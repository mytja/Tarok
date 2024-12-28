package lobby

import (
	"github.com/mytja/Tarok/backend/internal/lobby_messages"
	"github.com/mytja/Tarok/backend/internal/sql"
	"net"
	"net/http"
)

// Server starts the Run connect and disconnect methods
type Server interface {
	Run()
	GetDB() sql.SQL
	Authenticated(client Client)
	Connect(w http.ResponseWriter, r *http.Request) Client
	GameStartMessage(gameId string, players []string)
	ChangeOnlineStatus(playerId string, status int32)
	AddNewFriend(userId string, friendEmail string)
	IncomingFriendRequestAcceptDeny(userId string, friendRequestId string, accept bool)
	RemoveFriend(userId string, relationshipId string)
	Disconnect(client Client)
}

// Client contains all the methods we need for recognising and working with the Client
type Client interface {
	GetUserID() string
	GetClientID() string
	GetUser() sql.User
	GetRemoteAddr() net.Addr

	Send(msg *lobby_messages.LobbyMessage)
	Close()

	ReadPump()
	SendPump()
}
