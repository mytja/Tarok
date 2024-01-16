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
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide FormData;
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:tarok/constants.dart';

// TMS = Tournament Management System
class TMSController extends GetxController {
  var tournaments = [].obs;
  var nameController = TextEditingController().obs;
  var tournamentTime = Rxn<DateTime>();
  var division = (3.0).obs;
  var testers = [].obs;
  var testerHandle = TextEditingController().obs;
  var guest = false.obs;
  var isAdmin = false.obs;

  @override
  void onInit() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    String? token = await storage.read(key: "token");
    if (token == "" || token == "a" || token == null) {
      guest.value = true;
    } else {
      storage.read(key: "role").then((value) {
        debugPrint(value);
        isAdmin.value = value == "admin";
        if (!isAdmin.value) return;
      });
    }
    await fetchTournaments();
    super.onInit();
  }

  @override
  void onClose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.onClose();
  }

  void newTournamentDialog(
      {String editId = "",
      bool private = true,
      bool rated = true,
      List authors = const []}) {
    Get.dialog(
      AlertDialog(
        scrollable: true,
        title: Text("new_tournament".tr),
        content: Obx(
          () => SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController.value,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: "name".tr,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text("start_at".tr),
                StatefulBuilder(builder: (context, setState) {
                  return Obx(
                    () => ElevatedButton(
                      onPressed: () async {
                        tournamentTime.value = await showOmniDateTimePicker(
                          context: context,
                          initialDate: tournamentTime.value,
                        );
                        setState(() {});
                      },
                      child: Text(
                        tournamentTime.value == null
                            ? "select_start".tr
                            : tournamentTime.toString(),
                      ),
                    ),
                  );
                }),
                const SizedBox(
                  height: 25,
                ),
                Text("division".tr),
                Slider(
                  value: division.value,
                  min: 1,
                  max: 4,
                  divisions: 3,
                  label: division.value.round().toString(),
                  onChanged: (double value) {
                    division.value = value;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              if (editId != "") {
                await updateTournament(editId, private, rated, authors);
                await fetchTournaments();
                Get.back();
                return;
              }
              await newTournament();
              Get.back();
            },
            child: Text(editId == ""
                ? "create_new_tournament".tr
                : "edit_tournament".tr),
          ),
        ],
      ),
    );
  }

  void testerDialog(String tournamentId) {
    Get.dialog(
      AlertDialog(
        scrollable: true,
        title: Text("edit_testers".tr),
        content: Obx(
          () => SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: testerHandle.value,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: "handle".tr,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () async {
                    await addTester(tournamentId);
                    return;
                  },
                  child: Text("ok".tr),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text("testers".tr),
                ...testers.map(
                  (e) => Row(
                    children: [
                      Text(
                        "${e['name']} (${e['handle']})",
                        style: const TextStyle(fontSize: 25),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () async {
                          await removeTester(tournamentId, e["userId"]);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("ok".tr),
          ),
        ],
      ),
    );
  }

  Future<void> newTournament() async {
    if (tournamentTime.value == null) return;
    await dio.post(
      '$BACKEND_URL/tournaments',
      data: FormData.fromMap({
        "name": nameController.value.text,
        "start_time": tournamentTime.value!.millisecondsSinceEpoch,
        "division": division.value.round(),
      }),
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    await fetchTournaments();
  }

  Future<void> fetchTournaments() async {
    final response = await dio.get(
      '$BACKEND_URL/tournaments/all',
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    tournaments.value = jsonDecode(response.data);
    debugPrint("$tournaments");
  }

  Future<void> deleteTournament(String tournamentId) async {
    await dio.delete(
      '$BACKEND_URL/tournament/$tournamentId',
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    await fetchTournaments();
  }

  Future<void> recalculateRating(String tournamentId) async {
    await dio.patch(
      '$BACKEND_URL/tournament/$tournamentId/rating/recalculate',
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    await fetchTournaments();
  }

  Future<void> removeTester(String tournamentId, String testerId) async {
    await dio.delete(
      '$BACKEND_URL/tournament/$tournamentId/testers',
      data: FormData.fromMap({
        "testerId": testerId,
      }),
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    await fetchTournaments();
  }

  Future<void> addTester(String tournamentId) async {
    await dio.post(
      '$BACKEND_URL/tournament/$tournamentId/testers',
      data: FormData.fromMap({
        "handle": testerHandle.value.text,
      }),
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    await fetchTournaments();
  }

  Future<void> updateTournament(
    String tournamentId,
    bool private,
    bool rated,
    List authors,
  ) async {
    await dio.patch(
      '$BACKEND_URL/tournament/$tournamentId',
      data: FormData.fromMap({
        "created_by": jsonEncode(authors),
        "name": nameController.value.text,
        "start_time": tournamentTime.value!.millisecondsSinceEpoch,
        "division": division.value.round(),
        "private": private,
        "rated": rated,
      }),
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    await fetchTournaments();
  }
}
