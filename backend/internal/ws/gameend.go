package ws

import (
	"github.com/mytja/Tarok/backend/internal/helpers"
	"github.com/mytja/Tarok/backend/internal/messages"
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
