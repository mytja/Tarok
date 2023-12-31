package httphandlers

import (
	"encoding/json"
	"github.com/mytja/Tarok/backend/internal/events"
	"net/http"
)

type TournamentParticipation struct {
	Rating         int    `json:"rating"`
	Rated          bool   `json:"rated"`
	Delta          int    `json:"delta"`
	TournamentID   string `json:"tournament_id"`
	TournamentName string `json:"tournament_name"`
}

type UserJSON struct {
	UserId        string                    `json:"userId"`
	Name          string                    `json:"name"`
	Email         string                    `json:"email"`
	Handle        string                    `json:"handle"`
	PlayedGames   int                       `json:"playedGames"`
	Disabled      bool                      `json:"disabled"`
	EmailVerified bool                      `json:"emailVerified"`
	RegisteredOn  string                    `json:"registeredOn"`
	Role          string                    `json:"role"`
	Rating        int                       `json:"rating"`
	RatingDelta   []TournamentParticipation `json:"ratingDelta"`
}

func (s *httpImpl) GetUsers(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	if user.Role != "admin" {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	users, err := s.db.GetAllUsers()
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	usersJson := make([]UserJSON, 0)

	for _, v := range users {
		games, err := s.db.GetGamesByUserID(v.ID)
		if err != nil {
			continue
		}
		usersJson = append(usersJson, UserJSON{
			UserId:        v.ID,
			Name:          v.Name,
			Email:         v.Email,
			PlayedGames:   len(games),
			Disabled:      v.Disabled,
			EmailVerified: v.EmailConfirmed,
			RegisteredOn:  v.CreatedAt,
			Role:          v.Role,
			Rating:        v.Rating,
			Handle:        v.Handle,
		})
	}

	marshal, err := json.Marshal(usersJson)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
	w.Write(marshal)
}

func (s *httpImpl) DisableAccount(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	if user.Role != "admin" {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	u, err := s.db.GetUser(r.FormValue("userId"))
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	u.Disabled = !u.Disabled
	if u.Disabled {
		u.LoginToken = ""
		// nočemo ga slučajno kickati še preden je odjavljen tudi v podatkovni bazi
		defer events.Publish("kickPlayer", u.ID)
	}

	err = s.db.UpdateUser(u)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
}

func (s *httpImpl) ValidateEmail(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	if user.Role != "admin" {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	u, err := s.db.GetUser(r.FormValue("userId"))
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	u.EmailConfirmed = !u.EmailConfirmed

	err = s.db.UpdateUser(u)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
}

func (s *httpImpl) PromoteDemoteUser(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	if user.Role != "admin" {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	u, err := s.db.GetUser(r.FormValue("userId"))
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	if u.Role == "admin" {
		u.Role = "member"
	} else {
		u.Role = "admin"
	}

	err = s.db.UpdateUser(u)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
}
