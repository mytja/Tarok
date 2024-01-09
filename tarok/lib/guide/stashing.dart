import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StashingGuide extends StatelessWidget {
  const StashingGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("stashing".tr, style: const TextStyle(fontSize: 26)),
            Text("stashing_desc".tr),
          ],
        ),
      ),
    );
  }
}
