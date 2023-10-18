package ws

import (
	"github.com/mytja/Tarok/backend/internal/messages"
	"math"
)

func (s *serverImpl) EndTimerBroadcast(gameId string, playing string, timer float64) {
	msg := messages.Message{
		PlayerId: playing,
		Data:     &messages.Message_Time{Time: &messages.Time{CurrentTime: float32(math.Round(timer*100) / 100), Start: false}},
	}
	s.Broadcast("", gameId, &msg)
}

func (s *serverImpl) StartTimerBroadcast(gameId string, playing string, timer float64) {
	msg := messages.Message{
		PlayerId: playing,
		Data:     &messages.Message_Time{Time: &messages.Time{CurrentTime: float32(math.Round(timer*100) / 100), Start: true}},
	}
	s.Broadcast("", gameId, &msg)
}
