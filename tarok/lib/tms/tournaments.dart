import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarok/tms/tms_controller.dart';
import 'package:tarok/ui/main_page.dart';

class Tournaments extends StatelessWidget {
  const Tournaments({super.key});

  @override
  Widget build(BuildContext context) {
    TMSController controller = Get.put(TMSController());
    return PalckaHome(
      floatingActionButton: FloatingActionButton(
        onPressed: controller.newTournamentDialog,
        tooltip: "new_tournament".tr,
        child: const Icon(Icons.add),
      ),
      child: Obx(
        () => Container(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: <Widget>[
              Text(
                "tournaments".tr,
                style: const TextStyle(fontSize: 30),
              ),
              ...controller.tournaments.map((e) => e["start_time"] <
                      DateTime.now().millisecondsSinceEpoch
                  ? const SizedBox()
                  : Card(
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
                                    DateTime.fromMillisecondsSinceEpoch(
                                            e["start_time"])
                                        .toIso8601String(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () async {
                                      controller.nameController.value.text =
                                          e["name"];
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
                                  IconButton(
                                    onPressed: () async {
                                      controller.nameController.value.text =
                                          e["name"];
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
                                  IconButton(
                                    onPressed: () async {
                                      controller.nameController.value.text =
                                          e["name"];
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
                                  IconButton(
                                    onPressed: () async {
                                      await controller
                                          .deleteTournament(e["id"]);
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
                                  ElevatedButton(
                                    onPressed: () async {
                                      await Get.toNamed(
                                        "/tournament/${e["id"]}/participants",
                                      );
                                    },
                                    child: Text("show_participants".tr),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text("edit_rounds".tr),
                                  ),
                                ],
                              ),
                            ]),
                      ),
                    )),
              const SizedBox(
                height: 20,
              ),
              Text(
                "past_tournaments".tr,
                style: const TextStyle(fontSize: 30),
              ),
              ...controller.tournaments.map((e) => e["start_time"] >
                      DateTime.now().millisecondsSinceEpoch
                  ? const SizedBox()
                  : Card(
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
                                    DateTime.fromMillisecondsSinceEpoch(
                                            e["start_time"])
                                        .toIso8601String(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () async {
                                      controller.nameController.value.text =
                                          e["name"];
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
                                  IconButton(
                                    onPressed: () async {
                                      controller.nameController.value.text =
                                          e["name"];
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
                                  IconButton(
                                    onPressed: () async {
                                      controller.nameController.value.text =
                                          e["name"];
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
                                  IconButton(
                                    onPressed: () async {
                                      await controller
                                          .deleteTournament(e["id"]);
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
                                  ElevatedButton(
                                    onPressed: () async {
                                      await Get.toNamed(
                                        "/tournament/${e["id"]}/participants",
                                      );
                                    },
                                    child: Text("show_participants".tr),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text("edit_rounds".tr),
                                  ),
                                ],
                              ),
                            ]),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
