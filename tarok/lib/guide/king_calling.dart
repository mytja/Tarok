import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KingCallingGuide extends StatelessWidget {
  const KingCallingGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("king_calling".tr, style: const TextStyle(fontSize: 26)),
            Text("king_calling_desc".tr),
          ],
        ),
      ),
    );
  }
}
