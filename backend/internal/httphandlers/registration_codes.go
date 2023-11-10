package httphandlers

import (
	"encoding/json"
	"github.com/mytja/Tarok/backend/internal/sql"
	"net/http"
)

func (s *httpImpl) DeleteRegistrationCode(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	if user.Role != "admin" {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	err = s.db.DeleteCode(r.FormValue("code"))
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusCreated)
}

func (s *httpImpl) NewRegistrationCode(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	if user.Role != "admin" {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	err = s.db.InsertCode(sql.Code{Code: r.FormValue("code")})
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusCreated)
}

func (s *httpImpl) GetRegistrationCodes(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	if user.Role != "admin" {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	codes, err := s.db.GetCodes()
	if err != nil {
		s.sugared.Debugw("error while fetching codes", "err", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	marshal, err := json.Marshal(codes)
	if err != nil {
		s.sugared.Debugw("error while marshalling", "err", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
	w.Write(marshal)
}
