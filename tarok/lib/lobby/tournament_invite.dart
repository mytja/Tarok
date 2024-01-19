import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarok/lobby/lobby_controller.dart';

class TournamentInvite extends StatelessWidget {
  const TournamentInvite({super.key});

  @override
  Widget build(BuildContext context) {
    LobbyController controller = Get.put(LobbyController());

    return Obx(
      () => Column(
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
                            child: Text(e["created_by"].length == 1
                                ? "invite_tournament_singular${e['private'] ? '_private' : ''}"
                                    .trParams({
                                    "who": (e["created_by"] as List).join(", "),
                                  })
                                : e["created_by"].length == 2
                                    ? "invite_tournament_dual${e['private'] ? '_private' : ''}"
                                        .trParams({
                                        "who": (e["created_by"] as List)
                                            .join(", "),
                                      })
                                    : "invite_tournament_plural${e['private'] ? '_private' : ''}"
                                        .trParams({
                                        "who": (e["created_by"] as List)
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
                        "israted": e["rated"] ? "" : "not_space".tr,
                      })),
                      const SizedBox(
                        height: 5,
                      ),
                      // grozote
                      Text(
                        "${DateTime.fromMillisecondsSinceEpoch(e["start_time"]).day}. ${DateTime.fromMillisecondsSinceEpoch(e["start_time"]).month}. ${DateTime.fromMillisecondsSinceEpoch(e["start_time"]).year} — ${DateTime.fromMillisecondsSinceEpoch(e["start_time"]).hour}.${DateTime.fromMillisecondsSinceEpoch(e["start_time"]).minute < 10 ? "0${DateTime.fromMillisecondsSinceEpoch(e["start_time"]).minute}" : DateTime.fromMillisecondsSinceEpoch(e["start_time"]).minute}",
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (e["registered"]) {
                              await controller.unregisterContest(e["id"]);
                              return;
                            }
                            await controller.registerContest(e["id"]);
                          },
                          child: e["registered"]
                              ? Text("unregister_tournament".tr)
                              : Text("register_tournament".tr),
                        ),
                        if (e["private"])
                          TextButton(
                            onPressed: () {
                              controller.tournamentTestingDialog(
                                  e["id"], e["division"]);
                            },
                            child: Text("start_tournament_testing".tr),
                          ),
                      ]),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
