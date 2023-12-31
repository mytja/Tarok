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
import 'package:tarok/login/login_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class Register extends StatelessWidget {
  const Register({super.key});

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
              "registration".tr,
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
              height: 10,
            ),
            SizedBox(
              width: 350,
              child: TextField(
                controller: controller.name.value,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "profile_name".tr,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 350,
              child: TextField(
                controller: controller.handle.value,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "handle".tr,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text("handle_desc".tr),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 350,
              child: TextField(
                controller: controller.password1.value,
                obscureText: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "password".tr,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 350,
              child: TextField(
                controller: controller.password2.value,
                obscureText: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "repeat_password".tr,
                ),
              ),
            ),
            /*const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 350,
              child: TextField(
                controller: _regCode,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Registracijska koda',
                ),
              ),
            ),*/
            const SizedBox(
              height: 20,
            ),
            Text("tos_text".tr),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: controller.register,
              child: Text("register".tr, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                await launchUrl(Uri.parse("https://palcka.si/tos.html"));
              },
              child: Text("tos".tr, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(
              height: 10,
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
