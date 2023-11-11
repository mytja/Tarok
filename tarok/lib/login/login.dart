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

import 'dart:io';

import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' hide FormData;
import 'package:tarok/constants.dart';
import 'package:tarok/login/login_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.put(LoginController());

    return Scaffold(
      appBar: !(Platform.isAndroid || Platform.isIOS || isWebMobile)
          ? AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text("Palčka"),
            )
          : null,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20.0),
          children: [
            const Text(
              "Prijava",
              style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 350,
              child: TextField(
                controller: controller.email.value,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Elektronski naslov',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 350,
              child: TextField(
                controller: controller.password1.value,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Geslo',
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: controller.login,
              child: const Text("Prijava", style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Get.toNamed("/registration");
              },
              child: const Text("Registracija", style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            GridView.count(
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: (MediaQuery.of(context).size.width / 500).round(),
              childAspectRatio: 11,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    await storage.write(key: "token", value: "a");
                    Get.toNamed("/");
                  },
                  child: const Text("Gostujoči dostop",
                      style: TextStyle(fontSize: 20)),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await launchUrl(Uri.parse("https://discord.gg/fzeN4Cnbr3"));
                  },
                  icon: const FaIcon(FontAwesomeIcons.discord),
                  label: const Text(
                    "Uradni Discord strežnik",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await launchUrl(Uri.parse(
                        "https://nightly.link/mytja/Tarok/workflows/build/main/windows_app.zip?h=8b6e64c52f49d4292ad7ec115786aa6c367c0f65"));
                  },
                  label: const Text(
                    "Windows",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  icon: const FaIcon(FontAwesomeIcons.windows),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await launchUrl(Uri.parse(
                        "https://nightly.link/mytja/Tarok/workflows/build/main/linux_app.zip?h=8b6e64c52f49d4292ad7ec115786aa6c367c0f65"));
                  },
                  label: const Text(
                    "Linux",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  icon: const FaIcon(FontAwesomeIcons.linux),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await launchUrl(Uri.parse(
                        "https://nightly.link/mytja/Tarok/workflows/build/main/android_app.zip?h=8b6e64c52f49d4292ad7ec115786aa6c367c0f65"));
                  },
                  label: const Text(
                    "Android (APK)",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  icon: const FaIcon(FontAwesomeIcons.android),
                ),
                ElevatedButton.icon(
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('F-Droid'),
                      content: const Text(
                          'F-Droid je alternativna trgovina za Android naprave. Ta trgovina omogoča vsem odprtokodnim aplikacijam, da preko tega vira uporabnikom dostavljajo aplikacije in posodobitve zanje. Ker ta aplikacija še ni odprtokodna, še ni na voljo za prenos v tej trgovini. Seveda pa bo aplikacija popolnoma brezplačna za prenesti, kot tudi za igrati :).'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  ),
                  label: const Text(
                    "Android (F-Droid)",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  icon: SvgPicture.asset(
                    "assets/icons/fdroid-logo.svg",
                    height: 30,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await launchUrl(Uri.parse(
                        "https://play.google.com/store/apps/details?id=si.palcka.tarok"));
                  },
                  label: const Text(
                    "Android (Google Play)",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  icon: const FaIcon(FontAwesomeIcons.googlePlay),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await launchUrl(
                        Uri.parse("https://github.com/mytja/Tarok"));
                  },
                  label: const Text(
                    "Koda",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  icon: const FaIcon(FontAwesomeIcons.github),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
