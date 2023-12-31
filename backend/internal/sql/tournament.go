package sql

import "time"

type Tournament struct {
	ID        string
	CreatedBy string `db:"created_by"`
	Name      string
	StartTime int `db:"start_time"`
	Division  int
	Rated     bool
	Testers   string
	Private   bool
	CreatedAt string `db:"created_at"`
	UpdatedAt string `db:"updated_at"`
}

func (db *sqlImpl) GetTournament(id string) (tournament Tournament, err error) {
	err = db.db.Get(&tournament, "SELECT * FROM tournament WHERE id=$1", id)
	return tournament, err
}

func (db *sqlImpl) InsertTournament(tournament Tournament) (err error) {
	s := `INSERT INTO tournament (
					created_by,
					name,
					start_time,
					division,
					rated,
                    testers,
                    private
		  ) VALUES (
					:created_by,
					:name,
					:start_time,
					:division,
					:rated,
		            :testers,
		            :private
	)`
	_, err = db.db.NamedExec(s, tournament)
	return err
}

func (db *sqlImpl) GetAllTournaments() (tournament []Tournament, err error) {
	err = db.db.Select(&tournament, "SELECT * FROM tournament ORDER BY start_time")
	return tournament, err
}

func (db *sqlImpl) GetAllNotStartedTournaments() (tournament []Tournament, err error) {
	err = db.db.Select(&tournament, "SELECT * FROM tournament WHERE start_time>$1", time.Now().Unix()*1000)
	return tournament, err
}

func (db *sqlImpl) UpdateTournament(tournament Tournament) error {
	s := `UPDATE tournament SET
			created_by=:created_by,
			name=:name,
			start_time=:start_time,
			division=:division,
			rated=:rated,
			private=:private,
			testers=:testers
        WHERE id=:id`
	_, err := db.db.NamedExec(s, tournament)
	return err
}

func (db *sqlImpl) DeleteTournament(id string) error {
	_, err := db.db.Exec("DELETE FROM tournament WHERE id=$1", id)
	return err
}
