package httphandlers

import (
	"encoding/json"
	"github.com/mytja/Tarok/backend/internal/sql"
	"goji.io/pat"
	"net/http"
	"strconv"
	"time"
)

type Tournament struct {
	ID         string   `json:"id"`
	CreatedBy  []string `json:"created_by"`
	Name       string   `json:"name"`
	StartTime  int      `json:"start_time"`
	Division   int      `json:"division"`
	Rated      bool     `json:"rated"`
	Private    bool     `json:"private"`
	Registered bool     `json:"registered"`
	CreatedAt  string   `json:"created_at"`
	UpdatedAt  string   `json:"updated_at"`
}

func (s *httpImpl) GetAllTournaments(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	if user.Role != "admin" {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	tournaments, err := s.db.GetAllTournaments()
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	t := make([]Tournament, 0)
	for _, v := range tournaments {
		var authors []string
		err := json.Unmarshal([]byte(v.CreatedBy), &authors)
		if err != nil {
			continue
		}
		t = append(t, Tournament{
			ID:        v.ID,
			CreatedBy: authors,
			Name:      v.Name,
			StartTime: v.StartTime,
			Division:  v.Division,
			Rated:     v.Rated,
			CreatedAt: v.CreatedAt,
			UpdatedAt: v.UpdatedAt,
			Private:   v.Private,
		})
	}

	WriteJSON(w, t, http.StatusOK)
}

func (s *httpImpl) GetUpcomingTournaments(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	tournaments, err := s.db.GetAllNotStartedTournaments()
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	t := make([]Tournament, 0)
	for _, v := range tournaments {
		var authors []string
		err := json.Unmarshal([]byte(v.CreatedBy), &authors)
		if err != nil {
			continue
		}
		_, err = s.db.GetTournamentParticipantByTournamentUser(v.ID, user.ID)
		registered := err == nil
		t = append(t, Tournament{
			ID:         v.ID,
			CreatedBy:  authors,
			Name:       v.Name,
			StartTime:  v.StartTime,
			Division:   v.Division,
			Rated:      v.Rated,
			Registered: registered,
			CreatedAt:  v.CreatedAt,
			UpdatedAt:  v.UpdatedAt,
			Private:    v.Private,
		})
	}

	WriteJSON(w, t, http.StatusOK)
}

func (s *httpImpl) NewTournament(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	if user.Role != "admin" {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	//tournamentId := pat.Param(r, "tournamentId")

	createdBy, err := json.Marshal([]string{user.Name})
	if err != nil {
		s.sugared.Errorw("error while marshaling createdBy", "err", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	name := r.FormValue("name")
	if name == "" {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	startTime, err := strconv.Atoi(r.FormValue("start_time"))
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	if startTime < int(time.Now().Unix()) {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	division, err := strconv.Atoi(r.FormValue("division"))
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	if division < 1 || division > 4 {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	tournament := sql.Tournament{
		CreatedBy: string(createdBy),
		Name:      name,
		StartTime: startTime,
		Division:  division,
		Rated:     true,
		Private:   true,
	}

	err = s.db.InsertTournament(tournament)
	if err != nil {
		s.sugared.Errorw("error while inserting tournament", "err", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
}

func (s *httpImpl) UpdateTournament(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	if user.Role != "admin" {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	tournamentId := pat.Param(r, "tournamentId")
	tournament, err := s.db.GetTournament(tournamentId)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	var createdBy []string
	err = json.Unmarshal([]byte(r.FormValue("created_by")), &createdBy)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	marshal, err := json.Marshal(createdBy)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	tournament.CreatedBy = string(marshal)

	name := r.FormValue("name")
	if name != "" {
		tournament.Name = name
	}

	startTime, err := strconv.Atoi(r.FormValue("start_time"))
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	if startTime < int(time.Now().Unix()) {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	tournament.StartTime = startTime

	division, err := strconv.Atoi(r.FormValue("division"))
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	if division < 1 || division > 4 {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	tournament.Division = division

	rated, err := strconv.ParseBool(r.FormValue("rated"))
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	tournament.Rated = rated

	private, err := strconv.ParseBool(r.FormValue("private"))
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	tournament.Private = private

	err = s.db.UpdateTournament(tournament)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
}

func (s *httpImpl) DeleteTournament(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	if user.Role != "admin" {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	tournamentId := pat.Param(r, "tournamentId")
	_, err = s.db.GetTournament(tournamentId)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	err = s.db.DeleteTournament(tournamentId)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
}
