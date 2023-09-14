package ws

import (
	"github.com/google/uuid"
	"github.com/mytja/Tarok/backend/internal/sql"
	"net"
	"time"

	"github.com/gorilla/websocket"

	"google.golang.org/protobuf/proto"

	"go.uber.org/zap"

	"github.com/mytja/Tarok/backend/internal/events"
	"github.com/mytja/Tarok/backend/internal/messages"
)

const (
	writeTimeout = 10 * time.Second
)

type clientImpl struct {
	clientId string
	user     sql.User
	addr     net.Addr
	position int32
	conn     *websocket.Conn
	game     string

	logger *zap.SugaredLogger

	send chan *messages.Message

	server Server
}

// NewClient creates new instance of client with randomly generated id and remote adres, it also connects him to server with websocket
// and allows server to communicate with him
func NewClient(user sql.User, conn *websocket.Conn, serv Server, logger *zap.Logger, game string) Client {
	return &clientImpl{
		clientId: uuid.NewString(),
		user:     user,
		addr:     conn.RemoteAddr(),
		conn:     conn,
		game:     game,
		logger:   logger.Sugar(),
		server:   serv,

		send: make(chan *messages.Message),
	}
}

// GetUserID returns id of the client
func (c *clientImpl) GetUserID() string {
	return c.user.ID
}

func (c *clientImpl) GetClientID() string {
	return c.clientId
}

func (c *clientImpl) GetUser() sql.User {
	return c.user
}

func (c *clientImpl) GetGame() string {
	return c.game
}

// GetRemoteAddr returns remote address of the client
func (c *clientImpl) GetRemoteAddr() net.Addr {
	return c.addr
}

// Close closes the client
func (c *clientImpl) Close() {
	//close(c.send)
	c.conn.Close()
	// TODO: Server needs to be aware that we disconnected as well
}

// Send sends messages
func (c *clientImpl) Send(msg *messages.Message) {
	c.send <- msg
}

// Checks if our ReadMessage error is a normal disconnect event
func isUnexpectedClose(err error) bool {
	return websocket.IsUnexpectedCloseError(err,
		websocket.CloseNormalClosure,
		websocket.CloseAbnormalClosure,
		websocket.CloseGoingAway)
}

// ReadPump reads the messages sent from the client and returns error if needed
func (c *clientImpl) ReadPump() {
	c.logger.Debugw("started read pump for client",
		"id", c.user.ID, "remoteAddr", c.addr)

	defer c.Close()
	for {
		_, msg, err := c.conn.ReadMessage()
		if err != nil {
			// We will handle disconnects here since websocket will
			// error on this call when we receive it
			if isUnexpectedClose(err) {
				c.logger.Errorw("unexpected close on client socket",
					"id", c.user.ID, "remoteAddr", c.addr, zap.Error(err))
			}

			c.logger.Debugw("exiting client read pump", "id", c.user.ID, "remoteAddr", c.addr)
			break
		}

		game := c.server.GetGame(c.game)
		if game == nil {
			break
		}

		//tu je ta message bus
		// Everything seems fine, just unmarshal & forward
		c.logger.Debugw("received message", "id", c.user.ID, "remoteAddr", c.addr)
		message := &messages.Message{}
		err = proto.Unmarshal(msg, message)
		if err != nil {
			c.logger.Errorw("error while unmarshalling protobuf message", "msg", msg, "err", err)
			break
		}

		data := message.Data
		isLogin := false
		switch data.(type) {
		case *messages.Message_LoginInfo:
			isLogin = true
		}

		if !isLogin {
			_, exists := game.Players[c.user.ID]
			if !exists {
				c.logger.Debugw("user tried to send packets without logging in")
				continue
			}
		}

		switch u := data.(type) {
		case *messages.Message_LoginInfo:
			c.logger.Debugw("authenticating user")
			token := u.LoginInfo.Token
			if token == "" {
				c.send <- &messages.Message{GameId: c.game, Data: &messages.Message_LoginResponse{LoginResponse: &messages.LoginResponse{Type: &messages.LoginResponse_Fail_{Fail: &messages.LoginResponse_Fail{}}}}}
				c.Close()
				return
			}

			user, err := c.server.GetDB().CheckTokenString(token)
			if err != nil {
				c.send <- &messages.Message{GameId: c.game, Data: &messages.Message_LoginResponse{LoginResponse: &messages.LoginResponse{Type: &messages.LoginResponse_Fail_{Fail: &messages.LoginResponse_Fail{}}}}}
				c.Close()
				return
			}

			c.user = user
			c.send <- &messages.Message{GameId: c.game, Username: c.user.Name, PlayerId: c.user.ID, Data: &messages.Message_LoginResponse{LoginResponse: &messages.LoginResponse{Type: &messages.LoginResponse_Ok{Ok: &messages.LoginResponse_OK{}}}}}
			c.server.Authenticated(c)
			break
		case *messages.Message_Licitiranje:
			c.logger.Debugw("received Licitiranje packet", "gameId", c.game)
			c.server.Licitiranje(u.Licitiranje.Type, c.game, c.user.ID)
			break
		case *messages.Message_Card:
			c.logger.Debugw("received Card packet", "gameId", c.game, "packet", u)
			c.server.CardDrop(u.Card.Id, c.game, c.user.ID, c.clientId)
			break
		case *messages.Message_KingSelection:
			c.logger.Debugw("received KingSelection packet", "gameId", c.game)
			c.server.KingCalled(c.user.ID, c.game, u.KingSelection.Card)
			break
		case *messages.Message_TalonSelection:
			c.logger.Debugw("received TalonSelection packet", "gameId", c.game)
			c.server.TalonSelected(c.user.ID, c.game, u.TalonSelection.Part)
			break
		case *messages.Message_Stash:
			c.logger.Debugw("received Stash packet", "gameId", c.game)
			c.server.StashedCards(c.user.ID, c.game, c.clientId, u.Stash.Card)
			break
		case *messages.Message_Predictions:
			c.logger.Debugw("received Predictions packet", "gameId", c.game)
			c.server.Predictions(c.user.ID, c.game, u.Predictions)
			break
		case *messages.Message_GameEnd:
			c.logger.Debugw("received GameEnd packet", "gameId", c.game, "userId", c.user.ID)
			c.server.GameEndRequest(c.user.ID, c.game)
			break
		case *messages.Message_ChatMessage:
			c.logger.Debugw("received ChatMessage packet", "gameId", c.game, "userId", c.user.ID)
			u.ChatMessage.UserId = c.user.ID
			c.server.HandleMessage(c.game, u.ChatMessage)
			break
		case *messages.Message_InvitePlayer:
			c.logger.Debugw("received InvitePlayer packet", "gameId", c.game, "userId", c.user.ID)
			c.server.InvitePlayer(c.user.ID, c.game, message.PlayerId)
			break
		case *messages.Message_GameStart:
			c.logger.Debugw("received GameStart packet", "gameId", c.game, "userId", c.user.ID)
			c.server.ManuallyStartGame(c.user.ID, c.game)
			break
		default:
			message.PlayerId = c.user.ID
			events.Publish("server.broadcast", c.user.ID, message)
			break
		}
	}

	c.logger.Debugw("sending server.disconnect message", "client", c)
	events.Publish("server.disconnect", c)
	//events.Publish("server.disconnect", c.user.ID)
}

// SendPump sends messages to client and checks if there is an error and returns it
func (c *clientImpl) SendPump() {
	c.logger.Debugw("started send pump for client",
		"id", c.user.ID, "remoteAddr", c.addr)

	for message := range c.send {
		c.logger.Debugw("sending message", "msg", message, "client", c.clientId)

		// So we don't wait for too long before we send
		err := c.conn.SetWriteDeadline(time.Now().Add(writeTimeout))
		if err != nil {
			c.logger.Errorw("error while setting write deadline", "err", err)
			return
		}

		writer, err := c.conn.NextWriter(websocket.BinaryMessage)
		if err != nil {
			c.logger.Warnw("error while getting NextWriter for client",
				"id", c.user.ID, "remoteAddr", c.addr, zap.Error(err))
			return
		}

		rawMessage, err := proto.Marshal(message)
		if err != nil {
			c.logger.Errorw("error while marshalling protobuf message", "err", err)
			return
		}
		_, err = writer.Write(rawMessage)
		if err != nil {
			c.logger.Errorw("error while writing to the writer", "err", err)
			return
		}
		// We need to close the writer so that our message
		// gets flushed to the client
		if err = writer.Close(); err != nil {
			c.logger.Warnw("error while closing client writer",
				"id", c.user.ID, "remoteAddr", c.addr, zap.Error(err))
		}
	}

	c.logger.Debugw("exiting client send pump", "id", c.user.ID, "remoteAddr", c.addr)
	c.conn.WriteMessage(websocket.CloseMessage, []byte{})
}
