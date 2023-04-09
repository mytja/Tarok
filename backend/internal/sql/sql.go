package sql

import (
	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
	_ "github.com/mattn/go-sqlite3"
	"go.uber.org/zap"
	"net/http"
)

type sqlImpl struct {
	db     *sqlx.DB
	logger *zap.SugaredLogger
}

func (db *sqlImpl) Init() {
	db.db.MustExec(schema)
}

type SQL interface {
	CheckToken(request *http.Request) (User, error)
	GetRandomToken(currentUser User) (string, error)

	Init()
	Exec(query string) error

	GetUser(id string) (user User, err error)
	GetUserByLoginToken(loginToken string) (user User, err error)
	InsertUser(user User) (err error)

	GetUserByEmail(email string) (user User, err error)
	CheckIfAdminIsCreated() bool
	GetAllUsers() (users []User, err error)
	UpdateUser(user User) error

	GetRegistrationCode(c string) (code Code, err error)
	InsertCode(code Code) (err error)
	DeleteCode(code string) error
	GetCodes() (codes []Code, err error)
}

func NewSQL(driver string, drivername string, logger *zap.SugaredLogger) (SQL, error) {
	db, err := sqlx.Connect(driver, drivername)
	return &sqlImpl{
		db:     db,
		logger: logger,
	}, err
}

func (db *sqlImpl) Exec(query string) error {
	_, err := db.db.Exec(query)
	return err
}
