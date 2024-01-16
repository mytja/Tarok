package main

import (
	"context"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"github.com/google/uuid"
	"github.com/mytja/Tarok/backend/internal/consts"
	"github.com/mytja/Tarok/backend/internal/httphandlers"
	"github.com/mytja/Tarok/backend/internal/lobby"
	"github.com/mytja/Tarok/backend/internal/messages"
	"github.com/mytja/Tarok/backend/internal/sql"
	"github.com/mytja/Tarok/backend/internal/tournament"
	"github.com/mytja/Tarok/backend/internal/ws"
	"github.com/rs/cors"
	goji "goji.io"
	"google.golang.org/protobuf/proto"
	"io"
	"net/http"
	"os"
	"os/signal"
	"strconv"
	"syscall"
	"time"

	"github.com/spf13/cobra"
	"go.uber.org/zap"
	"goji.io/pat"
)

var (
	server ws.Server
)

func main() {
	config := consts.ServerConfig{}

	command := &cobra.Command{
		Use:   "ptrun-server",
		Short: "Game server for PTRun",
		Run: func(cmd *cobra.Command, args []string) {
			run(&config)
		},
	}

	jsonFile, err := os.Open("config.json")
	if err != nil {
		panic(err)
	}
	defer jsonFile.Close()

	byteValue, err := io.ReadAll(jsonFile)
	if err != nil {
		panic(err)
	}

	var fileConf consts.ServerFileConfig
	err = json.Unmarshal(byteValue, &fileConf)
	if err != nil {
		panic(err)
	}

	config.EmailAccount = fileConf.EmailAccount
	config.EmailPassword = fileConf.EmailPassword
	config.EmailPort = fileConf.EmailPort
	config.EmailServer = fileConf.EmailServer

	command.Flags().BoolVar(&config.Debug, "debug", true, "enable debug mode")
	command.Flags().StringVar(&config.Host, "host", "0.0.0.0", "set server host")
	command.Flags().StringVar(&config.Port, "port", "8080", "set server port")
	command.Flags().StringVar(&config.Path, "path", "/ws", "set server WS path")
	command.Flags().StringVar(&config.Postgres, "pghost", "127.0.0.1", "set server postgres host")

	if err := command.Execute(); err != nil {
		//fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}

func run(config *consts.ServerConfig) {
	var logger *zap.Logger
	var err error

	if config.Debug {
		logger, err = zap.NewDevelopment()
	} else {
		logger, err = zap.NewProduction()
	}

	if err != nil {
		panic(err)
	}

	sugared := logger.Sugar()

	db, err := sql.NewSQL("postgres", fmt.Sprintf("host=%s database=Tarok port=5432 user=postgres password=postgres sslmode=disable", config.Postgres), sugared)
	if err != nil {
		sugared.Errorw("failed to initialize database", "err", err)
		return
	}
	db.Init()

	server = ws.NewServer(logger, db)
	go server.Run()

	lobbyServer := lobby.NewLobbyServer(logger, db, server)
	go lobbyServer.Run()

	httpServer := httphandlers.NewHTTPHandler(db, config, sugared, server)

	sugared.Infow("starting websocket endpoint",
		"host", config.Host,
		"port", config.Port,
		"path", config.Path)

	mux := goji.NewMux()
	mux.HandleFunc(pat.Get("/ws/:id"), func(w http.ResponseWriter, r *http.Request) {
		server.Connect(w, r)
	})
	mux.HandleFunc(pat.Get("/lobby"), func(w http.ResponseWriter, r *http.Request) {
		lobbyServer.Connect(w, r)
	})
	mux.HandleFunc(pat.Post("/quick"), func(w http.ResponseWriter, r *http.Request) {
		user, err := db.CheckToken(r)
		if err != nil {
			w.WriteHeader(http.StatusForbidden)
			return
		}

		playerCount, err := strconv.Atoi(r.FormValue("players"))
		if err != nil {
			w.WriteHeader(http.StatusBadRequest)
			return
		}

		tip := r.FormValue("tip")
		if !(tip == "normal" || tip == "klepetalnica") {
			w.WriteHeader(http.StatusBadRequest)
			return
		}

		defaultTime := ws.DEFAULT_TIME
		if tip == "klepetalnica" {
			defaultTime = ws.KLEPETALNICA_TIME
		}

		additionalTime := ws.DEFAULT_ADDITIONAL_TIME
		if tip == "klepetalnica" {
			additionalTime = ws.KLEPETALNICA_TIME
		}

		game := server.GetMatch(playerCount, tip, user)
		if game == "CREATE" {
			logger.Info("creating new game")
			game = server.NewGame(playerCount, tip, false, user.ID, additionalTime, int(defaultTime), false, false, false, 8)
		}

		w.WriteHeader(http.StatusOK)
		w.Write([]byte(game))
	})
	mux.HandleFunc(pat.Post("/game/new/:gamemode/:type"), func(w http.ResponseWriter, r *http.Request) {
		user, err := db.CheckToken(r)
		if err != nil {
			w.WriteHeader(http.StatusForbidden)
			return
		}

		t := pat.Param(r, "type")
		if !(t == "normal" || t == "klepetalnica") {
			w.WriteHeader(http.StatusBadRequest)
			return
		}

		atoi, err := strconv.Atoi(pat.Param(r, "gamemode"))
		if err != nil {
			sugared.Debugw("atoi failed", "err", err)
			return
		}

		private, err := strconv.ParseBool(r.FormValue("private"))
		if err != nil {
			sugared.Debugw("atoi failed", "err", err)
			return
		}

		mondfang, err := strconv.ParseBool(r.FormValue("mondfang"))
		if err != nil {
			sugared.Debugw("parsebool failed", "err", err)
			return
		}

		napovedanMondfang, err := strconv.ParseBool(r.FormValue("napovedanMondfang"))
		if err != nil {
			sugared.Debugw("parsebool failed", "err", err)
			return
		}

		if !(atoi == 3 || atoi == 4) {
			sugared.Debugw("atoi failed", "err", err)
			return
		}

		additionalTime, err := strconv.ParseFloat(r.FormValue("pribitek"), 64)
		if err != nil {
			sugared.Debugw("atoi failed", "err", err)
			return
		}

		startTime, err := strconv.ParseInt(r.FormValue("zacetniCas"), 10, 32)
		if err != nil {
			sugared.Debugw("atoi failed", "err", err)
			return
		}

		rund, err := strconv.Atoi(r.FormValue("rund"))
		if err != nil {
			sugared.Debugw("atoi failed", "err", err)
			return
		}

		if rund <= 0 || rund > 40 {
			rund = -1
		}

		skisfang, err := strconv.ParseBool(r.FormValue("skisfang"))
		if err != nil {
			sugared.Debugw("atoi failed", "err", err)
			return
		}

		w.WriteHeader(http.StatusOK)

		game := server.NewGame(atoi, t, private, user.ID, additionalTime, int(startTime), skisfang, mondfang, napovedanMondfang, rund)

		w.Write([]byte(game))
	})
	mux.HandleFunc(pat.Get("/replay/:game_id"), func(w http.ResponseWriter, r *http.Request) {
		user, err := db.CheckToken(r)
		if err != nil {
			w.WriteHeader(http.StatusForbidden)
			return
		}

		gameId := pat.Param(r, "game_id")
		game, err := db.GetGame(gameId)
		if err != nil {
			sugared.Debugw("error while fetching game", "err", err)
			w.WriteHeader(http.StatusInternalServerError)
			return
		}

		if game.UserID != user.ID {
			password := r.URL.Query().Get("password")
			if password != game.Password {
				w.WriteHeader(http.StatusForbidden)
				return
			}
		}

		var j [][]string
		err = json.Unmarshal([]byte(game.Messages), &j)
		if err != nil {
			sugared.Debugw("error while unmarshaling messages", "err", err)
			w.WriteHeader(http.StatusInternalServerError)
			return
		}

		msgs := make([][]*messages.Message, 0)

		players := 4
		replayId := uuid.NewString()

		for _, v := range j {
			ff := make([]*messages.Message, 0)
			for _, l := range v {
				var msg messages.Message
				decoded, err := base64.StdEncoding.DecodeString(l)
				if err != nil {
					sugared.Debugw("error while decoding base64", "err", err)
					w.WriteHeader(http.StatusInternalServerError)
					return
				}
				err = proto.Unmarshal(decoded, &msg)
				if err != nil {
					sugared.Debugw("error while unmarshalling protobuf", "err", err)
					w.WriteHeader(http.StatusInternalServerError)
					return
				}

				skip := false

				data := msg.Data
				switch u := data.(type) {
				case *messages.Message_GameStart:
					players = len(u.GameStart.User)
					break
				case *messages.Message_GameStartCountdown:
					skip = true
					break
				case *messages.Message_Time:
					skip = true
					break
				case *messages.Message_Card:
					c := u.Card
					// CardRequest moramo poslati uporabniku
					if msg.PlayerId == user.ID {
						break
					}

					request := false
					switch c.Type.(type) {
					case *messages.Card_Request:
						request = true
						break
					}

					if request {
						skip = true
						break
					}
				}

				if skip {
					continue
				}

				ff = append(ff, &msg)
			}
			msgs = append(msgs, ff)
		}

		server.NewReplay(msgs, user.ID, replayId)

		jj := map[string]string{"replayId": replayId, "playerCount": fmt.Sprint(players)}
		marshal, err := json.Marshal(jj)
		if err != nil {
			sugared.Debugw("error while marshaling json", "err", err)
			w.WriteHeader(http.StatusInternalServerError)
			return
		}

		w.Write(marshal)
	})
	mux.HandleFunc(pat.Get("/admin/users"), httpServer.GetUsers)
	mux.HandleFunc(pat.Patch("/admin/accounts/disable"), httpServer.DisableAccount)
	mux.HandleFunc(pat.Patch("/admin/accounts/validate"), httpServer.ValidateEmail)
	mux.HandleFunc(pat.Patch("/admin/accounts/promote_demote"), httpServer.PromoteDemoteUser)
	mux.HandleFunc(pat.Get("/admin/reg_code"), httpServer.GetRegistrationCodes)
	mux.HandleFunc(pat.Post("/admin/reg_code"), httpServer.NewRegistrationCode)
	mux.HandleFunc(pat.Delete("/admin/reg_code"), httpServer.DeleteRegistrationCode)
	mux.HandleFunc(pat.Patch("/account/name"), httpServer.ChangeName)
	mux.HandleFunc(pat.Patch("/account/handle"), httpServer.ChangeHandle)
	mux.HandleFunc(pat.Patch("/account/password"), httpServer.ChangePassword)
	mux.HandleFunc(pat.Post("/account/profile_picture"), httpServer.ChangeProfilePicture)
	mux.HandleFunc(pat.Delete("/account/profile_picture"), httpServer.RemoveProfilePicture)
	mux.HandleFunc(pat.Get("/account"), httpServer.GetUserData)
	mux.HandleFunc(pat.Post("/register"), httpServer.Registration)
	mux.HandleFunc(pat.Post("/login"), httpServer.Login)
	mux.HandleFunc(pat.Post("/logout"), httpServer.Logout)
	mux.HandleFunc(pat.Post("/email/confirm"), httpServer.ConfirmEmail)
	mux.HandleFunc(pat.Post("/password/reset_request"), httpServer.RequestPasswordReset)
	mux.HandleFunc(pat.Post("/password/reset"), httpServer.PasswordResetConfirm)
	mux.HandleFunc(pat.Get("/tournaments/all"), httpServer.GetAllTournaments)
	mux.HandleFunc(pat.Get("/tournaments/upcoming"), httpServer.GetUpcomingTournaments)
	mux.HandleFunc(pat.Post("/tournaments"), httpServer.NewTournament)
	mux.HandleFunc(pat.Patch("/tournament/:tournamentId"), httpServer.UpdateTournament)
	mux.HandleFunc(pat.Delete("/tournament/:tournamentId"), httpServer.DeleteTournament)
	mux.HandleFunc(pat.Get("/tournament/:tournamentId/participants"), httpServer.GetAllParticipants)
	mux.HandleFunc(pat.Post("/tournament/:tournamentId/testers"), httpServer.AddTournamentTester)
	mux.HandleFunc(pat.Delete("/tournament/:tournamentId/testers"), httpServer.RemoveTournamentTester)
	mux.HandleFunc(pat.Post("/tournament/:tournamentId/register"), httpServer.AddParticipation)
	mux.HandleFunc(pat.Post("/tournament/:tournamentId/unregister"), httpServer.RemoveParticipation)
	mux.HandleFunc(pat.Get("/participations"), httpServer.GetParticipations)
	mux.HandleFunc(pat.Patch("/participation/:participationId/rated_unrated"), httpServer.ToggleRatedUnratedParticipant)
	mux.HandleFunc(pat.Get("/tournament/:tournamentId/stats"), httpServer.GetTournamentStatistics)
	mux.HandleFunc(pat.Get("/tournament/:tournamentId/rounds"), httpServer.GetTournamentRounds)
	mux.HandleFunc(pat.Post("/tournament/:tournamentId/rounds"), httpServer.NewTournamentRound)
	mux.HandleFunc(pat.Post("/tournament/:tournamentId/testing"), httpServer.TestTournament)
	mux.HandleFunc(pat.Patch("/tournament/:tournamentId/rating/recalculate"), httpServer.RecalculateTournamentRating)
	mux.HandleFunc(pat.Post("/tournament_round/:tournamentRoundId/clear"), httpServer.ClearTournamentRoundCards)
	mux.HandleFunc(pat.Post("/tournament_round/:tournamentRoundId/reshuffle"), httpServer.ReshuffleRoundCards)
	mux.HandleFunc(pat.Post("/tournament_round/:tournamentRoundId/card"), httpServer.AddCardTournamentRound)
	mux.HandleFunc(pat.Delete("/tournament_round/:tournamentRoundId/card"), httpServer.RemoveCardTournamentRound)
	mux.HandleFunc(pat.Patch("/tournament_round/:tournamentRoundId/time"), httpServer.ChangeRoundTime)
	mux.HandleFunc(pat.Delete("/tournament_round/:tournamentRoundId"), httpServer.DeleteTournamentRound)
	mux.HandleFunc(pat.Get("/user/:userId/profile_picture"), httpServer.GetProfilePicture)

	tournaments, err := db.GetAllNotStartedTournaments()
	if err != nil {
		sugared.Fatalw("error while fetching upcoming tournaments from the database", "err", err)
		return
	}

	for _, tour := range tournaments {
		t := tournament.NewTournament(tour.ID, sugared, db, server, tour.StartTime, false, "")
		go t.RunOrganizer()
	}

	c := cors.New(cors.Options{
		AllowedOrigins: []string{"*"}, // All origins
		AllowedHeaders: []string{"X-Login-Token"},
		AllowedMethods: []string{"POST", "GET", "DELETE", "PATCH", "PUT", "OPTIONS"},
	})

	srv := &http.Server{
		Handler: c.Handler(mux),
		Addr:    fmt.Sprintf("%s:%s", config.Host, config.Port),
		// These should probably be moved under internal/const
		WriteTimeout: 15 * time.Second,
		ReadTimeout:  15 * time.Second,
		IdleTimeout:  15 * time.Second,
	}

	done := make(chan os.Signal, 1)
	signal.Notify(done, os.Interrupt, syscall.SIGINT, syscall.SIGTERM)

	go func() {
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			sugared.Errorw("error starting http server", zap.Error(err))
		}
	}()

	<-done
	sugared.Debug("stopping")

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer func() {
		// If we need any more cleanup, it should go here

		// We should probably check and gracefully shutdown everything at this
		// point and also disconnect all our clients
		cancel()
	}()

	if err := srv.Shutdown(ctx); err != nil {
		sugared.Errorw("error shutting down http server", zap.Error(err))
	}
}
