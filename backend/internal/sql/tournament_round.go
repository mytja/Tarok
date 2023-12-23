package sql

import (
	"encoding/json"
	"github.com/mytja/Tarok/backend/internal/consts"
)

type TournamentRound struct {
	ID           string
	TournamentID string `db:"tournament_id"`
	Cards1       string `db:"cards1"`
	Cards2       string `db:"cards2"`
	Cards3       string `db:"cards3"`
	Cards4       string `db:"cards4"`
	Talon        string `db:"talon"`
	RoundNumber  int    `db:"round_number"`
	Time         int    `db:"time"`
	CreatedAt    string `db:"created_at"`
	UpdatedAt    string `db:"updated_at"`
}

func (db *sqlImpl) GetTournamentRound(id string) (tournamentRound TournamentRound, err error) {
	err = db.db.Get(&tournamentRound, "SELECT * FROM tournament_round WHERE id=$1", id)
	return tournamentRound, err
}

func (db *sqlImpl) GetTournamentRoundByTournamentNumber(tournamentId string, roundNumber int) (tournamentRound TournamentRound, err error) {
	err = db.db.Get(&tournamentRound, "SELECT * FROM tournament_round WHERE tournament_id=$1 AND round_number=$2", tournamentId, roundNumber)
	return tournamentRound, err
}

func (db *sqlImpl) InsertTournamentRound(tournamentRound TournamentRound) (err error) {
	s := `INSERT INTO tournament_round (
					tournament_id,
					cards1,
					cards2,
					cards3,
					cards4,
					talon,
                    round_number,
					time
		  ) VALUES (
					:tournament_id,
					:cards1,
					:cards2,
					:cards3,
					:cards4,
					:talon,
		            :round_number,
					:time
	)`
	_, err = db.db.NamedExec(s, tournamentRound)
	return err
}

func (db *sqlImpl) GetAllTournamentRounds(tournamentId string) (tournamentRound []TournamentRound, err error) {
	err = db.db.Select(&tournamentRound, "SELECT * FROM tournament_round WHERE tournament_id=$1 ORDER BY round_number", tournamentId)
	return tournamentRound, err
}

func (db *sqlImpl) UpdateTournamentRound(tournamentRound TournamentRound) error {
	s := `UPDATE tournament_round SET
			cards1=:cards1,
			cards2=:cards2,
			cards3=:cards3,
			cards4=:cards4,
			talon=:talon,
			round_number=:round_number,
			time=:time
        WHERE id=:id`
	_, err := db.db.NamedExec(s, tournamentRound)
	return err
}

func (db *sqlImpl) DeleteTournamentRound(id string) error {
	_, err := db.db.Exec("DELETE FROM tournament_round WHERE id=$1", id)
	return err
}

func (db *sqlImpl) GetTournamentCards(tournamentId string, roundNumber int, playerNumber int) (cards []consts.Card, err error) {
	round, err := db.GetTournamentRoundByTournamentNumber(tournamentId, roundNumber)
	if err != nil {
		return nil, err
	}
	rn := round.Cards1
	if playerNumber == 2 {
		rn = round.Cards2
	} else if playerNumber == 3 {
		rn = round.Cards3
	} else if playerNumber == 4 {
		rn = round.Cards4
	} else if playerNumber == -1 {
		rn = round.Talon
	}

	var karte []string
	err = json.Unmarshal([]byte(rn), &karte)
	if err != nil {
		return nil, err
	}

	cards = make([]consts.Card, 0)

	for _, karta := range karte {
		c, exists := consts.CARDS_MAP[karta]
		if !exists {
			db.logger.Warnw("neveljavna karta", "karta", karta, "tournamentId", tournamentId, "roundNumber", roundNumber, "playerNumber", playerNumber)
			continue
		}
		cards = append(cards, c)
	}

	return cards, nil
}
