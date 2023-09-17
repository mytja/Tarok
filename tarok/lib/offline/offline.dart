import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:tarok/constants.dart';
import 'package:tarok/game/cardutils.dart';
import 'package:tarok/game/premoves.dart';
import 'package:tarok/game/utils.dart';
import 'package:tarok/game/variables.dart';
import 'package:tarok/offline/klop.dart';
import 'package:tarok/offline/utils.dart';
import 'package:tarok/sounds.dart';
import 'package:tarok/stockskis_compatibility/interfaces/predictions.dart';
import 'package:tarok/messages.pb.dart' as Messages;
import 'package:stockskis/stockskis.dart' as stockskis;
import 'package:tarok/stockskis_compatibility/interfaces/results.dart';
import 'package:tarok/stockskis_compatibility/interfaces/start_predictions.dart';

class OfflineGame {
  OfflineGame({required this.setState});
  final Function setState;

  Future<void> startGame() async {
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
      for (int i = 1; i < playingCount; i++) {
        String botType = "normal";
        String botName = botNames[Random().nextInt(botNames.length)];
        if (l >= playingCount - 1) {
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
        stihiCount: ((54 - 6) / playingCount).floor(),
        predictions: stockskis.Predictions(),
      )..skisfang = SKISFANG;
    } else {
      // naslednja igra, samo resetiramo vrednosti pri sedanjih botih
      stockskisContext!.resetContext();
      logger.d("[bStartGame] stockskisContext!.resetContext() called");
    }

    logger.i(
      {
        "users": users.map((e) => '${e.id}/${e.name}').join(' '),
      },
    );

    currentPredictions = Messages.Predictions();
    stockskisContext!.doRandomShuffle();
    List<stockskis.Card> myCards = stockskisContext!.users["player"]!.cards;
    cards = myCards.map((card) => card.card).toList();
    users = stockskisContext!.buildPositionsSimple();
    stockskisContext!.selectedKing = "";

    if (userWidgets.isEmpty) {
      // sebe sploh ne smem dat med userWidgetse, razen kot zadnjega
      userWidgets = stockskisContext!.buildPositionsSimple();
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
    licitate(0);
  }

  Future<void> licitate(int startAt) async {
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
          stockskisContext!.users[users[i].id]!.playing = true;
          stockskisContext!.users[users[i].id]!.secretlyPlaying = true;
          stockskisContext!.users[users[i].id]!.licitiral = true;
          stockskisContext!.gamemode = m;
          if (m > -1 && m < 3) {
            stockskisContext!.kingFallen = false;
          } else {
            stockskisContext!.kingFallen = true;
          }
          debugPrint("set the game to ${users[i].id} using method 1");
          currentPredictions!.igra = Messages.User(
            id: users[i].id,
            name: users[i].name,
          );
          currentPredictions!.gamemode = m;
          stockskisContext!.predictions =
              PredictionsCompLayer.messagesToStockSkis(currentPredictions!);
          licitiranje = false;
          await startKingSelection(users[i].id);
          return;
        }
      }
      if (m == -1) {
        debugPrint("začenjam rundo klopa");
        // začnemo klopa pri obveznem
        stockskisContext!.users[users.last.id]!.licitiral = true;
        stockskisContext!.users[users.last.id]!.playing = true;
        stockskisContext!.users[users.last.id]!.secretlyPlaying = true;
        currentPredictions!.igra = Messages.User(
          id: users.last.id,
          name: users.last.name,
        );
        currentPredictions!.gamemode = -1;
        stockskisContext!.predictions =
            PredictionsCompLayer.messagesToStockSkis(currentPredictions!);
        predict(0);
      }
      return;
    }

    if (startAt == 0) {
      logger.i(
          "Povečujem krog licitiranja, prej na ${stockskisContext!.krogovLicitiranja}");
      stockskisContext!.krogovLicitiranja++;
    }

    for (int i = startAt; i < users.length; i++) {
      Sounds.click();

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
        suggestions = stockskisContext!.suggestModes(
          user.id,
          canLicitateThree: isMandatory,
        );
        return;
      }

      await Future.delayed(const Duration(milliseconds: 400), () {
        setState(() {});
      });

      List<int> botSuggestions = stockskisContext!.suggestModes(
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
          stockskisContext!.predictions =
              PredictionsCompLayer.messagesToStockSkis(currentPredictions!);
          await startKingSelection(users[n].id);
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
              stockskisContext!.gamemode = botSuggestions.last;
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
    licitate(0);
  }

  void setPointsResults() {
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

  Future<void> getResults() async {
    debugPrint("Gamemode stockškis konteksta je ${stockskisContext!.gamemode}");
    results =
        ResultsCompLayer.stockSkisToMessages(stockskisContext!.calculateGame());
    setPointsResults();
    setState(() {});
    if (!stockskis.AUTOSTART_GAME) return;
    await Future.delayed(const Duration(seconds: 10), () {
      startGame();
    });
  }

  Future<void> cleanStih() async {
    if (zaruf) {
      List<stockskis.Card> zadnjiStih = stockskisContext!.stihi.last;
      stockskis.StihAnalysis? analysis =
          stockskisContext!.analyzeStih(zadnjiStih);
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
          "Talon: ${stockskisContext!.talon.map((e) => e.card.asset).join(" ")}",
        );
        int len = stockskisContext!.talon.length;
        for (int i = 0; i < len; i++) {
          stockskis.Card karta = stockskisContext!.talon[0];
          debugPrint(
            "Dodeljujem karto ${karta.card.asset} z vrednostjo ${karta.card.worth} zarufancu. stockskisContext!.stihi[0].length = ${stockskisContext!.stihi[0].length}",
          );
          karta.user = analysis.cardPicks.user;
          stockskisContext!.stihi[0].add(karta);
          stockskisContext!.talon.removeAt(0);
        }
        debugPrint("Talon je bil dodeljen zarufancu");
      }
    }

    klopTalon(setState);

    await Future.delayed(const Duration(seconds: 1), () {
      List<stockskis.Card> zadnjiStih = stockskisContext!.stihi.last;
      if (zadnjiStih.isEmpty) return;
      String pickedUpBy = stockskisContext!.stihPickedUpBy(zadnjiStih);
      int k = 0;
      for (int i = 1; i < users.length; i++) {
        if (users[i].id == pickedUpBy) {
          k = i;
          break;
        }
      }
      final analysis = stockskisContext!.analyzeStih(zadnjiStih);
      debugPrint(
        "Cleaning. Picked up by $pickedUpBy. ${analysis!.cardPicks.card.asset}/${analysis.cardPicks.user}",
      );

      // preveri, kdo je dubu ta štih in naj on začne
      stih = [];
      cardStih = [];
      stihBoolValues = {};
      firstCard = null;
      stockskisContext!.stihi.add([]);
      setState(() {});
      validCards();
      play(k);
    });
  }

  Future<void> play(int startAt) async {
    licitiram = false;
    licitiranje = false;
    showTalon = false;
    predictions = false;
    myPredictions = null;
    int i = startAt;

    while (true) {
      if (i >= stockskisContext!.users.length) i = 0;
      stockskis.User pos =
          stockskisContext!.users[stockskisContext!.userPositions[i]]!;
      debugPrint(
        "Card length: ${pos.cards.length}; User: ${pos.user.id}/${pos.user.name}; i: $i",
      );
      if (pos.cards.isEmpty) {
        debugPrint("Calculating results");
        getResults();
        return;
      }
      if (pos.user.id == "player") {
        if (pos.cards.length == 1) {
          logger.d(
              "stockskisContext!.users['player'].cards.length is 1. Autodropping card.");
          turn = true;
          setState(() {});
          await ws.sendCard(pos.cards[0].card);
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
          debugPrint("Dropping premoved card ${premovedCard!.asset}");
          await ws.sendCard(premovedCard!);
          setState(() {});
          return;
        }
        setState(() {});
        return;
      }
      List<stockskis.Move> moves = stockskisContext!.evaluateMoves(pos.user.id);
      //print(moves);
      //print(stockskisContext!.stihi.last);
      //print(stockskisContext!.users["bot1"]!.cards);
      stockskis.Move bestMove = moves.first;
      for (int i = 1; i < moves.length; i++) {
        if (bestMove.evaluation < moves[i].evaluation) bestMove = moves[i];
      }

      inspect(bestMove); // Dart Debugger
      if (stockskisContext!.stihi.last.isEmpty) firstCard = bestMove.card.card;
      stockskisContext!.stihi.last.add(bestMove.card);
      stockskisContext!.users[pos.user.id]!.cards.remove(bestMove.card);
      await Future.delayed(const Duration(milliseconds: 400), () async {});
      debugPrint("Dodajam v štih");
      Sounds.card();
      if (await ws.addToStih(pos.user.id, "player", bestMove.card.card.asset)) {
        return;
      }
      i++;
      setState(() {});
      debugPrint(
          "StockŠkis štih: ${stockskisContext!.stihi.last.length}, Uporabniki: ${stockskisContext!.users.length}, Zaruf: $zaruf");
      if (stockskisContext!.stihi.last.length ==
          stockskisContext!.users.length) {
        await cleanStih();
        return;
      }
    }
  }

  Future<void> predict(int start) async {
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
      Sounds.click();

      // napovej barvića in valata po izbiri v napovedih
      if (currentPredictions!.valat.id != "") {
        currentPredictions!.gamemode = 10;
        stockskisContext!.gamemode = 10;
      } else if (currentPredictions!.barvniValat.id != "") {
        currentPredictions!.gamemode = 9;
        stockskisContext!.gamemode = 9;
      }

      if (sinceLastPrediction >= playingCount) {
        logger.i("Gamemode: ${stockskisContext!.gamemode}");
        if (stockskisContext!.gamemode >= 6) {
          play(stockskisContext!.playingPerson());
          return;
        }
        play(users.length - 1);
        return;
      }
      stockskis.User u =
          stockskisContext!.users[stockskisContext!.userPositions[k]]!;
      debugPrint(
          "User with ID ${u.user.id}. k=$k, sinceLastPrediction=$sinceLastPrediction");
      if (u.user.id == "player") {
        myPredictions = StartPredictionsCompLayer.stockSkisToMessages(
          stockskisContext!.getStartPredictions("player"),
        );
        startPredicting = true;
        sinceLastPrediction++;
        setState(() {});
        return;
      }
      bool changed = stockskisContext!.predict(u.user.id);
      if (changed) {
        sinceLastPrediction = 0;
      }
      currentPredictions = PredictionsCompLayer.stockSkisToMessages(
        stockskisContext!.predictions,
      );
      k++;
      if (k >= stockskisContext!.userPositions.length) k = 0;
      userHasKing = currentPredictions!.kraljUltimo.id;
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 500), () {});
      sinceLastPrediction++;
    }
  }

  Future<void> startTalon(String playerId) async {
    debugPrint("Talon");
    talon = [];
    int game = getPlayedGame();
    if (game == -1 || game >= 6) {
      predict(stockskisContext!.playingPerson());
      return;
    }
    debugPrint("Talon1");
    showTalon = true;

    var (stockskisTalon, talon1, zaruf1) =
        stockskisContext!.getStockskisTalon();
    talon = talon1;
    zaruf = zaruf1;

    if (playerId == "player") {
      playing = true;
      setState(() {});
      return;
    }

    talonSelected = stockskisContext!.selectDeck(playerId, stockskisTalon);
    List<stockskis.Card> selectedCards = stockskisTalon[talonSelected];
    debugPrint(
      "Izbrane karte: ${selectedCards.map((e) => e.card.asset).join(" ")}",
    );
    for (int i = 0; i < selectedCards.length; i++) {
      stockskis.Card s = selectedCards[i];
      stockskisContext!.talon.remove(s);
      s.user = playerId;
      stockskisContext!.users[playerId]!.cards.add(s);
    }
    setState(() {});
    debugPrint(
      "Talon: ${stockskisContext!.talon.map((e) => e.card.asset).join(" ")}",
    );
    String king = selectedKing == "" ? "" : selectedKing.split("/")[1];

    Sounds.click();

    int m = 0;
    if (game == 0 || game == 3) m = 2;
    if (game == 1 || game == 4) m = 3;
    if (game == 2 || game == 5) m = 6;
    List<stockskis.Card> stash =
        stockskisContext!.stashCards(playerId, (6 / m).round(), king);
    for (int i = 0; i < stash.length; i++) {
      stockskis.Card s = stash[i];
      stockskisContext!.users[playerId]!.cards.remove(s);
      s.user = playerId;
      stockskisContext!.stihi[0].add(stash[i]);
    }
    stockskisContext!.stihi.add([]);
    stockskisContext!.sortAllCards();
    setState(() {});
    firstCard = null;
    debugPrint(
      "Talon: ${stockskisContext!.talon.map((e) => e.card.asset).join(" ")}",
    );
    await Future.delayed(const Duration(seconds: 2), () {
      predict(stockskisContext!.playingPerson());
    });
  }

  Future<void> startKingSelection(String playerId) async {
    int game = getPlayedGame();
    if (game == -1 || game >= 3 || users.length == 3) {
      startTalon(playerId);
      return;
    }
    kingSelection = true;
    if (playerId == "player") {
      kingSelect = true;
      return;
    }
    kingSelect = false;
    Sounds.click();
    selectedKing = stockskisContext!.selectKing(playerId);
    setState(() {});
    await Future.delayed(const Duration(seconds: 2), () {
      kingSelection = false;
      stockskisContext!.selectSecretlyPlaying(selectedKing);
      startTalon(playerId);
      setState(() {});
    });
  }
}
