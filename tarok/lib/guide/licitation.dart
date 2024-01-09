import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LicitationGuide extends StatelessWidget {
  const LicitationGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("licitation".tr, style: const TextStyle(fontSize: 26)),
            Text("licitation_desc".tr),
            const SizedBox(
              height: 10,
            ),
            Text("three_only_mand".tr, style: const TextStyle(fontSize: 19)),
            Text("three_gameplay".tr),
            const SizedBox(
              height: 10,
            ),
            Text("two".tr, style: const TextStyle(fontSize: 19)),
            Text("two_gameplay".tr),
            const SizedBox(
              height: 10,
            ),
            Text("one".tr, style: const TextStyle(fontSize: 19)),
            Text("one_gameplay".tr),
            const SizedBox(
              height: 10,
            ),
            Text("solo_three_only_four".tr,
                style: const TextStyle(fontSize: 19)),
            Text("solo_three_gameplay".tr),
            const SizedBox(
              height: 10,
            ),
            Text("solo_two_only_four".tr, style: const TextStyle(fontSize: 19)),
            Text("solo_two_gameplay".tr),
            const SizedBox(
              height: 10,
            ),
            Text("solo_one_only_four".tr, style: const TextStyle(fontSize: 19)),
            Text("solo_one_gameplay".tr),
            const SizedBox(
              height: 10,
            ),
            Text("beggar".tr, style: const TextStyle(fontSize: 19)),
            Text("beggar_gameplay".tr),
            const SizedBox(
              height: 10,
            ),
            Text("solo_without".tr, style: const TextStyle(fontSize: 19)),
            Text("solo_without_gameplay".tr),
            const SizedBox(
              height: 10,
            ),
            Text("open_beggar".tr, style: const TextStyle(fontSize: 19)),
            Text("open_beggar_gameplay".tr),
            const SizedBox(
              height: 10,
            ),
            Text("color_valat".tr, style: const TextStyle(fontSize: 19)),
            Text("color_valat_gameplay".tr),
            const SizedBox(
              height: 10,
            ),
            Text("valat".tr, style: const TextStyle(fontSize: 19)),
            Text("valat_gameplay".tr),
            const SizedBox(
              height: 10,
            ),
            Text("klop".tr, style: const TextStyle(fontSize: 19)),
            Text("klop_gameplay".tr),
          ],
        ),
      ),
    );
  }
}
