package lobby

import (
	"github.com/google/uuid"
	"github.com/mytja/Tarok/backend/internal/sql"
	"net"
	"time"

	"github.com/gorilla/websocket"

	"google.golang.org/protobuf/proto"

	"go.uber.org/zap"

	"github.com/mytja/Tarok/backend/internal/events"
	"github.com/mytja/Tarok/backend/internal/lobby_messages"
)

const (
	writeTimeout = 10 * time.Second
)

type clientImpl struct {
	clientId string
	user     sql.User
	addr     net.Addr
	conn     *websocket.Conn

	logger *zap.SugaredLogger

	send chan *lobby_messages.LobbyMessage

	server Server
}

// NewClient creates new instance of client with randomly generated id and remote adres, it also connects him to server with websocket
// and allows server to communicate with him
func NewClient(user sql.User, conn *websocket.Conn, serv Server, logger *zap.Logger) Client {
	return &clientImpl{
		clientId: uuid.NewString(),
		user:     user,
		addr:     conn.RemoteAddr(),
		conn:     conn,
		logger:   logger.Sugar(),
		server:   serv,

		send: make(chan *lobby_messages.LobbyMessage),
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

// Send sends lobby_messages
func (c *clientImpl) Send(msg *lobby_messages.LobbyMessage) {
	c.send <- msg
}

// Checks if our ReadMessage error is a normal disconnect event
func isUnexpectedClose(err error) bool {
	return websocket.IsUnexpectedCloseError(err,
		websocket.CloseNormalClosure,
		websocket.CloseAbnormalClosure,
		websocket.CloseGoingAway)
}

// ReadPump reads the lobby_messages sent from the client and returns error if needed
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

		//tu je ta message bus
		// Everything seems fine, just unmarshal & forward
		c.logger.Debugw("received message", "id", c.user.ID, "remoteAddr", c.addr)
		message := &lobby_messages.LobbyMessage{}
		err = proto.Unmarshal(msg, message)
		if err != nil {
			c.logger.Errorw("error while unmarshalling protobuf message", "msg", msg, "err", err)
			break
		}

		data := message.Data
		isLogin := false
		switch data.(type) {
		case *lobby_messages.LobbyMessage_LoginInfo:
			isLogin = true
		}

		if !isLogin {
			c.logger.Debugw("user tried to send packets without logging in")
			continue
		}

		switch u := data.(type) {
		case *lobby_messages.LobbyMessage_LoginInfo:
			c.logger.Debugw("authenticating user")
			token := u.LoginInfo.Token
			if token == "" {
				c.send <- &lobby_messages.LobbyMessage{Data: &lobby_messages.LobbyMessage_LoginResponse{LoginResponse: &lobby_messages.LoginResponse{Type: &lobby_messages.LoginResponse_Fail_{Fail: &lobby_messages.LoginResponse_Fail{}}}}}
				c.Close()
				return
			}

			user, err := c.server.GetDB().CheckTokenString(token)
			if err != nil {
				c.send <- &lobby_messages.LobbyMessage{Data: &lobby_messages.LobbyMessage_LoginResponse{LoginResponse: &lobby_messages.LoginResponse{Type: &lobby_messages.LoginResponse_Fail_{Fail: &lobby_messages.LoginResponse_Fail{}}}}}
				c.Close()
				return
			}

			c.user = user
			c.send <- &lobby_messages.LobbyMessage{PlayerId: c.user.ID, Data: &lobby_messages.LobbyMessage_LoginResponse{LoginResponse: &lobby_messages.LoginResponse{Type: &lobby_messages.LoginResponse_Ok{Ok: &lobby_messages.LoginResponse_OK{}}}}}
			c.server.Authenticated(c)
			break
		default:
			message.PlayerId = c.user.ID
			events.Publish("lobby.broadcast", c.user.ID, message)
			break
		}
	}

	c.logger.Debugw("sending server.disconnect message", "client", c)
	events.Publish("lobby.disconnect", c)
	//events.Publish("server.disconnect", c.user.ID)
}

// SendPump sends lobby_messages to client and checks if there is an error and returns it
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
