package ws

import (
	"github.com/mytja/Tarok/backend/internal/messages"
	"strconv"
	"strings"
	"time"
)

func (s *serverImpl) Results(gameId string) {
	game, exists := s.games[gameId]
	if !exists {
		s.logger.Warnw("game doesn't exist", "gameId", gameId)
		return
	}

	gameCount := game.GameCount
	game.WaitingFor = "results"

	mondfang := false

	// stockškis does the magic
	message := StockSkisMessagesResults(s.UnmarshallResults(s.StockSkisExec("results", "1", gameId)))
	valat := false

	// tukaj prvo samo preverimo za radelce, jih applyjamo
	// če bi že tukaj dodajali točke igralcem, bi zamočili, saj bi pošiljali *2 (z radelci) točke, na serverju pa bi imeli *1 rezultate
	for _, v := range message.User {
		if v.Mondfang {
			if game.MondfangRadelci {
				mondfang = true
			}
			continue
		}

		if v.Skisfang {
			continue
		}

		if game.GameMode < 0 {
			continue
		}

		g := game.Playing[0]
		if game.Players[g].GetRadelci() == 0 {
			continue
		}

		v.Radelc = true
		if v.Igra > 0 {
			game.Players[g].RemoveRadelci()
		}
		v.Points *= 2
	}

	// sedaj pa applyjamo vse točke na igralce
	for _, v := range message.User {
		for _, u := range v.User {
			player := u.Id
			p, exists := game.Players[player]
			if !exists {
				s.logger.Warnw("no player exists", "player", player)
				continue
			}
			if v.Igra == 250 || v.Igra == 500 {
				valat = true
			}

			p.AddPoints(int(v.Points))
		}
	}

	message.Predictions = game.CurrentPredictions
	game.ResultsArchive = append(game.ResultsArchive, message)

	s.Broadcast("", gameId, &messages.Message{
		Data: &messages.Message_Results{Results: message},
	})

	// dodamo radelce po potrebi
	for i, v := range game.Players {
		if game.GameMode == -1 || game.GameMode >= 6 || valat {
			v.AddRadelci()
		}

		if mondfang {
			v.AddRadelci()
		}

		s.Broadcast("", gameId, &messages.Message{
			PlayerId: i,
			Data: &messages.Message_Radelci{
				Radelci: &messages.Radelci{
					Radleci: int32(v.GetRadelci()),
				},
			},
		})
	}

	s.logger.Debugw("radelci dodani vsem udeležencem igre")

	go func() {
		if game.TournamentID != "" {
			for {
				select {
				case m := <-game.TournamentMessaging:
					ss := strings.Split(m, " ")
					if len(ss) == 0 {
						continue
					}
					mes := ss[0]
					if mes == "tournamentEnd" {
						s.EndGame(gameId)
						return
					} else if mes == "tournamentNewGame" {
						s.StartGame(gameId)
						return
					} else if mes == "tournamentCountdown" {
						cnt, err := strconv.ParseInt(ss[1], 10, 32)
						if err != nil {
							continue
						}
						s.Broadcast(
							"",
							gameId,
							&messages.Message{
								Data: &messages.Message_GameStartCountdown{GameStartCountdown: &messages.GameStartCountdown{Countdown: int32(cnt)}},
							},
						)
					}
				}
			}
		}
		for i := 0; i <= 15; i++ {
			s.Broadcast(
				"",
				gameId,
				&messages.Message{
					Data: &messages.Message_GameStartCountdown{GameStartCountdown: &messages.GameStartCountdown{Countdown: int32(15 - i)}},
				},
			)
			time.Sleep(time.Second)
			if game.GameCount != gameCount || game.WaitingFor != "results" {
				s.Broadcast(
					"",
					gameId,
					&messages.Message{
						Data: &messages.Message_GameStartCountdown{GameStartCountdown: &messages.GameStartCountdown{Countdown: 0}},
					},
				)
				// igra se je že začela, posledično ne potrebujemo igre začeti še enkrat
				return
			}
		}
		if (game.GameCount == game.GamesRequired || game.GamesRequired == -1) && !game.Replay {
			noClients := 0
			for _, v := range game.Players {
				if !v.GetBotStatus() && len(v.GetClients()) == 0 {
					noClients++
				}
			}

			if noClients > 0 || (game.VotedAdditionOfGames <= 0 && game.GamesRequired != -1) {
				s.EndGame(gameId)
				return
			}
			if game.GamesRequired == -1 {
				game.GamesRequired = game.GameCount + game.VotedAdditionOfGames
			} else {
				game.GamesRequired += game.VotedAdditionOfGames
			}
			if game.VotedAdditionOfGames == 1 {
				game.SkisRunda = true
				game.CanExtendGame = false
			}
		}
		s.StartGame(gameId)
	}()
}
