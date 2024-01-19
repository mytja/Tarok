import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarok/tms/tms_controller.dart';

class TournamentActions extends StatelessWidget {
  const TournamentActions({super.key, required this.e});

  final Map e;

  @override
  Widget build(BuildContext context) {
    TMSController controller = Get.put(TMSController());

    return Row(children: [
      if (controller.isAdmin.value)
        IconButton(
          onPressed: () async {
            controller.nameController.value.text = e["name"];
            controller.division.value = (e["division"] as int).toDouble();
            controller.tournamentTime.value =
                DateTime.fromMillisecondsSinceEpoch(e["start_time"]);
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
            controller.division.value = (e["division"] as int).toDouble();
            controller.tournamentTime.value =
                DateTime.fromMillisecondsSinceEpoch(e["start_time"]);
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
            controller.division.value = (e["division"] as int).toDouble();
            controller.tournamentTime.value =
                DateTime.fromMillisecondsSinceEpoch(e["start_time"]);
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
    ]);
  }
}
