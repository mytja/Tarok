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
import 'package:stockskis/stockskis.dart' hide Card, debugPrint;
import 'package:tarok/lobby/lobby_controller.dart';
import 'package:tarok/lobby/lobby_ui.dart';
import 'package:tarok/ui/main_page.dart';

Future<void> preloadCards(BuildContext context) async {
  for (int i = 0; i < CARDS.length; i++) {
    LocalCard card = CARDS[i];
    await precacheImage(
      AssetImage("assets/tarok${card.asset}.webp"),
      context,
    );
  }
}

class Lobby extends StatelessWidget {
  const Lobby({super.key});

  @override
  Widget build(BuildContext context) {
    LobbyController controller = Get.put(LobbyController());

    return PalckaHome(
      floatingActionButton: FloatingActionButton(
        onPressed: controller.dialog,
        tooltip: "new_game".tr,
        child: const Icon(Icons.add),
      ),
      child: const Column(
        children: [
          LobbyUI(),
        ],
      ),
    );
  }
}
