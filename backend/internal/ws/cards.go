package ws

import (
	"fmt"
	"github.com/mytja/Tarok/backend/internal/consts"
	"github.com/mytja/Tarok/backend/internal/helpers"
	"github.com/mytja/Tarok/backend/internal/messages"
	"math"
	"strconv"
	"strings"
	"time"
)

func (s *serverImpl) FakeGoroutineCards(gameId string) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}

	go func() {
		select {
		case <-game.EndTimer:
			return
		}
	}()
}

func (s *serverImpl) BotGoroutineCards(gameId string, playing string) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}

	player, exists := game.Players[playing]
	if !exists {
		return
	}

	game.WaitingFor = playing

	go func() {
		s.logger.Debugw("starting goroutine cards", "userId", playing, "gameId", gameId)
		t := time.Now()
		timer := player.GetTimer()
		done := false

		s.StartTimerBroadcast(gameId, playing, timer)

		// tole mora biti tukaj, drugače se lahko boti prehitevajo
		if player.GetBotStatus() {
			if game.TournamentID == "" || !game.TimeoutReached {
				// v primeru turnirja ob timeoutu ne potrebujemo še botov zaustavljati
				time.Sleep(490 * time.Millisecond)
			}

			time.Sleep(10 * time.Millisecond)

			s.logger.Debugw("time exceeded by bot")
			go s.BotCard(gameId, playing)
			done = true
		}

		if game.TournamentID != "" && game.TimeoutReached && !player.GetBotStatus() {
			s.logger.Debugw("time exceeded by tournament timeout")
			time.Sleep(10 * time.Millisecond)
			go s.BotCard(gameId, playing)
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
				s.logger.Debugw("timer ended", "seconds", time.Now().Sub(t).Seconds(), "timer", timer, "gameId", gameId, "userId", playing)
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
					continue
				}
				if !(len(player.GetClients()) == 0 || time.Now().Sub(t).Seconds() > timer || game.TimeoutReached) {
					continue
				}

				s.logger.Debugw("time exceeded", "seconds", time.Now().Sub(t).Seconds(), "timer", timer, "gameId", gameId, "userId", playing)
				go s.BotCard(gameId, playing)
				done = true
			}
		}
	}()
}

func (s *serverImpl) BroadcastOpenBeggarCards(gameId string) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}
	if game.GameMode != 8 {
		return
	}
	playing, exists := game.Players[game.CurrentPredictions.Igra.Id]
	if !exists {
		return
	}
	for _, v := range playing.GetCards() {
		cardMsg := &messages.Message{
			PlayerId: game.CurrentPredictions.Igra.Id,
			Data: &messages.Message_Card{
				Card: &messages.Card{
					Id: v.id,
					Type: &messages.Card_Receive{
						Receive: &messages.Receive{},
					},
				},
			},
		}
		s.Broadcast(game.CurrentPredictions.Igra.Id, gameId, cardMsg)
	}
}

func (s *serverImpl) BroadcastAllCards(gameId string) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}
	for _, player := range game.Players {
		if game.GameMode == 8 && len(game.Playing) != 0 && player.GetUser().ID == game.Playing[0] {
			continue
		}
		for _, v := range player.GetCards() {
			cardMsg := &messages.Message{
				PlayerId: player.GetUser().ID,
				Data: &messages.Message_Card{
					Card: &messages.Card{
						Id: v.id,
						Type: &messages.Card_Receive{
							Receive: &messages.Receive{},
						},
					},
				},
			}
			s.Broadcast(player.GetUser().ID, gameId, cardMsg)
		}
	}
}

func (s *serverImpl) FirstCard(gameId string) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}

	game.CardsStarted = true

	var msg *messages.Message
	if game.GameMode <= 5 {
		msg = &messages.Message{
			PlayerId: game.Starts[0],
			Data:     &messages.Message_Card{Card: &messages.Card{Type: &messages.Card_Request{Request: &messages.Request{}}}},
		}
	} else {
		s.BroadcastOpenBeggarCards(gameId)

		msg = &messages.Message{
			PlayerId: game.CurrentPredictions.Igra.Id,
			Data:     &messages.Message_Card{Card: &messages.Card{Type: &messages.Card_Request{Request: &messages.Request{}}}},
		}
	}
	game.Players[msg.PlayerId].BroadcastToClients(msg)

	s.BotGoroutineCards(gameId, msg.PlayerId)
}

func (s *serverImpl) returnCardToSender(id string, gameId string, userId string, clientId string) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}
	game.Players[userId].SendToClient(clientId, &messages.Message{
		PlayerId: userId,
		Data: &messages.Message_Card{
			Card: &messages.Card{
				Id:     id,
				UserId: userId,
				Type: &messages.Card_Receive{
					Receive: &messages.Receive{},
				},
			},
		},
	})
	game.Players[userId].SendToClient(clientId, &messages.Message{
		PlayerId: userId,
		Data:     &messages.Message_Card{Card: &messages.Card{Type: &messages.Card_Request{Request: &messages.Request{}}}},
	})
}

func (s *serverImpl) BotCard(gameId string, playing string) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}

	player, exists := game.Players[playing]
	if !exists {
		return
	}

	s.logger.Debugw("bot card called", "gameId", gameId, "userId", playing)

	sT := time.Now()
	card := strings.ReplaceAll(string(s.StockSkisExec("card", playing, gameId)), "\n", "")
	eT := time.Now()

	player.BroadcastToClients(&messages.Message{
		PlayerId: playing,
		Data: &messages.Message_Card{Card: &messages.Card{
			Id:     card,
			UserId: playing,
			Type:   &messages.Card_Remove{Remove: &messages.Remove{}},
		}},
	})
	eT2 := time.Now()
	s.logger.Debugw("stockškis call executed and timed", "stockskis", eT.Sub(sT).Milliseconds(), "broadcast", eT2.Sub(eT).Milliseconds())

	s.CardDrop(card, gameId, playing, "")
}

func (s *serverImpl) CardDrop(id string, gameId string, userId string, clientId string) {
	game, exists := s.games[gameId]
	if !exists {
		s.logger.Warnw("game doesn't exist", "cardId", id, "gameId", gameId, "userId", userId)
		return
	}

	game.MovesPlayed++

	if !game.CardsStarted {
		s.logger.Warnw("cards haven't started", "cardId", id, "gameId", gameId, "userId", userId, "cardsStarted", game.CardsStarted)

		// dumbo, pls wait for the game to actually start
		//s.returnCardToSender(id, gameId, userId, clientId)
		return
	}

	if game.WaitingFor != userId {
		s.logger.Warnw("invalid person in queue", "cardId", id, "gameId", gameId, "userId", userId, "cardsStarted", game.CardsStarted, "waitingFor", game.WaitingFor)
		//s.returnCardToSender(id, gameId, userId, clientId)
		return
	}

	placedCard := helpers.ParseCardID(id)
	placedCardDef, err := consts.GetCardByID(id)
	if err != nil {
		s.logger.Warnw("invalid card")

		//s.returnCardToSender(id, gameId, userId, clientId)
		return
	}

	zadnjiStih := game.Stihi[len(game.Stihi)-1]

	if len(zadnjiStih) != 0 {
		// standardni del
		card := helpers.ParseCardID(zadnjiStih[0].id)
		imaTarok := false
		imaBarvo := false
		imaKarto := false
		imaPalcko := false
		cards := game.Players[userId].GetCards()
		for _, v := range cards {
			t := helpers.ParseCardID(v.id)

			s.logger.Debugw("user card", "card", t.Full, "userId", userId)

			if t.Full == id {
				imaKarto = true
			}
			if t.Type == "taroki" {
				imaTarok = true
			} else if t.Type == card.Type {
				imaBarvo = true
			}
			if t.Full == "/taroki/pagat" {
				imaPalcko = true
			}

			if imaTarok && imaBarvo && imaKarto && imaPalcko {
				break
			}
		}
		s.logger.Debugw("player cards", "userId", userId, "cardId", id)
		if !imaKarto {
			s.logger.Warnw("the player shall be removed from this game for using cheats", "gameId", gameId, "userId", userId, "starts", game.Starts)
			for _, v := range game.Players[userId].GetCards() {
				s.logger.Warnw("cheating cards", "card", v)
			}
			return
		}
		if imaBarvo && placedCard.Type != card.Type {
			s.logger.Debugw("returning the card to the user due to him having the correct colour", "card", card.Full, "type", placedCard.Type)
			//s.returnCardToSender(id, gameId, userId, clientId)
			return
		} else if !imaBarvo && imaTarok && placedCard.Type != "taroki" {
			s.logger.Debugw("returning the card to the user due to him having tarocks", "card", card.Full, "type", placedCard.Type)
			//s.returnCardToSender(id, gameId, userId, clientId)
			return
		}

		trula := 0
		for _, v := range zadnjiStih {
			if v.id == "/taroki/skis" || v.id == "/taroki/mond" {
				trula++
			}
			if trula == 2 && (imaPalcko && id != "/taroki/pagat") {
				s.logger.Debugw("returning the card to the user due to him having pagat while škis and mond have fallen", "card", card.Full, "type", placedCard.Type)
				//s.returnCardToSender(id, gameId, userId, clientId)
				return
			}
		}

		if game.GameMode == 6 || game.GameMode == 8 || game.GameMode == -1 {
			// berač/odprti berač/klop del
			c, err := consts.GetCardByID(zadnjiStih[0].id)
			if err != nil {
				s.logger.Warnw("invalid card")

				//s.returnCardToSender(id, gameId, userId, clientId)
				return
			}
			maxValue := c
			for _, v := range zadnjiStih {
				cardParsed := helpers.ParseCardID(maxValue.File)
				cc, err := consts.GetCardByID(v.id)
				if err != nil {
					s.logger.Warnw("invalid card")

					//s.returnCardToSender(id, gameId, userId, clientId)
					return
				}
				ccParsed := helpers.ParseCardID(v.id)

				if ((ccParsed.Type == "taroki" && !imaBarvo) || cardParsed.Type == ccParsed.Type) && cc.WorthOver > maxValue.WorthOver {
					s.logger.Debugw("nastavljam maxValue", "cc", cc, "cardParsed", cardParsed, "imaBarvo", imaBarvo, "maxValue", maxValue)
					maxValue = cc
				}
			}

			trenutnaKarta := helpers.ParseCardID(maxValue.File)

			imaVisjo := false
			for _, v := range game.Players[userId].GetCards() {
				t := helpers.ParseCardID(v.id)
				c, err := consts.GetCardByID(v.id)
				if err != nil {
					s.logger.Warnw("invalid card")

					//s.returnCardToSender(id, gameId, userId, clientId)
					return
				}

				s.logger.Debugw("user card", "card", t.Full, "userId", userId, "worth over", c.WorthOver, "worth", c.Worth)

				if (trenutnaKarta.Type == t.Type || (t.Type == "taroki" && !imaBarvo)) && maxValue.WorthOver < c.WorthOver {
					imaVisjo = true
				}
			}

			if imaVisjo && placedCardDef.WorthOver < maxValue.WorthOver {
				s.logger.Warnw("user has a higher ranked card than current one", "placedCard", placedCardDef, "maxValue", maxValue)

				//s.returnCardToSender(id, gameId, userId, clientId)
				return
			}
		}
	} else {
		cards := game.Players[userId].GetCards()
		found := false
		for _, v := range cards {
			if v.id != id {
				continue
			}
			found = true
			break
		}
		if !found {
			s.logger.Warnw("user doesn't have the sent card", "id", id, "userId", userId)
			return
		}
	}

	s.logger.Debugw("ending timer cards")

	game.EndTimer <- true

	s.logger.Debugw("ended timer cards")

	zadnjiStih = append(zadnjiStih, Card{
		id:     id,
		userId: userId,
	})
	game.Stihi[len(game.Stihi)-1] = zadnjiStih

	if game.PlayingIn == id {
		for i := range game.Players {
			game.Players[i].SetHasKingFallen()
		}
	}

	s.logger.Debug("removing card ", id)
	game.Players[userId].RemoveCardByID(id)
	s.logger.Debug("removed card ", id)

	s.Broadcast("", gameId, &messages.Message{
		PlayerId: userId,
		Data: &messages.Message_Card{
			Card: &messages.Card{
				Id:     id,
				UserId: userId,
				Type: &messages.Card_Send{
					Send: &messages.Send{},
				},
			},
		},
	})

	// obvestimo še naslednjega igralca, da naj vrže karto
	currentPlayer := 0
	for i, v := range game.Starts {
		if v == userId {
			s.logger.Debugw("found user", "userId", userId, "v", v, "i", i)
			currentPlayer = i
			break
		}
	}
	currentPlayer++
	if currentPlayer >= game.PlayersNeeded {
		currentPlayer = 0
	}
	game.WaitingFor = game.Starts[currentPlayer]

	s.logger.Debugw(
		"trenutni igralec",
		"p", currentPlayer,
		"stih", zadnjiStih,
		"len", len(game.Stihi),
		"needed", game.PlayersNeeded,
		"userId", game.Starts[currentPlayer],
	)

	if len(zadnjiStih) >= game.PlayersNeeded && len(game.Stihi) >= (54-6)/game.PlayersNeeded {
		s.Results(gameId)
		return
	}

	if len(zadnjiStih) >= game.PlayersNeeded {
		if game.GameMode == -1 && len(game.Talon) != 0 {
			// igramo klopa, pošljemo še za talon
			karta := game.Talon[0]
			karta.userId = "talon"
			game.Talon = helpers.RemoveOrdered(game.Talon, 0)
			zadnjiStih = append(zadnjiStih, karta)
			game.Stihi[len(game.Stihi)-1] = zadnjiStih

			s.Broadcast("", gameId, &messages.Message{
				PlayerId: "talon",
				Data: &messages.Message_Card{
					Card: &messages.Card{
						Id:     karta.id,
						UserId: "talon",
						Type: &messages.Card_Send{
							Send: &messages.Send{},
						},
					},
				},
			})
		}

		t := time.Now()
		for {
			if (game.TimeoutReached && time.Now().Sub(t).Milliseconds() > 10) || time.Now().Sub(t).Seconds() > 1 {
				s.logger.Debugw("pucam štihe")
				game.MovesPlayed += 2
				s.Broadcast("", gameId, &messages.Message{
					PlayerId: userId,
					Data: &messages.Message_ClearDesk{
						ClearDesk: &messages.ClearDesk{},
					},
				})
				break
			}
		}

		canGameEndEarly, _ := strconv.ParseBool(strings.ReplaceAll(string(s.StockSkisExec("gameEndEarly", "1", gameId)), "\n", ""))
		if canGameEndEarly {
			s.BroadcastAllCards(gameId)
			if !game.TimeoutReached {
				time.Sleep(1 * time.Second)
			} else {
				time.Sleep(10 * time.Millisecond)
			}
			s.Results(gameId)
			return
		}

		stockskisUser := strings.ReplaceAll(string(s.StockSkisExec("lastStih", "1", gameId)), "\n", "")
		fmt.Println(stockskisUser)

		game.Stihi = append(game.Stihi, []Card{})

		player := game.Players[stockskisUser]

		// Autodrop cards
		if len(player.GetCards()) == 1 {
			if game.TimeoutReached {
				time.Sleep(10 * time.Millisecond)
			} else {
				time.Sleep(500 * time.Millisecond)
			}
			card := player.GetCards()[0]
			player.BroadcastToClients(&messages.Message{
				PlayerId: stockskisUser,
				Data: &messages.Message_Card{Card: &messages.Card{
					Id:     card.id,
					UserId: card.userId,
					Type:   &messages.Card_Remove{Remove: &messages.Remove{}},
				}},
			})
			game.WaitingFor = stockskisUser
			s.FakeGoroutineCards(gameId)
			s.CardDrop(card.id, gameId, stockskisUser, "")
			return
		}

		s.Broadcast("", gameId, &messages.Message{
			PlayerId: stockskisUser,
			Data:     &messages.Message_Card{Card: &messages.Card{Type: &messages.Card_Request{Request: &messages.Request{}}}},
		})

		s.BotGoroutineCards(gameId, stockskisUser)
	} else {
		uid := game.Starts[currentPlayer]

		player := game.Players[uid]

		// Autodrop cards
		if len(player.GetCards()) == 1 {
			if game.TimeoutReached {
				time.Sleep(10 * time.Millisecond)
			} else {
				time.Sleep(500 * time.Millisecond)
			}
			card := player.GetCards()[0]
			player.BroadcastToClients(&messages.Message{
				PlayerId: uid,
				Data: &messages.Message_Card{Card: &messages.Card{
					Id:     card.id,
					UserId: card.userId,
					Type:   &messages.Card_Remove{Remove: &messages.Remove{}},
				}},
			})
			game.WaitingFor = uid
			s.FakeGoroutineCards(gameId)
			s.CardDrop(card.id, gameId, uid, "")
			return
		}

		s.Broadcast("", gameId, &messages.Message{
			PlayerId: uid,
			Data:     &messages.Message_Card{Card: &messages.Card{Type: &messages.Card_Request{Request: &messages.Request{}}}},
		})

		s.BotGoroutineCards(gameId, uid)
	}
}
