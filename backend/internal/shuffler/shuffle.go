package shuffler

import (
	"github.com/mytja/Tarok/backend/internal/consts"
	"github.com/mytja/Tarok/backend/internal/helpers"
	"log"
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

func ShuffleCards(playersNeeded int, exclude *[]int, excludeCards *[]string) (userCards [][]string, talon []string) {
	for {
		cards := make([]consts.Card, 0)
		cards = append(cards, consts.CARDS...)
		for _, v := range *excludeCards {
			for i2, v2 := range cards {
				if v == v2.File {
					cards = helpers.Remove(cards, i2)
				}
			}
		}

		cards = Shuffle(cards)
		imaTaroka := false
		kart := (54 - 6) / playersNeeded
		karte := make([][]string, 0)
		for p := 0; p < playersNeeded; p++ {
			k := make([]string, 0)
			imaTaroka = false
			if helpers.Contains(*exclude, p) {
				imaTaroka = true
				karte = append(karte, k)
				continue
			}
			for i := 0; i < kart; i++ {
				if strings.Contains(cards[0].File, "taroki") {
					imaTaroka = true
				}

				k = append(k, cards[0].File)
				cards = helpers.Remove(cards, 0)
			}
			if !imaTaroka {
				break
			}
			karte = append(karte, k)
		}

		if !imaTaroka {
			log.Println("igralec ni dobil taroka, ponovno mešam karte")
			continue
		}

		talon = make([]string, 0)

		for i := 0; i < 6; i++ {
			talon = append(talon, cards[i].File)
		}

		return karte, talon
	}
}
