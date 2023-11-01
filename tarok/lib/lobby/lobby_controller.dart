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
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:get/get.dart' hide FormData;
import 'package:tarok/constants.dart';
import 'package:tarok/messages/lobby_messages.pb.dart' as Messages;
import 'package:tarok/sounds.dart';
import 'package:web_socket_client/web_socket_client.dart';

class User {
  User({required this.id, required this.name, required this.rating});

  String id;
  String name;
  int rating;
}

class Game {
  Game({
    required this.id,
    required this.user,
    required this.mondfangRadelci,
    required this.skisfang,
    required this.napovedanMondfang,
    required this.kontraKazen,
    required this.totalTime,
    required this.additionalTime,
    required this.type,
    required this.requiredPlayers,
    required this.started,
    required this.private,
  });

  String id;
  List<User> user;
  bool mondfangRadelci;
  bool skisfang;
  bool napovedanMondfang;
  bool kontraKazen;
  int totalTime;
  double additionalTime;
  String type;
  int requiredPlayers;
  bool started;
  bool private;
}

class Friend {
  Friend({
    required this.id,
    required this.email,
    required this.name,
    required this.status,
    required this.relationshipId,
  });

  String id;
  String email;
  String name;
  int status;
  String relationshipId;
}

class Replay {
  Replay({
    required this.url,
    required this.gameId,
    required this.createdAt,
  });

  String url;
  String gameId;
  String createdAt;
}

class LobbyController extends GetxController {
  var priorityQueue = <Game>[].obs;
  var queue = <Game>[].obs;

  late final WebSocket socket;

  var isAdmin = false.obs;
  var codes = [].obs;
  var botNames = [].obs;
  var controller = TextEditingController().obs;
  var playerNameController = TextEditingController().obs;
  var replayController = TextEditingController().obs;
  var guest = false.obs;
  var mondfang = false.obs;
  var skisfang = false.obs;
  var napovedanMondfang = false.obs;
  var pribitek = 2.0.obs;
  var zacetniCas = 20.0.obs;
  var iger = 8.0.obs;
  var party = false.obs;
  var odhodne = <Friend>[].obs;
  var prihodne = <Friend>[].obs;
  var prijatelji = <Friend>[].obs;
  var emailController = TextEditingController().obs;
  var replays = <Replay>[].obs;

  Map dropdownValue = BOTS.first;

  @override
  void onClose() {
    super.dispose();
    controller.value.dispose();
    playerNameController.value.dispose();
    replayController.value.dispose();
    emailController.value.dispose();
  }

  void dialog() {
    Get.dialog(
      AlertDialog(
        scrollable: true,
        title: const Text('Prilagodite si igro'),
        content: Obx(
          () => SizedBox(
            width: double.maxFinite,
            child: Column(
              children: guest.value
                  ? []
                  : [
                      const Text('Sekund na potezo (pribitek)'),
                      Slider(
                        value: pribitek.value,
                        max: 5,
                        divisions: 10,
                        label: pribitek.toString(),
                        onChanged: (double value) {
                          pribitek.value = value;
                        },
                      ),
                      const Text('Začetni čas (sekund)'),
                      Slider(
                        value: zacetniCas.value,
                        min: 15,
                        max: 45,
                        divisions: 6,
                        label: zacetniCas.round().toString(),
                        onChanged: (double value) {
                          zacetniCas.value = value;
                        },
                      ),
                      const Text('Število iger'),
                      Slider(
                        value: iger.value,
                        min: 1,
                        max: 41,
                        divisions: 40,
                        label: iger.value == 41 ? "∞" : iger.round().toString(),
                        onChanged: (double value) {
                          iger.value = value;
                        },
                      ),
                      const Text('Zasebna partija'),
                      Switch(
                        value: party.value,
                        onChanged: (bool value) {
                          party.value = value;
                        },
                      ),
                      const Text('Vsi igralci dobijo radelce na mondfang'),
                      Switch(
                        value: mondfang.value,
                        onChanged: (bool value) {
                          mondfang.value = value;
                        },
                      ),
                      const Text('-100 dol za igralca, ki izgubi škisa'),
                      Switch(
                        value: skisfang.value,
                        onChanged: (bool value) {
                          skisfang.value = value;
                        },
                      ),
                      const Text('Napovedan mondfang'),
                      Switch(
                        value: napovedanMondfang.value,
                        onChanged: (bool value) {
                          napovedanMondfang.value = value;
                        },
                      ),
                    ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              if (guest.value) {
                botGame(3);
                return;
              }
              await newGame(3);
            },
            child: const Text('V tri'),
          ),
          TextButton(
            onPressed: () async {
              if (guest.value) {
                botGame(4);
                return;
              }
              await newGame(4);
            },
            child: const Text('V štiri'),
          ),
        ],
      ),
    );
  }

  Future<void> newGame(int players) async {
    final token = await storage.read(key: "token");
    if (token == null) return;
    final response = await dio.post(
      '$BACKEND_URL/game/new/$players/normal',
      data: FormData.fromMap({
        "private": party,
        "zacetniCas": zacetniCas.round(),
        "pribitek": pribitek,
        "skisfang": skisfang,
        "mondfang": mondfang,
        "napovedanMondfang": napovedanMondfang,
        "rund": iger.round(),
      }),
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    String gameId = response.data.toString();
    debugPrint(response.statusCode.toString());
    debugPrint(gameId);
    // ignore: use_build_context_synchronously
    //Navigator.pop(context);
    // ignore: use_build_context_synchronously
    Get.toNamed("/game", parameters: {
      "playing": players.toString(),
      "gameId": gameId,
      "bots": "false",
    });
  }

  Future<void> quickGameFind(int players, String tip) async {
    final token = await storage.read(key: "token");
    if (token == null) return;
    final response = await dio.post(
      '$BACKEND_URL/quick',
      data: FormData.fromMap({"players": players, "tip": tip}),
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    String gameId = response.data.toString();
    Get.toNamed("/game", parameters: {
      "playing": players.toString(),
      "gameId": gameId,
      "bots": "false",
    });
  }

  void botGame(int players) {
    Get.toNamed("/game", parameters: {
      "playing": players.toString(),
      "gameId": "",
      "bots": "true",
    });
  }

  Future<List> getRegistrationCodes() async {
    final response = await dio.get(
      "$BACKEND_URL/admin/reg_code",
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    if (response.statusCode != 200) return codes;
    debugPrint(response.data);
    try {
      codes.value = jsonDecode(response.data);
    } catch (e) {
      codes.value = [];
    }
    return codes;
  }

  Future getBots() async {
    String? response = await storage.read(key: "bots");
    if (response == null) {
      await storage.write(key: "bots", value: "[]");
      response = "[]";
    }
    botNames.value = jsonDecode(response);
  }

  Future<void> newBot(String name, String type) async {
    botNames.add({"name": name, "type": type});
    await storage.write(key: "bots", value: jsonEncode(botNames));
    await getBots();
  }

  String randomBotName() {
    for (int i = 0; i < BOTS.length; i++) {
      Map bot = BOTS[i];
      if (bot["type"] != dropdownValue["type"]) continue;
      int preferred = Random().nextInt(bot["preferred_names"].length);
      return bot["preferred_names"][preferred];
    }
    int preferred = Random().nextInt(BOT_NAMES.length);
    return BOT_NAMES[preferred];
  }

  Future<void> deleteBot(String name, String type) async {
    for (int i = 0; i < botNames.length; i++) {
      Map bot = botNames[i];
      if (bot["type"] != type || bot["name"] != name) continue;
      debugPrint("Here I am");
      botNames.removeAt(i);
      await storage.write(key: "bots", value: jsonEncode(botNames));
      botNames.refresh();
      return;
    }
  }

  /* FRIENDS */

  void friendAddDialog() {
    Get.dialog(
      AlertDialog(
        scrollable: true,
        title: const Text('Dodaj prijatelja'),
        content: Column(
          children: [
            const Text('Elektronski naslov prijatelja'),
            TextField(
              controller: emailController.value,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              await addFriend();
              Get.back();
            },
            child: const Text('Dodaj'),
          ),
        ],
      ),
    );
  }

  Future<void> addFriend() async {
    final Uint8List message = Messages.LobbyMessage(
      friendRequestSend: Messages.FriendRequestSend(
        email: emailController.value.text,
      ),
    ).writeToBuffer();
    socket.send(message);
  }

  Future<void> friendRequest(String relationId, bool accept) async {
    final Uint8List message = Messages.LobbyMessage(
      friendRequestAcceptDecline: Messages.FriendRequestAcceptDecline(
        relationshipId: relationId,
        accept: accept,
      ),
    ).writeToBuffer();
    socket.send(message);
  }

  Future<void> removeRelation(String relationId) async {
    final Uint8List message = Messages.LobbyMessage(
            removeFriend: Messages.RemoveFriend(relationshipId: relationId))
        .writeToBuffer();
    socket.send(message);
  }

  /*
  INIT FUNCTIONS
  */
  @override
  void onInit() async {
    storage.read(key: "role").then((value) {
      debugPrint(value);
      isAdmin.value = value == "admin";
      if (!isAdmin.value) return;
    });

    // ONLINE
    try {
      connect();
      listen();
    } catch (e) {
      // eh, nič zato, smo čist v redu
    }

    super.onInit();
  }

  @override
  void dispose() {
    try {
      socket.close();
    } catch (e) {}
    super.dispose();
  }

  /*
  HELPER FUNCTIONS
  */
  void connect() {
    final backoff = LinearBackoff(
      initial: const Duration(seconds: 1),
      increment: const Duration(seconds: 2),
      maximum: const Duration(seconds: 20),
    );
    const timeout = Duration(seconds: 10);
    final uri = Uri.parse(LOBBY_WS_URL);
    debugPrint("requesting to $uri");
    socket = WebSocket(
      uri,
      binaryType: "arraybuffer",
      backoff: backoff,
      timeout: timeout,
    );
  }

  Future<void> login() async {
    final token = await storage.read(key: "token");
    final Uint8List message =
        Messages.LobbyMessage(loginInfo: Messages.LoginInfo(token: token))
            .writeToBuffer();
    socket.send(message);
  }

  void listen() {
    socket.messages.listen(
      (data) async {
        final msg = Messages.LobbyMessage.fromBuffer(data);

        debugPrint(msg.toString());
        if (msg.hasLoginRequest()) {
          await login();
          return;
        } else if (msg.hasLoginResponse()) {
          if (msg.loginResponse.hasFail()) {
            debugPrint("Closing the websocket connection");
            socket.close();
            return;
          }
        } else if (msg.hasGameCreated()) {
          final game = msg.gameCreated;
          List<User> players = [];
          for (int i = 0; i < game.players.length; i++) {
            var player = game.players[i];
            players.add(
              User(id: player.id, name: player.name, rating: player.rating),
            );
          }
          Game g = Game(
            id: game.gameId,
            user: players,
            mondfangRadelci: game.mondfangRadelci,
            skisfang: game.skisfang,
            napovedanMondfang: game.napovedanMondfang,
            kontraKazen: game.kontraKazen,
            totalTime: game.totalTime,
            additionalTime: game.additionalTime,
            type: game.type,
            requiredPlayers: game.requiredPlayers,
            started: game.started,
            private: game.private,
          );
          if (game.priority) {
            priorityQueue.add(g);
            priorityQueue.refresh();
          } else {
            queue.add(g);
            queue.refresh();
          }
        } else if (msg.hasGameDisbanded()) {
          for (int i = 0; i < priorityQueue.length; i++) {
            if (priorityQueue[i].id != msg.gameDisbanded.gameId) continue;
            priorityQueue.removeAt(i);
            priorityQueue.refresh();
            break;
          }
          for (int i = 0; i < queue.length; i++) {
            if (queue[i].id != msg.gameDisbanded.gameId) continue;
            queue.removeAt(i);
            queue.refresh();
            break;
          }
        } else if (msg.hasGameJoin()) {
          for (int i = 0; i < priorityQueue.length; i++) {
            if (priorityQueue[i].id != msg.gameJoin.gameId) continue;
            bool found = false;
            for (int n = 0; n < priorityQueue[i].user.length; n++) {
              if (priorityQueue[i].user[n].id != msg.gameJoin.player.id) {
                continue;
              }
              found = true;
              break;
            }
            if (found) break;
            priorityQueue[i].user.add(
                  User(
                    id: msg.gameJoin.player.id,
                    name: msg.gameJoin.player.name,
                    rating: msg.gameJoin.player.rating,
                  ),
                );
            priorityQueue.refresh();
            break;
          }
          for (int i = 0; i < queue.length; i++) {
            if (queue[i].id != msg.gameJoin.gameId) continue;
            bool found = false;
            for (int n = 0; n < queue[i].user.length; n++) {
              if (queue[i].user[n].id != msg.gameJoin.player.id) {
                continue;
              }
              found = true;
              break;
            }
            if (found) break;
            queue[i].user.add(
                  User(
                    id: msg.gameJoin.player.id,
                    name: msg.gameJoin.player.name,
                    rating: msg.gameJoin.player.rating,
                  ),
                );
            queue.refresh();
            break;
          }
        } else if (msg.hasGameLeave()) {
          for (int i = 0; i < priorityQueue.length; i++) {
            if (priorityQueue[i].id != msg.gameLeave.gameId) continue;
            for (int n = 0; n < priorityQueue[i].user.length; n++) {
              if (priorityQueue[i].user[n].id != msg.gameLeave.player.id) {
                continue;
              }
              priorityQueue[i].user.removeAt(n);
              break;
            }
            priorityQueue.refresh();
            break;
          }
          for (int i = 0; i < queue.length; i++) {
            if (queue[i].id != msg.gameLeave.gameId) continue;
            for (int n = 0; n < queue[i].user.length; n++) {
              if (queue[i].user[n].id != msg.gameLeave.player.id) {
                continue;
              }
              queue[i].user.removeAt(n);
              break;
            }
            queue.refresh();
            break;
          }
        } else if (msg.hasGameInvite()) {
          InAppNotifications.instance
            ..titleFontSize = 20.0
            ..descriptionFontSize = 14.0
            ..textColor = Colors.white
            ..backgroundColor = Colors.black
            ..shadow = true
            ..animationStyle = InAppNotificationsAnimationStyle.offset;
          InAppNotifications.show(
            title: 'Povabilo',
            description: 'Povabljeni ste bili v igro.',
            duration: const Duration(seconds: 5),
            onTap: () {},
          );
          Sounds.inviteNotification();
        } else if (msg.hasGameMove()) {
          final move = msg.gameMove;
          final priority = move.priority;
          if (priority) {
            for (int i = 0; i < queue.length; i++) {
              if (queue[i].id != move.gameId) continue;
              priorityQueue.add(queue[i]);
              queue.removeAt(i);
              queue.refresh();
              priorityQueue.refresh();
              break;
            }
          } else {
            for (int i = 0; i < priorityQueue.length; i++) {
              if (priorityQueue[i].id != move.gameId) continue;
              queue.add(priorityQueue[i]);
              priorityQueue.removeAt(i);
              queue.refresh();
              priorityQueue.refresh();
              break;
            }
          }
        } else if (msg.hasFriend()) {
          final f = msg.friend;
          final friend = Friend(
            id: msg.playerId,
            email: f.email,
            name: f.name,
            status: f.status,
            relationshipId: f.id,
          );
          if (f.hasConnected()) {
            for (int i = 0; i < prijatelji.length; i++) {
              if (prijatelji[i].id == msg.playerId) return;
            }
            prijatelji.add(friend);
            prijatelji.refresh();
          } else if (f.hasIncoming()) {
            for (int i = 0; i < prihodne.length; i++) {
              if (prihodne[i].id == msg.playerId) return;
            }
            prihodne.add(friend);
            prihodne.refresh();
          } else {
            for (int i = 0; i < odhodne.length; i++) {
              if (odhodne[i].id == msg.playerId) return;
            }
            odhodne.add(friend);
            odhodne.refresh();
          }
        } else if (msg.hasFriendOnlineStatus()) {
          final f = msg.friendOnlineStatus;
          for (int i = 0; i < prijatelji.length; i++) {
            if (prijatelji[i].id != msg.playerId) continue;
            prijatelji[i].status = f.status;
            prijatelji.refresh();
            break;
          }
        } else if (msg.hasFriendRequestAcceptDecline()) {
          for (int i = 0; i < odhodne.length; i++) {
            if (odhodne[i].relationshipId !=
                msg.friendRequestAcceptDecline.relationshipId) continue;
            if (msg.friendRequestAcceptDecline.accept) {
              prijatelji.add(odhodne[i]);
              prijatelji.refresh();
            }
            odhodne.removeAt(i);
            odhodne.refresh();
            break;
          }
          for (int i = 0; i < prihodne.length; i++) {
            if (prihodne[i].relationshipId !=
                msg.friendRequestAcceptDecline.relationshipId) continue;
            if (msg.friendRequestAcceptDecline.accept) {
              prijatelji.add(prihodne[i]);
              prijatelji.refresh();
            }
            prihodne.removeAt(i);
            prihodne.refresh();
            break;
          }
        } else if (msg.hasRemoveFriend()) {
          for (int i = 0; i < prijatelji.length; i++) {
            if (prijatelji[i].relationshipId !=
                msg.removeFriend.relationshipId) {
              continue;
            }
            prijatelji.removeAt(i);
            prijatelji.refresh();
            break;
          }
          for (int i = 0; i < prihodne.length; i++) {
            if (prihodne[i].relationshipId != msg.removeFriend.relationshipId) {
              continue;
            }
            prihodne.removeAt(i);
            prihodne.refresh();
            break;
          }
          for (int i = 0; i < odhodne.length; i++) {
            if (odhodne[i].relationshipId != msg.removeFriend.relationshipId) {
              continue;
            }
            odhodne.removeAt(i);
            odhodne.refresh();
            break;
          }
        } else if (msg.hasReplay()) {
          final replay = msg.replay;
          replays.add(Replay(
            url: replay.url,
            gameId: replay.gameId,
            createdAt: replay.createdAt,
          ));
          replays.refresh();
        }
      },
      onDone: () {
        debugPrint('ws channel closed');
      },
      onError: (error) => debugPrint(error),
    );
  }
}
