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
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:get/get.dart' hide FormData;
import 'package:tarok/ui/main_page.dart';
import 'package:tarok/user/user_controller.dart';
import 'package:tarok/constants.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    UserSettingsController controller = Get.put(UserSettingsController());

    return PalckaHome(
      child: Obx(
        () => ListView(
          padding: const EdgeInsets.all(30),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Initicon(
                  text: controller.user.value.name,
                  elevation: 4,
                  backgroundColor: HSLColor.fromAHSL(
                          1, hashCode(controller.user.value.name) % 360, 1, 0.6)
                      .toColor(),
                  borderRadius: BorderRadius.zero,
                  size: 100,
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          controller.user.value.name,
                          style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            controller.nameController.value.text =
                                controller.user.value.name;
                            Get.dialog(
                              AlertDialog(
                                title: const Text("Zamenjava imena"),
                                content: IntrinsicHeight(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Zamenjava imena je brezplačna in prosto dostopna vsem.",
                                      ),
                                      const Text(
                                        "V primeru neprimernega imena, bodo administratorji spremenili ime, uporabniku pa se lahko po večkratnih kršitvah zakleni uporabniški račun.",
                                      ),
                                      Text(
                                        "Vaše trenutno uporabniško ime je: ${controller.user.value.name}",
                                      ),
                                      TextField(
                                        controller:
                                            controller.nameController.value,
                                      )
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text("Prekliči"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await controller.changeName();
                                      Get.back();
                                    },
                                    child: const Text("Spremeni"),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text("Sprememba imena"),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(controller.user.value.email),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.defaultDialog(
                              title: "Zamenjava elektronskega naslova",
                              content: const Text(
                                "Zaradi možne zlorabe ne ponujamo menjave elektronskega naslova direktno prek uporabniškega vmesnika. Kontaktirajte razvijalca na info@palcka.si ali na Discordu (@mytja).",
                              ),
                            );
                          },
                          child: const Text("Sprememba elektronskega naslova"),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                const Text("Število odigranih iger: ",
                    style: TextStyle(fontSize: 20)),
                Text(
                  controller.user.value.playedGames.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text("Uporabniški profil registriran: ",
                    style: TextStyle(fontSize: 20)),
                Text(
                  controller.user.value.registeredOn,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text("Vloga v sistemu: ", style: TextStyle(fontSize: 20)),
                Text(
                  controller.user.value.role,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: ElevatedButton(
                onPressed: () {
                  controller.nameController.value.text =
                      controller.user.value.name;
                  Get.dialog(
                    AlertDialog(
                      scrollable: true,
                      title: const Text("Sprememba gesla"),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Izberite si dobro geslo. Program vas bo zaradi varnosti izpisal/odjavil po uspešni spremembi gesla.",
                          ),
                          const Text(
                            "V primeru, da se ne zgodi nič po kliku na Spremeni, ste se mogoče zatipkali pri novem ali starem geslu..",
                          ),
                          TextField(
                            decoration:
                                const InputDecoration(hintText: 'Staro geslo'),
                            obscureText: true,
                            controller: controller.oldPasswordController.value,
                          ),
                          TextField(
                            decoration:
                                const InputDecoration(hintText: 'Novo geslo'),
                            obscureText: true,
                            controller: controller.newPasswordController.value,
                          ),
                          TextField(
                            decoration: const InputDecoration(
                                hintText: 'Ponovite novo geslo'),
                            obscureText: true,
                            controller:
                                controller.newPasswordControllerValidate.value,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text("Prekliči"),
                        ),
                        TextButton(
                          onPressed: () async {
                            await controller.changePassword();
                          },
                          child: const Text("Spremeni"),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text("Sprememba gesla"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
