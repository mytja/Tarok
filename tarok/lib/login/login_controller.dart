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
import 'package:tarok/constants.dart';

class LoginController extends GetxController {
  var email = TextEditingController().obs;
  var name = TextEditingController().obs;
  var password1 = TextEditingController().obs;
  var password2 = TextEditingController().obs;
  var emailController = TextEditingController().obs;

  Future<void> login() async {
    final response = await dio.post(
      "$BACKEND_URL/login",
      data: FormData.fromMap(
        {"email": email.value.text, "pass": password1.value.text},
      ),
    );
    if (response.statusCode != 200) return;
    final data = jsonDecode(response.data);
    await storage.write(key: "token", value: data["token"]);
    await storage.write(key: "role", value: data["role"]);
    Get.toNamed("/");
  }

  Future<void> register() async {
    if (password1.value.text != password2.value.text) {
      Get.dialog(
        AlertDialog(
          title: const Text('Gesli se ne ujemata'),
          content: const SizedBox(),
          actions: <Widget>[
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    final response = await dio.post(
      "$BACKEND_URL/register",
      data: FormData.fromMap(
        {
          "email": email.value.text,
          "pass": password1.value.text,
          "name": name.value.text,
          "regCode": "",
        },
      ),
    );
    if (response.statusCode != 201) return;
    Get.toNamed("/login");
  }

  @override
  void onClose() {
    email.value.dispose();
    name.value.dispose();
    password1.value.dispose();
    password2.value.dispose();
    super.onClose();
  }
}