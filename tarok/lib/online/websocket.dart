import 'dart:developer';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Image;
import 'package:tarok/constants.dart';
import 'package:tarok/game/cardutils.dart';
import 'package:tarok/game/premoves.dart';
import 'package:tarok/game/usertimer.dart';
import 'package:tarok/game/utils.dart';
import 'package:tarok/game/variables.dart';
import 'package:tarok/offline/offline.dart';
import 'package:tarok/offline/utils.dart';
import 'package:tarok/sounds.dart';
import 'package:tarok/stockskis_compatibility/interfaces/predictions.dart';
import 'package:tarok/stockskis_compatibility/interfaces/results.dart';
import 'package:web_socket_client/web_socket_client.dart';
import 'package:tarok/messages.pb.dart';
import 'package:stockskis/stockskis.dart' as stockskis;

class WS {
  WS({required this.setState});

  late final WebSocket socket;
  late final OfflineGame offline;

  final Function setState;

  void init() {
    offline = OfflineGame(setState: setState);
  }

  void connect(String gameId) {
    const timeout = Duration(seconds: 10);
    final uri = Uri.parse('$WS_URL/$gameId');
    debugPrint("requesting to $uri");
    socket = WebSocket(
      uri,
      binaryType: "arraybuffer",
      timeout: timeout,
    );
  }

  Future<void> login() async {
    final token = await storage.read(key: "token");
    final Uint8List message =
        Message(loginInfo: LoginInfo(token: token)).writeToBuffer();
    socket.send(message);
  }

  Future<void> gameEndSend() async {
    debugPrint("Called gameEndSend");
    if (bots) return;
    debugPrint("Sending the GameEnd packet");
    requestedGameEnd = true;
    final Uint8List message =
        Message(gameEnd: GameEnd(request: Request())).writeToBuffer();
    socket.send(message);
    debugPrint("Sent the GameEnd packet");
  }

  Future<void> sendMessageString(String m) async {
    if (bots) return;
    final Uint8List message = Message(
      chatMessage: ChatMessage(
        userId: playerId,
        message: m,
      ),
    ).writeToBuffer();
    socket.send(message);
  }

  Future<void> sendMessage() async {
    if (bots) return;
    final Uint8List message = Message(
      chatMessage: ChatMessage(
        userId: playerId,
        message: controller.text,
      ),
    ).writeToBuffer();
    socket.send(message);
    controller.text = "";
    setState(() {});
  }

  Future<void> stashCard(stockskis.LocalCard card) async {
    debugPrint("Klicana funkcija stashCard");
    if (card.worth == 5) return; // ne mormo si založit kraljev in trule
    stashedCards.add(card);
    cards.remove(card);
    if (stashedCards.length == stashAmount) {
      turn = false;
    }
    setState(() {});
    debugPrint(
      "stashedCards.length=${stashedCards.length}, stashAmount=$stashAmount",
    );
    await stashEnd(AVTOPOTRDI_ZALOZITEV);
    setState(() {});
  }

  Future<void> predict() async {
    if (currentPredictions == null) return;
    if (trula) {
      currentPredictions!.trula = User(id: playerId, name: name);
    }
    if (kralji) {
      currentPredictions!.kralji = User(id: playerId, name: name);
    }
    if (kraljUltimo) {
      currentPredictions!.kraljUltimo = User(id: playerId, name: name);
    }
    if (pagatUltimo) {
      currentPredictions!.pagatUltimo = User(id: playerId, name: name);
    }
    if (valat) {
      currentPredictions!.valat = User(id: playerId, name: name);
    }
    if (barvic) {
      currentPredictions!.barvniValat = User(id: playerId, name: name);
    }
    if (mondfang) {
      currentPredictions!.mondfang = User(id: playerId, name: name);
    }

    // kontre dal
    if (kontraKralj) {
      currentPredictions!.kraljUltimoKontraDal = User(id: playerId, name: name);
    }
    if (kontraPagat) {
      currentPredictions!.pagatUltimoKontraDal = User(id: playerId, name: name);
    }
    if (kontraIgra) {
      currentPredictions!.igraKontraDal = User(id: playerId, name: name);
    }
    if (kontraMondfang) {
      currentPredictions!.mondfangKontraDal = User(id: playerId, name: name);
    }

    currentPredictions!.changed = kontraMondfang ||
        kontraIgra ||
        kontraPagat ||
        kontraKralj ||
        trula ||
        kralji ||
        valat ||
        barvic ||
        pagatUltimo ||
        kraljUltimo ||
        mondfang;

    if (bots) {
      if (currentPredictions!.changed) sinceLastPrediction = 1;
      resetPredictions();
      currentPredictions!.changed = false;
      stockskisContext!.predictions =
          PredictionsCompLayer.messagesToStockSkis(currentPredictions!);
      myPredictions = null;
      setState(() {});
      await offline.predict(afterPlayer());
      return;
    }

    final Uint8List message =
        Message(predictions: currentPredictions!).writeToBuffer();
    socket.send(message);
    startPredicting = false;
    myPredictions = null;
  }

  Future<void> stashEnd(bool zalozitevPotrjena) async {
    if (stashedCards.length == stashAmount && zalozitevPotrjena) {
      if (bots) {
        for (int i = 0; i < stashedCards.length; i++) {
          for (int n = 0;
              n < stockskisContext!.users["player"]!.cards.length;
              n++) {
            final card = stockskisContext!.users["player"]!.cards[n];
            if (card.card.asset != stashedCards[i].asset) continue;
            stockskisContext!.stihi[0].add(card);
            stockskisContext!.users["player"]!.cards.removeAt(n);
            break;
          }
        }
        stockskisContext!.stihi.add([]);
        stash = false;
        turn = false;
        firstCard = null;
        stashedCards = [];
        setState(() {});
        await offline.predict(stockskisContext!.playingPerson());
        return;
      }
      debugPrint("Pošiljam Stash");
      final Uint8List message = Message(
              stash: Stash(
                  send: Send(),
                  card: stashedCards.map((e) => Card(id: e.asset))))
          .writeToBuffer();
      socket.send(message);
      stash = false;
      turn = false;

      stashedCards = [];
    }
  }

  Future<void> sendCard(stockskis.LocalCard card,
      {bool zalozitevPotrjena = false}) async {
    debugPrint("sendCard() called, turn=$turn, stash=$stash");
    if (!turn) return;
    if (stash && !zalozitevPotrjena) {
      stashCard(card);
      return;
    }
    if (bots) {
      resetPremoves();
      premovedCard = null;

      List<stockskis.Card> skisCards = stockskisContext!.users["player"]!.cards;
      for (int i = 0; i < skisCards.length; i++) {
        if (skisCards[i].card.asset == card.asset) {
          if (stockskisContext!.stihi.last.isEmpty) {
            firstCard = skisCards[i].card;
          }
          stockskisContext!.stihi.last.add(skisCards[i]);
          stockskisContext!.users["player"]!.cards.removeAt(i);
          break;
        }
      }
      cards.remove(card);

      turn = false;
      bool early = await addToStih("player", "player", card.asset);
      setState(() {});

      if (early) return;

      if (stockskisContext!.stihi.last.length ==
          stockskisContext!.users.length) {
        await offline.cleanStih();
        return;
      }

      int next = afterPlayer();
      debugPrint("Next $next");
      await offline.play(next);

      return;
    }
    final Uint8List message =
        Message(card: Card(id: card.asset, send: Send())).writeToBuffer();
    socket.send(message);
    turn = false;
    cards.remove(card);
    resetPremoves();
    premovedCard = null;
  }

  Future<void> invitePlayer(String playerId) async {
    if (bots) return;
    final Uint8List message = Message(
      playerId: playerId,
      invitePlayer: InvitePlayer(),
    ).writeToBuffer();
    socket.send(message);
  }

  Future<void> manuallyStartGame() async {
    if (bots) return;
    final Uint8List message = Message(
      gameStart: GameStart(),
    ).writeToBuffer();
    socket.send(message);
  }

  Future<void> licitiranjeSend(stockskis.LocalGame game) async {
    if (!licitiram || !licitiranje) return;
    if (bots) {
      for (int i = 0; i < users.length; i++) {
        if (users[i].id == "player") {
          logger.i("nastavljam users[i].licitiral na ${game.id}");
          users[i].licitiral = game.id;
          stockskisContext!.gamemode = game.id;
          break;
        }
      }
      int next = afterPlayer();
      setState(() {});
      offline.licitate(next);
      removeInvalidGames("player", game.id);
      licitiram = false;
      return;
    }
    final Uint8List message =
        Message(licitiranje: Licitiranje(type: game.id)).writeToBuffer();
    socket.send(message);
    licitiram = false;
  }

  Future<void> selectTalon(int t) async {
    if (!showTalon || talonSelected != -1) return;
    if (bots) {
      List<stockskis.LocalCard> selectedCards = talon[t];
      for (int i = 0; i < selectedCards.length; i++) {
        stockskis.LocalCard c = selectedCards[i];
        for (int n = 0; n < stockskisContext!.talon.length; n++) {
          if (stockskisContext!.talon[n].card.asset != c.asset) continue;
          stockskisContext!.talon[n].user = "player";
          stockskisContext!.users["player"]!.cards
              .add(stockskisContext!.talon[n]);
          stockskisContext!.talon.removeAt(n);
          break;
        }
        cards.add(c);
      }
      sortCards();
      talonSelected = t;
      stash = true;
      turn = true;
      stashAmount = selectedCards.length;
      stashedCards = [];
      kingSelect = false;
      kingSelection = false;
      debugPrint("$stashAmount");
      validCards();
      setState(() {});
      return;
    }
    final Uint8List message =
        Message(talonSelection: TalonSelection(send: Send(), part: t))
            .writeToBuffer();
    socket.send(message);
  }

  Future<void> selectKing(String king) async {
    if (!kingSelect) {
      return;
    }

    kingSelect = false;
    if (bots) {
      selectedKing = king;
      stockskisContext!.selectSecretlyPlaying(king);
      await offline.startTalon("player");
      return;
    }
    final Uint8List message =
        Message(kingSelection: KingSelection(send: Send(), card: king))
            .writeToBuffer();
    socket.send(message);
  }

  Future<bool> addToStih(
      String msgPlayerId, String playerId, String card) async {
    Sounds.card();

    debugPrint(
        "card=$card, selectedKing=$selectedKing, msgPlayerId=$msgPlayerId, playerId=$playerId");
    if (card == selectedKing) {
      if (bots) stockskisContext!.revealKing(msgPlayerId);
      userHasKing = msgPlayerId;
      debugPrint("Karta $selectedKing nastavljena na uporabnika $msgPlayerId.");
    }
    List<stockskis.SimpleUser> after = [];
    List<stockskis.SimpleUser> before = [];
    if (bots) myPosition = stockskisContext!.getPlayer();
    debugPrint("My position: $myPosition");
    for (int i = myPosition + 1; i < users.length; i++) {
      after.add(users[i]);
    }
    for (int i = 0; i < myPosition; i++) {
      before.add(users[i]);
    }
    List<stockskis.SimpleUser> allUsers = [
      ...after,
      ...before,
      users[myPosition]
    ];
    cardStih.add(card);
    //print(allUsers);
    if (msgPlayerId == "talon") {
      debugPrint("nastavljam karto na talon");
      stih.add(CardWidget(
        position: 100,
        widget: Image.asset("assets/tarok$card.webp"),
        angle: (Random().nextDouble() - 0.5) / ANGLE,
      ));
      return false;
    }

    for (int i = 0; i < allUsers.length; i++) {
      final user = allUsers[i];
      if (user.id != msgPlayerId) continue;
      int position = user.id == playerId ? 3 : i;
      stih.add(CardWidget(
        position: position,
        widget: Image.asset("assets/tarok$card.webp"),
        angle: (Random().nextDouble() - 0.5) / ANGLE,
      ));
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 20), () {
        stihBoolValues[position] = true;
        setState(() {});
      });
      break;
    }
    if (bots && stih.length == playingCount) {
      eval = stockskisContext!.evaluateGame();
      debugPrint("Trenutna evaluacija igre je $eval. Kralj je $userHasKing.");
      bool canGameEndEarly = stockskisContext!.canGameEndEarly();
      if (canGameEndEarly) {
        debugPrint("končujem igro predčasno");
        await Future.delayed(const Duration(milliseconds: 500), () async {
          await offline.getResults();
        });
        return true;
      }
    }
    return false;
  }

  void listen() {
    socket.messages.listen(
      (data) async {
        final msg = Message.fromBuffer(data);
        if (msg.hasLicitiranje() ||
            msg.hasKingSelection() ||
            msg.hasTalonSelection() ||
            msg.hasPredictions()) {
          Sounds.click();
        }

        debugPrint(msg.toString());
        if (msg.hasLoginRequest()) {
          await login();
          return;
        } else if (msg.hasLoginResponse()) {
          playerId = msg.playerId;
          name = msg.username;
          bool found = false;
          for (int i = 0; i < users.length; i++) {
            if (users[i].id == playerId) {
              found = true;
              break;
            }
          }
          if (!found) users.add(stockskis.SimpleUser(id: playerId, name: name));
        } else if (msg.hasGameEnd()) {
          final game = msg.gameEnd;
          if (game.hasResults()) {
            final r = game.results;
            for (int i = 0; i < r.user.length; i++) {
              final thisUser = r.user[i];
              for (int n = 0; n < users.length; n++) {
                bool ok = false;
                for (int k = 0; k < thisUser.user.length; k++) {
                  if (thisUser.user[k].id != users[n].id) continue;
                  users[n].total = thisUser.points;
                  ok = true;
                  break;
                }
                if (ok) break;
              }
            }
            // zaključimo igro
            gameDone = true;
            results = null;
            started = false;
            socket.close();
          } else if (game.hasRequest()) {
            final playerId = msg.playerId;
            for (int n = 0; n < users.length; n++) {
              if (playerId != users[n].id) continue;
              users[n].endGame = true;
              break;
            }
          }
        } else if (msg.hasConnection()) {
          final conn = msg.connection;
          if (conn.hasJoin()) {
            bool found = false;
            for (int i = 0; i < userWidgets.length; i++) {
              if (userWidgets[i].id == msg.playerId) {
                found = true;
                userWidgets[i].connected = true;
                break;
              }
            }
            if (!found) {
              users.add(
                  stockskis.SimpleUser(id: msg.playerId, name: msg.username));
            }
          } else if (conn.hasLeave()) {
            for (int i = 0; i < users.length; i++) {
              if (users[i].id != msg.playerId) continue;
              users.removeAt(i);
              break;
            }
          } else if (conn.hasDisconnect()) {
            for (int i = 0; i < userWidgets.length; i++) {
              if (userWidgets[i].id != msg.playerId) continue;
              userWidgets[i].connected = false;
              break;
            }
          }
        } else if (msg.hasCard()) {
          final card = msg.card;
          if (card.hasReceive()) {
            final userId = msg.playerId;

            debugPrint("userId=$userId, playerId=$playerId");

            if (userId != playerId) {
              for (int i = 0; i < userWidgets.length; i++) {
                if (userWidgets[i].id != userId) continue;
                for (int n = 0; n < stockskis.CARDS.length; n++) {
                  stockskis.LocalCard c = stockskis.CARDS[n];
                  if (c.asset != card.id) continue;
                  userWidgets[i].cards.add(
                        stockskis.Card(
                          card: c,
                          user: userId,
                        ),
                      );
                  break;
                }
                userWidgets[i].cards = [
                  ...sortCardsToUser(
                    [
                      ...userWidgets[i].cards.map((e) => e.card),
                    ],
                  ).map((e) => stockskis.Card(card: e, user: userId)),
                ];
                debugPrint("Cards of length: ${userWidgets[i].cards.length}");
                break;
              }
            } else {
              for (int i = 0; i < stockskis.CARDS.length; i++) {
                if (stockskis.CARDS[i].asset != card.id) continue;
                cards.add(stockskis.CARDS[i]);
                sortCards();
                break;
              }
            }
          } else if (card.hasSend()) {
            // this packet takes care of a deck (štih)
            // once a card is added to a štih, this message is sent
            started = true;
            showTalon = false;
            stash = false;
            predictions = false;
            startPredicting = false;
            final userId = msg.playerId;

            if (userId != playerId) {
              for (int i = 0; i < userWidgets.length; i++) {
                if (userWidgets[i].id != userId) continue;
                for (int n = 0; n < userWidgets[i].cards.length; n++) {
                  stockskis.Card c = userWidgets[i].cards[n];
                  if (card.id != c.card.asset) continue;
                  userWidgets[i].cards.removeAt(n);
                  break;
                }
                break;
              }
            }

            if (firstCard == null) {
              for (int i = 0; i < stockskis.CARDS.length; i++) {
                if (stockskis.CARDS[i].asset == card.id) {
                  firstCard = stockskis.CARDS[i];
                  break;
                }
              }
            }
            print("send received");
            addToStih(msg.playerId, playerId, card.id);
            validCards();
            print(stih.length);
            print(stih);
          } else if (card.hasRequest()) {
            // this packet is sent when it's user's time to send a card
            final userId = msg.playerId;
            countdownUserTimer(userId, setState);
            if (userId == playerId) {
              turn = true;
              if (premovedCard != null) {
                resetPremoves();
                setState(() {});
                sendCard(premovedCard!);
              } else {
                licitiram = false;
                licitiranje = false;
                stash = false;
                validCards();
              }
            }
            /*if (cards.length == 1) {
              Future.delayed(const Duration(milliseconds: 500), () {
                sendCard(cards[0]);
              });
            }*/
            // preventivno, če se uporabnik slučajno disconnecta-reconnecta
            started = true;
          } else if (card.hasRemove()) {
            for (int i = 0; i < cards.length; i++) {
              if (card.id == cards[i].asset) {
                cards.removeAt(i);
                break;
              }
            }
            turn = false;
            stash = false;
          }
        } else if (msg.hasGameStart() || msg.hasUserList()) {
          if (msg.hasGameStart()) {
            licitiranje = true;
            licitiram = false;
            cards = [];
            if (!lp && AVTOLP) {
              sendMessageString("lp");
              lp = true;
            }

            for (int i = 0; i < userWidgets.length; i++) {
              userWidgets[i].cards = [];
            }
          }

          resetPremoves();
          premovedCard = null;
          cardStih = [];
          userHasKing = "";
          selectedKing = "";
          firstCard = null;
          playing = false;
          results = null;
          showTalon = false;
          stash = false;
          predictions = false;
          kingSelect = false;
          kingSelection = false;
          zaruf = false;

          currentPredictions = Predictions();
          copyGames();

          for (int i = 0; i < users.length; i++) {
            users[i].licitiral = -2;
            users[i].endGame = false;
          }
          for (int i = 0; i < stockskis.CARDS.length; i++) {
            stockskis.CARDS[i].showZoom = false;
          }
          for (int i = 0; i < cards.length; i++) {
            cards[i].showZoom = false;
          }

          turn = false;
          started = true;

          stih = [];
          stihBoolValues = {};
          stashedCards = [];

          // ignore: prefer_typing_uninitialized_variables
          final gameStart;
          if (msg.hasGameStart()) {
            gameStart = msg.gameStart;
          } else {
            gameStart = msg.userList;
          }

          List<stockskis.SimpleUser> usersBackup = [...users];
          users = [];

          List<User> newUsers = gameStart.user;
          for (int i = 0; i < newUsers.length; i++) {
            final newUser = newUsers[i];
            if (newUser.id == playerId) myPosition = newUser.position;
            for (int n = 0; n < usersBackup.length; n++) {
              if (usersBackup[n].id != newUser.id) continue;
              users.add(
                stockskis.SimpleUser(id: newUser.id, name: newUser.name)
                  ..points = usersBackup[n].points
                  ..total = usersBackup[n].total
                  ..radlci = usersBackup[n].radlci
                  ..connected = usersBackup[n].connected,
              );
              break;
            }
          }

          if (users.isEmpty) return;

          debugPrint("urejam vrstni red v `users`");

          // uredimo vrstni red naših igralcev
          //users = [];
          //for (int i = 0; i < userPosition.length; i++) {
          //  users.add(userPosition[i]);
          //}

          debugPrint("vrstni red v `users` je urejen");

          // magija, da dobimo pravilno lokalno zaporedje
          int i = myPosition + 1;
          if (i >= users.length) i = 0;
          int k = 0;
          int ffallback = 0;
          userWidgets = [];
          print(myPosition);
          print(k);
          print(i);
          while (i < users.length) {
            if (ffallback > users.length * 2) {
              break;
            }
            stockskis.SimpleUser user = users[i];
            userWidgets.add(user);
            if (i == myPosition) break;
            i++;
            k++;
            ffallback++;
            if (i >= users.length) i = 0;
          }

          debugPrint("anotacije so bile dodane");
        } else if (msg.hasGameStartCountdown()) {
          countdown = msg.gameStartCountdown.countdown;
        } else if (msg.hasLicitiranje()) {
          licitiranje = true;
          licitiram = false;
          final player = msg.playerId;
          final l = msg.licitiranje.type;
          bool obvezen = users.last.id == playerId;
          removeInvalidGames(
            player,
            l,
            imaPrednost: obvezen,
          );
          inspect(users);
        } else if (msg.hasLicitiranjeStart()) {
          final userId = msg.playerId;
          countdownUserTimer(userId, setState);
          if (userId == playerId) {
            // this packet is sent when it's user's time to licitate
            bool obvezen = users.last.id == playerId;
            removeInvalidGames(
              userId,
              0,
              shraniLicitacijo: false,
              imaPrednost: obvezen,
            );
            licitiram = true;
          }
        } else if (msg.hasClearDesk()) {
          stih = [];
          cardStih = [];
          stihBoolValues = {};
          firstCard = null;
          validCards();
        } else if (msg.hasResults()) {
          final r = msg.results;
          results = r;
          bool radelc = false;
          for (int i = 0; i < results!.user.length; i++) {
            if (results!.user[i].radelc) {
              radelc = true;
              break;
            }
          }
          for (int n = 0; n < users.length; n++) {
            users[n].points.add(
                  stockskis.ResultsPoints(
                    playing: false,
                    points: 0,
                    results: ResultsCompLayer.messagesToStockSkis(r),
                    radelc: radelc,
                  ),
                );
          }
          for (int i = 0; i < r.user.length; i++) {
            final user = r.user[i];
            for (int k = 0; k < user.user.length; k++) {
              User u = user.user[k];
              for (int n = 0; n < users.length; n++) {
                if (users[n].id != u.id) continue;
                debugPrint(
                    "found ${u.id} with points ${user.points} and total ${users[n].total}");
                users[n].points.last.points += user.points;
                users[n].total += user.points;
                users[n].points.last.playing = user.playing;
                break;
              }
            }
          }
        } else if (msg.hasTalonSelection()) {
          final talonSelection = msg.talonSelection;
          kingSelect = false;
          kingSelection = false;
          if (talonSelection.hasRequest()) {
            final userId = msg.playerId;
            countdownUserTimer(userId, setState);
            if (userId == playerId) {
              playing = true;
            }
          } else if (talonSelection.hasSend()) {
            talonSelected = talonSelection.part;
          }
        } else if (msg.hasTalonReveal()) {
          final talonReveal = msg.talonReveal;
          licitiranje = false;
          licitiram = false;
          talon = [];
          talonSelected = -1;
          showTalon = true;
          kingSelect = false;
          kingSelection = false;
          for (int i = 0; i < talonReveal.stih.length; i++) {
            final stih = talonReveal.stih[i];
            List<stockskis.LocalCard> thisStih = [];
            for (int n = 0; n < stih.card.length; n++) {
              final card = stih.card[n];
              if (card.id == selectedKing) {
                zaruf = true;
              }
              for (int k = 0; k < stockskis.CARDS.length; k++) {
                final c = stockskis.CARDS[k];
                if (c.asset != card.id) continue;
                thisStih.add(c);
                break;
              }
            }
            talon.add(thisStih);
          }
        } else if (msg.hasStash()) {
          final userId = msg.playerId;
          countdownUserTimer(userId, setState);
          if (userId == playerId) {
            final s = msg.stash;
            kingSelect = false;
            kingSelection = false;
            if (s.hasRequest()) {
              stash = true;
              turn = true;
              stashAmount = s.length;
              validCards();
            }
          }
        } else if (msg.hasPredictions()) {
          showTalon = false;
          stash = false;
          currentPredictions = msg.predictions;
          predictions = true;
          kingSelect = false;
          kingSelection = false;
          startPredicting = false;
          myPredictions = null;

          // reset
          resetPredictions();
        } else if (msg.hasPredictionsResend()) {
          debugPrint("Received resent predictions");
          currentPredictions = msg.predictionsResend;
        } else if (msg.hasStartPredictions()) {
          final userId = msg.playerId;
          countdownUserTimer(userId, setState);
          if (userId == playerId) {
            showTalon = false;
            stash = false;
            myPredictions = msg.startPredictions;
            startPredicting = true;
          }
        } else if (msg.hasKingSelection()) {
          final selection = msg.kingSelection;
          if (selection.hasNotification()) {
            kingSelection = true;
          } else if (selection.hasRequest()) {
            final userId = msg.playerId;
            countdownUserTimer(userId, setState);
            if (userId == playerId) {
              kingSelect = true;
            }
          } else if (selection.hasSend()) {
            selectedKing = selection.card;
          }
        } else if (msg.hasRadelci()) {
          final userId = msg.playerId;
          final radelci = msg.radelci;
          for (int i = 0; i < users.length; i++) {
            if (users[i].id != userId) continue;
            users[i].radlci = radelci.radleci;
            break;
          }
        } else if (msg.hasTime()) {
          final time = msg.time;
          final userId = msg.playerId;
          for (int i = 0; i < userWidgets.length; i++) {
            if (userWidgets[i].id != userId) continue;
            userWidgets[i].timer = time.currentTime;
            userWidgets[i].timerOn = false;
            break;
          }
        } else if (msg.hasChatMessage()) {
          final chatMessage = msg.chatMessage;
          chat.insert(0, chatMessage);
        }
        setState(() {});
      },
      onDone: () {
        debugPrint('ws channel closed');
      },
      onError: (error) => debugPrint(error),
    );
  }
}
