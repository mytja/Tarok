package ws

import (
	"github.com/mytja/Tarok/backend/internal/helpers"
	"github.com/mytja/Tarok/backend/internal/messages"
	"math"
	"strings"
	"time"
)

func (s *serverImpl) BotKing(gameId string, playing string) {
	time.Sleep(500 * time.Millisecond)

	s.logger.Debugw("handling player due to him being offline", "playing", playing)

	// enable superpowers of stockškis
	king := strings.ReplaceAll(string(s.StockSkisExec("king", playing, gameId)), "\n", "")
	s.KingCalled(playing, gameId, king)
}

func (s *serverImpl) KingCalling(gameId string) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}
	playing := game.Playing[0]
	broadcast := &messages.Message{PlayerId: playing, GameId: gameId, Data: &messages.Message_KingSelection{KingSelection: &messages.KingSelection{Type: &messages.KingSelection_Notification{Notification: &messages.Notification{}}}}}
	s.Broadcast("", broadcast)

	prompt := &messages.Message{PlayerId: playing, GameId: gameId, Data: &messages.Message_KingSelection{KingSelection: &messages.KingSelection{Type: &messages.KingSelection_Request{Request: &messages.Request{}}}}}
	game.Players[playing].BroadcastToClients(prompt)

	go func() {
		t := time.Now()
		timer := game.Players[playing].GetTimer()
		done := false

		for {
			game, exists = s.games[gameId]
			if !exists {
				s.logger.Errorw("game doesn't exist, exiting", "gameId", gameId)
				return
			}

			select {
			case <-game.EndTimer:
				s.logger.Debugw("timer ended", "seconds", time.Now().Sub(t).Seconds(), "timer", timer)

				game, exists = s.games[gameId]
				if !exists {
					s.logger.Errorw("game doesn't exist, exiting", "gameId", gameId)
					return
				}

				game.Players[playing].SetTimer(math.Max(timer-time.Now().Sub(t).Seconds(), 0) + game.AdditionalTime)
				s.EndTimerBroadcast(gameId, playing, game.Players[playing].GetTimer())
				return
			case <-time.After(1 * time.Second):
				if done {
					continue
				}

				game, exists = s.games[gameId]
				if !exists {
					s.logger.Errorw("game doesn't exist, exiting", "gameId", gameId)
					return
				}

				s.EndTimerBroadcast(gameId, playing, math.Max(timer-time.Now().Sub(t).Seconds(), 0))
				if !(len(game.Players[playing].GetClients()) == 0 || time.Now().Sub(t).Seconds() > timer) {
					continue
				}
				s.logger.Debugw("time exceeded", "seconds", time.Now().Sub(t).Seconds(), "timer", timer)
				go s.BotKing(gameId, playing)
				done = true
			}
		}
	}()
}

func (s *serverImpl) KingCalled(userId string, gameId string, cardId string) {
	s.logger.Debugw("king was called", "userId", userId, "gameId", gameId, "cardId", cardId)

	game, exists := s.games[gameId]
	if !exists {
		return
	}
	playing := game.Playing[0]
	if userId != playing {
		s.logger.Warnw("modified client detected", "userId", userId)
		return
	}
	id := helpers.ParseCardID(cardId)
	if id.Name != "kralj" {
		return
	}
	if !helpers.Contains([]string{"kara", "kriz", "pik", "src"}, id.Type) {
		return
	}

	game.PlayingIn = cardId

	for i, v := range game.Players {
		if i == userId {
			// če je sam, je pač sam
			continue
		}
		if !v.ImaKarto(cardId) {
			continue
		}
		game.Playing = append(game.Playing, i)
		break
	}
	if game.GameMode >= 0 && game.GameMode <= 2 && len(game.Playing) == 1 {
		game.Zarufal = true
	}

	broadcast := &messages.Message{PlayerId: playing, GameId: gameId, Data: &messages.Message_KingSelection{KingSelection: &messages.KingSelection{Card: cardId, Type: &messages.KingSelection_Send{Send: &messages.Send{}}}}}
	s.Broadcast("", broadcast)

	game.EndTimer <- true

	time.Sleep(1000 * time.Millisecond)

	s.Talon(gameId)
}
