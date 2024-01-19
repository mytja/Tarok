import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailChangeField extends StatelessWidget {
  const EmailChangeField({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Get.defaultDialog(
          title: "change_of_email".tr,
          content: Text("change_of_email_desc".tr),
        );
      },
      child: Text("change_of_email".tr),
    );
  }
}
