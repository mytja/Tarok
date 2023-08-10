package consts

import "errors"

const (
	ChanBufferSize = 200
)

type Card struct {
	File      string
	Worth     int
	WorthOver int
	Alt       string
}

type Game struct {
	ID         int32
	Name       string
	PlaysThree bool
	Worth      int
}

var CARDS = []Card{
	{File: "/kara/1", Worth: 1, WorthOver: 4, Alt: "1 kara"},
	{File: "/kara/2", Worth: 1, WorthOver: 3, Alt: "2 kara"},
	{File: "/kara/3", Worth: 1, WorthOver: 2, Alt: "3 kara"},
	{File: "/kara/4", Worth: 1, WorthOver: 1, Alt: "4 kara"},
	{File: "/kara/pob", Worth: 2, WorthOver: 5, Alt: "Kara pob"},
	{File: "/kara/kaval", Worth: 3, WorthOver: 6, Alt: "Kara kaval"},
	{File: "/kara/dama", Worth: 4, WorthOver: 7, Alt: "Kara dama"},
	{File: "/kara/kralj", Worth: 5, WorthOver: 8, Alt: "Kara kralj"},

	{File: "/kriz/7", Worth: 1, WorthOver: 1, Alt: "7 križ"},
	{File: "/kriz/8", Worth: 1, WorthOver: 2, Alt: "8 križ"},
	{File: "/kriz/9", Worth: 1, WorthOver: 3, Alt: "9 križ"},
	{File: "/kriz/10", Worth: 1, WorthOver: 4, Alt: "10 križ"},
	{File: "/kriz/pob", Worth: 2, WorthOver: 5, Alt: "Križ pob"},
	{File: "/kriz/kaval", Worth: 3, WorthOver: 6, Alt: "Križ kaval"},
	{File: "/kriz/dama", Worth: 4, WorthOver: 7, Alt: "Križ dama"},
	{File: "/kriz/kralj", Worth: 5, WorthOver: 8, Alt: "Križ kralj"},

	{File: "/pik/7", Worth: 1, WorthOver: 1, Alt: "7 pik"},
	{File: "/pik/8", Worth: 1, WorthOver: 2, Alt: "8 pik"},
	{File: "/pik/9", Worth: 1, WorthOver: 3, Alt: "9 pik"},
	{File: "/pik/10", Worth: 1, WorthOver: 4, Alt: "10 pik"},
	{File: "/pik/pob", Worth: 2, WorthOver: 5, Alt: "Pik pob"},
	{File: "/pik/kaval", Worth: 3, WorthOver: 6, Alt: "Pik kaval"},
	{File: "/pik/dama", Worth: 4, WorthOver: 7, Alt: "Pik dama"},
	{File: "/pik/kralj", Worth: 5, WorthOver: 8, Alt: "Pik kralj"},

	{File: "/src/1", Worth: 1, WorthOver: 4, Alt: "1 src"},
	{File: "/src/2", Worth: 1, WorthOver: 3, Alt: "2 src"},
	{File: "/src/3", Worth: 1, WorthOver: 2, Alt: "3 src"},
	{File: "/src/4", Worth: 1, WorthOver: 1, Alt: "4 src"},
	{File: "/src/pob", Worth: 2, WorthOver: 5, Alt: "Src pob"},
	{File: "/src/kaval", Worth: 3, WorthOver: 6, Alt: "Src kaval"},
	{File: "/src/dama", Worth: 4, WorthOver: 7, Alt: "Src dama"},
	{File: "/src/kralj", Worth: 5, WorthOver: 8, Alt: "Src kralj"},

	{File: "/taroki/pagat", Worth: 5, WorthOver: 11, Alt: "Pagat"},
	{File: "/taroki/2", Worth: 1, WorthOver: 12, Alt: "2"},
	{File: "/taroki/3", Worth: 1, WorthOver: 13, Alt: "3"},
	{File: "/taroki/4", Worth: 1, WorthOver: 14, Alt: "4"},
	{File: "/taroki/5", Worth: 1, WorthOver: 15, Alt: "5"},
	{File: "/taroki/6", Worth: 1, WorthOver: 16, Alt: "6"},
	{File: "/taroki/7", Worth: 1, WorthOver: 17, Alt: "7"},
	{File: "/taroki/8", Worth: 1, WorthOver: 18, Alt: "8"},
	{File: "/taroki/9", Worth: 1, WorthOver: 19, Alt: "9"},
	{File: "/taroki/10", Worth: 1, WorthOver: 20, Alt: "10"},
	{File: "/taroki/11", Worth: 5, WorthOver: 21, Alt: "11"},
	{File: "/taroki/12", Worth: 1, WorthOver: 22, Alt: "12"},
	{File: "/taroki/13", Worth: 1, WorthOver: 23, Alt: "13"},
	{File: "/taroki/14", Worth: 1, WorthOver: 24, Alt: "14"},
	{File: "/taroki/15", Worth: 1, WorthOver: 25, Alt: "15"},
	{File: "/taroki/16", Worth: 1, WorthOver: 26, Alt: "16"},
	{File: "/taroki/17", Worth: 1, WorthOver: 27, Alt: "17"},
	{File: "/taroki/18", Worth: 1, WorthOver: 28, Alt: "18"},
	{File: "/taroki/19", Worth: 1, WorthOver: 29, Alt: "19"},
	{File: "/taroki/20", Worth: 1, WorthOver: 30, Alt: "20"},
	{File: "/taroki/mond", Worth: 5, WorthOver: 31, Alt: "Mond"},
	{File: "/taroki/skis", Worth: 5, WorthOver: 32, Alt: "Škis"},
}

func GetCardByID(id string) (Card, error) {
	for _, v := range CARDS {
		if v.File == id {
			return v, nil
		}
	}
	return Card{}, errors.New("no such card found")
}

var GAMES = []Game{
	{ID: -1, Name: "Naprej", PlaysThree: true, Worth: 0},
	{ID: 0, Name: "Tri", PlaysThree: true, Worth: 10},
	{ID: 1, Name: "Dva", PlaysThree: true, Worth: 20},
	{ID: 2, Name: "Ena", PlaysThree: true, Worth: 30},
	{ID: 3, Name: "Solo tri", PlaysThree: false, Worth: 40},
	{ID: 4, Name: "Solo dva", PlaysThree: false, Worth: 50},
	{ID: 5, Name: "Solo ena", PlaysThree: false, Worth: 60},
	{ID: 6, Name: "Berač", PlaysThree: true, Worth: 70},
	{ID: 7, Name: "Solo brez", PlaysThree: true, Worth: 80},
	{ID: 8, Name: "Odprti berač", PlaysThree: true, Worth: 90},
	{ID: 9, Name: "Barvni valat", PlaysThree: true, Worth: 125},
	{ID: 10, Name: "Valat", PlaysThree: true, Worth: 500},
}
