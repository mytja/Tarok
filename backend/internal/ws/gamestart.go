package ws

import (
	"fmt"
	"github.com/mytja/Tarok/backend/internal/messages"
	"github.com/mytja/Tarok/backend/internal/sql"
	"math/rand"
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

	if len(game.Players) >= game.PlayersNeeded {
		return
	}

	required := game.PlayersNeeded - len(game.Players)

	names := make([]string, 0)
	names = append(names, BOT_NAMES...)
	rand.Shuffle(len(names), func(i, j int) {
		names[i], names[j] = names[j], names[i]
	})

	for i := 0; i < required; i++ {
		uid := fmt.Sprintf("bot%s", fmt.Sprint(i))
		player := NewUser(uid, sql.User{
			ID:         uid,
			Email:      fmt.Sprintf("%s@palcka.si", uid),
			Password:   "",
			Role:       "bot",
			Name:       names[i],
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

	if len(game.Players) == game.PlayersNeeded {
		s.GameStartGoroutine(gameId)
	}
}
