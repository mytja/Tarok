package tournament

import (
	"github.com/mytja/Tarok/backend/internal/consts"
	"github.com/mytja/Tarok/backend/internal/events"
	"github.com/mytja/Tarok/backend/internal/messages"
	"github.com/mytja/Tarok/backend/internal/ws"
	"sort"
	"time"
)

func (s *tournamentImpl) NewTournamentGame(userId string, startTime int, rounds int) {
	user, err := s.db.GetUser(userId)
	if err != nil {
		s.logger.Errorw("failure while fetching user from the database", "err", err, "userId", userId, "tournamentId", s.tournamentId)
		return
	}

	gameId := s.wsServer.NewGame(4, "normal", true, userId, 0, startTime, false, false, false, rounds)
	s.games[gameId] = s.wsServer.GetGame(gameId)
	game := s.games[gameId]
	game.TournamentID = s.tournamentId
	game.Players[userId] = ws.NewUser(userId, user, s.logger)
	game.Players[userId].SetTimer(float64(game.StartTime) * (1 + consts.TALON_OPEN_TIME_PART))

	s.wsServer.ManuallyStartGame(userId, gameId)
	game.GameCount = 0

	events.Publish("lobby.newPrivateGame", gameId, userId)

	s.logger.Infow("created new tournament game", "gameId", gameId, "tournamentId", s.tournamentId, "userId", userId)
}

func (s *tournamentImpl) OpenLobbies() {
	s.logger.Infow("opening lobbies for tournament", "tournamentId", s.tournamentId)

	s.openedLobbies = true

	tournament, err := s.db.GetTournament(s.tournamentId)
	if err != nil {
		s.logger.Errorw("failure while fetching tournament", "err", err, "tournamentId", s.tournamentId)
		return
	}

	if !s.test && tournament.StartTime/1000 > s.startTime {
		s.startTime = tournament.StartTime
		s.openedLobbies = false

		s.logger.Infow("postponing tournament", "tournamentId", s.tournamentId)
		return
	}

	participants, err := s.db.GetAllTournamentParticipants(s.tournamentId)
	if err != nil {
		s.logger.Errorw("failure while fetching tournament participants", "err", err, "tournamentId", s.tournamentId)
		return
	}

	tournamentRounds, err := s.db.GetAllTournamentRounds(s.tournamentId)
	if err != nil {
		s.logger.Errorw("failure while fetching tournament rounds", "err", err, "tournamentId", s.tournamentId)
		return
	}

	if len(tournamentRounds) == 0 {
		s.logger.Errorw("failure: no tournament rounds", "err", err, "tournamentId", s.tournamentId)
		return
	}

	tournamentRound1 := tournamentRounds[0]
	tournamentRoundsCount := len(tournamentRounds)

	for _, participant := range participants {
		if s.test && participant.UserID != s.testerId {
			continue
		}
		s.NewTournamentGame(participant.UserID, tournamentRound1.Time, tournamentRoundsCount)
	}
}

type CurrentResults struct {
	Points int
	UserID string
	Rank   int
	GameID string
}

func (s *tournamentImpl) BroadcastCurrentStatus() {
	m := make([]CurrentResults, 0)

	for gameId, game := range s.games {
		for _, v := range game.Players {
			if v.GetBotStatus() {
				continue
			}
			userId := v.GetUser().ID
			points := v.GetResults()
			points -= 40 * v.GetRadelci()
			m = append(m, CurrentResults{
				Points: points,
				UserID: userId,
				GameID: gameId,
			})

		}
	}

	sort.Slice(m, func(i, j int) bool {
		return m[i].Points > m[j].Points
	})

	if len(m) == 0 {
		return
	}

	m[0].Rank = 1

	for i := 1; i < len(m); i++ {
		prev := m[i-1]
		if prev.Points == m[i].Points {
			m[i].Rank = prev.Rank
		} else {
			m[i].Rank = i + 1
		}
	}

	for i := 0; i < len(m); i++ {
		game := s.wsServer.GetGame(m[i].GameID)
		if game == nil {
			continue
		}
		player, exists := game.Players[m[i].UserID]
		if !exists {
			continue
		}
		player.BroadcastToClients(&messages.Message{
			Data: &messages.Message_TournamentStatistics{TournamentStatistics: &messages.TournamentStatistics{
				Place:           int32(m[i].Rank),
				Players:         int32(len(m)),
				TopPlayerPoints: int32(m[0].Points),
			}},
		})
	}
}

func (s *tournamentImpl) CalculateRating() {
	time.Sleep(10 * time.Second) // wait for end of all tournament games and reporting to the database
	ratingCalc := make([]UserRating, 0)
	for _, game := range s.games {
		for _, v := range game.Players {
			if v.GetBotStatus() {
				continue
			}
			userId := v.GetUser().ID
			points := v.GetResults()
			points -= 40 * v.GetRadelci()
			participant, err := s.db.GetTournamentParticipantByTournamentUser(s.tournamentId, userId)
			if err != nil {
				s.logger.Errorw("error while fetching tournament participant", "tournamentId", s.tournamentId, "userId", userId, "points", points)
				continue
			}

			// če oseba ni odigrala niti ene igre lahko zanjo naredimo turnir nerejtan
			if len(game.ResultsArchive) == 0 {
				participant.Rated = false
				err = s.db.UpdateTournamentParticipant(participant)
				if err != nil {
					s.logger.Errorw("error while updating tournament participant", "err", err)
				}
				continue
			}

			participant.RatingPoints = points
			err = s.db.UpdateTournamentParticipant(participant)
			if err != nil {
				s.logger.Errorw("error while updating tournament participant", "tournamentId", s.tournamentId, "userId", userId, "points", points)
				continue
			}
			if !participant.Rated {
				continue
			}
			user, err := s.db.GetUser(userId)
			if err != nil {
				s.logger.Errorw("error while fetching user", "tournamentId", s.tournamentId, "userId", userId, "points", points)
				continue
			}
			p := NewUserRating(userId, 1, user.Rating)
			p.Points = points
			ratingCalc = append(ratingCalc, p)
		}
	}

	if len(ratingCalc) == 0 {
		return
	}

	sort.Slice(ratingCalc, func(i, j int) bool {
		return ratingCalc[i].Points > ratingCalc[j].Points
	})

	if len(ratingCalc) == 0 {
		return
	}

	ratingCalc[0].Rank = 1

	for i := 1; i < len(ratingCalc); i++ {
		prev := ratingCalc[i-1]
		if prev.Points == ratingCalc[i].Points {
			ratingCalc[i].Rank = prev.Rank
		} else {
			ratingCalc[i].Rank = float64(i + 1)
		}
	}

	s.logger.Debugw("tournament results", "calc", ratingCalc)

	CalculateRating(&ratingCalc)

	s.logger.Debugw("calculated tournament results", "calc", ratingCalc)

	for _, v := range ratingCalc {
		participant, err := s.db.GetTournamentParticipantByTournamentUser(s.tournamentId, v.UserID)
		if err != nil {
			s.logger.Errorw("error while fetching tournament participant", "tournamentId", s.tournamentId, "userId", v.UserID, "newRating", v.NewRating)
			continue
		}
		participant.RatingDelta = v.NewRating - v.OldRating
		err = s.db.UpdateTournamentParticipant(participant)
		if err != nil {
			s.logger.Errorw("error while updating tournament participant", "tournamentId", s.tournamentId, "userId", v.UserID, "newRating", v.NewRating)
			continue
		}
		if !participant.Rated {
			continue
		}
		user, err := s.db.GetUser(v.UserID)
		if err != nil {
			s.logger.Errorw("error while fetching user", "tournamentId", s.tournamentId, "userId", v.UserID, "newRating", v.NewRating)
			continue
		}
		user.Rating = v.NewRating
		err = s.db.UpdateUser(user)
		if err != nil {
			s.logger.Errorw("error while updating user", "tournamentId", s.tournamentId, "userId", v.UserID, "newRating", v.NewRating)
			continue
		}
	}
}

func (s *tournamentImpl) EndTournament() {
	s.CalculateRating()
	s.logger.Debugw("rating calculated. now awaiting game ends.")
	time.Sleep(1 * time.Second)
	for i := range s.games {
		s.wsServer.EndGame(i)
	}
}

func (s *tournamentImpl) StartGame() bool {
	s.round++

	s.logger.Infow("starting new tournament round", "tournamentId", s.tournamentId, "round", s.round)

	round, err := s.db.GetTournamentRoundByTournamentNumber(s.tournamentId, s.round)
	if err != nil {
		s.logger.Errorw("failure while fetching tournament round. ending tournament", "round", s.round, "tournamentId", s.tournamentId)
		s.EndTournament()
		return true
	}
	s.talonTimeoutTime = int(float64(round.Time) * consts.TALON_OPEN_TIME_PART)
	s.nextRoundTime = int(time.Now().Unix()) + round.Time + s.talonTimeoutTime

	s.logger.Infow("calculated talon timeout", "talonTimeout", s.talonTimeoutTime)

	go s.BroadcastCurrentStatus()

	for i := range s.games {
		events.Publish("tournament.startGame", i)
	}

	return false
}

func (s *tournamentImpl) SetTimeout(timeout bool) {
	for _, v := range s.games {
		v.TimeoutReached = timeout
	}
}

func (s *tournamentImpl) SoftTimeoutRunningGames(softTimeout int, forcedTimeout int) bool {
	if int(time.Now().Unix()) >= forcedTimeout {
		s.HardTimeoutRunningGames()
		return true
	}

	for i, v := range s.games {
		if v.TimeoutReached {
			continue
		}
		if int(time.Now().UnixMilli()) >= softTimeout+v.MovesPlayed*consts.TOURNAMENT_SOFT_TIMEOUT_EXTENSION {
			s.logger.Infow("enforcing soft timeout on running tournament game", "tournamentId", s.tournamentId, "round", s.round, "game", i, "movesPlayed", v.MovesPlayed)
			v.TimeoutReached = true
		}
	}
	return false
}

func (s *tournamentImpl) HardTimeoutRunningGames() {
	s.logger.Infow("enforcing hard timeout on tournament games", "tournamentId", s.tournamentId, "round", s.round)
	for _, v := range s.games {
		v.TimeoutReached = true
	}
}

func (s *tournamentImpl) RunOrganizer() {
	s.logger.Infow("starting tournament organizer goroutine", "tournamentId", s.tournamentId)

	if s.test {
		s.logger.Infow("running a virtual (testing) tournament", "tournamentId", s.tournamentId, "user", s.testerId)
	}

	for {
		if !s.openedLobbies && int(time.Now().Unix()+300) >= s.startTime {
			s.OpenLobbies()
			continue
		}

		if int(time.Now().Unix()) < s.startTime && !s.openedLobbies {
			time.Sleep(15 * time.Second)
			continue
		}

		if s.roundStarted {
			dynamicEndMs := (s.nextRoundTime - consts.TOURNAMENT_GAME_END_TIMEOUT) * 1000
			forcedTimeout := s.nextRoundTime - 5

			time.Sleep(time.Duration(s.talonTimeoutTime-consts.TALON_TIMEOUT) * time.Second)

			// timeoutamo talon
			s.SetTimeout(true)

			time.Sleep(consts.TALON_TIMEOUT * time.Second)
			s.SetTimeout(false)

			s.logger.Debugw("odpiram talon")

			for i := range s.games {
				s.wsServer.Talon(i)
			}

			for {
				if s.SoftTimeoutRunningGames(dynamicEndMs, forcedTimeout) {
					break
				}
				time.Sleep(10 * time.Millisecond)
			}

			// wait for the hard timeout to end
			d := 5 * time.Second
			time.Sleep(d)

			s.logger.Infow("starting new tournament game", "tournamentId", s.tournamentId, "round", s.round)
			if s.StartGame() {
				// ending tournament
				break
			}

			time.Sleep(1 * time.Second)
			continue
		}

		if s.openedLobbies && !s.roundStarted && int(time.Now().Unix()) >= s.startTime {
			s.logger.Infow("starting first game of tournament", "tournamentId", s.tournamentId, "round", s.round)
			s.roundStarted = true
			if s.StartGame() {
				// ending tournament
				break
			}
		}

		time.Sleep(1 * time.Second)
	}

	s.logger.Infow("exiting tournament organizer goroutine. tournament is now officially over", "tournamentId", s.tournamentId)
}
