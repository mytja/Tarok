import 'dart:convert';
import 'dart:developer';
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
  List<String> cardStih = [];
  List<Widget> userWidgets = [];
  List<User> userPosition = [];
  List<LocalGame> games = GAMES.map((o) => o.copyWith()).toList();
  List<int> suggestions = [];
  Map<int, bool> stihBoolValues = {};

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
  bool zaruf = false;
  bool gameDone = false;
  bool requestedGameEnd = false;
  int myPosition = 0;
  int stashAmount = 0;
  int talonSelected = -1;
  String selectedKing = "";
  String userHasKing = "";
  Messages.StartPredictions? myPredictions;
  Messages.Predictions? currentPredictions;
  Messages.Results? results;
  LocalCard? premovedCard;
  double eval = 0.0;
  int sinceLastPrediction = 0;

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

  late stockskis.StockSkis stockskisContext;

  WebSocket websocketConnection(String gameId) {
    const timeout = Duration(seconds: 10);
    final uri = Uri.parse('$WS_URL/$gameId');
    debugPrint("requesting to $uri");
    final socket = WebSocket(
      uri,
      binaryType: "arraybuffer",
      timeout: timeout,
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

  void gameEndSend() {
    debugPrint("Called gameEndSend");
    if (widget.bots) return;
    debugPrint("Sending the GameEnd packet");
    requestedGameEnd = true;
    final Uint8List message =
        Messages.Message(gameEnd: Messages.GameEnd(request: Messages.Request()))
            .writeToBuffer();
    websocket.send(message);
    debugPrint("Sent the GameEnd packet");
  }

  void validCards() {
    if (stash) {
      for (int i = 0; i < cards.length; i++) {
        cards[i].valid = cards[i].worth != 5;
      }
      return;
    }

    int gamemode = -1;
    for (int i = 0; i < users.length; i++) {
      User user = users[i];
      gamemode = max(gamemode, user.licitiral);
    }
    int taroki = 0;
    bool imaBarvo = false;
    bool imaVecje = false;
    int maxWorthOver = 0;
    for (int i = 0; i < CARDS.length; i++) {
      if (!cardStih.contains(CARDS[i].asset)) continue;
      maxWorthOver = max(maxWorthOver, CARDS[i].worthOver);
    }

    if (firstCard == null) {
      for (int i = 0; i < cards.length; i++) {
        cards[i].valid = true;
        if (gamemode == -1 || gamemode == 6) {
          if (cards[i].asset == "/taroki/pagat" && cards.length != 1) {
            cards[i].valid = false;
          }
        }
      }
      return;
    }

    final color = firstCard!.asset.split("/")[1];

    for (int i = 0; i < cards.length; i++) {
      cards[i].valid = false;
      if (cards[i].asset.contains("taroki")) taroki++;
      if (cards[i].asset.contains(color)) imaBarvo = true;
    }

    for (int i = 0; i < cards.length; i++) {
      if (imaBarvo && !cards[i].asset.contains(color)) continue;
      if (cards[i].worthOver > maxWorthOver) imaVecje = true;
      if (imaVecje) break;
    }

    debugPrint(
        "taroki=$taroki imaBarvo=$imaBarvo imaVecje=$imaVecje maxWorthOver=$maxWorthOver gamemode=$gamemode cardStih=$cardStih");

    if (firstCard!.asset.contains("taroki")) {
      for (int i = 0; i < cards.length; i++) {
        if (gamemode == -1 || gamemode == 6) {
          if (imaVecje && cards[i].worthOver < maxWorthOver) continue;
          if (cards[i].asset == "/taroki/pagat" && taroki > 1) continue;
          cards[i].valid = true;
        }
        if (taroki == 0 || cards[i].asset.contains("taroki")) {
          cards[i].valid = true;
        }
      }
    } else {
      for (int i = 0; i < cards.length; i++) {
        if ((!imaBarvo && taroki == 0) ||
            (!imaBarvo && taroki > 0 && cards[i].asset.contains("taroki")) ||
            (imaBarvo &&
                !cards[i].asset.contains("taroki") &&
                cards[i].asset.contains(color))) {
          // STANDARDNO
          // Sedaj pa za različne gamemode
          if (gamemode == -1 || gamemode == 6) {
            if (imaVecje && cards[i].worthOver < maxWorthOver) continue;
            if (cards[i].asset == "/taroki/pagat" && taroki > 1) continue;
          }
          cards[i].valid = true;
        }
      }
    }
  }

  void stashCard(LocalCard card) {
    if (card.worth == 5) return; // ne mormo si založit kraljev in trule
    stashedCards.add(card);
    cards.remove(card);
    setState(() {});
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
        bPlay(users.length - 1); // obvezni
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
    if (kraljUltimo) {
      currentPredictions!.kraljUltimo = Messages.User(id: playerId);
    }
    if (pagatUltimo) {
      currentPredictions!.pagatUltimo = Messages.User(id: playerId);
    }
    if (valat) currentPredictions!.valat = Messages.User(id: playerId);
    if (barvic) currentPredictions!.barvniValat = Messages.User(id: playerId);

    // kontre dal
    if (kontraKralj) {
      currentPredictions!.kraljUltimoKontraDal = Messages.User(id: playerId);
    }
    if (kontraPagat) {
      currentPredictions!.pagatUltimoKontraDal = Messages.User(id: playerId);
    }
    if (kontraValat) {
      currentPredictions!.valatKontraDal = Messages.User(id: playerId);
    }
    if (kontraBarvic) {
      currentPredictions!.barvniValatKontraDal = Messages.User(id: playerId);
    }
    if (kontraIgra) {
      currentPredictions!.igraKontraDal = Messages.User(id: playerId);
    }

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

    if (widget.bots) {
      if (currentPredictions!.changed) sinceLastPrediction = 1;
      resetPredictions();
      currentPredictions!.changed = false;
      stockskisContext.predictions = currentPredictions!;
      setState(() {});
      bPredict(afterPlayer());
      return;
    }

    final Uint8List message =
        Messages.Message(predictions: currentPredictions!).writeToBuffer();
    websocket.send(message);
    startPredicting = false;
    myPredictions = null;
  }

  int afterPlayer() {
    for (int i = 0; i < stockskisContext.userPositions.length; i++) {
      if (stockskisContext.userPositions[i].id == "player") {
        if (i == stockskisContext.userPositions.length - 1) {
          return 0;
        } else {
          return i + 1;
        }
      }
    }
    return 0;
  }

  void klopTalon() {
    if (stockskisContext.gamemode == -1 && stockskisContext.talon.isNotEmpty) {
      stockskis.Card card = stockskisContext.talon.first;
      stockskisContext.talon.removeAt(0);
      cardStih.add(card.card.asset);
      stih.add(CardWidget(
        position: 100,
        widget: Image.asset("assets/tarok${card.card.asset}.webp"),
      ));
      setState(() {});
    }
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
          if (stockskisContext.stihi.last.isEmpty) {
            firstCard = skisCards[i].card;
          }
          stockskisContext.stihi.last.add(skisCards[i]);
          stockskisContext.users["player"]!.cards.removeAt(i);
          break;
        }
      }
      cards.remove(card);

      turn = false;
      addToStih("player", "player", card.asset);
      setState(() {});

      if (stockskisContext.stihi.last.length == stockskisContext.users.length) {
        klopTalon();
        await Future.delayed(const Duration(seconds: 1), () {
          print("Cleaning");
          List<stockskis.Card> zadnjiStih = stockskisContext.stihi.last;
          String pickedUpBy = stockskisContext.stihPickedUpBy(zadnjiStih);
          int k = 0;
          for (int i = 1; i < userPosition.length; i++) {
            if (userPosition[i].id == pickedUpBy) {
              k = i;
              break;
            }
          }

          int translatedK = stockskisContext.translatePositionToQueue(k);

          // preveri, kdo je dubu ta štih in naj on začne
          stih = [];
          cardStih = [];
          stihBoolValues = {};
          firstCard = null;
          stockskisContext.stihi.add([]);
          setState(() {});
          validCards();
          bPlay(translatedK);
        });
        return;
      }

      int next = afterPlayer();
      int translatedNext = stockskisContext.translatePositionToQueue(next);
      debugPrint("Next $next w/ $translatedNext");
      bPlay(translatedNext);

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
      int next = afterPlayer();
      setState(() {});
      bLicitate(next);
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
      stashedCards = [];
      kingSelect = false;
      kingSelection = false;
      print(stashAmount);
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
      stockskisContext.selectSecretlyPlaying(king);
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

  bool isPlayerMandatory(String playerId) {
    return userPosition.last.id == playerId;
  }

  void bLicitate(int startAt) async {
    licitiranje = true;

    int onward = 0;
    int notVoted = 0;
    for (int i = 0; i < users.length; i++) {
      if (users[i].licitiral == -1) onward++;
      if (users[i].licitiral == -2) notVoted++;
    }
    debugPrint("onward: $onward");
    if (onward >= users.length - 1 && notVoted == 0) {
      int m = -1;
      for (int i = 0; i < users.length; i++) {
        if (m < users[i].licitiral) {
          m = users[i].licitiral;
          stockskisContext.users[users[i].id]!.playing = true;
          stockskisContext.users[users[i].id]!.secretlyPlaying = true;
          stockskisContext.users[users[i].id]!.licitiral = true;
          stockskisContext.gamemode = m;
          if (m > -1 && m < 3) {
            stockskisContext.kingFallen = false;
          } else {
            stockskisContext.kingFallen = true;
          }
          debugPrint("set the game to ${users[i].id} using method 1");
          currentPredictions!.igra = Messages.User(
            id: users[i].id,
            name: users[i].name,
          );
          currentPredictions!.gamemode = m;
          stockskisContext.predictions = currentPredictions!;
          licitiranje = false;
          bKingSelect(users[i].id);
          break;
        }
      }
      return;
    }

    for (int i = startAt; i < userPosition.length; i++) {
      User user = userPosition[i];
      bool isMandatory = i == userPosition.length - 1;

      if (user.id == "player") {
        bool jeLicitiral = false;
        for (int n = 0; n < users.length; n++) {
          if (users[n].id == "player") {
            jeLicitiral = users[n].licitiral == -1;
          }
        }
        if (jeLicitiral) continue;
        licitiram = true;
        suggestions = stockskisContext.suggestModes(
          user.id,
          canLicitateThree: isMandatory,
        );
        return;
      }

      await Future.delayed(const Duration(seconds: 1), () {
        setState(() {});
      });

      List<int> botSuggestions = stockskisContext.suggestModes(
        user.id,
        canLicitateThree: isMandatory,
      );
      for (int n = 0; n < users.length; n++) {
        // preskočimo bote, ki so že licitirali
        if (users[n].licitiral == -1) continue;

        // preprečimo, da bi se boti kregali med sabo
        int onward = 0;
        int notVoted = 0;
        for (int i = 0; i < users.length; i++) {
          if (users[i].licitiral == -1) onward++;
          if (users[i].licitiral == -2) notVoted++;
        }
        if (onward >= users.length - 1 && notVoted == 0) {
          debugPrint("set the game to ${users[n].id}");
          currentPredictions!.igra = Messages.User(
            id: users[n].id,
            name: users[n].name,
          );
          stockskisContext.predictions = currentPredictions!;
          bKingSelect(users[n].id);
          return;
        }

        if (users[n].id == user.id) {
          if (botSuggestions.isEmpty) {
            users[n].licitiral = -1;
          } else {
            bool canLicitate = true;
            for (int i = 0; i < users.length; i++) {
              if (users[i].licitiral > botSuggestions.last) {
                canLicitate = false;
                break;
              } else if (users[i].licitiral >= botSuggestions.last &&
                  !isMandatory) {
                canLicitate = false;
                break;
              }
            }
            if (canLicitate) {
              users[n].licitiral = botSuggestions.last;
              removeInvalidGames(
                "player",
                botSuggestions.last,
                shraniLicitacijo: false,
                imaPrednost: isPlayerMandatory("player"),
              );
            } else {
              users[n].licitiral = -1;
            }
          }
        }
      }
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
        stockskisContext.users[users[i].id]!.licitiral = true;
        stockskisContext.gamemode = m;
        currentPredictions!.gamemode = m;
        return m;
      }
    }
    return m;
  }

  void bStartGame() async {
    logger.d("bStartGame() called");

    selectedKing = "";
    licitiranje = true;
    licitiram = false;
    userHasKing = "";
    selectedKing = "";
    firstCard = null;
    results = null;
    talonSelected = -1;
    zaruf = false;
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
    stihBoolValues = {};

    if (users.isEmpty) {
      logger.d("users.isEmpty");

      Map<String, stockskis.User> stockskisUsers = {};
      List<String> botNames = BOT_NAMES.toList();
      String botsStr = await storage.read(key: "bots") ?? "[]";
      List bots = jsonDecode(botsStr);
      int l = bots.length;
      for (int i = 1; i < widget.playing; i++) {
        String botType = "normal";
        String botName = botNames[Random().nextInt(botNames.length)];
        if (l >= widget.playing - 1) {
          int t = Random().nextInt(bots.length);
          botName = bots[t]["name"];
          botType = bots[t]["type"];
          bots.removeAt(t);
        } else {
          botNames.remove(botName);
        }
        String botId = "bot$i";
        stockskisUsers[botId] = stockskis.User(
          cards: [],
          user: User(id: botId, name: botName),
          playing: false,
          secretlyPlaying: false,
          botType: botType,
          licitiral: false,
        );
        User user = User(id: botId, name: botName);
        users.add(user);
      }
      stockskisUsers["player"] = stockskis.User(
        cards: [],
        user: User(id: "player", name: "Igralec"),
        playing: false,
        secretlyPlaying: false,
        botType: "NAB", // not a bot
        licitiral: false,
      );
      User user = User(id: "player", name: "Igralec");
      users.add(user);
      stockskisContext = stockskis.StockSkis(
        users: stockskisUsers,
        stihiCount: ((54 - 6) / widget.playing).floor(),
        predictions: Messages.Predictions(),
      );
    } else {
      // naslednja igra, samo resetiramo vrednosti pri sedanjih botih
      stockskisContext.resetContext();
      logger.d("[bStartGame] stockskisContext.resetContext() called");
    }

    logger.i(
      {
        "userPosition": userPosition.map((e) => '${e.id}/${e.name}').join(' '),
        "users": users.map((e) => '${e.id}/${e.name}').join(' '),
      },
    );

    currentPredictions = Messages.Predictions();
    stockskisContext.doRandomShuffle();
    List<stockskis.Card> myCards = stockskisContext.users["player"]!.cards;
    cards = myCards.map((card) => card.card).toList();
    userPosition = stockskisContext.userPositions;
    users = stockskisContext.userQueue;
    stockskisContext.selectedKing = "";

    // to mormo inicializirati tle
    // trust me, ich habe a gut reason ich kann nicht explain
    userWidgets = [];
    for (int i = 1; i < userPosition.length; i++) {
      userWidgets.add(
        Text(userPosition[i].name, style: const TextStyle(fontSize: 20)),
      );
    }

    logger.i(
      {
        "userPosition": userPosition.map((e) => '${e.id}/${e.name}').join(' '),
        "users": users.map((e) => '${e.id}/${e.name}').join(' '),
      },
    );

    resetPredictions();
    sinceLastPrediction = 0;
    //users = [];
    //for (int i = 0; i < userPosition.length; i++) {
    //  users.add(userPosition[i]);
    //}
    sortCards();
    turn = false;
    started = true;

    if (!isPlayerMandatory("player")) {
      games.removeAt(1);
    }

    setState(() {});
    bLicitate(stockskisContext.translateQueueToPosition(0));
  }

  void bSetPointsResults() {
    for (int i = 0; i < users.length; i++) {
      users[i].points.add(0);
    }
    for (int i = 0; i < users.length; i++) {
      String id = users[i].id;
      int result = 0;
      for (int n = 0; n < results!.user.length; n++) {
        Messages.ResultsUser result = results!.user[n];
        bool found = false;
        for (int k = 0; k < result.user.length; k++) {
          Messages.User user = result.user[k];
          if (user.id != id) continue;
          found = true;
          break;
        }
        if (!found) continue;
        users[i].points.last += result.points;
        users[i].total += result.points;
      }
    }
  }

  void bResults() async {
    debugPrint("Gamemode stockškis konteksta je ${stockskisContext.gamemode}");
    if (stockskisContext.gamemode >= 6) {
      for (int i = 0; i < users.length; i++) {
        users[i].radlci++;
        debugPrint("Dodajam radlce ${users[i].id}");
      }
    }
    results = stockskisContext.calculateGame();
    bSetPointsResults();
    setState(() {});
    await Future.delayed(const Duration(seconds: 10), () {
      bStartGame();
    });
  }

  void bPlay(int startAt) async {
    licitiram = false;
    licitiranje = false;
    showTalon = false;
    predictions = false;
    myPredictions = null;
    int i = startAt;
    while (true) {
      if (i >= stockskisContext.users.length) i = 0;
      int translated = stockskisContext.translateQueueToPosition(i);
      User pos = stockskisContext.userPositions[translated];
      debugPrint(
        "Card length: ${stockskisContext.users[pos.id]!.cards.length}; User: ${pos.id}/${pos.name}; i: $i; translated: $translated",
      );
      if (stockskisContext.users[pos.id]!.cards.isEmpty) {
        debugPrint("Calculating results");
        bResults();
        return;
      }
      if (pos.id == "player") {
        turn = true;
        validCards();
        setState(() {});
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
      if (stockskisContext.stihi.last.isEmpty) firstCard = bestMove.card.card;
      stockskisContext.stihi.last.add(bestMove.card);
      stockskisContext.users[pos.id]!.cards.remove(bestMove.card);
      await Future.delayed(const Duration(milliseconds: 500), () async {});
      if (await addToStih(pos.id, "player", bestMove.card.card.asset)) return;
      i++;
      setState(() {});
      if (stockskisContext.stihi.last.length == stockskisContext.users.length) {
        if (zaruf) {
          List<stockskis.Card> zadnjiStih = stockskisContext.stihi.last;
          stockskis.StihAnalysis? analysis =
              stockskisContext.analyzeStih(zadnjiStih);
          if (analysis == null) throw Exception("Štih is empty");
          bool found = false;
          for (int i = 0; i < zadnjiStih.length; i++) {
            stockskis.Card karta = zadnjiStih[i];
            if (karta.card.asset == selectedKing &&
                analysis.cardPicks.card.asset == selectedKing) {
              found = true;
              break;
            }
          }
          if (found) {
            for (int i = 0; i < stockskisContext.talon.length; i++) {
              stockskis.Card karta = stockskisContext.talon[0];
              karta.user = analysis.cardPicks.user;
              stockskisContext.stihi[0].add(karta);
              stockskisContext.talon.removeAt(0);
            }
            debugPrint("Talon je bil dodeljen zarufancu");
          }
        }

        klopTalon();

        await Future.delayed(const Duration(seconds: 1), () {
          List<stockskis.Card> zadnjiStih = stockskisContext.stihi.last;
          if (zadnjiStih.isEmpty) return;
          String pickedUpBy = stockskisContext.stihPickedUpBy(zadnjiStih);
          int k = 0;
          for (int i = 1; i < userPosition.length; i++) {
            if (userPosition[i].id == pickedUpBy) {
              k = i;
              break;
            }
          }
          final analysis = stockskisContext.analyzeStih(zadnjiStih);
          debugPrint(
            "Cleaning. Picked up by $pickedUpBy. ${analysis!.cardPicks.card.asset}/${analysis.cardPicks.user}",
          );

          // preveri, kdo je dubu ta štih in naj on začne
          stih = [];
          cardStih = [];
          stihBoolValues = {};
          firstCard = null;
          stockskisContext.stihi.add([]);
          setState(() {});
          validCards();
          bPlay(stockskisContext.translatePositionToQueue(k));
        });
        return;
      }
    }
  }

  void bPredict(int start) async {
    kingSelection = false;
    kingSelect = false;
    showTalon = false;
    licitiram = false;
    licitiranje = false;
    predictions = true;
    startPredicting = false;

    debugPrint("bPredict");
    int game = getPlayedGame();
    if (game == -1) {
      firstCard = null;
      bPlay(users.length - 1);
      return;
    }
    int k = start;
    setState(() {});

    while (true) {
      if (sinceLastPrediction > widget.playing) {
        logger.i("Gamemode: ${stockskisContext.gamemode}");
        if (stockskisContext.gamemode >= 6) {
          bPlay(stockskisContext
              .translatePositionToQueue(stockskisContext.playingPerson()));
          return;
        }
        bPlay(users.length - 1);
        return;
      }
      User u = stockskisContext.userPositions[k];
      debugPrint(
          "User with ID ${u.id}. k=$k, sinceLastPrediction=$sinceLastPrediction");
      if (u.id == "player") {
        myPredictions = stockskisContext.getStartPredictions();
        startPredicting = true;
        setState(() {});
        return;
      }
      k++;
      if (k >= stockskisContext.userPositions.length) k = 0;
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 500), () {});
      sinceLastPrediction++;
    }
  }

  void bTalon(String playerId) async {
    debugPrint("Talon");
    int game = getPlayedGame();
    if (game == -1 || game >= 6) {
      bPredict(stockskisContext.playingPerson());
      return;
    }
    debugPrint("Talon1");
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
        if (stockskisContext.talon[k].card.asset == selectedKing) {
          zaruf = true;
        }
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
      stockskis.Card s = selectedCards[i];
      stockskisContext.talon.remove(s);
      s.user = playerId;
      stockskisContext.users[playerId]!.cards.add(s);
    }
    String king = selectedKing == "" ? "" : selectedKing.split("/")[1];
    List<stockskis.Card> stash =
        stockskisContext.stashCards(playerId, (6 / m).round(), king);
    for (int i = 0; i < stash.length; i++) {
      stockskis.Card s = stash[i];
      stockskisContext.users[playerId]!.cards.remove(s);
      s.user = playerId;
      stockskisContext.stihi[0].add(stash[i]);
    }
    stockskisContext.stihi.add([]);
    setState(() {});
    firstCard = null;
    await Future.delayed(const Duration(seconds: 2), () {
      bPredict(stockskisContext.playingPerson());
    });
  }

  void bKingSelect(String playerId) async {
    int game = getPlayedGame();
    if (game == -1 || game >= 3 || userPosition.length == 3) {
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
      stockskisContext.selectSecretlyPlaying(selectedKing);
      bTalon(playerId);
      setState(() {});
    });
  }

  void removeInvalidGames(String playerId, int l,
      {bool shraniLicitacijo = true, bool imaPrednost = false}) {
    for (int i = 0; i < users.length; i++) {
      if (users[i].id != playerId) continue;
      if (shraniLicitacijo) users[i].licitiral = l;
      if (l == -1) break;
      for (int n = 1; n < games.length; i++) {
        if (games[1].id >= l && imaPrednost) break;
        if (games[1].id > l) break;
        games.removeAt(1);
      }
      break;
    }
  }

  Future<bool> addToStih(
      String msgPlayerId, String playerId, String card) async {
    if (card == selectedKing) {
      if (widget.bots) stockskisContext.revealKing(msgPlayerId);
      userHasKing = msgPlayerId;
    }
    List<User> after = [];
    List<User> before = [];
    if (widget.bots) myPosition = stockskisContext.getPlayer();
    debugPrint("My position: $myPosition");
    for (int i = myPosition + 1; i < users.length; i++) {
      after.add(users[i]);
    }
    for (int i = 0; i < myPosition; i++) {
      before.add(users[i]);
    }
    List<User> allUsers = [...after, ...before, users[myPosition]];
    cardStih.add(card);
    //print(allUsers);
    for (int i = 0; i < allUsers.length; i++) {
      final user = allUsers[i];
      if (user.id != msgPlayerId) continue;
      int position = user.id == playerId ? 3 : i;
      stih.add(CardWidget(
        position: position,
        widget: Image.asset("assets/tarok$card.webp"),
      ));
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 20), () {
        stihBoolValues[position] = true;
        setState(() {});
      });
      break;
    }
    if (widget.bots) {
      eval = stockskisContext.evaluateGame();
      debugPrint("Trenutna evaluacija igre je $eval. Kralj je $userHasKing.");
      bool canGameEndEarly = stockskisContext.canGameEndEarly();
      if (canGameEndEarly) {
        await Future.delayed(const Duration(milliseconds: 500), () async {
          bResults();
        });
        return true;
      }
    }
    return false;
  }

  void resetPredictions() {
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
  }

  @override
  void initState() {
    // BOTI - OFFLINE
    if (widget.bots) {
      playerId = "player";
      bStartGame();
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
            websocket.close();
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
          userHasKing = "";
          selectedKing = "";
          firstCard = null;
          results = null;
          games = GAMES.map((o) => o.copyWith()).toList();

          for (int i = 0; i < users.length; i++) {
            users[i].licitiral = -2;
            users[i].endGame = false;
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
          stihBoolValues = {};

          // ignore: prefer_typing_uninitialized_variables
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
            users.add(userPosition[i]);
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
            User user = userPosition[i];
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
          removeInvalidGames(player, l);
        } else if (msg.hasLicitiranjeStart()) {
          // this packet is sent when it's user's time to licitate
          licitiram = true;
        } else if (msg.hasClearDesk()) {
          stih = [];
          cardStih = [];
          stihBoolValues = {};
          firstCard = null;
          validCards();
        } else if (msg.hasResults()) {
          final r = msg.results;
          results = r;
          for (int n = 0; n < users.length; n++) {
            users[n].points.add(0);
          }
          for (int i = 0; i < r.user.length; i++) {
            final user = r.user[i];
            for (int k = 0; k < user.user.length; k++) {
              Messages.User u = user.user[k];
              for (int n = 0; n < users.length; n++) {
                if (users[n].id != u.id) continue;
                users[n].points.last += user.points;
                users[n].total += user.points;
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
          resetPredictions();
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
      onError: (error) => debugPrint(error),
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
        MediaQuery.of(context).size.width * 0.2,
      ),
      MediaQuery.of(context).size.height * 0.5,
    );
    final cardWidth = cardSize * 0.55;
    const duration = Duration(milliseconds: 200);
    final m = min(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    const cardK = 0.5;
    final topFromLeft = MediaQuery.of(context).size.width * 0.35;
    final leftFromTop = MediaQuery.of(context).size.height * 0.35;

    return Scaffold(
      body: Stack(
        children: [
          // REZULTATI
          Container(
            alignment: Alignment.topRight,
            child: Card(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width / 4,
                child: Column(
                  children: [
                    const Center(
                      child: Text(
                        "Rezultati",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
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
                    Row(
                      children: [
                        ...users.map((User user) => Expanded(
                              child: Center(
                                child: Text(
                                  "${user.radlci}",
                                  style: const TextStyle(
                                    color: Colors.grey,
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

          Positioned(
            top: 0,
            left: 0,
            child: Container(
              margin: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 3)),
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    width: 25,
                    color: Colors.white,
                  ),
                  AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    color: Colors.black,
                    height: MediaQuery.of(context).size.height /
                        3 *
                        max(0, min(1, 1 - eval / 2)),
                    width: 25,
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).size.height / 3 + 25,
            left: 20,
            child: Text(
              (eval).toStringAsFixed(1),
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

          for (int i = 1; i < userPosition.length; i++)
            Positioned(
              top: (i - 1 == 0 || i - 1 == 2)
                  ? leftFromTop + (m * cardK * 0.5) - 50
                  : 10,
              left: (i - 1 == 0)
                  ? 10
                  : (i - 1 == 1)
                      ? topFromLeft + (m * cardK * 0.25) + 100
                      : topFromLeft + (m * cardK * 1.6),
              child: Row(
                children: [
                  if (userPosition[i].licitiral >= 0)
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: Card(
                        child: Center(
                          child: Text(
                              GAME_DESC[userPosition[i].licitiral >= 8
                                  ? userPosition[i].licitiral - 1
                                  : userPosition[i].licitiral],
                              style: const TextStyle(fontSize: 30)),
                        ),
                      ),
                    ),
                  if ((userPosition[i].licitiral >= 0 &&
                          userPosition[i].licitiral < 3 &&
                          selectedKing != "") ||
                      userHasKing == userPosition[i].id)
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: Card(
                        child: Center(
                          child: Text(
                              selectedKing == "/pik/kralj"
                                  ? "♠️"
                                  : (selectedKing == "/src/kralj"
                                      ? "❤️"
                                      : (selectedKing == "/kriz/kralj"
                                          ? "♣️"
                                          : "♦️")),
                              style: const TextStyle(fontSize: 30)),
                        ),
                      ),
                    ),
                  if (userPosition[i].licitiral >= 0 && zaruf)
                    const SizedBox(
                      width: 50,
                      height: 50,
                      child: Card(
                        child: Center(
                          child: Text("Z", style: TextStyle(fontSize: 30)),
                        ),
                      ),
                    ),
                ],
              ),
            ),

          /*
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            top: leftFromTop,
            left: stih.isEmpty ? -500 : topFromLeft - (m * cardK * 0.5),
            height: m * cardK,
            child: Transform.rotate(
              angle: pi / 2,
              child: stih.isEmpty ? const SizedBox() : stih[0].widget,
            ),
          ),
          */

          // ŠTIHI
          ...stih.map((e) {
            if (e.position == 0) {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 50),
                top: leftFromTop,
                left: stihBoolValues[0] != true
                    ? topFromLeft - (m * cardK * 0.5) - 100
                    : topFromLeft - (m * cardK * 0.5),
                height: m * cardK,
                child: Transform.rotate(
                  angle: pi / 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        10 * (MediaQuery.of(context).size.width / 1000)),
                    child: e.widget,
                  ),
                ),
              );
            } else if (e.position == 1) {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 50),
                top: stihBoolValues[1] != true
                    ? leftFromTop - (m * cardK * 0.5) - 100
                    : leftFromTop - (m * cardK * 0.5),
                left: topFromLeft,
                height: m * cardK,
                child: Transform.rotate(
                  angle: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        10 * (MediaQuery.of(context).size.width / 1000)),
                    child: e.widget,
                  ),
                ),
              );
            } else if (e.position == 2) {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 50),
                top: leftFromTop,
                left: stihBoolValues[2] != true
                    ? topFromLeft + (m * cardK * 0.5) + 100
                    : topFromLeft + (m * cardK * 0.5),
                height: m * cardK,
                child: Transform.rotate(
                  angle: pi / 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        10 * (MediaQuery.of(context).size.width / 1000)),
                    child: e.widget,
                  ),
                ),
              );
            } else if (e.position == 100) {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 50),
                top: leftFromTop,
                left: topFromLeft,
                height: m * cardK,
                child: Transform.rotate(
                  angle: pi / 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        10 * (MediaQuery.of(context).size.width / 1000)),
                    child: e.widget,
                  ),
                ),
              );
            }
            return AnimatedPositioned(
              duration: const Duration(milliseconds: 50),
              top: stihBoolValues[3] != true
                  ? leftFromTop + (m * cardK * 0.5) + 100
                  : leftFromTop + (m * cardK * 0.5),
              left: topFromLeft,
              height: m * cardK,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    10 * (MediaQuery.of(context).size.width / 1000)),
                child: e.widget,
              ),
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
                    onTap: () {
                      if (!cards[entry.key].valid) return;
                      sendCard(entry.value);
                    },
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
                        scale: cards[entry.key].showZoom == true ? 1.4 : 1,
                        child: Transform.rotate(
                          angle: pi / 32,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10 *
                                (MediaQuery.of(context).size.width / 1000)),
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: cardSize,
                                  width: cardWidth,
                                  child: Image.asset(
                                    "assets/tarok${entry.value.asset}.webp",
                                  ),
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
                                if (turn &&
                                        (currentPredictions!.pagatUltimo.id !=
                                                "" &&
                                            entry.value.asset ==
                                                "/taroki/pagat") ||
                                    (currentPredictions!.kraljUltimo.id != "" &&
                                        entry.value.asset == selectedKing))
                                  Container(
                                    color: Colors.yellow.withAlpha(70),
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
              alignment: const Alignment(-1, -1),
              child: Card(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.4,
                  width: MediaQuery.of(context).size.width / 1.33,
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          "Licitiranje",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height / 15,
                              fontWeight: FontWeight.bold),
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
                                        : GAMES[user.licitiral > 8
                                                ? user.licitiral
                                                : user.licitiral + 1]
                                            .name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                      if (licitiram)
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.33,
                          height: MediaQuery.of(context).size.height / 2,
                          child: GridView.count(
                            primary: false,
                            padding: const EdgeInsets.all(20),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 4,
                            childAspectRatio: 3,
                            children: [
                              ...games.map((e) {
                                if (userPosition.length == 3 && !e.playsThree) {
                                  return const SizedBox();
                                }
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: suggestions.contains(e.id)
                                        ? Colors.purpleAccent.shade400
                                        : null,
                                    textStyle: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              30,
                                    ),
                                  ),
                                  onPressed: () => licitiranjeSend(e),
                                  child: Text(
                                    e.name,
                                  ),
                                );
                              })
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

          // KRALJI
          if (kingSelection)
            Container(
              alignment: const Alignment(-1, -1),
              child: Card(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.4,
                  width: MediaQuery.of(context).size.width / 1.33,
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          "Rufanje kralja",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height / 15,
                              fontWeight: FontWeight.bold),
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
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10 *
                                            (MediaQuery.of(context).size.width /
                                                600)),
                                        child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              1.8,
                                          child: Image.asset(
                                              "assets/tarok${king.asset}.webp"),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                    ],
                                  ),
                                  if (selectedKing != king.asset && !kingSelect)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10 *
                                          (MediaQuery.of(context).size.width /
                                              600)),
                                      child: Container(
                                        color: Colors.black.withAlpha(100),
                                        height:
                                            MediaQuery.of(context).size.height /
                                                1.8,
                                        width:
                                            MediaQuery.of(context).size.height /
                                                1.8 *
                                                0.55,
                                      ),
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
              alignment: const Alignment(-1, -1),
              child: Card(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.4,
                  width: MediaQuery.of(context).size.width / 1.33,
                  child: ListView(
                    children: [
                      Center(
                        child: Text(
                          "Napovedi",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height / 15,
                              fontWeight: FontWeight.bold),
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
                                      debugPrint(
                                          "igra ${currentPredictions!.igra.id} ${e.id}");
                                      if (e.id == currentPredictions!.igra.id) {
                                        return e.name;
                                      }
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
                                    if (myPredictions != null &&
                                        myPredictions!.trula &&
                                        users.map((e) {
                                              if (e.id ==
                                                  currentPredictions!
                                                      .trula.id) {
                                                return e.name;
                                              }
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
                                            currentPredictions!.trula.id) {
                                          return e.name;
                                        }
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
                                    if (myPredictions != null &&
                                        myPredictions!.kralji &&
                                        users.map((e) {
                                              if (e.id ==
                                                  currentPredictions!
                                                      .kralji.id) {
                                                return e.name;
                                              }
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
                                            currentPredictions!.kralji.id) {
                                          return e.name;
                                        }
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
                                            currentPredictions!
                                                .pagatUltimo.id) {
                                          return e.name;
                                        }
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
                                            currentPredictions!
                                                .kraljUltimo.id) {
                                          return e.name;
                                        }
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
                                            currentPredictions!
                                                .barvniValat.id) {
                                          return e.name;
                                        }
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
                                            currentPredictions!.valat.id) {
                                          return e.name;
                                        }
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
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (talon.isNotEmpty)
                                  ElevatedButton(
                                    onPressed: () {
                                      showTalon = true;
                                      setState(() {});
                                    },
                                    child: const Text(
                                      "Pokaži talon",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // TALON
          if (showTalon)
            Container(
              alignment: const Alignment(-1, -1),
              child: Card(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.4,
                  width: MediaQuery.of(context).size.width / 1.33,
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          "Talon",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height / 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ...talon.asMap().entries.map(
                                (stih) => GestureDetector(
                                  onTap: () => selectTalon(stih.key),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.height /
                                            2.5 *
                                            0.55 *
                                            (1 +
                                                0.7 * (stih.value.length - 1)) +
                                        stih.value.length * 3,
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                    child: Stack(
                                      children: [
                                        ...stih.value.asMap().entries.map(
                                              (entry) => Positioned(
                                                left: (MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        2.5 *
                                                        0.55 *
                                                        0.7 *
                                                        entry.key)
                                                    .toDouble(), // neka bs konstanta, ki izvira iz nekaj vrstic bolj gor
                                                // ali imam mentalne probleme? ja.
                                                // ali me briga? ne.
                                                // fuck bad code quality
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10 *
                                                          (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              1000)),
                                                  child: SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            2.5,
                                                    child: Image.asset(
                                                        "assets/tarok${entry.value.asset}.webp"),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        if (talonSelected != -1 &&
                                            talonSelected != stih.key)
                                          Container(
                                            color: Colors.black.withAlpha(100),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2.5,
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    2.5 *
                                                    0.55 *
                                                    stih.value.length +
                                                stih.value.length * 3,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (zaruf)
                        const Text(
                            "Uf, tole pa bo zaruf. Če izbereš kralja in ga uspešno pripelješ čez, dobiš še preostanek talona in v primeru, da je v talonu mond, ne pišeš -21 dol."),
                      ElevatedButton(
                        onPressed: () {
                          showTalon = false;
                          setState(() {});
                        },
                        child: const Text(
                          "Skrij talon",
                          style: TextStyle(
                            fontSize: 20,
                          ),
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
              alignment: const Alignment(-1, -1),
              child: Card(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.1,
                  width: MediaQuery.of(context).size.width / 1.33,
                  child: ListView(
                    children: [
                      const Center(
                        child: Text(
                          "Rezultati igre",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...results!.user.map(
                        (e) => Column(
                          children: [
                            ...e.user.map(
                              (e2) => e2.name != ""
                                  ? Text(
                                      e2.name,
                                      style: const TextStyle(fontSize: 20),
                                    )
                                  : const SizedBox(),
                            ),
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
                                      'Kontra',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'Rezultat',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ),
                              ],
                              rows: <DataRow>[
                                if (e.showGamemode)
                                  DataRow(
                                    cells: <DataCell>[
                                      const DataCell(Text('Igra')),
                                      DataCell(
                                          Text('${pow(2, e.kontraIgra)}x')),
                                      DataCell(Text(
                                        '${e.igra}',
                                        style: TextStyle(
                                          color: e.igra < 0
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                      )),
                                    ],
                                  ),
                                if (e.showDifference)
                                  DataRow(
                                    cells: <DataCell>[
                                      const DataCell(Text('Razlika')),
                                      DataCell(
                                          Text('${pow(2, e.kontraIgra)}x')),
                                      DataCell(Text(
                                        '${e.razlika}',
                                        style: TextStyle(
                                          color: e.razlika < 0
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                      )),
                                    ],
                                  ),
                                if (e.showTrula)
                                  DataRow(
                                    cells: <DataCell>[
                                      const DataCell(Text('Trula')),
                                      const DataCell(Text('1x')),
                                      DataCell(Text(
                                        '${e.trula}',
                                        style: TextStyle(
                                          color: e.trula < 0
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                      )),
                                    ],
                                  ),
                                if (e.showKralji)
                                  DataRow(
                                    cells: <DataCell>[
                                      const DataCell(Text('Kralji')),
                                      const DataCell(Text('1x')),
                                      DataCell(Text(
                                        '${e.kralji}',
                                        style: TextStyle(
                                          color: e.kralji < 0
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                      )),
                                    ],
                                  ),
                                if (e.showKralj)
                                  DataRow(
                                    cells: <DataCell>[
                                      const DataCell(Text('Kralj ultimo')),
                                      DataCell(
                                          Text('${pow(2, e.kontraKralj)}x')),
                                      DataCell(Text(
                                        '${e.kralj}',
                                        style: TextStyle(
                                          color: e.kralj < 0
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                      )),
                                    ],
                                  ),
                                if (e.showPagat)
                                  DataRow(
                                    cells: <DataCell>[
                                      const DataCell(Text('Pagat ultimo')),
                                      DataCell(
                                          Text('${pow(2, e.kontraPagat)}x')),
                                      DataCell(Text(
                                        '${e.pagat}',
                                        style: TextStyle(
                                          color: e.pagat < 0
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                      )),
                                    ],
                                  ),
                                if (e.mondfang)
                                  const DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text('Izguba monda (mondfang)')),
                                      DataCell(Text('/')),
                                      DataCell(Text(
                                        '-21',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      )),
                                    ],
                                  ),
                                DataRow(
                                  cells: <DataCell>[
                                    const DataCell(Text('Skupaj')),
                                    const DataCell(Text('')),
                                    DataCell(Text(
                                      '${e.points}',
                                      style: TextStyle(
                                        color: e.points < 0
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
                      ...users.map((user) => user.endGame
                          ? Text("${user.name} želi končati igro.")
                          : const SizedBox()),
                      if (!requestedGameEnd && !widget.bots)
                        ElevatedButton(
                          onPressed: gameEndSend,
                          child: const Text(
                            "Zaključi igro",
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

          // KONEC IGRE
          if (gameDone)
            Container(
              alignment: const Alignment(-1, -1),
              child: Card(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.4,
                  width: MediaQuery.of(context).size.width / 1.33,
                  child: ListView(
                    children: [
                      const Center(
                        child: Text(
                          "Hvala za igro",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataTable(
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Igralec',
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
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Rating',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                        ],
                        rows: users
                            .map(
                              (user) => DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(user.name)),
                                  DataCell(Text(
                                    user.total.toString(),
                                    style: TextStyle(
                                      color: user.total < 0
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                  )),
                                  const DataCell(Text(
                                    "+0",
                                    style: TextStyle(
                                      color: 0 < 0 ? Colors.red : Colors.green,
                                    ),
                                  )),
                                ],
                              ),
                            )
                            .toList(),
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
