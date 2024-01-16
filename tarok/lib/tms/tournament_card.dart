import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarok/tms/tms_controller.dart';

class TournamentCard extends StatelessWidget {
  const TournamentCard({super.key, required this.e});

  final Map e;

  @override
  Widget build(BuildContext context) {
    TMSController controller = Get.put(TMSController());

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
                  Text(
                    DateTime.fromMillisecondsSinceEpoch(e["start_time"])
                        .toIso8601String(),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Spacer(),
                  if (controller.isAdmin.value)
                    IconButton(
                      onPressed: () async {
                        controller.nameController.value.text = e["name"];
                        controller.division.value =
                            (e["division"] as int).toDouble();
                        controller.tournamentTime.value =
                            DateTime.fromMillisecondsSinceEpoch(
                                e["start_time"]);
                        controller.newTournamentDialog(
                          editId: e["id"],
                          private: e["private"],
                          rated: e["rated"],
                          authors: e["created_by"],
                        );
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  if (controller.isAdmin.value)
                    IconButton(
                      onPressed: () async {
                        controller.nameController.value.text = e["name"];
                        controller.division.value =
                            (e["division"] as int).toDouble();
                        controller.tournamentTime.value =
                            DateTime.fromMillisecondsSinceEpoch(
                                e["start_time"]);
                        await controller.updateTournament(
                          e["id"],
                          e["private"],
                          !e["rated"],
                          e["created_by"],
                        );
                      },
                      icon: e["rated"]
                          ? const Icon(Icons.trending_up)
                          : const Icon(Icons.trending_flat),
                    ),
                  if (controller.isAdmin.value)
                    IconButton(
                      onPressed: () async {
                        await controller.recalculateRating(e["id"]);
                      },
                      icon: const Icon(Icons.refresh),
                    ),
                  if (controller.isAdmin.value)
                    IconButton(
                      onPressed: () async {
                        controller.nameController.value.text = e["name"];
                        controller.division.value =
                            (e["division"] as int).toDouble();
                        controller.tournamentTime.value =
                            DateTime.fromMillisecondsSinceEpoch(
                                e["start_time"]);
                        await controller.updateTournament(
                          e["id"],
                          !e["private"],
                          e["rated"],
                          e["created_by"],
                        );
                      },
                      icon: e["private"]
                          ? const Icon(Icons.lock)
                          : const Icon(Icons.lock_open),
                    ),
                  if (controller.isAdmin.value)
                    IconButton(
                      onPressed: () async {
                        await controller.deleteTournament(e["id"]);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
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
