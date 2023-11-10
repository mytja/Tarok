package httphandlers

import (
	"encoding/json"
	"fmt"
	"github.com/mytja/Tarok/backend/internal/sql"
	mail "github.com/xhit/go-simple-mail/v2"
	"math/rand"
	"net/http"
	"strings"
	"time"
)

type TokenResponse struct {
	UserID string `json:"user_id"`
	Token  string `json:"token"`
	Role   string `json:"role"`
	Email  string `json:"email"`
	Name   string `json:"name"`
}

func (s *httpImpl) Registration(w http.ResponseWriter, r *http.Request) {
	email := r.FormValue("email")
	pass := r.FormValue("pass")
	name := r.FormValue("name")
	regCode := r.FormValue("regCode")
	if email == "" || pass == "" || name == "" {
		s.sugared.Errorw("empty fields", "email", email, "name", name)
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	// Check if user is already in DB
	var userCreated = true
	_, err := s.db.GetUserByEmail(email)
	if err != nil {
		if err.Error() == "sql: no rows in result set" {
			userCreated = false
		} else {
			s.sugared.Errorw("error while fetching from database", "err", err)
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
	}
	if userCreated {
		s.sugared.Errorw("user is already created")
		w.WriteHeader(http.StatusUnprocessableEntity)
		return
	}

	password, err := sql.HashPassword(pass)
	if err != nil {
		s.sugared.Errorw("password hashing error", "err", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	var role = "member"

	isAdmin := !s.db.CheckIfAdminIsCreated()
	if isAdmin {
		role = "admin"
	}

	if role != "admin" {
		_, err := s.db.GetRegistrationCode(regCode)
		if err != nil {
			w.WriteHeader(http.StatusForbidden)
			return
		}
	}

	s.sugared.Debugw("registering a new user", "regCode", regCode)

	chars := []rune("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
	length := 8
	var b strings.Builder
	for i := 0; i < length; i++ {
		b.WriteRune(chars[rand.Intn(len(chars))])
	}
	emailConfirmationPassword := b.String()

	n := time.Now()

	user := sql.User{
		Email:                    r.FormValue("email"),
		Password:                 password,
		Role:                     role,
		Name:                     name,
		EmailConfirmation:        emailConfirmationPassword,
		EmailConfirmed:           false,
		Disabled:                 true,
		PasswordResetToken:       "",
		PasswordResetInitiatedOn: n.Format(time.RFC3339),
	}

	err = s.db.InsertUser(user)
	if err != nil {
		s.sugared.Errorw("inserting user to the database has failed", "err", err)
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
		msg.SetSubject("Registracija na tarok strežniku palcka.si")

		emailConfirmationText := fmt.Sprintf(`
<html>
<head>
   <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
   <title>Tarok Palčka</title>
</head>
<body>
	<div style="margin-left:auto;margin-right:auto;">
		<h1>Registracija na Tarok strežniku Palčka</h1>
		Uradna instanca <b>palcka.si</b>
		<p/>
		Zahvaljujemo se vam za registracijo na tarok strežniku Palčka.
		Vaša registracijska koda je: <p/>
		<span style="font-size: 30px;">%s</span>
	</div>

	<p/>

	Vaš račun lahko potrdite z obiskom strani <a href="https://palcka.si/email/confirm?email=%s&regCode=%s">https://palcka.si/email/confirm?email=%s&regCode=%s</a>. Pri tem se prepričajte, da vas pelje na uradno stran (na domeni palcka.si).

	<p/>

	Še enkrat hvala za registracijo in obilo užitka ob igri taroka vam želi

	<p/>

	Ekipa palcka.si
</body>
</html>
`, emailConfirmationPassword, email, emailConfirmationPassword, email, emailConfirmationPassword)

		msg.SetBody(mail.TextHTML, emailConfirmationText)

		err = msg.Send(smtpClient)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
	}()

	w.WriteHeader(http.StatusCreated)
}

func (s *httpImpl) Login(w http.ResponseWriter, r *http.Request) {
	email := r.FormValue("email")
	pass := r.FormValue("pass")
	user, err := s.db.GetUserByEmail(email)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	hashCorrect := sql.CheckHash(pass, user.Password)
	if !hashCorrect {
		// nočmo razkrit, če uporabnik že obstaja tho
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	if user.Disabled || !user.EmailConfirmed {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	var token string
	if user.LoginToken == "" {
		token, err = s.db.GetRandomToken(user)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
	} else {
		token = user.LoginToken
	}

	response := TokenResponse{Token: token, Role: user.Role, UserID: user.ID, Email: user.Email, Name: user.Name}
	marshal, err := json.Marshal(response)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusOK)
	w.Write(marshal)
}

func (s *httpImpl) ConfirmEmail(w http.ResponseWriter, r *http.Request) {
	email := r.FormValue("email")
	regCode := r.FormValue("regCode")
	user, err := s.db.GetUserByEmail(email)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	if user.EmailConfirmed {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	if regCode != user.EmailConfirmation {
		w.WriteHeader(http.StatusForbidden)
		return
	}
	user.EmailConfirmed = true
	user.EmailConfirmation = ""
	w.WriteHeader(http.StatusOK)
}
