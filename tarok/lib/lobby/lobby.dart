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
import 'package:get/get.dart' hide FormData;
import 'package:stockskis/stockskis.dart' hide Card, debugPrint;
import 'package:tarok/constants.dart';
import 'package:tarok/lobby/lobby_controller.dart';
import 'package:tarok/replay.dart';
import 'package:tarok/ui/main_page.dart';
import 'package:url_launcher/url_launcher.dart';

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
        tooltip: "new_game".tr,
        child: const Icon(Icons.add),
      ),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Center(
                      child: Text(
                        "welcome_message".tr,
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                    if (controller.guest.value)
                      Center(
                        child: Text(
                          "using_guest_access".tr,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    Center(
                      child: Text(
                        "games_available".tr,
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                    if (!controller.guest.value)
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("with_players".tr),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  controller.quickGameFind(3, "normal"),
                              label: Text(
                                "in_three".tr,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              icon: const Icon(Icons.face),
                            ),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  controller.quickGameFind(4, "normal"),
                              label: Text(
                                "in_four".tr,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              icon: const Icon(Icons.face),
                            ),
                          ]),
                    if (!controller.guest.value)
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("chatroom".tr),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  controller.quickGameFind(3, "klepetalnica"),
                              label: Text(
                                "in_three".tr,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              icon: const Icon(Icons.face),
                            ),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  controller.quickGameFind(4, "klepetalnica"),
                              label: Text(
                                "in_four".tr,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              icon: const Icon(Icons.face),
                            ),
                          ]),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text("with_bots".tr),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton.icon(
                        onPressed: () => controller.botGame(3),
                        label: Text(
                          "in_three".tr,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        icon: const Icon(Icons.smart_toy),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => controller.botGame(4),
                        label: Text(
                          "in_four".tr,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        icon: const Icon(Icons.smart_toy),
                      ),
                    ]),
                    if (!controller.guest.value)
                      const SizedBox(
                        height: 10,
                      ),
                    if (!controller.guest.value)
                      Center(
                        child: ElevatedButton(
                          onPressed: () => Get.defaultDialog(
                            title: "replay".tr,
                            content: SingleChildScrollView(
                              child: Obx(
                                () => Column(children: [
                                  Text("replay_desc".tr),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(children: [
                                    Expanded(
                                      child: TextField(
                                        controller:
                                            controller.replayController.value,
                                        decoration: InputDecoration(
                                          border: const UnderlineInputBorder(),
                                          labelText: "replay_link".tr,
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
                                child: Text("cancel".tr),
                              ),
                              TextButton(
                                onPressed: () {
                                  joinReplay(
                                      controller.replayController.value.text);
                                },
                                child: Text("ok".tr),
                              ),
                            ],
                          ),
                          child: Text("replay".tr),
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
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                return AlertDialog(
                                  title: Text("modify_bots".tr),
                                  content: SingleChildScrollView(
                                    child: Obx(
                                      () => Column(children: [
                                        Text("modify_bots_desc".tr),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        FutureBuilder(
                                          future: controller.getBots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot snapshot) {
                                            if (controller
                                                .botNames.isNotEmpty) {
                                              return DataTable(
                                                columns: <DataColumn>[
                                                  DataColumn(
                                                    label: Expanded(
                                                      child: Text(
                                                        "bot".tr,
                                                        style: const TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Expanded(
                                                      child: Text(
                                                        "name".tr,
                                                        style: const TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Expanded(
                                                      child: Text(
                                                        "remove".tr,
                                                        style: const TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                                rows: [
                                                  ...controller.botNames.map(
                                                    (e) => DataRow(
                                                      cells: <DataCell>[
                                                        DataCell(
                                                            Text(e["type"])),
                                                        DataCell(
                                                            Text(e["name"])),
                                                        DataCell(
                                                          IconButton(
                                                            icon: const Icon(
                                                                Icons.delete),
                                                            onPressed:
                                                                () async {
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
                                              controller: controller
                                                  .playerNameController.value,
                                              decoration: InputDecoration(
                                                border:
                                                    const UnderlineInputBorder(),
                                                labelText: "bot_name".tr,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                                Icons.replay_outlined),
                                            onPressed: () async {
                                              String botName =
                                                  controller.randomBotName();
                                              controller.playerNameController
                                                  .value.text = botName;
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
                                                  label: Text(
                                                      e["name"].toString()),
                                                ),
                                              )
                                            ],
                                            selected: <Map>{
                                              controller.dropdownValue
                                            },
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
                                              controller.playerNameController
                                                  .value.text,
                                              controller.dropdownValue["type"]
                                                  as String,
                                            );
                                            setState(() {});
                                          },
                                          label: Text(
                                            "add_bot".tr,
                                            style: const TextStyle(
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
                                      child: Text("finish_list_editing".tr),
                                    ),
                                  ],
                                );
                              });
                            }),
                        child: Text("customize_bots".tr),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: IntrinsicWidth(
                        child: Card(
                          child: ListTile(
                            leading: const FaIcon(FontAwesomeIcons.discord),
                            title: Text("discord".tr),
                            subtitle: Text("discord_desc".tr),
                            onTap: () async {
                              await launchUrl(
                                  Uri.parse("https://discord.gg/fzeN4Cnbr3"));
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
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
                            onTap: () async {
                              debugPrint("Priority");
                              await Get.toNamed("/game", parameters: {
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
                                      "game".trParams({
                                        "type": e.type == "klepetalnica"
                                            ? "(klepetalnica)"
                                            : ""
                                      }),
                                    ),
                                  ),
                                  if (e.mondfangRadelci)
                                    Center(
                                      child: Text("mondfang_radelci".tr),
                                    ),
                                  if (e.skisfang)
                                    Center(
                                      child: Text("skisfang".tr),
                                    ),
                                  if (e.napovedanMondfang)
                                    Center(
                                      child: Text("predicted_mondfang".tr),
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
                                    itemCount:
                                        e.requiredPlayers - e.user.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Center(
                                        child: SizedBox(
                                          height: 40,
                                          child: Text(
                                            "join_game".tr,
                                            style: const TextStyle(
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
                            onTap: () async {
                              await Get.toNamed("/game", parameters: {
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
                                      "game".trParams({
                                        "type": e.type == "klepetalnica"
                                            ? "(klepetalnica)"
                                            : ""
                                      }),
                                    ),
                                  ),
                                  if (e.mondfangRadelci)
                                    Center(
                                      child: Text("mondfang_radelci".tr),
                                    ),
                                  if (e.skisfang)
                                    Center(
                                      child: Text("skisfang".tr),
                                    ),
                                  if (e.napovedanMondfang)
                                    Center(
                                      child: Text("predicted_mondfang".tr),
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
                                    itemCount:
                                        e.requiredPlayers - e.user.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Center(
                                        child: SizedBox(
                                          height: 40,
                                          child: Text(
                                            "join_game".tr,
                                            style: const TextStyle(
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
                  ],
                ),
              ),
            ),
            if (controller.tournaments.isNotEmpty)
              Expanded(
                child: Center(
                  child: ListView(
                    children: [
                      ...controller.tournaments.map((e) => Card(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(e["created_by"].length ==
                                                  1
                                              ? "invite_tournament_singular${e['private'] ? '_private' : ''}"
                                                  .trParams({
                                                  "who":
                                                      (e["created_by"] as List)
                                                          .join(", "),
                                                })
                                              : e["created_by"].length == 2
                                                  ? "invite_tournament_dual${e['private'] ? '_private' : ''}"
                                                      .trParams({
                                                      "who": (e["created_by"]
                                                              as List)
                                                          .join(", "),
                                                    })
                                                  : "invite_tournament_plural${e['private'] ? '_private' : ''}"
                                                      .trParams({
                                                      "who": (e["created_by"]
                                                              as List)
                                                          .join(", "),
                                                    })),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "${e["name"]} (Div.${e["division"]})",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text("tournament_rated".trParams({
                                      "israted":
                                          e["rated"] ? "" : "not_space".tr,
                                    })),
                                    Row(
                                      children: [
                                        // grozote
                                        Text(
                                          "${DateTime.fromMillisecondsSinceEpoch(e["start_time"]).day}. ${DateTime.fromMillisecondsSinceEpoch(e["start_time"]).month}. ${DateTime.fromMillisecondsSinceEpoch(e["start_time"]).year} — ${DateTime.fromMillisecondsSinceEpoch(e["start_time"]).hour}.${DateTime.fromMillisecondsSinceEpoch(e["start_time"]).minute < 10 ? "0${DateTime.fromMillisecondsSinceEpoch(e["start_time"]).minute}" : DateTime.fromMillisecondsSinceEpoch(e["start_time"]).minute}",
                                        ),

                                        const Spacer(),
                                        IconButton(
                                          onPressed: () async {
                                            if (e["registered"]) {
                                              await controller
                                                  .unregisterContest(e["id"]);
                                              return;
                                            }
                                            await controller
                                                .registerContest(e["id"]);
                                          },
                                          icon: e["registered"]
                                              ? const Icon(Icons.check)
                                              : const Icon(Icons.cancel),
                                        ),
                                      ],
                                    ),
                                    if (e["private"])
                                      TextButton(
                                        onPressed: () {
                                          controller.tournamentTestingDialog(
                                              e["id"], e["division"]);
                                        },
                                        child:
                                            Text("start_tournament_testing".tr),
                                      ),
                                  ]),
                            ),
                          )),
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
