package httphandlers

import (
	"encoding/json"
	"github.com/mytja/Tarok/backend/internal/sql"
	"net/http"
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
