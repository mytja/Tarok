package ws

import (
	"encoding/json"
	"fmt"
	"github.com/mytja/Tarok/backend/internal/consts"
	"github.com/mytja/Tarok/backend/internal/helpers"
	"github.com/mytja/Tarok/backend/internal/messages"
	"io"
	"os"
	"os/exec"
)

func (s *serverImpl) StockSkisExec(requestType string, userId string, gameId string) []byte {
	game, exists := s.games[gameId]
	if !exists {
		s.logger.Error("Game doesn't exist")
		return make([]byte, 0)
	}

	stihi := make([][]map[string]any, 0)
	// ugly ass n^3 sranje
	for _, stih := range game.Stihi {
		s := make([]map[string]any, 0)
		for _, card := range stih {
			c := consts.Card{}
			for _, c = range consts.CARDS {
				if c.File == card.id {
					break
				}
			}
			s = append(s, map[string]any{"asset": c.File, "worth": c.Worth, "worthOver": c.WorthOver, "user": card.userId})
		}
		stihi = append(stihi, s)
	}

	playing := game.Playing

	users := make([]map[string]any, 0)
	for _, uid := range game.Starts {
		u := game.Players[uid]

		cards := make([]map[string]any, 0)
		for _, card := range u.GetCards() {
			c := consts.Card{}
			for _, c = range consts.CARDS {
				if c.File == card.id {
					break
				}
			}
			cards = append(cards, map[string]any{"asset": c.File, "worth": c.Worth, "worthOver": c.WorthOver, "user": card.userId})
		}
		user := map[string]any{
			"id":              uid,
			"name":            u.GetUser().Name,
			"cards":           cards,
			"playing":         helpers.Contains(playing, uid) || u.SelectedKingFallen(),
			"secretlyPlaying": helpers.Contains(playing, uid) || u.UserHasKing(),
			"licitated":       len(playing) != 0 && playing[0] == uid,
		}
		users = append(users, user)
	}

	talon := make([]map[string]any, 0)
	for _, card := range game.Talon {
		c := consts.Card{}
		for _, c = range consts.CARDS {
			if c.File == card.id {
				break
			}
		}
		talon = append(talon, map[string]any{"asset": c.File, "worth": c.Worth, "worthOver": c.WorthOver, "user": card.userId})
	}

	kingFallen := false
	for _, v := range game.Players {
		kingFallen = v.SelectedKingFallen()
		if kingFallen {
			break
		}
	}

	kraljUltimo := &messages.User{Name: "", Id: ""}
	if game.CurrentPredictions.KraljUltimo != nil {
		kraljUltimo = game.CurrentPredictions.KraljUltimo
	}

	kraljUltimoKontraDal := &messages.User{Name: "", Id: ""}
	if game.CurrentPredictions.KraljUltimoKontraDal != nil {
		kraljUltimoKontraDal = game.CurrentPredictions.KraljUltimoKontraDal
	}

	pagatUltimo := &messages.User{Name: "", Id: ""}
	if game.CurrentPredictions.PagatUltimo != nil {
		pagatUltimo = game.CurrentPredictions.PagatUltimo
	}

	pagatUltimoKontraDal := &messages.User{Name: "", Id: ""}
	if game.CurrentPredictions.PagatUltimoKontraDal != nil {
		pagatUltimoKontraDal = game.CurrentPredictions.PagatUltimoKontraDal
	}

	igra := &messages.User{Name: "", Id: ""}
	if game.CurrentPredictions.Igra != nil {
		igra = game.CurrentPredictions.Igra
	}

	igraKontraDal := &messages.User{Name: "", Id: ""}
	if game.CurrentPredictions.IgraKontraDal != nil {
		igraKontraDal = game.CurrentPredictions.IgraKontraDal
	}

	valat := &messages.User{Name: "", Id: ""}
	if game.CurrentPredictions.Valat != nil {
		valat = game.CurrentPredictions.Valat
	}

	valatKontraDal := &messages.User{Name: "", Id: ""}
	if game.CurrentPredictions.ValatKontraDal != nil {
		valatKontraDal = game.CurrentPredictions.ValatKontraDal
	}

	barvniValat := &messages.User{Name: "", Id: ""}
	if game.CurrentPredictions.BarvniValat != nil {
		barvniValat = game.CurrentPredictions.BarvniValat
	}

	barvniValatKontraDal := &messages.User{Name: "", Id: ""}
	if game.CurrentPredictions.BarvniValat != nil {
		barvniValatKontraDal = game.CurrentPredictions.BarvniValat
	}

	trula := &messages.User{Name: "", Id: ""}
	if game.CurrentPredictions.Trula != nil {
		trula = game.CurrentPredictions.Trula
	}

	kralji := &messages.User{Name: "", Id: ""}
	if game.CurrentPredictions.Kralji != nil {
		kralji = game.CurrentPredictions.Kralji
	}

	predictions := map[string]any{
		"kraljUltimo": map[string]string{
			"id":   kraljUltimo.Id,
			"name": kraljUltimo.Name,
		},
		"kraljUltimoKontra": game.CurrentPredictions.KraljUltimoKontra,
		"kraljUltimoKontraDal": map[string]string{
			"id":   kraljUltimoKontraDal.Id,
			"name": kraljUltimoKontraDal.Name,
		},
		"pagatUltimo": map[string]string{
			"id":   pagatUltimo.Id,
			"name": pagatUltimo.Name,
		},
		"pagatUltimoKontra": game.CurrentPredictions.PagatUltimoKontra,
		"pagatUltimoKontraDal": map[string]string{
			"id":   pagatUltimoKontraDal.Id,
			"name": pagatUltimoKontraDal.Name,
		},
		"igra": map[string]string{
			"id":   igra.Id,
			"name": igra.Name,
		},
		"igraKontra": game.CurrentPredictions.IgraKontra,
		"igraKontraDal": map[string]string{
			"id":   igraKontraDal.Id,
			"name": igraKontraDal.Name,
		},
		"valat": map[string]string{
			"id":   valat.Id,
			"name": valat.Name,
		},
		"valatKontra": game.CurrentPredictions.ValatKontra,
		"valatKontraDal": map[string]string{
			"id":   valatKontraDal.Id,
			"name": valatKontraDal.Name,
		},
		"barvniValat": map[string]string{
			"id":   barvniValat.Id,
			"name": barvniValat.Name,
		},
		"barvniValatKontra": game.CurrentPredictions.BarvniValatKontra,
		"barvniValatKontraDal": map[string]string{
			"id":   barvniValatKontraDal.Id,
			"name": barvniValatKontraDal.Name,
		},
		"trula": map[string]string{
			"id":   trula.Id,
			"name": trula.Name,
		},
		"kralji": map[string]string{
			"id":   kralji.Id,
			"name": kralji.Name,
		},
		"gamemode": game.CurrentPredictions.Gamemode,
		"changed":  false,
	}

	selectedKing := game.PlayingIn
	gamemode := game.GameMode

	j := map[string]any{
		"stihi":        stihi,
		"users":        users,
		"talon":        talon,
		"predictions":  predictions,
		"kingFallen":   kingFallen,
		"selectedKing": selectedKing,
		"gamemode":     gamemode,
		"skisfang":     game.IzgubaSkisa,
	}

	jsonEncoded, err := json.Marshal(j)
	if err != nil {
		s.logger.Error(err.Error())
		return make([]byte, 0)
	}

	h := string(jsonEncoded)

	fmt.Println(h)

	cmd := exec.Command("./stockskis", requestType, userId)
	cmd.Stderr = os.Stderr

	stdin, err := cmd.StdinPipe()
	if err != nil {
		s.logger.Errorw("piping to stdin failed", "err", err.Error())
		return make([]byte, 0)
	}

	output, err := cmd.StdoutPipe()
	if err != nil {
		s.logger.Errorw("opening stdout pipe failed", "err", err.Error())
		return make([]byte, 0)
	}

	err = cmd.Start()
	if err != nil {
		s.logger.Errorw("stockškis failed", "err", err.Error())
		return make([]byte, 0)
	}

	defer stdin.Close()

	_, err = io.WriteString(stdin, h+"\n")
	if err != nil {
		s.logger.Errorw("writing to stdin failed", "err", err.Error())
		return make([]byte, 0)
	}

	respBytes, err := io.ReadAll(output)
	if err != nil {
		s.logger.Errorw("reading from stdout failed", "err", err.Error())
		return make([]byte, 0)
	}

	cmd.Wait()

	fmt.Println(string(respBytes))

	return respBytes
}

type Results struct {
	User []struct {
		Igra           int32 `json:"igra"`
		KontraIgra     int32 `json:"kontraIgra"`
		KontraKralj    int32 `json:"kontraKralj"`
		KontraPagat    int32 `json:"kontraPagat"`
		Kralj          int32 `json:"kralj"`
		Kralji         int32 `json:"kralji"`
		Pagat          int32 `json:"pagat"`
		Mondfang       bool  `json:"mondfang"`
		Playing        bool  `json:"playing"`
		Points         int32 `json:"points"`
		Radelc         bool  `json:"radelc"`
		Razlika        int32 `json:"razlika"`
		ShowDifference bool  `json:"showDifference"`
		ShowGamemode   bool  `json:"showGamemode"`
		ShowKralj      bool  `json:"showKralj"`
		ShowKralji     bool  `json:"showKralji"`
		ShowPagat      bool  `json:"showPagat"`
		ShowTrula      bool  `json:"showTrula"`
		Trula          int32 `json:"trula"`
		Skisfang       bool  `json:"skisfang"`
		Users          []struct {
			ID   string `json:"id"`
			Name string `json:"name"`
		} `json:"users"`
	} `json:"user"`
	Stih []struct {
		Card []struct {
			ID   string `json:"id"`
			User string `json:"user"`
		} `json:"card"`
		PickedUpBy        string  `json:"pickedUpBy"`
		PickedUpByPlaying bool    `json:"pickedUpByPlaying"`
		Worth             float32 `json:"worth"`
	} `json:"stih"`
}

func (s *serverImpl) UnmarshallResults(b []byte) Results {
	var out Results
	err := json.Unmarshal(b, &out)
	if err != nil {
		s.logger.Error(err.Error())
	}
	return out
}

func StockSkisMessagesResults(m Results) *messages.Results {
	stihi := make([]*messages.Stih, 0)
	for _, v := range m.Stih {
		cards := make([]*messages.Card, 0)
		for _, c := range v.Card {
			cards = append(cards, &messages.Card{
				Id:     c.ID,
				UserId: c.User,
			})
		}

		stihi = append(stihi, &messages.Stih{
			Card:              cards,
			Worth:             v.Worth,
			PickedUpByPlaying: v.PickedUpByPlaying,
			PickedUpBy:        v.PickedUpBy,
		})
	}

	results := make([]*messages.ResultsUser, 0)
	for _, v := range m.User {
		users := make([]*messages.User, 0)
		for _, c := range v.Users {
			if c.ID == "" {
				continue
			}
			users = append(users, &messages.User{
				Id:   c.ID,
				Name: c.Name,
			})
		}

		results = append(results, &messages.ResultsUser{
			User:           users,
			Playing:        v.Playing,
			Points:         v.Points,
			Trula:          v.Trula,
			Pagat:          v.Pagat,
			Igra:           v.Igra,
			Razlika:        v.Razlika,
			Kralj:          v.Kralj,
			Kralji:         v.Kralji,
			KontraPagat:    v.KontraPagat,
			KontraIgra:     v.KontraIgra,
			KontraKralj:    v.KontraKralj,
			Mondfang:       v.Mondfang,
			ShowGamemode:   v.ShowGamemode,
			ShowDifference: v.ShowDifference,
			ShowKralj:      v.ShowKralj,
			ShowPagat:      v.ShowPagat,
			ShowKralji:     v.ShowKralji,
			ShowTrula:      v.ShowTrula,
			Radelc:         v.Radelc,
			Skisfang:       v.Skisfang,
		})
	}

	r := messages.Results{
		User: results,
		Stih: stihi,
	}

	return &r
}
