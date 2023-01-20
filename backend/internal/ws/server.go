package ws

import (
	"github.com/google/uuid"
	"github.com/mytja/Tarok/backend/internal/helpers"
	"github.com/mytja/Tarok/backend/internal/sql"
	"goji.io/pat"
	"math/rand"
	"net/http"
	"time"

	"github.com/gorilla/websocket"
	"go.uber.org/zap"

	"github.com/mytja/Tarok/backend/internal/consts"
	"github.com/mytja/Tarok/backend/internal/events"
	"github.com/mytja/Tarok/backend/internal/messages"
)

var (
	socketUpgrader = websocket.Upgrader{
		ReadBufferSize:  1024,
		WriteBufferSize: 1024,
		CheckOrigin: func(r *http.Request) bool {
			return true
		},
	}
)

// serevrImpl has data about all clients
// and sends the connect and disconnect messages
type serverImpl struct {
	logger     *zap.SugaredLogger
	games      map[string]Game
	db         sql.SQL
	connect    chan connectMessage
	disconnect chan Client
	broadcast  chan broadcastMessage
}

// connectMessage is used to send the connect message
type connectMessage struct {
	game string
	conn *websocket.Conn
	user sql.User
	done chan Client
}

type broadcastMessage struct {
	msg           *messages.Message
	game          string
	excludeClient string
}

// NewServer return all the data for the server
func NewServer(logger *zap.Logger, db sql.SQL) Server {
	return &serverImpl{
		logger:     logger.Sugar(),
		games:      make(map[string]Game),
		db:         db,
		connect:    make(chan connectMessage, consts.ChanBufferSize),
		broadcast:  make(chan broadcastMessage, consts.ChanBufferSize),
		disconnect: make(chan Client, consts.ChanBufferSize),
	}
}

// Run is used for connecting and disconnecting clients from the server
func (s *serverImpl) Run() {
	s.logger.Debug("server started and listening for events")
	s.handleBroadcast()
	s.handleDisconnect()
	for {
		select {
		case connect := <-s.connect:
			s.logger.Infow("new connection", "remoteAddr", connect.conn.RemoteAddr())
			gameId := connect.game
			client := NewClient(connect.user, connect.conn, s, s.logger.Desugar(), gameId)
			connect.done <- client
		case disconnect := <-s.disconnect:
			s.logger.Infow("disconnect", "id", disconnect.GetID(), "remoteAddr", disconnect.GetRemoteAddr())
			for i, v := range s.games[disconnect.GetGame()].Players {
				if v.GetID() != disconnect.GetID() {
					continue
				}
				game := s.games[disconnect.GetGame()]
				s.logger.Debugw("found disconnected user", "game", game, "id", disconnect.GetID())
				game.Players = helpers.Remove(s.games[disconnect.GetGame()].Players, i)
				s.games[disconnect.GetGame()] = game
				s.logger.Debugw("found disconnected user", "game", game, "id", disconnect.GetID())
				break
			}
			s.logger.Debugw("disconnected the user. now closing the connection")
			disconnect.Close()
			s.logger.Debugw("connection close now finished")
			//recover()

			// Notify all other players
			playerId := disconnect.GetID()
			msg := messages.Message{
				GameId:   disconnect.GetGame(),
				PlayerId: playerId,
				Data:     &messages.Message_Connection{Connection: &messages.Connection{Rating: int32(disconnect.GetUser().Rating), Type: &messages.Connection_Disconnect{Disconnect: &messages.Disconnect{}}}},
			}

			s.logger.Debugw("broadcasting disconnect message to everybody in the game")
			s.Broadcast(playerId, &msg)
			if len(s.games[disconnect.GetGame()].Players)+1 == s.games[disconnect.GetGame()].PlayersNeeded {
				s.logger.Debugw("cancelling the game start", "gameId", disconnect.GetGame(), "id", disconnect.GetID(), "game", s.games[disconnect.GetGame()])
				s.games[disconnect.GetGame()].cancel <- true
			}
			s.logger.Debugw("done disconnecting the user")
		case broadcast := <-s.broadcast:
			s.logger.Debugw("Broadcasting", "id", broadcast.excludeClient, "msg", broadcast.msg)
			//broadcast.msg.PlayerId = broadcast.excludeClient
			for _, client := range s.games[broadcast.msg.GameId].Players {
				if broadcast.excludeClient == client.GetID() {
					continue
				}

				client.Send(broadcast.msg)
			}
		}
	}
}

// Connect gives Run the data to connect the client and starts functions ReadPump and SendPump
func (s *serverImpl) Connect(w http.ResponseWriter, r *http.Request) Client {
	game := pat.Param(r, "id")

	conn, err := socketUpgrader.Upgrade(w, r, nil)
	if err != nil {
		s.logger.Errorw("error while upgrading connection", zap.Error(err))
		return nil
	}

	done := make(chan Client)
	s.connect <- connectMessage{conn: conn, done: done, game: game}
	s.logger.Info("successfully sent connectMessage to s.connect channel")
	client := <-done
	go client.ReadPump()
	go client.SendPump()

	client.Send(&messages.Message{GameId: game, Data: &messages.Message_LoginRequest{LoginRequest: &messages.LoginRequest{}}})

	return client
}

func (s *serverImpl) Authenticated(client Client) {
	gameId := client.GetGame()
	id := client.GetID()
	user := client.GetUser()

	if len(s.games[gameId].Players) > s.games[gameId].PlayersNeeded {
		s.logger.Debugw("kicking authenticated user due to too many people in the game", "id", id, "gameId", gameId, "name", user.Name)
		return
	}

	s.logger.Debugw("successfully authenticated user", "id", id, "gameId", gameId, "name", user.Name)

	game := s.games[gameId]
	game.Players = append(game.Players, client)
	s.games[gameId] = game

	s.sendPlayers(client)
	s.Broadcast(client.GetID(), &messages.Message{
		GameId:   gameId,
		PlayerId: id,
		Username: user.Name,
		Data: &messages.Message_Connection{
			Connection: &messages.Connection{
				Rating: int32(user.Rating),
				Type:   &messages.Connection_Join{Join: &messages.Connect{}},
			},
		},
	})

	if len(s.games[gameId].Players) == s.games[gameId].PlayersNeeded {
		// začnimo igro
		s.logger.Debugw("starting game", "gameId", gameId)
		start := time.Now()
		done := false
		for {
			select {
			case <-s.games[gameId].cancel:
				s.logger.Debugw("cancelling game start", "gameId", gameId)
				return
			default:
				if time.Now().Sub(start).Seconds() > 10 {
					s.logger.Debugw("game started. sending GameStart packet", "gameId", gameId)
					t := make([]*messages.User, 0)
					for i, v := range s.games[gameId].Players {
						t = append(t, &messages.User{Name: v.GetUser().Name, Id: v.GetID(), Position: int32(i)})
					}
					msg := messages.Message{
						GameId: gameId,
						Data:   &messages.Message_GameStart{GameStart: &messages.GameStart{User: t}},
					}
					s.Broadcast("", &msg)
					s.ShuffleCards(gameId)
					licitatesFirst := s.games[gameId].Players[0]
					licitiranjeMsg := messages.Message{
						PlayerId: licitatesFirst.GetID(),
						GameId:   gameId,
						Data:     &messages.Message_LicitiranjeStart{LicitiranjeStart: &messages.LicitiranjeStart{}},
					}
					licitatesFirst.Send(&licitiranjeMsg)
					done = true
					break
				}
			}
			if done {
				break
			}
		}
		s.logger.Debugw("successfully started the game", "gameId", gameId)
	}
}

func (s *serverImpl) ShuffleCards(gameId string) {
	cards := make([]consts.Card, 0)
	cards = append(cards, consts.CARDS...)
	rand.Shuffle(len(cards), func(i, j int) {
		cards[i], cards[j] = cards[j], cards[i]
	})
	for _, client := range s.games[gameId].Players {
		for i := 0; i < (54-6)/s.games[gameId].PlayersNeeded; i++ {
			//s.logger.Info("sending cards")
			id := client.GetID()
			client.Send(&messages.Message{
				PlayerId: id,
				Data: &messages.Message_Card{
					Card: &messages.Card{
						Id: cards[0].File,
						Type: &messages.Card_Receive{
							Receive: &messages.Receive{},
						},
					},
				},
			})
			s.games[gameId].PlayerCards[id] = append(s.games[gameId].PlayerCards[id], Card{
				id:     cards[0].File,
				userId: id,
			})
			cards = helpers.Remove(cards, 0)
		}
	}
	game := s.games[gameId]
	for i := 0; i < 6; i++ {
		game.Talon = append(game.Talon, Card{
			id: cards[0].File,
		})
		cards = helpers.Remove(cards, 0)
	}
	s.games[gameId] = game
	s.logger.Debugw("talon", "talon", game.Talon)
}

func (s *serverImpl) Licitiranje(tip int32, gameId string, userId string) {
	game := s.games[gameId]
	if tip > game.Game {
		game.Game = tip
		game.Playing = userId
	}
	s.Broadcast("", &messages.Message{
		PlayerId: userId,
		GameId:   gameId,
		Data: &messages.Message_Licitiranje{
			Licitiranje: &messages.Licitiranje{
				Type: tip,
			},
		},
	})
	// TODO: fix user checking
	next := false
	for _, v := range game.Players {
		if next {
			licitiranjeMsg := messages.Message{
				PlayerId: v.GetID(),
				GameId:   gameId,
				Data:     &messages.Message_LicitiranjeStart{LicitiranjeStart: &messages.LicitiranjeStart{}},
			}
			v.Send(&licitiranjeMsg)
			next = false
			break
		}
		if v.GetID() == userId {
			next = true
		}
	}
	if next {
		// konc smo z licitiranjem, objavimo zadnje rezultate
		// in začnimo metat karte
		s.logger.Debugw("done with licitating, now starting playing the game", "gameId", gameId)
		msg := messages.Message{
			PlayerId: game.Playing,
			GameId:   gameId,
			Data:     &messages.Message_Card{Card: &messages.Card{Type: &messages.Card_Request{Request: &messages.Request{}}}},
		}
		game.Players[0].Send(&msg)
	}
}

func (s *serverImpl) returnCardToSender(id string, gameId string, userId string) {
	game := s.games[gameId]
	for _, v := range game.Players {
		if v.GetID() != userId {
			continue
		}
		v.Send(&messages.Message{
			PlayerId: userId,
			Data: &messages.Message_Card{
				Card: &messages.Card{
					Id: id,
					Type: &messages.Card_Receive{
						Receive: &messages.Receive{},
					},
				},
			},
		})
		v.Send(&messages.Message{
			PlayerId: userId,
			GameId:   gameId,
			Data:     &messages.Message_Card{Card: &messages.Card{Type: &messages.Card_Request{Request: &messages.Request{}}}},
		})
		return
	}
}

func (s *serverImpl) CardDrop(id string, gameId string, userId string) {
	game := s.games[gameId]
	// TODO: check user queue
	placedCard := helpers.ParseCardID(id)
	zadnjiStih := game.Stihi[len(game.Stihi)-1]
	if len(zadnjiStih) != 0 {
		card := helpers.ParseCardID(zadnjiStih[0].id)
		imaTarok := false
		imaBarvo := false
		imaKarto := false
		for _, v := range game.PlayerCards[userId] {
			t := helpers.ParseCardID(v.id)
			if t.Full == id {
				imaKarto = true
			}
			if t.Type == "taroki" {
				imaTarok = true
			} else if t.Type == card.Type {
				imaBarvo = true
			}
			if imaTarok && imaBarvo && imaKarto {
				break
			}
		}
		if !imaKarto {
			s.logger.Debugw("the player shall be removed from this game for using cheats", "gameId", gameId, "userId", userId)
			return
		}
		if imaBarvo && placedCard.Type != card.Type {
			s.returnCardToSender(id, gameId, userId)
			return
		} else if !imaBarvo && imaTarok && placedCard.Type != "taroki" {
			s.returnCardToSender(id, gameId, userId)
			return
		}
	}
	zadnjiStih = append(zadnjiStih, Card{
		id:     id,
		userId: userId,
	})
	game.Stihi[len(game.Stihi)-1] = zadnjiStih
	for i, v := range game.PlayerCards[userId] {
		if v.id == id {
			game.PlayerCards[userId] = helpers.Remove(game.PlayerCards[userId], i)
			break
		}
	}
	s.Broadcast("", &messages.Message{
		PlayerId: userId,
		GameId:   gameId,
		Data: &messages.Message_Card{
			Card: &messages.Card{
				Id: id,
				Type: &messages.Card_Send{
					Send: &messages.Send{},
				},
			},
		},
	})
	// obvestimo še naslednjega igralca, da naj vrže karto
	currentPlayer := 0
	for i, v := range game.Players {
		if v.GetID() == userId {
			currentPlayer = i
		}
	}
	currentPlayer++
	if currentPlayer >= game.PlayersNeeded {
		currentPlayer = 0
	}
	s.logger.Debugw("trenutni igralec", "p", currentPlayer, "stih", zadnjiStih, "len", len(game.Stihi))
	if len(zadnjiStih) >= game.PlayersNeeded {
		game.Stihi = append(game.Stihi, []Card{})
		t := time.Now()
		for {
			if time.Now().Sub(t).Seconds() > 1 {
				s.logger.Debugw("pucam štihe")
				s.Broadcast("", &messages.Message{
					PlayerId: userId,
					GameId:   gameId,
					Data: &messages.Message_ClearDesk{
						ClearDesk: &messages.ClearDesk{},
					},
				})
				break
			}
		}
	}
	game.Players[currentPlayer].Send(&messages.Message{
		PlayerId: userId,
		GameId:   gameId,
		Data:     &messages.Message_Card{Card: &messages.Card{Type: &messages.Card_Request{Request: &messages.Request{}}}},
	})
	s.games[gameId] = game
}

func (s *serverImpl) GetDB() sql.SQL {
	return s.db
}

func (s *serverImpl) NewGame(players int) string {
	UUID := uuid.NewString()
	s.games[UUID] = Game{
		PlayersNeeded: players,
		Players:       []Client{},
		cancel:        make(chan bool),
		Started:       false,
		Game:          -1,
		Playing:       "",
		Stihi:         [][]Card{{}},
		Talon:         []Card{},
		PlayerCards:   make(map[string][]Card),
	}
	return UUID
}

func (s *serverImpl) GetGames() []string {
	games := make([]string, 0)
	for v := range s.games {
		games = append(games, v)
	}
	return games
}

// Disconnect gives Run the data to disconnect client from the server
func (s *serverImpl) Disconnect(client Client) {
	s.disconnect <- client
}

func (s *serverImpl) handleDisconnect() {
	err := events.Subscribe("server.disconnect", s.Disconnect)
	if err != nil {
		s.logger.Warnw("cannot read from the client")
	}
}

func (s *serverImpl) Broadcast(excludeClient string, msg *messages.Message) {
	s.broadcast <- broadcastMessage{msg: msg, excludeClient: excludeClient}
}

func (s *serverImpl) handleBroadcast() {
	err := events.Subscribe("server.broadcast", s.Broadcast)
	if err != nil {
		s.logger.Warnw("cannot read from the client")
	}
}

func (s *serverImpl) sendPlayers(client Client) {
	s.logger.Debugw("sending client existing player list", "id", client.GetID())
	for _, cc := range s.games[client.GetGame()].Players {
		user := cc.GetUser()
		if client.GetID() == user.ID {
			continue
		}

		msg := &messages.Message{
			PlayerId: user.ID,
			Username: user.Name,
			Data: &messages.Message_Connection{
				Connection: &messages.Connection{
					Rating: int32(user.Rating),
					Type:   &messages.Connection_Join{Join: &messages.Connect{}},
				},
			},
		}

		client.Send(msg)
	}
}
