package httphandlers

import (
	"database/sql"
	"encoding/json"
	"errors"
	"github.com/mytja/Tarok/backend/internal/helpers"
	sql2 "github.com/mytja/Tarok/backend/internal/sql"
	tournament2 "github.com/mytja/Tarok/backend/internal/tournament"
	"goji.io/pat"
	"net/http"
	"time"
)

type Participant struct {
	ID            string `json:"id"`
	ParticipantID string `json:"participant_id"`
	TournamentID  string `json:"tournament_id"`
	Email         string `json:"email"`
	Name          string `json:"name"`
	Rated         bool   `json:"rated"`
	Delta         int    `json:"delta"`
	Points        int    `json:"points"`
	CreatedAt     string `json:"created_at"`
}

func (s *httpImpl) GetAllParticipants(w http.ResponseWriter, r *http.Request) {
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
	participants, err := s.db.GetAllTournamentParticipants(tournamentId)
	if err != nil {
		return
	}

	part := make([]Participant, 0)

	for _, p := range participants {
		u, err := s.db.GetUser(p.UserID)
		if err != nil {
			s.sugared.Errorw("could not fetch user", "err", err, "userId", p.UserID)
			continue
		}
		participant := Participant{
			ID:            p.ID,
			ParticipantID: p.UserID,
			Email:         u.Email,
			Name:          u.Name,
			Rated:         p.Rated,
			Delta:         p.RatingDelta,
			Points:        p.RatingPoints,
			CreatedAt:     p.CreatedAt,
		}
		part = append(part, participant)
	}

	WriteJSON(w, part, http.StatusOK)
}

func (s *httpImpl) RemoveParticipation(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	participantId := user.ID
	if user.Role == "admin" {
		pid := r.FormValue("participantId")
		if pid != "" {
			participantId = pid
		}
	}

	tournamentId := pat.Param(r, "tournamentId")

	tournament, err := s.db.GetTournament(tournamentId)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	// 5 minut pred začetkom se zaprejo odjave
	if tournament.StartTime < int(time.Now().Unix()*1000)+300_000 {
		s.sugared.Errorw("the registration is closed", "err", err, "tournamentId", tournamentId)
		w.WriteHeader(http.StatusForbidden)
		return
	}

	tournamentUser, err := s.db.GetTournamentParticipantByTournamentUser(tournamentId, participantId)
	if err != nil {
		w.WriteHeader(http.StatusNotFound)
		return
	}

	err = s.db.DeleteTournamentParticipant(tournamentUser.ID)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	WriteJSON(w, map[string]string{}, http.StatusOK)
}

func (s *httpImpl) AddParticipation(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	tournamentId := pat.Param(r, "tournamentId")

	tournament, err := s.db.GetTournament(tournamentId)
	if err != nil {
		s.sugared.Errorw("failed while fetching tournament", "err", err, "tournamentId", tournamentId)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	var testers []string
	err = json.Unmarshal([]byte(tournament.Testers), &testers)
	if err != nil {
		s.sugared.Errorw("failed while unmarshalling testers", "err", err, "tournamentId", tournamentId)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	isTesterOrAdmin := helpers.Contains(testers, user.ID) || user.Role == "admin"

	if tournament.Private && !isTesterOrAdmin {
		s.sugared.Errorw("tournament is private", "err", err, "tournamentId", tournamentId)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	// 5 minut pred začetkom se zaprejo prijave
	if tournament.StartTime < int(time.Now().Unix()*1000)+300_000 {
		s.sugared.Errorw("the registration is closed", "err", err, "tournamentId", tournamentId)
		w.WriteHeader(http.StatusForbidden)
		return
	}

	_, err = s.db.GetTournamentParticipantByTournamentUser(tournamentId, user.ID)
	if err == nil {
		s.sugared.Errorw("participant is already registered", "err", err, "tournamentId", tournamentId)
		w.WriteHeader(http.StatusConflict)
		return
	}
	if !errors.Is(err, sql.ErrNoRows) {
		s.sugared.Errorw("unknown error", "err", err, "tournamentId", tournamentId)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	tp := sql2.TournamentParticipant{
		TournamentID: tournamentId,
		UserID:       user.ID,
		Rated:        tournament.Rated && !isTesterOrAdmin,
		RatingDelta:  0,
		RatingPoints: 0,
	}

	err = s.db.InsertTournamentParticipant(tp)
	if err != nil {
		s.sugared.Errorw("failed while inserting tournament participant", "err", err, "tournamentId", tournamentId)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	WriteJSON(w, map[string]string{}, http.StatusCreated)
}

func (s *httpImpl) GetParticipations(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	participantId := user.ID
	if user.Role == "admin" {
		pid := r.FormValue("participantId")
		if pid != "" {
			participantId = pid
		}
	}

	participations, err := s.db.GetAllTournamentParticipationsForUser(participantId)
	if err != nil {
		s.sugared.Errorw("could not fetch participations", "err", err, "userId", participantId)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	part := make([]Participant, 0)

	for _, p := range participations {
		participant := Participant{
			ID:            p.ID,
			ParticipantID: p.UserID,
			TournamentID:  p.TournamentID,
			Rated:         p.Rated,
			Delta:         p.RatingDelta,
			Points:        p.RatingPoints,
			CreatedAt:     p.CreatedAt,
		}
		part = append(part, participant)
	}

	WriteJSON(w, part, http.StatusOK)
}

func (s *httpImpl) ToggleRatedUnratedParticipant(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	if user.Role != "admin" {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	tid := pat.Param(r, "participationId")
	participant, err := s.db.GetTournamentParticipant(tid)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	participant.Rated = !participant.Rated

	usr, err := s.db.GetUser(participant.UserID)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	usr.Rating -= participant.RatingDelta
	err = s.db.UpdateUser(usr)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	participant.RatingDelta = 0

	err = s.db.UpdateTournamentParticipant(participant)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	WriteJSON(w, map[string]string{}, http.StatusOK)
}

func (s *httpImpl) TestTournament(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	tournamentId := pat.Param(r, "tournamentId")

	tournament, err := s.db.GetTournament(tournamentId)
	if err != nil {
		s.sugared.Errorw("failed while fetching tournament", "err", err, "tournamentId", tournamentId)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	var testers []string
	err = json.Unmarshal([]byte(tournament.Testers), &testers)
	if err != nil {
		s.sugared.Errorw("failed while unmarshalling testers", "err", err, "tournamentId", tournamentId)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	if !(helpers.Contains(testers, user.ID) || user.Role == "admin") {
		s.sugared.Warnw("unauthorized access", "err", err, "tournamentId", tournamentId, "userId", user.ID)
		w.WriteHeader(http.StatusForbidden)
		return
	}

	tournamentUser, err := s.db.GetTournamentParticipantByTournamentUser(tournamentId, user.ID)
	if err != nil {
		if !errors.Is(err, sql.ErrNoRows) {
			s.sugared.Errorw("other error while fetching tournament participant", "tournamentId", tournamentId, "userId", user.ID)
			return
		}
		tournamentUser = sql2.TournamentParticipant{
			TournamentID: tournamentId,
			UserID:       user.ID,
			Rated:        false,
			RatingDelta:  0,
			RatingPoints: 0,
		}
		err = s.db.InsertTournamentParticipant(tournamentUser)
		if err != nil {
			s.sugared.Errorw("other error while inserting tournament participant", "tournamentId", tournamentId, "userId", user.ID)
			return
		}
	}

	t := tournament2.NewTournament(tournamentId, s.sugared, s.db, s.wsServer, int((time.Now().Unix()+60)*1000), true, user.ID)
	go t.RunOrganizer()

	WriteJSON(w, map[string]string{}, http.StatusOK)
}
