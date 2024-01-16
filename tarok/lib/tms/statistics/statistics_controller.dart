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
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide FormData;
import 'package:tarok/constants.dart';

class Participant {
  Participant({
    required this.userId,
    required this.userName,
    required this.delta,
    required this.points,
    required this.rated,
    required this.userHandle,
    required this.rating,
  });

  final String userId;
  final String userName;
  final int delta;
  final int points;
  final bool rated;
  final String userHandle;
  final int rating;
}

class StatisticsController extends GetxController {
  var participants = <Participant>[].obs;
  String contestId = Get.parameters["tournamentId"]!;
  var roundTime = (45.0).obs;

  Future<void> fetchStats() async {
    final response = await dio.get(
      '$BACKEND_URL/tournament/$contestId/stats',
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );

    participants.value = [];

    List r = jsonDecode(response.data);

    debugPrint("$r");

    for (int i = 0; i < r.length; i++) {
      var n = r[i];
      var participant = Participant(
        userId: n["user_id"],
        userName: n["user_name"],
        delta: n["delta"],
        points: n["points"],
        rated: n["rated"],
        userHandle: n["user_handle"],
        rating: n["rating"],
      );
      participants.add(participant);
    }
    participants.refresh();
  }

  @override
  Future<void> onInit() async {
    await fetchStats();
    super.onInit();
  }
}
