package ws

import (
	"errors"
	"fmt"
	"github.com/mytja/Tarok/backend/internal/helpers"
	"github.com/mytja/Tarok/backend/internal/messages"
	"os"
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

	exists = true
	if _, err := os.Stat(fmt.Sprintf("profile_pictures/%s.webp", message.UserId)); errors.Is(err, os.ErrNotExist) {
		exists = false
	}
	message.CustomProfilePicture = exists

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
		exists := true
		if _, err := os.Stat(fmt.Sprintf("profile_pictures/%s.webp", v.UserId)); errors.Is(err, os.ErrNotExist) {
			exists = false
		}
		v.CustomProfilePicture = exists

		player.SendToClient(clientId, &messages.Message{
			PlayerId: v.UserId,
			Data:     &messages.Message_ChatMessage{ChatMessage: v},
		})
	}
}
