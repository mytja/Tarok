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
    required this.disabled,
    required this.emailVerified,
    required this.registeredOn,
    required this.role,
    required this.handle,
  });

  final String userId;
  final String name;
  final String email;
  final int playedGames;
  RxBool disabled;
  RxBool emailVerified;
  final String registeredOn;
  final String role;
  final String handle;
}

class AdminController extends GetxController {
  var users = <User>[].obs;
  var controller = TextEditingController().obs;
  var handleController = TextEditingController().obs;

  Future<void> getUsers() async {
    final response = await dio.get(
      '$BACKEND_URL/admin/users',
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    List<User> usersList = [];
    List s = jsonDecode(response.data);
    for (int i = 0; i < s.length; i++) {
      usersList.add(User(
        userId: s[i]["userId"],
        name: s[i]["name"],
        email: s[i]["email"],
        playedGames: s[i]["playedGames"],
        disabled: (s[i]["disabled"] as bool).obs,
        emailVerified: (s[i]["emailVerified"] as bool).obs,
        registeredOn: s[i]["registeredOn"],
        role: s[i]["role"],
        handle: s[i]["handle"],
      ));
    }
    users.value = usersList;
  }

  Future<void> disableAccount(String userId) async {
    await dio.patch(
      '$BACKEND_URL/admin/accounts/disable',
      data: FormData.fromMap({
        "userId": userId,
      }),
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    await getUsers();
  }

  Future<void> validateEmailAccount(String userId) async {
    await dio.patch(
      '$BACKEND_URL/admin/accounts/validate',
      data: FormData.fromMap({
        "userId": userId,
      }),
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    await getUsers();
  }

  Future<void> changeName(String userId) async {
    await dio.patch(
      '$BACKEND_URL/account/name',
      data: FormData.fromMap({
        "userId": userId,
        "name": controller.value.text,
      }),
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    await getUsers();
  }

  Future<void> changeHandle(String userId) async {
    await dio.patch(
      '$BACKEND_URL/account/handle',
      data: FormData.fromMap({
        "userId": userId,
        "handle": handleController.value.text,
      }),
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    await getUsers();
  }

  Future<void> promoteDemoteUser(String userId) async {
    await dio.patch(
      '$BACKEND_URL/admin/accounts/promote_demote',
      data: FormData.fromMap({
        "userId": userId,
      }),
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    await getUsers();
  }

  @override
  void onInit() async {
    getUsers();
    super.onInit();
  }
}
