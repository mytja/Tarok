package sql

type TournamentParticipant struct {
	ID           string
	TournamentID string `db:"tournament_id"`
	UserID       string `db:"user_id"`
	Rated        bool
	RatingDelta  int    `db:"rating_delta"`
	RatingPoints int    `db:"rating_points"`
	CreatedAt    string `db:"created_at"`
	UpdatedAt    string `db:"updated_at"`
}

func (db *sqlImpl) GetTournamentParticipant(id string) (tournamentParticipant TournamentParticipant, err error) {
	err = db.db.Get(&tournamentParticipant, "SELECT * FROM tournament_participant WHERE id=$1", id)
	return tournamentParticipant, err
}

func (db *sqlImpl) GetTournamentParticipantByTournamentUser(tournamentId string, userId string) (tournamentParticipant TournamentParticipant, err error) {
	err = db.db.Get(&tournamentParticipant, "SELECT * FROM tournament_participant WHERE tournament_id=$1 AND user_id=$2", tournamentId, userId)
	return tournamentParticipant, err
}

func (db *sqlImpl) GetAllTournamentParticipationsForUser(userId string) (participations []TournamentParticipant, err error) {
	err = db.db.Select(&participations, "SELECT * FROM tournament_participant WHERE user_id=$1", userId)
	return participations, err
}

func (db *sqlImpl) InsertTournamentParticipant(tournamentParticipant TournamentParticipant) (err error) {
	s := `INSERT INTO tournament_participant (
                    tournament_id,
					user_id,
					rated,
					rating_delta,
                    rating_points
		  ) VALUES (
                    :tournament_id,
					:user_id,
					:rated,
					:rating_delta,
					:rating_points
	)`
	_, err = db.db.NamedExec(s, tournamentParticipant)
	return err
}

func (db *sqlImpl) GetAllTournamentParticipants(tournamentId string) (tournamentParticipant []TournamentParticipant, err error) {
	err = db.db.Select(&tournamentParticipant, "SELECT * FROM tournament_participant WHERE tournament_id=$1 ORDER BY created_at DESC", tournamentId)
	return tournamentParticipant, err
}

func (db *sqlImpl) UpdateTournamentParticipant(tournamentParticipant TournamentParticipant) error {
	s := `UPDATE tournament_participant SET
			rated=:rated,
			rating_delta=:rating_delta,
			rating_points=:rating_points
        WHERE id=:id`
	_, err := db.db.NamedExec(s, tournamentParticipant)
	return err
}

func (db *sqlImpl) DeleteTournamentParticipant(id string) error {
	_, err := db.db.Exec("DELETE FROM tournament_participant WHERE id=$1", id)
	return err
}
