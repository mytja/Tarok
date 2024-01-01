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
import 'package:get/get.dart' hide FormData;
import 'package:tarok/lobby/lobby_controller.dart';
import 'package:tarok/replay.dart';
import 'package:tarok/ui/main_page.dart';

class Replays extends StatelessWidget {
  const Replays({super.key});

  @override
  Widget build(BuildContext context) {
    LobbyController controller = Get.put(LobbyController());

    return PalckaHome(
      child: Obx(
        () => ListView(
          padding:
              const EdgeInsets.only(left: 50, right: 50, top: 10, bottom: 10),
          children: <Widget>[
            Center(
              child: Text(
                "replays".tr,
                style: const TextStyle(fontSize: 40),
              ),
            ),
            ...controller.replays.map(
              (e) => Row(
                children: [
                  //Text(e.gameId),
                  //const Spacer(),
                  Text(
                      "${DateTime.parse(e.createdAt).day}. ${DateTime.parse(e.createdAt).month}. ${DateTime.parse(e.createdAt).year}, ${DateTime.parse(e.createdAt).hour}.${DateTime.parse(e.createdAt).minute}"),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      await joinReplay(e.url);
                    },
                    child: Text("watch_replay".tr),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
