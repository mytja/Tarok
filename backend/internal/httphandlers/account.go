package httphandlers

import (
	sql2 "database/sql"
	"errors"
	"fmt"
	"github.com/h2non/bimg"
	"github.com/mytja/Tarok/backend/internal/helpers"
	"github.com/mytja/Tarok/backend/internal/sql"
	mail "github.com/xhit/go-simple-mail/v2"
	"goji.io/pat"
	"io"
	"net/http"
	"os"
	"strings"
	"time"
)

func (s *httpImpl) GetUserData(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	games, err := s.db.GetGamesByUserID(user.ID)

	tournamentParticipations, err := s.db.GetAllTournamentParticipationsForUser(user.ID)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	tp := []TournamentParticipation{{
		Rating:         1000,
		Rated:          false,
		Delta:          0,
		TournamentID:   "",
		TournamentName: "",
	}}

	for i, v := range tournamentParticipations {
		ratingDelta := v.RatingDelta
		if !v.Rated {
			ratingDelta = 0
		}
		tournament, err := s.db.GetTournament(v.TournamentID)
		if err != nil {
			s.sugared.Errorw("could not find tournament", "err", err)
			continue
		}
		// vedno imamo zagotovilo, da i == 0 obstaja
		tp = append(tp, TournamentParticipation{
			Rating:         tp[i].Rating + ratingDelta,
			Rated:          v.Rated,
			Delta:          ratingDelta,
			TournamentID:   v.TournamentID,
			TournamentName: tournament.Name,
		})
	}

	exists := true
	if _, err := os.Stat(fmt.Sprintf("profile_pictures/%s.webp", user.ID)); errors.Is(err, os.ErrNotExist) {
		exists = false
	}

	u := UserJSON{
		UserId:                  user.ID,
		Name:                    user.Name,
		Email:                   user.Email,
		PlayedGames:             len(games),
		RegisteredOn:            user.CreatedAt,
		Role:                    user.Role,
		Rating:                  user.Rating,
		Handle:                  user.Handle,
		RatingDelta:             tp,
		HasCustomProfilePicture: exists,
	}

	WriteJSON(w, u, http.StatusOK)
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

func (s *httpImpl) ChangeHandle(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	adminChanging := false

	if user.Role == "admin" && r.FormValue("userId") != "" {
		adminChanging = true
		user, err = s.db.GetUser(r.FormValue("userId"))
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
	}

	handle := r.FormValue("handle")
	if handle == "" {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	if !adminChanging {
		handle = strings.ToLower(handle)
		for i := 0; i < len(handle); i++ {
			c := rune(handle[i])
			if !helpers.Contains(AVAILABLE_HANDLE_CHARS, c) {
				w.WriteHeader(http.StatusBadRequest)
				return
			}
		}
	}

	var handleTaken = true
	_, err = s.db.GetUserByHandle(strings.ToLower(handle))
	if err != nil {
		if errors.Is(err, sql2.ErrNoRows) {
			handleTaken = false
		} else {
			s.sugared.Errorw("error while fetching from database", "err", err)
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
	}

	if handleTaken {
		w.WriteHeader(http.StatusConflict)
		return
	}

	user.Handle = handle

	err = s.db.UpdateUser(user)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
}

func (s *httpImpl) ChangeProfilePicture(w http.ResponseWriter, r *http.Request) {
	s.sugared.Debugw("accepting change profile picture request")

	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	err = r.ParseMultipartForm(10 << 20)
	if err != nil {
		s.sugared.Errorw("failed while uploading the profile picture - allocation failed", "err", err)
		return
	}

	file, _, err := r.FormFile("profile_picture")
	if err != nil {
		s.sugared.Errorw("failed while uploading the profile picture - bad request", "err", err)
		w.WriteHeader(http.StatusBadRequest)
		return
	}
	defer file.Close()

	byteContainer, err := io.ReadAll(file)
	if err != nil {
		s.sugared.Errorw("failed while uploading the profile picture - failure while parsing", "err", err)
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	image, err := bimg.NewImage(byteContainer).Convert(bimg.WEBP)
	if err != nil {
		s.sugared.Errorw("failed while uploading the profile picture - failure while converting to webp", "err", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	image, err = bimg.NewImage(byteContainer).ForceResize(512, 512)
	if err != nil {
		s.sugared.Errorw("failed while uploading the profile picture - failure while resizing", "err", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	err = os.WriteFile(fmt.Sprintf("profile_pictures/%s.webp", user.ID), image, 0666)
	if err != nil {
		s.sugared.Errorw("failed while uploading the profile picture - failure while saving the file", "err", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusOK)
}

func (s *httpImpl) RemoveProfilePicture(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	err = os.Remove(fmt.Sprintf("profile_pictures/%s.webp", user.ID))
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusOK)
}

func (s *httpImpl) GetProfilePicture(w http.ResponseWriter, r *http.Request) {
	open, err := os.Open(fmt.Sprintf("profile_pictures/%s.webp", pat.Param(r, "userId")))
	if err != nil {
		w.WriteHeader(http.StatusNotFound)
		return
	}
	read, err := io.ReadAll(open)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusOK)
	w.Write(read)
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
