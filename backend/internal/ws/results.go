package ws

import (
	"github.com/mytja/Tarok/backend/internal/messages"
	"time"
)

func (s *serverImpl) Results(gameId string) {
	game, exists := s.games[gameId]
	if !exists {
		s.logger.Warnw("game doesn't exist", "gameId", gameId)
		return
	}

	// stockškis does the magic
	message := StockSkisMessagesResults(s.UnmarshallResults(s.StockSkisExec("results", "1", gameId)))
	for _, v := range message.User {
		if v.Mondfang {
			continue
		}

		if game.GameMode >= 0 {
			g := game.Playing[0]
			if game.Players[g].GetRadelci() == 0 {
				continue
			}

			v.Radelc = true
			if v.Igra > 0 {
				game.Players[g].RemoveRadelci()
			}
			v.Points *= 2

			continue
		}

		g := v.User[0].Id
		if game.Players[g].GetRadelci() == 0 {
			continue
		}

		v.Radelc = true
		game.Players[g].RemoveRadelci()
		v.Points *= 2
	}

	s.Broadcast("", &messages.Message{
		GameId: gameId,
		Data:   &messages.Message_Results{Results: message},
	})

	for i, v := range game.Players {
		if game.GameMode == -1 || game.GameMode >= 6 {
			v.AddRadelci()
		}

		s.Broadcast("", &messages.Message{
			PlayerId: i,
			GameId:   gameId,
			Data: &messages.Message_Radelci{
				Radelci: &messages.Radelci{
					Radleci: int32(v.GetRadelci()),
				},
			},
		})
	}

	s.logger.Debugw("radelci dodani vsem udeležencem igre")

	for i := 0; i <= 15; i++ {
		s.Broadcast(
			"",
			&messages.Message{
				GameId: gameId,
				Data:   &messages.Message_GameStartCountdown{GameStartCountdown: &messages.GameStartCountdown{Countdown: int32(15 - i)}},
			},
		)
		time.Sleep(time.Second)
	}
	s.StartGame(gameId)
}