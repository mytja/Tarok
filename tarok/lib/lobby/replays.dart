import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:tarok/lobby/lobby_controller.dart';
import 'package:tarok/replay.dart';
import 'package:tarok/ui/main_page.dart';

class Replays extends StatelessWidget {
  const Replays({super.key});

  @override
  Widget build(BuildContext context) {
    LobbyController controller = Get.put(LobbyController());

    return PalckaHome(
      child: Obx(
        () => ListView(
          padding:
              const EdgeInsets.only(left: 50, right: 50, top: 10, bottom: 10),
          children: <Widget>[
            const Center(
              child: Text(
                'Posnetki iger',
                style: TextStyle(fontSize: 40),
              ),
            ),
            ...controller.replays.map(
              (e) => Row(
                children: [
                  Text(e.gameId),
                  const Spacer(),
                  Text(e.createdAt),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      await joinReplay(e.url);
                    },
                    child: const Text("Oglej si posnetek"),
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
