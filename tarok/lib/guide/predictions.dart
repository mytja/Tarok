import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PredictionsGuide extends StatelessWidget {
  const PredictionsGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("predictions".tr, style: const TextStyle(fontSize: 26)),
            Text("predictions_desc".tr),
            Text("quiet_predictions".tr),
            const SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  dataRowMaxHeight: 40,
                  dataRowMinHeight: 40,
                  headingRowHeight: 40,
                  columns: <DataColumn>[
                    DataColumn(label: Expanded(child: Text("prediction".tr))),
                    DataColumn(label: Expanded(child: Text("description".tr))),
                    DataColumn(label: Expanded(child: Text("worth".tr))),
                    DataColumn(
                        label: Expanded(child: Text("kontra_availability".tr))),
                  ],
                  rows: <DataRow>[
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text("trula".tr)),
                        DataCell(Text("trula_desc".tr)),
                        const DataCell(Text("20")),
                        const DataCell(Text("/")),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text("kings".tr)),
                        DataCell(Text("kings_desc".tr)),
                        const DataCell(Text("20")),
                        const DataCell(Text("/")),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text("pagat_ultimo".tr)),
                        DataCell(Text("pagat_ultimo_desc".tr)),
                        const DataCell(Text("50")),
                        DataCell(Text("up_to_mort".tr)),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text("king_ultimo".tr)),
                        DataCell(Text("king_ultimo_desc".tr)),
                        const DataCell(Text("20")),
                        DataCell(Text("up_to_mort".tr)),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text("mondfang".tr)),
                        DataCell(Text("mondfang_desc".tr)),
                        const DataCell(Text("42")),
                        DataCell(Text("up_to_mort".tr)),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text("color_valat".tr)),
                        DataCell(Text("color_valat_pred_desc".tr)),
                        DataCell(Text(
                            "discards_predictions_transforms_into_game".tr)),
                        DataCell(Text("game_can_kontra".tr)),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text("valat".tr)),
                        DataCell(Text("valat_pred_desc".tr)),
                        DataCell(Text(
                            "discards_predictions_transforms_into_game".tr)),
                        DataCell(Text("game_can_kontra".tr)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text("kontra".tr, style: const TextStyle(fontSize: 26)),
            Text("kontra_desc".tr),
            const SizedBox(
              height: 10,
            ),
            Text("radelci".tr, style: const TextStyle(fontSize: 26)),
            Text("radelci_desc".tr),
          ],
        ),
      ),
    );
  }
}
