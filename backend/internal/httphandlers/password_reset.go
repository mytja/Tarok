package httphandlers

import (
	"fmt"
	"github.com/mytja/Tarok/backend/internal/sql"
	mail "github.com/xhit/go-simple-mail/v2"
	"math/rand"
	"net/http"
	"strings"
	"time"
)

func (s *httpImpl) RequestPasswordReset(w http.ResponseWriter, r *http.Request) {
	email := r.FormValue("email")
	if email == "" {
		s.sugared.Errorw("empty fields", "email", email)
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	user, err := s.db.GetUserByEmail(email)
	if err != nil {
		s.sugared.Errorw("error while fetching from database", "err", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	if user.Disabled || !user.EmailConfirmed {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	chars := []rune("ABCDEFGHIJKLMNOPQRSTUVWXYZ" +
		"abcdefghijklmnopqrstuvwxyz" +
		"0123456789")
	length := 40
	var b strings.Builder
	for i := 0; i < length; i++ {
		b.WriteRune(chars[rand.Intn(len(chars))])
	}
	resetToken := b.String()

	n := time.Now()
	user.PasswordResetInitiatedOn = n.Format(time.RFC3339)
	user.PasswordResetToken = resetToken

	s.sugared.Debugw("requesting password reset", "email", email, "userId", user.ID)

	err = s.db.UpdateUser(user)
	if err != nil {
		s.sugared.Errorw("updating user in the database has failed", "err", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	go func() {
		smtp := mail.NewSMTPClient()
		smtp.Host = s.config.EmailServer
		smtp.Port = s.config.EmailPort
		smtp.Username = s.config.EmailAccount
		smtp.Password = s.config.EmailPassword
		smtp.Encryption = mail.EncryptionTLS

		smtpClient, err := smtp.Connect()
		if err != nil {
			s.sugared.Error(err)
		}

		// Create email
		msg := mail.NewMSG()
		msg.SetFrom("Palčka <registracija@palcka.si>")
		msg.AddTo(email)
		msg.SetSubject("Zahtevek za ponastavitev gesla na tarok strežniku palcka.si")

		emailConfirmationText := fmt.Sprintf(`
<html>
<head>
   <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
   <title>Tarok Palčka</title>
</head>
<body>
	<div style="margin-left:auto;margin-right:auto;">
		<h1>Zahtevek za ponastavitev gesla na tarok strežniku palcka.si</h1>
		Uradna instanca <b>palcka.si</b>
	</div>

	<p/>

	Spoštovani,

	<p/>

	nekdo je %s zahteval ponastavitev vašega gesla.
	Če tega dejanja niste izvršili vi, je priporočljivo, da si čim prej spremenite geslo,
	po potrebi pa lahko kontaktirate tudi razvijalca in glavnega administratorja sistema, ki lahko zaklene
	vaš račun in tako poskrbi, da se prepreči dostop do računa.

	<p/>

	Povezava za ponastavitev poteče čez 72 ur. <b>Ne delite te povezave z nikomer drugim, niti z razvijalcem.</b>

	<p/>

	Vaš račun lahko potrdite z obiskom strani <a href="https://palcka.si/password/reset?email=%s&resetCode=%s">https://palcka.si/password/reset?email=%s&resetCode=%s</a>. Pri tem se prepričajte, da vas pelje na uradno stran (na domeni palcka.si).

	<p/>

	Hvala za zaupanje

	<p/>

	Ekipa palcka.si

	<p/>
	<hr>
	<p/>
	
	Kontaktne možnosti:
	<li><a href="https://discord.gg/cTZMCktwcK">Discord strežnik Palčka</a>,</li>
	<li><a href="mailto:info@palcka.si">Kontaktna elektronska pošta</a>,</li>
	<li><a href="https://discord.com/users/761599472454205531">Direktni kontakt razvijalca na Discordu (@mytja)</a>.</li>
</body>
</html>
`, n.Format("02. 01. 2006 ob 15.04"), email, resetToken, email, resetToken)

		msg.SetBody(mail.TextHTML, emailConfirmationText)

		err = msg.Send(smtpClient)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
	}()

	w.WriteHeader(http.StatusCreated)
}

func (s *httpImpl) PasswordResetConfirm(w http.ResponseWriter, r *http.Request) {
	email := r.FormValue("email")
	resetCode := r.FormValue("resetCode")
	newPassword := r.FormValue("newPassword")
	if email == "" || resetCode == "" || newPassword == "" {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	user, err := s.db.GetUserByEmail(email)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		s.sugared.Debugw("could not fetch user by email", "email", email)
		return
	}

	passwordResetDate, err := time.Parse(time.RFC3339, user.PasswordResetInitiatedOn)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		s.sugared.Debugw("could not parse time", "email", email, "reset", user.PasswordResetInitiatedOn)
		return
	}

	if time.Now().Sub(passwordResetDate).Hours() >= 72 {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	if resetCode != user.PasswordResetToken {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	if user.PasswordResetToken == "" {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	password, err := sql.HashPassword(newPassword)
	if err != nil {
		s.sugared.Errorw("error while hashing new password", "user", user.ID, "err", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	user.Password = password
	user.LoginToken = ""
	user.PasswordResetToken = ""

	err = s.db.UpdateUser(user)
	if err != nil {
		s.sugared.Errorw("error while updating user", "user", user.ID, "err", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	go func() {
		smtp := mail.NewSMTPClient()
		smtp.Host = s.config.EmailServer
		smtp.Port = s.config.EmailPort
		smtp.Username = s.config.EmailAccount
		smtp.Password = s.config.EmailPassword
		smtp.Encryption = mail.EncryptionTLS

		smtpClient, err := smtp.Connect()
		if err != nil {
			s.sugared.Error(err)
		}

		// Create email
		msg := mail.NewMSG()
		msg.SetFrom("Palčka <registracija@palcka.si>")
		msg.AddTo(email)
		msg.SetSubject("Sprememba gesla na palcka.si")

		emailConfirmationText := fmt.Sprintf(`
<html>
<head>
   <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
   <title>Tarok Palčka</title>
</head>
<body>
	<div style="margin-left:auto;margin-right:auto;">
		<h1>Sprememba gesla na palcka.si</h1>
		Uradna instanca <b>palcka.si</b>
	</div>

	<p/>

	Spoštovani,

	<p/>

	nekdo je ravnokar (%s) uspešno izvršil ponastavitev vašega gesla.
	Če tega dejanja niste izvršili vi, si čim prej spremenite geslo vašega poštnega predala, kot tudi računa na Palčki.
	Nujno kontaktirajte razvijalca in vzdrževalca sistema na eni izmed spodaj naštetih metod (na Discordu dobite najhitrejši odgovor).

	<p/>

	Če ste to dejanje izvršili vi, lahko mirno ignorirate to elektronsko pošto.

	<p/>

	Hvala za zaupanje

	<p/>

	Ekipa palcka.si

	<p/>
	<hr>
	<p/>
	
	Kontaktne možnosti:
	<li><a href="https://discord.gg/cTZMCktwcK">Discord strežnik Palčka</a>,</li>
	<li><a href="mailto:info@palcka.si">Kontaktna elektronska pošta</a>,</li>
	<li><a href="https://discord.com/users/761599472454205531">Direktni kontakt razvijalca na Discordu (@mytja)</a>.</li>
</body>
</html>
`, time.Now().Format("02. 01. 2006 ob 15.04"))

		msg.SetBody(mail.TextHTML, emailConfirmationText)

		err = msg.Send(smtpClient)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
	}()

	w.WriteHeader(http.StatusOK)
}
