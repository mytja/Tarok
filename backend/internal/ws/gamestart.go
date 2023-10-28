package ws

import (
	"fmt"
	"github.com/mytja/Tarok/backend/internal/events"
	"github.com/mytja/Tarok/backend/internal/helpers"
	"github.com/mytja/Tarok/backend/internal/lobby_messages"
	"github.com/mytja/Tarok/backend/internal/messages"
	"github.com/mytja/Tarok/backend/internal/sql"
	"math/rand"
	"time"
)

func (s *serverImpl) StartGame(gameId string) {
	s.logger.Debugw("game started. sending GameStart packet", "gameId", gameId)

	game, exists := s.games[gameId]
	if !exists {
		s.logger.Debugw("game has finished, it doesn't exist, exiting", "gameId", gameId)
		return
	}

	if game.Replay {
		s.logger.Debugw("game cannot start due to it being a replay", "gameId", gameId)
		return
	}

	if len(game.Starts) == 0 {
		gStarts := make([]string, 0)
		for i := range game.Players {
			gStarts = append(gStarts, i)
		}
		game.Starts = gStarts
	}

	// resetiraj vse spremenljivke pri vseh User-jih
	for _, v := range game.Players {
		v.ResetGameVariables()
		v.NewGameHistory()
	}

	firstUser := game.Starts[0]
	game.Starts = helpers.RemoveOrdered(game.Starts, 0)
	game.Starts = append(game.Starts, firstUser)

	game.GameMode = -2
	game.GameEnd = make([]string, 0)
	game.Stihi = make([][]Card, 0)
	game.Stihi = append(game.Stihi, make([]Card, 0))
	game.Talon = []Card{}
	game.Playing = append([]string{}, game.Starts...)
	game.CardsStarted = false
	game.PlayingIn = ""
	game.KrogovLicitiranja = 0
	game.NaslednjiKrogPri = ""
	game.Stashed = make([]Card, 0)
	game.SinceLastPrediction = -1
	game.CurrentPredictions = &messages.Predictions{}
	game.VotedAdditionOfGames = -1
	game.WaitingFor = ""
	game.EarlyGameStart = make([]string, 0)

	game.GameCount++

	s.Broadcast("", gameId, &messages.Message{Data: &messages.Message_GameInfo{GameInfo: &messages.GameInfo{
		GamesPlayed:   int32(game.GameCount),
		GamesRequired: int32(game.GamesRequired),
		CanExtendGame: game.CanExtendGame,
	}}})

	s.logger.Debugw("game start", "stihi", game.Stihi, "playing", game.Playing, "starts", game.Starts)

	t := make([]*messages.User, 0)
	for i, k := range game.Starts {
		if !game.Players[k].GetBotStatus() && len(game.Players[k].GetClients()) == 0 && !game.Started {
			// aborting start
			return
		}
		v := game.Players[k]
		game.Players[k].SetTimer(float64(game.StartTime))
		t = append(t, &messages.User{Name: v.GetUser().Name, Id: v.GetUser().ID, Position: int32(i)})
	}

	status := 0
	for _, k := range game.Starts {
		if !game.Players[k].GetBotStatus() && len(game.Players[k].GetClients()) != 0 {
			status++
		}
	}
	if status == 0 {
		s.EndGame(gameId)
		return
	}

	msg := messages.Message{
		Data: &messages.Message_GameStart{GameStart: &messages.GameStart{User: t}},
	}
	s.Broadcast("", gameId, &msg)

	// poskusimo počakati, saj ne želimo da broadcast kart prehiti broadcast začetka igre
	// (messages.GameStart na klientu poskrbi za izbris arraya s kartami)
	// go je tok hiter da prehiteva dobesedno vse :)
	time.Sleep(time.Millisecond * 20)

	for _, k := range game.Starts {
		s.Broadcast("", gameId, &messages.Message{
			PlayerId: k,
			Data:     &messages.Message_Time{Time: &messages.Time{CurrentTime: float32(game.Players[k].GetTimer()), Start: false}},
		})
	}

	s.ShuffleCards(gameId)

	// game must be reinitialized after s.ShuffleCards(...)
	licitatesFirst := game.Players[game.Starts[0]]
	licitiranjeMsg := messages.Message{
		PlayerId: licitatesFirst.GetUser().ID,
		Data:     &messages.Message_LicitiranjeStart{LicitiranjeStart: &messages.LicitiranjeStart{}},
	}
	licitatesFirst.BroadcastToClients(&licitiranjeMsg)

	game.Started = true

	for _, k := range game.Starts {
		if game.Players[k].GetBotStatus() || len(game.Players[k].GetClients()) != 0 {
			continue
		}
		s.Broadcast("", gameId, &messages.Message{
			PlayerId: k,
			Data: &messages.Message_Connection{
				Connection: &messages.Connection{
					Type: &messages.Connection_Disconnect{
						Disconnect: &messages.Disconnect{},
					},
				},
			},
		})
	}

	// zdaj, ko se je igra začela, ne potrebujemo več te stvari na listi
	events.Publish("lobby.broadcast", &lobby_messages.LobbyMessage{
		Data: &lobby_messages.LobbyMessage_GameDisbanded{
			GameDisbanded: &lobby_messages.GameDisbanded{
				GameId: gameId,
			},
		},
	})

	s.BotGoroutineLicitiranje(gameId, licitatesFirst.GetUser().ID)
}

func (s *serverImpl) ManuallyStartGame(playerId string, gameId string) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}

	if game.Owner != playerId {
		return
	}

	if game.Started {
		return
	}

	if len(game.Players) >= game.PlayersNeeded {
		return
	}

	game.Players[playerId].NewGameHistory()

	required := game.PlayersNeeded - len(game.Players)

	names := make([]string, 0)
	names = append(names, BOT_NAMES...)
	rand.Shuffle(len(names), func(i, j int) {
		names[i], names[j] = names[j], names[i]
	})

	for i := 0; i < required; i++ {
		uid := fmt.Sprintf("bot%s", fmt.Sprint(i))
		player := NewUser(uid, sql.User{
			ID:         uid,
			Email:      fmt.Sprintf("%s@palcka.si", uid),
			Password:   "",
			Role:       "bot",
			Name:       names[i],
			LoginToken: "",
			Rating:     1000,
			CreatedAt:  "",
			UpdatedAt:  "",
		}, s.logger)
		player.SetBotStatus()
		game.Players[uid] = player

		s.Broadcast(uid, gameId, &messages.Message{
			PlayerId: uid,
			Username: player.GetUser().Name,
			Data: &messages.Message_Connection{
				Connection: &messages.Connection{
					Rating: int32(player.GetUser().Rating),
					Type:   &messages.Connection_Join{Join: &messages.Connect{}},
				},
			},
		})
	}

	time.Sleep(100 * time.Millisecond)

	if len(game.Players) == game.PlayersNeeded {
		s.GameStartGoroutine(gameId)
	}
}

func (s *serverImpl) StartGameEarly(userId string, gameId string) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}

	if !game.CanExtendGame {
		return
	}

	if game.WaitingFor != "results" {
		return
	}

	if game.GamesRequired == game.GameCount {
		return
	}

	if game.GamesRequired == -1 {
		return
	}

	if !helpers.Contains(game.Starts, userId) {
		s.logger.Warnw("user tried to end game in which he's not in.", "userId", userId, "gameId", gameId)
		return
	}

	if helpers.Contains(game.EarlyGameStart, userId) {
		s.logger.Warnw("user tried voting twice.", "userId", userId, "gameId", gameId)
		return
	}

	game.EarlyGameStart = append(game.EarlyGameStart, userId)

	totalPlayers := 0
	for _, v := range game.Players {
		if v.GetBotStatus() {
			continue
		}
		if len(v.GetClients()) == 0 {
			continue
		}
		totalPlayers++
	}

	if len(game.EarlyGameStart) >= totalPlayers {
		s.StartGame(gameId)
	}
}
