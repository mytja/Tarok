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
			s.logger.Infow("disconnect", "id", disconnect.GetUserID(), "remoteAddr", disconnect.GetRemoteAddr())
			for i, v := range s.games[disconnect.GetGame()].Players[disconnect.GetUserID()] {
				if v.GetClientID() != disconnect.GetClientID() {
					continue
				}
				s.games[disconnect.GetGame()].Players[disconnect.GetUserID()] = helpers.Remove(s.games[disconnect.GetGame()].Players[disconnect.GetUserID()], i)
				break
			}
			s.logger.Debugw("disconnected the user. now closing the connection")
			disconnect.Close()
			s.logger.Debugw("connection close now finished")
			//recover()

			// Notify all other players
			playerId := disconnect.GetUserID()
			msg := messages.Message{
				GameId:   disconnect.GetGame(),
				PlayerId: playerId,
				Data:     &messages.Message_Connection{Connection: &messages.Connection{Rating: int32(disconnect.GetUser().Rating), Type: &messages.Connection_Disconnect{Disconnect: &messages.Disconnect{}}}},
			}

			s.logger.Debugw("broadcasting disconnect message to everybody in the game")
			if len(s.games[disconnect.GetGame()].Players[playerId]) == 0 {
				s.Broadcast(playerId, &msg)
			}
			if len(s.games[disconnect.GetGame()].Players)+1 == s.games[disconnect.GetGame()].PlayersNeeded {
				s.logger.Debugw("cancelling the game start", "gameId", disconnect.GetGame(), "id", disconnect.GetUserID(), "game", s.games[disconnect.GetGame()])
				s.games[disconnect.GetGame()].cancel <- true
			}
			s.logger.Debugw("done disconnecting the user")
		case broadcast := <-s.broadcast:
			s.logger.Debugw("Broadcasting", "id", broadcast.excludeClient, "msg", broadcast.msg)
			//broadcast.msg.PlayerId = broadcast.excludeClient
			for userId, clients := range s.games[broadcast.msg.GameId].Players {
				if broadcast.excludeClient == userId {
					continue
				}

				for _, client := range clients {
					client.Send(broadcast.msg)
				}
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

func (s *serverImpl) StartGame(gameId string) {
	s.logger.Debugw("game started. sending GameStart packet", "gameId", gameId)
	gStarts := make([]string, 0)
	for i := range s.games[gameId].Players {
		gStarts = append(gStarts, i)
	}
	game := s.games[gameId]
	game.Playing = []string{}
	game.PlayerCards = make(map[string][]Card)
	game.PlayerCardsArchive = make(map[string][]Card)
	game.Game = -2
	game.Stihi = make([][]Card, 0)
	game.Stihi = append(game.Stihi, make([]Card, 0))
	game.Starts = gStarts
	game.Talon = []Card{}
	s.games[gameId] = game
	s.logger.Debug(game.Stihi)
	t := make([]*messages.User, 0)
	for i, k := range s.games[gameId].Starts {
		if len(s.games[gameId].Players[k]) == 0 {
			// aborting start
			return
		}
		v := s.games[gameId].Players[k][0]
		t = append(t, &messages.User{Name: v.GetUser().Name, Id: v.GetUserID(), Position: int32(i)})
	}
	msg := messages.Message{
		GameId: gameId,
		Data:   &messages.Message_GameStart{GameStart: &messages.GameStart{User: t}},
	}
	s.Broadcast("", &msg)

	// Shuffle
	cards := make([]consts.Card, 0)
	cards = append(cards, consts.CARDS...)
	rand.Shuffle(len(cards), func(i, j int) {
		cards[i], cards[j] = cards[j], cards[i]
	})
	for _, userId := range game.Starts {
		for i := 0; i < (54-6)/game.PlayersNeeded; i++ {
			for _, client := range game.Players[userId] {
				client.Send(&messages.Message{
					PlayerId: userId,
					Data: &messages.Message_Card{
						Card: &messages.Card{
							Id: cards[0].File,
							Type: &messages.Card_Receive{
								Receive: &messages.Receive{},
							},
						},
					},
				})
			}
			game.PlayerCards[userId] = append(game.PlayerCards[userId], Card{
				id:     cards[0].File,
				userId: userId,
			})
			cards = helpers.Remove(cards, 0)
		}
	}
	archive := make(map[string][]Card)
	for k, v := range game.PlayerCards {
		archive[k] = append(make([]Card, 0), v...)
	}
	game.PlayerCardsArchive = archive
	for i := 0; i < 6; i++ {
		game.Talon = append(game.Talon, Card{
			id: cards[0].File,
		})
		cards = helpers.Remove(cards, 0)
	}
	s.logger.Debugw("talon", "talon", game.Talon, "cards", game.PlayerCards)

	// game must be reinitialized after s.ShuffleCards(...)
	licitatesFirst := game.Players[game.Starts[0]]
	for _, v := range licitatesFirst {
		licitiranjeMsg := messages.Message{
			PlayerId: v.GetUserID(),
			GameId:   gameId,
			Data:     &messages.Message_LicitiranjeStart{LicitiranjeStart: &messages.LicitiranjeStart{}},
		}
		v.Send(&licitiranjeMsg)
	}
	game.Started = true
	s.games[gameId] = game
}

func (s *serverImpl) Authenticated(client Client) {
	gameId := client.GetGame()

	if _, exists := s.games[gameId]; !exists {
		s.logger.Debugw("connected game doesn't exist")
		return
	}

	id := client.GetUserID()
	user := client.GetUser()

	if len(s.games[gameId].Players) > s.games[gameId].PlayersNeeded {
		s.logger.Debugw("kicking authenticated user due to too many people in the game", "id", id, "gameId", gameId, "name", user.Name)
		return
	}

	s.logger.Debugw("successfully authenticated user", "id", id, "gameId", gameId, "name", user.Name)

	game := s.games[gameId]
	for userId := range game.Players {
		if userId == id {
			// client is already in the game, resending the game assets
			for _, c := range game.PlayerCards[id] {
				client.Send(&messages.Message{
					PlayerId: id,
					Data: &messages.Message_Card{
						Card: &messages.Card{
							Id: c.id,
							Type: &messages.Card_Receive{
								Receive: &messages.Receive{},
							},
						},
					},
				})
			}
		}
	}

	c, exists := game.Players[id]
	if !exists {
		c = make([]Client, 0)
	}
	c = append(c, client)
	s.games[gameId].Players[id] = c

	s.sendPlayers(client)

	if len(game.Players[id]) == 1 {
		// we only broadcast that the user exists
		// we don't broadcast if another client has connected
		s.Broadcast(client.GetUserID(), &messages.Message{
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
	}

	// TODO: licitiranje fallback
	if game.Started {
		t := make([]*messages.User, 0)
		for i, k := range game.Starts {
			v := game.Players[k][0]
			t = append(t, &messages.User{Name: v.GetUser().Name, Id: v.GetUserID(), Position: int32(i)})
		}
		msg := messages.Message{
			GameId: gameId,
			Data:   &messages.Message_UserList{UserList: &messages.UserList{User: t}},
		}
		client.Send(&msg)
		w := game.WaitingFor
		if game.Starts[w] == id {
			client.Send(&messages.Message{GameId: gameId, PlayerId: id, Data: &messages.Message_Card{Card: &messages.Card{Type: &messages.Card_Request{Request: &messages.Request{}}}}})
		}
		for _, v := range game.Stihi[len(game.Stihi)-1] {
			client.Send(&messages.Message{GameId: gameId, PlayerId: v.userId, Data: &messages.Message_Card{Card: &messages.Card{Id: v.id, Type: &messages.Card_Send{Send: &messages.Send{}}}}})
		}
	}

	if len(s.games[gameId].Players) == s.games[gameId].PlayersNeeded && !s.games[gameId].Started {
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
				if s.games[gameId].Started {
					return
				}
				if time.Now().Sub(start).Seconds() > 10 {
					s.StartGame(gameId)
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

}

func (s *serverImpl) Licitiranje(tip int32, gameId string, userId string) {
	game := s.games[gameId]
	if tip > game.Game || (tip >= game.Game && game.Starts[len(game.Starts)-1] == userId) {
		game.Game = tip
		game.Playing = []string{userId}
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
	for _, uid := range game.Starts {
		if next {
			for _, v := range game.Players[uid] {
				licitiranjeMsg := messages.Message{
					PlayerId: v.GetUserID(),
					GameId:   gameId,
					Data:     &messages.Message_LicitiranjeStart{LicitiranjeStart: &messages.LicitiranjeStart{}},
				}
				v.Send(&licitiranjeMsg)
			}
			next = false
			break
		}
		if uid == userId {
			next = true
		}
	}
	if next {
		// konc smo z licitiranjem, objavimo zadnje rezultate
		// in začnimo metat karte
		s.logger.Debugw("done with licitating, now starting playing the game", "gameId", gameId)
		msg := messages.Message{
			PlayerId: game.Starts[0],
			GameId:   gameId,
			Data:     &messages.Message_Card{Card: &messages.Card{Type: &messages.Card_Request{Request: &messages.Request{}}}},
		}
		for _, v := range game.Players[game.Starts[0]] {
			v.Send(&msg)
		}
	}
	s.games[gameId] = game
}

func (s *serverImpl) returnCardToSender(id string, gameId string, userId string, clientId string) {
	game := s.games[gameId]
	for _, v := range game.Players[userId] {
		if v.GetClientID() != clientId {
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

func (s *serverImpl) CardDrop(id string, gameId string, userId string, clientId string) {
	game := s.games[gameId]
	// TODO: check user queue
	placedCard := helpers.ParseCardID(id)
	zadnjiStih := game.Stihi[len(game.Stihi)-1]
	if len(zadnjiStih) != 0 {
		s.logger.Debugw("cards", "cards", game.PlayerCards[userId], "len", len(game.PlayerCards[userId]))
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
		s.logger.Debugw("player cards", "userId", userId, "cardId", id)
		if !imaKarto {
			s.logger.Debugw("the player shall be removed from this game for using cheats", "gameId", gameId, "userId", userId)
			return
		}
		if imaBarvo && placedCard.Type != card.Type {
			s.returnCardToSender(id, gameId, userId, clientId)
			return
		} else if !imaBarvo && imaTarok && placedCard.Type != "taroki" {
			s.returnCardToSender(id, gameId, userId, clientId)
			return
		}
	} else {
		// TODO: preveri če ma uporabnik sploh karto
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
	for i, v := range game.Starts {
		if v == userId {
			currentPlayer = i
			break
		}
	}
	currentPlayer++
	if currentPlayer >= game.PlayersNeeded {
		currentPlayer = 0
	}
	game.WaitingFor = currentPlayer

	s.logger.Debugw(
		"trenutni igralec",
		"p", currentPlayer,
		"stih", zadnjiStih,
		"len", len(game.Stihi),
		"cards", game.PlayerCards[userId],
		"allCards", game.PlayerCards,
		"needed", game.PlayersNeeded,
	)
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
	if len(zadnjiStih) >= game.PlayersNeeded {
		max := zadnjiStih[0].id
		for _, v := range zadnjiStih {
			c1 := consts.Card{}
			c2 := consts.Card{}
			for _, v2 := range consts.CARDS {
				if v2.File == v.id {
					c1 = v2
				}
				if v2.File == max {
					c2 = v2
				}
			}
			if c1.WorthOver > c2.WorthOver {
				max = v.id
			}
		}
		for _, v := range zadnjiStih {
			if v.id != max {
				continue
			}
			for i, client := range game.Players[v.userId] {
				game.WaitingFor = i
				client.Send(&messages.Message{
					PlayerId: userId,
					GameId:   gameId,
					Data:     &messages.Message_Card{Card: &messages.Card{Type: &messages.Card_Request{Request: &messages.Request{}}}},
				})
			}
		}
	} else {
		for _, client := range game.Players[game.Starts[currentPlayer]] {
			client.Send(&messages.Message{
				PlayerId: userId,
				GameId:   gameId,
				Data:     &messages.Message_Card{Card: &messages.Card{Type: &messages.Card_Request{Request: &messages.Request{}}}},
			})
		}
	}

	s.games[gameId] = game

	if len(zadnjiStih) >= game.PlayersNeeded && len(game.Stihi) > (54-6)/game.PlayersNeeded {
		// pogledamo, če je zadnji štih, da proglasimo rezultate
		totalPlaying := 0
		totalNotPlaying := 0
		playing := 0
		playingCount := 0
		notPlaying := 0
		notPlayingCount := 0
		for _, stih := range game.Stihi {
			if len(stih) == 0 {
				s.logger.Debugw("skipping empty deck")
				continue
			}
			max := stih[0].id
			for _, v := range stih {
				c1 := consts.Card{}
				c2 := consts.Card{}
				for _, v2 := range consts.CARDS {
					if v2.File == v.id {
						c1 = v2
					}
					if v2.File == max {
						c2 = v2
					}
				}
				id1 := helpers.ParseCardID(c1.File)
				id2 := helpers.ParseCardID(c1.File)
				// položena karta mora biti:
				// 1. tarok
				// 2. istega tipa (da če je oseba brez tarokov, slučajno ne pobere platelce druge barve)
				if c1.WorthOver > c2.WorthOver && (id1.Type == "taroki" || (id1.Type == id2.Type)) {
					max = v.id
				}
			}

			playingPickedUp := false

			for user := range game.Players {
				found := false
				for _, v := range game.PlayerCardsArchive[user] {
					if v.id != max {
						continue
					}
					s.logger.Debugw("štih", "max", max, "playing", game.Playing, "user", user, "stih", stih, "playingPickedUp", playingPickedUp, "totalPlaying", totalPlaying, "totalNotPlaying", totalNotPlaying)
					found = true
					if helpers.Contains(game.Playing, user) {
						playingPickedUp = true
					}
					break
				}
				if found {
					break
				}
			}

			for _, v := range stih {
				for _, v2 := range consts.CARDS {
					if v2.File != v.id {
						continue
					}
					if playingPickedUp {
						playing += v2.Worth
						playingCount++
					} else {
						notPlaying += v2.Worth
						notPlayingCount++
					}
					if notPlayingCount == 3 {
						totalNotPlaying += notPlaying - (notPlayingCount - 1)
						notPlaying = 0
						notPlayingCount = 0
					}
					if playingCount == 3 {
						totalPlaying += playing - (playingCount - 1)
						playing = 0
						playingCount = 0
					}
					break
				}
			}
		}
		// še zadnje preostale karte v štetju
		if notPlayingCount != 0 {
			totalNotPlaying += notPlaying - (notPlayingCount - 1)
			notPlaying = 0
			notPlayingCount = 0
		}

		if playingCount != 0 {
			totalPlaying += playing - (playingCount - 1)
			playing = 0
			playingCount = 0
		}

		users := make([]*messages.ResultsUser, 0)

		for user, clients := range game.Players {
			client := clients[0].GetUser()
			p := helpers.Contains(game.Playing, user)
			s.logger.Debugw("playing", "playing", game.Playing, "user", user, "client", client, "p", p, "playing", p)
			points := 0
			if p {
				worth := 0
				for _, v := range consts.GAMES {
					if v.ID == game.Game {
						worth = v.Worth
						break
					}
				}
				points = totalPlaying - 35
				if points > 0 {
					points += worth
				} else {
					points -= worth
				}
			}
			user := &messages.ResultsUser{
				User: &messages.User{
					Id:   client.ID,
					Name: client.Name,
				},
				Points:  int32(points),
				Playing: p,
			}
			users = append(users, user)
		}

		s.Broadcast("", &messages.Message{
			GameId: gameId,
			Data:   &messages.Message_Results{Results: &messages.Results{User: users}},
		})

		s.StartGame(gameId)
	}
}

func (s *serverImpl) GetDB() sql.SQL {
	return s.db
}

func (s *serverImpl) NewGame(players int) string {
	UUID := uuid.NewString()
	s.games[UUID] = Game{
		PlayersNeeded: players,
		Players:       make(map[string][]Client),
		cancel:        make(chan bool),
		Started:       false,
		Game:          -1,
		Playing:       make([]string, 0),
		Stihi:         [][]Card{{}},
		Talon:         []Card{},
		PlayerCards:   make(map[string][]Card),
		WaitingFor:    0,
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

func (s *serverImpl) GetMatch(players int, user sql.User) string {
	for k, v := range s.games {
		s.logger.Debugw("match", "key", k, "playersNeeded", v.PlayersNeeded, "players", players, "playerMap", v.Players, "playerMapLen", len(v.Players))
		if players != v.PlayersNeeded {
			continue
		}

		containsPlayer := false
		for i := range v.Players {
			if i == user.ID {
				containsPlayer = true
				break
			}
		}

		if containsPlayer {
			return k
		}

		if v.PlayersNeeded > len(v.Players) {
			return k
		}
	}
	return "CREATE"
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
	s.logger.Debugw("sending client existing player list", "id", client.GetUserID())
	sent := make([]string, 0)

	for _, clients := range s.games[client.GetGame()].Players {
		if len(clients) == 0 {
			continue
		}
		user := clients[0].GetUser()

		if client.GetUserID() == user.ID {
			continue
		}

		if helpers.Contains(sent, user.ID) {
			// ne rabmo pošiljat če se je prjavu z dvema napravama
			continue
		}
		sent = append(sent, user.ID)

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
