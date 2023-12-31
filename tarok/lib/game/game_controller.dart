// Tarok Palčka - a simple tarock program.
// Copyright (C) 2023 Mitja Ševerkar
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

// ignore_for_file: library_prefixes

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:dart_discord_rpc/dart_discord_rpc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:get/get.dart';
import 'package:rounded_background_text/rounded_background_text.dart';
import 'package:stockskis/stockskis.dart' as stockskis;
import 'package:tarok/constants.dart';
import 'package:tarok/game/variables.dart';
import 'package:tarok/messages/messages.pb.dart' as Messages;
import 'package:tarok/sounds.dart';
import 'package:tarok/stockskis_compatibility/interfaces/predictions.dart';
import 'package:tarok/stockskis_compatibility/interfaces/results.dart';
import 'package:tarok/stockskis_compatibility/interfaces/start_predictions.dart';
import 'package:tarok/timer.dart';
import 'package:web_socket_client/web_socket_client.dart';

class GameController extends GetxController {
  var users = <stockskis.SimpleUser>[].obs;
  var talon = <List<stockskis.LocalCard>>[].obs;
  var cards = <stockskis.LocalCard>[].obs;
  var stashedCards = <stockskis.LocalCard>[].obs;
  var zalozeniTaroki = <stockskis.LocalCard>[].obs;
  var firstCard = Rxn<stockskis.LocalCard>();
  var stih = <CardWidget>[].obs;
  var cardStih = <String>[].obs;
  var userWidgets = <stockskis.SimpleUser>[].obs;
  var games = stockskis.GAMES.toList().obs;
  var suggestions = <int>[].obs;
  var stihBoolValues = <int, bool>{}.obs;

  var lp = false.obs;
  var turn = false.obs;
  var licitiranje = false.obs;
  var licitiram = false.obs;
  var started = false.obs;
  var isPlaying = false.obs;
  var stash = false.obs;
  var showTalon = false.obs;
  var predictions = false.obs;
  var startPredicting = false.obs;
  var kingSelection = false.obs;
  var kingSelect = false.obs;
  var bots = true;
  var zaruf = false.obs;
  var gameDone = false.obs;
  var requestedGameEnd = false.obs;
  var playingCount = 0.obs;
  var myPosition = 0.obs;
  var stashAmount = 0.obs;
  var talonSelected = (-1).obs;
  var selectedKing = "".obs;
  var userHasKing = "".obs;
  var myPredictions = Rxn<Messages.StartPredictions>();
  var currentPredictions = Rxn<Messages.Predictions>();
  var results = Rxn<Messages.Results>();
  var premovedCard = Rxn<stockskis.LocalCard>();
  var eval = 0.0.obs;
  var sinceLastPrediction = 0.obs;
  var countdown = 0.obs;
  var chat = <Messages.ChatMessage>[].obs;
  var razpriKarte = false.obs;

  var kontraIgra = false.obs;
  var kontraPagat = false.obs;
  var kontraKralj = false.obs;
  var kontraMondfang = false.obs;
  var trula = false.obs;
  var kralji = false.obs;
  var kraljUltimo = false.obs;
  var pagatUltimo = false.obs;
  var valat = false.obs;
  var barvic = false.obs;
  var mondfang = false.obs;

  var gamesPlayed = 0.obs;
  var gamesRequired = (-1).obs;
  var canExtendGame = true.obs;

  var unreadMessages = 0.obs;

  var tournamentGame = false.obs;

  var playerId = "player".obs;

  Timer? currentTimer;

  final bool bbots = Get.parameters["bots"] == "true";
  final String gameId = Get.parameters["gameId"]!;
  final int playing = int.parse(Get.parameters["playing"]!);
  final bool replay = Get.parameters["replay"] == "true";

  stockskis.StockSkis? stockskisContext;
  var controller = TextEditingController().obs;
  var gameLinkController = TextEditingController().obs;
  List prijatelji = [].obs;

  late final WebSocket socket;

  /*
  INIT FUNCTIONS
  */
  @override
  void onInit() async {
    playingCount.value = playing;
    bots = bbots;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    if (!kIsWeb && (Platform.isLinux || Platform.isWindows)) {
      rpc.updatePresence(
        DiscordPresence(
          details: 'Igra igro ${bots ? "z boti" : "z igralci"}',
          startTimeStamp: DateTime.now().millisecondsSinceEpoch,
          largeImageKey: 'palcka_logo',
          largeImageText: 'Tarok Palčka',
        ),
      );
    }

    // BOTI - OFFLINE
    if (bots) {
      playerId.value = "player";
      canExtendGame.value = false;
      bStartGame();
      super.onInit();
      return;
    }

    // ONLINE
    connect(gameId);
    listen();

    super.onInit();
  }

  @override
  void onClose() {
    controller.value.dispose();

    if (!kIsWeb && (Platform.isLinux || Platform.isWindows)) {
      rpc.updatePresence(
        DiscordPresence(
          details: 'Gleda na začetni zaslon',
          startTimeStamp: DateTime.now().millisecondsSinceEpoch,
          largeImageKey: 'palcka_logo',
          largeImageText: 'Tarok Palčka',
        ),
      );
    }

    try {
      socket.close();
    } catch (e) {}
    super.dispose();
  }

  /*
  HELPER FUNCTIONS
  */
  void connect(String gameId) {
    final backoff = LinearBackoff(
      initial: const Duration(seconds: 1),
      increment: const Duration(seconds: 1),
      maximum: const Duration(seconds: 5),
    );
    const timeout = Duration(seconds: 10);
    final uri = Uri.parse('$WS_URL/$gameId');
    debugPrint("requesting to $uri");
    socket = WebSocket(
      uri,
      binaryType: "arraybuffer",
      backoff: backoff,
      timeout: timeout,
    );
  }

  List<Widget> gameListAssemble(double fullHeight) {
    List<Widget> gameListAssembly = [];
    if (games.isEmpty) return gameListAssembly;

    int missingGames = games.length < 2 ? 0 : games[1].id;

    for (int i = 0; i < games.length; i++) {
      var e = games[i];
      if (users.length == 3 && !e.playsThree) {
        continue;
      }
      gameListAssembly.add(
        SizedBox(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: suggestions.contains(e.id)
                  ? Colors.purpleAccent.shade400
                  : null,
              textStyle: TextStyle(
                fontSize: fullHeight / 35,
              ),
            ),
            onPressed: () async {
              await licitiranjeSend(e);
            },
            child: Text(
              e.name.tr,
            ),
          ),
        ),
      );
      if (e.id == -1) {
        for (int i = 0; i < missingGames; i++) {
          gameListAssembly.add(const SizedBox());
        }
      }
      if (e.id == 2 || e.id == 5 || e.id == 8) {
        gameListAssembly.add(const SizedBox());
      }
    }
    return gameListAssembly;
  }

  bool hasCard(String asset) {
    for (int i = 0; i < cards.length; i++) {
      if (cards[i].asset != asset) continue;
      return true;
    }
    return false;
  }

  void resetPredictions() {
    kontraIgra.value = false;
    kontraPagat.value = false;
    kontraKralj.value = false;
    trula.value = false;
    kralji.value = false;
    kraljUltimo.value = false;
    pagatUltimo.value = false;
    valat.value = false;
    mondfang.value = false;
    kontraMondfang.value = false;
    barvic.value = false;
  }

  void resetPremoves() {
    for (int i = 0; i < cards.length; i++) {
      cards[i].showZoom = false;
    }
    cards.refresh();
  }

  void validCards() {
    if (stash.value) {
      for (int i = 0; i < cards.length; i++) {
        cards[i].valid = cards[i].worth != 5;
      }
      cards.refresh();
      return;
    }

    debugPrint(
      "Poklicana funkcija validCards, firstCard=${firstCard.value?.asset}, cardStih=$cardStih",
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

    if (firstCard.value == null) {
      for (int i = 0; i < cards.length; i++) {
        cards[i].valid = true;
        if (gamemode == -1 || gamemode == 6 || gamemode == 8) {
          if (cards[i].asset == "/taroki/pagat" && cards.length != 1) {
            cards[i].valid = false;
          }
        }
      }
      cards.refresh();
      return;
    }

    final color = firstCard.value!.asset.split("/")[1];
    for (int i = 0; i < cards.length; i++) {
      cards[i].valid = false;
      if (cards[i].asset.contains("taroki")) taroki++;
      if (cards[i].asset.contains(color)) imaBarvo = true;
    }

    int trula = 0;
    for (int i = 0; i < cardStih.length; i++) {
      String card = cardStih[i];
      if (card == "/taroki/mond" || card == "/taroki/skis") {
        trula++;
      }
    }

    if (trula == 2) {
      for (int i = 0; i < cards.length; i++) {
        if (cards[i].asset == "/taroki/pagat") {
          cards[i].valid = true;
          return;
        }
      }
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

    if (firstCard.value!.asset.contains("taroki")) {
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
    cards.refresh();
  }

  void sortCards() {
    cards.value = sortCardsToUser(cards);
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
    users.refresh();
  }

  void bKlopTalon() {
    if (stockskisContext!.gamemode == -1 &&
        stockskisContext!.talon.isNotEmpty) {
      stockskis.Card card = stockskisContext!.talon.first;
      stockskisContext!.talon.removeAt(0);
      card.user = "talon";
      stockskisContext!.stihi.last.add(card);
      cardStih.add(card.card.asset);
      stih.add(CardWidget(
        position: 100,
        widget: Image(
          image: AssetImage("assets/tarok${card.card.asset}.webp"),
        ),
        angle: (Random().nextDouble() - 0.5) / ANGLE,
      ));
    }
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

  void copyGames() {
    games.value = [
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

  Future<void> login() async {
    final token = await storage.read(key: "token");
    final Uint8List message =
        Messages.Message(loginInfo: Messages.LoginInfo(token: token))
            .writeToBuffer();
    socket.send(message);
  }

  Future<void> gameEndSend(int after) async {
    debugPrint("Called gameEndSend");
    if (bots) return;
    debugPrint("Sending the GameEnd packet");
    requestedGameEnd.value = true;
    final Uint8List message = Messages.Message(
            gameEnd: Messages.GameEnd(request: Messages.Request(count: after)))
        .writeToBuffer();
    socket.send(message);
    debugPrint("Sent the GameEnd packet");
  }

  Future<void> gameStartEarly() async {
    debugPrint("Called gameStartEarly");
    if (bots) return;
    debugPrint("Sending the StartEarly packet");
    requestedGameEnd.value = true;
    final Uint8List message =
        Messages.Message(startEarly: Messages.StartEarly()).writeToBuffer();
    socket.send(message);
    debugPrint("Sent the StartEarly packet");
  }

  Future<void> sendMessageString(String m) async {
    if (bots) return;
    unreadMessages.value = 0;
    final Uint8List message = Messages.Message(
      chatMessage: Messages.ChatMessage(
        userId: playerId.value,
        message: m,
      ),
    ).writeToBuffer();
    socket.send(message);
  }

  Future<void> sendReplayNext() async {
    if (bots) return;
    if (!replay) return;
    final Uint8List message = Messages.Message(
      replayMove: Messages.ReplayMove(),
    ).writeToBuffer();
    socket.send(message);
  }

  Future<void> sendReplayGame(int game) async {
    if (bots) return;
    if (!replay) return;
    final Uint8List message = Messages.Message(
      replaySelectGame: Messages.ReplaySelectGame(game: game),
    ).writeToBuffer();
    socket.send(message);
  }

  Future<void> sendMessage() async {
    if (bots) return;
    unreadMessages.value = 0;
    final Uint8List message = Messages.Message(
      chatMessage: Messages.ChatMessage(
        userId: playerId.value,
        message: controller.value.text,
      ),
    ).writeToBuffer();
    socket.send(message);
    controller.value.text = "";
  }

  Future<void> stashCard(stockskis.LocalCard card) async {
    debugPrint("Klicana funkcija stashCard");
    if (card.worth == 5) return; // ne mormo si založit kraljev in trule
    stashedCards.add(card);
    cards.remove(card);
    if (stashedCards.length == stashAmount.value) {
      turn.value = false;
    }
    debugPrint(
      "stashedCards.length=${stashedCards.length}, stashAmount=$stashAmount",
    );
    await stashEnd(AVTOPOTRDI_ZALOZITEV);
  }

  Future<void> predict() async {
    if (currentPredictions.value == null) return;
    if (trula.value) {
      currentPredictions.value!.trula =
          Messages.User(id: playerId.value, name: name);
    }
    if (kralji.value) {
      currentPredictions.value!.kralji =
          Messages.User(id: playerId.value, name: name);
    }
    if (kraljUltimo.value) {
      currentPredictions.value!.kraljUltimo =
          Messages.User(id: playerId.value, name: name);
    }
    if (pagatUltimo.value) {
      currentPredictions.value!.pagatUltimo =
          Messages.User(id: playerId.value, name: name);
    }
    if (valat.value) {
      currentPredictions.value!.valat =
          Messages.User(id: playerId.value, name: name);
    }
    if (barvic.value) {
      currentPredictions.value!.barvniValat =
          Messages.User(id: playerId.value, name: name);
    }
    if (mondfang.value) {
      currentPredictions.value!.mondfang =
          Messages.User(id: playerId.value, name: name);
    }

    // kontre dal
    if (kontraKralj.value) {
      currentPredictions.value!.kraljUltimoKontraDal =
          Messages.User(id: playerId.value, name: name);
    }
    if (kontraPagat.value) {
      currentPredictions.value!.pagatUltimoKontraDal =
          Messages.User(id: playerId.value, name: name);
    }
    if (kontraIgra.value) {
      currentPredictions.value!.igraKontraDal =
          Messages.User(id: playerId.value, name: name);
    }
    if (kontraMondfang.value) {
      currentPredictions.value!.mondfangKontraDal =
          Messages.User(id: playerId.value, name: name);
    }

    currentPredictions.value!.changed = kontraMondfang.value ||
        kontraIgra.value ||
        kontraPagat.value ||
        kontraKralj.value ||
        trula.value ||
        kralji.value ||
        valat.value ||
        barvic.value ||
        pagatUltimo.value ||
        kraljUltimo.value ||
        mondfang.value;

    if (bots) {
      if (currentPredictions.value!.changed) sinceLastPrediction.value = 1;
      resetPredictions();
      currentPredictions.value!.changed = false;
      stockskisContext!.predictions =
          PredictionsCompLayer.messagesToStockSkis(currentPredictions.value!);
      myPredictions.value = null;
      await bPredict(bAfterPlayer());
      return;
    }

    final Uint8List message =
        Messages.Message(predictions: currentPredictions.value).writeToBuffer();
    socket.send(message);
    startPredicting.value = false;
    myPredictions.value = null;
  }

  Future<void> stashEnd(bool zalozitevPotrjena) async {
    if (stashedCards.length == stashAmount.value && zalozitevPotrjena) {
      if (bots) {
        for (int i = 0; i < stashedCards.length; i++) {
          if (!stashedCards[i].asset.contains("taroki")) {
            continue;
          }
          zalozeniTaroki.add(stashedCards[i]);
        }

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
        stash.value = false;
        turn.value = false;
        firstCard.value = null;
        stashedCards.value = [];
        await bPredict(stockskisContext!.playingPerson());
        return;
      }
      debugPrint("Pošiljam Stash");
      final Uint8List message = Messages.Message(
              stash: Messages.Stash(
                  send: Messages.Send(),
                  card: stashedCards.map((e) => Messages.Card(id: e.asset))))
          .writeToBuffer();
      socket.send(message);
      stash.value = false;
      turn.value = false;

      stashedCards.value = [];
    }
  }

  Future<void> sendCard(stockskis.LocalCard card,
      {bool zalozitevPotrjena = false}) async {
    debugPrint("sendCard() called, turn=$turn, stash=$stash");
    if (!turn.value) return;
    if (stash.value && !zalozitevPotrjena) {
      stashCard(card);
      return;
    }
    if (bots) {
      resetPremoves();
      premovedCard.value = null;

      List<stockskis.Card> skisCards = stockskisContext!.users["player"]!.cards;
      for (int i = 0; i < skisCards.length; i++) {
        if (skisCards[i].card.asset == card.asset) {
          if (stockskisContext!.stihi.last.isEmpty) {
            firstCard.value = skisCards[i].card;
          }
          stockskisContext!.stihi.last.add(skisCards[i]);
          stockskisContext!.users["player"]!.cards.removeAt(i);
          break;
        }
      }
      cards.remove(card);
      turn.value = false;

      bool early = await addToStih("player", "player", card.asset);

      if (early) return;

      if (stockskisContext!.stihi.last.length ==
          stockskisContext!.users.length) {
        await bCleanStih();
        return;
      }

      int next = bAfterPlayer();
      debugPrint("Next $next");
      await bPlay(next);

      return;
    }
    final Uint8List message = Messages.Message(
            card: Messages.Card(id: card.asset, send: Messages.Send()))
        .writeToBuffer();
    socket.send(message);
    resetPremoves();
    premovedCard.value = null;
  }

  Future<void> invitePlayer(String playerId) async {
    if (bots) return;
    final Uint8List message = Messages.Message(
      playerId: playerId,
      invitePlayer: Messages.InvitePlayer(),
    ).writeToBuffer();
    socket.send(message);
  }

  Future<void> manuallyStartGame() async {
    if (bots) return;
    final Uint8List message = Messages.Message(
      gameStart: Messages.GameStart(),
    ).writeToBuffer();
    socket.send(message);
  }

  Future<void> licitiranjeSend(stockskis.LocalGame game) async {
    if (!licitiram.value || !licitiranje.value) return;
    if (bots) {
      for (int i = 0; i < users.length; i++) {
        if (users[i].id == "player") {
          logger.i("nastavljam users[i].licitiral na ${game.id}");
          users[i].licitiral = game.id;
          stockskisContext!.gamemode = game.id;
          break;
        }
      }
      int next = bAfterPlayer();
      bLicitate(next);
      removeInvalidGames("player", game.id);
      licitiram.value = false;
      return;
    }
    final Uint8List message =
        Messages.Message(licitiranje: Messages.Licitiranje(type: game.id))
            .writeToBuffer();
    socket.send(message);
    licitiram.value = false;
  }

  Future<void> selectTalon(int t) async {
    if (!showTalon.value || talonSelected.value != -1) return;
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
      talonSelected.value = t;
      stash.value = true;
      turn.value = true;
      stashAmount.value = selectedCards.length;
      stashedCards.value = [];
      kingSelect.value = false;
      kingSelection.value = false;
      debugPrint("$stashAmount");
      validCards();
      return;
    }
    final Uint8List message = Messages.Message(
            talonSelection:
                Messages.TalonSelection(send: Messages.Send(), part: t))
        .writeToBuffer();
    socket.send(message);
  }

  Future<void> selectKing(String king) async {
    if (!kingSelect.value) {
      return;
    }

    kingSelect.value = false;
    if (bots) {
      selectedKing.value = king;
      stockskisContext!.selectSecretlyPlaying(king);
      await bStartTalon("player");
      return;
    }
    final Uint8List message = Messages.Message(
            kingSelection:
                Messages.KingSelection(send: Messages.Send(), card: king))
        .writeToBuffer();
    socket.send(message);
  }

  Future<bool> addToStih(
      String msgPlayerId, String playerId, String card) async {
    Sounds.card();

    debugPrint(
        "card=$card, selectedKing=$selectedKing, msgPlayerId=$msgPlayerId, playerId=$playerId");
    if (card == selectedKing.value) {
      if (bots) stockskisContext!.revealKing(msgPlayerId);
      userHasKing.value = msgPlayerId;
      debugPrint("Karta $selectedKing nastavljena na uporabnika $msgPlayerId.");
    }
    List<stockskis.SimpleUser> after = [];
    List<stockskis.SimpleUser> before = [];
    if (bots) myPosition.value = stockskisContext!.getPlayer();
    debugPrint("My position: $myPosition");
    for (int i = myPosition.value + 1; i < users.length; i++) {
      after.add(users[i]);
    }
    for (int i = 0; i < myPosition.value; i++) {
      before.add(users[i]);
    }
    List<stockskis.SimpleUser> allUsers = [
      ...after,
      ...before,
      users[myPosition.value]
    ];
    cardStih.add(card);
    //print(allUsers);
    if (msgPlayerId == "talon") {
      debugPrint("nastavljam karto na talon");
      stih.add(CardWidget(
        position: 100,
        widget: Image(image: AssetImage("assets/tarok$card.webp")),
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
        widget: Image(
          image: AssetImage("assets/tarok$card.webp"),
        ),
        angle: (Random().nextDouble() - 0.5) / ANGLE,
      ));
      await Future.delayed(const Duration(milliseconds: 20), () {
        stihBoolValues[position] = true;
      });
      break;
    }
    if (bots && stih.length == playingCount.value) {
      eval.value = stockskisContext!.evaluateGame();
      debugPrint("Trenutna evaluacija igre je $eval. Kralj je $userHasKing.");
      bool canGameEndEarly = stockskisContext!.canGameEndEarly();
      if (canGameEndEarly) {
        for (int i = 0; i < stockskisContext!.userPositions.length; i++) {
          stockskis.User up =
              stockskisContext!.users[stockskisContext!.userPositions[i]]!;
          for (int n = 0; n < userWidgets.length; n++) {
            if (userWidgets[n].id != up.user.id) {
              continue;
            }
            userWidgets[n].cards = [];
            userWidgets[n].cards.addAll(up.cards);
            break;
          }
        }
        debugPrint("končujem igro predčasno");
        await Future.delayed(Duration(milliseconds: BOT_DELAY), () async {
          await bResults();
        });
        return true;
      }
    }
    return false;
  }

  void cancelCurrentTimer() {
    if (currentTimer == null) return;
    currentTimer!.cancel();
    currentTimer = null;
  }

  void startTimer(int i) {
    currentTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (userWidgets[i].timer <= 0) return;
      //print(i);
      userWidgets[i].timer -= 0.05;
      userWidgets.refresh();
    });
  }

  void countdownUserTimer(String userId) {
    if (tournamentGame.value) return;
    for (int i = 0; i < userWidgets.length; i++) {
      if (userWidgets[i].id != userId) continue;
      userWidgets[i].timerOn = true;
      break;
    }
  }

  stockskis.SimpleUser getPlayer() {
    for (int i = 0; i < users.length; i++) {
      if (users[i].id != playerId.value) continue;
      return users[i];
    }
    throw Exception("Could not find user");
  }

  void listen() {
    socket.messages.listen(
      (data) async {
        final msg = Messages.Message.fromBuffer(data);
        if (msg.hasLicitiranje() ||
            msg.hasKingSelection() ||
            msg.hasTalonSelection() ||
            msg.hasPredictions()) {
          Sounds.click();
        }

        debugPrint(msg.toString());
        if (msg.hasLoginRequest()) {
          if (msg.loginResponse.hasFail()) {
            socket.close();
            return;
          }
          await login();
          return;
        } else if (msg.hasLoginResponse()) {
          playerId.value = msg.playerId;
          name = msg.username;
          bool found = false;
          for (int i = 0; i < users.length; i++) {
            if (users[i].id == playerId.value) {
              found = true;
              break;
            }
          }
          if (!found) {
            users.add(stockskis.SimpleUser(id: playerId.value, name: name));
          }
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
                  users[n].ratingDelta = thisUser.ratingDelta;
                  ok = true;
                  break;
                }
                if (ok) break;
              }
            }
            // zaključimo igro
            gameDone.value = true;
            results.value = null;
            started.value = false;
            socket.close();
          } else if (game.hasRequest()) {
            final playerId = msg.playerId;
            for (int n = 0; n < users.length; n++) {
              if (playerId != users[n].id) continue;
              users[n].endGame = game.request.count;
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

            if (userId != playerId.value) {
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
              turn.value = false;
            }
          } else if (card.hasSend()) {
            // this packet takes care of a deck (štih)
            // once a card is added to a štih, this message is sent
            started.value = true;
            showTalon.value = false;
            stash.value = false;
            predictions.value = false;
            startPredicting.value = false;
            final userId = msg.playerId;

            for (int i = 0; i < userWidgets.length; i++) {
              if (userWidgets[i].id != userId) continue;
              for (int n = 0; n < userWidgets[i].cards.length; n++) {
                stockskis.Card c = userWidgets[i].cards[n];
                if (card.id != c.card.asset) continue;
                userWidgets[i].cards.removeAt(n);
                break;
              }

              if (userId != playerId.value) {
                break;
              }

              turn.value = false;

              for (int n = 0; n < cards.length; n++) {
                stockskis.LocalCard c = cards[n];
                if (card.id != c.asset) continue;
                cards.removeAt(n);
                break;
              }

              break;
            }

            if (firstCard.value == null) {
              for (int i = 0; i < stockskis.CARDS.length; i++) {
                if (stockskis.CARDS[i].asset == card.id) {
                  firstCard.value = stockskis.CARDS[i];
                  break;
                }
              }
            }
            print("send received");
            addToStih(msg.playerId, playerId.value, card.id);
            validCards();
            print(stih.length);
            print(stih);
          } else if (card.hasRequest()) {
            // this packet is sent when it's user's time to send a card
            final userId = msg.playerId;
            countdownUserTimer(userId);
            if (userId == playerId.value) {
              turn.value = true;
              if (premovedCard.value != null) {
                resetPremoves();
                sendCard(premovedCard.value!);
              } else {
                licitiram.value = false;
                licitiranje.value = false;
                stash.value = false;
                validCards();
              }
            }
            /*if (cards.length == 1) {
              Future.delayed(const Duration(milliseconds: 500), () {
                sendCard(cards[0]);
              });
            }*/
            // preventivno, če se uporabnik slučajno disconnecta-reconnecta
            started.value = true;
          } else if (card.hasRemove()) {
            for (int i = 0; i < cards.length; i++) {
              if (card.id == cards[i].asset) {
                cards.removeAt(i);
                break;
              }
            }
            turn.value = false;
            stash.value = false;
          }
        } else if (msg.hasGameStart() || msg.hasUserList()) {
          if (msg.hasGameStart()) {
            licitiranje.value = true;
            licitiram.value = false;
            cards.value = [];
            if (!lp.value && AVTOLP) {
              sendMessageString("lp");
              lp.value = true;
            }

            for (int i = 0; i < userWidgets.length; i++) {
              userWidgets[i].cards = [];
            }
          }

          resetPremoves();
          premovedCard.value = null;
          cardStih.value = [];
          userHasKing.value = "";
          selectedKing.value = "";
          firstCard.value = null;
          isPlaying.value = false;
          results.value = null;
          showTalon.value = false;
          stash.value = false;
          predictions.value = false;
          kingSelect.value = false;
          kingSelection.value = false;
          zaruf.value = false;
          requestedGameEnd.value = false;
          talon.value = [];
          suggestions.value = [];

          currentPredictions.value = Messages.Predictions();
          copyGames();

          for (int i = 0; i < users.length; i++) {
            users[i].licitiral = -2;
            users[i].endGame = -1;
          }
          for (int i = 0; i < stockskis.CARDS.length; i++) {
            stockskis.CARDS[i].showZoom = false;
          }
          for (int i = 0; i < cards.length; i++) {
            cards[i].showZoom = false;
          }

          turn.value = false;
          started.value = true;

          stih.value = [];
          stihBoolValues.value = {};
          stashedCards.value = [];
          zalozeniTaroki.value = [];

          // ignore: prefer_typing_uninitialized_variables
          final gameStart;
          if (msg.hasGameStart()) {
            gameStart = msg.gameStart;
          } else {
            gameStart = msg.userList;
          }

          List<stockskis.SimpleUser> usersBackup = [...users];
          users.value = [];

          List<Messages.User> newUsers = gameStart.user;
          for (int i = 0; i < newUsers.length; i++) {
            final newUser = newUsers[i];
            if (newUser.id == playerId.value) {
              myPosition.value = newUser.position;
            }
            for (int n = 0; n < usersBackup.length; n++) {
              if (usersBackup[n].id != newUser.id) continue;
              users.add(
                stockskis.SimpleUser(id: newUser.id, name: newUser.name)
                  ..points = usersBackup[n].points
                  ..total = usersBackup[n].total
                  ..radlci = usersBackup[n].radlci
                  ..connected = usersBackup[n].connected
                  ..endGame = usersBackup[n].endGame,
              );
              break;
            }
          }

          if (users.isEmpty) return;

          debugPrint("urejam vrstni red v `users` $users");

          // uredimo vrstni red naših igralcev
          //users = [];
          //for (int i = 0; i < userPosition.length; i++) {
          //  users.add(userPosition[i]);
          //}

          debugPrint("vrstni red v `users` je urejen");

          // magija, da dobimo pravilno lokalno zaporedje
          int i = myPosition.value + 1;
          if (i >= users.length) i = 0;
          int k = 0;
          int ffallback = 0;
          userWidgets.value = [];
          print(myPosition);
          print(k);
          print(i);
          while (i < users.length) {
            if (ffallback > users.length * 2) {
              break;
            }
            stockskis.SimpleUser user = users[i];
            userWidgets.add(user);
            if (i == myPosition.value) break;
            i++;
            k++;
            ffallback++;
            if (i >= users.length) i = 0;
          }

          debugPrint("anotacije so bile dodane");

          users.refresh();
          userWidgets.refresh();
        } else if (msg.hasGameStartCountdown()) {
          countdown.value = msg.gameStartCountdown.countdown;
        } else if (msg.hasLicitiranje()) {
          licitiranje.value = true;
          licitiram.value = false;
          final player = msg.playerId;
          final l = msg.licitiranje.type;
          bool obvezen = users.last.id == playerId.value;
          removeInvalidGames(
            player,
            l,
            imaPrednost: obvezen,
          );
          inspect(users);
        } else if (msg.hasLicitiranjeStart()) {
          final userId = msg.playerId;
          countdownUserTimer(userId);
          if (userId == playerId.value) {
            // this packet is sent when it's user's time to licitate
            bool obvezen = users.last.id == playerId.value;
            removeInvalidGames(
              userId,
              0,
              shraniLicitacijo: false,
              imaPrednost: obvezen,
            );
            licitiram.value = true;

            var user = getPlayer();

            var ss = stockskis.StockSkis(
              predictions: PredictionsCompLayer.messagesToStockSkis(
                  currentPredictions.value!),
              users: {
                userId: stockskis.User(
                  user: user,
                  cards: cards
                      .map((element) =>
                          stockskis.Card(card: element, user: userId))
                      .toList(),
                  playing: false,
                  secretlyPlaying: false,
                  botType: "player",
                  licitiral: false,
                ),
              },
              stihiCount: 48 ~/ users.length,
            );
            suggestions.value = ss.suggestModes(
              userId,
              canLicitateThree: obvezen,
            );
            debugPrint(jsonEncode(suggestions));
          }
        } else if (msg.hasClearDesk()) {
          stih.value = [];
          cardStih.value = [];
          stihBoolValues.value = {};
          firstCard.value = null;
          validCards();
        } else if (msg.hasResults()) {
          final r = msg.results;

          if (!msg.silent) {
            results.value = r;
          }

          if (msg.silent || !replay) {
            results.value = r;
            bool radelc = false;
            for (int i = 0; i < results.value!.user.length; i++) {
              if (results.value!.user[i].radelc) {
                radelc = true;
                break;
              }
            }
            for (int n = 0; n < users.length; n++) {
              debugPrint("Dodajam točke igralcu ${users[n].id}");
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
            users.refresh();
          }

          if (msg.silent) {
            results.value = null;
          }
        } else if (msg.hasTalonSelection()) {
          final talonSelection = msg.talonSelection;
          kingSelect.value = false;
          kingSelection.value = false;
          if (talonSelection.hasRequest()) {
            final userId = msg.playerId;
            countdownUserTimer(userId);
            if (userId == playerId.value) {
              isPlaying.value = true;
            }
          } else if (talonSelection.hasSend()) {
            talonSelected.value = talonSelection.part;
          }
        } else if (msg.hasTalonReveal()) {
          final talonReveal = msg.talonReveal;
          licitiranje.value = false;
          licitiram.value = false;
          talon.value = [];
          talonSelected.value = -1;
          showTalon.value = true;
          kingSelect.value = false;
          kingSelection.value = false;
          for (int i = 0; i < talonReveal.stih.length; i++) {
            final stih = talonReveal.stih[i];
            List<stockskis.LocalCard> thisStih = [];
            for (int n = 0; n < stih.card.length; n++) {
              final card = stih.card[n];
              if (card.id == selectedKing.value) {
                zaruf.value = true;
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
          if (userId == playerId.value) {
            final s = msg.stash;
            kingSelect.value = false;
            kingSelection.value = false;
            if (s.hasRequest()) {
              stash.value = true;
              turn.value = true;
              stashAmount.value = s.length;
              validCards();
            }
          }
        } else if (msg.hasPredictions()) {
          showTalon.value = false;
          stash.value = false;
          currentPredictions.value = msg.predictions;
          if (!msg.silent) {
            predictions.value = true;
          }
          kingSelect.value = false;
          kingSelection.value = false;
          startPredicting.value = false;
          myPredictions.value = null;

          for (int i = 0; i < users.length; i++) {
            if (!(users[i].id == currentPredictions.value!.kraljUltimo.id ||
                users[i].id == currentPredictions.value!.pagatUltimo.id)) {
              continue;
            }
            users[i].cards = [];
            if (users[i].id == currentPredictions.value!.kraljUltimo.id) {
              users[i].cards.add(stockskis.Card(
                    card: stockskis.LocalCard(
                      asset: selectedKing.value,
                      worth: 5,
                      worthOver: 8,
                      alt: "",
                    ),
                    user: users[i].id,
                  ));
            }
            if (users[i].id == currentPredictions.value!.pagatUltimo.id) {
              users[i].cards.add(stockskis.Card(
                    card: stockskis.LocalCard(
                      asset: "/taroki/pagat",
                      worth: 5,
                      worthOver: 11,
                      alt: "Pagat",
                    ),
                    user: users[i].id,
                  ));
            }
          }

          // reset
          resetPredictions();
        } else if (msg.hasPredictionsResend()) {
          debugPrint("Received resent predictions");
          currentPredictions.value = msg.predictionsResend;
        } else if (msg.hasStartPredictions()) {
          final userId = msg.playerId;
          countdownUserTimer(userId);
          if (userId == playerId.value) {
            showTalon.value = false;
            stash.value = false;
            myPredictions.value = msg.startPredictions;
            startPredicting.value = true;
          }
        } else if (msg.hasKingSelection()) {
          final selection = msg.kingSelection;
          if (selection.hasNotification()) {
            kingSelection.value = true;
          } else if (selection.hasRequest()) {
            final userId = msg.playerId;
            countdownUserTimer(userId);
            if (userId == playerId.value) {
              kingSelect.value = true;
            }
          } else if (selection.hasSend()) {
            selectedKing.value = selection.card;
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
          final bool start = time.start;
          if (tournamentGame.value && userId != playerId.value) return;
          cancelCurrentTimer();
          for (int i = 0; i < userWidgets.length; i++) {
            if (userWidgets[i].id != userId) continue;
            userWidgets[i].timer = time.currentTime;
            userWidgets[i].timerOn = false;
            if (start) {
              startTimer(i);
            }
            break;
          }
          userWidgets.refresh();
        } else if (msg.hasChatMessage()) {
          final chatMessage = msg.chatMessage;
          if (msg.playerId != playerId.value) unreadMessages.value++;
          chat.insert(0, chatMessage);
        } else if (msg.hasStashedTarock()) {
          final stashedTarock = msg.stashedTarock;
          for (int i = 0; i < stockskis.CARDS.length; i++) {
            if (stashedTarock.card.id != stockskis.CARDS[i].asset) {
              continue;
            }
            zalozeniTaroki.add(stockskis.CARDS[i]);
            break;
          }
        } else if (msg.hasClearHand()) {
          cards.value = [];
        } else if (msg.hasReplayLink()) {
          gameLinkController.value.text = msg.replayLink.replay;
        } else if (msg.hasGameInfo()) {
          gamesRequired.value = msg.gameInfo.gamesRequired;
          gamesPlayed.value = msg.gameInfo.gamesPlayed;
          canExtendGame.value = msg.gameInfo.canExtendGame;
        } else if (msg.hasPrepareGameMode()) {
          if (msg.prepareGameMode.hasNormal()) {
            tournamentGame.value = false;
          } else if (msg.prepareGameMode.hasTournament()) {
            tournamentGame.value = true;
          }
        }
      },
      onDone: () {
        debugPrint('ws channel closed');
      },
      onError: (error) => debugPrint(error),
    );
  }

  /*
  IGRE Z BOTI
  */
  Future<void> bStartGame() async {
    logger.d("bStartGame() called");

    selectedKing.value = "";
    premovedCard.value = null;
    licitiranje.value = true;
    licitiram.value = false;
    userHasKing.value = "";
    firstCard.value = null;
    results.value = null;
    talonSelected.value = -1;
    zaruf.value = false;
    cardStih.value = [];
    gamesPlayed.value++;
    copyGames();

    for (int i = 0; i < users.length; i++) {
      users[i].licitiral = -2;
      users[i].cards = [];
    }
    for (int i = 0; i < stockskis.CARDS.length; i++) {
      stockskis.CARDS[i].showZoom = false;
    }
    for (int i = 0; i < cards.length; i++) {
      cards[i].showZoom = false;
    }

    turn.value = false;
    started.value = true;

    stih.value = [];
    talon.value = [];
    stihBoolValues.value = {};
    zalozeniTaroki.value = [];

    if (users.isEmpty) {
      logger.d("users.isEmpty");

      Map<String, stockskis.User> stockskisUsers = {};
      List<String> botNames = BOT_NAMES.toList();
      String botsStr = await storage.read(key: "bots") ?? "[]";
      List bots = jsonDecode(botsStr);
      int l = bots.length;
      for (int i = 1; i < playingCount.value; i++) {
        String botType = "normal";
        String botName = botNames[Random().nextInt(botNames.length)];
        if (l >= playingCount.value - 1) {
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
        user: stockskis.SimpleUser(id: "player", name: "player".tr),
        playing: false,
        secretlyPlaying: false,
        botType: "NAB", // not a bot
        licitiral: false,
      );
      stockskis.SimpleUser user =
          stockskis.SimpleUser(id: "player", name: "player".tr);
      users.add(user);
      stockskisContext = stockskis.StockSkis(
        users: stockskisUsers,
        stihiCount: ((54 - 6) / playingCount.value).floor(),
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

    currentPredictions.value = Messages.Predictions();
    stockskisContext!.doRandomShuffle();
    List<stockskis.Card> myCards = stockskisContext!.users["player"]!.cards;
    cards.value = myCards.map((card) => card.card).toList();
    users.value = stockskisContext!.buildPositionsSimple();
    stockskisContext!.selectedKing = "";

    if (userWidgets.isEmpty) {
      // sebe sploh ne smem dat med userWidgetse, razen kot zadnjega
      userWidgets.value = stockskisContext!.buildPositionsSimple();
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
    sinceLastPrediction.value = 0;
    //users = [];
    //for (int i = 0; i < userPosition.length; i++) {
    //  users.add(userPosition[i]);
    //}
    sortCards();
    turn.value = false;
    started.value = true;

    if (!isPlayerMandatory("player")) {
      games.removeAt(1);
    }

    bLicitate(0);
  }

  Future<void> bLicitate(int startAt) async {
    licitiranje.value = true;

    int onward = 0;
    int notVoted = 0;
    for (int i = 0; i < users.length; i++) {
      if (users[i].licitiral == -1) onward++;
      if (users[i].licitiral == -2) notVoted++;
    }
    debugPrint("onward: $onward, notVoted: $notVoted");
    if (onward >= users.length - 1 && notVoted == 0) {
      users.refresh();

      await Future.delayed(
          Duration(milliseconds: (BOT_DELAY / 4).round()), () {});

      Sounds.click();

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
          } else if (stockskisContext!.userPositions.length == 4) {
            // če igramo v tri, nimamo kraljev in rufanja
            stockskisContext!.kingFallen = true;
          }
          debugPrint("set the game to ${users[i].id} using method 1");
          currentPredictions.value!.igra = Messages.User(
            id: users[i].id,
            name: users[i].name,
          );
          currentPredictions.value!.gamemode = m;
          stockskisContext!.predictions =
              PredictionsCompLayer.messagesToStockSkis(
                  currentPredictions.value!);
          licitiranje.value = false;
          await bStartKingSelection(users[i].id);
          return;
        }
      }
      if (m == -1) {
        debugPrint("začenjam rundo klopa");
        // začnemo klopa pri obveznem
        stockskisContext!.users[users.last.id]!.licitiral = true;
        stockskisContext!.users[users.last.id]!.playing = true;
        stockskisContext!.users[users.last.id]!.secretlyPlaying = true;
        currentPredictions.value!.igra = Messages.User(
          id: users.last.id,
          name: users.last.name,
        );
        currentPredictions.value!.gamemode = -1;
        stockskisContext!.predictions =
            PredictionsCompLayer.messagesToStockSkis(currentPredictions.value!);
        bPredict(0);
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
        licitiram.value = true;
        if (!OMOGOCI_STOCKSKIS_PREDLOGE) return;
        suggestions.value = stockskisContext!.suggestModes(
          user.id,
          canLicitateThree: isMandatory,
        );
        return;
      }

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
          users.refresh();
          await Future.delayed(Duration(milliseconds: BOT_DELAY), () async {
            debugPrint("set the game to ${users[n].id}");
            currentPredictions.value!.igra = Messages.User(
              id: users[n].id,
              name: users[n].name,
            );
            stockskisContext!.predictions =
                PredictionsCompLayer.messagesToStockSkis(
                    currentPredictions.value!);
            await bStartKingSelection(users[n].id);
          });
          return;
        }

        await Future.delayed(
            Duration(milliseconds: (BOT_DELAY / 4).round()), () async {});

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

        users.refresh();
      }
    }

    users.refresh();

    bLicitate(0);
  }

  void bSetPointsResults() {
    bool radelc = false;
    for (int i = 0; i < results.value!.user.length; i++) {
      if (results.value!.user[i].radelc) {
        radelc = true;
        break;
      }
    }
    for (int i = 0; i < users.length; i++) {
      users[i].points.add(stockskis.ResultsPoints(
            points: 0,
            playing: false,
            results: ResultsCompLayer.messagesToStockSkis(results.value!),
            radelc: radelc,
          ));
    }
    for (int i = 0; i < users.length; i++) {
      String id = users[i].id;
      for (int n = 0; n < results.value!.user.length; n++) {
        Messages.ResultsUser result = results.value!.user[n];
        bool found = false;
        for (int k = 0; k < result.user.length; k++) {
          Messages.User user = result.user[k];
          if (user.id != id) continue;
          found = true;
          break;
        }
        if (!found) continue;
        String playingUser = currentPredictions.value!.igra.id;
        if (playingUser == id) {
          users[i].points.last.playing = true;
        }
        users[i].points.last.points += result.points;
        users[i].total += result.points;
      }
    }
  }

  Future<void> bResults() async {
    debugPrint("Gamemode stockškis konteksta je ${stockskisContext!.gamemode}");
    results.value =
        ResultsCompLayer.stockSkisToMessages(stockskisContext!.calculateGame());
    bSetPointsResults();
    if (!stockskis.AUTOSTART_GAME) return;
    await Future.delayed(Duration(seconds: NEXT_ROUND_DELAY), () {
      bStartGame();
    });
  }

  Future<void> bCleanStih() async {
    if (zaruf.value) {
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
        if (karta.card.asset == selectedKing.value &&
            analysis.cardPicks.card.asset == selectedKing.value) {
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

    bKlopTalon();

    await Future.delayed(Duration(milliseconds: CARD_CLEANUP_DELAY), () {
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
      stih.value = [];
      cardStih.value = [];
      stihBoolValues.value = {};
      firstCard.value = null;
      stockskisContext!.stihi.add([]);
      validCards();
      bPlay(k);
    });
  }

  Future<void> bPlay(int startAt) async {
    licitiram.value = false;
    licitiranje.value = false;
    showTalon.value = false;
    predictions.value = false;
    myPredictions.value = null;
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
        bResults();
        return;
      }
      if (pos.user.id == "player") {
        if (pos.cards.length == 1) {
          logger.d(
              "stockskisContext!.users['player'].cards.length is 1. Autodropping card.");
          turn.value = true;
          await sendCard(pos.cards[0].card);
          return;
        }
        turn.value = true;
        validCards();
        if (premovedCard.value != null) {
          if (!premovedCard.value!.valid) {
            resetPremoves();
            return;
          }
          debugPrint("Dropping premoved card ${premovedCard.value!.asset}");
          await sendCard(premovedCard.value!);
          return;
        }
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
      if (stockskisContext!.stihi.last.isEmpty) {
        firstCard.value = bestMove.card.card;
      }
      stockskisContext!.stihi.last.add(bestMove.card);
      stockskisContext!.users[pos.user.id]!.cards.remove(bestMove.card);
      await Future.delayed(Duration(milliseconds: BOT_DELAY), () async {});
      debugPrint("Dodajam v štih");
      Sounds.card();
      if (await addToStih(pos.user.id, "player", bestMove.card.card.asset)) {
        return;
      }
      i++;
      debugPrint(
          "StockŠkis štih: ${stockskisContext!.stihi.last.length}, Uporabniki: ${stockskisContext!.users.length}, Zaruf: $zaruf");
      if (stockskisContext!.stihi.last.length ==
          stockskisContext!.users.length) {
        await bCleanStih();
        return;
      }
    }
  }

  Future<void> bPredict(int start) async {
    kingSelection.value = false;
    kingSelect.value = false;
    showTalon.value = false;
    licitiram.value = false;
    licitiranje.value = false;
    predictions.value = true;
    startPredicting.value = false;

    debugPrint("bPredict");
    int k = start;

    while (true) {
      Sounds.click();

      if (currentPredictions.value!.kraljUltimo.id != "") {
        stockskisContext!.revealKing(currentPredictions.value!.kraljUltimo.id);
      }

      // napovej barvića in valata po izbiri v napovedih
      if (currentPredictions.value!.valat.id != "") {
        currentPredictions.value!.gamemode = 10;
        stockskisContext!.gamemode = 10;
      } else if (currentPredictions.value!.barvniValat.id != "") {
        currentPredictions.value!.gamemode = 9;
        stockskisContext!.gamemode = 9;
      }

      if (sinceLastPrediction >= playingCount.value) {
        logger.i("Gamemode: ${stockskisContext!.gamemode}");
        if (stockskisContext!.gamemode >= 6) {
          bPlay(stockskisContext!.playingPerson());
          return;
        }
        bPlay(users.length - 1);
        return;
      }
      stockskis.User u =
          stockskisContext!.users[stockskisContext!.userPositions[k]]!;
      debugPrint(
          "User with ID ${u.user.id}. k=$k, sinceLastPrediction=$sinceLastPrediction");
      if (u.user.id == "player") {
        myPredictions.value = StartPredictionsCompLayer.stockSkisToMessages(
          stockskisContext!.getStartPredictions("player"),
        );
        startPredicting.value = true;
        sinceLastPrediction++;
        return;
      }
      bool changed = stockskisContext!.predict(u.user.id);
      if (changed) {
        sinceLastPrediction.value = 0;
      }
      currentPredictions.value = PredictionsCompLayer.stockSkisToMessages(
        stockskisContext!.predictions,
      );
      k++;
      if (k >= stockskisContext!.userPositions.length) k = 0;
      userHasKing.value = currentPredictions.value!.kraljUltimo.id;
      await Future.delayed(Duration(milliseconds: BOT_DELAY), () {});
      sinceLastPrediction++;
    }
  }

  Future<void> bStartTalon(String playerId) async {
    debugPrint("Talon");
    talon.value = [];
    int game = bGetPlayedGame();
    if (game == -1 || game >= 6) {
      bPredict(stockskisContext!.playingPerson());
      return;
    }
    debugPrint("Talon1");
    showTalon.value = true;

    var (stockskisTalon, talon1, zaruf1) =
        stockskisContext!.getStockskisTalon();
    talon.value = talon1;
    zaruf.value = zaruf1;

    if (playerId == "player") {
      isPlaying.value = true;
      return;
    }

    talonSelected.value =
        stockskisContext!.selectDeck(playerId, stockskisTalon);
    List<stockskis.Card> selectedCards = stockskisTalon[talonSelected.value];
    debugPrint(
      "Izbrane karte: ${selectedCards.map((e) => e.card.asset).join(" ")}",
    );
    for (int i = 0; i < selectedCards.length; i++) {
      stockskis.Card s = selectedCards[i];
      stockskisContext!.talon.remove(s);
      s.user = playerId;
      stockskisContext!.users[playerId]!.cards.add(s);
    }
    debugPrint(
      "Talon: ${stockskisContext!.talon.map((e) => e.card.asset).join(" ")}",
    );
    String king = selectedKing.value == "" ? "" : selectedKing.split("/")[1];

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
      if (!stash[i].card.asset.contains("taroki")) {
        continue;
      }
      zalozeniTaroki.add(stash[i].card);
    }
    stockskisContext!.stihi.add([]);
    stockskisContext!.sortAllCards();
    firstCard.value = null;
    debugPrint(
      "Talon: ${stockskisContext!.talon.map((e) => e.card.asset).join(" ")}",
    );
    await Future.delayed(Duration(milliseconds: (BOT_DELAY / 2).round()), () {
      bPredict(stockskisContext!.playingPerson());
    });
  }

  Future<void> bStartKingSelection(String playerId) async {
    int game = bGetPlayedGame();
    if (game == -1 || game >= 3 || users.length == 3) {
      bStartTalon(playerId);
      return;
    }
    kingSelection.value = true;
    if (playerId == "player") {
      kingSelect.value = true;
      return;
    }
    kingSelect.value = false;
    Sounds.click();
    selectedKing.value = stockskisContext!.selectKing(playerId);
    await Future.delayed(const Duration(seconds: 2), () {
      kingSelection.value = false;
      stockskisContext!.selectSecretlyPlaying(selectedKing.value);
      bStartTalon(playerId);
    });
  }

  int bAfterPlayer() {
    for (int i = 0; i < stockskisContext!.userPositions.length; i++) {
      if (stockskisContext!.userPositions[i] == "player") {
        if (i == stockskisContext!.userPositions.length - 1) {
          return 0;
        } else {
          return i + 1;
        }
      }
    }
    return 0;
  }

  int bGetPlayedGame() {
    int m = -1;
    for (int i = 0; i < users.length; i++) {
      if (m < users[i].licitiral) {
        m = users[i].licitiral;
        stockskisContext!.users[users[i].id]!.playing = true;
        stockskisContext!.users[users[i].id]!.secretlyPlaying = true;
        stockskisContext!.users[users[i].id]!.licitiral = true;
        stockskisContext!.gamemode = m;
        currentPredictions.value!.gamemode = m;
        return m;
      }
    }
    return m;
  }

  /*
  UI HELPER FUNCTIONS
  */
  Future<void> dropOnlyValidCard() async {
    resetPremoves();
    premovedCard.value = null;

    int validCards = 0;
    for (int i = 0; i < cards.length; i++) {
      if (cards[i].valid) validCards++;
      if (validCards > 1) return;
    }
    if (validCards == 0) return;
    if (!turn.value) return;
    for (int i = 0; i < cards.length; i++) {
      if (!cards[i].valid) continue;
      await sendCard(cards[i]);
      break;
    }
  }

  List<Widget> stihi3(
    double cardK,
    double m,
    double center,
    double leftFromTop,
    double cardToWidth,
    double fullWidth,
  ) {
    BorderRadius radius = BorderRadius.circular(10 * (fullWidth / 1000));
    double cardHeight = m * cardK;
    double cardWidth = cardHeight * 0.57;

    List<Widget> widgets = [];
    for (int i = 0; i < stih.length; i++) {
      CardWidget e = stih[i];
      if (e.position == 0) {
        widgets.add(
          AnimatedPositioned(
            duration: const Duration(milliseconds: ANIMATION_TIME),
            top: stihBoolValues[0] != true
                ? leftFromTop - (cardHeight * 0.5) - 100
                : leftFromTop - (cardHeight * 0.5),
            left: stihBoolValues[0] != true
                ? cardToWidth - cardHeight / 3 - 100
                : cardToWidth - cardHeight / 3,
            height: cardHeight,
            child: AnimatedRotation(
              duration: const Duration(milliseconds: ANIMATION_TIME),
              turns: stihBoolValues[0] != true ? 0.35 : 0.35 + e.angle,
              child: ClipRRect(
                borderRadius: radius,
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      height: cardHeight,
                      width: cardWidth,
                    ),
                    SizedBox(
                      height: cardHeight,
                      width: cardWidth,
                      child: Center(child: e.widget),
                    ),
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
            duration: const Duration(milliseconds: ANIMATION_TIME),
            top: stihBoolValues[1] != true
                ? leftFromTop - (cardHeight * 0.5) - 100
                : leftFromTop - (cardHeight * 0.5),
            right: stihBoolValues[1] != true
                ? fullWidth * (1 / 6 + 0.25)
                : fullWidth * (1 / 6 + 0.25) + 100,
            height: cardHeight,
            child: AnimatedRotation(
              duration: const Duration(milliseconds: ANIMATION_TIME),
              turns: stihBoolValues[1] != true ? -0.35 : -0.35 + e.angle,
              child: ClipRRect(
                borderRadius: radius,
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      height: cardHeight,
                      width: cardWidth,
                    ),
                    SizedBox(
                      height: cardHeight,
                      width: cardWidth,
                      child: Center(child: e.widget),
                    ),
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
          Positioned(
            top: leftFromTop,
            left: cardToWidth,
            height: cardHeight,
            child: Transform.rotate(
              angle: pi / 3,
              child: ClipRRect(
                borderRadius: radius,
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      height: cardHeight,
                      width: cardWidth,
                    ),
                    SizedBox(
                      height: cardHeight,
                      width: cardWidth,
                      child: Center(child: e.widget),
                    ),
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
          duration: const Duration(milliseconds: ANIMATION_TIME),
          top: stihBoolValues[3] != true
              ? leftFromTop + (cardHeight * 0.5) + 100
              : leftFromTop + (cardHeight * 0.5) * 0.55,
          left: cardToWidth,
          height: cardHeight,
          child: AnimatedRotation(
            duration: const Duration(milliseconds: ANIMATION_TIME),
            turns: stihBoolValues[3] != true ? 0 : e.angle,
            child: ClipRRect(
              borderRadius: radius,
              child: Stack(
                children: [
                  Container(
                    color: Colors.white,
                    height: cardHeight,
                    width: cardWidth,
                  ),
                  SizedBox(
                    height: cardHeight,
                    width: cardWidth,
                    child: Center(child: e.widget),
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

  List<Widget> stihi4(
    double cardK,
    double m,
    double center,
    double leftFromTop,
    double cardToWidth,
    double fullWidth,
  ) {
    BorderRadius radius = BorderRadius.circular(10 * (fullWidth / 1000));
    double cardHeight = m * cardK;
    double cardWidth = cardHeight * 0.57;

    List<Widget> widgets = [];
    for (int i = 0; i < stih.length; i++) {
      CardWidget e = stih[i];
      if (e.position == 0) {
        widgets.add(
          AnimatedPositioned(
            duration: const Duration(milliseconds: ANIMATION_TIME),
            top: leftFromTop,
            left: stihBoolValues[0] != true ? 0 : center - cardHeight / 4,
            height: cardHeight,
            child: AnimatedRotation(
              duration: const Duration(milliseconds: ANIMATION_TIME),
              turns: stihBoolValues[0] != true ? 0.2 : 0.25 + e.angle,
              child: ClipRRect(
                borderRadius: radius,
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      height: cardHeight,
                      width: cardWidth,
                    ),
                    SizedBox(
                      height: cardHeight,
                      width: cardWidth,
                      child: Center(child: e.widget),
                    ),
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
            duration: const Duration(milliseconds: ANIMATION_TIME),
            top: stihBoolValues[1] != true
                ? leftFromTop - (cardHeight * 0.5) - 100
                : leftFromTop - (cardHeight * 0.5),
            left: center + cardHeight / 4,
            height: cardHeight,
            child: AnimatedRotation(
              duration: const Duration(milliseconds: ANIMATION_TIME),
              turns: stihBoolValues[1] != true ? 0 : e.angle,
              child: ClipRRect(
                borderRadius: radius,
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      height: cardHeight,
                      width: cardWidth,
                    ),
                    SizedBox(
                      height: cardHeight,
                      width: cardWidth,
                      child: Center(child: e.widget),
                    ),
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
            duration: const Duration(milliseconds: ANIMATION_TIME),
            top: leftFromTop,
            left: stihBoolValues[2] != true
                ? center + cardHeight + 100
                : center + cardHeight - cardHeight / 4,
            height: cardHeight,
            child: AnimatedRotation(
              duration: const Duration(milliseconds: ANIMATION_TIME),
              turns: stihBoolValues[2] != true ? 0.25 : 0.25 + e.angle,
              child: ClipRRect(
                borderRadius: radius,
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      height: cardHeight,
                      width: cardWidth,
                    ),
                    SizedBox(
                      height: cardHeight,
                      width: cardWidth,
                      child: Center(child: e.widget),
                    ),
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
          Positioned(
            top: leftFromTop,
            left: cardToWidth,
            height: cardHeight,
            child: Transform.rotate(
              angle: pi / 4,
              child: ClipRRect(
                borderRadius: radius,
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      height: cardHeight,
                      width: cardWidth,
                    ),
                    SizedBox(
                      height: cardHeight,
                      width: cardWidth,
                      child: Center(child: e.widget),
                    ),
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
          duration: const Duration(milliseconds: ANIMATION_TIME),
          top: stihBoolValues[3] != true
              ? leftFromTop + (cardHeight * 0.5) + 100
              : leftFromTop + (cardHeight * 0.5),
          left: center + cardHeight / 2 - cardHeight / 4,
          height: cardHeight,
          child: AnimatedRotation(
            duration: const Duration(milliseconds: ANIMATION_TIME),
            turns: stihBoolValues[3] != true ? 0 : e.angle,
            child: ClipRRect(
              borderRadius: radius,
              child: Stack(
                children: [
                  Container(
                    color: Colors.white,
                    height: cardHeight,
                    width: cardWidth,
                  ),
                  SizedBox(
                    height: cardHeight,
                    width: cardWidth,
                    child: Center(child: e.widget),
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

  bool kartePogoj(int i) {
    return (stockskis.ODPRTE_IGRE && bots) ||
        userWidgets[i].cards.isNotEmpty ||
        (bots &&
            !predictions.value &&
            currentPredictions.value!.gamemode == 8 &&
            userWidgets[i].id == currentPredictions.value!.igra.id);
  }

  List<stockskis.Card> pridobiKarte(int i) {
    return userWidgets[i].cards.isNotEmpty
        ? userWidgets[i].cards
        : stockskisContext!.users[userWidgets[i].id]!.cards;
  }

  List<Widget> generateNames3(
    double leftFromTop,
    double m,
    double cardK,
    double userSquareSize,
    double fullWidth,
    double fullHeight,
  ) {
    List<Widget> widgets = [];

    if (userWidgets.isEmpty) {
      return widgets;
    }

    if (currentPredictions.value == null) {
      return widgets;
    }

    final miniCardHeight = fullHeight / 7;
    final miniCardWidth = miniCardHeight * 0.57;

    widgets.add(
      Positioned(
        top: 10,
        left: fullWidth * 0.2 - userSquareSize / 2,
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

    if (currentPredictions.value!.igra.id == userWidgets[0].id) {
      widgets.add(
        Positioned(
          top: 10,
          left: fullWidth * 0.2 + userSquareSize / 2,
          child: Container(
            height: userSquareSize / 2,
            width: userSquareSize / 2,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: Colors.black,
              ),
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                GAME_DESC[currentPredictions.value!.gamemode + 1],
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
                left: miniCardWidth * 0.5 + 10,
                top: e.key * (miniCardWidth * 0.5) - 10,
                child: Transform.rotate(
                  angle: -pi / 2,
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.white,
                        width: miniCardWidth,
                        height: miniCardHeight,
                      ),
                      SizedBox(
                        height: miniCardHeight,
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
        right: fullWidth * (1 / 6 + 0.2),
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

    if (currentPredictions.value!.igra.id == userWidgets[1].id) {
      widgets.add(
        Positioned(
          top: 10,
          right: fullWidth * (1 / 6 + 0.2) - userSquareSize / 2,
          child: Container(
            height: userSquareSize / 2,
            width: userSquareSize / 2,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: Colors.black,
              ),
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                GAME_DESC[currentPredictions.value!.gamemode + 1],
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
                top: e.key * (miniCardWidth * 0.5) - 10,
                right: fullWidth * (1 / 6) + 50 + miniCardWidth,
                child: Transform.rotate(
                  angle: pi / 2,
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.white,
                        width: miniCardWidth,
                        height: miniCardHeight,
                      ),
                      SizedBox(
                        height: miniCardHeight,
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
    double fullWidth,
    double fullHeight,
  ) {
    List<Widget> widgets = [];

    if (userWidgets.isEmpty) {
      return widgets;
    }

    if (currentPredictions.value == null) {
      return widgets;
    }

    final miniCardHeight = fullHeight / 7;
    final miniCardWidth = miniCardHeight * 0.57;

    widgets.add(
      Positioned(
        top: leftFromTop + (m * cardK * 0.5) - userSquareSize / 2,
        left: miniCardHeight,
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

    if (currentPredictions.value!.igra.id == userWidgets[0].id) {
      widgets.add(
        Positioned(
          top: leftFromTop + (m * cardK * 0.5) - userSquareSize / 2,
          left: miniCardHeight + userSquareSize,
          child: Container(
            height: userSquareSize / 2,
            width: userSquareSize / 2,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: zaruf.value ? Colors.red : Colors.black,
              ),
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                GAME_DESC[currentPredictions.value!.gamemode + 1],
                style: TextStyle(
                  fontSize: 0.3 * userSquareSize,
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (userHasKing.value == userWidgets[0].id ||
        (currentPredictions.value!.igra.id == userWidgets[0].id &&
            selectedKing.value != "") ||
        currentPredictions.value!.kraljUltimo.id == userWidgets[0].id) {
      widgets.add(
        Positioned(
          top: leftFromTop + (m * cardK * 0.5),
          left: miniCardHeight + userSquareSize,
          child: Container(
            height: userSquareSize / 2,
            width: userSquareSize / 2,
            decoration: BoxDecoration(
              color: selectedKing.value == "/pik/kralj" ||
                      selectedKing.value == "/kriz/kralj"
                  ? Colors.black
                  : Colors.red,
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                  selectedKing.value == "/pik/kralj"
                      ? "♠️"
                      : (selectedKing.value == "/src/kralj"
                          ? "❤️"
                          : (selectedKing.value == "/kriz/kralj"
                              ? "♣️"
                              : "♦️")),
                  style: TextStyle(fontSize: 0.3 * userSquareSize)),
            ),
          ),
        ),
      );
    }

    if (kartePogoj(0)) {
      widgets.addAll(
        pridobiKarte(0)
            .asMap()
            .entries
            .map(
              (e) => Positioned(
                top: -e.key * (miniCardWidth * 0.5) +
                    leftFromTop +
                    (m * cardK * 0.5),
                child: Transform.rotate(
                  angle: -pi / 2,
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.white,
                        width: miniCardWidth,
                        height: miniCardHeight,
                      ),
                      SizedBox(
                        height: miniCardHeight,
                        child: Image.asset(
                          "assets/tarok${e.value.card.asset}.webp",
                          filterQuality: FilterQuality.medium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList()
            .reversed,
      );
    }

    if (userWidgets.length < 2) {
      return widgets;
    }

    widgets.add(
      Positioned(
        top: 10,
        left: fullWidth * (0.35 + 1 / 32),
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

    if (currentPredictions.value!.igra.id == userWidgets[1].id) {
      widgets.add(
        Positioned(
          top: 10,
          left: fullWidth * (0.35 + 1 / 32) + userSquareSize,
          child: Container(
            height: userSquareSize / 2,
            width: userSquareSize / 2,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: zaruf.value ? Colors.red : Colors.black,
              ),
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                GAME_DESC[currentPredictions.value!.gamemode + 1],
                style: TextStyle(
                  fontSize: 0.3 * userSquareSize,
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (userHasKing.value == userWidgets[1].id ||
        (currentPredictions.value!.igra.id == userWidgets[1].id &&
            selectedKing.value != "") ||
        currentPredictions.value!.kraljUltimo.id == userWidgets[1].id) {
      widgets.add(
        Positioned(
          top: 10 + userSquareSize / 2,
          left: fullWidth * (0.35 + 1 / 32) + userSquareSize,
          child: Container(
            height: userSquareSize / 2,
            width: userSquareSize / 2,
            decoration: BoxDecoration(
              color: selectedKing.value == "/pik/kralj" ||
                      selectedKing.value == "/kriz/kralj"
                  ? Colors.black
                  : Colors.red,
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                  selectedKing.value == "/pik/kralj"
                      ? "♠️"
                      : (selectedKing.value == "/src/kralj"
                          ? "❤️"
                          : (selectedKing.value == "/kriz/kralj"
                              ? "♣️"
                              : "♦️")),
                  style: TextStyle(fontSize: 0.3 * userSquareSize)),
            ),
          ),
        ),
      );
    }

    if (kartePogoj(1)) {
      widgets.addAll(
        pridobiKarte(1)
            .asMap()
            .entries
            .map(
              (e) => Positioned(
                left: fullWidth * 0.35 - (e.key + 1) * (miniCardWidth * 0.5),
                child: Transform.rotate(
                  angle: 0,
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.white,
                        width: miniCardWidth,
                        height: miniCardHeight,
                      ),
                      SizedBox(
                        height: miniCardHeight,
                        child: Image.asset(
                          "assets/tarok${e.value.card.asset}.webp",
                          filterQuality: FilterQuality.medium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList()
            .reversed,
      );
    }

    if (userWidgets.length < 3) {
      return widgets;
    }

    widgets.add(
      Positioned(
        top: leftFromTop + (m * cardK * 0.5) - userSquareSize / 2,
        right: fullWidth / 6 + userSquareSize * 1.5 + miniCardHeight,
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

    if (currentPredictions.value!.igra.id == userWidgets[2].id) {
      widgets.add(
        Positioned(
          top: leftFromTop + (m * cardK * 0.5) - userSquareSize / 2,
          right: fullWidth / 6 + userSquareSize + miniCardHeight,
          child: Container(
            height: userSquareSize / 2,
            width: userSquareSize / 2,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: zaruf.value ? Colors.red : Colors.black,
              ),
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                GAME_DESC[currentPredictions.value!.gamemode + 1],
                style: TextStyle(
                  fontSize: 0.3 * userSquareSize,
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (userHasKing.value == userWidgets[2].id ||
        (currentPredictions.value!.igra.id == userWidgets[2].id &&
            selectedKing.value != "") ||
        currentPredictions.value!.kraljUltimo.id == userWidgets[2].id) {
      widgets.add(
        Positioned(
          top: leftFromTop + (m * cardK * 0.5),
          right: fullWidth / 6 + userSquareSize + miniCardHeight,
          child: Container(
            height: userSquareSize / 2,
            width: userSquareSize / 2,
            decoration: BoxDecoration(
              color: selectedKing.value == "/pik/kralj" ||
                      selectedKing.value == "/kriz/kralj"
                  ? Colors.black
                  : Colors.red,
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                selectedKing.value == "/pik/kralj"
                    ? "♠️"
                    : (selectedKing.value == "/src/kralj"
                        ? "❤️"
                        : (selectedKing.value == "/kriz/kralj" ? "♣️" : "♦️")),
                style: TextStyle(fontSize: 0.3 * userSquareSize),
              ),
            ),
          ),
        ),
      );
    }

    if (kartePogoj(2)) {
      widgets.addAll(
        pridobiKarte(2)
            .asMap()
            .entries
            .map(
              (e) => Positioned(
                top: -e.key * (miniCardWidth * 0.5) +
                    leftFromTop +
                    (m * cardK * 0.5),
                right: fullWidth / 5.5 + userSquareSize / 2 + 45,
                child: Transform.rotate(
                  angle: pi / 2,
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.white,
                        width: miniCardWidth,
                        height: miniCardHeight,
                      ),
                      SizedBox(
                        height: miniCardHeight,
                        child: Image.asset(
                          "assets/tarok${e.value.card.asset}.webp",
                          filterQuality: FilterQuality.medium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList()
            .reversed,
      );
    }

    return widgets;
  }
}
