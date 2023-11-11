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
                child: const Text("Osveži podatke"),
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
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Uporabniški ID',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Ime',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Elektronski naslov',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Odigranih iger',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Rola',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Onemogočen račun',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Preverjen elektronski naslov',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Registriran dne',
                          style: TextStyle(fontStyle: FontStyle.italic),
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
                                          title: const Text(
                                              "Sprememba uporabnikovega imena"),
                                          content: IntrinsicHeight(
                                            child: Column(
                                              children: [
                                                Text(
                                                    "Uporabnikovo trenutno ime je ${m.name}."),
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
                                              child: const Text("Prekliči"),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                await controller
                                                    .changeName(m.userId);
                                                Get.back();
                                              },
                                              child: const Text("Spremeni"),
                                            ),
                                          ]),
                                    );
                                  },
                                  child: const Text("Spremeni ime"),
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
                                      ? const Text(
                                          "Pretvori administratorja v uporabnika")
                                      : const Text(
                                          "Pretvori uporabnika v administratorja"),
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
