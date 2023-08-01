package stockskis

type stockSkis struct {
	Players      map[string]Player
	GameMode     int
	History      bool
	CanLookHands bool
	MoveHistory  []Deck
}

func (skis *stockSkis) AddMoveToPerson(playerId string, move Move) {
	if len(skis.MoveHistory[len(skis.MoveHistory)-1].Cards) == len(skis.Players) {
		skis.MoveHistory[len(skis.MoveHistory)-1] = StihPickedUpBy(skis.MoveHistory[len(skis.MoveHistory)-1])
		skis.MoveHistory = append(skis.MoveHistory, Deck{})
	}
	skis.MoveHistory[len(skis.MoveHistory)-1].Cards = append(skis.MoveHistory[len(skis.MoveHistory)-1].Cards, move)
	player := skis.Players[playerId]
	for i, v := range player.Cards {
		if v.File == move.Card.File {
			player.Cards = Remove(player.Cards, i)
			break
		}
	}
	cardType, _, _ := ParseCard(move.Card.File)
	if cardType == "kara" {
		player.PadleKare = append(player.PadleKare, move.Card)
	} else if cardType == "pik" {
		player.PadliPiki = append(player.PadliPiki, move.Card)
	} else if cardType == "src" {
		player.PadliSrci = append(player.PadliSrci, move.Card)
	} else if cardType == "kriz" {
		player.PadliKrizi = append(player.PadliKrizi, move.Card)
	} else if cardType == "taroki" {
		player.FallenTarocks = append(player.FallenTarocks, move.Card)
	}
	skis.Players[playerId] = player
}

func StihPickedUpBy(stih Deck) Deck {
	if len(stih.Cards) == 0 {
		return stih
	}
	firstCard := stih.Cards[0]
	firstCardType, _, _ := ParseCard(firstCard.Card.File)
	max := stih.Cards[0]
	for _, v := range stih.Cards {
		cardType, _, _ := ParseCard(v.Card.File)
		if v.Card.WorthOver > max.Card.WorthOver && (firstCardType == cardType || cardType == "taroki") {
			max = v
		}
	}
	stih.PickedUpBy = max.UserID
	return stih
}

// TODO: pobiranje s škisom k noben ne pobere s tarokom
func (skis *stockSkis) EvaluateMoves(playerId string) ([]Move, int) {
	player := skis.Players[playerId]
	h := skis.MoveHistory[len(skis.MoveHistory)-1].Cards
	var firstCard *Move
	if len(h) != 0 {
		firstCard = &h[0]
	}
	moves := make([]Move, 0)
	hasCard := false
	hasTarocks := false
	hasColors := false
	if firstCard != nil {
		firstCardType, _, _ := ParseCard(firstCard.Card.File)
		for _, v := range skis.Players[playerId].Cards {
			cardType, _, _ := ParseCard(v.File)
			if firstCardType == cardType {
				hasCard = true
			}
			if cardType == "taroki" {
				hasTarocks = true
			}
			if hasCard && hasTarocks {
				break
			}
		}
	} else {
		hasCard = true
		hasTarocks = true
	}

	// preverimo, če ima oseba barve
	for _, v := range skis.Players[playerId].Cards {
		cardType, _, _ := ParseCard(v.File)
		if cardType != "taroki" {
			hasColors = true
			break
		}
	}

	for _, v := range skis.Players[playerId].Cards {
		cardType, _, _ := ParseCard(v.File)
		if firstCard != nil {
			firstCardType, _, _ := ParseCard(firstCard.Card.File)
			if hasCard && firstCardType != cardType {
				continue
			} else if hasTarocks && !hasCard && cardType != "taroki" {
				continue
			}
		}
		padlo := make([]Card, 0)
		for _, p := range skis.Players {
			if cardType == "kriz" {
				for _, v := range p.PadliKrizi {
					padlo = append(padlo, v)
				}
			} else if cardType == "src" {
				for _, v := range p.PadliSrci {
					padlo = append(padlo, v)
				}
			} else if cardType == "pik" {
				for _, v := range p.PadliPiki {
					padlo = append(padlo, v)
				}
			} else if cardType == "kara" {
				for _, v := range p.PadleKare {
					padlo = append(padlo, v)
				}
			} else if cardType == "taroki" {
				for _, v := range p.FallenTarocks {
					padlo = append(padlo, v)
				}
			}
		}

		points := 0
		if firstCard != nil {
			firstCardType, _, _ := ParseCard(firstCard.Card.File)
			if firstCardType == "taroki" {
				points -= v.WorthOver
			}
		}

		if cardType == "taroki" {
			// taroke se (minimalno) kaznuje, dokler imaš v roki barve
			if hasColors {
				points--
			}
		}

		deck := skis.MoveHistory[len(skis.MoveHistory)-1]
		deck.Cards = append(deck.Cards, Move{UserID: playerId, Card: v})
		deck = StihPickedUpBy(deck)
		for _, p := range skis.Players {
			if deck.PickedUpBy == p.ID && ((p.Playing && !player.Playing) || (!p.Playing && player.Playing)) {
				points -= 3 * v.Worth
			}
		}

		moves = append(moves, Move{
			ID:     "",
			UserID: playerId,
			Card:   v,
			Value:  v.Worth + points - len(padlo),
		})
	}
	return moves, 0
}

type StockSkis interface {
	EvaluateMoves(playerId string) ([]Move, int)
	AddMoveToPerson(playerId string, move Move)
}

func NewContext(players map[string]Player, gameMode int, history bool, moveHistory []Deck, canLook bool) StockSkis {
	return &stockSkis{
		Players:      players,
		GameMode:     gameMode,
		History:      history,
		MoveHistory:  moveHistory,
		CanLookHands: canLook,
	}
}
