package main

import (
	"fmt"
	"math/rand"
	"stockskis/stockskis"
	"time"
)

func main() {
	rand.Seed(time.Now().UnixMilli())
	cards := append([]stockskis.Card{}, stockskis.CARDS...)
	rand.Shuffle(len(cards), func(i, j int) {
		cards[i], cards[j] = cards[j], cards[i]
	})
	players := 3
	player := 0
	playerMap := make(map[string]stockskis.Player)
	for i := 0; i < 54-6; i++ {
		if i%((54-6)/players) == 0 || i == 0 {
			player++
			playerMap[fmt.Sprint(player)] = stockskis.Player{ID: fmt.Sprint(player), Name: fmt.Sprintf("Igralec %s", fmt.Sprint(player)), Playing: player == 1, Cards: []stockskis.Card{}}
		}
		p := playerMap[fmt.Sprint(player)]
		p.Cards = append(p.Cards, cards[i])
		playerMap[fmt.Sprint(player)] = p
	}
	fmt.Println("Kontekst")
	fmt.Println(playerMap)
	fmt.Println("Konec konteksta")
	context := stockskis.NewContext(playerMap, 0, false, []stockskis.Deck{{}}, false)
	for i := 1; i <= players; i++ {
		t := time.Now()
		playerId := fmt.Sprint(i)
		moves, depth := context.EvaluateMoves(playerId)
		if len(moves) == 0 {
			// ni več movov, končamo igro
			fmt.Println("Igra botov je končana.")
			return
		}
		max := moves[0]
		for _, v := range moves {
			if v.Value > max.Value {
				max = v
			}
		}
		fmt.Printf("Najdene poteze %s pri globini %s v času %s. Izbrana je bila poteza %s.\n", fmt.Sprint(moves), fmt.Sprint(depth), time.Now().Sub(t), fmt.Sprint(max))
		context.AddMoveToPerson(playerId, max)
	}
}
