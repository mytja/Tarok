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

func (s *serverImpl) BotGoroutineCards(gameId string, playing string) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}

	go func() {
		t := time.Now()
		timer := game.Players[playing].GetTimer()
		done := false

		for {
			select {
			case <-game.EndTimer:
				s.logger.Debugw("timer ended", "seconds", time.Now().Sub(t).Seconds(), "timer", timer)
				s.games[gameId].Players[playing].SetTimer(math.Max(timer-time.Now().Sub(t).Seconds(), 0) + game.AdditionalTime)
				return
			default:
				if done {
					continue
				}
				if !(len(s.games[gameId].Players[playing].GetClients()) == 0 || time.Now().Sub(t).Seconds() > timer) {
					continue
				}
				s.logger.Debugw("time exceeded", "seconds", time.Now().Sub(t).Seconds(), "timer", timer)
				s.BotCard(gameId, playing)
				done = true
			}
		}
	}()
}

func (s *serverImpl) FirstCard(gameId string) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}
	var msg *messages.Message
	if game.GameMode <= 5 {
		msg = &messages.Message{
			PlayerId: game.Starts[0],
			GameId:   gameId,
			Data:     &messages.Message_Card{Card: &messages.Card{Type: &messages.Card_Request{Request: &messages.Request{}}}},
		}
	} else {
		msg = &messages.Message{
			PlayerId: game.CurrentPredictions.Igra.Id,
			GameId:   gameId,
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
		GameId:   gameId,
		Data:     &messages.Message_Card{Card: &messages.Card{Type: &messages.Card_Request{Request: &messages.Request{}}}},
	})
}

func (s *serverImpl) BotCard(gameId string, playing string) {
	card := strings.ReplaceAll(string(s.StockSkisExec("stash", playing, gameId)), "\n", "")
	s.CardDrop(card, gameId, playing, "")
}

func (s *serverImpl) CardDrop(id string, gameId string, userId string, clientId string) {
	game, exists := s.games[gameId]
	if !exists {
		s.logger.Warnw("game doesn't exist", "cardId", id, "gameId", gameId, "userId", userId)
		return
	}
	if !game.CardsStarted {
		s.logger.Warnw("cards haven't started", "cardId", id, "gameId", gameId, "userId", userId, "cardsStarted", game.CardsStarted)

		// dumbo, pls wait for the game to actually start
		s.returnCardToSender(id, gameId, userId, clientId)
		return
	}

	// TODO: check user queue
	placedCard := helpers.ParseCardID(id)
	placedCardDef, err := consts.GetCardByID(id)
	if err != nil {
		s.logger.Warnw("invalid card")

		s.returnCardToSender(id, gameId, userId, clientId)
		return
	}

	zadnjiStih := game.Stihi[len(game.Stihi)-1]

	if len(zadnjiStih) != 0 {
		// standardni del
		card := helpers.ParseCardID(zadnjiStih[0].id)
		imaTarok := false
		imaBarvo := false
		imaKarto := false
		for _, v := range game.Players[userId].GetCards() {
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
			if imaTarok && imaBarvo && imaKarto {
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
			s.returnCardToSender(id, gameId, userId, clientId)
			return
		} else if !imaBarvo && imaTarok && placedCard.Type != "taroki" {
			s.logger.Debugw("returning the card to the user due to him having tarocks", "card", card.Full, "type", placedCard.Type)
			s.returnCardToSender(id, gameId, userId, clientId)
			return
		}

		if game.GameMode == 6 || game.GameMode == 8 || game.GameMode == -1 {
			// berač/odprti berač/klop del
			c, err := consts.GetCardByID(zadnjiStih[0].id)
			if err != nil {
				s.logger.Warnw("invalid card")

				s.returnCardToSender(id, gameId, userId, clientId)
				return
			}
			maxValue := c
			for _, v := range zadnjiStih {
				cardParsed := helpers.ParseCardID(maxValue.File)
				cc, err := consts.GetCardByID(v.id)
				if err != nil {
					s.logger.Warnw("invalid card")

					s.returnCardToSender(id, gameId, userId, clientId)
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

					s.returnCardToSender(id, gameId, userId, clientId)
					return
				}

				s.logger.Debugw("user card", "card", t.Full, "userId", userId, "worth over", c.WorthOver, "worth", c.Worth)

				if (trenutnaKarta.Type == t.Type || (t.Type == "taroki" && !imaBarvo)) && maxValue.WorthOver < c.WorthOver {
					imaVisjo = true
				}
			}

			if imaVisjo && placedCardDef.WorthOver < maxValue.WorthOver {
				s.logger.Warnw("user has a higher ranked card than current one", "placedCard", placedCardDef, "maxValue", maxValue)

				s.returnCardToSender(id, gameId, userId, clientId)
				return
			}
		}
	} else {
		// TODO: preveri če ma uporabnik sploh karto
	}

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
	s.games[gameId] = game

	s.Broadcast("", &messages.Message{
		PlayerId: userId,
		GameId:   gameId,
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
			currentPlayer = i
			break
		}
	}
	currentPlayer++
	if currentPlayer >= game.PlayersNeeded {
		currentPlayer = 0
	}
	game.WaitingFor = currentPlayer

	s.logger.Debugw(
		"trenutni igralec",
		"p", currentPlayer,
		"stih", zadnjiStih,
		"len", len(game.Stihi),
		"needed", game.PlayersNeeded,
	)
	if len(zadnjiStih) >= game.PlayersNeeded {
		if game.GameMode == -1 && len(game.Talon) != 0 {
			// igramo klopa, pošljemo še za talon
			karta := game.Talon[0]
			karta.userId = "talon"
			game.Talon = helpers.RemoveOrdered(game.Talon, 0)
			zadnjiStih = append(zadnjiStih, karta)
			game.Stihi[len(game.Stihi)-1] = zadnjiStih

			s.Broadcast("", &messages.Message{
				GameId:   gameId,
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

		game.Stihi = append(game.Stihi, []Card{})
		t := time.Now()
		for {
			if time.Now().Sub(t).Seconds() > 1 {
				s.logger.Debugw("pucam štihe")
				s.Broadcast("", &messages.Message{
					PlayerId: userId,
					GameId:   gameId,
					Data: &messages.Message_ClearDesk{
						ClearDesk: &messages.ClearDesk{},
					},
				})
				break
			}
		}

		canGameEndEarly, _ := strconv.ParseBool(strings.ReplaceAll(string(s.StockSkisExec("gameEndEarly", "1", gameId)), "\n", ""))
		if canGameEndEarly {
			s.games[gameId] = game
			s.Results(gameId)
			return
		}

		stockskisUser := strings.ReplaceAll(string(s.StockSkisExec("lastStih", "1", gameId)), "\n", "")
		fmt.Println(stockskisUser)
		user, exists := game.Players[stockskisUser]
		if !exists {
			// kaj takega se ne bi smelo zgoditi
			s.logger.Errorw("stockškis user doesn't exist", "user", stockskisUser, "game", gameId)
		}
		user.BroadcastToClients(&messages.Message{
			PlayerId: stockskisUser,
			GameId:   gameId,
			Data:     &messages.Message_Card{Card: &messages.Card{Type: &messages.Card_Request{Request: &messages.Request{}}}},
		})
	} else {
		game.Players[game.Starts[currentPlayer]].BroadcastToClients(&messages.Message{
			PlayerId: userId,
			GameId:   gameId,
			Data:     &messages.Message_Card{Card: &messages.Card{Type: &messages.Card_Request{Request: &messages.Request{}}}},
		})
	}

	s.games[gameId] = game

	if len(zadnjiStih) >= game.PlayersNeeded && len(game.Stihi) > (54-6)/game.PlayersNeeded {
		s.Results(gameId)
	}
}
