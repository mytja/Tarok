package ws

func (s *serverImpl) InvitePlayer(playerId string, gameId string, invitedId string) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}

	if game.Owner != playerId {
		return
	}

	game.InvitedPlayers = append(game.InvitedPlayers, invitedId)
}
