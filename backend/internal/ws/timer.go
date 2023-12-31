package ws

import (
	"github.com/mytja/Tarok/backend/internal/messages"
	"math"
)

func (s *serverImpl) EndTimerBroadcast(gameId string, playing string, timer float64) {
	game, exists := s.games[gameId]
	if !exists {
		s.logger.Errorw("no such game", "gameId", gameId, "playing", playing, "timer", timer)
		return
	}

	if game.TournamentID != "" {
		return
	}

	msg := messages.Message{
		PlayerId: playing,
		Data:     &messages.Message_Time{Time: &messages.Time{CurrentTime: float32(math.Round(timer*100) / 100), Start: false}},
	}
	s.Broadcast("", gameId, &msg)
}

func (s *serverImpl) StartTimerBroadcast(gameId string, playing string, timer float64) {
	game, exists := s.games[gameId]
	if !exists {
		s.logger.Errorw("no such game", "gameId", gameId, "playing", playing, "timer", timer)
		return
	}

	if game.TournamentID != "" {
		return
	}

	msg := messages.Message{
		PlayerId: playing,
		Data:     &messages.Message_Time{Time: &messages.Time{CurrentTime: float32(math.Round(timer*100) / 100), Start: true}},
	}
	s.Broadcast("", gameId, &msg)
}
