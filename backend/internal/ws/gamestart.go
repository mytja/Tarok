package ws

import (
	"fmt"
	"github.com/mytja/Tarok/backend/internal/messages"
	"github.com/mytja/Tarok/backend/internal/sql"
	"time"
)

func (s *serverImpl) ManuallyStartGame(playerId string, gameId string) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}

	if game.Owner != playerId {
		return
	}

	if game.Started {
		return
	}

	if len(s.games[gameId].Players) >= s.games[gameId].PlayersNeeded {
		return
	}

	required := s.games[gameId].PlayersNeeded - len(s.games[gameId].Players)
	for i := 0; i < required; i++ {
		uid := fmt.Sprintf("bot%s", fmt.Sprint(i))
		player := NewUser(uid, sql.User{
			ID:         uid,
			Email:      fmt.Sprintf("%s@palcka.si", uid),
			Password:   "",
			Role:       "bot",
			Name:       BOT_NAMES[i],
			LoginToken: "",
			Rating:     1000,
			CreatedAt:  "",
			UpdatedAt:  "",
		}, s.logger)
		player.SetBotStatus()
		game.Players[uid] = player

		s.Broadcast(uid, &messages.Message{
			GameId:   gameId,
			PlayerId: uid,
			Username: player.GetUser().Name,
			Data: &messages.Message_Connection{
				Connection: &messages.Connection{
					Rating: int32(player.GetUser().Rating),
					Type:   &messages.Connection_Join{Join: &messages.Connect{}},
				},
			},
		})
	}

	time.Sleep(100 * time.Millisecond)

	if len(s.games[gameId].Players) == s.games[gameId].PlayersNeeded {
		s.GameStartGoroutine(gameId)
	}
}
