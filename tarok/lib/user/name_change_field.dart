import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarok/user/user_controller.dart';

class NameChangeField extends StatelessWidget {
  const NameChangeField({super.key});

  @override
  Widget build(BuildContext context) {
    UserSettingsController controller = Get.put(UserSettingsController());

    return ElevatedButton(
      onPressed: () {
        controller.nameController.value.text = controller.user.value.name;
        Get.dialog(
          AlertDialog(
            scrollable: true,
            title: Text("name_change".tr),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("change_of_name_desc1".tr),
                Text("change_of_name_desc2".tr),
                Text("change_of_name_desc3"
                    .trParams({"name": controller.user.value.name})),
                TextField(
                  controller: controller.nameController.value,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("cancel".tr),
              ),
              TextButton(
                onPressed: () async {
                  await controller.changeName();
                  Get.back();
                },
                child: Text("change".tr),
              ),
            ],
          ),
        );
      },
      child: Text("name_change".tr),
    );
  }
}
