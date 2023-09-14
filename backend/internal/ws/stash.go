package ws

import (
	"encoding/json"
	"github.com/mytja/Tarok/backend/internal/messages"
	"math"
	"strings"
	"time"
)

func (s *serverImpl) BotStash(gameId string, playing string) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}

	time.Sleep(500 * time.Millisecond)
	// enable superpowers of stockškis
	var i []StockSkisCard
	err := json.Unmarshal([]byte(strings.ReplaceAll(string(s.StockSkisExec("stash", playing, gameId)), "\n", "")), &i)
	if err != nil {
		s.logger.Warnw("error while executing stockškis", "error", err)
		return
	}
	cards := make([]*messages.Card, 0)
	for _, v := range i {
		message := &messages.Card{
			Id:     v.Card.Asset,
			UserId: playing,
		}
		cards = append(cards, message)

		game.Players[playing].BroadcastToClients(&messages.Message{
			PlayerId: playing,
			GameId:   gameId,
			Data: &messages.Message_Card{Card: &messages.Card{
				Id:     v.Card.Asset,
				UserId: playing,
				Type:   &messages.Card_Remove{Remove: &messages.Remove{}},
			}},
		})
	}
	s.StashedCards(playing, gameId, "", cards)
}

func (s *serverImpl) Stash(gameId string) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}

	s.logger.Debugw("stash called", "gameId", gameId)

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
		return
	}

	prompt := messages.Message{PlayerId: playing, GameId: gameId, Data: &messages.Message_Stash{Stash: &messages.Stash{Length: int32(kart), Type: &messages.Stash_Request{Request: &messages.Request{}}}}}
	player.BroadcastToClients(&prompt)

	go func() {
		t := time.Now()
		timer := player.GetTimer()
		done := false

		if player.GetBotStatus() {
			time.Sleep(500 * time.Millisecond)

			s.logger.Debugw("time exceeded by bot")
			go s.BotStash(gameId, playing)
			done = true
		}

		for {
			select {
			case <-game.EndTimer:
				s.logger.Debugw("timer ended", "seconds", time.Now().Sub(t).Seconds(), "timer", timer)
				player.SetTimer(math.Max(timer-time.Now().Sub(t).Seconds(), 0) + game.AdditionalTime)
				s.EndTimerBroadcast(gameId, playing, player.GetTimer())
				return
			case <-time.After(1 * time.Second):
				if done {
					continue
				}
				s.EndTimerBroadcast(gameId, playing, math.Max(timer-time.Now().Sub(t).Seconds(), 0))
				if !(len(player.GetClients()) == 0 || time.Now().Sub(t).Seconds() > timer) {
					continue
				}
				s.logger.Debugw("time exceeded", "seconds", time.Now().Sub(t).Seconds(), "timer", timer)
				go s.BotStash(gameId, playing)
				done = true
			}
		}
	}()
}

func (s *serverImpl) StashedCards(userId string, gameId string, clientId string, cards []*messages.Card) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}
	game.Stashed = make([]Card, 0)
	playing := game.Playing[0]
	if userId != playing {
		s.logger.Warnw("modified client detected", "userId", userId)
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
		return
	}

	t := 0
	for _, card := range cards {
		if !game.Players[playing].ImaKarto(card.Id) {
			s.logger.Warnw("modified client detected", "userId", userId)
			return
		}
		t++
	}

	if t != kart {
		s.logger.Warnw("modified client detected", "userId", userId)
		return
	}

	if len(game.Stashed) > 0 {
		s.logger.Warnw("this has already been stashed", "userId", userId)
		for _, v := range cards {
			found := false
			for _, n := range game.Stashed {
				if n.id != v.Id {
					continue
				}
				found = true
				break
			}
			if found {
				// če je karta založena je ne pošiljamo še enkrat
				continue
			}

			s.returnCardToSender(v.Id, gameId, playing, clientId)
		}
		return
	}

	for _, card := range cards {
		for k, c := range game.Players[userId].GetCards() {
			if c.id != card.Id {
				continue
			}
			c.userId = userId
			game.Stashed = append(game.Stashed, c)
			game.Players[userId].RemoveCard(k)
			break
		}
	}

	game.Players[userId].AssignArchive()

	s.logger.Debugw("cards", "current", game.Players[userId].GetCards(), "archived", game.Players[userId].GetArchivedCards())

	game.EndTimer <- true

	s.logger.Debugw("sent EndTimer")

	time.Sleep(3 * time.Second)
	s.FirstPrediction(gameId)
}
