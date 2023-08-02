package ws

import (
	"github.com/mytja/Tarok/backend/internal/sql"
	"net"
	"net/http"

	"github.com/mytja/Tarok/backend/internal/messages"
)

// Server starts the Run connect and disconnect methods
type Server interface {
	Run()

	GetGames() []string
	GetMatch(int, sql.User) string
	StartGame(gameId string)
	GetDB() sql.SQL
	Authenticated(client Client)
	ShuffleCards(gameId string)
	Licitiranje(tip int32, gameId string, userId string)
	CardDrop(id string, gameId string, userId string, clientId string)
	NewGame(players int) string
	Connect(w http.ResponseWriter, r *http.Request) Client
	Disconnect(client Client)
	Broadcast(excludeClient string, msg *messages.Message)
	KingCalling(gameId string)
	KingCalled(userId string, gameId string, cardId string)
	Talon(gameId string)
	TalonSelected(userId string, gameId string, part int32)
	Stash(gameId string)
	StashedCards(userId string, gameId string, cards []*messages.Card)
	Predictions(gameId string, userId string, predictions *messages.Predictions)
	GameEndRequest(userId string, gameId string)
	StockSkisExec(requestType string, userId string, gameId string) []byte
	UnmarshallResults(b []byte) Results
}

// Client contains all the methods we need for recognising and working with the Client
type Client interface {
	GetUserID() string
	GetClientID() string
	GetUser() sql.User
	GetGame() string
	GetRemoteAddr() net.Addr

	Send(msg *messages.Message)
	Close()

	ReadPump()
	SendPump()
}

type User interface {
	RemoveClient(clientId string)
	GetClients() []Client
	BroadcastToClients(message *messages.Message)
	ResetGameVariables()
	GetUser() sql.User
	AddCard(card Card)
	ResendCards()
	NewClient(client Client)
	ImaKarto(karta string) bool
	GetCards() []Card
	GetArchivedCards() []Card
	RemoveCard(card int)
	SetGameMode(mode int32)
	GetGameMode() int32
	SendToClient(clientId string, message *messages.Message)
	RemoveCardByID(card string)
	AddPoints(points int)
	GetResults() int
	AssignArchive()
	GetRadelci() int
	AddRadelci()
	RemoveRadelci()
	SetHasKingFallen()
	SetHasKing(selectedKing string)
	UserHasKing() bool
	SelectedKingFallen() bool
}

type Card struct {
	id     string
	userId string
}

type Game struct {
	PlayersNeeded       int
	Players             map[string]User
	Starts              []string
	Stihi               [][]Card
	Stashed             []Card
	WaitingFor          int
	Zarufal             bool
	Cancel              chan bool
	Started             bool
	GameMode            int32
	Playing             []string
	Talon               []Card
	CardsStarted        bool
	PlayingIn           string
	CurrentPredictions  *messages.Predictions
	SinceLastPrediction int
	GameEnd             []string
}
