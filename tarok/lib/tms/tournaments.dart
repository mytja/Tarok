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
import 'package:get/get.dart';
import 'package:tarok/tms/tms_controller.dart';
import 'package:tarok/tms/tournament_card.dart';
import 'package:tarok/ui/main_page.dart';

class Tournaments extends StatelessWidget {
  const Tournaments({super.key});

  @override
  Widget build(BuildContext context) {
    TMSController controller = Get.put(TMSController());
    return Obx(
      () => PalckaHome(
        floatingActionButton: controller.isAdmin.value
            ? FloatingActionButton(
                onPressed: controller.newTournamentDialog,
                tooltip: "new_tournament".tr,
                child: const Icon(Icons.add),
              )
            : const SizedBox(),
        automaticallyImplyLeading: true,
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: <Widget>[
              Text(
                "tournaments".tr,
                style: const TextStyle(fontSize: 30),
              ),
              ...controller.tournaments.map(
                (e) => e["start_time"] < DateTime.now().millisecondsSinceEpoch
                    ? const SizedBox()
                    : TournamentCard(e: e),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "past_tournaments".tr,
                style: const TextStyle(fontSize: 30),
              ),
              ...controller.tournaments.map(
                (e) => e["start_time"] > DateTime.now().millisecondsSinceEpoch
                    ? const SizedBox()
                    : TournamentCard(e: e),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
