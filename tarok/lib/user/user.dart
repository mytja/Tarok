// Tarok Palčka - a simple tarock program.
// Copyright (C) 2023 Mitja Ševerkar
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:get/get.dart' hide FormData;
import 'package:tarok/ui/main_page.dart';
import 'package:tarok/user/user_controller.dart';
import 'package:tarok/constants.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    UserSettingsController controller = Get.put(UserSettingsController());

    return PalckaHome(
      child: Obx(
        () => ListView(
          padding: const EdgeInsets.all(30),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Initicon(
                  text: controller.user.value.name,
                  elevation: 4,
                  backgroundColor: HSLColor.fromAHSL(
                          1, hashCode(controller.user.value.name) % 360, 1, 0.6)
                      .toColor(),
                  borderRadius: BorderRadius.zero,
                  size: 100,
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${controller.user.value.name} (${controller.user.value.handle})",
                          style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                controller.nameController.value.text =
                                    controller.user.value.name;
                                Get.dialog(
                                  AlertDialog(
                                    scrollable: true,
                                    title: Text("name_change".tr),
                                    content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("change_of_name_desc1".tr),
                                        Text("change_of_name_desc2".tr),
                                        Text("change_of_name_desc3".trParams({
                                          "name": controller.user.value.name
                                        })),
                                        TextField(
                                          controller:
                                              controller.nameController.value,
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
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                controller.handleController.value.text =
                                    controller.user.value.handle;
                                Get.dialog(
                                  AlertDialog(
                                    scrollable: true,
                                    title: Text("handle_change".tr),
                                    content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("change_of_handle_desc1".tr),
                                        Text("change_of_handle_desc2".tr),
                                        Text("handle_desc".tr),
                                        Text("change_of_handle_desc4".trParams({
                                          "name": controller.user.value.handle
                                        })),
                                        TextField(
                                          controller:
                                              controller.handleController.value,
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
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(controller.user.value.email),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.defaultDialog(
                              title: "change_of_email".tr,
                              content: Text("change_of_email_desc".tr),
                            );
                          },
                          child: Text("change_of_email".tr),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Text(
                  "number_of_played_games".tr,
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  controller.user.value.playedGames.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "user_profile_registered".tr,
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  controller.user.value.registeredOn,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text("role_in_system".tr, style: const TextStyle(fontSize: 20)),
                Text(
                  controller.user.value.role,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: ElevatedButton(
                onPressed: () {
                  controller.nameController.value.text =
                      controller.user.value.name;
                  Get.dialog(
                    AlertDialog(
                      scrollable: true,
                      title: Text("change_of_password".tr),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("change_of_password_desc1".tr),
                          Text("change_of_password_desc2".tr),
                          TextField(
                            decoration:
                                InputDecoration(hintText: 'old_password'.tr),
                            obscureText: true,
                            controller: controller.oldPasswordController.value,
                          ),
                          TextField(
                            decoration:
                                InputDecoration(hintText: 'new_password'.tr),
                            obscureText: true,
                            controller: controller.newPasswordController.value,
                          ),
                          TextField(
                            decoration: InputDecoration(
                                hintText: 'confirm_new_password'.tr),
                            obscureText: true,
                            controller:
                                controller.newPasswordControllerValidate.value,
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
                            await controller.changePassword();
                          },
                          child: Text("change".tr),
                        ),
                      ],
                    ),
                  );
                },
                child: Text("change_of_password".tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
