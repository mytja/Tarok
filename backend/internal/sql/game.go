package sql

type Game struct {
	ID       string
	UserID   string `db:"user_id"`
	GameID   string `db:"game_id"`
	Messages string
	Password string

	CreatedAt string `db:"created_at"`
	UpdatedAt string `db:"updated_at"`
}

func (db *sqlImpl) GetGame(id string) (game Game, err error) {
	err = db.db.Get(&game, "SELECT * FROM game_user WHERE game_id=$1", id)
	return game, err
}

func (db *sqlImpl) GetGamesByUserID(id string) (games []Game, err error) {
	err = db.db.Select(&games, "SELECT * FROM game_user WHERE user_id=$1 ORDER BY created_at DESC", id)
	return games, err
}

func (db *sqlImpl) InsertGame(game Game) (err error) {
	_, err = db.db.NamedExec(
		"INSERT INTO game_user (user_id, game_id, messages, password) VALUES (:user_id, :game_id, :messages, :password)",
		game)
	return err
}

func (db *sqlImpl) GetGames() (games []Game, err error) {
	err = db.db.Select(&games, "SELECT * FROM game_user ORDER BY created_at DESC")
	return games, err
}
