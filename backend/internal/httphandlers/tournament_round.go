package httphandlers

import (
	"encoding/json"
	"github.com/mytja/Tarok/backend/internal/helpers"
	"github.com/mytja/Tarok/backend/internal/shuffler"
	"github.com/mytja/Tarok/backend/internal/sql"
	"goji.io/pat"
	"net/http"
	"strconv"
)

type TournamentRound struct {
	RoundID            string     `json:"round_id"`
	TournamentID       string     `json:"tournament_id"`
	ConsecutiveRoundID int        `json:"consecutive_round_id"`
	Cards              [][]string `json:"cards"`
	Talon              []string   `json:"talon"`
	Time               int        `json:"time"`
	CreatedAt          string     `json:"created_at"`
	UpdatedAt          string     `json:"updated_at"`
}

func ReshuffleTournamentRoundCards(tournamentRound *sql.TournamentRound, w *http.ResponseWriter, exclude *[]int, excludeCards *[]string) {
	userCards, talon := shuffler.ShuffleCards(4, exclude, excludeCards)

	talonMarshal, err := json.Marshal(talon)
	if err != nil {
		(*w).WriteHeader(http.StatusInternalServerError)
		return
	}
	tournamentRound.Talon = string(talonMarshal)

	if len(userCards[0]) != 0 {
		userMarshal1, err := json.Marshal(userCards[0])
		if err != nil {
			(*w).WriteHeader(http.StatusInternalServerError)
			return
		}
		tournamentRound.Cards1 = string(userMarshal1)
	}

	if len(userCards[1]) != 0 {
		userMarshal2, err := json.Marshal(userCards[1])
		if err != nil {
			(*w).WriteHeader(http.StatusInternalServerError)
			return
		}
		tournamentRound.Cards2 = string(userMarshal2)
	}

	if len(userCards[2]) != 0 {
		userMarshal3, err := json.Marshal(userCards[2])
		if err != nil {
			(*w).WriteHeader(http.StatusInternalServerError)
			return
		}
		tournamentRound.Cards3 = string(userMarshal3)
	}

	if len(userCards[3]) != 0 {
		userMarshal4, err := json.Marshal(userCards[3])
		if err != nil {
			(*w).WriteHeader(http.StatusInternalServerError)
			return
		}
		tournamentRound.Cards4 = string(userMarshal4)
	}
}

func (s *httpImpl) NewTournamentRound(w http.ResponseWriter, r *http.Request) {
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
		s.sugared.Errorw("error while fetching tournament", "err", err, "tournamentId", tournamentId)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	rounds, err := s.db.GetAllTournamentRounds(tournamentId)
	if err != nil {
		s.sugared.Errorw("error while fetching tournament rounds", "err", err, "tournamentId", tournamentId)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	roundTime, err := strconv.Atoi(r.FormValue("roundTime"))
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	tournamentRound := sql.TournamentRound{
		TournamentID: tournamentId,
		RoundNumber:  len(rounds) + 1,
		Time:         roundTime,
	}

	ReshuffleTournamentRoundCards(&tournamentRound, &w, &[]int{}, &[]string{})

	err = s.db.InsertTournamentRound(tournamentRound)
	if err != nil {
		s.sugared.Errorw("error while inserting tournament round", "err", err, "tournamentId", tournamentId)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusCreated)
}

func (s *httpImpl) ClearTournamentRoundCards(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	if user.Role != "admin" {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	tournamentRoundId := pat.Param(r, "tournamentRoundId")
	round, err := s.db.GetTournamentRound(tournamentRoundId)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	round.Cards1 = "[]"
	round.Cards2 = "[]"
	round.Cards3 = "[]"
	round.Cards4 = "[]"
	round.Talon = "[]"

	err = s.db.UpdateTournamentRound(round)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
}

func (s *httpImpl) ReshuffleRoundCards(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	if user.Role != "admin" {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	tournamentRoundId := pat.Param(r, "tournamentRoundId")
	round, err := s.db.GetTournamentRound(tournamentRoundId)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	exclude := make([]int, 0)
	excludeCards := make([]string, 0)
	if round.Cards1 != "[]" {
		exclude = append(exclude, 0)
		var c []string
		err = json.Unmarshal([]byte(round.Cards1), &c)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
		excludeCards = append(excludeCards, c...)
	}
	if round.Cards2 != "[]" {
		exclude = append(exclude, 1)
		var c []string
		err = json.Unmarshal([]byte(round.Cards2), &c)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
		excludeCards = append(excludeCards, c...)
	}
	if round.Cards3 != "[]" {
		exclude = append(exclude, 2)
		var c []string
		err = json.Unmarshal([]byte(round.Cards3), &c)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
		excludeCards = append(excludeCards, c...)
	}
	if round.Cards4 != "[]" {
		exclude = append(exclude, 3)
		var c []string
		err = json.Unmarshal([]byte(round.Cards4), &c)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
		excludeCards = append(excludeCards, c...)
	}

	ReshuffleTournamentRoundCards(&round, &w, &exclude, &excludeCards)

	err = s.db.UpdateTournamentRound(round)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
}

func (s *httpImpl) DeleteTournamentRound(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	if user.Role != "admin" {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	tournamentRoundId := pat.Param(r, "tournamentRoundId")
	round, err := s.db.GetTournamentRound(tournamentRoundId)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	rounds, err := s.db.GetAllTournamentRounds(round.TournamentID)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	err = s.db.DeleteTournamentRound(round.ID)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	for i := round.RoundNumber; i < len(rounds); i++ {
		rounds[i].RoundNumber--
		err = s.db.UpdateTournamentRound(rounds[i])
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
	}

	w.WriteHeader(http.StatusOK)
}

func (s *httpImpl) GetTournamentRounds(w http.ResponseWriter, r *http.Request) {
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
	rounds, err := s.db.GetAllTournamentRounds(tournamentId)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	rs := make([]TournamentRound, 0)
	for _, v := range rounds {
		var c1 []string
		json.Unmarshal([]byte(v.Cards1), &c1)
		var c2 []string
		json.Unmarshal([]byte(v.Cards2), &c2)
		var c3 []string
		json.Unmarshal([]byte(v.Cards3), &c3)
		var c4 []string
		json.Unmarshal([]byte(v.Cards4), &c4)
		var talon []string
		json.Unmarshal([]byte(v.Talon), &talon)

		rs = append(rs, TournamentRound{
			RoundID:            v.ID,
			TournamentID:       v.TournamentID,
			ConsecutiveRoundID: v.RoundNumber,
			Cards:              [][]string{c1, c2, c3, c4},
			Talon:              talon,
			Time:               v.Time,
			CreatedAt:          v.CreatedAt,
			UpdatedAt:          v.UpdatedAt,
		})
	}

	WriteJSON(w, rs, http.StatusOK)
}

func (s *httpImpl) AddCardTournamentRound(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	if user.Role != "admin" {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	tournamentRoundId := pat.Param(r, "tournamentRoundId")
	card := r.FormValue("card")
	deckId, err := strconv.Atoi(r.FormValue("deckId"))
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	round, err := s.db.GetTournamentRound(tournamentRoundId)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	var c1 []string
	err = json.Unmarshal([]byte(round.Cards1), &c1)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	var c2 []string
	err = json.Unmarshal([]byte(round.Cards2), &c2)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	var c3 []string
	err = json.Unmarshal([]byte(round.Cards3), &c3)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	var c4 []string
	err = json.Unmarshal([]byte(round.Cards4), &c4)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	var talon []string
	err = json.Unmarshal([]byte(round.Talon), &talon)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	cards := make([]string, 0)
	cards = append(cards, c1...)
	cards = append(cards, c2...)
	cards = append(cards, c3...)
	cards = append(cards, c4...)
	cards = append(cards, talon...)

	if helpers.Contains(cards, card) {
		s.sugared.Errorw("cards already contain the card", "card", card, "cards", cards)
		w.WriteHeader(http.StatusConflict)
		return
	}

	if deckId == 1 {
		if len(c1) >= 48/4 {
			s.sugared.Errorw("deck 1 is already full", "card", card, "cards", cards)
			w.WriteHeader(http.StatusConflict)
			return
		}
		c1 = append(c1, card)
		marshal, err := json.Marshal(c1)
		if err != nil {
			return
		}
		round.Cards1 = string(marshal)
	} else if deckId == 2 {
		if len(c2) >= 48/4 {
			s.sugared.Errorw("deck 2 is already full", "card", card, "cards", cards)
			w.WriteHeader(http.StatusConflict)
			return
		}
		c2 = append(c2, card)
		marshal, err := json.Marshal(c2)
		if err != nil {
			return
		}
		round.Cards2 = string(marshal)
	} else if deckId == 3 {
		if len(c3) >= 48/4 {
			s.sugared.Errorw("deck 3 is already full", "card", card, "cards", cards)
			w.WriteHeader(http.StatusConflict)
			return
		}
		c3 = append(c3, card)
		marshal, err := json.Marshal(c3)
		if err != nil {
			return
		}
		round.Cards3 = string(marshal)
	} else if deckId == 4 {
		if len(c4) >= 48/4 {
			s.sugared.Errorw("deck 4 is already full", "card", card, "cards", cards)
			w.WriteHeader(http.StatusConflict)
			return
		}
		c4 = append(c4, card)
		marshal, err := json.Marshal(c4)
		if err != nil {
			return
		}
		round.Cards4 = string(marshal)
	} else if deckId == -1 {
		if len(talon) >= 6 {
			s.sugared.Errorw("talon", "card", card, "cards", cards)
			w.WriteHeader(http.StatusConflict)
			return
		}
		talon = append(talon, card)
		marshal, err := json.Marshal(talon)
		if err != nil {
			return
		}
		round.Talon = string(marshal)
	}

	err = s.db.UpdateTournamentRound(round)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
}

func (s *httpImpl) RemoveCardTournamentRound(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	if user.Role != "admin" {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	tournamentRoundId := pat.Param(r, "tournamentRoundId")
	card := r.FormValue("card")
	deckId, err := strconv.Atoi(r.FormValue("deckId"))
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	round, err := s.db.GetTournamentRound(tournamentRoundId)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	var c1 []string
	err = json.Unmarshal([]byte(round.Cards1), &c1)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	var c2 []string
	err = json.Unmarshal([]byte(round.Cards2), &c2)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	var c3 []string
	err = json.Unmarshal([]byte(round.Cards3), &c3)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	var c4 []string
	err = json.Unmarshal([]byte(round.Cards4), &c4)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	var talon []string
	err = json.Unmarshal([]byte(round.Talon), &talon)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	cards := make([]string, 0)
	cards = append(cards, c1...)
	cards = append(cards, c2...)
	cards = append(cards, c3...)
	cards = append(cards, c4...)
	cards = append(cards, talon...)

	if !helpers.Contains(cards, card) {
		w.WriteHeader(http.StatusConflict)
		return
	}

	if deckId == 1 {
		for i, v := range c1 {
			if v != card {
				continue
			}
			c1 = helpers.RemoveOrdered(c1, i)
			break
		}
		marshal, err := json.Marshal(c1)
		if err != nil {
			return
		}
		round.Cards1 = string(marshal)
	} else if deckId == 2 {
		for i, v := range c2 {
			if v != card {
				continue
			}
			c2 = helpers.RemoveOrdered(c2, i)
			break
		}
		marshal, err := json.Marshal(c2)
		if err != nil {
			return
		}
		round.Cards2 = string(marshal)
	} else if deckId == 3 {
		for i, v := range c3 {
			if v != card {
				continue
			}
			c3 = helpers.RemoveOrdered(c3, i)
			break
		}
		marshal, err := json.Marshal(c3)
		if err != nil {
			return
		}
		round.Cards3 = string(marshal)
	} else if deckId == 4 {
		for i, v := range c4 {
			if v != card {
				continue
			}
			c4 = helpers.RemoveOrdered(c4, i)
			break
		}
		marshal, err := json.Marshal(c4)
		if err != nil {
			return
		}
		round.Cards4 = string(marshal)
	} else if deckId == -1 {
		for i, v := range talon {
			if v != card {
				continue
			}
			talon = helpers.RemoveOrdered(talon, i)
			break
		}
		marshal, err := json.Marshal(talon)
		if err != nil {
			return
		}
		round.Talon = string(marshal)
	}

	err = s.db.UpdateTournamentRound(round)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
}

func (s *httpImpl) ChangeRoundTime(w http.ResponseWriter, r *http.Request) {
	user, err := s.db.CheckToken(r)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	if user.Role != "admin" {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	tournamentRoundId := pat.Param(r, "tournamentRoundId")
	time, err := strconv.Atoi(r.FormValue("time"))
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	round, err := s.db.GetTournamentRound(tournamentRoundId)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	round.Time = time

	if time <= 30 {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	err = s.db.UpdateTournamentRound(round)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
}
