import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:get/get.dart' hide FormData;
import 'package:tarok/constants.dart';
import 'package:tarok/game/game_controller.dart';
import 'package:tarok/lobby/lobby_controller.dart';
import 'package:tarok/ui/main_page.dart';

class Friends extends StatelessWidget {
  const Friends({super.key, this.gameId = ""});

  final String gameId;

  @override
  Widget build(BuildContext context) {
    LobbyController controller = Get.put(LobbyController());

    List<String> invited = [];

    Widget mainContent = Obx(
      () => ListView(
        shrinkWrap: true,
        children: <Widget>[
          const Center(
            child: Text(
              'Moji prijatelji',
              style: TextStyle(fontSize: 40),
            ),
          ),
          const Center(
            child: Text(
              'Prihodne prošnje za prijateljstvo',
              style: TextStyle(fontSize: 20),
            ),
          ),
          ...controller.prihodne.map(
            (e) => Container(
              margin: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 100,
                  ),
                  Initicon(
                    text: e.name,
                    elevation: 4,
                    size: 70,
                    backgroundColor:
                        HSLColor.fromAHSL(1, hashCode(e.name) % 360, 1, 0.6)
                            .toColor(),
                    borderRadius: BorderRadius.zero,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.name,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          )),
                      Text(e.email),
                    ],
                  ),
                  const Spacer(),
                  if (gameId == "")
                    IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () async {
                        await controller.friendRequest(e.relationshipId, true);
                      },
                    ),
                  if (gameId == "")
                    IconButton(
                      icon: const Icon(Icons.block),
                      onPressed: () async {
                        await controller.friendRequest(e.relationshipId, false);
                      },
                    ),
                  const SizedBox(
                    width: 100,
                  ),
                ],
              ),
            ),
          ),
          const Center(
            child: Text(
              'Odhodne prošnje za prijateljstvo',
              style: TextStyle(fontSize: 20),
            ),
          ),
          ...controller.odhodne.map(
            (e) => Container(
              margin: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 100,
                  ),
                  Initicon(
                    text: e.name,
                    elevation: 4,
                    size: 70,
                    backgroundColor:
                        HSLColor.fromAHSL(1, hashCode(e.name) % 360, 1, 0.6)
                            .toColor(),
                    borderRadius: BorderRadius.zero,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.name,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          )),
                      Text(e.email),
                    ],
                  ),
                  const Spacer(),
                  if (gameId == "")
                    IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () async {
                        await controller.removeRelation(e.relationshipId);
                      },
                    ),
                  const SizedBox(
                    width: 100,
                  ),
                ],
              ),
            ),
          ),
          const Center(
            child: Text(
              'Prijatelji',
              style: TextStyle(fontSize: 20),
            ),
          ),
          ...controller.prijatelji.map(
            (e) => Container(
              margin: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 100,
                  ),
                  SizedBox(
                    height: 70,
                    width: 70,
                    child: Stack(children: [
                      Initicon(
                        text: e.name,
                        elevation: 4,
                        size: 70,
                        backgroundColor:
                            HSLColor.fromAHSL(1, hashCode(e.name) % 360, 1, 0.6)
                                .toColor(),
                        borderRadius: BorderRadius.zero,
                      ),
                      if (e.status == 0)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            color: Colors.grey,
                            height: 15,
                            width: 15,
                          ),
                        ),
                      if (e.status == 1)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            color: Colors.greenAccent.shade700,
                            height: 15,
                            width: 15,
                          ),
                        ),
                      if (e.status == 2)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            color: Colors.red,
                            height: 15,
                            width: 15,
                          ),
                        ),
                    ]),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.name,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          )),
                      Text(e.email),
                    ],
                  ),
                  const Spacer(),
                  if (gameId == "")
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () async {
                        await controller.removeRelation(e.relationshipId);
                      },
                    ),
                  if (gameId != "" && !invited.contains(e.id))
                    ElevatedButton(
                      child: const Text("Povabi"),
                      onPressed: () async {
                        GameController c = Get.put(GameController());
                        await c.invitePlayer(e.id);
                        invited.add(e.id);
                        controller.prijatelji.refresh();
                      },
                    ),
                  if (gameId != "" && invited.contains(e.id))
                    const Icon(Icons.check),
                  const SizedBox(
                    width: 100,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (gameId != "") return mainContent;

    return PalckaHome(
      floatingActionButton: FloatingActionButton(
        onPressed: controller.friendAddDialog,
        tooltip: 'Dodaj prijatelja',
        child: const Icon(Icons.add),
      ),
      child: mainContent,
    );
  }
}
