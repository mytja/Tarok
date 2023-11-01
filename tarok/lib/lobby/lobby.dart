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

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:stockskis/stockskis.dart' hide Card, debugPrint;
import 'package:tarok/constants.dart';
import 'package:tarok/lobby/lobby_controller.dart';
import 'package:tarok/replay.dart';
import 'package:tarok/ui/main_page.dart';

Future<void> preloadCards(BuildContext context) async {
  for (int i = 0; i < CARDS.length; i++) {
    LocalCard card = CARDS[i];
    await precacheImage(
      AssetImage("assets/tarok${card.asset}.webp"),
      context,
    );
  }
}

class Lobby extends StatelessWidget {
  const Lobby({super.key});

  @override
  Widget build(BuildContext context) {
    LobbyController controller = Get.put(LobbyController());

    return PalckaHome(
      floatingActionButton: FloatingActionButton(
        onPressed: controller.dialog,
        tooltip: 'Ustvari novo igro',
        child: const Icon(Icons.add),
      ),
      child: Obx(
        () => ListView(
          shrinkWrap: true,
          children: <Widget>[
            const Center(
              child: Text(
                'Dobrodošli v Palčka tarok programu.',
                style: TextStyle(fontSize: 40),
              ),
            ),
            if (controller.guest.value)
              const Center(
                child: Text(
                  "Uporabljate gostujoči dostop",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            const Center(
              child: Text(
                "Igre na voljo",
                style: TextStyle(fontSize: 30),
              ),
            ),
            if (!controller.guest.value)
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("S pravimi igralci"),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton.icon(
                  onPressed: () => controller.quickGameFind(3, "normal"),
                  label: const Text(
                    "V tri",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  icon: const Icon(Icons.face),
                ),
                ElevatedButton.icon(
                  onPressed: () => controller.quickGameFind(4, "normal"),
                  label: const Text(
                    "V štiri",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  icon: const Icon(Icons.face),
                ),
              ]),
            if (!controller.guest.value)
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("Klepetalnica"),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton.icon(
                  onPressed: () => controller.quickGameFind(3, "klepetalnica"),
                  label: const Text(
                    "V tri",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  icon: const Icon(Icons.face),
                ),
                ElevatedButton.icon(
                  onPressed: () => controller.quickGameFind(4, "klepetalnica"),
                  label: const Text(
                    "V štiri",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  icon: const Icon(Icons.face),
                ),
              ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("Z računalniškimi igralci"),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton.icon(
                onPressed: () => controller.botGame(3),
                label: const Text(
                  "V tri",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                icon: const Icon(Icons.smart_toy),
              ),
              ElevatedButton.icon(
                onPressed: () => controller.botGame(4),
                label: const Text(
                  "V štiri",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                icon: const Icon(Icons.smart_toy),
              ),
            ]),
            const SizedBox(
              height: 10,
            ),
            if (controller.isAdmin.value)
              Center(
                child: ElevatedButton(
                  onPressed: () => Get.defaultDialog(
                    title: 'Administratorska plošča',
                    content: SingleChildScrollView(
                      child: Column(children: [
                        const Text(
                          'Na tej plošči lahko kot administrator urejate razne nastavitve tarok programa Palčka',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        FutureBuilder(
                          future: controller.getRegistrationCodes(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return DataTable(
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Registracijska koda',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Izbriši',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: [
                                  ...controller.codes.map(
                                    (code) => DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text(code["Code"])),
                                        DataCell(
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () async {
                                              await dio.delete(
                                                "$BACKEND_URL/admin/reg_code",
                                                data: FormData.fromMap(
                                                  {
                                                    "code": code["Code"],
                                                  },
                                                ),
                                                options: Options(
                                                  headers: {
                                                    "X-Login-Token":
                                                        await storage.read(
                                                            key: "token")
                                                  },
                                                ),
                                              );
                                              controller.getRegistrationCodes();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                        Row(children: [
                          Expanded(
                            child: TextField(
                              controller: controller.controller.value,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Nova registracijska koda',
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.save),
                            onPressed: () async {
                              await dio.post(
                                "$BACKEND_URL/admin/reg_code",
                                data: FormData.fromMap(
                                  {
                                    "code": controller.controller.value.text,
                                  },
                                ),
                                options: Options(
                                  headers: {
                                    "X-Login-Token":
                                        await storage.read(key: "token")
                                  },
                                ),
                              );
                              controller.getRegistrationCodes();
                            },
                          ),
                        ]),
                      ]),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                  child: const Text("Administratorska plošča"),
                ),
              ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () => Get.defaultDialog(
                  title: 'Posnetek igre',
                  content: SingleChildScrollView(
                    child: Obx(
                      () => Column(children: [
                        const Text(
                          'Tukaj lahko vpišete URL do posnetka igre',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(children: [
                          Expanded(
                            child: TextField(
                              controller: controller.replayController.value,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Povezava do posnetka igre',
                              ),
                            ),
                          ),
                        ]),
                      ]),
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('Prekliči'),
                    ),
                    TextButton(
                      onPressed: () {
                        joinReplay(controller.replayController.value.text);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
                child: const Text("Posnetek igre"),
              ),
            ),

            const SizedBox(
              height: 10,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return AlertDialog(
                          title: const Text('Prilagodi računalniške igralce'),
                          content: SingleChildScrollView(
                            child: Obx(
                              () => Column(children: [
                                const Text(
                                  'Tukaj lahko urejate, kakšne bote želite videti v svojih igrah. Program bo ob vstopu v igro avtomatično izbral naključne igralce iz tega seznama, če jih je vsaj toliko, kot zahteva ta igra.',
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                FutureBuilder(
                                  future: controller.getBots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (controller.botNames.isNotEmpty) {
                                      return DataTable(
                                        columns: const <DataColumn>[
                                          DataColumn(
                                            label: Expanded(
                                              child: Text(
                                                'Bot',
                                                style: TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Expanded(
                                              child: Text(
                                                'Ime',
                                                style: TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Expanded(
                                              child: Text(
                                                'Izbriši',
                                                style: TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                          ),
                                        ],
                                        rows: [
                                          ...controller.botNames.map(
                                            (e) => DataRow(
                                              cells: <DataCell>[
                                                DataCell(Text(e["type"])),
                                                DataCell(Text(e["name"])),
                                                DataCell(
                                                  IconButton(
                                                    icon: const Icon(
                                                        Icons.delete),
                                                    onPressed: () async {
                                                      await controller
                                                          .deleteBot(
                                                        e["name"],
                                                        e["type"],
                                                      );
                                                      await controller
                                                          .getBots();
                                                      setState(() {});
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    return const SizedBox();
                                  },
                                ),
                                Row(children: [
                                  Expanded(
                                    child: TextField(
                                      controller:
                                          controller.playerNameController.value,
                                      decoration: const InputDecoration(
                                        border: UnderlineInputBorder(),
                                        labelText: 'Ime igralca',
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.replay_outlined),
                                    onPressed: () async {
                                      String botName =
                                          controller.randomBotName();
                                      controller.playerNameController.value
                                          .text = botName;
                                      setState(() {});
                                    },
                                  ),
                                ]),
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: SegmentedButton<Map>(
                                    segments: <ButtonSegment<Map>>[
                                      ...BOTS.map(
                                        (e) => ButtonSegment<Map>(
                                          value: e,
                                          label: Text(e["name"].toString()),
                                        ),
                                      )
                                    ],
                                    selected: <Map>{controller.dropdownValue},
                                    onSelectionChanged:
                                        (Set<Map> newSelection) {
                                      controller.dropdownValue =
                                          newSelection.first;
                                      setState(() {});
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    await controller.newBot(
                                      controller
                                          .playerNameController.value.text,
                                      controller.dropdownValue["type"]
                                          as String,
                                    );
                                    setState(() {});
                                  },
                                  label: const Text(
                                    "Dodaj bota na seznam",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  icon: const Icon(Icons.add),
                                ),
                              ]),
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Končaj z urejanjem'),
                            ),
                          ],
                        );
                      });
                    }),
                child: const Text("Prilagodi računalniške igralce"),
              ),
            ),

            // PRIORITY QUEUE
            GridView.count(
              childAspectRatio: 0.75,
              crossAxisCount: 4,
              physics:
                  const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
              shrinkWrap: true,
              children: [
                ...controller.priorityQueue.map(
                  (e) => GestureDetector(
                    onTap: () {
                      debugPrint("Priority");
                      Get.toNamed("/game", parameters: {
                        "playing": e.requiredPlayers.toString(),
                        "gameId": e.id,
                        "bots": "false",
                      });
                    },
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: Text(
                                'Igra ${e.totalTime}+${e.additionalTime} ${e.mondfangRadelci || e.skisfang || e.napovedanMondfang ? "+ modifikacije" : ""} ${e.type == "klepetalnica" ? "(klepetalnica)" : ""}'),
                          ),
                          if (e.mondfangRadelci)
                            const Center(
                              child: Text('Mondfang radelci'),
                            ),
                          if (e.skisfang)
                            const Center(
                              child: Text('Škisfang'),
                            ),
                          if (e.napovedanMondfang)
                            const Center(
                              child: Text('Napovedan mondfang'),
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                          ...e.user.map(
                            (k) => SizedBox(
                              height: 40,
                              child: Text(
                                k.name,
                                style: const TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: e.requiredPlayers - e.user.length,
                            itemBuilder: (BuildContext context, int index) {
                              return const Center(
                                child: SizedBox(
                                  height: 40,
                                  child: Text(
                                    "Pridružite se igri",
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // QUEUE
            GridView.count(
              crossAxisCount: 4,
              physics:
                  const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
              shrinkWrap: true,
              children: [
                ...controller.queue.map(
                  (e) => GestureDetector(
                    onTap: () {
                      Get.toNamed("/game", parameters: {
                        "playing": e.requiredPlayers.toString(),
                        "gameId": e.id,
                        "bots": "false",
                      });
                    },
                    child: Card(
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                                'Igra ${e.totalTime}+${e.additionalTime} ${e.mondfangRadelci || e.skisfang || e.napovedanMondfang ? "+ modifikacije" : ""} ${e.type == "klepetalnica" ? "(klepetalnica)" : ""}'),
                          ),
                          if (e.mondfangRadelci)
                            const Center(
                              child: Text('Mondfang radelci'),
                            ),
                          if (e.skisfang)
                            const Center(
                              child: Text('Škisfang'),
                            ),
                          if (e.napovedanMondfang)
                            const Center(
                              child: Text('Napovedan mondfang'),
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                          ...e.user.map(
                            (k) => SizedBox(
                              height: 40,
                              child: Text(
                                k.name,
                                style: const TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ),
                          ...List.generate(
                            e.requiredPlayers - e.user.length,
                            (index) => const SizedBox(
                              height: 40,
                              child: Text(
                                "Pridružite se igri",
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
