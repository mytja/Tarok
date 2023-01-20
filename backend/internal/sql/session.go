package sql

import (
	"crypto/rand"
	"encoding/base64"
	"errors"
)

func (db *sqlImpl) GetRandomToken(currentUser User) (string, error) {
	randomBytes := make([]byte, 32)
	_, err := rand.Read(randomBytes)
	if err != nil {
		return "", err
	}
	token := base64.StdEncoding.EncodeToString(randomBytes)
	user, err := db.GetUserByLoginToken(token)
	if err == nil || (err != nil && err.Error() != "sql: no rows in result set") {
		return "", err
	}
	db.logger.Info(currentUser, user, token)
	currentUser.LoginToken = token
	err = db.UpdateUser(currentUser)
	return token, err
}

func (db *sqlImpl) CheckToken(loginToken string) (user User, err error) {
	if loginToken == "" {
		db.logger.Debug("invalid token")
		return user, errors.New("invalid token")
	}
	user, err = db.GetUserByLoginToken(loginToken)
	if err != nil {
		db.logger.Debug(err.Error())
		return user, err
	}
	return user, err
}
