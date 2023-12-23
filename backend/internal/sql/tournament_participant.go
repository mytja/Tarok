package sql

type TournamentParticipant struct {
	ID           string
	TournamentID string `db:"tournament_id"`
	UserID       string `db:"user_id"`
	Rated        bool
	RatingDelta  int    `db:"rating_delta"`
	CreatedAt    string `db:"created_at"`
	UpdatedAt    string `db:"updated_at"`
}

func (db *sqlImpl) GetTournamentParticipant(id string) (tournamentParticipant TournamentParticipant, err error) {
	err = db.db.Get(&tournamentParticipant, "SELECT * FROM tournament_participant WHERE id=$1", id)
	return tournamentParticipant, err
}

func (db *sqlImpl) GetTournamentParticipantByTournamentUser(tournamentId string, userId string) (tournamentParticipant TournamentParticipant, err error) {
	err = db.db.Get(&tournamentParticipant, "SELECT * FROM tournament_participant WHERE tournamnet_id=$1 AND user_id=$2", tournamentId, userId)
	return tournamentParticipant, err
}

func (db *sqlImpl) InsertTournamentParticipant(tournamentParticipant TournamentParticipant) (err error) {
	s := `INSERT INTO tournament_participant (
                    tournament_id,
					user_id,
					rated,
					rating_delta
		  ) VALUES (
                    :tournament_id,
					:user_id,
					:rated,
					:rating_delta
	)`
	_, err = db.db.NamedExec(s, tournamentParticipant)
	return err
}

func (db *sqlImpl) GetAllTournamentParticipants() (tournamentParticipant []TournamentParticipant, err error) {
	err = db.db.Select(&tournamentParticipant, "SELECT * FROM tournament_participant ORDER BY created_at DESC")
	return tournamentParticipant, err
}

func (db *sqlImpl) UpdateTournamentParticipant(tournamentParticipant TournamentParticipant) error {
	s := `UPDATE tournament_participant SET
			rated=:rated,
			rating_delta=:rating_delta
        WHERE id=:id`
	_, err := db.db.NamedExec(s, tournamentParticipant)
	return err
}

func (db *sqlImpl) DeleteTournamentParticipant(id string) error {
	_, err := db.db.Exec("DELETE FROM tournament_participant WHERE id=$1", id)
	return err
}
