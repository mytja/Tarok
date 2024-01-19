import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarok/tms/tms_controller.dart';
import 'package:tarok/tms/tournament_actions.dart';

class TournamentCard extends StatelessWidget {
  const TournamentCard({super.key, required this.e});

  final Map e;

  @override
  Widget build(BuildContext context) {
    TMSController controller = Get.put(TMSController());

    final fullWidth = MediaQuery.of(context).size.width;
    bool smallDevice = fullWidth < 750;

    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${e["name"]} (Div.${e["division"]})",
                    style: const TextStyle(fontSize: 30),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  if (!smallDevice)
                    Text(
                      DateTime.fromMillisecondsSinceEpoch(e["start_time"])
                          .toIso8601String(),
                      style: const TextStyle(fontSize: 18),
                    ),
                  const Spacer(),
                  if (!smallDevice) TournamentActions(e: e),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              if (smallDevice)
                Text(
                  DateTime.fromMillisecondsSinceEpoch(e["start_time"])
                      .toIso8601String(),
                  style: const TextStyle(fontSize: 18),
                ),
              const SizedBox(
                height: 20,
              ),
              if (smallDevice) TournamentActions(e: e),
              const SizedBox(
                height: 20,
              ),
              Flex(
                direction: !smallDevice ? Axis.horizontal : Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.isAdmin.value)
                    ElevatedButton(
                      onPressed: () async {
                        await Get.toNamed(
                          "/tournament/${e["id"]}/participants",
                        );
                      },
                      child: Text("show_participants".tr),
                    ),
                  if (controller.isAdmin.value)
                    ElevatedButton(
                      onPressed: () async {
                        await Get.toNamed("/tournament/${e["id"]}/rounds");
                      },
                      child: Text("edit_rounds".tr),
                    ),
                  if (controller.isAdmin.value)
                    ElevatedButton(
                      onPressed: () async {
                        controller.testers.value = e["testers"];
                        controller.testerDialog(e["id"]);
                      },
                      child: Text("edit_testers".tr),
                    ),
                  ElevatedButton(
                    onPressed: () async {
                      await Get.toNamed("/tournament/${e["id"]}/stats");
                    },
                    child: Text("tournament_statistics".tr),
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}
