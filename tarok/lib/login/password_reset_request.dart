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
import 'package:tarok/login/login_controller.dart';

class PasswordResetRequest extends StatelessWidget {
  const PasswordResetRequest({super.key});

  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.put(LoginController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("palcka".tr),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Get.toNamed("/settings");
            },
          ),
        ],
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20.0),
          children: [
            Text(
              "password_reset".tr,
              style: const TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 350,
              child: TextField(
                controller: controller.email.value,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "email".tr,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text("password_reset_procedure".tr),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: controller.passwordResetRequest,
              child: Text("password_reset_request".tr,
                  style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                await Get.toNamed("/login");
              },
              child: Text("login".tr, style: const TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
