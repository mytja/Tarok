package ws

import (
	"github.com/mytja/Tarok/backend/internal/consts"
	"github.com/mytja/Tarok/backend/internal/helpers"
	"github.com/mytja/Tarok/backend/internal/messages"
	"math/rand"
	"strings"
	"time"
)

func Shuffle[T any](slc []T) []T {
	N := len(slc)
	for i := 0; i < N; i++ {
		// choose index uniformly in [i, N-1]
		r := i + rand.Intn(N-i)
		slc[r], slc[i] = slc[i], slc[r]
	}
	return slc
}

func (s *serverImpl) TransformCards(cards []consts.Card, userId string) []Card {
	c := make([]Card, 0)
	for _, v := range cards {
		c = append(c, Card{
			id:     v.File,
			userId: userId,
		})
	}
	return c
}

func (s *serverImpl) ShuffleCards(gameId string) {
	for {
		game, exists := s.games[gameId]
		if !exists {
			s.logger.Errorw("game has finished, it doesn't exist, exiting", "gameId", gameId)
			return
		}

		if game.TournamentID != "" {
			for kk, userId := range game.Starts {
				cs, err := s.db.GetTournamentCards(game.TournamentID, game.GameCount, kk)
				if err != nil {
					s.logger.Errorw("could not transform cards inside tournament", "err", err)
					return
				}
				cards := s.TransformCards(cs, userId)
				for _, card := range cards {
					game.Players[userId].AddCard(card)
					game.Players[userId].BroadcastToClients(&messages.Message{
						PlayerId: userId,
						Data: &messages.Message_Card{
							Card: &messages.Card{
								Id:     card.id,
								UserId: userId,
								Type: &messages.Card_Receive{
									Receive: &messages.Receive{},
								},
							},
						},
					})
				}
			}
			tl, err := s.db.GetTournamentCards(game.TournamentID, game.GameCount, -1)
			if err != nil {
				s.logger.Errorw("could not transform cards inside tournament", "err", err)
				return
			}
			game.Talon = s.TransformCards(tl, "")
			break
		}

		cards := make([]consts.Card, 0)
		cards = append(cards, consts.CARDS...)
		cards = Shuffle(cards)
		imaTaroka := false
		skisDolocen := -1
		for kk, userId := range game.Starts {
			imaTaroka = false
			for i := 0; i < (54-6)/game.PlayersNeeded; i++ {
				if strings.Contains(cards[0].File, "taroki") {
					imaTaroka = true
				}

				game.Players[userId].BroadcastToClients(&messages.Message{
					PlayerId: userId,
					Data: &messages.Message_Card{
						Card: &messages.Card{
							Id:     cards[0].File,
							UserId: userId,
							Type: &messages.Card_Receive{
								Receive: &messages.Receive{},
							},
						},
					},
				})
				if cards[0].File == "/taroki/skis" {
					skisDolocen = kk
				}
				game.Players[userId].AddCard(Card{
					id:     cards[0].File,
					userId: userId,
				})
				cards = helpers.Remove(cards, 0)
			}
			if !imaTaroka {
				break
			}
		}
		if !imaTaroka {
			time.Sleep(100 * time.Millisecond)
			s.Broadcast("", gameId, &messages.Message{Data: &messages.Message_ClearHand{ClearHand: &messages.ClearHand{}}})
			for _, userId := range game.Starts {
				game.Players[userId].ResetGameVariables()
			}
			time.Sleep(100 * time.Millisecond)
			s.logger.Errorw("igralec ni dobil taroka, ponovno mešam karte", "gameId", gameId)
			continue
		}

		if game.SkisRunda {
			if skisDolocen != -1 {
				game.GamesRequired += len(game.Starts) - skisDolocen
				game.SkisRunda = false
			} else {
				// ponovi škis rundo
				game.GamesRequired++
			}
		}

		for i := 0; i < 6; i++ {
			game.Talon = append(game.Talon, Card{
				id: cards[0].File,
			})
			cards = helpers.Remove(cards, 0)
		}
		s.logger.Debugw("talon", "talon", game.Talon)

		return
	}
}
