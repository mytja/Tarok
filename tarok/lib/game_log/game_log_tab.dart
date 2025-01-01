import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:safe_local_storage/safe_local_storage.dart';
import 'package:tarok/game_log/game_log_event_widget.dart';
import 'package:tarok/game_log/game_log_object.dart';

class GameLogFile {
  final String path;
  final int creation;

  GameLogFile({required this.path, required this.creation});
}

class GameLogTab extends StatefulWidget {
  const GameLogTab({super.key});

  @override
  _GameLogTabState createState() => _GameLogTabState();
}

class _GameLogTabState extends State<GameLogTab> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  String? selectedGame;
  List gameLog = [];

  Future<List<GameLogFile>> loadGames() async {
    List<GameLogFile> files = [];
    var directory = await getApplicationDocumentsDirectory();
    directory = Directory("${directory.path}/PalckaGames");
    await directory.create();
    await for (FileSystemEntity entity in directory.list(followLinks: false)) {
      if (!entity.path.contains("gamelog-")) continue;
      FileStat stats = await entity.stat();
      files.add(GameLogFile(
        path: entity.path,
        creation: stats.modified.millisecondsSinceEpoch,
      ));
    }
    files.sort((a, b) => -a.creation.compareTo(b.creation));
    return files;
  }

  Future<void> loadGame(String gamePath) async {
    final storage = SafeLocalStorage(gamePath);
    gameLog = jsonDecode(await storage.read());
  }

  Widget convertGameLogTypes(BuildContext context, GameLog log) {
    switch (log.actionType) {
      case GameLogTypes.GAME_END:
        return GameLogEvent(
          title: "game_ended".tr,
          subtitle: "game_ended_subtitle".tr,
          log: log,
          rightDisplay: -1,
          icon: const Icon(Icons.stop, size: 48),
        );
      case GameLogTypes.GAME_START:
        return GameLogEvent(
          title: "game_started".tr,
          subtitle: "game_started_subtitle".tr,
          log: log,
          rightDisplay: -1,
          icon: const Icon(Icons.play_arrow, size: 48),
        );
      case GameLogTypes.START_LICITATION:
        return GameLogEvent(
          title: "licitation_started".tr,
          subtitle:
              "licitation_started_subtitle".trParams({"player": log.userName}),
          log: log,
          rightDisplay: -1,
          icon: const Icon(Icons.speaker, size: 48),
          showCards: false,
        );
      case GameLogTypes.USER_LICITATED_SOMETHING:
        return GameLogEvent(
          title: "user_licitated".tr,
          subtitle:
              "user_licitated_subtitle".trParams({"player": log.userName}),
          log: log,
          rightDisplay: 0,
          icon: const Icon(Icons.speaker, size: 48),
        );
      case GameLogTypes.LICITATIONS_DONE:
        return GameLogEvent(
          title: "licitations_done".tr,
          subtitle: "licitations_done_subtitle".trParams({
            "player": log.userName,
          }),
          log: log,
          rightDisplay: 0,
          icon: const Icon(Icons.speaker, size: 48),
        );
      case GameLogTypes.KING_SELECTION_STARTED:
        return GameLogEvent(
          title: "king_selection_started".tr,
          subtitle: "king_selection_started_subtitle".trParams({
            "player": log.userName,
          }),
          log: log,
          rightDisplay: -1,
          icon: const Icon(Icons.how_to_reg, size: 48),
          showCards: false,
        );
      case GameLogTypes.KING_SELECTED_KING_SELECTION_ENDED:
        return GameLogEvent(
          title: "king_selection_done".tr,
          subtitle: "king_selection_done_subtitle".trParams({
            "player": log.userName,
          }),
          log: log,
          rightDisplay: 1,
          icon: const Icon(Icons.how_to_reg, size: 48),
        );
      case GameLogTypes.TALON_OPEN:
        return GameLogEvent(
          title: "talon_open".tr,
          subtitle: "talon_open_subtitle".trParams({
            "player": log.userName,
          }),
          log: log,
          rightDisplay: 1,
          icon: const Icon(Icons.style, size: 48),
        );
      case GameLogTypes.TALON_SELECTED:
        return GameLogEvent(
          title: "talon_selected".tr,
          subtitle: "talon_selected_subtitle".trParams({
            "player": log.userName,
          }),
          log: log,
          rightDisplay: 2,
          icon: const Icon(Icons.style, size: 48),
        );
      case GameLogTypes.CARD_STASHING_STARTED:
        return GameLogEvent(
          title: "card_stashing_started".tr,
          subtitle: "card_stashing_started_subtitle".trParams({
            "player": log.userName,
            "cardAmount": log.action.toString(),
          }),
          log: log,
          rightDisplay: -1,
          icon: const Icon(Icons.reorder, size: 48),
        );
      case GameLogTypes.CARD_STASHED:
        return GameLogEvent(
          title: "card_stashed".tr,
          subtitle: "card_stashed_subtitle".trParams({
            "player": log.userName,
          }),
          log: log,
          rightDisplay: 1,
          icon: const Icon(Icons.reorder, size: 48),
        );
      case GameLogTypes.CARD_STASHING_DONE:
        return GameLogEvent(
          title: "card_stashing_done".tr,
          subtitle: "card_stashing_done_subtitle".trParams({
            "player": log.userName,
            "cardAmount": log.action.toString(),
          }),
          log: log,
          rightDisplay: -1,
          icon: const Icon(Icons.reorder, size: 48),
        );
      case GameLogTypes.TALON_CLOSED:
        return GameLogEvent(
          title: "talon_closed".tr,
          subtitle: "talon_closed_subtitle".trParams({
            "player": log.userName,
          }),
          log: log,
          rightDisplay: -1,
          icon: const Icon(Icons.style, size: 48),
          showCards: false,
        );
      case GameLogTypes.PREDICTIONS_STARTED:
        return GameLogEvent(
          title: "predictions_started".tr,
          subtitle: "predictions_started_subtitle".trParams({
            "player": log.userName,
          }),
          log: log,
          rightDisplay: -1,
          icon: const Icon(Icons.question_mark, size: 48),
          showCards: false,
        );
      case GameLogTypes.USER_PREDICTED:
        final predictions = log.additionalData;
        List<String> finalNames = [];
        for (String prediction in predictions) {
          String finalName = "";
          List<String> data = prediction.split("/");
          String predictionName = data[0].tr;
          if (data[0] == "game") predictionName = "game_prediction".tr;
          String d = data[1].replaceFirst("kontra", "");
          if (d == "prediction") {
            finalName = "${'predicted'.tr}$predictionName";
          } else {
            finalName =
                "${'kontra_predicted'.tr}$predictionName (${2 << (int.parse(d) - 1)})";
          }
          finalNames.add(finalName);
        }
        return GameLogEvent(
          title: "user_predicted".tr,
          subtitle: "user_predicted_subtitle".trParams({
            "player": log.userName,
            "finalNames": finalNames.join("\n"),
          }),
          log: log,
          rightDisplay: -1,
          icon: const Icon(Icons.question_mark, size: 48),
          showCards: false,
        );
      case GameLogTypes.PREDICTIONS_DONE:
        return GameLogEvent(
          title: "predictions_done".tr,
          subtitle: "predictions_done_subtitle".trParams({
            "player": log.userName,
          }),
          log: log,
          rightDisplay: -1,
          icon: const Icon(Icons.question_mark, size: 48),
          showCards: false,
        );
      case GameLogTypes.CARD_GAME_STARTED:
        return GameLogEvent(
          title: "card_game_started".tr,
          subtitle: "card_game_started_subtitle".trParams({
            "player": log.userName,
          }),
          log: log,
          rightDisplay: -1,
          icon: const Icon(Icons.note, size: 48),
        );
      case GameLogTypes.CARD_ROUND_STARTED:
        return GameLogEvent(
          title: "card_round_started".tr,
          subtitle: "card_round_started_subtitle".trParams({
            "player": log.userName,
          }),
          log: log,
          rightDisplay: 4,
          icon: const Icon(Icons.description, size: 48),
        );
      case GameLogTypes.CARD_DROPPED:
        return GameLogEvent(
          title: "card_dropped".tr,
          subtitle: log.userId == "system"
              ? "system_card_dropped_subtitle".trParams({
                  "player": log.userName,
                })
              : "card_dropped_subtitle".trParams({
                  "player": log.userName,
                }),
          log: log,
          rightDisplay: 1,
          icon: const Icon(Icons.description, size: 48),
        );
      case GameLogTypes.CARD_ROUND_DONE:
        return GameLogEvent(
          title: "card_round_done".tr,
          subtitle: "card_round_done_subtitle".trParams({
            "player": log.userName,
          }),
          log: log,
          rightDisplay: 3,
          icon: const Icon(Icons.description, size: 48),
          showCards: false,
        );
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("palcka".tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Row(
        children: [
          Container(
            width: 200,
            color: Colors.black54,
            child: FutureBuilder(
              future: loadGames(),
              initialData: const <GameLogFile>[],
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List<Widget> w = [];
                  for (int i = 0; i < snapshot.data.length; i++) {
                    GameLogFile file = snapshot.data[i];
                    w.add(
                      ListTile(
                        leading: const Icon(Icons.games),
                        title: Text('game_number'.trParams({
                          "gameNumber": (snapshot.data.length - i).toString(),
                        })),
                        onTap: () async {
                          selectedGame = file.path;
                          await loadGame(file.path);
                          setState(() {});
                        },
                        selected: selectedGame == file.path,
                      ),
                    );
                  }
                  return ListView(
                    padding: const EdgeInsets.all(8),
                    children: w,
                  );
                }
                return const Center(
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  ...gameLog.map(
                    (e) => convertGameLogTypes(context, GameLog.fromJson(e)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
