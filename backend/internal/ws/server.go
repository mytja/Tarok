package ws

import (
	"github.com/google/uuid"
	"github.com/mytja/Tarok/backend/internal/helpers"
	"github.com/mytja/Tarok/backend/internal/sql"
	"goji.io/pat"
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
	games      map[string]*Game
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

func NewServer(logger *zap.Logger, db sql.SQL) Server {
	return &serverImpl{
		logger:     logger.Sugar(),
		games:      make(map[string]*Game),
		db:         db,
		connect:    make(chan connectMessage, consts.ChanBufferSize),
		broadcast:  make(chan broadcastMessage, consts.ChanBufferSize),
		disconnect: make(chan Client, consts.ChanBufferSize),
	}
}

func (s *serverImpl) GetGame(gameId string) *Game {
	game, exists := s.games[gameId]
	if !exists {
		return nil
	}
	return game
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

			playerId := disconnect.GetUserID()
			gameId := disconnect.GetGame()

			game, exists := s.games[gameId]
			if !exists {
				continue
			}

			player, exists := game.Players[playerId]
			if !exists {
				continue
			}

			player.RemoveClient(disconnect.GetClientID())

			s.logger.Debugw("disconnected the user. now closing the connection")
			disconnect.Close()
			s.logger.Debugw("connection close now finished")
			//recover()

			p := 0
			for _, v := range game.Players {
				if len(v.GetClients()) == 0 {
					continue
				}
				p++
			}
			s.logger.Debugw("game count", "p", p)
			if p == 0 {
				s.EndGame(gameId)
				continue
			}

			if len(player.GetClients()) == 0 {
				if game.Started {
					// če se je igra že začela samo disconnectamo uporabnika - še vedno obdržimo vse njegove rezultate ipd., samo sporočimo
					// klientu, da igrajo z računalnikom
					msg := messages.Message{
						GameId:   gameId,
						PlayerId: playerId,
						Data:     &messages.Message_Connection{Connection: &messages.Connection{Rating: int32(disconnect.GetUser().Rating), Type: &messages.Connection_Disconnect{Disconnect: &messages.Disconnect{}}}},
					}

					s.logger.Debugw("broadcasting disconnect message to everybody in the game")
					s.Broadcast(playerId, &msg)
				} else {
					// igra se še ni začela, odstranimo uporabnika
					msg := messages.Message{
						GameId:   gameId,
						PlayerId: playerId,
						Data:     &messages.Message_Connection{Connection: &messages.Connection{Rating: int32(disconnect.GetUser().Rating), Type: &messages.Connection_Leave{Leave: &messages.Leave{}}}},
					}

					s.logger.Debugw("broadcasting leave message to everybody in the game")
					s.Broadcast(playerId, &msg)

					delete(game.Players, playerId)
				}
			}
			s.logger.Debugw("done disconnecting the user")
		case broadcast := <-s.broadcast:
			s.logger.Debugw("Broadcasting", "id", broadcast.excludeClient, "msg", broadcast.msg)

			game, exists := s.games[broadcast.msg.GameId]
			if !exists {
				continue
			}

			//broadcast.msg.PlayerId = broadcast.excludeClient
			for userId, user := range game.Players {
				if broadcast.excludeClient == userId {
					continue
				}
				user.BroadcastToClients(broadcast.msg)
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

	game, exists := s.games[gameId]
	if !exists {
		s.logger.Debugw("game has finished, it doesn't exist, exiting", "gameId", gameId)
		return
	}

	if len(game.Starts) == 0 {
		gStarts := make([]string, 0)
		for i := range game.Players {
			gStarts = append(gStarts, i)
		}
		game.Starts = gStarts
	}

	// resetiraj vse spremenljivke pri vseh User-jih
	for _, v := range game.Players {
		v.ResetGameVariables()
	}

	firstUser := game.Starts[0]
	game.Starts = helpers.RemoveOrdered(game.Starts, 0)
	game.Starts = append(game.Starts, firstUser)

	game.GameMode = -2
	game.GameEnd = make([]string, 0)
	game.Stihi = make([][]Card, 0)
	game.Stihi = append(game.Stihi, make([]Card, 0))
	game.Talon = []Card{}
	game.Playing = append([]string{}, game.Starts...)
	game.CardsStarted = false
	game.PlayingIn = ""
	game.KrogovLicitiranja = 0
	game.NaslednjiKrogPri = ""
	game.Stashed = make([]Card, 0)
	game.SinceLastPrediction = -1
	game.CurrentPredictions = &messages.Predictions{}

	s.logger.Debugw("game start", "stihi", game.Stihi, "playing", game.Playing, "starts", game.Starts)

	t := make([]*messages.User, 0)
	for i, k := range game.Starts {
		if !game.Players[k].GetBotStatus() && len(game.Players[k].GetClients()) == 0 {
			if game.Started {
				continue
			}
			// aborting start
			return
		}
		v := game.Players[k]
		game.Players[k].SetTimer(float64(game.StartTime))
		t = append(t, &messages.User{Name: v.GetUser().Name, Id: v.GetUser().ID, Position: int32(i)})
	}

	status := 0
	for _, k := range game.Starts {
		if !game.Players[k].GetBotStatus() && len(game.Players[k].GetClients()) != 0 {
			status++
		}
	}
	if status == 0 {
		s.EndGame(gameId)
		return
	}

	msg := messages.Message{
		GameId: gameId,
		Data:   &messages.Message_GameStart{GameStart: &messages.GameStart{User: t}},
	}
	s.Broadcast("", &msg)

	// poskusimo počakati, saj ne želimo da broadcast kart prehiti broadcast začetka igre
	// (messages.GameStart na klientu poskrbi za izbris arraya s kartami)
	// go je tok hiter da prehiteva dobesedno vse :)
	time.Sleep(time.Millisecond * 20)

	for _, k := range game.Starts {
		s.Broadcast("", &messages.Message{
			PlayerId: k,
			GameId:   gameId,
			Data:     &messages.Message_Time{Time: &messages.Time{CurrentTime: float32(game.Players[k].GetTimer())}},
		})
	}

	s.ShuffleCards(gameId)

	// game must be reinitialized after s.ShuffleCards(...)
	licitatesFirst := game.Players[game.Starts[0]]
	licitiranjeMsg := messages.Message{
		PlayerId: licitatesFirst.GetUser().ID,
		GameId:   gameId,
		Data:     &messages.Message_LicitiranjeStart{LicitiranjeStart: &messages.LicitiranjeStart{}},
	}
	licitatesFirst.BroadcastToClients(&licitiranjeMsg)

	game.Started = true

	s.BotGoroutineLicitiranje(gameId, licitatesFirst.GetUser().ID)
}

func (s *serverImpl) GameStartGoroutine(gameId string) {
	game, exists := s.games[gameId]
	if !exists {
		s.logger.Debugw("connected game doesn't exist")
		return
	}

	// začnimo igro
	start := time.Now()

	s.logger.Debugw("starting game", "gameId", gameId)

	go func() {
		for {
			game, exists = s.games[gameId]
			if !exists {
				s.logger.Errorw("game doesn't exist, exiting", "gameId", gameId)
				return
			}

			totalPlayers := 0
			for _, v := range game.Players {
				if v.GetBotStatus() || len(v.GetClients()) != 0 {
					totalPlayers++
					continue
				}
			}
			if totalPlayers < game.PlayersNeeded {
				s.logger.Debugw("cancelling game start", "gameId", gameId)
				s.Broadcast(
					"",
					&messages.Message{
						GameId: gameId,
						Data:   &messages.Message_GameStartCountdown{GameStartCountdown: &messages.GameStartCountdown{Countdown: 0}},
					},
				)
				return
			}
			if game.Started {
				s.logger.Debugw("game has already begun", "gameId", gameId)
				s.Broadcast(
					"",
					&messages.Message{
						GameId: gameId,
						Data:   &messages.Message_GameStartCountdown{GameStartCountdown: &messages.GameStartCountdown{Countdown: 0}},
					},
				)
				return
			}
			if time.Now().Sub(start) < 10*time.Second {
				s.Broadcast(
					"",
					&messages.Message{
						GameId: gameId,
						Data:   &messages.Message_GameStartCountdown{GameStartCountdown: &messages.GameStartCountdown{Countdown: int32(10 - time.Now().Sub(start).Seconds())}},
					},
				)
				time.Sleep(1 * time.Second)
			} else {
				s.StartGame(gameId)
				return
			}
		}
	}()
}

func (s *serverImpl) Authenticated(client Client) {
	gameId := client.GetGame()

	game, exists := s.games[gameId]
	if !exists {
		s.logger.Debugw("connected game doesn't exist")
		return
	}

	user := client.GetUser()
	id := user.ID

	if len(game.Players) >= game.PlayersNeeded {
		s.logger.Debugw("kicking authenticated user due to too many people in the game", "id", id, "gameId", gameId, "name", user.Name)
		return
	}

	s.logger.Debugw("successfully authenticated user", "id", id, "gameId", gameId, "name", user.Name)

	if game.Private && !(helpers.Contains(game.InvitedPlayers, user.ID) || game.Owner == user.ID) {
		s.logger.Debugw("kicking authenticated user due to him not being invited", "id", id, "gameId", gameId, "name", user.Name)
		return
	}

	c, exists := game.Players[id]
	if !exists {
		player := NewUser(id, user, s.logger)
		game.Players[id] = player
	}
	c = game.Players[id]
	c.NewClient(client)
	game.Players[id] = c

	s.sendPlayers(client)

	for userId := range game.Players {
		if userId != id {
			continue
		}
		// client is already in the game, resending the game assets
		game.Players[id].ResendCards(client.GetClientID())
		s.BroadcastOpenBeggarCards(gameId)
		s.RelayAllMessagesToClient(gameId, id, client.GetClientID())
		break
	}

	if len(game.Players[id].GetClients()) == 1 {
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
			// TODO: preveri kaj tole sploh dela tle
			if len(game.Players[k].GetClients()) == 0 {
				continue
			}
			v := game.Players[k]
			t = append(t, &messages.User{Name: v.GetUser().Name, Id: v.GetUser().ID, Position: int32(i)})
		}
		msg := messages.Message{
			GameId: gameId,
			Data:   &messages.Message_UserList{UserList: &messages.UserList{User: t}},
		}
		client.Send(&msg)
		w := game.WaitingFor
		if w == id {
			client.Send(&messages.Message{GameId: gameId, PlayerId: id, Data: &messages.Message_Card{Card: &messages.Card{Type: &messages.Card_Request{Request: &messages.Request{}}}}})
		}
		for _, v := range game.Stihi[len(game.Stihi)-1] {
			client.Send(&messages.Message{GameId: gameId, PlayerId: v.userId, Data: &messages.Message_Card{Card: &messages.Card{Id: v.id, UserId: v.userId, Type: &messages.Card_Send{Send: &messages.Send{}}}}})
		}
	}

	if len(game.Players) == game.PlayersNeeded && !game.Started {
		s.GameStartGoroutine(gameId)
	}
}

func (s *serverImpl) PlayingPicksUp(gameId string, stih []Card) bool {
	game, exists := s.games[gameId]
	if !exists {
		return false
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

	for u, user := range game.Players {
		imaKarto := user.ImaKarto(max)
		if !imaKarto {
			continue
		}
		pobral := helpers.Contains(game.Playing, u)
		s.logger.Debugw("štih", "max", max, "playing", game.Playing, "user", user, "stih", stih, "pickedUp", pobral)
		return pobral
	}

	return false
}

func (s *serverImpl) GetDB() sql.SQL {
	return s.db
}

func (s *serverImpl) NewGame(
	players int,
	tip string,
	private bool,
	owner string,
	additionalTime float64,
	startTime int,
	skisfang bool,
	mondfang bool,
	napovedanMondfang bool,
) string {
	UUID := uuid.NewString()
	s.games[UUID] = &Game{
		PlayersNeeded:     players,
		Players:           make(map[string]User),
		Started:           false,
		GameMode:          -1,
		Playing:           make([]string, 0),
		Stihi:             [][]Card{{}},
		Talon:             []Card{},
		WaitingFor:        "",
		CardsStarted:      false,
		EndTimer:          make(chan bool),
		AdditionalTime:    additionalTime,
		StartTime:         startTime,
		Chat:              make([]*messages.ChatMessage, 0),
		Type:              tip,
		Private:           private,
		Owner:             owner,
		InvitedPlayers:    make([]string, 0),
		MondfangRadelci:   mondfang,
		KazenZaKontro:     false,
		IzgubaSkisa:       skisfang,
		NapovedanMondfang: napovedanMondfang,
		KrogovLicitiranja: 0,
		NaslednjiKrogPri:  "",
	}
	return UUID
}

type GameDescriptor struct {
	ID                string
	AdditionalTime    float64
	StartTime         int
	Type              string
	Private           bool
	RequiredPlayers   int
	Users             []SimpleUser
	Started           bool
	Skisfang          bool
	MondfangRadelci   bool
	NapovedanMondfang bool
	KontraKazen       bool
}

type SimpleUser struct {
	ID   string
	Name string
}

func (s *serverImpl) GetGames(userId string) ([]GameDescriptor, []GameDescriptor) {
	games := make([]GameDescriptor, 0)
	priorityGames := make([]GameDescriptor, 0)
	for i, v := range s.games {
		if v.Started && !helpers.Contains(v.Starts, userId) {
			continue
		}

		players := make([]SimpleUser, 0)
		for _, p := range v.Players {
			if !p.GetBotStatus() && len(p.GetClients()) == 0 {
				continue
			}
			players = append(players, SimpleUser{
				ID:   p.GetUser().ID,
				Name: p.GetUser().Name,
			})
		}
		desc := GameDescriptor{
			ID:                i,
			StartTime:         v.StartTime,
			AdditionalTime:    v.AdditionalTime,
			Type:              v.Type,
			Private:           v.Private,
			RequiredPlayers:   v.PlayersNeeded,
			Started:           v.Started,
			Users:             players,
			Skisfang:          v.IzgubaSkisa,
			MondfangRadelci:   v.MondfangRadelci,
			NapovedanMondfang: v.NapovedanMondfang,
			KontraKazen:       v.KazenZaKontro,
		}
		if v.Private {
			if !helpers.Contains(v.InvitedPlayers, userId) {
				continue
			}
			priorityGames = append(priorityGames, desc)
			continue
		}
		games = append(games, desc)
	}
	return games, priorityGames
}

func (s *serverImpl) GetMatch(players int, tip string, user sql.User) string {
	for k, v := range s.games {
		s.logger.Debugw("match", "key", k, "playersNeeded", v.PlayersNeeded, "players", players, "playerMap", v.Players, "playerMapLen", len(v.Players))
		if players != v.PlayersNeeded {
			continue
		}
		if tip != v.Type {
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
	game, exists := s.games[client.GetGame()]
	if !exists {
		return
	}

	s.logger.Debugw("sending client existing player list", "id", client.GetUserID())
	sent := make([]string, 0)

	for _, user := range game.Players {
		if len(user.GetClients()) == 0 {
			continue
		}

		if client.GetUserID() == user.GetUser().ID {
			continue
		}

		if helpers.Contains(sent, user.GetUser().ID) {
			// ne rabmo pošiljat če se je prjavu z dvema napravama
			continue
		}

		sent = append(sent, user.GetUser().ID)

		msg := &messages.Message{
			PlayerId: user.GetUser().ID,
			Username: user.GetUser().Name,
			Data: &messages.Message_Connection{
				Connection: &messages.Connection{
					Rating: int32(user.GetUser().Rating),
					Type:   &messages.Connection_Join{Join: &messages.Connect{}},
				},
			},
		}

		client.Send(msg)
	}
}
