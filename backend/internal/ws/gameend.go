package ws

import (
	"encoding/json"
	"fmt"
	"github.com/mytja/Tarok/backend/internal/events"
	"github.com/mytja/Tarok/backend/internal/helpers"
	"github.com/mytja/Tarok/backend/internal/lobby_messages"
	"github.com/mytja/Tarok/backend/internal/messages"
	"github.com/mytja/Tarok/backend/internal/sql"
	"math/rand"
	"strings"
	"time"
)

func (s *serverImpl) EndGame(gameId string) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}

	for _, v := range game.Players {
		radelci := v.GetRadelci() * -40
		v.AddPoints(radelci)
	}

	if game.Replay {
		delete(s.games, gameId)
		return
	}

	events.Publish("lobby.broadcast", &lobby_messages.LobbyMessage{Data: &lobby_messages.LobbyMessage_GameDisbanded{GameDisbanded: &lobby_messages.GameDisbanded{GameId: gameId}}})

	results := make([]*messages.ResultsUser, 0)
	for u, user := range game.Players {
		if !user.GetBotStatus() && game.Started {
			h := user.GetGameHistory()
			marshal, err := json.Marshal(h)
			if err == nil {
				chars := []rune("ABCDEFGHIJKLMNOPQRSTUVWXYZ" +
					"abcdefghijklmnopqrstuvwxyz" +
					"0123456789")
				length := 16
				var b strings.Builder
				for i := 0; i < length; i++ {
					b.WriteRune(chars[rand.Intn(len(chars))])
				}
				password := b.String()

				g := sql.Game{
					UserID:   u,
					GameID:   gameId,
					Messages: string(marshal),
					Password: password,
				}
				s.db.InsertGame(g)
				user.BroadcastToClients(&messages.Message{
					PlayerId: u,
					Data:     &messages.Message_ReplayLink{ReplayLink: &messages.ReplayLink{Replay: fmt.Sprintf("https://palcka.si/replay/%s?password=%s", gameId, password)}},
				})
			}
		}
		results = append(results,
			&messages.ResultsUser{
				User: []*messages.User{{
					Id: u,
				}},
				Points: int32(user.GetResults()),
			},
		)
	}
	s.Broadcast("", gameId, &messages.Message{Data: &messages.Message_GameEnd{GameEnd: &messages.GameEnd{Type: &messages.GameEnd_Results{Results: &messages.Results{
		User: results,
	}}}}})
	time.Sleep(3 * time.Second) // nekaj spanca, preden izbrišemo vse skupaj.
	delete(s.games, gameId)
}

func (s *serverImpl) GameAddRounds(userId string, gameId string, rounds int) {
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

	if game.GameCount != game.GamesRequired && game.GamesRequired != -1 {
		return
	}

	if !helpers.Contains(game.Starts, userId) {
		s.logger.Warnw("user tried to end game in which he's not in.", "userId", userId, "gameId", gameId)
		return
	}

	if helpers.Contains(game.GameEnd, userId) {
		s.logger.Warnw("user tried voting twice.", "userId", userId, "gameId", gameId)
		return
	}

	if !(rounds == 0 || rounds == 1 || rounds == 4 || rounds == 8 || rounds == 12 || rounds == 16 || rounds == 20) {
		s.logger.Warnw("user tried to add an unofficial number of rounds", "userId", userId, "gameId", gameId)
		return
	}

	game.GameEnd = append(game.GameEnd, userId)

	if game.VotedAdditionOfGames == -1 {
		game.VotedAdditionOfGames = rounds
	}

	if rounds < game.VotedAdditionOfGames {
		game.VotedAdditionOfGames = rounds
	}

	// TODO
	//events.Publish()

	s.Broadcast("", gameId, &messages.Message{PlayerId: userId, Data: &messages.Message_GameEnd{GameEnd: &messages.GameEnd{Type: &messages.GameEnd_Request{Request: &messages.Request{Count: int32(rounds)}}}}})
}
