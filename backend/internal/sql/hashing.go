package sql

import "golang.org/x/crypto/bcrypt"

func HashPassword(pass string) (string, error) {
	passbyte := []byte(pass)
	password, err := bcrypt.GenerateFromPassword(passbyte, 14)
	if err != nil {
		return "", err
	}
	return string(password), nil
}

func CheckHash(pass string, hashedPass string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hashedPass), []byte(pass))
	return err == nil
}
