package sql

type Code struct {
	Code      string
	CreatedAt string `db:"created_at"`
	UpdatedAt string `db:"updated_at"`
}

func (db *sqlImpl) GetRegistrationCode(c string) (code Code, err error) {
	err = db.db.Get(&code, "SELECT * FROM codes WHERE code=$1", c)
	return code, err
}

func (db *sqlImpl) InsertCode(code Code) (err error) {
	_, err = db.db.NamedExec("INSERT INTO codes (code) VALUES (:code)", code)
	return err
}

func (db *sqlImpl) GetCodes() (codes []Code, err error) {
	err = db.db.Select(&codes, "SELECT * FROM codes ORDER BY code ASC")
	return codes, err
}

func (db *sqlImpl) DeleteCode(code string) error {
	_, err := db.db.Exec("DELETE FROM codes WHERE code=$1", code)
	return err
}
