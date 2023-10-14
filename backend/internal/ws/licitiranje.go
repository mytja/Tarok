package ws

import (
	"encoding/json"
	"github.com/mytja/Tarok/backend/internal/helpers"
	"github.com/mytja/Tarok/backend/internal/messages"
	"math"
	"time"
)

func (s *serverImpl) BotLicitate(gameId string, userId string) int {
	var j []int
	json.Unmarshal(s.StockSkisExec("modes", userId, gameId), &j)
	return j[len(j)-1]
}

func (s *serverImpl) BotGoroutineLicitiranje(gameId string, playing string) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}

	player, exists := game.Players[playing]
	if !exists {
		return
	}

	go func() {
		s.logger.Debugw("gorutina bot licitiranje se poganja")

		t := time.Now()
		timer := player.GetTimer()
		done := false

		s.StartTimerBroadcast(gameId, playing, timer)

		if player.GetBotStatus() {
			time.Sleep(500 * time.Millisecond)

			s.logger.Debugw("time exceeded by bot")
			go s.Licitiranje(int32(s.BotLicitate(gameId, playing)), gameId, playing)
			done = true
		}

		for {
			game, exists = s.games[gameId]
			if !exists {
				s.logger.Errorw("game doesn't exist, exiting", "gameId", gameId)
				return
			}

			select {
			case _ = <-game.EndTimer:
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
				game, exists = s.games[gameId]
				if !exists {
					s.logger.Errorw("game doesn't exist, exiting", "gameId", gameId)
					return
				}

				if done {
					break
				}
				if !(len(player.GetClients()) == 0 || time.Now().Sub(t).Seconds() > timer) {
					break
				}
				s.logger.Debugw("time exceeded", "seconds", time.Now().Sub(t).Seconds(), "timer", timer)

				go s.Licitiranje(int32(s.BotLicitate(gameId, playing)), gameId, playing)
				done = true
				break
			}
		}
	}()
}

func (s *serverImpl) Licitiranje(tip int32, gameId string, userId string) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}

	s.logger.Debugw("licitiranje called", "gameId", gameId, "userId", userId)

	if len(game.Playing) == 0 || game.Playing[0] != userId {
		s.logger.Warnw("modified client detected. you cannot licitate if you're not the person")
	}

	if tip != -1 && (tip > game.GameMode || (tip >= game.GameMode && game.Starts[len(game.Starts)-1] == userId)) {
		game.Players[userId].SetGameMode(tip)
		game.GameMode = tip
		playing := game.Playing[0]
		game.Playing = helpers.RemoveOrdered(game.Playing, 0)
		game.Playing = append(game.Playing, playing)
		if game.NaslednjiKrogPri == "" {
			game.NaslednjiKrogPri = playing
		}
	} else {
		if tip == -1 && tip > game.GameMode {
			game.GameMode = tip
		}
		game.Players[userId].SetGameMode(tip)
		game.Playing = helpers.RemoveOrdered(game.Playing, 0)
	}

	s.logger.Debugw("licitiranje", "playing", game.Playing, "tip", tip, "userId", userId, "starts", game.Starts)

	s.Broadcast("", &messages.Message{
		PlayerId: userId,
		GameId:   gameId,
		Data: &messages.Message_Licitiranje{
			Licitiranje: &messages.Licitiranje{
				Type: tip,
			},
		},
	})

	licitiranje := 0

	for _, v := range game.Players {
		if v.GetGameMode() == -2 {
			licitiranje++
		}
	}

	s.logger.Debugw("ending timer")
	game.EndTimer <- true
	s.logger.Debugw("timer end")

	time.Sleep(100 * time.Millisecond)

	if licitiranje == 0 && len(game.Playing) == 1 {
		// konc smo z licitiranjem, objavimo zadnje rezultate
		// in začnimo metat karte
		s.logger.Debugw("done with licitating, now starting playing the game", "gameId", gameId)

		game.CurrentPredictions = &messages.Predictions{Igra: &messages.User{Id: game.Playing[0]}, Gamemode: game.GameMode}
		s.Broadcast("", &messages.Message{
			GameId: gameId,
			Data:   &messages.Message_PredictionsResend{PredictionsResend: game.CurrentPredictions},
		})

		if game.PlayersNeeded == 4 && game.GameMode >= 0 && game.GameMode <= 2 {
			// rufanje kralja
			s.KingCalling(gameId)
		} else if game.GameMode >= 0 && game.GameMode <= 5 {
			s.Talon(gameId)
		} else if game.GameMode >= 6 {
			s.FirstPrediction(gameId)
		}
		game = s.games[gameId]
		game.CardsStarted = true
	} else if licitiranje != 0 || len(game.Playing) >= 1 {
		playing := game.Playing[0]

		if game.NaslednjiKrogPri == playing {
			game.NaslednjiKrogPri = ""
			game.KrogovLicitiranja++
		}

		game.Players[playing].BroadcastToClients(&messages.Message{
			PlayerId: playing,
			GameId:   gameId,
			Data:     &messages.Message_LicitiranjeStart{LicitiranjeStart: &messages.LicitiranjeStart{}},
		})

		s.BotGoroutineLicitiranje(gameId, playing)
	} else {
		game = s.games[gameId]
		game.CardsStarted = true
		game.CurrentPredictions = &messages.Predictions{Gamemode: game.GameMode}

		// igramo klopa
		s.FirstPrediction(gameId)
	}
}
