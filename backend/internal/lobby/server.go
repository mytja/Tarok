package lobby

import (
	"errors"
	"fmt"
	"github.com/gorilla/websocket"
	"github.com/mytja/Tarok/backend/internal/helpers"
	"github.com/mytja/Tarok/backend/internal/lobby_messages"
	"github.com/mytja/Tarok/backend/internal/sql"
	"github.com/mytja/Tarok/backend/internal/ws"
	"go.uber.org/zap"
	"net/http"
	"os"
	"time"

	"github.com/mytja/Tarok/backend/internal/consts"
	"github.com/mytja/Tarok/backend/internal/events"
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
	db         sql.SQL
	connect    chan connectMessage
	disconnect chan Client
	broadcast  chan *lobby_messages.LobbyMessage
	gameServer ws.Server
	clients    []Client
}

// connectMessage is used to send the connect message
type connectMessage struct {
	conn *websocket.Conn
	user sql.User
	done chan Client
}

func NewLobbyServer(logger *zap.Logger, db sql.SQL, gameServer ws.Server) Server {
	return &serverImpl{
		logger:     logger.Sugar(),
		db:         db,
		connect:    make(chan connectMessage, consts.ChanBufferSize),
		broadcast:  make(chan *lobby_messages.LobbyMessage, consts.ChanBufferSize),
		disconnect: make(chan Client, consts.ChanBufferSize),
		clients:    make([]Client, 0),
		gameServer: gameServer,
	}
}

// Run is used for connecting and disconnecting clients from the server
func (s *serverImpl) Run() {
	s.logger.Debug("server started and listening for events")
	s.handleBroadcast()
	s.handleEvents()
	s.handleDisconnect()
	for {
		select {
		case connect := <-s.connect:
			s.logger.Infow("new connection to lobby", "remoteAddr", connect.conn.RemoteAddr())
			client := NewClient(connect.user, connect.conn, s, s.logger.Desugar())
			connect.done <- client
		case disconnect := <-s.disconnect:
			s.logger.Infow("disconnect", "id", disconnect.GetUserID(), "remoteAddr", disconnect.GetRemoteAddr())

			clientId := disconnect.GetClientID()

			s.logger.Debugw("disconnected the user. now closing the connection")
			disconnect.Close()
			s.logger.Debugw("connection close now finished")

			for i, v := range s.clients {
				if v.GetClientID() != clientId {
					continue
				}
				s.clients = helpers.Remove(s.clients, i)
			}

			// če je v igri, naj prvo pošljemo sporočilo onlineStatus=1, nato ga pa še čisto do konca disconnectamo
			time.Sleep(100 * time.Millisecond)
			events.Publish("lobby.onlineStatus", disconnect.GetUserID(), int32(0))

			s.logger.Debugw("done disconnecting the user")
		case broadcast := <-s.broadcast:
			s.logger.Debugw("Broadcasting to lobby", "msg", broadcast)

			//broadcast.msg.PlayerId = broadcast.excludeClient
			for _, client := range s.clients {
				s.logger.Debugw("found client to broadcast message to", "clientId", client.GetClientID())
				client.Send(broadcast)
			}
		}
	}
}

// Connect gives Run the data to connect the client and starts functions ReadPump and SendPump
func (s *serverImpl) Connect(w http.ResponseWriter, r *http.Request) Client {
	conn, err := socketUpgrader.Upgrade(w, r, nil)
	if err != nil {
		//s.logger.Errorw("error while upgrading connection", zap.Error(err))
		return nil
	}

	done := make(chan Client)
	s.connect <- connectMessage{conn: conn, done: done}
	s.logger.Info("successfully sent connectMessage to s.connect channel")
	client := <-done
	s.clients = append(s.clients, client)
	go client.ReadPump()
	go client.SendPump()

	client.Send(&lobby_messages.LobbyMessage{Data: &lobby_messages.LobbyMessage_LoginRequest{LoginRequest: &lobby_messages.LoginRequest{}}})

	return client
}

func (s *serverImpl) TransformGameDescriptors(client Client, games []ws.GameDescriptor, priority bool) {
	for _, v := range games {
		users := make([]*lobby_messages.Player, 0)
		for _, k := range v.Users {
			users = append(users, &lobby_messages.Player{
				Id:     k.ID,
				Name:   k.Name,
				Rating: 1000,
			})
		}
		s.logger.Debugw("sending a game to lobby user", "game", v)
		client.Send(&lobby_messages.LobbyMessage{Data: &lobby_messages.LobbyMessage_GameCreated{GameCreated: &lobby_messages.GameCreated{
			GameId:            v.ID,
			Players:           users,
			MondfangRadelci:   v.MondfangRadelci,
			Skisfang:          v.Skisfang,
			NapovedanMondfang: v.NapovedanMondfang,
			KontraKazen:       v.KontraKazen,
			TotalTime:         int32(v.StartTime),
			AdditionalTime:    float32(v.AdditionalTime),
			Type:              v.Type,
			RequiredPlayers:   int32(v.RequiredPlayers),
			Started:           v.Started,
			Private:           v.Private,
			Priority:          priority,
		}}})
	}
}

func (s *serverImpl) GameStartMessage(gameId string, players []string) {
	for _, v := range s.clients {
		if helpers.Contains(players, v.GetUserID()) {
			v.Send(&lobby_messages.LobbyMessage{
				Data: &lobby_messages.LobbyMessage_GameMove{
					GameMove: &lobby_messages.GameMove{
						GameId:   gameId,
						Priority: true,
					},
				},
			})
		} else {
			v.Send(&lobby_messages.LobbyMessage{
				Data: &lobby_messages.LobbyMessage_GameDisbanded{
					GameDisbanded: &lobby_messages.GameDisbanded{
						GameId: gameId,
					},
				},
			})
		}
	}
}

func (s *serverImpl) Invite(gameId string, playerId string) {
	for _, v := range s.clients {
		if v.GetUserID() != playerId {
			continue
		}
		game := s.gameServer.GetGame(gameId)
		if game == nil {
			continue
		}
		if game.Private {
			players := make([]*lobby_messages.Player, 0)
			for _, v := range game.Players {
				players = append(players, &lobby_messages.Player{
					Id:     v.GetUser().ID,
					Name:   v.GetUser().Name,
					Rating: int32(v.GetUser().Rating),
				})
			}
			v.Send(&lobby_messages.LobbyMessage{
				Data: &lobby_messages.LobbyMessage_GameCreated{
					GameCreated: &lobby_messages.GameCreated{
						GameId:            gameId,
						Players:           players,
						MondfangRadelci:   game.MondfangRadelci,
						Skisfang:          game.IzgubaSkisa,
						NapovedanMondfang: game.NapovedanMondfang,
						KontraKazen:       game.KazenZaKontro,
						TotalTime:         int32(game.StartTime),
						AdditionalTime:    float32(game.AdditionalTime),
						Type:              game.Type,
						RequiredPlayers:   int32(game.PlayersNeeded),
						Started:           game.Started,
						Private:           game.Private,
						Priority:          true,
					},
				},
			})
		} else {
			v.Send(&lobby_messages.LobbyMessage{
				Data: &lobby_messages.LobbyMessage_GameMove{
					GameMove: &lobby_messages.GameMove{
						GameId:   gameId,
						Priority: true,
					},
				},
			})
		}
		v.Send(&lobby_messages.LobbyMessage{
			Data: &lobby_messages.LobbyMessage_GameInvite{
				GameInvite: &lobby_messages.GameInvite{
					GameId: gameId,
				},
			},
		})
	}
}

func (s *serverImpl) ChangeOnlineStatus(playerId string, status int32) {
	friends, err := s.db.GetFriends(playerId)
	if err != nil {
		return
	}

	f := make([]string, 0)
	for _, v := range friends {
		if v.User1 == playerId {
			f = append(f, v.User2)
			continue
		}
		f = append(f, v.User1)
	}

	for _, v := range s.clients {
		if !helpers.Contains(f, v.GetUserID()) {
			continue
		}
		v.Send(&lobby_messages.LobbyMessage{
			PlayerId: playerId,
			Data: &lobby_messages.LobbyMessage_FriendOnlineStatus{
				FriendOnlineStatus: &lobby_messages.FriendOnlineStatus{
					Status: status,
				},
			},
		})
	}
}

func (s *serverImpl) Authenticated(client Client) {
	user := client.GetUser()
	id := user.ID

	s.logger.Debugw("successfully authenticated user", "id", id, "name", user.Name)

	games, priorityGames := s.gameServer.GetGames(id)
	s.TransformGameDescriptors(client, games, false)
	s.TransformGameDescriptors(client, priorityGames, true)

	events.Publish("lobby.onlineStatus", id, int32(1))

	friends, err := s.db.GetFriends(id)
	if err != nil {
		s.logger.Debugw("get friends failed", "userId", user.ID, "err", err)
		return
	}
	allFriends := make([]string, 0)
	for _, v := range friends {
		if id == v.User1 {
			allFriends = append(allFriends, v.User2)
		} else {
			allFriends = append(allFriends, v.User1)
		}
	}

	inGame := make([]string, 0)
	online := make([]string, 0)

	for _, v := range s.clients {
		if !helpers.Contains(allFriends, v.GetUserID()) {
			continue
		}
		if helpers.Contains(online, v.GetUserID()) {
			continue
		}
		online = append(online, v.GetUserID())
	}

	for _, v := range s.gameServer.GetInGamePlayers() {
		if !helpers.Contains(allFriends, v) {
			continue
		}
		if helpers.Contains(inGame, v) {
			continue
		}
		inGame = append(inGame, v)
	}

	/*for _, v := range online {
		client.Send(&lobby_messages.LobbyMessage{PlayerId: v, Data: &lobby_messages.LobbyMessage_FriendOnlineStatus{FriendOnlineStatus: &lobby_messages.FriendOnlineStatus{Status: 1}}})
	}*

	/*for _, v := range inGame {
		client.Send(&lobby_messages.LobbyMessage{PlayerId: v, Data: &lobby_messages.LobbyMessage_FriendOnlineStatus{FriendOnlineStatus: &lobby_messages.FriendOnlineStatus{Status: 2}}})
	}*/

	for _, v := range friends {
		var uid string
		if id == v.User1 {
			uid = v.User2
		} else {
			uid = v.User1
		}

		user, err := s.db.GetUser(uid)
		if err != nil {
			continue
		}

		t := 0
		if helpers.Contains(online, uid) {
			t = 1
		}
		if helpers.Contains(inGame, uid) {
			t = 2
		}

		exists := true
		if _, err := os.Stat(fmt.Sprintf("profile_pictures/%s.webp", uid)); errors.Is(err, os.ErrNotExist) {
			exists = false
		}

		client.Send(&lobby_messages.LobbyMessage{
			PlayerId: uid,
			Data: &lobby_messages.LobbyMessage_Friend{
				Friend: &lobby_messages.Friend{
					Status:               int32(t),
					Name:                 user.Name,
					Handle:               user.Handle,
					Id:                   v.ID,
					Data:                 &lobby_messages.Friend_Connected_{Connected: &lobby_messages.Friend_Connected{}},
					CustomProfilePicture: exists,
				},
			},
		})
	}

	outgoingFriends, err := s.db.GetOutgoingFriends(id)
	if err != nil {
		return
	}
	for _, v := range outgoingFriends {
		user, err := s.db.GetUser(v.User2)
		if err != nil {
			continue
		}

		exists := true
		if _, err := os.Stat(fmt.Sprintf("profile_pictures/%s.webp", user.ID)); errors.Is(err, os.ErrNotExist) {
			exists = false
		}

		client.Send(&lobby_messages.LobbyMessage{
			PlayerId: v.User2,
			Data: &lobby_messages.LobbyMessage_Friend{
				Friend: &lobby_messages.Friend{
					Status:               0,
					Name:                 user.Name,
					Handle:               user.Handle,
					Id:                   v.ID,
					Data:                 &lobby_messages.Friend_Outgoing_{Outgoing: &lobby_messages.Friend_Outgoing{}},
					CustomProfilePicture: exists,
				},
			},
		})
	}

	incomingFriends, err := s.db.GetIncomingFriends(id)
	if err != nil {
		return
	}
	for _, v := range incomingFriends {
		user, err := s.db.GetUser(v.User1)
		if err != nil {
			continue
		}

		exists := true
		if _, err := os.Stat(fmt.Sprintf("profile_pictures/%s.webp", user.ID)); errors.Is(err, os.ErrNotExist) {
			exists = false
		}

		client.Send(&lobby_messages.LobbyMessage{
			PlayerId: v.User1,
			Data: &lobby_messages.LobbyMessage_Friend{
				Friend: &lobby_messages.Friend{
					Status:               0,
					Name:                 user.Name,
					Handle:               user.Handle,
					Id:                   v.ID,
					Data:                 &lobby_messages.Friend_Incoming_{Incoming: &lobby_messages.Friend_Incoming{}},
					CustomProfilePicture: exists,
				},
			},
		})
	}

	replays, err := s.db.GetGamesByUserID(id)
	if err != nil {
		return
	}

	for _, v := range replays {
		client.Send(&lobby_messages.LobbyMessage{
			Data: &lobby_messages.LobbyMessage_Replay{
				Replay: &lobby_messages.Replay{
					Url:       fmt.Sprintf("https://palcka.si/replay/%s?password=%s", v.GameID, v.Password),
					GameId:    v.GameID,
					CreatedAt: v.CreatedAt,
				},
			},
		})
	}
}

func (s *serverImpl) KickPlayer(playerId string) {
	for _, v := range s.clients {
		if v.GetUserID() != playerId {
			continue
		}
		s.disconnect <- v
	}
}

func (s *serverImpl) NewPrivateGame(gameId string, playerId string) {
	game := s.gameServer.GetGame(gameId)
	if game == nil {
		s.logger.Errorw("game doesn't exist", "gameId", gameId)
		return
	}

	for _, v := range s.clients {
		if v.GetUserID() != playerId {
			continue
		}

		players := make([]*lobby_messages.Player, 0)
		for _, v := range game.Players {
			players = append(players, &lobby_messages.Player{
				Id:     v.GetUser().ID,
				Name:   v.GetUser().Name,
				Rating: int32(v.GetUser().Rating),
			})
		}

		v.Send(&lobby_messages.LobbyMessage{Data: &lobby_messages.LobbyMessage_GameCreated{GameCreated: &lobby_messages.GameCreated{
			GameId:            gameId,
			Players:           players,
			MondfangRadelci:   game.MondfangRadelci,
			Skisfang:          game.IzgubaSkisa,
			NapovedanMondfang: game.NapovedanMondfang,
			KontraKazen:       game.KazenZaKontro,
			TotalTime:         int32(game.StartTime),
			AdditionalTime:    float32(game.AdditionalTime),
			Type:              game.Type,
			RequiredPlayers:   int32(game.PlayersNeeded),
			Started:           game.Started,
			Private:           game.Private,
			Priority:          true,
		}}})
	}
}

func (s *serverImpl) GetDB() sql.SQL {
	return s.db
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

// Disconnect gives Run the data to disconnect client from the server
func (s *serverImpl) Disconnect(client Client) {
	s.disconnect <- client
}

func (s *serverImpl) handleDisconnect() {
	err := events.Subscribe("lobby.disconnect", s.Disconnect)
	if err != nil {
		s.logger.Warnw("cannot read from the client")
	}
}

func (s *serverImpl) Broadcast(msg *lobby_messages.LobbyMessage) {
	s.broadcast <- msg
}

func (s *serverImpl) handleBroadcast() {
	err := events.Subscribe("lobby.broadcast", s.Broadcast)
	if err != nil {
		s.logger.Warnw("cannot read from the client")
	}
}

func (s *serverImpl) handleEvents() {
	err := events.Subscribe("lobby.gameStart", s.GameStartMessage)
	if err != nil {
		s.logger.Warnw("cannot read from the client")
	}
	err = events.Subscribe("lobby.invite", s.Invite)
	if err != nil {
		s.logger.Warnw("cannot read from the client")
	}
	err = events.Subscribe("lobby.onlineStatus", s.ChangeOnlineStatus)
	if err != nil {
		s.logger.Warnw("cannot read from the client")
	}
	err = events.Subscribe("kickPlayer", s.KickPlayer)
	if err != nil {
		s.logger.Warnw("cannot read from the client")
	}
	err = events.Subscribe("lobby.newPrivateGame", s.NewPrivateGame)
	if err != nil {
		s.logger.Warnw("cannot read from the client")
	}
}
