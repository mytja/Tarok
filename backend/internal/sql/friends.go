package sql

type Friends struct {
	ID        string
	User1     string
	User2     string
	Connected bool
	CreatedAt string `db:"created_at"`
	UpdatedAt string `db:"updated_at"`
}

func (db *sqlImpl) GetFriendRelationshipByUserID(user1 string, user2 string) (friends Friends, err error) {
	err = db.db.Get(&friends, "SELECT * FROM friends WHERE (user1=$1 AND user2=$2) OR (user2=$1 AND user1=$2)", user1, user2)
	return friends, err
}

func (db *sqlImpl) GetFriendRelationship(id string) (friends Friends, err error) {
	err = db.db.Get(&friends, "SELECT * FROM friends WHERE id=$1", id)
	return friends, err
}

func (db *sqlImpl) InsertFriendRelationship(friends Friends) (err error) {
	_, err = db.db.NamedExec(
		"INSERT INTO friends (user1, user2, connected) VALUES (:user1, :user2, :connected)",
		friends)
	return err
}

func (db *sqlImpl) GetFriends(userId string) (friends []Friends, err error) {
	err = db.db.Select(&friends, "SELECT * FROM friends WHERE (user1=$1 OR user2=$1) AND connected=true ORDER BY id ASC", userId)
	return friends, err
}

func (db *sqlImpl) GetIncomingFriends(userId string) (friends []Friends, err error) {
	err = db.db.Select(&friends, "SELECT * FROM friends WHERE user2=$1 AND connected=false ORDER BY id ASC", userId)
	return friends, err
}

func (db *sqlImpl) GetOutgoingFriends(userId string) (friends []Friends, err error) {
	err = db.db.Select(&friends, "SELECT * FROM friends WHERE user1=$1 AND connected=false ORDER BY id ASC", userId)
	return friends, err
}

func (db *sqlImpl) UpdateFriends(friends Friends) error {
	_, err := db.db.NamedExec(
		"UPDATE friends SET connected=:connected WHERE id=:id",
		friends)
	return err
}

func (db *sqlImpl) DeleteFriends(ID string) error {
	_, err := db.db.Exec("DELETE FROM friends WHERE id=$1", ID)
	return err
}
