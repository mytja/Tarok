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

	GetGame(gameId string) *Game
	GetGames(string) ([]GameDescriptor, []GameDescriptor)
	GetMatch(int, string, sql.User) string
	StartGame(gameId string)
	GetDB() sql.SQL
	Authenticated(client Client)
	ShuffleCards(gameId string)
	Licitiranje(tip int32, gameId string, userId string)
	CardDrop(id string, gameId string, userId string, clientId string)
	NewGame(players int, tip string, private bool, owner string, additionalTime float64, startTime int, skisfang bool, mondfang bool) string
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
	Results(gameId string)
	HandleMessage(gameId string, message *messages.ChatMessage)
	RelayAllMessagesToClient(gameId string, playerId string, clientId string)
	AddFriendByEmail(w http.ResponseWriter, r *http.Request)
	IncomingFriendRequestAcceptDeny(w http.ResponseWriter, r *http.Request)
	RemoveFriend(w http.ResponseWriter, r *http.Request)
	GetFriends(w http.ResponseWriter, r *http.Request)
	InvitePlayer(playerId string, gameId string, invitedId string)
	ManuallyStartGame(playerId string, gameId string)
	GameStartGoroutine(gameId string)
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
	ResendCards(clientId string)
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
	SetTimer(timer float64)
	GetTimer() float64
	SetBotStatus()
	GetBotStatus() bool
}

type Card struct {
	id     string
	userId string
}

type StockSkisCard struct {
	Card struct {
		Alt       string `json:"alt"`
		Asset     string `json:"asset"`
		Worth     int    `json:"worth"`
		WorthOver int    `json:"worthOver"`
	} `json:"card"`
	User string `json:"user"`
}

type Game struct {
	PlayersNeeded       int
	Players             map[string]User
	Starts              []string
	Stihi               [][]Card
	Stashed             []Card
	WaitingFor          int
	Zarufal             bool
	Started             bool
	GameMode            int32
	Playing             []string
	Talon               []Card
	CardsStarted        bool
	PlayingIn           string
	CurrentPredictions  *messages.Predictions
	SinceLastPrediction int
	GameEnd             []string
	EndTimer            chan bool
	StartTime           int
	AdditionalTime      float64
	Chat                []*messages.ChatMessage
	Type                string
	Private             bool
	InvitedPlayers      []string
	Owner               string
	MondfangRadelci     bool
	KazenZaKontro       bool
	IzgubaSkisa         bool
}

type Predictions struct {
	KraljUltimo struct {
		ID   string `json:"id"`
		Name string `json:"name"`
	} `json:"kraljUltimo"`
	KraljUltimoKontra    int `json:"kraljUltimoKontra"`
	KraljUltimoKontraDal struct {
		ID   string `json:"id"`
		Name string `json:"name"`
	} `json:"kraljUltimoKontraDal"`
	Trula struct {
		ID   string `json:"id"`
		Name string `json:"name"`
	} `json:"trula"`
	Kralji struct {
		ID   string `json:"id"`
		Name string `json:"name"`
	} `json:"kralji"`
	PagatUltimo struct {
		ID   string `json:"id"`
		Name string `json:"name"`
	} `json:"pagatUltimo"`
	PagatUltimoKontra    int `json:"pagatUltimoKontra"`
	PagatUltimoKontraDal struct {
		ID   string `json:"id"`
		Name string `json:"name"`
	} `json:"pagatUltimoKontraDal"`
	Igra struct {
		ID   string `json:"id"`
		Name string `json:"name"`
	} `json:"igra"`
	IgraKontra    int `json:"igraKontra"`
	IgraKontraDal struct {
		ID   string `json:"id"`
		Name string `json:"name"`
	} `json:"igraKontraDal"`
	Valat struct {
		ID   string `json:"id"`
		Name string `json:"name"`
	} `json:"valat"`
	ValatKontra    int `json:"valatKontra"`
	ValatKontraDal struct {
		ID   string `json:"id"`
		Name string `json:"name"`
	} `json:"valatKontraDal"`
	BarvniValat struct {
		ID   string `json:"id"`
		Name string `json:"name"`
	} `json:"barvniValat"`
	BarvniValatKontra    int `json:"barvniValatKontra"`
	BarvniValatKontraDal struct {
		ID   string `json:"id"`
		Name string `json:"name"`
	} `json:"barvniValatKontraDal"`
	GameMode int  `json:"gamemode"`
	Changed  bool `json:"changed"`
}

func StockSkisPredictionsToMessages(predictions Predictions) *messages.Predictions {
	p := &messages.Predictions{
		KraljUltimo: &messages.User{
			Id:   predictions.KraljUltimo.ID,
			Name: predictions.KraljUltimo.Name,
		},
		KraljUltimoKontra: int32(predictions.KraljUltimoKontra),
		KraljUltimoKontraDal: &messages.User{
			Id:   predictions.KraljUltimoKontraDal.ID,
			Name: predictions.KraljUltimoKontraDal.Name,
		},
		Trula: &messages.User{
			Id:   predictions.Trula.ID,
			Name: predictions.Trula.Name,
		},
		Kralji: &messages.User{
			Id:   predictions.Kralji.ID,
			Name: predictions.Kralji.Name,
		},
		PagatUltimo: &messages.User{
			Id:   predictions.PagatUltimo.ID,
			Name: predictions.PagatUltimo.Name,
		},
		PagatUltimoKontra: int32(predictions.PagatUltimoKontra),
		PagatUltimoKontraDal: &messages.User{
			Id:   predictions.PagatUltimoKontraDal.ID,
			Name: predictions.PagatUltimoKontraDal.Name,
		},
		Igra: &messages.User{
			Id:   predictions.Igra.ID,
			Name: predictions.Igra.Name,
		},
		IgraKontra: int32(predictions.IgraKontra),
		IgraKontraDal: &messages.User{
			Id:   predictions.IgraKontraDal.ID,
			Name: predictions.IgraKontraDal.Name,
		},
		Valat: &messages.User{
			Id:   predictions.Valat.ID,
			Name: predictions.Valat.Name,
		},
		ValatKontra: int32(predictions.ValatKontra),
		ValatKontraDal: &messages.User{
			Id:   predictions.ValatKontraDal.ID,
			Name: predictions.ValatKontraDal.Name,
		},
		BarvniValat: &messages.User{
			Id:   predictions.BarvniValat.ID,
			Name: predictions.BarvniValat.Name,
		},
		BarvniValatKontra: int32(predictions.BarvniValatKontra),
		BarvniValatKontraDal: &messages.User{
			Id:   predictions.BarvniValatKontraDal.ID,
			Name: predictions.BarvniValatKontraDal.Name,
		},
		Gamemode: int32(predictions.GameMode),
		Changed:  predictions.Changed,
	}
	if p.KraljUltimo.Id == "" {
		p.KraljUltimo = nil
	}
	if p.KraljUltimoKontraDal.Id == "" {
		p.KraljUltimoKontraDal = nil
	}
	if p.Trula.Id == "" {
		p.Trula = nil
	}
	if p.Kralji.Id == "" {
		p.Kralji = nil
	}
	if p.PagatUltimo.Id == "" {
		p.PagatUltimo = nil
	}
	if p.PagatUltimoKontraDal.Id == "" {
		p.PagatUltimoKontraDal = nil
	}
	if p.Igra.Id == "" {
		p.Igra = nil
	}
	if p.IgraKontraDal.Id == "" {
		p.IgraKontraDal = nil
	}
	if p.Valat.Id == "" {
		p.Valat = nil
	}
	if p.ValatKontraDal.Id == "" {
		p.ValatKontraDal = nil
	}
	if p.BarvniValat.Id == "" {
		p.BarvniValat = nil
	}
	if p.BarvniValatKontraDal.Id == "" {
		p.BarvniValatKontraDal = nil
	}
	return p
}
