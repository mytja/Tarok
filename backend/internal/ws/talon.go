package ws

import (
	"github.com/mytja/Tarok/backend/internal/helpers"
	"github.com/mytja/Tarok/backend/internal/messages"
	"math"
	"strconv"
	"strings"
	"time"
)

func (s *serverImpl) BotTalon(gameId string, playing string) {
	// enable superpowers of stockškis
	talon, err := strconv.ParseInt(strings.ReplaceAll(string(s.StockSkisExec("talon", playing, gameId)), "\n", ""), 10, 32)
	if err != nil {
		return
	}
	s.TalonSelected(playing, gameId, int32(talon))
}

func (s *serverImpl) Talon(gameId string) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}

	if game.GameMode >= 6 || game.GameMode == -1 {
		s.FirstPrediction(gameId)
		return
	}

	playing := game.Playing[0]
	player, exists := game.Players[playing]
	if !exists {
		return
	}

	kart := 0
	if game.GameMode == 0 || game.GameMode == 3 {
		kart = 3
	} else if game.GameMode == 1 || game.GameMode == 4 {
		kart = 2
	} else if game.GameMode == 2 || game.GameMode == 5 {
		kart = 1
	} else {
		// talon se sploh ne prikaže, preskočimo ta del
		s.FirstCard(gameId)
		return
	}
	decks := make([]*messages.Stih, 0)
	deck := make([]*messages.Card, 0)
	for _, v := range game.Talon {
		deck = append(deck, &messages.Card{Id: v.id})
		if len(deck) == kart {
			decks = append(decks, &messages.Stih{Card: deck})
			deck = make([]*messages.Card, 0)
		}
	}
	broadcast := messages.Message{PlayerId: playing, Data: &messages.Message_TalonReveal{TalonReveal: &messages.TalonReveal{Stih: decks}}}
	s.Broadcast("", gameId, &broadcast)

	prompt := messages.Message{PlayerId: playing, Data: &messages.Message_TalonSelection{TalonSelection: &messages.TalonSelection{Type: &messages.TalonSelection_Request{Request: &messages.Request{}}}}}
	player.BroadcastToClients(&prompt)

	game.WaitingFor = "talon"

	go func() {
		t := time.Now()
		timer := player.GetTimer()
		done := false

		s.StartTimerBroadcast(gameId, playing, timer)

		if player.GetBotStatus() {
			if !game.TimeoutReached {
				time.Sleep(480 * time.Millisecond)
			}
			time.Sleep(10 * time.Millisecond)

			s.logger.Debugw("time exceeded by bot")
			go s.BotTalon(gameId, playing)
			done = true
		}

		if game.TournamentID != "" && game.TimeoutReached && !player.GetBotStatus() {
			time.Sleep(10 * time.Millisecond)

			s.logger.Debugw("time exceeded by tournament timeout")
			go s.BotTalon(gameId, playing)
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
				return
			case <-time.After(1 * time.Second):
				game, exists = s.games[gameId]
				if !exists {
					s.logger.Errorw("game doesn't exist, exiting", "gameId", gameId)
					return
				}

				if done {
					continue
				}

				if !(len(player.GetClients()) == 0 || time.Now().Sub(t).Seconds() > timer || game.TimeoutReached) {
					continue
				}
				s.logger.Debugw("time exceeded", "seconds", time.Now().Sub(t).Seconds(), "timer", timer)
				go s.BotTalon(gameId, playing)
				done = true
			}
		}
	}()
}

func (s *serverImpl) TalonSelected(userId string, gameId string, part int32) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}

	game.MovesPlayed++

	playing := game.Playing[0]
	if game.WaitingFor != "talon" {
		s.logger.Warnw("modified client detected", "userId", userId)
		return
	}
	if userId != playing {
		s.logger.Warnw("modified client detected", "userId", userId)
		return
	}

	decks := make([][]Card, 0)
	decks = append(decks, make([]Card, 0))
	kart := 0
	if game.GameMode == 0 || game.GameMode == 3 {
		kart = 3
	} else if game.GameMode == 1 || game.GameMode == 4 {
		kart = 2
	} else if game.GameMode == 2 || game.GameMode == 5 {
		kart = 1
	} else {
		// talon se sploh ne prikaže, preskočimo ta del
		return
	}
	if len(game.Talon) != 6 {
		s.logger.Warnw("modified client detected", "userId", userId)
		return
	}

	for _, v := range game.Talon {
		l := len(decks) - 1
		decks[l] = append(decks[l], v)
		if len(decks[l]) == kart {
			decks = append(decks, make([]Card, 0))
		}
	}

	if int32(len(decks)) <= part {
		return
	}

	talon := decks[part]

	broadcast := &messages.Message{PlayerId: playing, Data: &messages.Message_TalonSelection{TalonSelection: &messages.TalonSelection{Part: part, Type: &messages.TalonSelection_Send{Send: &messages.Send{}}}}}
	s.Broadcast("", gameId, broadcast)

	// pošljemo nove karte igralcu
	for _, c := range talon {
		for i, v := range game.Talon {
			if v.id != c.id {
				continue
			}
			game.Talon = helpers.Remove(game.Talon, i)
		}
		game.Players[playing].BroadcastToClients(
			&messages.Message{
				PlayerId: playing,
				Data: &messages.Message_Card{
					Card: &messages.Card{
						Id:     c.id,
						UserId: playing,
						Type: &messages.Card_Receive{
							Receive: &messages.Receive{},
						},
					},
				},
			},
		)

		// izmenjava kart iz talona
		c.userId = playing

		game.Players[playing].AddCard(c)
	}

	for i := range game.Players {
		game.Players[i].SetHasKing(game.PlayingIn)
	}

	s.logger.Debugw("end timer called")
	game.EndTimer <- true
	s.logger.Debugw("end timer sent")

	s.Stash(gameId)
}
