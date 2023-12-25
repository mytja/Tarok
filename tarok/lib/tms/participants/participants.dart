import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarok/tms/participants/participants_controller.dart';
import 'package:tarok/ui/main_page.dart';

class TournamentParticipants extends StatelessWidget {
  const TournamentParticipants({super.key});

  @override
  Widget build(BuildContext context) {
    ParticipantsController controller = Get.put(ParticipantsController());
    return PalckaHome(
      automaticallyImplyLeading: true,
      child: Obx(
        () => Container(
          margin: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Text("participants".tr, style: const TextStyle(fontSize: 18)),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                  onPressed: () async {
                    await controller.fetchParticipants();
                  },
                  child: Text("refresh_data".tr),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: <DataColumn>[
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            "name".tr,
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            "email".tr,
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            "rated".tr,
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            "delta".tr,
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            "points".tr,
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            "registered_on".tr,
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            "participation_id".tr,
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                    ],
                    rows: <DataRow>[
                      ...controller.participants.map(
                        (m) => DataRow(
                          cells: <DataCell>[
                            DataCell(
                              Text(m["name"]),
                            ),
                            DataCell(Text(m["email"])),
                            DataCell(
                              Switch(
                                onChanged: (value) async {
                                  m["rated"] = value;
                                  await controller.toggleRatedUnrated(m["id"]);
                                },
                                value: m["rated"],
                              ),
                            ),
                            DataCell(Text(m["delta"].toString())),
                            DataCell(Text(m["points"].toString())),
                            DataCell(Text(m["created_at"])),
                            DataCell(Text(m["id"])),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
