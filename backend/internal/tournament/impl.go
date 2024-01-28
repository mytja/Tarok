package tournament

import (
	"github.com/mytja/Tarok/backend/internal/sql"
	"github.com/mytja/Tarok/backend/internal/ws"
	"go.uber.org/zap"
)

type tournamentImpl struct {
	logger           *zap.SugaredLogger
	db               sql.SQL
	wsServer         ws.Server
	tournamentId     string
	games            map[string]*ws.Game
	queuedGames      map[string]*ws.Game
	openedLobbies    bool
	round            int
	startTime        int
	roundStarted     bool
	nextRoundTime    int
	test             bool
	testerId         string
	talonTimeoutTime int
}

type Tournament interface {
	RunOrganizer()
}

func NewTournament(tournamentId string, logger *zap.SugaredLogger, db sql.SQL, wsServer ws.Server, startTime int, test bool, testerId string) Tournament {
	return &tournamentImpl{
		logger:        logger,
		db:            db,
		wsServer:      wsServer,
		tournamentId:  tournamentId,
		openedLobbies: false,
		round:         0,
		startTime:     startTime / 1000,
		roundStarted:  false,
		games:         make(map[string]*ws.Game),
		queuedGames:   make(map[string]*ws.Game),
		nextRoundTime: 0,
		test:          test,
		testerId:      testerId,
	}
}
