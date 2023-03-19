package ws

import (
	"github.com/google/uuid"
	"github.com/mytja/Tarok/backend/internal/helpers"
	"github.com/mytja/Tarok/backend/internal/sql"
	"goji.io/pat"
	"math/rand"
	"net/http"
	"time"

	"github.com/gorilla/websocket"
	"go.uber.org/zap"

	"github.com/mytja/Tarok/backend/internal/consts"
	"github.com/mytja/Tarok/backend/internal/events"
	"github.com/mytja/Tarok/backend/internal/messages"
)

var (
	socketUpgrader = websocket.Upgrader{
		ReadBufferSize:  1024,
		WriteBufferSize: 1024,
		CheckOrigin: func(r *http.Request) bool {
			return true
		},
	}
)

// serevrImpl has data about all clients
// and sends the connect and disconnect messages
type serverImpl struct {
	logger     *zap.SugaredLogger
	games      map[string]Game
	db         sql.SQL
	connect    chan connectMessage
	disconnect chan Client
	broadcast  chan broadcastMessage
}

// connectMessage is used to send the connect message
type connectMessage struct {
	game string
	conn *websocket.Conn
	user sql.User
	done chan Client
}

type broadcastMessage struct {
	msg           *messages.Message
	game          string
	excludeClient string
}

// NewServer return all the data for the server
func NewServer(logger *zap.Logger, db sql.SQL) Server {
	return &serverImpl{
		logger:     logger.Sugar(),
		games:      make(map[string]Game),
		db:         db,
		connect:    make(chan connectMessage, consts.ChanBufferSize),
		broadcast:  make(chan broadcastMessage, consts.ChanBufferSize),
		disconnect: make(chan Client, consts.ChanBufferSize),
	}
}

// Run is used for connecting and disconnecting clients from the server
func (s *serverImpl) Run() {
	s.logger.Debug("server started and listening for events")
	s.handleBroadcast()
	s.handleDisconnect()
	for {
		select {
		case connect := <-s.connect:
			s.logger.Infow("new connection", "remoteAddr", connect.conn.RemoteAddr())
			gameId := connect.game
			client := NewClient(connect.user, connect.conn, s, s.logger.Desugar(), gameId)
			connect.done <- client
		case disconnect := <-s.disconnect:
			s.logger.Infow("disconnect", "id", disconnect.GetUserID(), "remoteAddr", disconnect.GetRemoteAddr())
			for i, v := range s.games[disconnect.GetGame()].Players[disconnect.GetUserID()] {
				if v.GetClientID() != disconnect.GetClientID() {
					continue
				}
				s.games[disconnect.GetGame()].Players[disconnect.GetUserID()] = helpers.Remove(s.games[disconnect.GetGame()].Players[disconnect.GetUserID()], i)
				break
			}
			s.logger.Debugw("disconnected the user. now closing the connection")
			disconnect.Close()
			s.logger.Debugw("connection close now finished")
			//recover()

			// Notify all other players
			playerId := disconnect.GetUserID()
			msg := messages.Message{
				GameId:   disconnect.GetGame(),
				PlayerId: playerId,
				Data:     &messages.Message_Connection{Connection: &messages.Connection{Rating: int32(disconnect.GetUser().Rating), Type: &messages.Connection_Disconnect{Disconnect: &messages.Disconnect{}}}},
			}

			s.logger.Debugw("broadcasting disconnect message to everybody in the game")
			if len(s.games[disconnect.GetGame()].Players[playerId]) == 0 {
				s.Broadcast(playerId, &msg)
			}
			if len(s.games[disconnect.GetGame()].Players)+1 == s.games[disconnect.GetGame()].PlayersNeeded {
				s.logger.Debugw("cancelling the game start", "gameId", disconnect.GetGame(), "id", disconnect.GetUserID(), "game", s.games[disconnect.GetGame()])
				s.games[disconnect.GetGame()].cancel <- true
			}
			s.logger.Debugw("done disconnecting the user")
		case broadcast := <-s.broadcast:
			s.logger.Debugw("Broadcasting", "id", broadcast.excludeClient, "msg", broadcast.msg)
			//broadcast.msg.PlayerId = broadcast.excludeClient
			for userId, clients := range s.games[broadcast.msg.GameId].Players {
				if broadcast.excludeClient == userId {
					continue
				}

				for _, client := range clients {
					client.Send(broadcast.msg)
				}
			}
		}
	}
}

// Connect gives Run the data to connect the client and starts functions ReadPump and SendPump
func (s *serverImpl) Connect(w http.ResponseWriter, r *http.Request) Client {
	game := pat.Param(r, "id")

	conn, err := socketUpgrader.Upgrade(w, r, nil)
	if err != nil {
		s.logger.Errorw("error while upgrading connection", zap.Error(err))
		return nil
	}

	done := make(chan Client)
	s.connect <- connectMessage{conn: conn, done: done, game: game}
	s.logger.Info("successfully sent connectMessage to s.connect channel")
	client := <-done
	go client.ReadPump()
	go client.SendPump()

	client.Send(&messages.Message{GameId: game, Data: &messages.Message_LoginRequest{LoginRequest: &messages.LoginRequest{}}})

	return client
}

func (s *serverImpl) StartGame(gameId string) {
	s.logger.Debugw("game started. sending GameStart packet", "gameId", gameId)
	gStarts := make([]string, 0)
	for i := range s.games[gameId].Players {
		gStarts = append(gStarts, i)
	}
	game := s.games[gameId]
	game.PlayerCards = make(map[string][]Card)
	game.PlayerCardsArchive = make(map[string][]Card)
	game.Game = -2
	game.Stihi = make([][]Card, 0)
	game.Stihi = append(game.Stihi, make([]Card, 0))
	game.Starts = gStarts
	game.Talon = []Card{}
	game.PlayerGameModes = make(map[string]int32)
	game.Playing = append([]string{}, game.Starts...)
	game.CardsStarted = false
	game.Zarufal = false
	game.PlayingIn = ""
	game.Stashed = make([]Card, 0)
	game.SinceLastPrediction = 0
	s.games[gameId] = game
	s.logger.Debugw("game start", "stihi", game.Stihi, "playing", game.Playing, "starts", game.Starts)
	t := make([]*messages.User, 0)
	for i, k := range game.Starts {
		if len(game.Players[k]) == 0 {
			// aborting start
			return
		}
		v := game.Players[k][0]
		t = append(t, &messages.User{Name: v.GetUser().Name, Id: v.GetUserID(), Position: int32(i)})
	}
	msg := messages.Message{
		GameId: gameId,
		Data:   &messages.Message_GameStart{GameStart: &messages.GameStart{User: t}},
	}
	s.Broadcast("", &msg)

	// Shuffle
	cards := make([]consts.Card, 0)
	cards = append(cards, consts.CARDS...)
	rand.Shuffle(len(cards), func(i, j int) {
		cards[i], cards[j] = cards[j], cards[i]
	})
	for _, userId := range game.Starts {
		for i := 0; i < (54-6)/game.PlayersNeeded; i++ {
			for _, client := range game.Players[userId] {
				client.Send(&messages.Message{
					PlayerId: userId,
					Data: &messages.Message_Card{
						Card: &messages.Card{
							Id: cards[0].File,
							Type: &messages.Card_Receive{
								Receive: &messages.Receive{},
							},
						},
					},
				})
			}
			game.PlayerCards[userId] = append(game.PlayerCards[userId], Card{
				id:     cards[0].File,
				userId: userId,
			})
			cards = helpers.Remove(cards, 0)
		}
	}
	archive := make(map[string][]Card)
	for k, v := range game.PlayerCards {
		archive[k] = append(make([]Card, 0), v...)
	}
	game.PlayerCardsArchive = archive
	for i := 0; i < 6; i++ {
		game.Talon = append(game.Talon, Card{
			id: cards[0].File,
		})
		cards = helpers.Remove(cards, 0)
	}
	s.logger.Debugw("talon", "talon", game.Talon, "cards", game.PlayerCards)

	// game must be reinitialized after s.ShuffleCards(...)
	licitatesFirst := game.Players[game.Starts[0]]
	for _, v := range licitatesFirst {
		licitiranjeMsg := messages.Message{
			PlayerId: v.GetUserID(),
			GameId:   gameId,
			Data:     &messages.Message_LicitiranjeStart{LicitiranjeStart: &messages.LicitiranjeStart{}},
		}
		v.Send(&licitiranjeMsg)
	}
	game.Started = true
	s.games[gameId] = game
}

func (s *serverImpl) Authenticated(client Client) {
	gameId := client.GetGame()

	if _, exists := s.games[gameId]; !exists {
		s.logger.Debugw("connected game doesn't exist")
		return
	}

	id := client.GetUserID()
	user := client.GetUser()

	if len(s.games[gameId].Players) > s.games[gameId].PlayersNeeded {
		s.logger.Debugw("kicking authenticated user due to too many people in the game", "id", id, "gameId", gameId, "name", user.Name)
		return
	}

	s.logger.Debugw("successfully authenticated user", "id", id, "gameId", gameId, "name", user.Name)

	game := s.games[gameId]
	for userId := range game.Players {
		if userId == id {
			// client is already in the game, resending the game assets
			for _, c := range game.PlayerCards[id] {
				client.Send(&messages.Message{
					PlayerId: id,
					Data: &messages.Message_Card{
						Card: &messages.Card{
							Id: c.id,
							Type: &messages.Card_Receive{
								Receive: &messages.Receive{},
							},
						},
					},
				})
			}
		}
	}

	c, exists := game.Players[id]
	if !exists {
		c = make([]Client, 0)
	}
	c = append(c, client)
	s.games[gameId].Players[id] = c

	s.sendPlayers(client)

	if len(game.Players[id]) == 1 {
		// we only broadcast that the user exists
		// we don't broadcast if another client has connected
		s.Broadcast(client.GetUserID(), &messages.Message{
			GameId:   gameId,
			PlayerId: id,
			Username: user.Name,
			Data: &messages.Message_Connection{
				Connection: &messages.Connection{
					Rating: int32(user.Rating),
					Type:   &messages.Connection_Join{Join: &messages.Connect{}},
				},
			},
		})
	}

	// TODO: licitiranje fallback
	if game.Started {
		t := make([]*messages.User, 0)
		for i, k := range game.Starts {
			v := game.Players[k][0]
			t = append(t, &messages.User{Name: v.GetUser().Name, Id: v.GetUserID(), Position: int32(i)})
		}
		msg := messages.Message{
			GameId: gameId,
			Data:   &messages.Message_UserList{UserList: &messages.UserList{User: t}},
		}
		client.Send(&msg)
		w := game.WaitingFor
		if game.Starts[w] == id {
			client.Send(&messages.Message{GameId: gameId, PlayerId: id, Data: &messages.Message_Card{Card: &messages.Card{Type: &messages.Card_Request{Request: &messages.Request{}}}}})
		}
		for _, v := range game.Stihi[len(game.Stihi)-1] {
			client.Send(&messages.Message{GameId: gameId, PlayerId: v.userId, Data: &messages.Message_Card{Card: &messages.Card{Id: v.id, Type: &messages.Card_Send{Send: &messages.Send{}}}}})
		}
	}

	if len(s.games[gameId].Players) == s.games[gameId].PlayersNeeded && !s.games[gameId].Started {
		// začnimo igro
		s.logger.Debugw("starting game", "gameId", gameId)
		start := time.Now()
		done := false
		for {
			select {
			case <-s.games[gameId].cancel:
				s.logger.Debugw("cancelling game start", "gameId", gameId)
				return
			default:
				if s.games[gameId].Started {
					return
				}
				if time.Now().Sub(start).Seconds() > 10 {
					s.StartGame(gameId)
					done = true
					break
				}
			}
			if done {
				break
			}
		}
		s.logger.Debugw("successfully started the game", "gameId", gameId)
	}
}

func (s *serverImpl) ShuffleCards(gameId string) {

}

func (s *serverImpl) KingCalling(gameId string) {
	game := s.games[gameId]
	playing := game.Playing[0]
	broadcast := &messages.Message{PlayerId: playing, GameId: gameId, Data: &messages.Message_KingSelection{KingSelection: &messages.KingSelection{Type: &messages.KingSelection_Notification{Notification: &messages.Notification{}}}}}
	s.Broadcast("", broadcast)
	prompt := &messages.Message{PlayerId: playing, GameId: gameId, Data: &messages.Message_KingSelection{KingSelection: &messages.KingSelection{Type: &messages.KingSelection_Request{Request: &messages.Request{}}}}}
	for _, v := range game.Players[playing] {
		v.Send(prompt)
	}
}

func (s *serverImpl) KingCalled(userId string, gameId string, cardId string) {
	game := s.games[gameId]
	playing := game.Playing[0]
	if userId != playing {
		s.logger.Warnw("modified client detected", "userId", userId)
		return
	}
	id := helpers.ParseCardID(cardId)
	if id.Name != "kralj" {
		return
	}
	if !helpers.Contains([]string{"kara", "kriz", "pik", "src"}, id.Type) {
		return
	}

	game.PlayingIn = cardId

	found := false
	for i, v := range game.PlayerCards {
		if i == userId {
			// če je sam, je pač sam
			continue
		}
		for _, c := range v {
			if c.id != cardId {
				continue
			}
			game.Playing = append(game.Playing, i)
			found = true
			break
		}
		if found {
			break
		}
	}
	if !found {
		// lepo :)
		game.Zarufal = true
	}

	s.games[gameId] = game
	broadcast := &messages.Message{PlayerId: playing, GameId: gameId, Data: &messages.Message_KingSelection{KingSelection: &messages.KingSelection{Card: cardId, Type: &messages.KingSelection_Send{Send: &messages.Send{}}}}}
	s.Broadcast("", broadcast)
	s.Talon(gameId)
}

func (s *serverImpl) Talon(gameId string) {
	game := s.games[gameId]
	playing := game.Playing[0]
	kart := 0
	if game.Game == 0 || game.Game == 3 {
		kart = 3
	} else if game.Game == 1 || game.Game == 4 {
		kart = 2
	} else if game.Game == 2 || game.Game == 5 {
		kart = 1
	} else {
		// talon se sploh ne prikaže, preskočimo ta del
		s.FirstCard(gameId)
		return
	}
	decks := make([]*messages.Stih, 0)
	deck := make([]*messages.Card, 0)
	for _, v := range game.Talon {
		deck = append(deck, &messages.Card{Id: v.id})
		if len(deck) == kart {
			decks = append(decks, &messages.Stih{Card: deck})
			deck = make([]*messages.Card, 0)
		}
	}
	broadcast := messages.Message{PlayerId: playing, GameId: gameId, Data: &messages.Message_TalonReveal{TalonReveal: &messages.TalonReveal{Stih: decks}}}
	s.Broadcast("", &broadcast)
	prompt := messages.Message{PlayerId: playing, GameId: gameId, Data: &messages.Message_TalonSelection{TalonSelection: &messages.TalonSelection{Type: &messages.TalonSelection_Request{Request: &messages.Request{}}}}}
	for _, v := range game.Players[playing] {
		v.Send(&prompt)
	}
}

// TODO: preveri, da slučajno ne izbere 2x in si zagotovi 2x več kart
func (s *serverImpl) TalonSelected(userId string, gameId string, part int32) {
	game := s.games[gameId]
	playing := game.Playing[0]
	if userId != playing {
		s.logger.Warnw("modified client detected", "userId", userId)
		return
	}
	decks := make([][]Card, 0)
	decks = append(decks, make([]Card, 0))
	kart := 0
	if game.Game == 0 || game.Game == 3 {
		kart = 3
	} else if game.Game == 1 || game.Game == 4 {
		kart = 2
	} else if game.Game == 2 || game.Game == 5 {
		kart = 1
	} else {
		// talon se sploh ne prikaže, preskočimo ta del
		return
	}
	for _, v := range game.Talon {
		l := len(decks) - 1
		decks[l] = append(decks[l], v)
		if len(decks[l]) == kart {
			decks = append(decks, make([]Card, 0))
		}
	}

	if int32(len(decks)) <= part {
		return
	}

	talon := decks[part]

	broadcast := &messages.Message{PlayerId: playing, GameId: gameId, Data: &messages.Message_TalonSelection{TalonSelection: &messages.TalonSelection{Part: part, Type: &messages.TalonSelection_Send{Send: &messages.Send{}}}}}
	s.Broadcast("", broadcast)

	// pošljemo nove karte igralcu
	for _, c := range talon {
		for i, v := range game.Talon {
			if v.id != c.id {
				continue
			}
			game.Talon = helpers.Remove(game.Talon, i)
		}
		for _, v := range game.Players[playing] {
			v.Send(&messages.Message{PlayerId: playing, GameId: gameId, Data: &messages.Message_Card{Card: &messages.Card{Id: c.id, Type: &messages.Card_Receive{Receive: &messages.Receive{}}}}})
		}
		game.PlayerCards[userId] = append(game.PlayerCards[userId], c)
		game.PlayerCardsArchive[userId] = append(game.PlayerCardsArchive[userId], c)
	}

	s.games[gameId] = game
	s.Stash(gameId)
}

func (s *serverImpl) Stash(gameId string) {
	game := s.games[gameId]
	playing := game.Playing[0]
	kart := 0
	if game.Game == 0 || game.Game == 3 {
		kart = 3
	} else if game.Game == 1 || game.Game == 4 {
		kart = 2
	} else if game.Game == 2 || game.Game == 5 {
		kart = 1
	} else {
		// talon se sploh ne prikaže, preskočimo ta del
		return
	}
	prompt := messages.Message{PlayerId: playing, GameId: gameId, Data: &messages.Message_Stash{Stash: &messages.Stash{Length: int32(kart), Type: &messages.Stash_Request{Request: &messages.Request{}}}}}
	for _, v := range game.Players[playing] {
		v.Send(&prompt)
	}
}

func (s *serverImpl) StashedCards(userId string, gameId string, cards []*messages.Card) {
	game := s.games[gameId]
	game.Stashed = make([]Card, 0)
	playing := game.Playing[0]
	if userId != playing {
		s.logger.Warnw("modified client detected", "userId", userId)
		return
	}
	kart := 0
	if game.Game == 0 || game.Game == 3 {
		kart = 3
	} else if game.Game == 1 || game.Game == 4 {
		kart = 2
	} else if game.Game == 2 || game.Game == 5 {
		kart = 1
	} else {
		// talon se sploh ne prikaže, preskočimo ta del
		return
	}
	t := 0
	for _, card := range cards {
		for _, c := range game.PlayerCards[userId] {
			if c.id != card.Id {
				continue
			}
			t++
		}
	}
	if t != kart {
		// illegal client
		return
	}
	for _, card := range cards {
		for k, c := range game.PlayerCards[userId] {
			if c.id != card.Id {
				continue
			}
			game.Stashed = append(game.Stashed, c)
			game.PlayerCards[userId] = helpers.Remove(game.PlayerCards[userId], k)
			break
		}
	}

	game.PlayerCardsArchive[userId] = make([]Card, 0)
	game.PlayerCardsArchive[userId] = append(game.PlayerCardsArchive[userId], game.PlayerCards[userId]...)

	s.games[gameId] = game
	time.Sleep(3 * time.Second)
	s.FirstPrediction(gameId)
}

func (s *serverImpl) FirstCard(gameId string) {
	game := s.games[gameId]
	msg := messages.Message{
		PlayerId: game.Starts[0],
		GameId:   gameId,
		Data:     &messages.Message_Card{Card: &messages.Card{Type: &messages.Card_Request{Request: &messages.Request{}}}},
	}
	for _, v := range game.Players[game.Starts[0]] {
		v.Send(&msg)
	}
}

func (s *serverImpl) HasPagat(gameId string, userId string) bool {
	game := s.games[gameId]
	for _, v := range game.PlayerCards[userId] {
		if v.id == "/taroki/pagat" {
			return true
		}
	}
	return false
}

func (s *serverImpl) HasKing(gameId string, userId string) bool {
	game := s.games[gameId]
	for _, v := range game.PlayerCards[userId] {
		if v.id == game.PlayingIn {
			return true
		}
	}
	return false
}

func (s *serverImpl) FirstPrediction(gameId string) {
	game := s.games[gameId]
	playing := game.Playing[0]
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
		Gamemode:             game.Game,
		Changed:              false,
	}
	broadcast := &messages.Message{PlayerId: playing, GameId: gameId, Data: &messages.Message_Predictions{Predictions: game.CurrentPredictions}}
	s.Broadcast("", broadcast)
	for _, c := range game.Players[playing] {
		c.Send(&messages.Message{PlayerId: playing, GameId: gameId, Data: &messages.Message_StartPredictions{StartPredictions: &messages.StartPredictions{
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
	s.games[gameId] = game
}

// na trulo & kralje se (verjetno) ne daje kontre
// pri truli in kraljih velja pravilo kdor prvi pride prvi melje
// lahko ju napove kdorkoli
// ultime lahko napovesta samo igralca
func (s *serverImpl) Predictions(userId string, gameId string, predictions *messages.Predictions) {
	game := s.games[gameId]
	playing := game.Playing[0]

	s.logger.Debugw("predictions", "p", predictions)

	// ne moreš na novo napovedati
	if predictions.BarvniValat != nil && game.CurrentPredictions.BarvniValat != nil && predictions.BarvniValat.Id != game.CurrentPredictions.BarvniValat.Id {
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
	if predictions.PagatUltimo != nil && !(s.HasPagat(gameId, predictions.PagatUltimo.Id) && helpers.Contains(game.Playing, predictions.PagatUltimo.Id)) {
		s.logger.Debugw("prediction rule wasn't satisfied")
		return
	}

	// ne moreš na novo napovedati
	if predictions.KraljUltimo != nil && game.CurrentPredictions.KraljUltimo != nil && predictions.KraljUltimo.Id != game.CurrentPredictions.KraljUltimo.Id {
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
	if predictions.KraljUltimo != nil && !(s.HasKing(gameId, predictions.KraljUltimo.Id) && helpers.Contains(game.Playing, predictions.KraljUltimo.Id)) {
		s.logger.Debugw("prediction rule wasn't satisfied", "king", game.PlayingIn)
		return
	}

	if predictions.BarvniValatKontra != 0 {
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
	}

	if predictions.Gamemode != game.CurrentPredictions.Gamemode {
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

	game.CurrentPredictions = predictions
	s.games[gameId] = game

	broadcast := &messages.Message{PlayerId: playing, GameId: gameId, Data: &messages.Message_Predictions{Predictions: predictions}}
	s.Broadcast("", broadcast)

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
	for _, c := range game.Players[newId] {
		p := helpers.Contains(game.Playing, newId)
		c.Send(&messages.Message{PlayerId: newId, GameId: gameId, Data: &messages.Message_StartPredictions{StartPredictions: &messages.StartPredictions{
			KraljUltimoKontra: kralj && predictions.KraljUltimo != nil && predictions.KraljUltimoKontra < 4,
			PagatUltimoKontra: pagat && predictions.PagatUltimo != nil && predictions.PagatUltimoKontra < 4,
			IgraKontra:        igra && predictions.IgraKontra < 4,
			ValatKontra:       valat && predictions.Valat != nil && predictions.ValatKontra < 4,
			BarvniValatKontra: barvic && predictions.BarvniValat != nil && predictions.BarvniValatKontra < 4,
			PagatUltimo:       s.HasPagat(gameId, newId) && predictions.PagatUltimo == nil && p,
			Trula:             trula,
			Kralji:            kralji,
			KraljUltimo:       s.HasKing(gameId, newId) && predictions.KraljUltimo == nil && p,
			Valat:             playing == newId && predictions.Valat == nil,
			BarvniValat:       playing == newId && predictions.BarvniValat == nil,
		}}})
	}
}

// TODO: fix user checking
func (s *serverImpl) Licitiranje(tip int32, gameId string, userId string) {
	game := s.games[gameId]

	if tip != -1 && (tip > game.Game || (tip >= game.Game && game.Starts[len(game.Starts)-1] == userId)) {
		game.PlayerGameModes[userId] = tip
		game.Game = tip
		playing := game.Playing[0]
		game.Playing = helpers.RemoveOrdered(game.Playing, 0)
		game.Playing = append(game.Playing, playing)
	} else {
		if tip == -1 && tip > game.Game {
			game.Game = tip
		}
		game.PlayerGameModes[userId] = -1
		game.Playing = helpers.RemoveOrdered(game.Playing, 0)
	}

	s.logger.Debugw("licitiranje", "playing", game.Playing, "tip", tip, "userId", userId, "starts", game.Starts)

	s.Broadcast("", &messages.Message{
		PlayerId: userId,
		GameId:   gameId,
		Data: &messages.Message_Licitiranje{
			Licitiranje: &messages.Licitiranje{
				Type: tip,
			},
		},
	})

	s.games[gameId] = game

	canStart := true
	for _, v := range game.Starts {
		_, exists := game.PlayerGameModes[v]
		if !exists {
			canStart = false
		}
	}

	if canStart && len(game.Playing) == 1 {
		// konc smo z licitiranjem, objavimo zadnje rezultate
		// in začnimo metat karte
		s.logger.Debugw("done with licitating, now starting playing the game", "gameId", gameId)
		if game.PlayersNeeded == 4 {
			// rufanje kralja
			s.KingCalling(gameId)
		} else {
			s.Talon(gameId)
		}
		game = s.games[gameId]
		game.CardsStarted = true
		s.games[gameId] = game
	} else if !canStart || len(game.Playing) > 1 {
		playing := game.Playing[0]
		for _, v := range game.Players[playing] {
			licitiranjeMsg := messages.Message{
				PlayerId: v.GetUserID(),
				GameId:   gameId,
				Data:     &messages.Message_LicitiranjeStart{LicitiranjeStart: &messages.LicitiranjeStart{}},
			}
			v.Send(&licitiranjeMsg)
		}
	} else {
		// TODO: implementiraj klopa
		// igramo klopa
	}
}

func (s *serverImpl) returnCardToSender(id string, gameId string, userId string, clientId string) {
	game := s.games[gameId]
	for _, v := range game.Players[userId] {
		if v.GetClientID() != clientId {
			continue
		}
		v.Send(&messages.Message{
			PlayerId: userId,
			Data: &messages.Message_Card{
				Card: &messages.Card{
					Id: id,
					Type: &messages.Card_Receive{
						Receive: &messages.Receive{},
					},
				},
			},
		})
		v.Send(&messages.Message{
			PlayerId: userId,
			GameId:   gameId,
			Data:     &messages.Message_Card{Card: &messages.Card{Type: &messages.Card_Request{Request: &messages.Request{}}}},
		})
		return
	}
}

func (s *serverImpl) PlayingPicksUp(gameId string, stih []Card) bool {
	game := s.games[gameId]
	max := stih[0].id
	for _, v := range stih {
		c1 := consts.Card{}
		c2 := consts.Card{}
		for _, v2 := range consts.CARDS {
			if v2.File == v.id {
				c1 = v2
			}
			if v2.File == max {
				c2 = v2
			}
		}
		id1 := helpers.ParseCardID(c1.File)
		id2 := helpers.ParseCardID(c1.File)
		// položena karta mora biti:
		// 1. tarok
		// 2. istega tipa (da če je oseba brez tarokov, slučajno ne pobere platelce druge barve)
		if c1.WorthOver > c2.WorthOver && (id1.Type == "taroki" || (id1.Type == id2.Type)) {
			max = v.id
		}
	}

	for user := range game.Players {
		for _, v := range game.PlayerCardsArchive[user] {
			if v.id != max {
				continue
			}
			pobral := helpers.Contains(game.Playing, user)
			s.logger.Debugw("štih", "max", max, "playing", game.Playing, "user", user, "stih", stih, "pickedUp", pobral)
			return pobral
		}
	}

	return false
}

func (s *serverImpl) CardDrop(id string, gameId string, userId string, clientId string) {
	game := s.games[gameId]
	if !game.CardsStarted {
		// dumbo, pls wait for the game to actually start
		s.returnCardToSender(id, gameId, userId, clientId)
		return
	}

	// TODO: check user queue
	placedCard := helpers.ParseCardID(id)
	zadnjiStih := game.Stihi[len(game.Stihi)-1]
	if len(zadnjiStih) != 0 {
		s.logger.Debugw("cards", "cards", game.PlayerCards[userId], "len", len(game.PlayerCards[userId]))
		card := helpers.ParseCardID(zadnjiStih[0].id)
		imaTarok := false
		imaBarvo := false
		imaKarto := false
		for _, v := range game.PlayerCards[userId] {
			t := helpers.ParseCardID(v.id)
			if t.Full == id {
				imaKarto = true
			}
			if t.Type == "taroki" {
				imaTarok = true
			} else if t.Type == card.Type {
				imaBarvo = true
			}
			if imaTarok && imaBarvo && imaKarto {
				break
			}
		}
		s.logger.Debugw("player cards", "userId", userId, "cardId", id)
		if !imaKarto {
			s.logger.Warnw("the player shall be removed from this game for using cheats", "gameId", gameId, "userId", userId, "cards", game.PlayerCards, "starts", game.Starts)
			for _, v := range game.PlayerCards[userId] {
				s.logger.Warnw("cheating cards", "card", v)
			}
			return
		}
		if imaBarvo && placedCard.Type != card.Type {
			s.returnCardToSender(id, gameId, userId, clientId)
			return
		} else if !imaBarvo && imaTarok && placedCard.Type != "taroki" {
			s.returnCardToSender(id, gameId, userId, clientId)
			return
		}
	} else {
		// TODO: preveri če ma uporabnik sploh karto
	}
	zadnjiStih = append(zadnjiStih, Card{
		id:     id,
		userId: userId,
	})
	game.Stihi[len(game.Stihi)-1] = zadnjiStih
	for i, v := range game.PlayerCards[userId] {
		if v.id == id {
			game.PlayerCards[userId] = helpers.Remove(game.PlayerCards[userId], i)
			break
		}
	}
	s.Broadcast("", &messages.Message{
		PlayerId: userId,
		GameId:   gameId,
		Data: &messages.Message_Card{
			Card: &messages.Card{
				Id: id,
				Type: &messages.Card_Send{
					Send: &messages.Send{},
				},
			},
		},
	})
	// obvestimo še naslednjega igralca, da naj vrže karto
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
	game.WaitingFor = currentPlayer

	s.logger.Debugw(
		"trenutni igralec",
		"p", currentPlayer,
		"stih", zadnjiStih,
		"len", len(game.Stihi),
		"cards", game.PlayerCards[userId],
		"allCards", game.PlayerCards,
		"needed", game.PlayersNeeded,
	)
	if len(zadnjiStih) >= game.PlayersNeeded {
		game.Stihi = append(game.Stihi, []Card{})
		t := time.Now()
		for {
			if time.Now().Sub(t).Seconds() > 1 {
				s.logger.Debugw("pucam štihe")
				s.Broadcast("", &messages.Message{
					PlayerId: userId,
					GameId:   gameId,
					Data: &messages.Message_ClearDesk{
						ClearDesk: &messages.ClearDesk{},
					},
				})
				break
			}
		}
	}
	if len(zadnjiStih) >= game.PlayersNeeded {
		max := zadnjiStih[0].id
		for _, v := range zadnjiStih {
			c1 := consts.Card{}
			c2 := consts.Card{}
			for _, v2 := range consts.CARDS {
				if v2.File == v.id {
					c1 = v2
				}
				if v2.File == max {
					c2 = v2
				}
			}
			if c1.WorthOver > c2.WorthOver {
				max = v.id
			}
		}
		for _, v := range zadnjiStih {
			if v.id != max {
				continue
			}
			for i, client := range game.Players[v.userId] {
				game.WaitingFor = i
				client.Send(&messages.Message{
					PlayerId: userId,
					GameId:   gameId,
					Data:     &messages.Message_Card{Card: &messages.Card{Type: &messages.Card_Request{Request: &messages.Request{}}}},
				})
			}
		}
	} else {
		for _, client := range game.Players[game.Starts[currentPlayer]] {
			client.Send(&messages.Message{
				PlayerId: userId,
				GameId:   gameId,
				Data:     &messages.Message_Card{Card: &messages.Card{Type: &messages.Card_Request{Request: &messages.Request{}}}},
			})
		}
	}

	s.games[gameId] = game

	if len(zadnjiStih) >= game.PlayersNeeded && len(game.Stihi) > (54-6)/game.PlayersNeeded {
		// pogledamo, če je zadnji štih, da proglasimo rezultate
		totalPlaying := 0
		totalNotPlaying := 0
		playing := 0
		playingCount := 0
		notPlaying := 0
		notPlayingCount := 0

		// TODO: po možnosti naredi, da nasprotnik ne more dati napovedi v imenu drugih
		// TODO: mondfang
		// PAGAT ULTIMO
		pobral := s.PlayingPicksUp(gameId, zadnjiStih)
		pagat := 0
		pagatPresent := false
		narejen := true
		for _, c := range zadnjiStih {
			if c.id == "/taroki/pagat" {
				pagatPresent = true
				continue
			}
			parse := helpers.ParseCardID(c.id)
			if parse.Type == "taroki" && parse.Name != "pagat" {
				narejen = false
			}
		}
		if pagatPresent || game.CurrentPredictions.PagatUltimo != nil {
			if pagatPresent && narejen {
				if pobral {
					// igralec pobere s pagatom
					pagat = 25
				} else {
					// nasprotnik pobere s pagatom
					pagat = -25
				}
			} else if pagatPresent {
				// pagat je v zadnjem štihu, ampak ga je pobrala druga karta
				pagataDal := ""
				for _, v := range zadnjiStih {
					if v.id == "/taroki/pagat" {
						pagataDal = v.userId
						break
					}
				}
				dal := helpers.Contains(game.Playing, pagataDal)
				if dal {
					// pagata je vrgel igralec (ne nujno napovedanega), posledično se jima piše dol
					pagat = -25
				} else {
					// pagata je vrgel nasprotnik (ne nujno napovedanega), posledično se igralcema piše gor
					pagat = 25
				}
			} else {
				// pagat ni v zadnjem štihu, posledično to ni ultimo
				napovedalIgralec := helpers.Contains(game.Playing, game.CurrentPredictions.PagatUltimo.Id)
				if napovedalIgralec {
					// pagata je napovedal igralec, posledično se piše dol
					pagat = -25
				} else {
					// pagata je napovedal nasprotnik, posledično se piše gor
					pagat = 25
				}
			}
		}
		if game.CurrentPredictions.PagatUltimo != nil {
			pagat *= 2
		}
		pagat *= helpers.PowInts(2, int(game.CurrentPredictions.PagatUltimoKontra))

		// KRALJ ULTIMO
		kralj := 0
		kraljPresent := false
		narejen = s.PlayingPicksUp(gameId, zadnjiStih)
		for _, c := range zadnjiStih {
			if c.id == game.PlayingIn {
				kraljPresent = true
				break
			}
		}
		if kraljPresent || game.CurrentPredictions.KraljUltimo != nil {
			if kraljPresent && narejen {
				// kralj je v zadnjem štihu in ga je igralec pobral
				kralj = 10
			} else {
				// 1. kralj ni v zadnjem štihu, posledično tudi ni narejen
				// 2. kralj ni v je v zadnjem štihu, ampak ni narejen
				kralj = -10
			}
		}
		if game.CurrentPredictions.KraljUltimo != nil {
			kralj *= 2
		}
		kralj *= helpers.PowInts(2, int(game.CurrentPredictions.KraljUltimoKontra))

		// KRALJI IN TRULA
		// ne rabimo še dodati založenih kart in talona, saj to tako ali tako ne vpliva, ker si teh kart ne moreš založiti
		kraljev := 0
		trulaTarokov := 0
		kralji := 0
		trula := 0
		for _, stih := range game.Stihi {
			if len(stih) == 0 {
				continue
			}
			pobran := s.PlayingPicksUp(gameId, stih)
			for _, c := range stih {
				if c.id == "/taroki/pagat" || c.id == "/taroki/mond" || c.id == "/taroki/skis" {
					if pobran {
						trulaTarokov++
					} else {
						trulaTarokov--
					}
				} else if c.id == "/kara/kralj" || c.id == "/pik/kralj" || c.id == "/kriz/kralj" || c.id == "/src/kralj" {
					if pobran {
						kraljev++
					} else {
						kraljev--
					}
				}
			}
		}
		if helpers.Abs(kraljev) == 4 {
			if kraljev < 0 {
				kralji = -10
			} else {
				kralji = 10
			}
		} else if game.CurrentPredictions.Kralji != nil {
			playing := helpers.Contains(game.Playing, game.CurrentPredictions.Kralji.Id)
			if playing {
				kralji = -10
			} else {
				kralji = 10
			}
		}
		if helpers.Abs(trulaTarokov) == 3 {
			if trulaTarokov < 0 {
				trula = -10
			} else {
				trula = 10
			}
		} else if game.CurrentPredictions.Trula != nil {
			playing := helpers.Contains(game.Playing, game.CurrentPredictions.Trula.Id)
			if playing {
				trula = -10
			} else {
				trula = 10
			}
		}
		if game.CurrentPredictions.Trula != nil {
			trula *= 2
		}
		if game.CurrentPredictions.Kralji != nil {
			kralji *= 2
		}

		notPlayingUser := ""
		for _, p := range game.Starts {
			if helpers.Contains(game.Playing, p) {
				continue
			}
			notPlayingUser = p
			break
		}

		s.logger.Debug("counting points")

		for k := range game.Talon {
			game.Talon[k].userId = notPlayingUser
		}
		for k := range game.Stashed {
			game.Talon[k].userId = game.Playing[0]
		}
		game.Stihi = append(game.Stihi, game.Talon)
		game.Stihi = append(game.Stihi, game.Stashed)
		for _, stih := range game.Stihi {
			if len(stih) == 0 {
				s.logger.Debugw("skipping empty deck")
				continue
			}

			for _, v := range stih {
				for _, v2 := range consts.CARDS {
					if v2.File != v.id {
						continue
					}
					if s.PlayingPicksUp(gameId, stih) {
						playing += v2.Worth
						playingCount++
					} else {
						notPlaying += v2.Worth
						notPlayingCount++
					}
					if notPlayingCount == 3 {
						totalNotPlaying += notPlaying - (notPlayingCount - 1)
						notPlaying = 0
						notPlayingCount = 0
					}
					if playingCount == 3 {
						totalPlaying += playing - (playingCount - 1)
						playing = 0
						playingCount = 0
					}
					break
				}
			}
		}
		// še zadnje preostale karte v štetju
		if notPlayingCount != 0 {
			totalNotPlaying += notPlaying - (notPlayingCount - 1)
			notPlaying = 0
			notPlayingCount = 0
		}

		if playingCount != 0 {
			totalPlaying += playing - (playingCount - 1)
			playing = 0
			playingCount = 0
		}

		s.logger.Debugw("results", "notPlaying", notPlaying, "playing", playing, "stihi", len(game.Stihi), "talon", game.Talon, "stashed", game.Stashed)

		users := make([]*messages.ResultsUser, 0)

		for user, clients := range game.Players {
			client := clients[0].GetUser()
			p := helpers.Contains(game.Playing, user)
			s.logger.Debugw("playing", "playing", game.Playing, "user", user, "client", client, "p", p, "playing", p)
			points := 0
			worth := 0
			diff := 0
			if p {
				for _, v := range consts.GAMES {
					if v.ID == game.Game {
						worth = v.Worth
						break
					}
				}
				worth *= helpers.PowInts(2, int(game.CurrentPredictions.IgraKontra))
				diff = totalPlaying - 35
				diff *= helpers.PowInts(2, int(game.CurrentPredictions.IgraKontra))
				points = diff
				if points <= 0 {
					worth = -worth
				}
				points += worth
				points += kralji
				points += kralj
				points += trula
				points += pagat
			} else {
				points = totalNotPlaying - 35
			}
			user := &messages.ResultsUser{
				User: &messages.User{
					Id:   client.ID,
					Name: client.Name,
				},
				Points:      int32(points),
				Playing:     p,
				Trula:       int32(trula),
				Pagat:       int32(pagat),
				Igra:        int32(worth),
				Kralj:       int32(kralj),
				Kralji:      int32(kralji),
				KontraPagat: game.CurrentPredictions.PagatUltimoKontra,
				KontraIgra:  game.CurrentPredictions.IgraKontra,
				KontraKralj: game.CurrentPredictions.KraljUltimoKontra,
			}
			if p {
				user.Razlika = int32(diff)
			} else {
				user.Razlika = int32(diff)
			}
			users = append(users, user)
		}

		s.Broadcast("", &messages.Message{
			GameId: gameId,
			Data:   &messages.Message_Results{Results: &messages.Results{User: users}},
		})

		time.Sleep(10 * time.Second)
		s.StartGame(gameId)
	}
}

func (s *serverImpl) GetDB() sql.SQL {
	return s.db
}

func (s *serverImpl) NewGame(players int) string {
	UUID := uuid.NewString()
	s.games[UUID] = Game{
		PlayersNeeded:   players,
		Players:         make(map[string][]Client),
		cancel:          make(chan bool),
		Started:         false,
		Game:            -1,
		Playing:         make([]string, 0),
		Stihi:           [][]Card{{}},
		Talon:           []Card{},
		PlayerCards:     make(map[string][]Card),
		WaitingFor:      0,
		PlayerGameModes: make(map[string]int32),
		CardsStarted:    false,
	}
	return UUID
}

func (s *serverImpl) GetGames() []string {
	games := make([]string, 0)
	for v := range s.games {
		games = append(games, v)
	}
	return games
}

func (s *serverImpl) GetMatch(players int, user sql.User) string {
	for k, v := range s.games {
		s.logger.Debugw("match", "key", k, "playersNeeded", v.PlayersNeeded, "players", players, "playerMap", v.Players, "playerMapLen", len(v.Players))
		if players != v.PlayersNeeded {
			continue
		}

		containsPlayer := false
		for i := range v.Players {
			if i == user.ID {
				containsPlayer = true
				break
			}
		}

		if containsPlayer {
			return k
		}

		if v.PlayersNeeded > len(v.Players) {
			return k
		}
	}
	return "CREATE"
}

// Disconnect gives Run the data to disconnect client from the server
func (s *serverImpl) Disconnect(client Client) {
	s.disconnect <- client
}

func (s *serverImpl) handleDisconnect() {
	err := events.Subscribe("server.disconnect", s.Disconnect)
	if err != nil {
		s.logger.Warnw("cannot read from the client")
	}
}

func (s *serverImpl) Broadcast(excludeClient string, msg *messages.Message) {
	s.broadcast <- broadcastMessage{msg: msg, excludeClient: excludeClient}
}

func (s *serverImpl) handleBroadcast() {
	err := events.Subscribe("server.broadcast", s.Broadcast)
	if err != nil {
		s.logger.Warnw("cannot read from the client")
	}
}

func (s *serverImpl) sendPlayers(client Client) {
	s.logger.Debugw("sending client existing player list", "id", client.GetUserID())
	sent := make([]string, 0)

	for _, clients := range s.games[client.GetGame()].Players {
		if len(clients) == 0 {
			continue
		}
		user := clients[0].GetUser()

		if client.GetUserID() == user.ID {
			continue
		}

		if helpers.Contains(sent, user.ID) {
			// ne rabmo pošiljat če se je prjavu z dvema napravama
			continue
		}
		sent = append(sent, user.ID)

		msg := &messages.Message{
			PlayerId: user.ID,
			Username: user.Name,
			Data: &messages.Message_Connection{
				Connection: &messages.Connection{
					Rating: int32(user.Rating),
					Type:   &messages.Connection_Join{Join: &messages.Connect{}},
				},
			},
		}

		client.Send(msg)
	}
}
