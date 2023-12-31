package sql

type User struct {
	ID                       string
	Email                    string
	Password                 string `db:"pass"`
	Role                     string
	Name                     string
	Handle                   string
	LoginToken               string `db:"login_token"`
	Rating                   int
	EmailConfirmation        string `db:"email_confirmation"`
	EmailConfirmed           bool   `db:"email_confirmed"`
	Disabled                 bool
	PasswordResetToken       string `db:"password_reset_token"`
	PasswordResetInitiatedOn string `db:"password_reset_initiated_on"`
	EmailSentOn              int    `db:"mail_sent_on"`

	CreatedAt string `db:"created_at"`
	UpdatedAt string `db:"updated_at"`
}

func (db *sqlImpl) GetUser(id string) (user User, err error) {
	err = db.db.Get(&user, "SELECT * FROM users WHERE id=$1", id)
	return user, err
}

func (db *sqlImpl) GetUserByLoginToken(loginToken string) (user User, err error) {
	err = db.db.Get(&user, "SELECT * FROM users WHERE login_token=$1", loginToken)
	return user, err
}

func (db *sqlImpl) GetUserByEmail(email string) (user User, err error) {
	err = db.db.Get(&user, "SELECT * FROM users WHERE email=$1", email)
	return user, err
}

func (db *sqlImpl) GetUserByHandle(handle string) (user User, err error) {
	err = db.db.Get(&user, "SELECT * FROM users WHERE handle=$1", handle)
	return user, err
}

func (db *sqlImpl) InsertUser(user User) (err error) {
	s := `INSERT INTO users (
                   email,
                   name,
                   pass,
                   rating,
                   role,
                   login_token,
                   email_confirmation,
                   email_confirmed,
                   disabled,
                   password_reset_token,
                   password_reset_initiated_on,
                   handle
		  ) VALUES (
					:email,
					:name,
					:pass,
					1000,
					:role,
		            :login_token,
		            :email_confirmation,
                   	:email_confirmed,
                   	:disabled,
                   	:password_reset_token,
                   	:password_reset_initiated_on,
		            :handle
	)`
	_, err = db.db.NamedExec(s, user)
	return err
}

func (db *sqlImpl) CheckIfAdminIsCreated() bool {
	var users []User
	err := db.db.Select(&users, "SELECT * FROM users")
	if err != nil {
		// Return true, as we don't want all the kids, on some internal error to become administrators
		return true
	}
	return len(users) > 0
}

func (db *sqlImpl) GetAllUsers() (users []User, err error) {
	err = db.db.Select(&users, "SELECT * FROM users ORDER BY name")
	return users, err
}

func (db *sqlImpl) UpdateUser(user User) error {
	s := `UPDATE users SET
			pass=:pass,
			name=:name,
			rating=:rating,
			role=:role,
			email=:email,
			login_token=:login_token,
			email_confirmation=:email_confirmation,
			email_confirmed=:email_confirmed,
			disabled=:disabled,
			password_reset_token=:password_reset_token,
			password_reset_initiated_on=:password_reset_initiated_on,
			mail_sent_on=:mail_sent_on,
			handle=:handle
             WHERE id=:id`
	_, err := db.db.NamedExec(s, user)
	return err
}
