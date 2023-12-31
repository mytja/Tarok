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

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:tarok/constants.dart';

class User {
  User({
    required this.userId,
    required this.name,
    required this.email,
    required this.playedGames,
    required this.registeredOn,
    required this.role,
    required this.handle,
    required this.rating,
    required this.ratingDelta,
  });

  final String userId;
  final String name;
  final String email;
  final int playedGames;
  final String registeredOn;
  final String role;
  final String handle;
  final int rating;
  final List ratingDelta;
}

class UserSettingsController extends GetxController {
  var user = User(
    userId: "",
    name: "",
    email: "",
    playedGames: 0,
    registeredOn: "",
    role: "",
    handle: "",
    rating: 1000,
    ratingDelta: [],
  ).obs;
  var oldPasswordController = TextEditingController().obs;
  var newPasswordController = TextEditingController().obs;
  var newPasswordControllerValidate = TextEditingController().obs;
  var nameController = TextEditingController().obs;
  var handleController = TextEditingController().obs;

  Future<void> getUser() async {
    final response = await dio.get(
      '$BACKEND_URL/account',
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    Map s = jsonDecode(response.data);
    user.value = User(
      userId: s["userId"],
      name: s["name"],
      email: s["email"],
      playedGames: s["playedGames"],
      registeredOn: s["registeredOn"],
      role: s["role"],
      handle: s["handle"],
      rating: s["rating"],
      ratingDelta: s["ratingDelta"],
    );
  }

  Future<void> changeName() async {
    await dio.patch(
      '$BACKEND_URL/account/name',
      data: FormData.fromMap({
        "name": nameController.value.text,
      }),
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    await getUser();
  }

  Future<void> changeHandle() async {
    await dio.patch(
      '$BACKEND_URL/account/handle',
      data: FormData.fromMap({
        "handle": handleController.value.text,
      }),
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    await getUser();
  }

  Future<void> changePassword() async {
    if (newPasswordControllerValidate.value.text !=
        newPasswordController.value.text) {
      return;
    }
    await dio.patch(
      '$BACKEND_URL/account/password',
      data: FormData.fromMap({
        "oldPassword": oldPasswordController.value.text,
        "newPassword": newPasswordController.value.text,
      }),
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    logout();
  }

  @override
  void onInit() async {
    getUser();
    super.onInit();
  }
}
