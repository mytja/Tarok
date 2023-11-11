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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tarok/constants.dart';
import 'package:tarok/lobby/lobby_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class PalckaHome extends StatelessWidget {
  const PalckaHome({
    super.key,
    required this.child,
    this.floatingActionButton,
  });

  final Widget child;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    LobbyController controller = Get.put(LobbyController());
    return Scaffold(
      drawer: Drawer(
        child: Obx(
          () => ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: const Text(
                  'Palčka.si tarok program',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Domov'),
                onTap: () {
                  Get.toNamed("/");
                },
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Prijatelji'),
                onTap: () {
                  Get.toNamed("/friends");
                },
              ),
              ListTile(
                leading: const Icon(Icons.replay),
                title: const Text('Posnetki iger'),
                onTap: () {
                  Get.toNamed("/replays");
                },
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.discord),
                title: const Text('Discord strežnik'),
                onTap: () async {
                  await launchUrl(Uri.parse("https://discord.gg/fzeN4Cnbr3"));
                },
              ),
              if (controller.isAdmin.value) const Divider(),
              if (controller.isAdmin.value)
                ListTile(
                  leading: const Icon(Icons.account_box),
                  title: const Text('Uporabniki'),
                  onTap: () {
                    Get.toNamed("/users");
                  },
                ),
              /*if (controller.isAdmin.value)
                ListTile(
                  leading: const Icon(Icons.admin_panel_settings),
                  title: const Text('Administratorske nastavitve'),
                  onTap: () {
                    Get.toNamed("/admin");
                  },
                ),*/
              const Divider(),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('Uporabniški profil'),
                onTap: () async {
                  Get.toNamed("/profile");
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Odjava'),
                onTap: () async {
                  await logout();
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Palčka"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              Get.toNamed("/settings");
            },
          ),
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () async {
              Get.toNamed("/about");
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await logout();
            },
          ),
        ],
      ),
      body: Center(child: child),
      floatingActionButton: floatingActionButton,
    );
  }
}
