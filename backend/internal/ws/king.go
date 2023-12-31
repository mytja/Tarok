package ws

import (
	"github.com/mytja/Tarok/backend/internal/helpers"
	"github.com/mytja/Tarok/backend/internal/messages"
	"math"
	"strings"
	"time"
)

func (s *serverImpl) BotKing(gameId string, playing string) {
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
	player, exists := game.Players[playing]
	if !exists {
		return
	}

	game.WaitingFor = "king"

	broadcast := &messages.Message{PlayerId: playing, Data: &messages.Message_KingSelection{KingSelection: &messages.KingSelection{Type: &messages.KingSelection_Notification{Notification: &messages.Notification{}}}}}
	s.Broadcast("", gameId, broadcast)

	prompt := &messages.Message{PlayerId: playing, Data: &messages.Message_KingSelection{KingSelection: &messages.KingSelection{Type: &messages.KingSelection_Request{Request: &messages.Request{}}}}}
	player.BroadcastToClients(prompt)

	go func() {
		t := time.Now()
		timer := player.GetTimer()
		done := false

		s.StartTimerBroadcast(gameId, playing, timer)

		if player.GetBotStatus() {
			if game.TournamentID == "" || !game.TimeoutReached {
				time.Sleep(480 * time.Millisecond)
			}

			time.Sleep(10 * time.Millisecond)

			s.logger.Debugw("time exceeded by bot")
			go s.BotKing(gameId, playing)
			done = true
		}

		if game.TournamentID != "" && game.TimeoutReached && !player.GetBotStatus() {
			time.Sleep(10 * time.Millisecond)

			s.logger.Debugw("time exceeded by tournament timeout")
			go s.BotKing(gameId, playing)
			done = true
		}

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

				player.SetTimer(math.Max(timer-time.Now().Sub(t).Seconds(), 0) + game.AdditionalTime)
				s.EndTimerBroadcast(gameId, playing, player.GetTimer())
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

				if !(len(player.GetClients()) == 0 || time.Now().Sub(t).Seconds() > timer || game.TimeoutReached) {
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

	game.MovesPlayed++

	playing := game.Playing[0]
	if userId != playing {
		s.logger.Warnw("modified client detected", "userId", userId)
		return
	}
	id := helpers.ParseCardID(cardId)
	if id.Name != "kralj" {
		s.logger.Warnw("modified client detected", "userId", userId)
		return
	}
	if !helpers.Contains([]string{"kara", "kriz", "pik", "src"}, id.Type) {
		s.logger.Warnw("modified client detected", "userId", userId)
		return
	}
	if game.PlayingIn != "" {
		s.logger.Warnw("modified client detected", "userId", userId)
		return
	}
	if !((game.GameMode >= 0 && game.GameMode < 3) && game.PlayersNeeded == 4) {
		s.logger.Warnw("modified client detected", "userId", userId)
		return
	}
	if game.WaitingFor != "king" {
		s.logger.Warnw("modified client detected", "userId", userId)
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

	broadcast := &messages.Message{PlayerId: playing, Data: &messages.Message_KingSelection{KingSelection: &messages.KingSelection{Card: cardId, Type: &messages.KingSelection_Send{Send: &messages.Send{}}}}}
	s.Broadcast("", gameId, broadcast)

	game.EndTimer <- true

	if !game.TimeoutReached {
		time.Sleep(990 * time.Millisecond)
	}
	time.Sleep(10 * time.Millisecond)

	s.Talon(gameId)
}
