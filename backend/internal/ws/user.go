package ws

import (
	"encoding/base64"
	"github.com/mytja/Tarok/backend/internal/helpers"
	"github.com/mytja/Tarok/backend/internal/messages"
	"github.com/mytja/Tarok/backend/internal/sql"
	"go.uber.org/zap"
	"google.golang.org/protobuf/proto"
)

type userImpl struct {
	ID             string
	User           sql.User
	Clients        []Client
	Cards          []Card
	CardArchive    []Card
	GameMode       int32
	Results        int
	Radelci        int
	HasKing        bool
	HasKingFallen  bool
	Timer          float64
	Bot            bool
	MessageHistory [][]string
	logger         *zap.SugaredLogger
}

func NewUser(id string, user sql.User, logger *zap.SugaredLogger) User {
	return &userImpl{
		ID:             id,
		User:           user,
		Clients:        make([]Client, 0),
		Cards:          make([]Card, 0),
		CardArchive:    make([]Card, 0),
		GameMode:       -2,
		Results:        0,
		logger:         logger,
		Radelci:        0,
		MessageHistory: make([][]string, 0),
		Timer:          DEFAULT_TIME,
		HasKing:        false,
		HasKingFallen:  false,
		Bot:            false,
	}
}

func (u *userImpl) NewGameHistory() {
	u.MessageHistory = append(u.MessageHistory, make([]string, 0))
}

func (u *userImpl) GetGameHistory() [][]string {
	return u.MessageHistory
}

func (u *userImpl) RemoveClient(clientId string) {
	for i, v := range u.Clients {
		if v.GetClientID() != clientId {
			continue
		}
		u.Clients = helpers.Remove(u.Clients, i)
		break
	}
}

func (u *userImpl) GetClients() []Client {
	return u.Clients
}

func (u *userImpl) BroadcastToClients(message *messages.Message) {
	if !u.Bot && len(u.MessageHistory) > 0 {
		m, err := proto.Marshal(message)
		if err == nil {
			u.MessageHistory[len(u.MessageHistory)-1] = append(u.MessageHistory[len(u.MessageHistory)-1], base64.StdEncoding.EncodeToString(m))
		}
	}
	for _, v := range u.Clients {
		v.Send(message)
	}
}

func (u *userImpl) SendToClient(clientId string, message *messages.Message) {
	for _, v := range u.Clients {
		if v.GetClientID() != clientId {
			continue
		}
		v.Send(message)
	}
}

func (u *userImpl) ResetGameVariables() {
	u.CardArchive = make([]Card, 0)
	u.Cards = make([]Card, 0)
	u.GameMode = -2
	u.HasKingFallen = false
	u.HasKing = false
}

func (u *userImpl) GetUser() sql.User {
	return u.User
}

func (u *userImpl) AddCard(card Card) {
	u.Cards = append(u.Cards, card)
	u.CardArchive = append(u.CardArchive, card)
}

func (u *userImpl) ResendCards(clientId string) {
	for _, c := range u.Cards {
		u.logger.Debugw("resending cards", "cardId", c.id)
		u.SendToClient(clientId, &messages.Message{
			PlayerId: u.ID,
			Data: &messages.Message_Card{
				Card: &messages.Card{
					Id:     c.id,
					UserId: u.ID,
					Type: &messages.Card_Receive{
						Receive: &messages.Receive{},
					},
				},
			},
		})
	}
}

func (u *userImpl) NewClient(client Client) {
	u.Clients = append(u.Clients, client)
}

func (u *userImpl) ImaKarto(karta string) bool {
	for _, v := range u.Cards {
		if karta != v.id {
			continue
		}
		return true
	}
	return false
}

func (u *userImpl) GetCards() []Card {
	return u.Cards
}

func (u *userImpl) GetArchivedCards() []Card {
	return u.CardArchive
}

func (u *userImpl) RemoveCard(card int) {
	u.Cards = helpers.Remove(u.Cards, card)
}

func (u *userImpl) RemoveCardByID(card string) {
	for i, v := range u.Cards {
		if v.id != card {
			continue
		}
		u.Cards = helpers.Remove(u.Cards, i)
		u.logger.Debug("found my card")
		return
	}
	u.logger.Warn("I haven't found the card")
}

func (u *userImpl) AssignArchive() {
	u.CardArchive = make([]Card, 0)
	u.CardArchive = append(u.CardArchive, u.Cards...)
}

func (u *userImpl) SetGameMode(mode int32) {
	u.GameMode = mode
}

func (u *userImpl) GetGameMode() int32 {
	return u.GameMode
}

func (u *userImpl) AddPoints(points int) {
	u.Results += points
}

func (u *userImpl) GetResults() int {
	return u.Results
}

func (u *userImpl) GetRadelci() int {
	return u.Radelci
}

func (u *userImpl) AddRadelci() {
	u.Radelci++
}

func (u *userImpl) RemoveRadelci() {
	u.Radelci--
}

func (u *userImpl) SetHasKingFallen() {
	if u.HasKing {
		u.HasKingFallen = true
	}
}

func (u *userImpl) SetHasKing(selectedKing string) {
	for _, v := range u.CardArchive {
		if v.id == selectedKing {
			u.HasKing = true
			break
		}
	}
}

func (u *userImpl) UserHasKing() bool {
	return u.HasKing
}

func (u *userImpl) SelectedKingFallen() bool {
	return u.HasKingFallen
}

func (u *userImpl) GetTimer() float64 {
	return u.Timer
}

func (u *userImpl) SetTimer(timer float64) {
	u.Timer = timer
}

func (u *userImpl) SetBotStatus() {
	u.Bot = true
}

func (u *userImpl) GetBotStatus() bool {
	return u.Bot
}
