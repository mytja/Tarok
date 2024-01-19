import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarok/user/user_controller.dart';

class HandleChangeField extends StatelessWidget {
  const HandleChangeField({super.key});

  @override
  Widget build(BuildContext context) {
    UserSettingsController controller = Get.put(UserSettingsController());

    return ElevatedButton(
      onPressed: () {
        controller.handleController.value.text = controller.user.value.handle;
        Get.dialog(
          AlertDialog(
            scrollable: true,
            title: Text("handle_change".tr),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("change_of_handle_desc1".tr),
                Text("change_of_handle_desc2".tr),
                Text("handle_desc".tr),
                Text("change_of_handle_desc4"
                    .trParams({"name": controller.user.value.handle})),
                TextField(
                  controller: controller.handleController.value,
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
                  await controller.changeHandle();
                  Get.back();
                },
                child: Text("change".tr),
              ),
            ],
          ),
        );
      },
      child: Text("handle_change".tr),
    );
  }
}
