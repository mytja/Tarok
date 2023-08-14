package ws

import (
	"github.com/mytja/Tarok/backend/internal/messages"
	"math"
)

func (s *serverImpl) EndTimerBroadcast(gameId string, playing string, timer float64) {
	msg := messages.Message{
		PlayerId: playing,
		GameId:   gameId,
		Data:     &messages.Message_Time{Time: &messages.Time{CurrentTime: float32(math.Round((timer * 10) / 10))}},
	}
	s.Broadcast("", &msg)
}
