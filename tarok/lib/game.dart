import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:rounded_background_text/rounded_background_text.dart';
import 'package:tarok/constants.dart';
import 'package:tarok/messages.pb.dart' as Messages;
import 'package:tarok/timer.dart';
import 'package:web_socket_client/web_socket_client.dart';
import 'package:stockskis/stockskis.dart' as stockskis;

import 'stockskis_compatibility/compatibility.dart';

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
  String name = "Igralec";

  List<stockskis.SimpleUser> users = [];
  List<List<stockskis.LocalCard>> talon = [];
  List<stockskis.LocalCard> cards = [];
  List<stockskis.LocalCard> stashedCards = [];
  stockskis.LocalCard? firstCard;
  List<CardWidget> stih = [];
  List<String> cardStih = [];
  List<stockskis.SimpleUser> userWidgets = [];
  List<stockskis.LocalGame> games = stockskis.GAMES.toList();
  List<int> suggestions = [];
  Map<int, bool> stihBoolValues = {};

  bool lp = false;
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
  stockskis.LocalCard? premovedCard;
  double eval = 0.0;
  int sinceLastPrediction = 0;
  int countdown = 0;
  List<Messages.ChatMessage> chat = [];
  bool razpriKarte = false;

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
  late TextEditingController _controller;
  List prijatelji = [];

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

  void countdownUserTimer(String userId) {
    for (int i = 0; i < userWidgets.length; i++) {
      if (userWidgets[i].id != userId) continue;
      userWidgets[i].timerOn = true;
      break;
    }
    setState(() {});
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

  Future<void> sendMessageString(String m) async {
    if (widget.bots) return;
    final Uint8List message = Messages.Message(
      chatMessage: Messages.ChatMessage(
        userId: playerId,
        message: m,
      ),
    ).writeToBuffer();
    websocket.send(message);
  }

  Future<void> sendMessage() async {
    if (widget.bots) return;
    final Uint8List message = Messages.Message(
      chatMessage: Messages.ChatMessage(
        userId: playerId,
        message: _controller.text,
      ),
    ).writeToBuffer();
    websocket.send(message);
    _controller.text = "";
    setState(() {});
  }

  void validCards() {
    if (stash) {
      for (int i = 0; i < cards.length; i++) {
        cards[i].valid = cards[i].worth != 5;
      }
      return;
    }

    debugPrint(
      "Poklicana funkcija validCards, firstCard=${firstCard?.asset}, cardStih=$cardStih",
    );

    int gamemode = -1;
    for (int i = 0; i < users.length; i++) {
      stockskis.SimpleUser user = users[i];
      gamemode = max(gamemode, user.licitiral);
    }
    int taroki = 0;
    bool imaBarvo = false;
    bool imaVecje = false;
    int maxWorthOver = 0;

    if (firstCard == null) {
      for (int i = 0; i < cards.length; i++) {
        cards[i].valid = true;
        if (gamemode == -1 || gamemode == 6 || gamemode == 8) {
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

    for (int i = 0; i < stockskis.CARDS.length; i++) {
      if (!cardStih.contains(stockskis.CARDS[i].asset)) continue;
      if (imaBarvo && !stockskis.CARDS[i].asset.contains(color)) continue;
      maxWorthOver = max(maxWorthOver, stockskis.CARDS[i].worthOver);
    }

    for (int i = 0; i < cards.length; i++) {
      if (imaBarvo && !cards[i].asset.contains(color)) continue;
      if (cards[i].worthOver > maxWorthOver) imaVecje = true;
      if (imaVecje) break;
    }

    debugPrint(
        "taroki=$taroki imaBarvo=$imaBarvo imaVecje=$imaVecje maxWorthOver=$maxWorthOver gamemode=$gamemode cardStih=$cardStih color=$color");

    if (firstCard!.asset.contains("taroki")) {
      for (int i = 0; i < cards.length; i++) {
        if (gamemode == -1 || gamemode == 6 || gamemode == 8) {
          if (imaVecje && cards[i].worthOver < maxWorthOver) continue;
          if (cards[i].asset == "/taroki/pagat" && taroki > 1) continue;
          if (taroki != 0 && !cards[i].asset.contains("taroki")) continue;
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
          if (gamemode == -1 || gamemode == 6 || gamemode == 8) {
            if (imaBarvo || taroki > 0) {
              if (imaVecje && cards[i].worthOver < maxWorthOver) {
                continue;
              }
              if (cards[i].asset == "/taroki/pagat" && taroki > 1) continue;
            }
          }
          cards[i].valid = true;
        }
      }
    }
  }

  Future<void> stashEnd(bool zalozitevPotrjena) async {
    if (stashedCards.length == stashAmount && zalozitevPotrjena) {
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
        stashedCards = [];
        setState(() {});
        bPredict(stockskisContext.playingPerson());
        return;
      }
      debugPrint("Pošiljam Stash");
      final Uint8List message = Messages.Message(
              stash: Messages.Stash(
                  send: Messages.Send(),
                  card: stashedCards.map((e) => Messages.Card(id: e.asset))))
          .writeToBuffer();
      websocket.send(message);
      stash = false;
      turn = false;

      stashedCards = [];
    }
  }

  void resetPremoves() {
    for (int i = 0; i < cards.length; i++) {
      cards[i].showZoom = false;
    }
  }

  void stashCard(stockskis.LocalCard card) async {
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

  void predict() {
    if (currentPredictions == null) return;
    if (trula) {
      currentPredictions!.trula = Messages.User(id: playerId, name: name);
    }
    if (kralji) {
      currentPredictions!.kralji = Messages.User(id: playerId, name: name);
    }
    if (kraljUltimo) {
      currentPredictions!.kraljUltimo = Messages.User(id: playerId, name: name);
    }
    if (pagatUltimo) {
      currentPredictions!.pagatUltimo = Messages.User(id: playerId, name: name);
    }
    if (valat) {
      currentPredictions!.valat = Messages.User(id: playerId, name: name);
    }
    if (barvic) {
      currentPredictions!.barvniValat = Messages.User(id: playerId, name: name);
    }

    // kontre dal
    if (kontraKralj) {
      currentPredictions!.kraljUltimoKontraDal =
          Messages.User(id: playerId, name: name);
    }
    if (kontraPagat) {
      currentPredictions!.pagatUltimoKontraDal =
          Messages.User(id: playerId, name: name);
    }
    if (kontraValat) {
      currentPredictions!.valatKontraDal =
          Messages.User(id: playerId, name: name);
    }
    if (kontraBarvic) {
      currentPredictions!.barvniValatKontraDal =
          Messages.User(id: playerId, name: name);
    }
    if (kontraIgra) {
      currentPredictions!.igraKontraDal =
          Messages.User(id: playerId, name: name);
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
      stockskisContext.predictions =
          PredictionsCompLayer.messagesToStockSkis(currentPredictions!);
      myPredictions = null;
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
      if (stockskisContext.userPositions[i] == "player") {
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
      card.user = "talon";
      stockskisContext.stihi.last.add(card);
      cardStih.add(card.card.asset);
      stih.add(CardWidget(
        position: 100,
        widget: Image.asset("assets/tarok${card.card.asset}.webp"),
      ));
      setState(() {});
    }
  }

  void sendCard(stockskis.LocalCard card,
      {bool zalozitevPotrjena = false}) async {
    debugPrint("sendCard() called, turn=$turn, stash=$stash");
    if (!turn) return;
    if (stash && !zalozitevPotrjena) {
      stashCard(card);
      return;
    }
    if (widget.bots) {
      resetPremoves();
      premovedCard = null;

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
      bool early = await addToStih("player", "player", card.asset);
      setState(() {});

      if (early) return;

      if (stockskisContext.stihi.last.length == stockskisContext.users.length) {
        await bCleanStih();
        return;
      }

      int next = afterPlayer();
      debugPrint("Next $next");
      bPlay(next);

      return;
    }
    final Uint8List message = Messages.Message(
            card: Messages.Card(id: card.asset, send: Messages.Send()))
        .writeToBuffer();
    websocket.send(message);
    turn = false;
    cards.remove(card);
    resetPremoves();
    premovedCard = null;
  }

  Future<void> invitePlayer(String playerId) async {
    if (widget.bots) {
      return;
    }

    final Uint8List message = Messages.Message(
      playerId: playerId,
      invitePlayer: Messages.InvitePlayer(),
    ).writeToBuffer();
    websocket.send(message);
  }

  Future<void> manuallyStartGame() async {
    if (widget.bots) {
      return;
    }

    final Uint8List message = Messages.Message(
      gameStart: Messages.GameStart(),
    ).writeToBuffer();
    websocket.send(message);
  }

  void licitiranjeSend(stockskis.LocalGame game) {
    if (!licitiram || !licitiranje) return;
    if (widget.bots) {
      for (int i = 0; i < users.length; i++) {
        if (users[i].id == "player") {
          logger.i("nastavljam users[i].licitiral na ${game.id}");
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

  void selectTalon(int t) async {
    if (!showTalon || talonSelected != -1) return;
    if (widget.bots) {
      List<stockskis.LocalCard> selectedCards = talon[t];
      for (int i = 0; i < selectedCards.length; i++) {
        stockskis.LocalCard c = selectedCards[i];
        for (int n = 0; n < stockskisContext.talon.length; n++) {
          if (stockskisContext.talon[n].card.asset != c.asset) continue;
          stockskisContext.talon[n].user = "player";
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

  List<stockskis.LocalCard> sortCardsToUser(List<stockskis.LocalCard> cards) {
    List<stockskis.LocalCard> piki = [];
    List<stockskis.LocalCard> kare = [];
    List<stockskis.LocalCard> srci = [];
    List<stockskis.LocalCard> krizi = [];
    List<stockskis.LocalCard> taroki = [];
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
    return [...piki, ...kare, ...srci, ...krizi, ...taroki];
  }

  void sortCards() {
    cards = sortCardsToUser(cards);
  }

  bool isPlayerMandatory(String playerId) {
    return users.last.id == playerId;
  }

  stockskis.SimpleUser getUserFromPosition(String userId) {
    for (int i = 0; i < users.length; i++) {
      if (users[i].id == userId) return users[i];
    }
    throw Exception("no user was found");
  }

  void bLicitate(int startAt) async {
    licitiranje = true;

    int onward = 0;
    int notVoted = 0;
    for (int i = 0; i < users.length; i++) {
      if (users[i].licitiral == -1) onward++;
      if (users[i].licitiral == -2) notVoted++;
    }
    debugPrint("onward: $onward, notVoted: $notVoted");
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
          stockskisContext.predictions =
              PredictionsCompLayer.messagesToStockSkis(currentPredictions!);
          licitiranje = false;
          bKingSelect(users[i].id);
          return;
        }
      }
      if (m == -1) {
        debugPrint("začenjam rundo klopa");
        // začnemo klopa pri obveznem
        stockskisContext.users[users.last.id]!.licitiral = true;
        stockskisContext.users[users.last.id]!.playing = true;
        stockskisContext.users[users.last.id]!.secretlyPlaying = true;
        currentPredictions!.igra = Messages.User(
          id: users.last.id,
          name: users.last.name,
        );
        currentPredictions!.gamemode = -1;
        stockskisContext.predictions =
            PredictionsCompLayer.messagesToStockSkis(currentPredictions!);
        bPredict(0);
      }
      return;
    }

    for (int i = startAt; i < users.length; i++) {
      stockskis.SimpleUser user = users[i];
      bool isMandatory = i == users.length - 1;

      debugPrint("user.id=${user.id}, isMandatory=$isMandatory");

      if (user.id == "player") {
        bool jeLicitiral = false;
        for (int n = 0; n < users.length; n++) {
          if (users[n].id == "player") {
            jeLicitiral = users[n].licitiral == -1;
          }
        }
        if (jeLicitiral) continue;
        licitiram = true;
        if (!OMOGOCI_STOCKSKIS_PREDLOGE) return;
        suggestions = stockskisContext.suggestModes(
          user.id,
          canLicitateThree: isMandatory,
        );
        return;
      }

      await Future.delayed(const Duration(milliseconds: 400), () {
        setState(() {});
      });

      List<int> botSuggestions = OMOGOCI_STOCKSKIS_PREDLOGE
          ? stockskisContext.suggestModes(
              user.id,
              canLicitateThree: isMandatory,
            )
          : [];
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
          stockskisContext.predictions =
              PredictionsCompLayer.messagesToStockSkis(currentPredictions!);
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
    firstCard = null;
    results = null;
    talonSelected = -1;
    zaruf = false;
    cardStih = [];
    copyGames();

    for (int i = 0; i < users.length; i++) {
      users[i].licitiral = -2;
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
          user: stockskis.SimpleUser(id: botId, name: botName),
          playing: false,
          secretlyPlaying: false,
          botType: botType,
          licitiral: false,
        );
        stockskis.SimpleUser user =
            stockskis.SimpleUser(id: botId, name: botName);
        users.add(user);
      }
      stockskisUsers["player"] = stockskis.User(
        cards: [],
        user: stockskis.SimpleUser(id: "player", name: "Igralec"),
        playing: false,
        secretlyPlaying: false,
        botType: "NAB", // not a bot
        licitiral: false,
      );
      stockskis.SimpleUser user =
          stockskis.SimpleUser(id: "player", name: "Igralec");
      users.add(user);
      stockskisContext = stockskis.StockSkis(
        users: stockskisUsers,
        stihiCount: ((54 - 6) / widget.playing).floor(),
        predictions: stockskis.Predictions(),
      )..skisfang = SKISFANG;
    } else {
      // naslednja igra, samo resetiramo vrednosti pri sedanjih botih
      stockskisContext.resetContext();
      logger.d("[bStartGame] stockskisContext.resetContext() called");
    }

    logger.i(
      {
        "users": users.map((e) => '${e.id}/${e.name}').join(' '),
      },
    );

    currentPredictions = Messages.Predictions();
    stockskisContext.doRandomShuffle();
    List<stockskis.Card> myCards = stockskisContext.users["player"]!.cards;
    cards = myCards.map((card) => card.card).toList();
    users = stockskisContext.buildPositionsSimple();
    stockskisContext.selectedKing = "";

    if (userWidgets.isEmpty) {
      // sebe sploh ne smem dat med userWidgetse, razen kot zadnjega
      userWidgets = stockskisContext.buildPositionsSimple();
      stockskis.SimpleUser w = userWidgets[0];
      userWidgets.removeAt(0);
      userWidgets.add(w);
    }

    logger.i(
      {
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
    bLicitate(0);
  }

  void bSetPointsResults() {
    bool radelc = false;
    for (int i = 0; i < results!.user.length; i++) {
      if (results!.user[i].radelc) {
        radelc = true;
        break;
      }
    }
    for (int i = 0; i < users.length; i++) {
      users[i].points.add(stockskis.ResultsPoints(
            points: 0,
            playing: false,
            results: ResultsCompLayer.messagesToStockSkis(results!),
            radelc: radelc,
          ));
    }
    for (int i = 0; i < users.length; i++) {
      String id = users[i].id;
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
        String playingUser = currentPredictions!.igra.id;
        if (playingUser == id) {
          users[i].points.last.playing = true;
        }
        users[i].points.last.points += result.points;
        users[i].total += result.points;
      }
    }
  }

  void bResults() async {
    debugPrint("Gamemode stockškis konteksta je ${stockskisContext.gamemode}");
    results =
        ResultsCompLayer.stockSkisToMessages(stockskisContext.calculateGame());
    bSetPointsResults();
    setState(() {});
    if (!stockskis.AUTOSTART_GAME) return;
    await Future.delayed(const Duration(seconds: 10), () {
      bStartGame();
    });
  }

  Future<void> bCleanStih() async {
    if (zaruf) {
      List<stockskis.Card> zadnjiStih = stockskisContext.stihi.last;
      stockskis.StihAnalysis? analysis =
          stockskisContext.analyzeStih(zadnjiStih);
      if (analysis == null) throw Exception("Štih is empty");
      debugPrint(
        "Zaruf analiza: ${analysis.cardPicks.card.asset} $selectedKing ${zadnjiStih.map((e) => e.card.asset)}",
      );
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
        debugPrint(
          "Talon: ${stockskisContext.talon.map((e) => e.card.asset).join(" ")}",
        );
        int len = stockskisContext.talon.length;
        for (int i = 0; i < len; i++) {
          stockskis.Card karta = stockskisContext.talon[0];
          debugPrint(
            "Dodeljujem karto ${karta.card.asset} z vrednostjo ${karta.card.worth} zarufancu. stockskisContext.stihi[0].length = ${stockskisContext.stihi[0].length}",
          );
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
      for (int i = 1; i < users.length; i++) {
        if (users[i].id == pickedUpBy) {
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
      bPlay(k);
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
      stockskis.User pos =
          stockskisContext.users[stockskisContext.userPositions[i]]!;
      debugPrint(
        "Card length: ${pos.cards.length}; User: ${pos.user.id}/${pos.user.name}; i: $i",
      );
      if (pos.cards.isEmpty) {
        debugPrint("Calculating results");
        bResults();
        return;
      }
      if (pos.user.id == "player") {
        if (pos.cards.length == 1) {
          logger.d(
              "stockskisContext.users['player'].cards.length is 1. Autodropping card.");
          turn = true;
          setState(() {});
          sendCard(pos.cards[0].card);
          setState(() {});
          return;
        }
        turn = true;
        validCards();
        if (premovedCard != null) {
          if (!premovedCard!.valid) {
            resetPremoves();
            setState(() {});
            return;
          }
          ;
          debugPrint("Dropping premoved card ${premovedCard!.asset}");
          sendCard(premovedCard!);
          setState(() {});
          return;
        }
        setState(() {});
        return;
      }
      List<stockskis.Move> moves = stockskisContext.evaluateMoves(pos.user.id);
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
      stockskisContext.users[pos.user.id]!.cards.remove(bestMove.card);
      await Future.delayed(const Duration(milliseconds: 500), () async {});
      debugPrint("Dodajam v štih");
      if (await addToStih(pos.user.id, "player", bestMove.card.card.asset)) {
        return;
      }
      i++;
      setState(() {});
      debugPrint(
          "StockŠkis štih: ${stockskisContext.stihi.last.length}, Uporabniki: ${stockskisContext.users.length}, Zaruf: $zaruf");
      if (stockskisContext.stihi.last.length == stockskisContext.users.length) {
        await bCleanStih();
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
    int k = start;
    setState(() {});

    while (true) {
      // napovej barvića in valata po izbiri v napovedih
      if (currentPredictions!.valat.id != "") {
        currentPredictions!.gamemode = 10;
        stockskisContext.gamemode = 10;
      } else if (currentPredictions!.barvniValat.id != "") {
        currentPredictions!.gamemode = 9;
        stockskisContext.gamemode = 9;
      }

      if (sinceLastPrediction > widget.playing) {
        logger.i("Gamemode: ${stockskisContext.gamemode}");
        if (stockskisContext.gamemode >= 6) {
          bPlay(stockskisContext.playingPerson());
          return;
        }
        bPlay(users.length - 1);
        return;
      }
      stockskis.User u =
          stockskisContext.users[stockskisContext.userPositions[k]]!;
      debugPrint(
          "User with ID ${u.user.id}. k=$k, sinceLastPrediction=$sinceLastPrediction");
      if (u.user.id == "player") {
        myPredictions = StartPredictionsCompLayer.stockSkisToMessages(
          stockskisContext.getStartPredictions("player"),
        );
        startPredicting = true;
        sinceLastPrediction++;
        setState(() {});
        return;
      }
      bool changed = stockskisContext.predict(u.user.id);
      if (changed) {
        sinceLastPrediction = 0;
      }
      currentPredictions = PredictionsCompLayer.stockSkisToMessages(
        stockskisContext.predictions,
      );
      k++;
      if (k >= stockskisContext.userPositions.length) k = 0;
      userHasKing = currentPredictions!.kraljUltimo.id;
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 500), () {});
      sinceLastPrediction++;
    }
  }

  void bTalon(String playerId) async {
    debugPrint("Talon");
    talon = [];
    int game = getPlayedGame();
    if (game == -1 || game >= 6) {
      bPredict(stockskisContext.playingPerson());
      return;
    }
    debugPrint("Talon1");
    showTalon = true;

    var (stockskisTalon, talon1, zaruf1) = stockskisContext.getStockskisTalon();
    talon = talon1;
    zaruf = zaruf1;

    if (playerId == "player") {
      playing = true;
      setState(() {});
      return;
    }

    talonSelected = stockskisContext.selectDeck(playerId, stockskisTalon);
    List<stockskis.Card> selectedCards = stockskisTalon[talonSelected];
    debugPrint(
      "Izbrane karte: ${selectedCards.map((e) => e.card.asset).join(" ")}",
    );
    for (int i = 0; i < selectedCards.length; i++) {
      stockskis.Card s = selectedCards[i];
      stockskisContext.talon.remove(s);
      s.user = playerId;
      stockskisContext.users[playerId]!.cards.add(s);
    }
    setState(() {});
    debugPrint(
      "Talon: ${stockskisContext.talon.map((e) => e.card.asset).join(" ")}",
    );
    String king = selectedKing == "" ? "" : selectedKing.split("/")[1];

    int m = 0;
    if (game == 0 || game == 3) m = 2;
    if (game == 1 || game == 4) m = 3;
    if (game == 2 || game == 5) m = 6;
    List<stockskis.Card> stash =
        stockskisContext.stashCards(playerId, (6 / m).round(), king);
    for (int i = 0; i < stash.length; i++) {
      stockskis.Card s = stash[i];
      stockskisContext.users[playerId]!.cards.remove(s);
      s.user = playerId;
      stockskisContext.stihi[0].add(stash[i]);
    }
    stockskisContext.stihi.add([]);
    stockskisContext.sortAllCards();
    setState(() {});
    firstCard = null;
    debugPrint(
      "Talon: ${stockskisContext.talon.map((e) => e.card.asset).join(" ")}",
    );
    await Future.delayed(const Duration(seconds: 2), () {
      bPredict(stockskisContext.playingPerson());
    });
  }

  void bKingSelect(String playerId) async {
    int game = getPlayedGame();
    if (game == -1 || game >= 3 || users.length == 3) {
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
    debugPrint(
        "card=$card, selectedKing=$selectedKing, msgPlayerId=$msgPlayerId, playerId=$playerId");
    if (card == selectedKing) {
      if (widget.bots) stockskisContext.revealKing(msgPlayerId);
      userHasKing = msgPlayerId;
      debugPrint("Karta $selectedKing nastavljena na uporabnika $msgPlayerId.");
    }
    List<stockskis.SimpleUser> after = [];
    List<stockskis.SimpleUser> before = [];
    if (widget.bots) myPosition = stockskisContext.getPlayer();
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
      ));
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 20), () {
        stihBoolValues[position] = true;
        setState(() {});
      });
      break;
    }
    if (widget.bots && stih.length == widget.playing) {
      eval = stockskisContext.evaluateGame();
      debugPrint("Trenutna evaluacija igre je $eval. Kralj je $userHasKing.");
      bool canGameEndEarly = stockskisContext.canGameEndEarly();
      if (canGameEndEarly) {
        debugPrint("končujem igro predčasno");
        await Future.delayed(const Duration(milliseconds: 500), () async {
          bResults();
        });
        return true;
      }
    }
    return false;
  }

  List<Widget> generateNames3(
    double leftFromTop,
    double m,
    double cardK,
    double userSquareSize,
  ) {
    List<Widget> widgets = [];

    if (userWidgets.isEmpty) {
      return widgets;
    }

    if (currentPredictions == null) {
      return widgets;
    }

    widgets.add(
      Positioned(
        top: 10,
        left: MediaQuery.of(context).size.width * 0.15 - userSquareSize / 2,
        height: userSquareSize,
        width: userSquareSize,
        child: Stack(
          children: [
            SizedBox(
              height: userSquareSize,
              width: userSquareSize,
              child: Initicon(
                text: userWidgets[0].name,
                elevation: 4,
                backgroundColor: HSLColor.fromAHSL(
                        1, hashCode(userWidgets[0].name) % 360, 1, 0.6)
                    .toColor(),
                borderRadius: BorderRadius.zero,
              ),
            ),
            if (!userWidgets[0].connected)
              Container(
                height: userSquareSize,
                width: userSquareSize,
                color: Colors.black.withAlpha(200),
              ),
            Positioned(
              top: 5,
              left: 10,
              child: SizedBox(
                height: userSquareSize,
                width: userSquareSize,
                child: RoundedBackgroundText(
                  userWidgets[0].name,
                  style: const TextStyle(color: Colors.white),
                  backgroundColor: Colors.black,
                ),
              ),
            ),
            UserTimer(
              user: userWidgets[0],
              userSquareSize: userSquareSize,
              timerOn: userWidgets[0].timerOn,
            ),
          ],
        ),
      ),
    );

    if (currentPredictions!.igra.id == userWidgets[0].id) {
      widgets.add(
        Positioned(
          top: 10,
          left: MediaQuery.of(context).size.width * 0.15 + userSquareSize / 2,
          child: Container(
            height: userSquareSize / 2,
            width: userSquareSize / 2,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: zaruf ? Colors.red : Colors.black,
              ),
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                GAME_DESC[currentPredictions!.gamemode + 1],
                style: TextStyle(
                  fontSize: 0.3 * userSquareSize,
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (kartePogoj(0)) {
      widgets.addAll(
        pridobiKarte(0).asMap().entries.map(
              (e) => Positioned(
                top: e.key *
                        (MediaQuery.of(context).size.height / 7 * 0.57 * 0.5) -
                    10,
                child: Transform.rotate(
                  angle: -pi / 2,
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.height / 7 * 0.57,
                        height: MediaQuery.of(context).size.height / 7,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 7,
                        child: Image.asset(
                          "assets/tarok${e.value.card.asset}.webp",
                          filterQuality: FilterQuality.medium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      );
    }

    if (userWidgets.length < 2) {
      return widgets;
    }

    widgets.add(
      Positioned(
        top: 10,
        left: MediaQuery.of(context).size.width * 0.55 - userSquareSize / 2,
        child: Stack(
          children: [
            SizedBox(
              height: userSquareSize,
              width: userSquareSize,
              child: Initicon(
                text: userWidgets[1].name,
                elevation: 4,
                borderRadius: BorderRadius.zero,
                backgroundColor: HSLColor.fromAHSL(
                        1, hashCode(userWidgets[1].name) % 360, 1, 0.6)
                    .toColor(),
              ),
            ),
            if (!userWidgets[1].connected)
              Container(
                height: userSquareSize,
                width: userSquareSize,
                color: Colors.black.withAlpha(200),
              ),
            Positioned(
              top: 5,
              left: 10,
              child: SizedBox(
                height: userSquareSize,
                width: userSquareSize,
                child: RoundedBackgroundText(
                  userWidgets[1].name,
                  style: const TextStyle(color: Colors.white),
                  backgroundColor: Colors.black,
                ),
              ),
            ),
            UserTimer(
              user: userWidgets[1],
              userSquareSize: userSquareSize,
              timerOn: userWidgets[1].timerOn,
            ),
          ],
        ),
      ),
    );

    if (currentPredictions!.igra.id == userWidgets[1].id) {
      widgets.add(
        Positioned(
          top: 10,
          left: MediaQuery.of(context).size.width * 0.55 + userSquareSize / 2,
          child: Container(
            height: userSquareSize / 2,
            width: userSquareSize / 2,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: zaruf ? Colors.red : Colors.black,
              ),
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                GAME_DESC[currentPredictions!.gamemode + 1],
                style: TextStyle(
                  fontSize: 0.3 * userSquareSize,
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (kartePogoj(1)) {
      widgets.addAll(
        pridobiKarte(1).asMap().entries.map(
              (e) => Positioned(
                top: e.key *
                        (MediaQuery.of(context).size.height / 7 * 0.57 * 0.5) -
                    10,
                right: MediaQuery.of(context).size.width * 0.3,
                child: Transform.rotate(
                  angle: pi / 2,
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.height / 7 * 0.57,
                        height: MediaQuery.of(context).size.height / 7,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 7,
                        child: Image.asset(
                          "assets/tarok${e.value.card.asset}.webp",
                          filterQuality: FilterQuality.medium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      );
    }

    return widgets;
  }

  List<Widget> generateNames4(
    double leftFromTop,
    double m,
    double cardK,
    double userSquareSize,
  ) {
    List<Widget> widgets = [];

    if (userWidgets.isEmpty) {
      return widgets;
    }

    if (currentPredictions == null) {
      return widgets;
    }

    widgets.add(
      Positioned(
        top: leftFromTop + (m * cardK * 0.5),
        left: 10,
        height: userSquareSize,
        width: userSquareSize,
        child: Stack(
          children: [
            SizedBox(
              height: userSquareSize,
              width: userSquareSize,
              child: Initicon(
                text: userWidgets[0].name,
                elevation: 4,
                backgroundColor: HSLColor.fromAHSL(
                        1, hashCode(userWidgets[0].name) % 360, 1, 0.6)
                    .toColor(),
                borderRadius: BorderRadius.zero,
              ),
            ),
            if (!userWidgets[0].connected)
              Container(
                height: userSquareSize,
                width: userSquareSize,
                color: Colors.black.withAlpha(200),
              ),
            Positioned(
              top: 5,
              left: 10,
              child: SizedBox(
                height: userSquareSize,
                width: userSquareSize,
                child: RoundedBackgroundText(
                  userWidgets[0].name,
                  style: const TextStyle(color: Colors.white),
                  backgroundColor: Colors.black,
                ),
              ),
            ),
            UserTimer(
              user: userWidgets[0],
              userSquareSize: userSquareSize,
              timerOn: userWidgets[0].timerOn,
            ),
          ],
        ),
      ),
    );

    if (currentPredictions!.igra.id == userWidgets[0].id) {
      widgets.add(
        Positioned(
          top: leftFromTop + (m * cardK * 0.5),
          left: 10 + userSquareSize,
          child: Container(
            height: userSquareSize / 2,
            width: userSquareSize / 2,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: zaruf ? Colors.red : Colors.black,
              ),
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                GAME_DESC[currentPredictions!.gamemode + 1],
                style: TextStyle(
                  fontSize: 0.3 * userSquareSize,
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (userHasKing == userWidgets[0].id ||
        (currentPredictions!.igra.id == userWidgets[0].id &&
            selectedKing != "")) {
      widgets.add(
        Positioned(
          top: leftFromTop + (m * cardK * 0.5) + userSquareSize / 2,
          left: 10 + userSquareSize,
          child: Container(
            height: userSquareSize / 2,
            width: userSquareSize / 2,
            decoration: BoxDecoration(
              color:
                  selectedKing == "/pik/kralj" || selectedKing == "/kriz/kralj"
                      ? Colors.black
                      : Colors.red,
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                  selectedKing == "/pik/kralj"
                      ? "♠️"
                      : (selectedKing == "/src/kralj"
                          ? "❤️"
                          : (selectedKing == "/kriz/kralj" ? "♣️" : "♦️")),
                  style: TextStyle(fontSize: 0.3 * userSquareSize)),
            ),
          ),
        ),
      );
    }

    if (kartePogoj(0)) {
      widgets.addAll(
        pridobiKarte(0).asMap().entries.map(
              (e) => Positioned(
                top: e.key *
                        (MediaQuery.of(context).size.height / 7 * 0.57 * 0.5) -
                    10,
                child: Transform.rotate(
                  angle: -pi / 2,
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.height / 7 * 0.57,
                        height: MediaQuery.of(context).size.height / 7,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 7,
                        child: Image.asset(
                          "assets/tarok${e.value.card.asset}.webp",
                          filterQuality: FilterQuality.medium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      );
    }

    if (userWidgets.length < 2) {
      return widgets;
    }

    widgets.add(
      Positioned(
        top: 10,
        left: MediaQuery.of(context).size.width * 0.35 - userSquareSize / 2,
        child: Stack(
          children: [
            SizedBox(
              height: userSquareSize,
              width: userSquareSize,
              child: Initicon(
                text: userWidgets[1].name,
                elevation: 4,
                borderRadius: BorderRadius.zero,
                backgroundColor: HSLColor.fromAHSL(
                        1, hashCode(userWidgets[1].name) % 360, 1, 0.6)
                    .toColor(),
              ),
            ),
            if (!userWidgets[1].connected)
              Container(
                height: userSquareSize,
                width: userSquareSize,
                color: Colors.black.withAlpha(200),
              ),
            Positioned(
              top: 5,
              left: 10,
              child: SizedBox(
                height: userSquareSize,
                width: userSquareSize,
                child: RoundedBackgroundText(
                  userWidgets[1].name,
                  style: const TextStyle(color: Colors.white),
                  backgroundColor: Colors.black,
                ),
              ),
            ),
            UserTimer(
              user: userWidgets[1],
              userSquareSize: userSquareSize,
              timerOn: userWidgets[1].timerOn,
            ),
          ],
        ),
      ),
    );

    if (currentPredictions!.igra.id == userWidgets[1].id) {
      widgets.add(
        Positioned(
          top: 10,
          left: MediaQuery.of(context).size.width * 0.35 + userSquareSize / 2,
          child: Container(
            height: userSquareSize / 2,
            width: userSquareSize / 2,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: zaruf ? Colors.red : Colors.black,
              ),
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                GAME_DESC[currentPredictions!.gamemode + 1],
                style: TextStyle(
                  fontSize: 0.3 * userSquareSize,
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (userHasKing == userWidgets[1].id ||
        (currentPredictions!.igra.id == userWidgets[1].id &&
            selectedKing != "")) {
      widgets.add(
        Positioned(
          top: 10 + userSquareSize / 2,
          left: MediaQuery.of(context).size.width * 0.35 + userSquareSize / 2,
          child: Container(
            height: userSquareSize / 2,
            width: userSquareSize / 2,
            decoration: BoxDecoration(
              color:
                  selectedKing == "/pik/kralj" || selectedKing == "/kriz/kralj"
                      ? Colors.black
                      : Colors.red,
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                  selectedKing == "/pik/kralj"
                      ? "♠️"
                      : (selectedKing == "/src/kralj"
                          ? "❤️"
                          : (selectedKing == "/kriz/kralj" ? "♣️" : "♦️")),
                  style: TextStyle(fontSize: 0.3 * userSquareSize)),
            ),
          ),
        ),
      );
    }

    if (kartePogoj(1)) {
      widgets.addAll(
        pridobiKarte(1).asMap().entries.map(
              (e) => Positioned(
                left: MediaQuery.of(context).size.width * 0.35 +
                    userSquareSize +
                    10 +
                    e.key *
                        (MediaQuery.of(context).size.height / 7 * 0.57 * 0.5),
                child: Transform.rotate(
                  angle: 0,
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.height / 7 * 0.57,
                        height: MediaQuery.of(context).size.height / 7,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 7,
                        child: Image.asset(
                          "assets/tarok${e.value.card.asset}.webp",
                          filterQuality: FilterQuality.medium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      );
    }

    if (userWidgets.length < 3) {
      return widgets;
    }

    widgets.add(
      Positioned(
        top: leftFromTop + (m * cardK * 0.5),
        right: MediaQuery.of(context).size.width * 0.3,
        child: Stack(
          children: [
            SizedBox(
              height: userSquareSize,
              width: userSquareSize,
              child: Initicon(
                text: userWidgets[2].name,
                elevation: 4,
                borderRadius: BorderRadius.zero,
                backgroundColor: HSLColor.fromAHSL(
                        1, hashCode(userWidgets[2].name) % 360, 1, 0.6)
                    .toColor(),
              ),
            ),
            if (!userWidgets[2].connected)
              Container(
                height: userSquareSize,
                width: userSquareSize,
                color: Colors.black.withAlpha(200),
              ),
            Positioned(
              top: 5,
              left: 10,
              child: SizedBox(
                height: userSquareSize,
                width: userSquareSize,
                child: RoundedBackgroundText(
                  userWidgets[2].name,
                  style: const TextStyle(color: Colors.white),
                  backgroundColor: Colors.black,
                ),
              ),
            ),
            UserTimer(
              user: userWidgets[2],
              userSquareSize: userSquareSize,
              timerOn: userWidgets[2].timerOn,
            ),
          ],
        ),
      ),
    );

    if (currentPredictions!.igra.id == userWidgets[2].id) {
      widgets.add(
        Positioned(
          top: leftFromTop + (m * cardK * 0.5),
          right: MediaQuery.of(context).size.width * 0.3 - userSquareSize / 2,
          child: Container(
            height: userSquareSize / 2,
            width: userSquareSize / 2,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: zaruf ? Colors.red : Colors.black,
              ),
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                GAME_DESC[currentPredictions!.gamemode + 1],
                style: TextStyle(
                  fontSize: 0.3 * userSquareSize,
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (userHasKing == userWidgets[2].id ||
        (currentPredictions!.igra.id == userWidgets[2].id &&
            selectedKing != "")) {
      widgets.add(
        Positioned(
          top: leftFromTop + (m * cardK * 0.5) + userSquareSize / 2,
          right: MediaQuery.of(context).size.width * 0.3 - userSquareSize / 2,
          child: Container(
            height: userSquareSize / 2,
            width: userSquareSize / 2,
            decoration: BoxDecoration(
              color:
                  selectedKing == "/pik/kralj" || selectedKing == "/kriz/kralj"
                      ? Colors.black
                      : Colors.red,
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                selectedKing == "/pik/kralj"
                    ? "♠️"
                    : (selectedKing == "/src/kralj"
                        ? "❤️"
                        : (selectedKing == "/kriz/kralj" ? "♣️" : "♦️")),
                style: TextStyle(fontSize: 0.3 * userSquareSize),
              ),
            ),
          ),
        ),
      );
    }

    if (kartePogoj(2)) {
      widgets.addAll(
        pridobiKarte(2).asMap().entries.map(
              (e) => Positioned(
                top: e.key *
                    (MediaQuery.of(context).size.height / 7 * 0.57 * 0.5),
                right: MediaQuery.of(context).size.width * 0.3,
                child: Transform.rotate(
                  angle: pi / 2,
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.height / 7 * 0.57,
                        height: MediaQuery.of(context).size.height / 7,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 7,
                        child: Image.asset(
                          "assets/tarok${e.value.card.asset}.webp",
                          filterQuality: FilterQuality.medium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      );
    }

    return widgets;
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

  void copyGames() {
    games = [
      ...(jsonDecode(
        jsonEncode(
          stockskis.GAMES,
          toEncodable: (Object? value) => value is stockskis.LocalGame
              ? stockskis.LocalGame.toJson(value)
              : throw UnsupportedError('Cannot convert to JSON: $value'),
        ),
      ) as List<dynamic>)
          .map((e) => stockskis.LocalGame.fromJson(e)),
    ];
  }

  Future<void> fetchFriends() async {
    final response = await dio.get(
      "$BACKEND_URL/friends/get",
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    if (response.statusCode != 200) return;
    final data = jsonDecode(response.data);
    print(data);
    prijatelji = data["CurrentFriends"];
    setState(() {});
  }

  @override
  void initState() {
    _controller = TextEditingController();

    // BOTI - OFFLINE
    if (widget.bots) {
      playerId = "player";
      bStartGame();
      super.initState();
      return;
    }

    fetchFriends();

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
            countdownUserTimer(userId);
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

          currentPredictions = Messages.Predictions();
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

          List<Messages.User> newUsers = gameStart.user;
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
          userWidgets = [];
          print(myPosition);
          print(k);
          print(i);
          while (i < users.length) {
            stockskis.SimpleUser user = users[i];
            userWidgets.add(user);
            if (i == myPosition) break;
            i++;
            k++;
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
          countdownUserTimer(userId);
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
              Messages.User u = user.user[k];
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
            countdownUserTimer(userId);
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
          countdownUserTimer(userId);
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
          countdownUserTimer(userId);
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
            countdownUserTimer(userId);
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

    super.initState();
  }

  bool kartePogoj(int i) {
    return (stockskis.ODPRTE_IGRE && widget.bots) ||
        userWidgets[i].cards.isNotEmpty ||
        (widget.bots &&
            !predictions &&
            currentPredictions!.gamemode == 8 &&
            userWidgets[i].id == currentPredictions!.igra.id);
  }

  List<stockskis.Card> pridobiKarte(int i) {
    return userWidgets[i].cards.isNotEmpty
        ? userWidgets[i].cards
        : stockskisContext.users[userWidgets[i].id]!.cards;
  }

  List<Widget> stihi3(double cardK, double m, double center, double leftFromTop,
      double cardToWidth) {
    List<Widget> widgets = [];
    for (int i = 0; i < stih.length; i++) {
      CardWidget e = stih[i];
      if (e.position == 0) {
        widgets.add(
          AnimatedPositioned(
            duration: const Duration(milliseconds: 50),
            top: stihBoolValues[1] != true
                ? leftFromTop - (m * cardK * 0.5) - 100
                : leftFromTop - (m * cardK * 0.5),
            left: stihBoolValues[1] != true
                ? cardToWidth - m * cardK / 3 - 100
                : cardToWidth - m * cardK / 3,
            height: m * cardK,
            child: Transform.rotate(
              angle: -pi / 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    10 * (MediaQuery.of(context).size.width / 1000)),
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      height: m * cardK,
                      width: m * cardK * 0.57,
                    ),
                    e.widget,
                  ],
                ),
              ),
            ),
          ),
        );
        continue;
      }
      if (e.position == 1) {
        widgets.add(
          AnimatedPositioned(
            duration: const Duration(milliseconds: 50),
            top: stihBoolValues[1] != true
                ? leftFromTop - (m * cardK * 0.5) - 100
                : leftFromTop - (m * cardK * 0.5),
            left: stihBoolValues[1] != true
                ? cardToWidth + m * cardK / 3 + 100
                : cardToWidth + m * cardK / 3,
            height: m * cardK,
            child: Transform.rotate(
              angle: pi / 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    10 * (MediaQuery.of(context).size.width / 1000)),
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      height: m * cardK,
                      width: m * cardK * 0.57,
                    ),
                    e.widget,
                  ],
                ),
              ),
            ),
          ),
        );
        continue;
      }
      if (e.position == 100) {
        widgets.add(
          AnimatedPositioned(
            duration: const Duration(milliseconds: 50),
            top: leftFromTop,
            left: cardToWidth,
            height: m * cardK,
            child: Transform.rotate(
              angle: pi / 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    10 * (MediaQuery.of(context).size.width / 1000)),
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      height: m * cardK,
                      width: m * cardK * 0.57,
                    ),
                    e.widget,
                  ],
                ),
              ),
            ),
          ),
        );
        continue;
      }
      widgets.add(
        AnimatedPositioned(
          duration: const Duration(milliseconds: 50),
          top: stihBoolValues[3] != true
              ? leftFromTop + (m * cardK * 0.5) + 100
              : leftFromTop + (m * cardK * 0.5) * 0.7,
          left: cardToWidth,
          height: m * cardK,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
                10 * (MediaQuery.of(context).size.width / 1000)),
            child: Stack(
              children: [
                Container(
                  color: Colors.white,
                  height: m * cardK,
                  width: m * cardK * 0.57,
                ),
                e.widget,
              ],
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  List<Widget> stihi4(double cardK, double m, double center, double leftFromTop,
      double cardToWidth) {
    List<Widget> widgets = [];
    for (int i = 0; i < stih.length; i++) {
      CardWidget e = stih[i];
      if (e.position == 0) {
        widgets.add(
          AnimatedPositioned(
            duration: const Duration(milliseconds: 50),
            top: leftFromTop,
            left: stihBoolValues[0] != true ? 0 : center,
            height: m * cardK,
            child: Transform.rotate(
              angle: pi / 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    10 * (MediaQuery.of(context).size.width / 1000)),
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      height: m * cardK,
                      width: m * cardK * 0.57,
                    ),
                    e.widget,
                  ],
                ),
              ),
            ),
          ),
        );
        continue;
      }
      if (e.position == 1) {
        widgets.add(
          AnimatedPositioned(
            duration: const Duration(milliseconds: 50),
            top: stihBoolValues[1] != true
                ? leftFromTop - (m * cardK * 0.5) - 100
                : leftFromTop - (m * cardK * 0.5),
            left: cardToWidth,
            height: m * cardK,
            child: Transform.rotate(
              angle: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    10 * (MediaQuery.of(context).size.width / 1000)),
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      height: m * cardK,
                      width: m * cardK * 0.57,
                    ),
                    e.widget,
                  ],
                ),
              ),
            ),
          ),
        );
        continue;
      }
      if (e.position == 2) {
        widgets.add(
          AnimatedPositioned(
            duration: const Duration(milliseconds: 50),
            top: leftFromTop,
            left: stihBoolValues[2] != true
                ? center + m * cardK + 100
                : center + m * cardK,
            height: m * cardK,
            child: Transform.rotate(
              angle: pi / 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    10 * (MediaQuery.of(context).size.width / 1000)),
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      height: m * cardK,
                      width: m * cardK * 0.57,
                    ),
                    e.widget,
                  ],
                ),
              ),
            ),
          ),
        );
        continue;
      }
      if (e.position == 100) {
        widgets.add(
          AnimatedPositioned(
            duration: const Duration(milliseconds: 50),
            top: leftFromTop,
            left: cardToWidth,
            height: m * cardK,
            child: Transform.rotate(
              angle: pi / 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    10 * (MediaQuery.of(context).size.width / 1000)),
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      height: m * cardK,
                      width: m * cardK * 0.57,
                    ),
                    e.widget,
                  ],
                ),
              ),
            ),
          ),
        );
        continue;
      }
      widgets.add(
        AnimatedPositioned(
          duration: const Duration(milliseconds: 50),
          top: stihBoolValues[3] != true
              ? leftFromTop + (m * cardK * 0.5) + 100
              : leftFromTop + (m * cardK * 0.5),
          left: cardToWidth,
          height: m * cardK,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
                10 * (MediaQuery.of(context).size.width / 1000)),
            child: Stack(
              children: [
                Container(
                  color: Colors.white,
                  height: m * cardK,
                  width: m * cardK * 0.57,
                ),
                e.widget,
              ],
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  @override
  void dispose() {
    _controller.dispose();

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
    final cardWidth = cardSize * 0.573;
    const duration = Duration(milliseconds: 200);
    final m = min(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    const cardK = 0.38;
    final topFromLeft = MediaQuery.of(context).size.width * 0.35;
    final leftFromTop = MediaQuery.of(context).size.height * 0.30;
    final cardToWidth = MediaQuery.of(context).size.width * 0.35 -
        50 -
        (m * cardK * 0.57) / 2 +
        50;
    final center = cardToWidth - m * cardK * 0.57 * 0.8;
    final userSquareSize =
        min(MediaQuery.of(context).size.height / 5, 100.0).toDouble();
    final border = (MediaQuery.of(context).size.width / 800);
    final popupCardSize = MediaQuery.of(context).size.height / 2.5;
    final kCoverUp = 0.6;

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          resetPremoves();
          premovedCard = null;
          setState(() {});

          int validCards = 0;
          for (int i = 0; i < cards.length; i++) {
            if (cards[i].valid) validCards++;
            if (validCards > 1) return;
          }
          if (validCards == 0) return;
          if (!turn) return;
          for (int i = 0; i < cards.length; i++) {
            if (!cards[i].valid) continue;
            sendCard(cards[i]);
            break;
          }
        },
        child: Stack(
          children: [
            // COUNTDOWN
            if (countdown != 0)
              Positioned(
                left: center * 1.5,
                top: userSquareSize,
                child: Text(
                  countdown.toString(),
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height / 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            // REZULTATI, KLEPET, CHAT
            Container(
              alignment: Alignment.topRight,
              child: Card(
                elevation: 10,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.4,
                  width: MediaQuery.of(context).size.width / 4,
                  child: DefaultTabController(
                      length: 4,
                      child: Scaffold(
                        appBar: AppBar(
                          automaticallyImplyLeading: false,
                          elevation: 0,
                          flexibleSpace: const TabBar(tabs: [
                            Tab(icon: Icon(Icons.timeline)),
                            Tab(icon: Icon(Icons.chat)),
                            Tab(icon: Icon(Icons.bug_report)),
                            Tab(icon: Icon(Icons.info)),
                          ]),
                        ),
                        body: TabBarView(children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  ...users.map(
                                      (stockskis.SimpleUser user) => Expanded(
                                            child: Center(
                                              child: Text(
                                                user.name,
                                                style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          )),
                                ],
                              ),
                              Row(
                                children: [
                                  ...users.map(
                                      (stockskis.SimpleUser user) => Expanded(
                                            child: Center(
                                              child: Text(
                                                user.radlci > 5
                                                    ? "${user.radlci} ✪"
                                                    : List.generate(user.radlci,
                                                        (e) => "✪").join(" "),
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          )),
                                ],
                              ),
                              if (users.isNotEmpty)
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    child: ListView.builder(
                                      itemCount: users[0].points.length,
                                      itemBuilder:
                                          (BuildContext context, int index) =>
                                              GestureDetector(
                                        onTap: () {
                                          results = ResultsCompLayer
                                              .stockSkisToMessages(
                                            users.first.points[index].results,
                                          );
                                          setState(() {});
                                        },
                                        child: Row(
                                          children: [
                                            ...users.map(
                                              (e) => Expanded(
                                                child: Center(
                                                  child: Text(
                                                    e.points[index].points
                                                            .toString() +
                                                        (e.points[index]
                                                                    .playing &&
                                                                e.points[index]
                                                                    .radelc
                                                            ? e.points[index]
                                                                        .points >=
                                                                    0
                                                                ? " 🔺"
                                                                : " 🔻"
                                                            : ""),
                                                    style: TextStyle(
                                                      color: e.points[index]
                                                                  .points <
                                                              0
                                                          ? Colors.red
                                                          : (e.points[index]
                                                                      .points ==
                                                                  0
                                                              ? Colors.grey
                                                              : Colors.green),
                                                      fontSize: 12,
                                                      fontWeight: e
                                                              .points[index]
                                                              .playing
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
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
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ],
                          ),
                          Column(children: [
                            Expanded(
                              child: ListView(
                                children: chat
                                    .map((e) => Row(children: [
                                          Initicon(
                                            text: getUserFromPosition(e.userId)
                                                .name,
                                            elevation: 4,
                                            size: 40,
                                            backgroundColor: HSLColor.fromAHSL(
                                                    1,
                                                    hashCode(
                                                            getUserFromPosition(
                                                                    e.userId)
                                                                .name) %
                                                        360,
                                                    1,
                                                    0.6)
                                                .toColor(),
                                            borderRadius: BorderRadius.zero,
                                          ),
                                          const SizedBox(width: 10),
                                          Flexible(
                                            child: Text(
                                                "${getUserFromPosition(e.userId).name}: ${e.message}"),
                                          ),
                                        ]))
                                    .toList(),
                              ),
                            ),
                            TextField(
                              controller: _controller,
                              onSubmitted: (String value) async {
                                await sendMessage();
                              },
                            ),
                          ]),
                          ListView(children: [
                            const Center(
                              child: Text(
                                "Odpravljanje hroščev",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Text(
                              "Prva karta: ${firstCard == null ? '' : firstCard!.asset}",
                            ),
                            Text("Štih: $cardStih"),
                            Text("Izbran kralj: $selectedKing"),
                            Text("Uporabnik s kraljem: $userHasKing"),
                            Text("Karte založene: $stashAmount"),
                            Text("Talon izbran: $talonSelected"),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              onPressed: () {
                                validCards();
                                setState(() {});
                              },
                              child: const Text(
                                "Ponovno evaluiraj karte",
                              ),
                            ),
                          ]),
                          ListView(children: [
                            ...userWidgets.map(
                              (e) => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (e.id == userHasKing || e.licitiral > -1)
                                      Text(e.name,
                                          style: TextStyle(
                                            fontSize: userSquareSize / 3,
                                          )),
                                    const SizedBox(width: 20),
                                    if (e.licitiral > -1)
                                      Container(
                                        height: userSquareSize / 2,
                                        width: userSquareSize / 2,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          border: Border.all(
                                            color: zaruf
                                                ? Colors.red
                                                : Colors.black,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            GAME_DESC[e.licitiral + 1],
                                            style: TextStyle(
                                              fontSize: 0.3 * userSquareSize,
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (e.id == userHasKing ||
                                        (e.licitiral > -1 && e.licitiral < 6))
                                      Container(
                                        height: userSquareSize / 2,
                                        width: userSquareSize / 2,
                                        decoration: BoxDecoration(
                                          color: selectedKing == "/pik/kralj" ||
                                                  selectedKing == "/kriz/kralj"
                                              ? Colors.black
                                              : Colors.red,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: Center(
                                          child: Text(
                                              selectedKing == "/pik/kralj"
                                                  ? "♠️"
                                                  : (selectedKing ==
                                                          "/src/kralj"
                                                      ? "❤️"
                                                      : (selectedKing ==
                                                              "/kriz/kralj"
                                                          ? "♣️"
                                                          : "♦️")),
                                              style: TextStyle(
                                                  fontSize:
                                                      0.3 * userSquareSize)),
                                        ),
                                      ),
                                  ]),
                            ),
                            const Center(child: Text("Povabi prijatelje")),
                            ...prijatelji.map(
                              (e) => Row(
                                children: [
                                  Text("${e["User"]["Name"]}"),
                                  const Spacer(),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await invitePlayer(e["User"]["ID"]);
                                    },
                                    child: const Text("Povabi"),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  await manuallyStartGame();
                                },
                                child: const Text("Začni igro"),
                              ),
                            ),
                          ]),
                        ]),
                      )),
                ),
              ),
            ),

            // EVAL BAR
            if (widget.bots)
              Positioned(
                top: 0,
                right: MediaQuery.of(context).size.width / 4,
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

            if (widget.bots)
              Positioned(
                top: MediaQuery.of(context).size.height / 3 + 25,
                right: MediaQuery.of(context).size.width / 4 + 20,
                child: Text(
                  (eval).toStringAsFixed(1),
                ),
              ),

            // ŠTIHI
            if (widget.playing == 3 && !(widget.bots && SLEPI_TAROK))
              ...stihi3(
                cardK,
                m,
                center,
                leftFromTop,
                cardToWidth,
              ),
            if (widget.playing == 4 && !(widget.bots && SLEPI_TAROK))
              ...stihi4(
                cardK,
                m,
                center,
                leftFromTop,
                cardToWidth,
              ),

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
                        if (!turn && PREMOVE) {
                          resetPremoves();
                          premovedCard = cards[entry.key];
                          cards[entry.key].showZoom = true;
                          setState(() {});
                          return;
                        }
                        sendCard(entry.value);
                      },
                      child: MouseRegion(
                        onEnter: (event) {
                          setState(() {
                            if (entry.key >= cards.length) return;
                            if (cards[entry.key].asset != entry.value.asset) {
                              return;
                            }
                            cards[entry.key].showZoom = true;
                          });
                        },
                        onExit: (event) {
                          setState(() {
                            if (entry.key >= cards.length) return;
                            if (cards[entry.key].asset != entry.value.asset) {
                              return;
                            }
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
                                  Container(
                                    color: Colors.white,
                                    height: cardSize,
                                    width: cardWidth,
                                  ),
                                  SizedBox(
                                    height: cardSize,
                                    width: cardWidth,
                                    child: Center(
                                      child: Image.asset(
                                        "assets/tarok${entry.value.asset}.webp",
                                      ),
                                    ),
                                  ),
                                  if (!turn)
                                    Container(
                                      color: Colors.red.withAlpha(120),
                                      height: cardSize,
                                      width: cardWidth,
                                    ),
                                  if (turn && !cards[entry.key].valid)
                                    Container(
                                      color: Colors.red.withAlpha(120),
                                      height: cardSize,
                                      width: cardWidth,
                                    ),
                                  if (turn &&
                                          (currentPredictions != null &&
                                              currentPredictions!
                                                      .pagatUltimo.id !=
                                                  "" &&
                                              entry.value.asset ==
                                                  "/taroki/pagat") ||
                                      (currentPredictions != null &&
                                          currentPredictions!.kraljUltimo.id !=
                                              "" &&
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

            // IMENA
            if (widget.playing == 4)
              ...generateNames4(leftFromTop, m, cardK, userSquareSize),
            if (widget.playing == 3)
              ...generateNames3(leftFromTop, m, cardK, userSquareSize),

            // LICITIRANJE
            if (licitiranje)
              DraggableWidget(
                initialPosition: AnchoringPosition.center,
                child: Card(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ...users.map(
                                (stockskis.SimpleUser user) => Row(
                                  children: [
                                    Column(
                                      children: [
                                        Center(
                                          child: Text(
                                            user.name,
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            user.licitiral == -2
                                                ? ""
                                                : stockskis
                                                    .GAMES[user.licitiral + 1]
                                                    .name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (licitiram)
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width / 2),
                              child: GridView.count(
                                shrinkWrap: true,
                                primary: false,
                                padding: const EdgeInsets.all(20),
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                crossAxisCount: 4,
                                childAspectRatio: 3,
                                children: [
                                  ...games.map((e) {
                                    if (users.length == 3 && !e.playsThree) {
                                      return const SizedBox();
                                    }
                                    return SizedBox(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              suggestions.contains(e.id)
                                                  ? Colors.purpleAccent.shade400
                                                  : null,
                                          textStyle: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                30,
                                          ),
                                        ),
                                        onPressed: () => licitiranjeSend(e),
                                        child: Text(
                                          e.name,
                                        ),
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
              ),

            // KRALJI
            if (kingSelection)
              DraggableWidget(
                initialPosition: AnchoringPosition.center,
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ...KINGS.map(
                              (king) => GestureDetector(
                                onTap: () => selectKing(king.asset),
                                child: Stack(
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              10 * border),
                                          child: SizedBox(
                                            height: popupCardSize,
                                            child: Stack(
                                              children: [
                                                Container(
                                                  color: Colors.white,
                                                  height: popupCardSize,
                                                  width: popupCardSize * 0.57,
                                                ),
                                                Image.asset(
                                                    "assets/tarok${king.asset}.webp"),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                    if (selectedKing != king.asset &&
                                        !kingSelect)
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10 * border),
                                        child: Container(
                                          color: Colors.black.withAlpha(100),
                                          height: popupCardSize,
                                          width: popupCardSize * 0.57,
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
              DraggableWidget(
                initialPosition: AnchoringPosition.center,
                child: Card(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DataTable(
                            dataRowMaxHeight: 40,
                            dataRowMinHeight: 40,
                            headingRowHeight: 40,
                            columns: <DataColumn>[
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'Igra (${stockskis.GAMES[currentPredictions!.gamemode + 1].name == "Naprej" ? "Klop" : stockskis.GAMES[currentPredictions!.gamemode + 1].name})',
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(users.map((e) {
                                    if (e.id == currentPredictions!.igra.id) {
                                      return e.name;
                                    }
                                    return "";
                                  }).join("")),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Row(
                                    children: [
                                      Text(
                                          "${KONTRE[currentPredictions!.igraKontra]} (${users.map((e) {
                                        if (e.id ==
                                            currentPredictions!.igraKontraDal
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
                              ),
                            ],
                            rows: <DataRow>[
                              if (!(valat ||
                                  barvic ||
                                  currentPredictions!.gamemode >= 6 ||
                                  currentPredictions!.gamemode == -1))
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
                              if (!(valat ||
                                  barvic ||
                                  currentPredictions!.gamemode >= 6 ||
                                  currentPredictions!.gamemode == -1))
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
                              if (!(valat ||
                                  barvic ||
                                  currentPredictions!.gamemode >= 6 ||
                                  currentPredictions!.gamemode == -1))
                                DataRow(
                                  cells: <DataCell>[
                                    const DataCell(Text('Pagat ultimo')),
                                    if (myPredictions != null &&
                                        myPredictions!.pagatUltimo &&
                                        !kraljUltimo)
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
                              if (!(valat ||
                                  barvic ||
                                  currentPredictions!.gamemode >= 6 ||
                                  currentPredictions!.gamemode == -1))
                                DataRow(
                                  cells: <DataCell>[
                                    const DataCell(Text('Kralj ultimo')),
                                    if (myPredictions != null &&
                                        myPredictions!.kraljUltimo &&
                                        !pagatUltimo)
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
                              if (!(valat ||
                                  currentPredictions!.gamemode >= 6 ||
                                  currentPredictions!.gamemode <= 2 ||
                                  currentPredictions!.gamemode == -1 ||
                                  !playing))
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
                              if (!(barvic ||
                                  currentPredictions!.gamemode >= 6 ||
                                  currentPredictions!.gamemode == -1 ||
                                  !playing))
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
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
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
                  ),
                ),
              ),

            // TALON
            if (showTalon)
              DraggableWidget(
                initialPosition: AnchoringPosition.center,
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (selectedKing != "")
                          Text(
                            "${users.map((e) {
                              //debugPrint("igra ${currentPredictions!.igra.id} ${e.id}");
                              if (e.id == currentPredictions!.igra.id) {
                                return e.name;
                              }
                              return "";
                            }).join("")} igra v ${selectedKing == "/pik/kralj" ? "piku" : selectedKing == "/kara/kralj" ? "kari" : selectedKing == "/src/kralj" ? "srcu" : "križu"}.",
                          ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...talon.asMap().entries.map(
                                  (stih) => GestureDetector(
                                    onTap: () => selectTalon(stih.key),
                                    child: SizedBox(
                                      width: popupCardSize *
                                              0.573 *
                                              (1 +
                                                  kCoverUp *
                                                      (stih.value.length - 1)) +
                                          stih.value.length * 3,
                                      height: popupCardSize,
                                      child: Stack(
                                        children: [
                                          ...stih.value.asMap().entries.map(
                                                (entry) => Positioned(
                                                  left: (popupCardSize *
                                                          0.573 *
                                                          kCoverUp *
                                                          entry.key)
                                                      .toDouble(), // neka bs konstanta, ki izvira iz nekaj vrstic bolj gor
                                                  // ali imam mentalne probleme? ja.
                                                  // ali me briga? ne.
                                                  // fuck bad code quality
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius
                                                        .circular(10 *
                                                            (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                1000)),
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          color: Colors.white,
                                                          width: popupCardSize *
                                                              0.57,
                                                          height: popupCardSize,
                                                        ),
                                                        SizedBox(
                                                          height: popupCardSize,
                                                          child: Image.asset(
                                                            "assets/tarok${entry.value.asset}.webp",
                                                          ),
                                                        ),
                                                        if (talonSelected !=
                                                                -1 &&
                                                            talonSelected !=
                                                                stih.key)
                                                          Container(
                                                            color: Colors.black
                                                                .withAlpha(100),
                                                            height:
                                                                popupCardSize,
                                                            width:
                                                                popupCardSize *
                                                                    0.57,
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
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

            // ZALOŽITEV KART
            // POTRDI ZALOŽITEV
            if (stashedCards.length >= stashAmount && stashAmount > 0)
              DraggableWidget(
                initialPosition: AnchoringPosition.center,
                child: Card(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Trenutno si zalagate naslednje karte.",
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...stashedCards.map(
                                (king) => Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10 *
                                          (MediaQuery.of(context).size.width /
                                              800)),
                                      child: SizedBox(
                                        height: popupCardSize,
                                        child: Stack(
                                          children: [
                                            Container(
                                              color: Colors.white,
                                              height: popupCardSize,
                                              width: popupCardSize * 0.57,
                                            ),
                                            Image.asset(
                                                "assets/tarok${king.asset}.webp"),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  await stashEnd(true);
                                  stashedCards = [];
                                  setState(() {});
                                },
                                child: const Text(
                                  "Potrdi",
                                ),
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: () async {
                                  int k = stashedCards.length;
                                  for (int i = 0; i < k; i++) {
                                    debugPrint(
                                        "return card: ${stashedCards[0]}");
                                    cards.add(stashedCards[0]);
                                    stashedCards.removeAt(0);
                                  }
                                  turn = true;
                                  sortCards();
                                  setState(() {});
                                },
                                child: const Text(
                                  "Zamenjaj karte",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // REZULTATI IGRE
            if (results != null)
              DraggableWidget(
                initialPosition: AnchoringPosition.center,
                child: Card(
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width < 1000
                            ? MediaQuery.of(context).size.width
                            : MediaQuery.of(context).size.width / 1.5,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...results!.user.map(
                            (e) => Column(
                              children: [
                                ...e.user.map(
                                  (e2) => e2.name != ""
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: Initicon(
                                                text: e2.name,
                                                elevation: 4,
                                                size: 30,
                                                backgroundColor:
                                                    HSLColor.fromAHSL(
                                                            1,
                                                            hashCode(e2.name) %
                                                                360,
                                                            1,
                                                            0.6)
                                                        .toColor(),
                                                borderRadius: BorderRadius.zero,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              e2.name,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                ),
                                DataTable(
                                  dataRowMaxHeight: 40,
                                  dataRowMinHeight: 40,
                                  headingRowHeight: 40,
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
                                          'Kontro dal',
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
                                          DataCell(Text(
                                              currentPredictions!.igra.name)),
                                          DataCell(Text(currentPredictions!
                                              .igraKontraDal.name)),
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
                                          const DataCell(Text("")),
                                          DataCell(
                                            Text(currentPredictions!
                                                .igraKontraDal.name),
                                          ),
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
                                          DataCell(Text(
                                              currentPredictions!.trula.name)),
                                          const DataCell(Text("")),
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
                                          DataCell(Text(
                                              currentPredictions!.kralji.name)),
                                          const DataCell(Text("")),
                                        ],
                                      ),
                                    if (e.showKralj)
                                      DataRow(
                                        cells: <DataCell>[
                                          const DataCell(Text('Kralj ultimo')),
                                          DataCell(Text(
                                              '${pow(2, e.kontraKralj)}x')),
                                          DataCell(Text(
                                            '${e.kralj}',
                                            style: TextStyle(
                                              color: e.kralj < 0
                                                  ? Colors.red
                                                  : Colors.green,
                                            ),
                                          )),
                                          DataCell(Text(currentPredictions!
                                              .kraljUltimo.name)),
                                          DataCell(Text(currentPredictions!
                                              .kraljUltimoKontraDal.name)),
                                        ],
                                      ),
                                    if (e.showPagat)
                                      DataRow(
                                        cells: <DataCell>[
                                          const DataCell(Text('Pagat ultimo')),
                                          DataCell(Text(
                                              '${pow(2, e.kontraPagat)}x')),
                                          DataCell(Text(
                                            '${e.pagat}',
                                            style: TextStyle(
                                              color: e.pagat < 0
                                                  ? Colors.red
                                                  : Colors.green,
                                            ),
                                          )),
                                          DataCell(Text(currentPredictions!
                                              .pagatUltimo.name)),
                                          DataCell(Text(currentPredictions!
                                              .pagatUltimoKontraDal.name)),
                                        ],
                                      ),
                                    if (e.mondfang)
                                      const DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text('Izguba monda')),
                                          DataCell(Text('/')),
                                          DataCell(Text(
                                            '-21',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          )),
                                          DataCell(Text("")),
                                          DataCell(Text("")),
                                        ],
                                      ),
                                    if (e.skisfang)
                                      const DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text('Škisfang')),
                                          DataCell(Text('/')),
                                          DataCell(Text(
                                            '-100',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          )),
                                          DataCell(Text("")),
                                          DataCell(Text("")),
                                        ],
                                      ),
                                    DataRow(
                                      cells: <DataCell>[
                                        const DataCell(Text('Skupaj')),
                                        const DataCell(Text('')),
                                        DataCell(
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                if (e.radelc)
                                                  TextSpan(
                                                    text:
                                                        '${e.points ~/ 2} * 2 = ',
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                TextSpan(
                                                  text: '${e.points}',
                                                  style: TextStyle(
                                                    color: e.points < 0
                                                        ? Colors.red
                                                        : Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const DataCell(Text("")),
                                        const DataCell(Text("")),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
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
                          const SizedBox(height: 30),

                          ElevatedButton(
                            onPressed: () {
                              razpriKarte = !razpriKarte;
                              setState(() {});
                            },
                            child: razpriKarte
                                ? const Text(
                                    "Skrij točkovanje po štihih",
                                  )
                                : const Text(
                                    "Prikaži točkovanje po štihih",
                                  ),
                          ),

                          // pobrane karte v štihu
                          if (razpriKarte)
                            const Text("Pobrane karte:",
                                style: TextStyle(fontSize: 30)),
                          if (razpriKarte)
                            Wrap(
                              children: [
                                ...results!.stih.asMap().entries.map(
                                      (e) => e.value.card.isNotEmpty
                                          ? Card(
                                              elevation: 6,
                                              child: Column(
                                                children: [
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    currentPredictions!
                                                                    .gamemode >=
                                                                0 &&
                                                            currentPredictions!
                                                                    .gamemode <=
                                                                5
                                                        ? (e.key == 0
                                                            ? "Založeno"
                                                            : e.key + 1 ==
                                                                    results!
                                                                        .stih
                                                                        .length
                                                                ? "Talon"
                                                                : "${e.key}. štih")
                                                        : (currentPredictions!
                                                                    .gamemode ==
                                                                -1
                                                            ? "${e.key + 1}. štih"
                                                            : (e.key + 1 ==
                                                                    results!
                                                                        .stih
                                                                        .length
                                                                ? "Talon"
                                                                : "${e.key + 1}. štih")),
                                                    style: TextStyle(
                                                      fontWeight: e.value
                                                              .pickedUpByPlaying
                                                          ? FontWeight.bold
                                                          : FontWeight.w300,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  SizedBox(
                                                    // neka bs konstanta, ki izvira iz nekaj vrstic bolj gor
                                                    // ali imam mentalne probleme? ja.
                                                    // ali me briga? ne.
                                                    // fuck bad code quality      (e) => SizedBox(
                                                    width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            8 *
                                                            0.573 *
                                                            (1 +
                                                                0.7 *
                                                                    (e.value.card
                                                                            .length -
                                                                        1)) +
                                                        e.value.card.length * 3,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            8,
                                                    child: Stack(
                                                      children: [
                                                        ...e.value.card
                                                            .asMap()
                                                            .entries
                                                            .map(
                                                              (entry) =>
                                                                  Positioned(
                                                                left: (MediaQuery.of(context)
                                                                            .size
                                                                            .height /
                                                                        8 *
                                                                        0.573 *
                                                                        0.7 *
                                                                        entry
                                                                            .key)
                                                                    .toDouble(),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius: BorderRadius.circular(10 *
                                                                      (MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          10000)),
                                                                  child: Stack(
                                                                    children: [
                                                                      Container(
                                                                        color: Colors
                                                                            .white,
                                                                        width: MediaQuery.of(context).size.height /
                                                                            8 *
                                                                            0.57,
                                                                        height:
                                                                            MediaQuery.of(context).size.height /
                                                                                8,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            MediaQuery.of(context).size.height /
                                                                                8,
                                                                        child: Image
                                                                            .asset(
                                                                          "assets/tarok${entry.value.id}.webp",
                                                                          filterQuality:
                                                                              FilterQuality.medium,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    "Štih je vreden ${e.value.worth.round()} ${e.value.worth == 3 || e.value.worth == 4 ? 'točke' : e.value.worth == 2 ? 'točki' : e.value.worth == 1 ? 'točko' : 'točk'}.",
                                                  ),
                                                  if (e.value.pickedUpBy != "")
                                                    Text(
                                                      "Štih je pobral ${e.value.pickedUpBy}.",
                                                    ),
                                                  const SizedBox(height: 10),
                                                ],
                                              ),
                                            )
                                          : const SizedBox(),
                                    ),
                              ],
                            ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              results = null;
                              setState(() {});
                            },
                            child: const Text(
                              "Zapri vpogled v rezultate",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // KONEC IGRE
            if (gameDone)
              DraggableWidget(
                initialPosition: AnchoringPosition.center,
                child: Card(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Hvala za igro",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          DataTable(
                            dataRowMaxHeight: 40,
                            dataRowMinHeight: 40,
                            headingRowHeight: 40,
                            columns: const <DataColumn>[
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'Igralec',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'Rezultat',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'Rating',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
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
                                          color:
                                              0 < 0 ? Colors.red : Colors.green,
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
              ),
          ],
        ),
      ),
      floatingActionButton: !(started && !widget.bots)
          ? FloatingActionButton(
              onPressed: () {
                try {
                  websocket.close(1000, 'CLOSE_NORMAL');
                } catch (e) {}
                Navigator.pop(context);
              },
              tooltip: 'Zapusti igro',
              child: const Icon(Icons.close),
            )
          : const SizedBox(),
    );
  }
}
