package ws

import (
	"encoding/json"
	"github.com/mytja/Tarok/backend/internal/helpers"
	"github.com/mytja/Tarok/backend/internal/messages"
	"math"
	"time"
)

func (s *serverImpl) HasPagat(gameId string, userId string) bool {
	game, exists := s.games[gameId]
	if !exists {
		return false
	}
	return game.Players[userId].ImaKarto("/taroki/pagat")
}

func (s *serverImpl) HasKing(gameId string, userId string) bool {
	game, exists := s.games[gameId]
	if !exists {
		return false
	}
	return game.Players[userId].ImaKarto(game.PlayingIn)
}

func (s *serverImpl) BotPredict(gameId string, userId string) {
	var predictions Predictions
	json.Unmarshal(s.StockSkisExec("predict", userId, gameId), &predictions)
	s.Predictions(userId, gameId, StockSkisPredictionsToMessages(predictions))
}

func (s *serverImpl) BotGoroutinePredictions(gameId string, playing string) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}

	go func() {
		t := time.Now()
		timer := game.Players[playing].GetTimer()
		done := false

		for {
			game, exists = s.games[gameId]
			if !exists {
				s.logger.Errorw("game doesn't exist, exiting", "gameId", gameId)
				return
			}

			select {
			case <-game.EndTimer:
				s.logger.Debugw("timer ended", "seconds", time.Now().Sub(t).Seconds(), "timer", timer)
				game, exists = s.games[gameId]
				if !exists {
					s.logger.Errorw("game doesn't exist, exiting", "gameId", gameId)
					return
				}

				game.Players[playing].SetTimer(math.Max(timer-time.Now().Sub(t).Seconds(), 0) + game.AdditionalTime)
				s.EndTimerBroadcast(gameId, playing, game.Players[playing].GetTimer())
				return
			case <-time.After(1 * time.Second):
				game, exists = s.games[gameId]
				if !exists {
					s.logger.Errorw("game doesn't exist, exiting", "gameId", gameId)
					return
				}

				if done {
					continue
				}

				s.EndTimerBroadcast(gameId, playing, math.Max(timer-time.Now().Sub(t).Seconds(), 0))
				if !(len(game.Players[playing].GetClients()) == 0 || time.Now().Sub(t).Seconds() > timer) {
					continue
				}
				s.logger.Debugw("time exceeded", "seconds", time.Now().Sub(t).Seconds(), "timer", timer)
				go s.BotPredict(gameId, playing)
				done = true
			}
		}
	}()
}

func (s *serverImpl) FirstPrediction(gameId string) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}

	var playing string
	var starts string
	if game.GameMode == -1 {
		playing = game.Starts[len(game.Starts)-1]
		// za compatibility z ostalimi funkcijami
		game.Playing = append(game.Playing, playing)
		starts = game.Starts[0]
	} else {
		playing = game.Playing[0]
		starts = playing
	}

	game.CurrentPredictions = &messages.Predictions{
		KraljUltimo:          nil,
		KraljUltimoKontra:    0,
		KraljUltimoKontraDal: nil,
		Trula:                nil,
		Kralji:               nil,
		PagatUltimo:          nil,
		PagatUltimoKontra:    0,
		PagatUltimoKontraDal: nil,
		Igra:                 &messages.User{Id: playing},
		IgraKontra:           0,
		IgraKontraDal:        nil,
		Valat:                nil,
		ValatKontra:          0,
		ValatKontraDal:       nil,
		BarvniValat:          nil,
		BarvniValatKontra:    0,
		BarvniValatKontraDal: nil,
		Gamemode:             game.GameMode,
		Changed:              false,
	}
	broadcast := &messages.Message{PlayerId: playing, GameId: gameId, Data: &messages.Message_Predictions{Predictions: game.CurrentPredictions}}
	s.Broadcast("", broadcast)
	time.Sleep(100 * time.Millisecond)
	if game.GameMode == -1 {
		s.Broadcast("", &messages.Message{PlayerId: starts, GameId: gameId, Data: &messages.Message_StartPredictions{StartPredictions: &messages.StartPredictions{
			KraljUltimoKontra: false,
			PagatUltimoKontra: false,
			IgraKontra:        true,
			ValatKontra:       false,
			BarvniValatKontra: false,
			PagatUltimo:       false,
			Trula:             false,
			Kralji:            false,
			KraljUltimo:       false,
			Valat:             false,
			BarvniValat:       false,
		}}})
	} else if game.GameMode >= 6 {
		s.Broadcast("", &messages.Message{PlayerId: starts, GameId: gameId, Data: &messages.Message_StartPredictions{StartPredictions: &messages.StartPredictions{
			KraljUltimoKontra: false,
			PagatUltimoKontra: false,
			IgraKontra:        false,
			ValatKontra:       false,
			BarvniValatKontra: false,
			PagatUltimo:       false,
			Trula:             false,
			Kralji:            false,
			KraljUltimo:       false,
			Valat:             false,
			BarvniValat:       false,
		}}})
	} else {
		s.Broadcast("", &messages.Message{PlayerId: starts, GameId: gameId, Data: &messages.Message_StartPredictions{StartPredictions: &messages.StartPredictions{
			KraljUltimoKontra: false,
			PagatUltimoKontra: false,
			IgraKontra:        false,
			ValatKontra:       false,
			BarvniValatKontra: false,
			PagatUltimo:       s.HasPagat(gameId, playing),
			Trula:             true,
			Kralji:            true,
			KraljUltimo:       s.HasKing(gameId, playing),
			Valat:             true,
			BarvniValat:       true,
		}}})
	}

	s.BotGoroutinePredictions(gameId, starts)
}

// na trulo & kralje se (verjetno) ne daje kontre
// pri truli in kraljih velja pravilo kdor prvi pride prvi melje
// lahko ju napove kdorkoli
// ultime lahko napovesta samo igralca
func (s *serverImpl) Predictions(userId string, gameId string, predictions *messages.Predictions) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}
	playing := game.Playing[0]

	s.logger.Debugw("predictions", "p", predictions)

	// ne moreš na novo napovedati
	if predictions.BarvniValat != nil && game.CurrentPredictions.BarvniValat != nil && predictions.BarvniValat.Id != game.CurrentPredictions.BarvniValat.Id {
		s.logger.Debugw("prediction rule wasn't satisfied")
		return
	}
	// ne moreš napovedati, če ne igraš specifične igre
	if predictions.BarvniValat != nil && !((game.GameMode >= 3 && game.GameMode <= 5) || game.GameMode == 9) {
		s.logger.Debugw("prediction rule wasn't satisfied")
		return
	}
	// ne moreš napovedati, če nisi igralec
	if predictions.BarvniValat == nil && game.CurrentPredictions.BarvniValat != nil && playing != game.CurrentPredictions.BarvniValat.Id {
		s.logger.Debugw("prediction rule wasn't satisfied")
		return
	}
	// ne moreš preklicati napovedi
	if predictions.BarvniValat == nil && game.CurrentPredictions.BarvniValat != nil {
		s.logger.Debugw("prediction rule wasn't satisfied")
		return
	}

	// ne moreš na novo napovedati
	if predictions.Valat != nil && game.CurrentPredictions.Valat != nil && predictions.Valat.Id != game.CurrentPredictions.Valat.Id {
		s.logger.Debugw("prediction rule wasn't satisfied")
		return
	}
	// ne moreš napovedati, če ne igraš specifične igre
	if predictions.Valat != nil && !((game.GameMode >= 0 && game.GameMode <= 5) || game.GameMode == 10) {
		s.logger.Debugw("prediction rule wasn't satisfied")
		return
	}
	// ne moreš napovedati, če nisi igralec
	if predictions.Valat == nil && game.CurrentPredictions.Valat != nil && playing != game.CurrentPredictions.Valat.Id {
		s.logger.Debugw("prediction rule wasn't satisfied")
		return
	}
	// ne moreš preklicati napovedi
	if predictions.Valat == nil && game.CurrentPredictions.Valat != nil {
		s.logger.Debugw("prediction rule wasn't satisfied")
		return
	}

	// ne moreš na novo napovedati
	if predictions.Trula != nil && game.CurrentPredictions.Trula != nil && predictions.Trula.Id != game.CurrentPredictions.Trula.Id {
		s.logger.Debugw("prediction rule wasn't satisfied")
		return
	}
	// ne moreš napovedati, če ne igraš specifične igre
	if predictions.Trula != nil && !(game.GameMode >= 0 && game.GameMode <= 5) {
		s.logger.Debugw("prediction rule wasn't satisfied")
		return
	}
	// ne moreš preklicati napovedi
	if predictions.Trula == nil && game.CurrentPredictions.Trula != nil {
		s.logger.Debugw("prediction rule wasn't satisfied")
		return
	}

	// ne moreš na novo napovedati
	if predictions.Kralji != nil && game.CurrentPredictions.Kralji != nil && predictions.Kralji.Id != game.CurrentPredictions.Kralji.Id {
		s.logger.Debugw("prediction rule wasn't satisfied")
		return
	}
	// ne moreš napovedati, če ne igraš specifične igre
	if predictions.Kralji != nil && !(game.GameMode >= 0 && game.GameMode <= 5) {
		s.logger.Debugw("prediction rule wasn't satisfied")
		return
	}
	// ne moreš preklicati napovedi
	if predictions.Kralji == nil && game.CurrentPredictions.Kralji != nil {
		s.logger.Debugw("prediction rule wasn't satisfied")
		return
	}

	// ne moreš na novo napovedati
	if predictions.PagatUltimo != nil && game.CurrentPredictions.PagatUltimo != nil && predictions.PagatUltimo.Id != game.CurrentPredictions.PagatUltimo.Id {
		s.logger.Debugw("prediction rule wasn't satisfied")
		return
	}
	// ne moreš napovedati, če ne igraš specifične igre
	if predictions.PagatUltimo != nil && !(game.GameMode >= 0 && game.GameMode <= 5) {
		s.logger.Debugw("prediction rule wasn't satisfied")
		return
	}
	// ne moreš napovedati, če nisi igralec
	if predictions.PagatUltimo == nil && game.CurrentPredictions.PagatUltimo != nil && playing != game.CurrentPredictions.PagatUltimo.Id {
		s.logger.Debugw("prediction rule wasn't satisfied")
		return
	}
	// ne moreš preklicati napovedi
	if predictions.PagatUltimo == nil && game.CurrentPredictions.PagatUltimo != nil {
		s.logger.Debugw("prediction rule wasn't satisfied")
		return
	}
	// ne moreš napovedati, če nimaš pagata
	if predictions.PagatUltimo != nil && predictions.PagatUltimo.Id != "" && !(s.HasPagat(gameId, predictions.PagatUltimo.Id) && helpers.Contains(game.Playing, predictions.PagatUltimo.Id)) {
		s.logger.Debugw("prediction rule wasn't satisfied")
		return
	}

	// ne moreš na novo napovedati
	if predictions.KraljUltimo != nil && game.CurrentPredictions.KraljUltimo != nil && predictions.KraljUltimo.Id != game.CurrentPredictions.KraljUltimo.Id {
		s.logger.Debugw("prediction rule wasn't satisfied")
		return
	}
	// ne moreš napovedati, če ne igraš specifične igre
	if predictions.KraljUltimo != nil && !(game.GameMode >= 0 && game.GameMode <= 5) {
		s.logger.Debugw("prediction rule wasn't satisfied")
		return
	}
	// ne moreš napovedati, če nisi igralec
	if predictions.KraljUltimo == nil && game.CurrentPredictions.KraljUltimo != nil && playing != game.CurrentPredictions.KraljUltimo.Id {
		s.logger.Debugw("prediction rule wasn't satisfied")
		return
	}
	// ne moreš preklicati napovedi
	if predictions.KraljUltimo == nil && game.CurrentPredictions.KraljUltimo != nil {
		s.logger.Debugw("prediction rule wasn't satisfied")
		return
	}
	// ne moreš napovedati, če nimaš kralja
	if predictions.KraljUltimo != nil && predictions.KraljUltimo.Id != "" && !(s.HasKing(gameId, predictions.KraljUltimo.Id) && helpers.Contains(game.Playing, predictions.KraljUltimo.Id)) {
		s.logger.Debugw("prediction rule wasn't satisfied", "king", game.PlayingIn)
		return
	}

	if predictions.BarvniValatKontra != 0 {
		// ne moreš kontrirati, če nihče ni napovedal
		if game.CurrentPredictions.BarvniValat == nil {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
		// ne moreš zmanjšati kontre
		if predictions.BarvniValatKontra < game.CurrentPredictions.BarvniValatKontra {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
		// ne moreš napovedati več konter naenkrat (>2)
		if game.CurrentPredictions.BarvniValatKontra+1 != predictions.BarvniValatKontra && game.CurrentPredictions.BarvniValatKontra < predictions.BarvniValatKontra {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
		// kontro in subkontro lahko napovesta samo nasprotnika
		if predictions.BarvniValatKontra%2 == 1 && (predictions.BarvniValatKontraDal == nil || helpers.Contains(game.Playing, predictions.BarvniValatKontraDal.Id)) {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
		// rekontro in mortkontro lahko napovesta samo igralca
		if predictions.BarvniValatKontra%2 == 0 && (predictions.BarvniValatKontraDal == nil || !helpers.Contains(game.Playing, predictions.BarvniValatKontraDal.Id)) {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
		// ne moreš dati 5x kontre
		if predictions.BarvniValatKontra > 4 {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
	}
	if predictions.ValatKontra != 0 {
		// ne moreš kontrirati, če nihče ni napovedal
		if game.CurrentPredictions.Valat == nil {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
		// ne moreš zmanjšati kontre
		if predictions.ValatKontra < game.CurrentPredictions.ValatKontra {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
		// ne moreš napovedati več konter naenkrat (>2)
		if game.CurrentPredictions.ValatKontra+1 != predictions.ValatKontra && game.CurrentPredictions.ValatKontra < predictions.ValatKontra {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
		// kontro in subkontro lahko napovesta samo nasprotnika
		if predictions.ValatKontra%2 == 1 && (predictions.ValatKontraDal == nil || helpers.Contains(game.Playing, predictions.ValatKontraDal.Id)) {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
		// rekontro in mortkontro lahko napovesta samo igralca
		if predictions.ValatKontra%2 == 0 && (predictions.ValatKontraDal == nil || !helpers.Contains(game.Playing, predictions.ValatKontraDal.Id)) {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
		// ne moreš dati 5x kontre
		if predictions.ValatKontra > 4 {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
	}
	if predictions.KraljUltimoKontra != 0 {
		// ne moreš kontrirati, če nihče ni napovedal
		if game.CurrentPredictions.KraljUltimo == nil {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
		// ne moreš zmanjšati kontre
		if predictions.KraljUltimoKontra < game.CurrentPredictions.KraljUltimoKontra {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
		// ne moreš napovedati več konter naenkrat (>2)
		if game.CurrentPredictions.KraljUltimoKontra+1 != predictions.KraljUltimoKontra && game.CurrentPredictions.KraljUltimoKontra < predictions.KraljUltimoKontra {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
		// kontro in subkontro lahko napovesta samo nasprotnika
		if predictions.KraljUltimoKontra%2 == 1 && (predictions.KraljUltimoKontraDal == nil || helpers.Contains(game.Playing, predictions.KraljUltimoKontraDal.Id)) {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
		// rekontro in mortkontro lahko napovesta samo igralca
		if predictions.KraljUltimoKontra%2 == 0 && (predictions.KraljUltimoKontraDal == nil || !helpers.Contains(game.Playing, predictions.KraljUltimoKontraDal.Id)) {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
		// ne moreš dati 5x kontre
		if predictions.KraljUltimoKontra > 4 {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
	}
	if predictions.PagatUltimoKontra != 0 {
		// ne moreš kontrirati, če nihče ni napovedal
		if game.CurrentPredictions.PagatUltimo == nil {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
		// ne moreš zmanjšati kontre
		if predictions.PagatUltimoKontra < game.CurrentPredictions.PagatUltimoKontra {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
		// ne moreš napovedati več konter naenkrat (>2)
		if game.CurrentPredictions.PagatUltimoKontra+1 != predictions.PagatUltimoKontra && game.CurrentPredictions.PagatUltimoKontra < predictions.PagatUltimoKontra {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
		// kontro in subkontro lahko napovesta samo nasprotnika
		if predictions.PagatUltimoKontra%2 == 1 && (predictions.PagatUltimoKontraDal == nil || helpers.Contains(game.Playing, predictions.PagatUltimoKontraDal.Id)) {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
		// rekontro in mortkontro lahko napovesta samo igralca
		if predictions.PagatUltimoKontra%2 == 0 && (predictions.PagatUltimoKontraDal == nil || !helpers.Contains(game.Playing, predictions.PagatUltimoKontraDal.Id)) {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
		// ne moreš dati 5x kontre
		if predictions.PagatUltimoKontra > 4 {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
	}
	if predictions.IgraKontra != 0 {
		// ne moreš zmanjšati kontre
		if predictions.IgraKontra < game.CurrentPredictions.IgraKontra {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
		// ne moreš napovedati več konter naenkrat (>2)
		if game.CurrentPredictions.IgraKontra+1 != predictions.IgraKontra && game.CurrentPredictions.IgraKontra < predictions.IgraKontra {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
		// kontro in subkontro lahko napovesta samo nasprotnika
		if predictions.IgraKontra%2 == 1 && (predictions.IgraKontraDal == nil || helpers.Contains(game.Playing, predictions.IgraKontraDal.Id)) {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
		// rekontro in mortkontro lahko napovesta samo igralca
		if predictions.IgraKontra%2 == 0 && (predictions.IgraKontraDal == nil || !helpers.Contains(game.Playing, predictions.IgraKontraDal.Id)) {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
		// ne moreš dati 5x kontre
		if predictions.IgraKontra > 4 {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
		// pri klopu ne moreš dati rekontre
		if game.GameMode == -1 && predictions.IgraKontra > 1 {
			s.logger.Debugw("prediction rule wasn't satisfied")
			return
		}
	}

	barvicNapovedan := game.CurrentPredictions.Gamemode >= 3 && game.CurrentPredictions.Gamemode <= 5 &&
		(predictions.BarvniValat != nil && playing == predictions.BarvniValat.Id)
	valatNapovedan := game.CurrentPredictions.Gamemode >= 0 && game.CurrentPredictions.Gamemode <= 5 &&
		(predictions.Valat != nil && playing == predictions.Valat.Id)

	if barvicNapovedan {
		predictions.Gamemode = 9
	} else if valatNapovedan {
		predictions.Gamemode = 10
	}

	if predictions.Gamemode != game.CurrentPredictions.Gamemode && !barvicNapovedan && !valatNapovedan {
		s.logger.Debugw("prediction rule wasn't satisfied")
		return
	}
	if predictions.Igra == nil || predictions.Igra.Id != playing {
		s.logger.Debugw("prediction rule wasn't satisfied")
		return
	}
	if predictions.Changed {
		game.SinceLastPrediction = -1
	}
	game.SinceLastPrediction++

	game.GameMode = predictions.Gamemode
	game.CurrentPredictions = predictions

	game.EndTimer <- true

	broadcast := &messages.Message{PlayerId: playing, GameId: gameId, Data: &messages.Message_Predictions{Predictions: predictions}}
	s.Broadcast("", broadcast)

	time.Sleep(100 * time.Millisecond)

	// obvestimo še naslednjega igralca, da naj vrže karto
	if game.SinceLastPrediction >= game.PlayersNeeded-1 {
		s.FirstCard(gameId)
		return
	}

	currentPlayer := 0
	for i, v := range game.Starts {
		if v == userId {
			currentPlayer = i
			break
		}
	}
	currentPlayer++
	if currentPlayer >= game.PlayersNeeded {
		currentPlayer = 0
	}

	newId := game.Starts[currentPlayer]
	isPlaying := helpers.Contains(game.Playing, newId)
	kralj := (predictions.KraljUltimoKontra%2 == 1 && isPlaying) || (predictions.KraljUltimoKontra%2 == 0 && !isPlaying)
	valat := (predictions.ValatKontra%2 == 1 && isPlaying) || (predictions.ValatKontra%2 == 0 && !isPlaying)
	barvic := (predictions.BarvniValatKontra%2 == 1 && isPlaying) || (predictions.BarvniValatKontra%2 == 0 && !isPlaying)
	pagat := (predictions.PagatUltimoKontra%2 == 1 && isPlaying) || (predictions.PagatUltimoKontra%2 == 0 && !isPlaying)
	igra := (predictions.IgraKontra%2 == 1 && isPlaying) || (predictions.IgraKontra%2 == 0 && !isPlaying)
	trula := predictions.Trula == nil
	kralji := predictions.Kralji == nil
	ultimo := (predictions.KraljUltimo != nil && predictions.KraljUltimo.Id == newId) ||
		(predictions.PagatUltimo != nil && predictions.PagatUltimo.Id == newId)
	p := helpers.Contains(game.Playing, newId)
	s.Broadcast("", &messages.Message{PlayerId: newId, GameId: gameId, Data: &messages.Message_StartPredictions{StartPredictions: &messages.StartPredictions{
		KraljUltimoKontra: kralj && predictions.KraljUltimo != nil && predictions.KraljUltimoKontra < 4,
		PagatUltimoKontra: pagat && predictions.PagatUltimo != nil && predictions.PagatUltimoKontra < 4,
		IgraKontra:        igra && ((game.GameMode != -1 && predictions.IgraKontra < 4) || (game.GameMode == -1 && predictions.IgraKontra == 0)),
		ValatKontra:       valat && predictions.Valat != nil && predictions.ValatKontra < 4,
		BarvniValatKontra: barvic && predictions.BarvniValat != nil && predictions.BarvniValatKontra < 4,
		PagatUltimo:       !ultimo && s.HasPagat(gameId, newId) && predictions.PagatUltimo == nil,
		Trula:             trula,
		Kralji:            kralji,
		KraljUltimo:       !ultimo && s.HasKing(gameId, newId) && predictions.KraljUltimo == nil && p,
		Valat:             playing == newId && predictions.Valat == nil,
		BarvniValat:       playing == newId && predictions.BarvniValat == nil,
	}}})

	s.BotGoroutinePredictions(gameId, newId)
}
