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
                child: Text(
                  "palcka".tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: Text("home".tr),
                onTap: () async {
                  await Get.toNamed("/");
                },
              ),
              if (!controller.guest.value)
                ListTile(
                  leading: const Icon(Icons.people),
                  title: Text("friends".tr),
                  onTap: () async {
                    await Get.toNamed("/friends");
                  },
                ),
              if (!controller.guest.value)
                ListTile(
                  leading: const Icon(Icons.replay),
                  title: Text("replays".tr),
                  onTap: () async {
                    await Get.toNamed("/replays");
                  },
                ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.discord),
                title: Text("discord".tr),
                onTap: () async {
                  await launchUrl(Uri.parse("https://discord.gg/fzeN4Cnbr3"));
                },
              ),
              if (controller.isAdmin.value) const Divider(),
              if (controller.isAdmin.value)
                ListTile(
                  leading: const Icon(Icons.account_box),
                  title: Text("users".tr),
                  onTap: () async {
                    await Get.toNamed("/users");
                  },
                ),
              /*if (controller.isAdmin.value)
                ListTile(
                  leading: const Icon(Icons.admin_panel_settings),
                  title: const Text('Administratorske nastavitve'),
                  onTap: () async {
                    await Get.toNamed("/admin");
                  },
                ),*/
              const Divider(),
              if (!controller.guest.value)
                ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: Text("profile".tr),
                  onTap: () async {
                    await Get.toNamed("/profile");
                  },
                ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text("logout".tr),
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
        title: Text("palcka".tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Get.toNamed("/settings");
            },
          ),
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () async {
              await Get.toNamed("/about");
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
