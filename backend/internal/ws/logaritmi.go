package ws

import (
	"github.com/mytja/Tarok/backend/internal/consts"
	"github.com/mytja/Tarok/backend/internal/messages"
	"github.com/mytja/Tarok/backend/internal/shuffler"
)

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
				cs, err := s.db.GetTournamentCards(game.TournamentID, game.GameCount, kk+1)
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
			return
		}

		cards, talon := shuffler.ShuffleCards(game.PlayersNeeded, &[]int{}, &[]string{})
		skisDolocen := -1
		for kk, userId := range game.Starts {
			for i := 0; i < len(cards[kk]); i++ {
				karta := cards[kk][i]

				game.Players[userId].BroadcastToClients(&messages.Message{
					PlayerId: userId,
					Data: &messages.Message_Card{
						Card: &messages.Card{
							Id:     karta,
							UserId: userId,
							Type: &messages.Card_Receive{
								Receive: &messages.Receive{},
							},
						},
					},
				})
				if karta == "/taroki/skis" {
					skisDolocen = kk
				}
				game.Players[userId].AddCard(Card{
					id:     karta,
					userId: userId,
				})
			}
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
				id: talon[i],
			})
		}

		s.logger.Debugw("talon", "talon", game.Talon)

		return
	}
}
