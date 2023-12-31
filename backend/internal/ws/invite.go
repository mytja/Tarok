package ws

import "github.com/mytja/Tarok/backend/internal/events"

func (s *serverImpl) InvitePlayer(playerId string, gameId string, invitedId string) {
	game, exists := s.games[gameId]
	if !exists {
		return
	}

	if game.Owner != playerId {
		return
	}

	if game.TournamentID != "" {
		return
	}

	game.InvitedPlayers = append(game.InvitedPlayers, invitedId)

	events.Publish("lobby.invite", gameId, invitedId)
}
