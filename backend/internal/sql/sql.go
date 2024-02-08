package sql

import (
	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
	_ "github.com/mattn/go-sqlite3"
	"github.com/mytja/Tarok/backend/internal/consts"
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
	CheckTokenString(loginToken string) (user User, err error)
	GetRandomToken(currentUser User) (string, error)

	Init()
	Exec(query string) error

	GetUser(id string) (user User, err error)
	GetUserByLoginToken(loginToken string) (user User, err error)
	InsertUser(user User) (err error)
	GetUserByEmail(email string) (user User, err error)
	GetUserByHandle(handle string) (user User, err error)
	CheckIfAdminIsCreated() bool
	GetAllUsers() (users []User, err error)
	UpdateUser(user User) error

	GetRegistrationCode(c string) (code Code, err error)
	InsertCode(code Code) (err error)
	DeleteCode(code string) error
	GetCodes() (codes []Code, err error)

	GetFriendRelationshipByUserID(user1 string, user2 string) (friends Friends, err error)
	GetFriendRelationship(id string) (friends Friends, err error)
	InsertFriendRelationship(friends Friends) (err error)
	GetFriends(userId string) (friends []Friends, err error)
	GetIncomingFriends(userId string) (friends []Friends, err error)
	GetOutgoingFriends(userId string) (friends []Friends, err error)
	UpdateFriends(friends Friends) error
	DeleteFriends(ID string) error

	GetGame(id string) (game Game, err error)
	GetGamesByUserID(id string) (games []Game, err error)
	InsertGame(game Game) (err error)
	GetGames() (games []Game, err error)

	GetTournament(id string) (tournament Tournament, err error)
	GetTournamentByArgs(startTime int, division int, name string) (tournament Tournament, err error)
	InsertTournament(tournament Tournament) (err error)
	GetAllTournaments() (tournament []Tournament, err error)
	GetAllNotEndedTournaments() (tournament []Tournament, err error)
	UpdateTournament(tournament Tournament) error
	DeleteTournament(id string) error
	GetAllPastTournaments() (tournament []Tournament, err error)

	GetTournamentParticipant(id string) (tournamentParticipant TournamentParticipant, err error)
	GetTournamentParticipantByTournamentUser(tournamentId string, userId string) (tournamentParticipant TournamentParticipant, err error)
	InsertTournamentParticipant(tournamentParticipant TournamentParticipant) (err error)
	GetAllTournamentParticipationsForUser(userId string) (participations []TournamentParticipant, err error)
	GetAllTournamentParticipants(tournamentId string) (tournamentParticipant []TournamentParticipant, err error)
	UpdateTournamentParticipant(tournamentParticipant TournamentParticipant) error
	DeleteTournamentParticipant(id string) error

	GetTournamentRound(id string) (tournamentRound TournamentRound, err error)
	GetTournamentRoundByTournamentNumber(tournamentId string, roundNumber int) (tournamentRound TournamentRound, err error)
	InsertTournamentRound(tournamentRound TournamentRound) (err error)
	GetAllTournamentRounds(tournamentId string) (tournamentRound []TournamentRound, err error)
	UpdateTournamentRound(tournamentRound TournamentRound) error
	DeleteTournamentRound(id string) error
	GetTournamentCards(tournamentId string, roundNumber int, playerNumber int) (cards []consts.Card, err error)
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
