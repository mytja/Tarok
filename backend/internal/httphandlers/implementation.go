package httphandlers

import (
	"github.com/mytja/Tarok/backend/internal/consts"
	"github.com/mytja/Tarok/backend/internal/sql"
	"github.com/mytja/Tarok/backend/internal/ws"
	"go.uber.org/zap"
	"net/http"
)

type httpImpl struct {
	db       sql.SQL
	config   *consts.ServerConfig
	sugared  *zap.SugaredLogger
	wsServer ws.Server
}

type HTTPHandler interface {
	Registration(w http.ResponseWriter, r *http.Request)
	Login(w http.ResponseWriter, r *http.Request)
	DeleteRegistrationCode(w http.ResponseWriter, r *http.Request)
	NewRegistrationCode(w http.ResponseWriter, r *http.Request)
	GetRegistrationCodes(w http.ResponseWriter, r *http.Request)
	ConfirmEmail(w http.ResponseWriter, r *http.Request)
	GetUsers(w http.ResponseWriter, r *http.Request)
	DisableAccount(w http.ResponseWriter, r *http.Request)
	ValidateEmail(w http.ResponseWriter, r *http.Request)
	ChangeName(w http.ResponseWriter, r *http.Request)
	ChangePassword(w http.ResponseWriter, r *http.Request)
	PromoteDemoteUser(w http.ResponseWriter, r *http.Request)
	GetUserData(w http.ResponseWriter, r *http.Request)
	Logout(w http.ResponseWriter, r *http.Request)
	RequestPasswordReset(w http.ResponseWriter, r *http.Request)
	PasswordResetConfirm(w http.ResponseWriter, r *http.Request)
	GetAllTournaments(w http.ResponseWriter, r *http.Request)
	GetUpcomingTournaments(w http.ResponseWriter, r *http.Request)
	NewTournament(w http.ResponseWriter, r *http.Request)
	UpdateTournament(w http.ResponseWriter, r *http.Request)
	DeleteTournament(w http.ResponseWriter, r *http.Request)
	GetAllParticipants(w http.ResponseWriter, r *http.Request)
	RemoveParticipation(w http.ResponseWriter, r *http.Request)
	AddParticipation(w http.ResponseWriter, r *http.Request)
	GetParticipations(w http.ResponseWriter, r *http.Request)
	ToggleRatedUnratedParticipant(w http.ResponseWriter, r *http.Request)
	NewTournamentRound(w http.ResponseWriter, r *http.Request)
	ClearTournamentRoundCards(w http.ResponseWriter, r *http.Request)
	ReshuffleRoundCards(w http.ResponseWriter, r *http.Request)
	DeleteTournamentRound(w http.ResponseWriter, r *http.Request)
	GetTournamentRounds(w http.ResponseWriter, r *http.Request)
	AddCardTournamentRound(w http.ResponseWriter, r *http.Request)
	RemoveCardTournamentRound(w http.ResponseWriter, r *http.Request)
	ChangeHandle(w http.ResponseWriter, r *http.Request)
	AddTournamentTester(w http.ResponseWriter, r *http.Request)
	RemoveTournamentTester(w http.ResponseWriter, r *http.Request)
	TestTournament(w http.ResponseWriter, r *http.Request)
	ChangeRoundTime(w http.ResponseWriter, r *http.Request)
}

func NewHTTPHandler(db sql.SQL, config *consts.ServerConfig, sugared *zap.SugaredLogger, wsServer ws.Server) HTTPHandler {
	return &httpImpl{
		db:       db,
		config:   config,
		sugared:  sugared,
		wsServer: wsServer,
	}
}
