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

import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:get/get.dart' hide FormData;
import 'package:tarok/constants.dart';
import 'package:tarok/game/game_controller.dart';
import 'package:tarok/lobby/lobby_controller.dart';
import 'package:tarok/ui/main_page.dart';

class Friends extends StatelessWidget {
  const Friends({super.key, this.gameId = ""});

  final String gameId;

  @override
  Widget build(BuildContext context) {
    LobbyController controller = Get.put(LobbyController());

    List<String> invited = [];

    Widget mainContent = Obx(
      () => ListView(
        shrinkWrap: true,
        children: <Widget>[
          Center(
            child: Text(
              "my_friends".tr,
              style: const TextStyle(fontSize: 40),
            ),
          ),
          Center(
            child: Text(
              "incoming_friend_requests".tr,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          ...controller.prihodne.map(
            (e) => Container(
              margin: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 100,
                  ),
                  Initicon(
                    text: e.name,
                    elevation: 4,
                    size: 70,
                    backgroundColor:
                        HSLColor.fromAHSL(1, hashCode(e.name) % 360, 1, 0.6)
                            .toColor(),
                    borderRadius: BorderRadius.zero,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.name,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          )),
                      Text(e.email),
                    ],
                  ),
                  const Spacer(),
                  if (gameId == "")
                    IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () async {
                        await controller.friendRequest(e.relationshipId, true);
                      },
                    ),
                  if (gameId == "")
                    IconButton(
                      icon: const Icon(Icons.block),
                      onPressed: () async {
                        await controller.friendRequest(e.relationshipId, false);
                      },
                    ),
                  const SizedBox(
                    width: 100,
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Text(
              "outgoing_friend_requests".tr,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          ...controller.odhodne.map(
            (e) => Container(
              margin: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 100,
                  ),
                  Initicon(
                    text: e.name,
                    elevation: 4,
                    size: 70,
                    backgroundColor:
                        HSLColor.fromAHSL(1, hashCode(e.name) % 360, 1, 0.6)
                            .toColor(),
                    borderRadius: BorderRadius.zero,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.name,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          )),
                      Text(e.email),
                    ],
                  ),
                  const Spacer(),
                  if (gameId == "")
                    IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () async {
                        await controller.removeRelation(e.relationshipId);
                      },
                    ),
                  const SizedBox(
                    width: 100,
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Text(
              "friends".tr,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          ...controller.prijatelji.map(
            (e) => Container(
              margin: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 100,
                  ),
                  SizedBox(
                    height: 70,
                    width: 70,
                    child: Stack(children: [
                      Initicon(
                        text: e.name,
                        elevation: 4,
                        size: 70,
                        backgroundColor:
                            HSLColor.fromAHSL(1, hashCode(e.name) % 360, 1, 0.6)
                                .toColor(),
                        borderRadius: BorderRadius.zero,
                      ),
                      if (e.status == 0)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            color: Colors.grey,
                            height: 15,
                            width: 15,
                          ),
                        ),
                      if (e.status == 1)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            color: Colors.greenAccent.shade700,
                            height: 15,
                            width: 15,
                          ),
                        ),
                      if (e.status == 2)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            color: Colors.red,
                            height: 15,
                            width: 15,
                          ),
                        ),
                    ]),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.name,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          )),
                      Text(e.email),
                    ],
                  ),
                  const Spacer(),
                  if (gameId == "")
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () async {
                        await controller.removeRelation(e.relationshipId);
                      },
                    ),
                  if (gameId != "" && !invited.contains(e.id))
                    ElevatedButton(
                      child: Text("invite".tr),
                      onPressed: () async {
                        GameController c = Get.put(GameController());
                        await c.invitePlayer(e.id);
                        invited.add(e.id);
                        controller.prijatelji.refresh();
                      },
                    ),
                  if (gameId != "" && invited.contains(e.id))
                    const Icon(Icons.check),
                  const SizedBox(
                    width: 100,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (gameId != "") return mainContent;

    return PalckaHome(
      floatingActionButton: FloatingActionButton(
        onPressed: controller.friendAddDialog,
        tooltip: "add_friend".tr,
        child: const Icon(Icons.add),
      ),
      child: mainContent,
    );
  }
}
