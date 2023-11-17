package httphandlers

import (
	"encoding/json"
	"fmt"
	"github.com/mytja/Tarok/backend/internal/sql"
	mail "github.com/xhit/go-simple-mail/v2"
	"net/http"
	"time"
)

func (s *httpImpl) GetUserData(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	games, err := s.db.GetGamesByUserID(user.ID)

	u := UserJSON{
		UserId:       user.ID,
		Name:         user.Name,
		Email:        user.Email,
		PlayedGames:  len(games),
		RegisteredOn: user.CreatedAt,
		Role:         user.Role,
	}

	marshal, err := json.Marshal(u)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
	w.Write(marshal)
}

func (s *httpImpl) ChangeName(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	if user.Role == "admin" && r.FormValue("userId") != "" {
		user, err = s.db.GetUser(r.FormValue("userId"))
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
	}

	name := r.FormValue("name")
	if name == "" {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	user.Name = name

	err = s.db.UpdateUser(user)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
}

func (s *httpImpl) ChangePassword(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	oldPassword := r.FormValue("oldPassword")
	hashCorrect := sql.CheckHash(oldPassword, user.Password)
	if !hashCorrect {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	newPassword := r.FormValue("newPassword")
	if newPassword == "" {
		w.WriteHeader(http.StatusBadRequest)
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
		msg.AddTo(user.Email)
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

	nekdo je ravnokar (%s) uspešno spremenil vaše geslo.
	Če tega dejanja niste izvršili vi, si čim prej spremenite geslo vašega računa na Palčki.
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

func (s *httpImpl) Logout(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	user.LoginToken = ""

	err = s.db.UpdateUser(user)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
}
