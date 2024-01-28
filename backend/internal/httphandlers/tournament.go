package httphandlers

import (
	"encoding/json"
	"github.com/mytja/Tarok/backend/internal/helpers"
	"github.com/mytja/Tarok/backend/internal/sql"
	tournament2 "github.com/mytja/Tarok/backend/internal/tournament"
	"goji.io/pat"
	"net/http"
	"sort"
	"strconv"
	"time"
)

type Tournament struct {
	ID         string     `json:"id"`
	CreatedBy  []string   `json:"created_by"`
	Name       string     `json:"name"`
	StartTime  int        `json:"start_time"`
	Division   int        `json:"division"`
	Rated      bool       `json:"rated"`
	Private    bool       `json:"private"`
	Testers    []UserJSON `json:"testers"`
	Registered bool       `json:"registered"`
	CreatedAt  string     `json:"created_at"`
	UpdatedAt  string     `json:"updated_at"`
}

func (s *httpImpl) GetAllTournaments(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	tournaments, err := s.db.GetAllPastTournaments()
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	if user.Role == "admin" {
		tournaments, err = s.db.GetAllTournaments()
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
	}

	t := make([]Tournament, 0)
	for _, v := range tournaments {
		if v.Private && user.Role != "admin" {
			continue
		}

		var authors []string
		err = json.Unmarshal([]byte(v.CreatedBy), &authors)
		if err != nil {
			s.sugared.Errorw("error while parsing created by", "err", err)
			continue
		}
		var tes []string
		err = json.Unmarshal([]byte(v.Testers), &tes)
		if err != nil {
			s.sugared.Errorw("error while parsing testers", "err", err)
			continue
		}

		testers := make([]UserJSON, 0)
		if user.Role == "admin" {
			for _, te := range tes {
				u, err := s.db.GetUser(te)
				if err != nil {
					s.sugared.Errorw("error while fetching user", "err", err)
					continue
				}
				testers = append(testers, UserJSON{
					UserId: te,
					Name:   u.Name,
					Email:  u.Email,
					Handle: u.Handle,
					Role:   u.Role,
					Rating: u.Rating,
				})
			}
		}

		t = append(t, Tournament{
			ID:        v.ID,
			CreatedBy: authors,
			Name:      v.Name,
			StartTime: v.StartTime,
			Division:  v.Division,
			Rated:     v.Rated,
			Testers:   testers,
			CreatedAt: v.CreatedAt,
			UpdatedAt: v.UpdatedAt,
			Private:   v.Private,
		})
	}

	WriteJSON(w, t, http.StatusOK)
}

func (s *httpImpl) GetTournamentStatistics(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	tournament, err := s.db.GetTournament(pat.Param(r, "tournamentId"))
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	if tournament.Private && user.Role != "admin" {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	participants, err := s.db.GetAllTournamentParticipants(tournament.ID)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	sort.Slice(participants, func(i, j int) bool {
		return participants[i].RatingPoints > participants[j].RatingPoints
	})

	t := make([]TournamentParticipation, 0)
	for _, v := range participants {
		if !v.Rated {
			continue
		}
		usr, err := s.db.GetUser(v.UserID)
		if err != nil {
			continue
		}
		t = append(t, TournamentParticipation{
			Points:     v.RatingPoints,
			Rated:      v.Rated,
			Delta:      v.RatingDelta,
			UserName:   usr.Name,
			UserHandle: usr.Handle,
			UserID:     v.UserID,
			Rating:     usr.Rating,
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
		err = json.Unmarshal([]byte(v.CreatedBy), &authors)
		if err != nil {
			continue
		}
		_, err = s.db.GetTournamentParticipantByTournamentUser(v.ID, user.ID)
		registered := err == nil
		var testers []string
		err = json.Unmarshal([]byte(v.Testers), &testers)
		if err != nil {
			continue
		}
		if v.Private && !(helpers.Contains(testers, user.ID) || user.Role == "admin") {
			continue
		}
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

	if startTime < int(time.Now().Unix()*1000) {
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
		Testers:   "[]",
		Rated:     true,
		Private:   true,
	}

	err = s.db.InsertTournament(tournament)
	if err != nil {
		s.sugared.Errorw("error while inserting tournament", "err", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	// ogabno
	// TODO: znebi se te katastrofe
	t, err := s.db.GetTournamentByArgs(startTime, division, name)
	if err != nil {
		s.sugared.Errorw("error while fetching tournament. could not start tournament organizer", "err", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	to := tournament2.NewTournament(t.ID, s.sugared, s.db, s.wsServer, startTime, false, "")
	go to.RunOrganizer()

	w.WriteHeader(http.StatusOK)
}

func (s *httpImpl) RecalculateRating(tournamentId string) {
	ratingCalc := make([]tournament2.UserRating, 0)

	participants, err := s.db.GetAllTournamentParticipants(tournamentId)
	if err != nil {
		return
	}

	for _, v := range participants {
		if !v.Rated {
			continue
		}

		user, err := s.db.GetUser(v.UserID)
		if err != nil {
			continue
		}

		user.Rating -= v.RatingDelta

		r := tournament2.NewUserRating(user.ID, 0, user.Rating)
		r.Points = v.RatingPoints

		ratingCalc = append(ratingCalc, r)
	}

	sort.Slice(ratingCalc, func(i, j int) bool {
		return ratingCalc[i].Points > ratingCalc[j].Points
	})

	if len(ratingCalc) == 0 {
		return
	}

	ratingCalc[0].Rank = 1

	for i := 1; i < len(ratingCalc); i++ {
		prev := ratingCalc[i-1]
		if prev.Points == ratingCalc[i].Points {
			ratingCalc[i].Rank = prev.Rank
		} else {
			ratingCalc[i].Rank = float64(i + 1)
		}
	}

	s.sugared.Debugw("tournament results", "calc", ratingCalc)

	tournament2.CalculateRating(&ratingCalc)

	s.sugared.Debugw("calculated tournament results", "calc", ratingCalc)

	for _, v := range ratingCalc {
		participant, err := s.db.GetTournamentParticipantByTournamentUser(tournamentId, v.UserID)
		if err != nil {
			s.sugared.Errorw("error while fetching tournament participant", "tournamentId", tournamentId, "userId", v.UserID, "newRating", v.NewRating)
			continue
		}
		participant.RatingDelta = v.NewRating - v.OldRating
		err = s.db.UpdateTournamentParticipant(participant)
		if err != nil {
			s.sugared.Errorw("error while updating tournament participant", "tournamentId", tournamentId, "userId", v.UserID, "newRating", v.NewRating)
			continue
		}
		if !participant.Rated {
			continue
		}
		user, err := s.db.GetUser(v.UserID)
		if err != nil {
			s.sugared.Errorw("error while fetching user", "tournamentId", tournamentId, "userId", v.UserID, "newRating", v.NewRating)
			continue
		}
		user.Rating = v.NewRating
		err = s.db.UpdateUser(user)
		if err != nil {
			s.sugared.Errorw("error while updating user", "tournamentId", tournamentId, "userId", v.UserID, "newRating", v.NewRating)
			continue
		}
	}
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

	if startTime < int(time.Now().Unix()*1000) {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	if startTime != tournament.StartTime {
		to := tournament2.NewTournament(tournamentId, s.sugared, s.db, s.wsServer, startTime, false, "")
		defer func() { go to.RunOrganizer() }()
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

	if rated != tournament.Rated {
		if rated {
			s.RecalculateRating(tournamentId)
		} else {
			participants, err := s.db.GetAllTournamentParticipants(tournamentId)
			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				return
			}
			for _, v := range participants {
				usr, err := s.db.GetUser(v.UserID)
				if err != nil {
					continue
				}
				usr.Rating -= v.RatingDelta
				err = s.db.UpdateUser(usr)
				if err != nil {
					continue
				}
				v.RatingDelta = 0
				err = s.db.UpdateTournamentParticipant(v)
				if err != nil {
					continue
				}
			}
		}
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

func (s *httpImpl) RecalculateTournamentRating(w http.ResponseWriter, r *http.Request) {
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
	s.RecalculateRating(tournamentId)
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

func (s *httpImpl) AddTournamentTester(w http.ResponseWriter, r *http.Request) {
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

	tournamentTesterHandle := r.FormValue("handle")
	u, err := s.db.GetUserByHandle(tournamentTesterHandle)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	var testers []string
	err = json.Unmarshal([]byte(tournament.Testers), &testers)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	if helpers.Contains(testers, u.ID) {
		w.WriteHeader(http.StatusConflict)
		return
	}

	testers = append(testers, u.ID)

	marshal, err := json.Marshal(testers)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	tournament.Testers = string(marshal)

	err = s.db.UpdateTournament(tournament)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
}

func (s *httpImpl) RemoveTournamentTester(w http.ResponseWriter, r *http.Request) {
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

	tournamentTesterId := r.FormValue("testerId")

	var testers []string
	err = json.Unmarshal([]byte(tournament.Testers), &testers)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	for i, v := range testers {
		if v != tournamentTesterId {
			continue
		}
		testers = helpers.RemoveOrdered(testers, i)
		break
	}

	marshal, err := json.Marshal(testers)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	tournament.Testers = string(marshal)

	err = s.db.UpdateTournament(tournament)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
}
