package ws

import (
	"github.com/mytja/Tarok/backend/internal/messages"
	"time"
)

func (s *serverImpl) SelectReplayGame(gameId string, replayGame int) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}

	if !game.Replay {
		return
	}

	replayGame++

	if len(game.ReplayMessages) <= replayGame {
		return
	}

	g := game.ReplayMessages[replayGame]
	if len(g) == 0 {
		return
	}

	game.ReplayGame = replayGame
	game.ReplayState = 1

	s.Broadcast("", gameId, g[0])
}

func (s *serverImpl) SendFirstReplayMessage(gameId string) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}

	if !game.Replay {
		return
	}

	if len(game.ReplayMessages) == 0 {
		return
	}

	g := game.ReplayMessages[0]
	if len(g) == 0 {
		return
	}

	for i, v := range game.ReplayMessages {
		for _, k := range v {
			if i == 0 {
				s.Broadcast("", gameId, k)
				continue
			}

			k.Silent = true

			switch k.Data.(type) {
			case *messages.Message_GameStart:
				s.Broadcast("", gameId, k)
				break
			case *messages.Message_Results:
				s.Broadcast("", gameId, k)
				break
			}
		}

		time.Sleep(10 * time.Millisecond)
	}

	time.Sleep(50 * time.Millisecond)

	for _, v := range game.ReplayMessages {
		for _, k := range v {
			k.Silent = false
		}
	}

	game.ReplayGame = 1
	s.Broadcast("", gameId, g[0])
}

func (s *serverImpl) NextReplayStep(gameId string) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}

	if !game.Replay {
		return
	}

	if len(game.ReplayMessages) <= game.ReplayGame {
		s.logger.Debugw("ne morem pridobiti igre", "replayState", game.ReplayState, "g", game.ReplayGame, "msg", len(game.ReplayMessages))
		return
	}

	g := game.ReplayMessages[game.ReplayGame]

	game.ReplayState++

	if len(g) <= game.ReplayState {
		s.logger.Debugw("replay state is higher than length of a replay", "replayState", game.ReplayState, "g", len(g))
		return
	}

	r := g[game.ReplayState]
	sent := 0
	for i, v := range g {
		if i <= game.ReplayState {
			continue
		}

		cancel := false
		switch k := v.Data.(type) {
		case *messages.Message_Card:
			card := k.Card
			send := false
			request := false
			switch card.Type.(type) {
			case *messages.Card_Send:
				send = true
				break
			case *messages.Card_Receive:
				send = true
				break
			case *messages.Card_Request:
				request = true
				break
			}

			if request {
				sent++
				s.Broadcast("", gameId, v)
				cancel = true
				break
			}

			if r.PlayerId != card.UserId {
				cancel = true
				break
			}

			if !send {
				break
			}

			s.Broadcast("", gameId, v)
			sent++
			break
		default:
			cancel = true
			break
		}

		if cancel {
			break
		}
	}

	game.ReplayState += sent
	s.Broadcast("", gameId, r)
}
