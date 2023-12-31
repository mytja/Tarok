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

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:stockskis/stockskis.dart';
import 'package:tarok/constants.dart';
import 'package:tarok/game/variables.dart';

enum Cards { person1, person2, person3, person4, talon }

class Round {
  Round({
    required this.id,
    required this.tournamentId,
    required this.roundId,
    required this.cards,
    required this.talon,
    required this.time,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String tournamentId;
  final int roundId;
  final List<List<String>> cards;
  final List<String> talon;
  final int time;
  final String createdAt;
  final String updatedAt;

  List<String> availableCards = CARDS.map((e) => e.asset).toList();
  var selectedDeck = Rx(Cards.person1);
}

class RoundsController extends GetxController {
  var rounds = <Round>[].obs;
  String contestId = Get.parameters["tournamentId"]!;
  var roundTime = (45.0).obs;

  Future<void> newRound() async {
    await dio.post(
      '$BACKEND_URL/tournament/$contestId/rounds',
      data: FormData.fromMap({
        "roundTime": roundTime.round(),
      }),
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    await fetchRounds();
  }

  Future<void> fetchRounds() async {
    final response = await dio.get(
      '$BACKEND_URL/tournament/$contestId/rounds',
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );

    List<Round> roundsArchive = [...rounds];
    rounds.value = [];

    List r = jsonDecode(response.data);
    for (int i = 0; i < r.length; i++) {
      var n = r[i];
      var round = Round(
        id: n["round_id"],
        tournamentId: n["tournament_id"],
        roundId: n["consecutive_round_id"],
        cards: (n["cards"] as List)
            .map((e) => sortStringCards(List<String>.from(e)))
            .toList(),
        talon: List<String>.from(n["talon"]),
        time: n["time"],
        createdAt: n["created_at"],
        updatedAt: n["updated_at"],
      );
      for (int f = 0; f < roundsArchive.length; f++) {
        if (roundsArchive[f].id != round.id) continue;
        round.selectedDeck.value = roundsArchive[f].selectedDeck.value;
        break;
      }

      for (int n = 0; n < round.cards.length; n++) {
        var uc = round.cards[n];
        for (int f = 0; f < uc.length; f++) {
          String c = round.cards[n][f];
          round.availableCards.remove(c);
        }
      }

      for (int f = 0; f < round.talon.length; f++) {
        String c = round.talon[f];
        round.availableCards.remove(c);
      }

      rounds.add(round);
    }
    rounds.refresh();
  }

  Future<void> clearTournamentCards(String roundId) async {
    await dio.post(
      '$BACKEND_URL/tournament_round/$roundId/clear',
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    await fetchRounds();
  }

  Future<void> deleteRound(String roundId) async {
    await dio.delete(
      '$BACKEND_URL/tournament_round/$roundId',
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    await fetchRounds();
  }

  Future<void> reshuffleCards(String roundId) async {
    await dio.post(
      '$BACKEND_URL/tournament_round/$roundId/reshuffle',
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    await fetchRounds();
  }

  Future<void> addCard(String roundId, String card, int deckId) async {
    await dio.post(
      '$BACKEND_URL/tournament_round/$roundId/card',
      data: FormData.fromMap({
        "card": card,
        "deckId": deckId,
      }),
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    await fetchRounds();
  }

  Future<void> deleteCard(String roundId, String card, int deckId) async {
    await dio.delete(
      '$BACKEND_URL/tournament_round/$roundId/card',
      data: FormData.fromMap({
        "card": card,
        "deckId": deckId,
      }),
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    await fetchRounds();
  }

  void newRoundDialog() {
    Get.dialog(
      AlertDialog(
        scrollable: true,
        title: Text("new_round".tr),
        content: Obx(
          () => SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("time_per_round".tr),
                Slider(
                  value: roundTime.value,
                  min: 30,
                  max: 120,
                  divisions: 18,
                  label: roundTime.value.round().toString(),
                  onChanged: (double value) {
                    roundTime.value = value;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              await newRound();
              Get.back();
            },
            child: Text("create_new_round".tr),
          ),
        ],
      ),
    );
  }

  @override
  Future<void> onInit() async {
    await fetchRounds();
    super.onInit();
  }
}
