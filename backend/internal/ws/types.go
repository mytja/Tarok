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
	GetDB() sql.SQL
	Authenticated(client Client)
	ShuffleCards(gameId string)
	Licitiranje(tip int32, gameId string, userId string)
	CardDrop(id string, gameId string, userId string)
	NewGame(players int) string
	Connect(w http.ResponseWriter, r *http.Request) Client
	Disconnect(client Client)
	Broadcast(excludeClient string, msg *messages.Message)
}

// Client contains all the methods we need for recognising and working with the Client
type Client interface {
	GetID() string
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
	PlayersNeeded int
	Players       []Client
	Stihi         [][]Card
	cancel        chan bool
	Started       bool
	Game          int32
	Playing       string
	Talon         []Card
	PlayerCards   map[string][]Card
}
