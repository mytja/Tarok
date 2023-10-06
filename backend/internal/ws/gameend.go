package ws

import (
	"encoding/json"
	"fmt"
	"github.com/mytja/Tarok/backend/internal/helpers"
	"github.com/mytja/Tarok/backend/internal/messages"
	"github.com/mytja/Tarok/backend/internal/sql"
	"math/rand"
	"strings"
	"time"
)

func (s *serverImpl) EndGame(gameId string) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}

	for _, v := range game.Players {
		radelci := v.GetRadelci() * -40
		v.AddPoints(radelci)
	}

	results := make([]*messages.ResultsUser, 0)
	for u, user := range game.Players {
		if !user.GetBotStatus() {
			h := user.GetGameHistory()
			marshal, err := json.Marshal(h)
			if err == nil {
				chars := []rune("ABCDEFGHIJKLMNOPQRSTUVWXYZ" +
					"abcdefghijklmnopqrstuvwxyz" +
					"0123456789")
				length := 16
				var b strings.Builder
				for i := 0; i < length; i++ {
					b.WriteRune(chars[rand.Intn(len(chars))])
				}
				password := b.String()
				hash, err := sql.HashPassword(password)
				if err != nil {
					return
				}

				g := sql.Game{
					UserID:   u,
					GameID:   gameId,
					Messages: string(marshal),
					Password: hash,
				}
				s.db.InsertGame(g)
				user.BroadcastToClients(&messages.Message{
					PlayerId: u,
					GameId:   gameId,
					Data:     &messages.Message_ReplayLink{ReplayLink: &messages.ReplayLink{Replay: fmt.Sprintf("https://palcka.si/replay/%s?password=%s", gameId, password)}},
				})
			}
		}
		results = append(results,
			&messages.ResultsUser{
				User: []*messages.User{{
					Id: u,
				}},
				Points: int32(user.GetResults()),
			},
		)
	}
	s.Broadcast("", &messages.Message{GameId: gameId, Data: &messages.Message_GameEnd{GameEnd: &messages.GameEnd{Type: &messages.GameEnd_Results{Results: &messages.Results{
		User: results,
	}}}}})
	time.Sleep(3 * time.Second) // nekaj spanca, preden izbrišemo vse skupaj.
	delete(s.games, gameId)
}

func (s *serverImpl) GameEndRequest(userId string, gameId string) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}

	if !helpers.Contains(game.Starts, userId) {
		s.logger.Warnw("user tried to end game in which he's not in.", "userId", userId, "gameId", gameId)
		return
	}

	if helpers.Contains(game.GameEnd, userId) {
		s.logger.Warnw("user tried voting twice.", "userId", userId, "gameId", gameId)
		return
	}

	game.GameEnd = append(game.GameEnd, userId)

	s.Broadcast("", &messages.Message{PlayerId: userId, GameId: gameId, Data: &messages.Message_GameEnd{GameEnd: &messages.GameEnd{Type: &messages.GameEnd_Request{Request: &messages.Request{}}}}})

	s.logger.Debugw("appended user to the game end queue", "gameId", gameId, "userId", userId, "gameEnd", game.GameEnd)

	playersOnline := 0
	for _, v := range game.Players {
		if len(v.GetClients()) == 0 {
			continue
		}
		playersOnline++
	}

	if (float32(len(game.GameEnd)) / float32(playersOnline)) > 0.5 {
		s.logger.Debugw("ending the game", "gameId", gameId, "gameEnd", game.GameEnd, "playersNeeded", game.PlayersNeeded)
		s.EndGame(gameId)
	}
}
