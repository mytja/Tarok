import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tarok/constants.dart';
import 'package:tarok/lobby/lobby_controller.dart';
import 'package:tarok/lobby/tournament_invite.dart';
import 'package:tarok/replay.dart';
import 'package:url_launcher/url_launcher.dart';

class LobbyUI extends StatelessWidget {
  const LobbyUI({super.key});

  @override
  Widget build(BuildContext context) {
    LobbyController controller = Get.put(LobbyController());

    return Expanded(
      child: Obx(
        () => ListView(
          children: <Widget>[
            const TournamentInvite(),
            Center(
              child: Column(
                children: [
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
                    Center(
                      child: Text("with_players".tr),
                    ),
                  if (!controller.guest.value)
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      ElevatedButton.icon(
                        onPressed: () => controller.quickGameFind(3, "normal"),
                        label: Text(
                          "in_three".tr,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        icon: const Icon(Icons.face),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => controller.quickGameFind(4, "normal"),
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
                    Center(
                      child: Text("chatroom".tr),
                    ),
                  if (!controller.guest.value)
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                  Center(
                    child: Text("with_bots".tr),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                                          if (controller.botNames.isNotEmpty) {
                                            return DataTable(
                                              columns: <DataColumn>[
                                                DataColumn(
                                                  label: Expanded(
                                                    child: Text(
                                                      "bot".tr,
                                                      style: const TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic),
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Expanded(
                                                    child: Text(
                                                      "name".tr,
                                                      style: const TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic),
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Expanded(
                                                    child: Text(
                                                      "remove".tr,
                                                      style: const TextStyle(
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
                                          icon:
                                              const Icon(Icons.replay_outlined),
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
                                      DropdownButton<String>(
                                        value: controller.dropdownValue,
                                        icon: const Icon(Icons.arrow_downward),
                                        elevation: 16,
                                        onChanged: (String? value) {
                                          // This is called when the user selects an item.
                                          setState(() {
                                            controller.dropdownValue = value!;
                                          });
                                        },
                                        items: BOTS
                                            .map<DropdownMenuItem<String>>(
                                                (dynamic value) {
                                          return DropdownMenuItem<String>(
                                            value: value["type"],
                                            child: Text(value["name"]),
                                          );
                                        }).toList(),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          await controller.newBot(
                                            controller.playerNameController
                                                .value.text,
                                            controller.dropdownValue,
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
                    crossAxisCount: MediaQuery.of(context).size.width <
                            MediaQuery.of(context).size.height
                        ? 1
                        : 4,
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
                                  itemCount: e.requiredPlayers - e.user.length,
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
                    crossAxisCount: MediaQuery.of(context).size.width <
                            MediaQuery.of(context).size.height
                        ? 1
                        : 4,
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
                                  itemCount: e.requiredPlayers - e.user.length,
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
          ],
        ),
      ),
    );
  }
}
