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

type Card struct {
	id     string
	userId string
}

type Game struct {
	PlayersNeeded       int
	Players             map[string][]Client
	PlayerGameModes     map[string]int32
	Starts              []string
	Stihi               [][]Card
	Stashed             []Card
	WaitingFor          int
	cancel              chan bool
	Started             bool
	Game                int32
	Playing             []string
	Talon               []Card
	PlayerCardsArchive  map[string][]Card
	PlayerCards         map[string][]Card
	CardsStarted        bool
	Zarufal             bool
	PlayingIn           string
	CurrentPredictions  *messages.Predictions
	SinceLastPrediction int
	GameEnd             []string
	Results             map[string]int
}
