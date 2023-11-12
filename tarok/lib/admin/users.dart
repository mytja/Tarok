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
import 'package:tarok/admin/admin_controller.dart';
import 'package:tarok/ui/main_page.dart';

class Users extends StatelessWidget {
  const Users({super.key});

  @override
  Widget build(BuildContext context) {
    AdminController controller = Get.put(AdminController());

    return PalckaHome(
      child: Obx(
        () => ListView(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: ElevatedButton(
                onPressed: () async {
                  await controller.getUsers();
                },
                child: Text("refresh_data".tr),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: <DataColumn>[
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          "user_id".tr,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          "name".tr,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          "email".tr,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          "played_games".tr,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          "role".tr,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          "account_disabled".tr,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          "verified_email".tr,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          "registered_on".tr,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ],
                  rows: <DataRow>[
                    ...controller.users.map(
                      (m) => DataRow(
                        cells: <DataCell>[
                          DataCell(Text(m.userId)),
                          DataCell(
                            Row(
                              children: [
                                Text(m.name),
                                const SizedBox(
                                  width: 20,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    controller.controller.value.text = m.name;
                                    Get.dialog(
                                      AlertDialog(
                                          title: Text("change_user_name".tr),
                                          content: IntrinsicHeight(
                                            child: Column(
                                              children: [
                                                Text("user_current_name"
                                                    .trParams(
                                                        {"name": m.name})),
                                                TextField(
                                                  controller: controller
                                                      .controller.value,
                                                )
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () async {
                                                Get.back();
                                              },
                                              child: Text("cancel".tr),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                await controller
                                                    .changeName(m.userId);
                                                Get.back();
                                              },
                                              child: Text("change".tr),
                                            ),
                                          ]),
                                    );
                                  },
                                  child: Text("change_user_name".tr),
                                ),
                              ],
                            ),
                          ),
                          DataCell(Text(m.email)),
                          DataCell(Text(m.playedGames.toString())),
                          DataCell(
                            Row(
                              children: [
                                Text(m.role),
                                const SizedBox(
                                  width: 20,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await controller
                                        .promoteDemoteUser(m.userId);
                                  },
                                  child: m.role == "admin"
                                      ? Text("admin_to_user".tr)
                                      : Text("user_to_admin".tr),
                                ),
                              ],
                            ),
                          ),
                          DataCell(
                            Switch(
                              onChanged: (value) async {
                                m.disabled.value = value;
                                await controller.disableAccount(m.userId);
                              },
                              value: m.disabled.value,
                            ),
                          ),
                          DataCell(
                            Switch(
                              onChanged: (value) async {
                                m.emailVerified.value = value;
                                await controller.validateEmailAccount(m.userId);
                              },
                              value: m.emailVerified.value,
                            ),
                          ),
                          DataCell(Text(m.registeredOn)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
