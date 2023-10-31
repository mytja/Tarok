package ws

import (
	"github.com/mytja/Tarok/backend/internal/helpers"
	"github.com/mytja/Tarok/backend/internal/messages"
)

func (s *serverImpl) HandleMessage(gameId string, message *messages.ChatMessage) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}
	if message == nil {
		return
	}
	if !helpers.Contains(game.Starts, message.UserId) {
		return
	}
	game.Chat = append(game.Chat, message)
	s.Broadcast("", gameId, &messages.Message{
		PlayerId: message.UserId,
		Data:     &messages.Message_ChatMessage{ChatMessage: message},
	})
}

func (s *serverImpl) RelayAllMessagesToClient(gameId string, playerId string, clientId string) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}

	player, exists := game.Players[playerId]
	if !exists {
		return
	}

	for _, v := range game.Chat {
		player.SendToClient(clientId, &messages.Message{
			PlayerId: v.UserId,
			Data:     &messages.Message_ChatMessage{ChatMessage: v},
		})
	}
}
