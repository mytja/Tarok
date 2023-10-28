package lobby

import (
	"github.com/gorilla/websocket"
	"github.com/mytja/Tarok/backend/internal/helpers"
	"github.com/mytja/Tarok/backend/internal/lobby_messages"
	"github.com/mytja/Tarok/backend/internal/sql"
	"github.com/mytja/Tarok/backend/internal/ws"
	"go.uber.org/zap"
	"net/http"

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
		s.logger.Errorw("error while upgrading connection", zap.Error(err))
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

func TransformGameDescriptors(client Client, games []ws.GameDescriptor, priority bool) {
	for _, v := range games {
		users := make([]*lobby_messages.Player, 0)
		for _, k := range v.Users {
			users = append(users, &lobby_messages.Player{
				Id:     k.ID,
				Name:   k.Name,
				Rating: 1000,
			})
		}
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

func (s *serverImpl) Authenticated(client Client) {
	user := client.GetUser()
	id := user.ID

	s.logger.Debugw("successfully authenticated user", "id", id, "name", user.Name)

	games, priorityGames := s.gameServer.GetGames(id)
	TransformGameDescriptors(client, games, false)
	TransformGameDescriptors(client, priorityGames, true)
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
