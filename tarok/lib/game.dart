import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tarok/constants.dart';
import 'package:tarok/messages.pb.dart' as Messages;
import 'package:tarok/stockskis/stockskis.dart' as stockskis;
import 'package:web_socket_client/web_socket_client.dart';

class Game extends StatefulWidget {
  const Game(
      {super.key,
      required this.gameId,
      required this.bots,
      required this.playing});

  final String gameId;
  final bool bots;
  final int playing;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late WebSocket websocket;
  late String playerId;
  late String name;

  List<User> users = [];
  List<List<LocalCard>> talon = [];
  List<LocalCard> cards = [];
  List<LocalCard> stashedCards = [];
  LocalCard? firstCard;
  List<CardWidget> stih = [];
  List<Widget> userWidgets = [];
  Map<int, User> userPosition = {};
  List<LocalGame> games = GAMES.map((o) => o.copyWith()).toList();
  List<int> suggestions = [];

  bool turn = false;
  bool licitiranje = false;
  bool licitiram = false;
  bool started = false;
  bool playing = false;
  bool stash = false;
  bool showTalon = false;
  bool predictions = false;
  bool startPredicting = false;
  bool kingSelection = false;
  bool kingSelect = false;
  int myPosition = 0;
  int stashAmount = 0;
  int talonSelected = -1;
  String selectedKing = "";
  Messages.StartPredictions? myPredictions;
  Messages.Predictions? currentPredictions;
  Messages.ResultsUser? results;

  bool kontraValat = false;
  bool kontraBarvic = false;
  bool kontraIgra = false;
  bool kontraPagat = false;
  bool kontraKralj = false;
  bool trula = false;
  bool kralji = false;
  bool kraljUltimo = false;
  bool pagatUltimo = false;
  bool valat = false;
  bool barvic = false;

  late final stockskis.StockSkis stockskisContext;

  WebSocket websocketConnection(String gameId) {
    const timeout = Duration(seconds: 10);
    final uri = Uri.parse('ws://localhost:8080/ws/$gameId');
    debugPrint("requesting to $uri");
    final socket = WebSocket(
      uri,
      binaryType: "arraybuffer",
    );
    return socket;
  }

  Future<void> login() async {
    final token = await storage.read(key: "token");
    final Uint8List message =
        Messages.Message(loginInfo: Messages.LoginInfo(token: token))
            .writeToBuffer();
    websocket.send(message);
  }

  void validCards() {
    if (stash) {
      for (int i = 0; i < cards.length; i++) {
        cards[i].valid = cards[i].worth != 5;
      }
      return;
    }
    if (firstCard == null) {
      for (int i = 0; i < cards.length; i++) {
        cards[i].valid = true;
      }
      return;
    }
    final color = firstCard!.asset.split("/")[1];
    bool imaTaroke = false;
    bool imaBarvo = false;
    for (int i = 0; i < cards.length; i++) {
      if (cards[i].asset.contains("taroki")) imaTaroke = true;
      if (cards[i].asset.contains(color)) imaBarvo = true;
      if (imaBarvo && imaTaroke) break;
      cards[i].valid = false;
    }
    if (firstCard!.asset.contains("taroki")) {
      for (int i = 0; i < cards.length; i++) {
        if (!imaTaroke || cards[i].asset.contains("taroki"))
          cards[i].valid = true;
      }
    } else {
      for (int i = 0; i < cards.length; i++) {
        if ((!imaBarvo && !imaTaroke) ||
            (!imaBarvo && imaTaroke && cards[i].asset.contains("taroki")) ||
            (imaBarvo && cards[i].asset.contains(color))) cards[i].valid = true;
      }
    }
  }

  void stashCard(LocalCard card) {
    if (card.worth == 5) return; // ne mormo si založit kraljev in trule
    stashedCards.add(card);
    cards.remove(card);
    if (stashedCards.length == stashAmount) {
      if (widget.bots) {
        for (int i = 0; i < stashedCards.length; i++) {
          for (int n = 0;
              n < stockskisContext.users["player"]!.cards.length;
              n++) {
            final card = stockskisContext.users["player"]!.cards[n];
            if (card.card.asset != stashedCards[i].asset) continue;
            stockskisContext.stihi[0].add(card);
            stockskisContext.users["player"]!.cards.removeAt(n);
            break;
          }
        }
        stockskisContext.stihi.add([]);
        stash = false;
        turn = false;
        firstCard = null;
        bPlay(0);
        return;
      }
      final Uint8List message = Messages.Message(
              stash: Messages.Stash(
                  send: Messages.Send(),
                  card: stashedCards.map((e) => Messages.Card(id: e.asset))))
          .writeToBuffer();
      websocket.send(message);
      stash = false;
      turn = false;
    }
  }

  void predict() {
    if (currentPredictions == null) return;
    if (trula) currentPredictions!.trula = Messages.User(id: playerId);
    if (kralji) currentPredictions!.kralji = Messages.User(id: playerId);
    if (kraljUltimo)
      currentPredictions!.kraljUltimo = Messages.User(id: playerId);
    if (pagatUltimo)
      currentPredictions!.pagatUltimo = Messages.User(id: playerId);
    if (valat) currentPredictions!.valat = Messages.User(id: playerId);
    if (barvic) currentPredictions!.barvniValat = Messages.User(id: playerId);

    // kontre dal
    if (kontraKralj)
      currentPredictions!.kraljUltimoKontraDal = Messages.User(id: playerId);
    if (kontraPagat)
      currentPredictions!.pagatUltimoKontraDal = Messages.User(id: playerId);
    if (kontraValat)
      currentPredictions!.valatKontraDal = Messages.User(id: playerId);
    if (kontraBarvic)
      currentPredictions!.barvniValatKontraDal = Messages.User(id: playerId);
    if (kontraIgra)
      currentPredictions!.igraKontraDal = Messages.User(id: playerId);

    currentPredictions!.changed = kontraValat ||
        kontraBarvic ||
        kontraIgra ||
        kontraPagat ||
        kontraKralj ||
        trula ||
        kralji ||
        valat ||
        barvic ||
        pagatUltimo ||
        kraljUltimo;
    final Uint8List message =
        Messages.Message(predictions: currentPredictions!).writeToBuffer();
    websocket.send(message);
    startPredicting = false;
    myPredictions = null;
  }

  void sendCard(LocalCard card) async {
    if (!turn) return;
    if (stash) {
      stashCard(card);
      return;
    }
    if (widget.bots) {
      List<stockskis.Card> skisCards = stockskisContext.users["player"]!.cards;
      for (int i = 0; i < skisCards.length; i++) {
        if (skisCards[i].card.asset == card.asset) {
          stockskisContext.stihi.last.add(skisCards[i]);
          stockskisContext.users["player"]!.cards.removeAt(i);
          break;
        }
      }
      cards.remove(card);

      int k = 0;
      for (int i = 0; i < userPosition.length; i++) {
        if (userPosition[i]!.id == "player") {
          k = i;
          break;
        }
      }

      addToStih("player", "player", card.asset);
      setState(() {});

      if (stockskisContext.stihi.last.length == stockskisContext.users.length) {
        await Future.delayed(const Duration(seconds: 1), () {
          print("Cleaning");
          List<stockskis.Card> zadnjiStih = stockskisContext.stihi.last;
          String pickedUpBy = stockskisContext.stihPickedUpBy(zadnjiStih);
          int k = 0;
          for (int i = 1; i < userPosition.length; i++) {
            if (userPosition[i]!.id == pickedUpBy) {
              k = i;
              break;
            }
          }

          // preveri, kdo je dubu ta štih in naj on začne
          stih = [];
          firstCard = null;
          stockskisContext.stihi.add([]);
          setState(() {});
          validCards();
          bPlay(k);
        });
        return;
      }

      print("Next ${k + 1}");
      bPlay(k + 1);

      // dodaj bote
      return;
    }
    final Uint8List message = Messages.Message(
            card: Messages.Card(id: card.asset, send: Messages.Send()))
        .writeToBuffer();
    websocket.send(message);
    turn = false;
    cards.remove(card);
  }

  void licitiranjeSend(LocalGame game) {
    if (!licitiram || !licitiranje) return;
    if (widget.bots) {
      for (int i = 0; i < users.length; i++) {
        if (users[i].id == "player") {
          users[i].licitiral = game.id;
          break;
        }
      }
      int k = 0;
      for (int i = 0; i < userPosition.length; i++) {
        if (userPosition[i]!.id == "player") {
          k = i;
          break;
        }
      }
      setState(() {});
      bLicitate(k + 1);
      removeInvalidGames("player", game.id);
      licitiram = false;
      return;
    }
    final Uint8List message =
        Messages.Message(licitiranje: Messages.Licitiranje(type: game.id))
            .writeToBuffer();
    websocket.send(message);
    licitiram = false;
  }

  void selectTalon(int t) {
    if (!showTalon || talonSelected != -1) return;
    if (widget.bots) {
      List<LocalCard> selectedCards = talon[t];
      for (int i = 0; i < selectedCards.length; i++) {
        LocalCard c = selectedCards[i];
        for (int n = 0; n < stockskisContext.talon.length; n++) {
          if (stockskisContext.talon[n].card.asset != c.asset) continue;
          stockskisContext.users["player"]!.cards
              .add(stockskisContext.talon[n]);
          stockskisContext.talon.removeAt(n);
          break;
        }
        cards.add(c);
      }
      sortCards();
      talonSelected = t;
      stash = true;
      stash = true;
      turn = true;
      stashAmount = selectedCards.length;
      validCards();
      setState(() {});
      return;
    }
    final Uint8List message = Messages.Message(
            talonSelection:
                Messages.TalonSelection(send: Messages.Send(), part: t))
        .writeToBuffer();
    websocket.send(message);
  }

  void selectKing(String king) {
    kingSelect = false;
    if (widget.bots) {
      selectedKing = king;
      bTalon("player");
      return;
    }
    final Uint8List message = Messages.Message(
            kingSelection:
                Messages.KingSelection(send: Messages.Send(), card: king))
        .writeToBuffer();
    websocket.send(message);
  }

  void sortCards() {
    List<LocalCard> piki = [];
    List<LocalCard> kare = [];
    List<LocalCard> srci = [];
    List<LocalCard> krizi = [];
    List<LocalCard> taroki = [];
    for (int i = 0; i < cards.length; i++) {
      final card = cards[i];
      if (card.asset.contains("taroki")) taroki.add(card);
      if (card.asset.contains("kriz")) krizi.add(card);
      if (card.asset.contains("src")) srci.add(card);
      if (card.asset.contains("kara")) kare.add(card);
      if (card.asset.contains("pik")) piki.add(card);
    }
    piki.sort((a, b) => a.worthOver.compareTo(b.worthOver));
    kare.sort((a, b) => a.worthOver.compareTo(b.worthOver));
    srci.sort((a, b) => a.worthOver.compareTo(b.worthOver));
    krizi.sort((a, b) => a.worthOver.compareTo(b.worthOver));
    taroki.sort((a, b) => a.worthOver.compareTo(b.worthOver));
    cards = [...piki, ...kare, ...srci, ...krizi, ...taroki];
  }

  void bLicitate(int startAt) async {
    licitiranje = true;

    int onward = 0;
    for (int i = 0; i < users.length; i++) {
      if (users[i].licitiral == -1) onward++;
    }
    if (onward >= users.length - 1) {
      int m = -1;
      for (int i = 0; i < users.length; i++) {
        if (m < users[i].licitiral) {
          m = users[i].licitiral;
          stockskisContext.users[users[i].id]!.playing = true;
          stockskisContext.users[users[i].id]!.secretlyPlaying = true;
          stockskisContext.gamemode = m;
          licitiranje = false;
          bKingSelect(users[i].id);
          break;
        }
      }
      return;
    }

    for (int i = startAt; i < userPosition.length; i++) {
      User user = userPosition[i]!;
      if (user.id == "player") {
        bool jeLicitiral = false;
        for (int n = 0; n < users.length; n++) {
          if (users[n].id == "player") {
            jeLicitiral = users[n].licitiral == -1;
          }
        }
        if (jeLicitiral) continue;
        licitiram = true;
        suggestions = stockskisContext.suggestModes(user.id);
        return;
      }
      List<int> botSuggestions = stockskisContext.suggestModes(user.id);
      for (int n = 0; n < users.length; n++) {
        // preskočimo bote, ki so že licitirali
        if (users[n].licitiral == -1) continue;

        // preprečimo, da bi se boti kregali med sabo
        int onward = 0;
        for (int k = 0; k < users.length; k++) {
          if (users[k].licitiral == -1) onward++;
        }
        if (onward >= users.length - 1) {
          bKingSelect(users[n].id);
          return;
        }

        if (users[n].id == user.id) {
          if (botSuggestions.isEmpty) {
            users[n].licitiral = -1;
          } else {
            // TODO: pojdi na obveznega
            bool canLicitate = true;
            for (int i = 0; i < users.length; i++) {
              if (users[i].licitiral >= botSuggestions.last) {
                canLicitate = false;
                break;
              }
            }
            if (canLicitate) {
              users[n].licitiral = botSuggestions.last;
            } else {
              users[n].licitiral = -1;
            }
          }
        }
      }
      await Future.delayed(const Duration(seconds: 1), () {
        setState(() {});
      });
    }
    bLicitate(0);
  }

  int getPlayedGame() {
    int m = -1;
    for (int i = 0; i < users.length; i++) {
      if (m < users[i].licitiral) {
        m = users[i].licitiral;
        stockskisContext.users[users[i].id]!.playing = true;
        stockskisContext.users[users[i].id]!.secretlyPlaying = true;
        stockskisContext.gamemode = m;
        return m;
      }
    }
    return m;
  }

  void bPlay(int startAt) async {
    licitiram = false;
    licitiranje = false;
    showTalon = false;
    int i = startAt;
    while (true) {
      if (i >= stockskisContext.users.length) i = 0;
      print("Currently at $i");
      User pos = userPosition[i]!;
      if (pos.id == "player") {
        turn = true;
        validCards();
        setState(() {});
        return;
      }
      if (stockskisContext.users[pos.id]!.cards.isEmpty) {
        // kalkulirajmo in končajmo igro
        return;
      }
      List<stockskis.Move> moves = stockskisContext.evaluateMoves(pos.id);
      //print(moves);
      //print(stockskisContext.stihi.last);
      //print(stockskisContext.users["bot1"]!.cards);
      stockskis.Move bestMove = moves.first;
      for (int i = 1; i < moves.length; i++) {
        if (bestMove.evaluation < moves[i].evaluation) bestMove = moves[i];
      }
      inspect(bestMove); // Dart Debugger
      stockskisContext.stihi.last.add(bestMove.card);
      stockskisContext.users[pos.id]!.cards.remove(bestMove.card);
      await Future.delayed(const Duration(milliseconds: 500), () {
        addToStih(pos.id, "player", bestMove.card.card.asset);
      });
      i++;
      setState(() {});
      if (stockskisContext.stihi.last.length == stockskisContext.users.length) {
        await Future.delayed(const Duration(seconds: 1), () {
          print("Cleaning");
          List<stockskis.Card> zadnjiStih = stockskisContext.stihi.last;
          String pickedUpBy = stockskisContext.stihPickedUpBy(zadnjiStih);
          int k = 0;
          for (int i = 1; i < userPosition.length; i++) {
            if (userPosition[i]!.id == pickedUpBy) {
              k = i;
              break;
            }
          }

          // preveri, kdo je dubu ta štih in naj on začne
          stih = [];
          firstCard = null;
          stockskisContext.stihi.add([]);
          setState(() {});
          validCards();
          bPlay(k);
        });
        return;
      }
    }
  }

  void bTalon(String playerId) async {
    print("Talon");
    int game = getPlayedGame();
    if (game == -1 || game >= 6) {
      firstCard = null;
      bPlay(0);
      return;
    }
    print("Talon1");
    showTalon = true;

    int m = 0;
    if (game == 0 || game == 3) m = 2;
    if (game == 1 || game == 4) m = 3;
    if (game == 2 || game == 5) m = 6;
    talon = [];
    int k = 0;
    List<List<stockskis.Card>> stockskisTalon = [];
    for (int i = 0; i < m; i++) {
      List<LocalCard> cards = [];
      List<stockskis.Card> c = [];
      for (int n = 0; n < 6 / m; n++) {
        cards.add(stockskisContext.talon[k].card);
        c.add(stockskisContext.talon[k]);
        k++;
      }
      talon.add(cards);
      stockskisTalon.add(c);
    }

    if (playerId == "player") {
      playing = true;
      setState(() {});
      return;
    }

    talonSelected = stockskisContext.selectDeck(stockskisTalon);
    List<stockskis.Card> selectedCards = stockskisTalon[talonSelected];
    for (int i = 0; i < selectedCards.length; i++) {
      selectedCards[i].user = playerId;
      stockskisContext.users[playerId]!.cards.add(selectedCards[i]);
      stockskisContext.talon.remove(selectedCards[i]);
    }
    String king = selectedKing == "" ? "" : selectedKing.split("/")[1];
    List<stockskis.Card> stash =
        stockskisContext.stashCards(playerId, (6 / m).round(), king);
    for (int i = 0; i < stash.length; i++) {
      stash[i].user = playerId;
      stockskisContext.users[playerId]!.cards.remove(stash[i]);
      stockskisContext.stihi[0].add(stash[i]);
    }
    stockskisContext.stihi.add([]);
    setState(() {});
    firstCard = null;
    await Future.delayed(const Duration(seconds: 2), () {
      bPlay(0);
    });
  }

  void bKingSelect(String playerId) async {
    int game = getPlayedGame();
    if (game == -1 || game >= 3) {
      bTalon(playerId);
      return;
    }
    kingSelection = true;
    if (playerId == "player") {
      kingSelect = true;
      return;
    }
    kingSelect = false;
    selectedKing = stockskisContext.selectKing(playerId);
    setState(() {});
    await Future.delayed(const Duration(seconds: 2), () {
      kingSelection = false;
      bTalon(playerId);
      setState(() {});
    });
  }

  void removeInvalidGames(String playerId, int l) {
    for (int i = 0; i < users.length; i++) {
      if (users[i].id != playerId) continue;
      users[i].licitiral = l;
      if (l == -1) break;
      for (int n = 1; n < games.length; i++) {
        if (games[1].id > l) break;
        games.removeAt(1);
      }
      break;
    }
  }

  void addToStih(String msgPlayerId, String playerId, String card) {
    List<User> after = [];
    List<User> before = [];
    for (int i = myPosition + 1; i < users.length; i++) {
      after.add(users[i]);
    }
    for (int i = 0; i < myPosition; i++) {
      before.add(users[i]);
    }
    List<User> allUsers = [...after, ...before, users[myPosition]];
    //print(allUsers);
    for (int i = 0; i < allUsers.length; i++) {
      final user = allUsers[i];
      if (user.id != msgPlayerId) continue;
      stih.add(CardWidget(
        position: user.id == playerId ? 3 : i,
        widget: Image.asset("assets/tarok$card.webp"),
      ));
      break;
    }
  }

  @override
  void initState() {
    // BOTI - OFFLINE
    if (widget.bots) {
      Map<String, stockskis.User> stockskisUsers = {};
      List<LocalCard> localCards = CARDS.toList();
      localCards.shuffle();
      List<String> botNames = BOT_NAMES.toList();
      for (int i = 1; i < widget.playing; i++) {
        String randomName = botNames[Random().nextInt(botNames.length)];
        botNames.remove(randomName);
        LocalCard card = localCards[0];
        localCards.removeAt(0);
        String botId = "bot$i";
        stockskisUsers[botId] = stockskis.User(
          cards: [],
          user: User(id: botId, name: randomName),
          playing: false,
          secretlyPlaying: false,
        );
        User user = User(id: botId, name: randomName);
        users.add(user);
        userPosition[i] = user;
        userWidgets.add(
          Text(user.name, style: const TextStyle(fontSize: 20)),
        );
      }
      stockskisUsers["player"] = stockskis.User(
        cards: [],
        user: User(id: "player", name: "Igralec"),
        playing: false,
        secretlyPlaying: false,
      );
      User user = User(id: "player", name: "Igralec");
      users.add(user);
      userPosition[0] = user;
      stockskisContext = stockskis.StockSkis(
        users: stockskisUsers,
        stihiCount: ((54 - 6) / widget.playing).floor(),
      );
      users = [];
      for (int i = 0; i < userPosition.length; i++) {
        users.add(userPosition[i]!);
      }
      stockskisContext.doRandomShuffle();
      List<stockskis.Card> myCards = stockskisContext.users["player"]!.cards;
      cards = myCards.map((card) => card.card).toList();
      sortCards();
      turn = false;
      started = true;
      bLicitate(0);
      super.initState();
      return;
    }

    // ONLINE
    websocket = websocketConnection(widget.gameId);
    websocket.messages.listen(
      (data) async {
        final msg = Messages.Message.fromBuffer(data);
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
          if (!found) users.add(User(id: playerId, name: name));
        } else if (msg.hasConnection()) {
          final conn = msg.connection;
          if (conn.hasJoin()) {
            bool found = false;
            for (int i = 0; i < users.length; i++) {
              if (users[i].id == msg.playerId) {
                found = true;
                break;
              }
            }
            if (!found) users.add(User(id: msg.playerId, name: msg.username));
          } else {
            for (int i = 0; i < users.length; i++) {
              if (users[i].id != msg.playerId) continue;
              users.removeAt(i);
              break;
            }
          }
        } else if (msg.hasCard()) {
          final card = msg.card;
          if (card.hasReceive()) {
            for (int i = 0; i < CARDS.length; i++) {
              if (CARDS[i].asset != card.id) continue;
              cards.add(CARDS[i]);
              sortCards();
              break;
            }
          } else if (card.hasSend()) {
            // this packet takes care of a deck (štih)
            // once a card is added to a štih, this message is sent
            started = true;
            showTalon = false;
            stash = false;
            predictions = false;
            startPredicting = false;
            if (firstCard == null) {
              for (int i = 0; i < CARDS.length; i++) {
                if (CARDS[i].asset == card.id) {
                  firstCard = CARDS[i];
                  break;
                }
              }
            }
            print("send received");
            addToStih(msg.playerId, playerId, card.id);
            print(stih.length);
            print(stih);
          } else if (card.hasRequest()) {
            // this packet is sent when it's user's time to send a card
            turn = true;
            licitiram = false;
            licitiranje = false;
            stash = false;
            validCards();
            // preventivno, če se uporabnik slučajno disconnecta-reconnecta
            started = true;
          }
        } else if (msg.hasGameStart() || msg.hasUserList()) {
          if (msg.hasGameStart()) {
            licitiranje = true;
            licitiram = false;
          }
          firstCard = null;
          results = null;
          games = GAMES.map((o) => o.copyWith()).toList();

          for (int i = 0; i < users.length; i++) {
            users[i].licitiral = -2;
          }
          for (int i = 0; i < CARDS.length; i++) {
            CARDS[i].showZoom = false;
          }
          for (int i = 0; i < cards.length; i++) {
            cards[i].showZoom = false;
          }

          turn = false;
          started = true;

          stih = [];

          final gameStart;
          if (msg.hasGameStart()) {
            gameStart = msg.gameStart;
          } else {
            gameStart = msg.userList;
          }

          List<Messages.User> newUsers = gameStart.user;
          for (int i = 0; i < newUsers.length; i++) {
            final newUser = newUsers[i];
            if (newUser.id == playerId) myPosition = newUser.position;
            for (int n = 0; n < users.length; n++) {
              if (users[n].id != newUser.id) continue;
              userPosition[newUser.position] =
                  User(id: newUser.id, name: newUser.name)
                    ..points = users[n].points;
              break;
            }
          }

          if (userPosition.isEmpty) return;

          // uredimo vrstni red naših igralcev
          users = [];
          for (int i = 0; i < userPosition.length; i++) {
            users.add(userPosition[i]!);
          }

          // magija, da dobimo pravilno lokalno zaporedje
          int i = myPosition + 1;
          if (i >= userPosition.length) i = 0;
          int k = 0;
          userWidgets = [];
          print(myPosition);
          print(k);
          print(i);
          while (i < userPosition.length) {
            User user = userPosition[i]!;
            userWidgets.add(
              Text(user.name, style: const TextStyle(fontSize: 20)),
            );
            i++;
            k++;
            if (i >= userPosition.length) i = 0;
            if (i == myPosition) break;
          }
        } else if (msg.hasLicitiranje()) {
          licitiranje = true;
          final player = msg.playerId;
          final l = msg.licitiranje.type;
          removeInvalidGames(playerId, l);
        } else if (msg.hasLicitiranjeStart()) {
          // this packet is sent when it's user's time to licitate
          licitiram = true;
        } else if (msg.hasClearDesk()) {
          stih = [];
          firstCard = null;
          validCards();
        } else if (msg.hasResults()) {
          final r = msg.results;
          for (int i = 0; i < r.user.length; i++) {
            final user = r.user[i];
            if (user.playing) {
              print("Playing $user");
              results = user;
            } else {
              print("Not playing $user");
              user.points = 0;
            }
            for (int n = 0; n < users.length; n++) {
              if (users[n].id == user.user.id) {
                users[n].points.add(user.points);
                break;
              }
            }
          }
        } else if (msg.hasTalonSelection()) {
          final talonSelection = msg.talonSelection;
          kingSelect = false;
          kingSelection = false;
          selectedKing = "";
          if (talonSelection.hasRequest()) {
            playing = true;
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
          selectedKing = "";
          for (int i = 0; i < talonReveal.stih.length; i++) {
            final stih = talonReveal.stih[i];
            List<LocalCard> thisStih = [];
            for (int n = 0; n < stih.card.length; n++) {
              final card = stih.card[n];
              for (int k = 0; k < CARDS.length; k++) {
                final localCard = CARDS[k];
                if (localCard.asset != card.id) continue;
                thisStih.add(localCard);
                break;
              }
            }
            talon.add(thisStih);
          }
        } else if (msg.hasStash()) {
          final s = msg.stash;
          kingSelect = false;
          kingSelection = false;
          selectedKing = "";
          if (s.hasRequest()) {
            stash = true;
            turn = true;
            stashAmount = s.length;
            validCards();
          }
        } else if (msg.hasPredictions()) {
          showTalon = false;
          stash = false;
          currentPredictions = msg.predictions;
          predictions = true;
          kingSelect = false;
          kingSelection = false;
          selectedKing = "";

          // reset
          kontraValat = false;
          kontraBarvic = false;
          kontraIgra = false;
          kontraPagat = false;
          kontraKralj = false;
          trula = false;
          kralji = false;
          kraljUltimo = false;
          pagatUltimo = false;
          valat = false;
          barvic = false;
        } else if (msg.hasStartPredictions()) {
          showTalon = false;
          stash = false;
          myPredictions = msg.startPredictions;
          startPredicting = true;
        } else if (msg.hasKingSelection()) {
          final selection = msg.kingSelection;
          if (selection.hasNotification()) {
            kingSelection = true;
          } else if (selection.hasRequest()) {
            kingSelect = true;
          }
        }
        setState(() {});
      },
      onDone: () {
        debugPrint('ws channel closed');
      },
      onError: (error) => print(error),
    );

    super.initState();
  }

  @override
  void dispose() {
    try {
      websocket.close();
    } catch (e) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardSize = min(
      max(
        MediaQuery.of(context).size.width / cards.length,
        MediaQuery.of(context).size.width * 0.15,
      ),
      550.0,
    );
    final cardWidth = cardSize * 0.55;
    const duration = Duration(milliseconds: 200);
    final m = min(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    const cardK = 0.4;
    final topFromLeft = MediaQuery.of(context).size.width * 0.35;
    final leftFromTop = MediaQuery.of(context).size.height * 0.3;

    return Scaffold(
      body: Stack(
        children: [
          // REZULTATI
          Container(
            alignment: Alignment.topRight,
            child: Card(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width / 4,
                child: Column(
                  children: [
                    const Center(
                      child: Text(
                        "Rezultati",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: [
                        ...users.map((User user) => Expanded(
                              child: Center(
                                child: Text(
                                  user.name,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                    if (users.isNotEmpty)
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 24),
                          child: ListView.builder(
                            itemCount: users[0].points.length,
                            itemBuilder: (BuildContext context, int index) =>
                                Row(
                              children: [
                                ...users.map((e) => Expanded(
                                      child: Center(
                                        child: Text(
                                          e.points[index].toString(),
                                          style: TextStyle(
                                            color: e.points[index] < 0
                                                ? Colors.red
                                                : (e.points[index] == 0
                                                    ? Colors.grey
                                                    : Colors.green),
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    Row(
                      children: [
                        ...users.map((e) => Expanded(
                              child: Center(
                                child: Text(
                                  e.total.toString(),
                                  style: TextStyle(
                                    color: e.total < 0
                                        ? Colors.red
                                        : (e.total == 0
                                            ? Colors.grey
                                            : Colors.green),
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // IMENA
          if (userWidgets.isNotEmpty)
            Positioned(
              top: leftFromTop + (m * cardK * 0.5),
              left: 10,
              height: m * cardK,
              child: userWidgets[0],
            ),
          if (userWidgets.length >= 2)
            Positioned(
              top: 10,
              left: topFromLeft + (m * cardK * 0.25),
              height: m * cardK,
              child: userWidgets[1],
            ),
          if (userWidgets.length >= 3)
            Positioned(
              top: leftFromTop + (m * cardK * 0.5),
              left: topFromLeft + (m * cardK * 1.6),
              height: m * cardK,
              child: userWidgets[2],
            ),

          // ŠTIHI
          ...stih.map((e) {
            if (e.position == 0) {
              return Positioned(
                top: leftFromTop,
                left: topFromLeft - (m * cardK * 0.5),
                height: m * cardK,
                child: Transform.rotate(angle: pi / 2, child: e.widget),
              );
            } else if (e.position == 1) {
              return Positioned(
                top: leftFromTop - (m * cardK * 0.5),
                left: topFromLeft,
                height: m * cardK,
                child: e.widget,
              );
            } else if (e.position == 2) {
              return Positioned(
                top: leftFromTop,
                left: topFromLeft + (m * cardK * 0.5),
                height: m * cardK,
                child: Transform.rotate(angle: pi / 2, child: e.widget),
              );
            }
            return Positioned(
              top: leftFromTop + (m * cardK * 0.5),
              left: topFromLeft,
              height: m * cardK,
              child: e.widget,
            );
          }),

          // MOJE KARTE
          ...cards.asMap().entries.map(
                (entry) => Container(
                  height: cardSize,
                  transform: Matrix4.translationValues(
                      entry.key *
                          min(
                            MediaQuery.of(context).size.width / cards.length,
                            MediaQuery.of(context).size.height * 0.15,
                          ),
                      (MediaQuery.of(context).size.height - cardSize / 1.75),
                      0),
                  child: GestureDetector(
                    onTap: () => sendCard(entry.value),
                    child: MouseRegion(
                      onEnter: (event) {
                        setState(() {
                          cards[entry.key].showZoom = true;
                        });
                      },
                      onExit: (event) {
                        setState(() {
                          cards[entry.key].showZoom = false;
                        });
                      },
                      child: AnimatedScale(
                        duration: duration,
                        scale: cards[entry.key].showZoom == true ? 1.15 : 1,
                        child: Transform.rotate(
                          angle: pi / 32,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: cardSize,
                                  width: cardWidth,
                                  child: Image.asset(
                                      "assets/tarok${entry.value.asset}.webp"),
                                ),
                                if (!turn)
                                  Container(
                                    color: Colors.red.withAlpha(100),
                                    height: cardSize,
                                    width: cardWidth,
                                  ),
                                if (turn && !cards[entry.key].valid)
                                  Container(
                                    color: Colors.red.withAlpha(100),
                                    height: cardSize,
                                    width: cardWidth,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

          // LICITIRANJE
          if (licitiranje)
            Container(
              alignment: Alignment.center,
              child: Card(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    children: [
                      const Center(
                        child: Text(
                          "Licitiranje",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          ...users.map((User user) => Expanded(
                                child: Center(
                                  child: Text(
                                    user.name,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          ...users.map((User user) => Expanded(
                                child: Center(
                                  child: Text(
                                    user.licitiral == -2
                                        ? ""
                                        : GAMES[user.licitiral + 1].name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                      if (licitiram)
                        Wrap(
                          children: [
                            ...games.map((e) => ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: suggestions.contains(e.id)
                                        ? Colors.purpleAccent.shade400
                                        : null,
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  onPressed: () => licitiranjeSend(e),
                                  child: Text(
                                    e.name,
                                  ),
                                )),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),

          // KRALJI
          if (kingSelection)
            Container(
              alignment: Alignment.center,
              child: Card(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    children: [
                      const Center(
                        child: Text(
                          "Rufanje kralja",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ...KINGS.map(
                            (king) => GestureDetector(
                              onTap: () => selectKing(king.asset),
                              child: Stack(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                5,
                                        child: Image.asset(
                                            "assets/tarok${king.asset}.webp"),
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                    ],
                                  ),
                                  if (selectedKing != king.asset && !kingSelect)
                                    Container(
                                      color: Colors.black.withAlpha(100),
                                      height:
                                          MediaQuery.of(context).size.height /
                                              5,
                                      width:
                                          MediaQuery.of(context).size.height /
                                              5 *
                                              0.55,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // TALON
          if (showTalon)
            Container(
              alignment: Alignment.center,
              child: Card(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    children: [
                      const Center(
                        child: Text(
                          "Talon",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ...talon.asMap().entries.map(
                                (stih) => GestureDetector(
                                  onTap: () => selectTalon(stih.key),
                                  child: Stack(
                                    children: [
                                      Row(
                                        children: [
                                          ...stih.value.asMap().entries.map(
                                                (entry) => Row(
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              5,
                                                      child: Image.asset(
                                                          "assets/tarok${entry.value.asset}.webp"),
                                                    ),
                                                    const SizedBox(
                                                      width: 3,
                                                    ),
                                                  ],
                                                ),
                                              )
                                        ],
                                      ),
                                      if (talonSelected != -1 &&
                                          talonSelected != stih.key)
                                        Container(
                                          color: Colors.black.withAlpha(100),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              5,
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  5 *
                                                  0.55 *
                                                  3 +
                                              stih.value.length * 3,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // NAPOVEDI
          if (predictions && currentPredictions != null)
            Container(
              alignment: Alignment.center,
              child: Card(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    children: [
                      const Center(
                        child: Text(
                          "Napovedi",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Center(
                        child: Column(
                          children: [
                            DataTable(
                              columns: const <DataColumn>[
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'Napoved',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'Napovedal',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'Kontra',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ),
                              ],
                              rows: <DataRow>[
                                DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(
                                        'Igra (${GAMES[currentPredictions!.gamemode + 1].name})')),
                                    DataCell(Text(users.map((e) {
                                      if (e.id == currentPredictions!.igra.id)
                                        return e.name;
                                      return "";
                                    }).join(""))),
                                    DataCell(
                                      Row(
                                        children: [
                                          Text(
                                              "${KONTRE[currentPredictions!.igraKontra]} (${users.map((e) {
                                            if (e.id ==
                                                currentPredictions!
                                                    .igraKontraDal
                                                    .id) return e.name;
                                            return "";
                                          }).join("")})"),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          if (myPredictions != null &&
                                              myPredictions!.igraKontra)
                                            Switch(
                                              value: kontraIgra,
                                              onChanged: (bool value) {
                                                setState(() {
                                                  if (value) {
                                                    currentPredictions!
                                                        .igraKontra++;
                                                  } else {
                                                    currentPredictions!
                                                        .igraKontra--;
                                                  }
                                                  kontraIgra = value;
                                                });
                                              },
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                DataRow(
                                  cells: <DataCell>[
                                    const DataCell(Text('Trula')),
                                    if (users.map((e) {
                                          if (e.id ==
                                              currentPredictions!.trula.id)
                                            return e.name;
                                          return "";
                                        }).join("") ==
                                        "")
                                      DataCell(
                                        Switch(
                                          value: trula,
                                          onChanged: (bool value) {
                                            setState(() {
                                              trula = value;
                                            });
                                          },
                                        ),
                                      )
                                    else
                                      DataCell(Text(users.map((e) {
                                        if (e.id ==
                                            currentPredictions!.trula.id)
                                          return e.name;
                                        return "";
                                      }).join(""))),
                                    const DataCell(
                                      Row(
                                        children: [
                                          Text("/"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                DataRow(
                                  cells: <DataCell>[
                                    const DataCell(Text('Kralji')),
                                    if (users.map((e) {
                                          if (e.id ==
                                              currentPredictions!.kralji.id)
                                            return e.name;
                                          return "";
                                        }).join("") ==
                                        "")
                                      DataCell(
                                        Switch(
                                          value: kralji,
                                          onChanged: (bool value) {
                                            setState(() {
                                              kralji = value;
                                            });
                                          },
                                        ),
                                      )
                                    else
                                      DataCell(Text(users.map((e) {
                                        if (e.id ==
                                            currentPredictions!.kralji.id)
                                          return e.name;
                                        return "";
                                      }).join(""))),
                                    const DataCell(
                                      Row(
                                        children: [
                                          Text("/"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                DataRow(
                                  cells: <DataCell>[
                                    const DataCell(Text('Pagat ultimo')),
                                    if (myPredictions != null &&
                                        myPredictions!.pagatUltimo)
                                      DataCell(
                                        Switch(
                                          value: pagatUltimo,
                                          onChanged: (bool value) {
                                            setState(() {
                                              pagatUltimo = value;
                                            });
                                          },
                                        ),
                                      )
                                    else
                                      DataCell(Text(users.map((e) {
                                        if (e.id ==
                                            currentPredictions!.pagatUltimo.id)
                                          return e.name;
                                        return "";
                                      }).join(""))),
                                    DataCell(
                                      Row(
                                        children: [
                                          Text(
                                              "${KONTRE[currentPredictions!.pagatUltimoKontra]} (${users.map((e) {
                                            if (e.id ==
                                                currentPredictions!
                                                    .pagatUltimoKontraDal
                                                    .id) return e.name;
                                            return "";
                                          }).join("")})"),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          if (myPredictions != null &&
                                              myPredictions!.pagatUltimoKontra)
                                            Switch(
                                              value: kontraPagat,
                                              onChanged: (bool value) {
                                                setState(() {
                                                  if (value) {
                                                    currentPredictions!
                                                        .pagatUltimoKontra++;
                                                  } else {
                                                    currentPredictions!
                                                        .pagatUltimoKontra--;
                                                  }
                                                  kontraPagat = value;
                                                });
                                              },
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                DataRow(
                                  cells: <DataCell>[
                                    const DataCell(Text('Kralj ultimo')),
                                    if (myPredictions != null &&
                                        myPredictions!.kraljUltimo)
                                      DataCell(
                                        Switch(
                                          value: kraljUltimo,
                                          onChanged: (bool value) {
                                            setState(() {
                                              kraljUltimo = value;
                                            });
                                          },
                                        ),
                                      )
                                    else
                                      DataCell(Text(users.map((e) {
                                        if (e.id ==
                                            currentPredictions!.kraljUltimo.id)
                                          return e.name;
                                        return "";
                                      }).join(""))),
                                    DataCell(
                                      Row(
                                        children: [
                                          Text(
                                              "${KONTRE[currentPredictions!.kraljUltimoKontra]} (${users.map((e) {
                                            if (e.id ==
                                                currentPredictions!
                                                    .kraljUltimoKontraDal
                                                    .id) return e.name;
                                            return "";
                                          }).join("")})"),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          if (myPredictions != null &&
                                              myPredictions!.kraljUltimoKontra)
                                            Switch(
                                              value: kontraKralj,
                                              onChanged: (bool value) {
                                                setState(() {
                                                  if (value) {
                                                    currentPredictions!
                                                        .kraljUltimoKontra++;
                                                  } else {
                                                    currentPredictions!
                                                        .kraljUltimoKontra--;
                                                  }
                                                  kontraKralj = value;
                                                });
                                              },
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                DataRow(
                                  cells: <DataCell>[
                                    const DataCell(Text('Barvni valat')),
                                    if (myPredictions != null &&
                                        myPredictions!.barvniValat)
                                      DataCell(
                                        Switch(
                                          value: barvic,
                                          onChanged: (bool value) {
                                            setState(() {
                                              barvic = value;
                                            });
                                          },
                                        ),
                                      )
                                    else
                                      DataCell(Text(users.map((e) {
                                        if (e.id ==
                                            currentPredictions!.barvniValat.id)
                                          return e.name;
                                        return "";
                                      }).join(""))),
                                    DataCell(
                                      Row(
                                        children: [
                                          Text(
                                              "${KONTRE[currentPredictions!.barvniValatKontra]} (${users.map((e) {
                                            if (e.id ==
                                                currentPredictions!
                                                    .barvniValatKontraDal
                                                    .id) return e.name;
                                            return "";
                                          }).join("")})"),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          if (myPredictions != null &&
                                              myPredictions!.barvniValatKontra)
                                            Switch(
                                              value: kontraBarvic,
                                              onChanged: (bool value) {
                                                setState(() {
                                                  if (value) {
                                                    currentPredictions!
                                                        .barvniValatKontra++;
                                                  } else {
                                                    currentPredictions!
                                                        .barvniValatKontra--;
                                                  }
                                                  kontraBarvic = value;
                                                });
                                              },
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                DataRow(
                                  cells: <DataCell>[
                                    const DataCell(Text('Valat')),
                                    if (myPredictions != null &&
                                        myPredictions!.valat)
                                      DataCell(
                                        Switch(
                                          value: valat,
                                          onChanged: (bool value) {
                                            setState(() {
                                              valat = value;
                                            });
                                          },
                                        ),
                                      )
                                    else
                                      DataCell(Text(users.map((e) {
                                        if (e.id ==
                                            currentPredictions!.valat.id)
                                          return e.name;
                                        return "";
                                      }).join(""))),
                                    DataCell(
                                      Row(
                                        children: [
                                          Text(
                                              "${KONTRE[currentPredictions!.valatKontra]} (${users.map((e) {
                                            if (e.id ==
                                                currentPredictions!
                                                    .valatKontraDal
                                                    .id) return e.name;
                                            return "";
                                          }).join("")})"),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          if (myPredictions != null &&
                                              myPredictions!.valatKontra)
                                            Switch(
                                              value: kontraValat,
                                              onChanged: (bool value) {
                                                setState(() {
                                                  if (value) {
                                                    currentPredictions!
                                                        .valatKontra++;
                                                  } else {
                                                    currentPredictions!
                                                        .valatKontra--;
                                                  }
                                                  kontraValat = value;
                                                });
                                              },
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (startPredicting)
                              ElevatedButton(
                                onPressed: predict,
                                child: const Text(
                                  "Napovej",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // REZULTATI IGRE
          if (results != null)
            Container(
              alignment: Alignment.center,
              child: Card(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    children: [
                      const Center(
                        child: Text(
                          "Rezultati igre",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataTable(
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Napoved',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Kontra',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Rezultat',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                        ],
                        rows: <DataRow>[
                          DataRow(
                            cells: <DataCell>[
                              const DataCell(Text('Igra')),
                              DataCell(Text('${pow(2, results!.kontraIgra)}x')),
                              DataCell(Text(
                                '${results!.igra}',
                                style: TextStyle(
                                  color: results!.igra < 0
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              )),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              const DataCell(Text('Razlika')),
                              DataCell(Text('${pow(2, results!.kontraIgra)}x')),
                              DataCell(Text(
                                '${results!.razlika}',
                                style: TextStyle(
                                  color: results!.razlika < 0
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              )),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              const DataCell(Text('Trula')),
                              const DataCell(Text('1x')),
                              DataCell(Text(
                                '${results!.trula}',
                                style: TextStyle(
                                  color: results!.trula < 0
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              )),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              const DataCell(Text('Kralji')),
                              const DataCell(Text('1x')),
                              DataCell(Text(
                                '${results!.kralji}',
                                style: TextStyle(
                                  color: results!.kralji < 0
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              )),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              const DataCell(Text('Kralj ultimo')),
                              DataCell(
                                  Text('${pow(2, results!.kontraKralj)}x')),
                              DataCell(Text(
                                '${results!.kralj}',
                                style: TextStyle(
                                  color: results!.kralj < 0
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              )),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              const DataCell(Text('Pagat ultimo')),
                              DataCell(
                                  Text('${pow(2, results!.kontraPagat)}x')),
                              DataCell(Text(
                                '${results!.pagat}',
                                style: TextStyle(
                                  color: results!.pagat < 0
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              )),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              const DataCell(Text('Skupaj')),
                              const DataCell(Text('')),
                              DataCell(Text(
                                '${results!.points}',
                                style: TextStyle(
                                  color: results!.points < 0
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              )),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: !(started && !widget.bots)
          ? FloatingActionButton(
              onPressed: () => Navigator.pop(context),
              tooltip: 'Zapusti igro',
              child: const Icon(Icons.close),
            )
          : const SizedBox(),
    );
  }
}
