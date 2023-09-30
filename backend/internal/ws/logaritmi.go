package ws

import (
	"github.com/mytja/Tarok/backend/internal/consts"
	"github.com/mytja/Tarok/backend/internal/helpers"
	"github.com/mytja/Tarok/backend/internal/messages"
	"math/rand"
	"strings"
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

func (s *serverImpl) ShuffleCards(gameId string) {
	for {
		game, exists := s.games[gameId]
		if !exists {
			s.logger.Errorw("game has finished, it doesn't exist, exiting", "gameId", gameId)
			return
		}

		cards := make([]consts.Card, 0)
		cards = append(cards, consts.CARDS...)
		cards = Shuffle(cards)
		imaTaroka := false
		for _, userId := range game.Starts {
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
			s.Broadcast("", &messages.Message{GameId: gameId, Data: &messages.Message_ClearHand{ClearHand: &messages.ClearHand{}}})
			for _, userId := range game.Starts {
				game.Players[userId].ResetGameVariables()
			}
			s.logger.Errorw("igralec ni dobil taroka, ponovno mešam karte", "gameId", gameId)
			continue
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
