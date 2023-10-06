package ws

func (s *serverImpl) SelectReplayGame(gameId string, replayGame int) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}

	if !game.Replay {
		return
	}

	if len(game.ReplayMessages) <= replayGame {
		return
	}

	g := game.ReplayMessages[replayGame]
	if len(g) == 0 {
		return
	}

	game.ReplayGame = replayGame

	s.Broadcast("", g[0])
}

func (s *serverImpl) NextReplayStep(gameId string) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}

	if !game.Replay {
		return
	}

	g := game.ReplayMessages[game.ReplayGame]
	if len(g) <= game.ReplayState+1 {
		return
	}

	game.ReplayState++

	s.Broadcast("", g[game.ReplayState])
}
