package main

import (
	"github.com/google/uuid"
	"stockskis/stockskis"
)
import "C"

var stockSkisMap map[string]stockskis.StockSkis

type Player struct {
	ID      string
	Playing bool
	Cards   []stockskis.Card
}
type Deck struct {
	ID         string
	PickedUpBy string
	Cards      []stockskis.Move
}

//export GetVersion
func GetVersion() *C.char {
	return C.CString(stockskis.StockSkisVersion)
}

//export NewCContext
func NewCContext(players *[]Player, gamemode int, history bool, moveHistory *[]Deck, canLook bool) *C.char {
	UUID := uuid.NewString()
	var playersMap map[string]stockskis.Player
	for _, v := range *players {
		playersMap[v.ID] = stockskis.Player{ID: v.ID, Playing: v.Playing, Cards: v.Cards}
	}
	var moveHist []stockskis.Deck
	for _, v := range *moveHistory {
		moveHist = append(moveHist, stockskis.Deck{ID: v.ID, PickedUpBy: v.PickedUpBy, Cards: v.Cards})
	}
	stockSkisMap[UUID] = stockskis.NewContext(playersMap, gamemode, history, moveHist, canLook)
	return C.CString(UUID)
}

func main() {}
