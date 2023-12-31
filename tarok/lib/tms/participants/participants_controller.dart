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
import 'package:get/get.dart' hide FormData;
import 'package:tarok/constants.dart';

class ParticipantsController extends GetxController {
  var participants = [].obs;
  String contestId = Get.parameters["tournamentId"]!;

  Future<void> unregister(String participantId) async {
    await dio.post(
      '$BACKEND_URL/tournament/$contestId/unregister',
      data: FormData.fromMap({
        "participantId": participantId,
      }),
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    await fetchParticipants();
  }

  Future<void> fetchParticipants() async {
    final response = await dio.get(
      '$BACKEND_URL/tournament/$contestId/participants',
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    participants.value = jsonDecode(response.data);
  }

  Future<void> toggleRatedUnrated(String participationId) async {
    await dio.patch(
      '$BACKEND_URL/participation/$participationId/rated_unrated',
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    await fetchParticipants();
  }

  @override
  Future<void> onInit() async {
    await fetchParticipants();
    super.onInit();
  }
}
