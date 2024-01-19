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

import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:get/get.dart' hide FormData;
import 'package:tarok/ui/main_page.dart';
import 'package:tarok/user/email_change_field.dart';
import 'package:tarok/user/handle_change_field.dart';
import 'package:tarok/user/name_change_field.dart';
import 'package:tarok/user/user_controller.dart';
import 'package:tarok/constants.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    UserSettingsController controller = Get.put(UserSettingsController());

    final fullWidth = MediaQuery.of(context).size.width;
    bool smallDevice = fullWidth < 700;

    return PalckaHome(
      automaticallyImplyLeading: true,
      child: Obx(
        () => ListView(
          padding: EdgeInsets.all(smallDevice ? 20 : 30),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                controller.user.value.hasCustomProfilePicture
                    ? Image.network(
                        "$BACKEND_URL/user/${controller.user.value.userId}/profile_picture?lastRefresh=${controller.lastRefresh.value}",
                        width: min(100, fullWidth * 0.15),
                        height: min(100, fullWidth * 0.15),
                      )
                    : Initicon(
                        text: controller.user.value.name,
                        elevation: 4,
                        backgroundColor: HSLColor.fromAHSL(
                                1,
                                hashCode(controller.user.value.name) % 360,
                                1,
                                0.6)
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
                    SizedBox(
                      width: fullWidth - 180,
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              "${controller.user.value.name} (${controller.user.value.handle})",
                              style: TextStyle(
                                fontSize: min(50, fullWidth * 0.045),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (!smallDevice)
                            const SizedBox(
                              width: 20,
                            ),
                          if (!smallDevice)
                            const Column(
                              children: [
                                NameChangeField(),
                                SizedBox(
                                  height: 5,
                                ),
                                HandleChangeField(),
                              ],
                            ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text(controller.user.value.email),
                        if (!smallDevice)
                          const SizedBox(
                            width: 10,
                          ),
                        if (!smallDevice) const EmailChangeField(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ElevatedButton(
                onPressed: () async {
                  await controller.uploadProfilePicture();
                },
                child: Text("change_profile_picture".tr),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  await controller.removeProfilePicture();
                },
                child: Text("delete_profile_picture".tr),
              ),
            ]),
            if (smallDevice)
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  NameChangeField(),
                  SizedBox(
                    height: 10,
                  ),
                  HandleChangeField(),
                  SizedBox(
                    height: 10,
                  ),
                  EmailChangeField(),
                ],
              ),
            const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Text(
                  "number_of_played_games".tr,
                  style: TextStyle(
                    fontSize: min(fullWidth * 0.04, 20),
                  ),
                ),
                Text(
                  controller.user.value.playedGames.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: min(fullWidth * 0.04, 20),
                  ),
                ),
              ],
            ),
            if (!smallDevice)
              Row(
                children: [
                  Text(
                    "user_profile_registered".tr,
                    style: TextStyle(
                      fontSize: min(fullWidth * 0.04, 20),
                    ),
                  ),
                  Text(
                    controller.user.value.registeredOn,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: min(fullWidth * 0.04, 20),
                    ),
                  ),
                ],
              ),
            Row(
              children: [
                Text("role_in_system".tr,
                    style: TextStyle(
                      fontSize: min(fullWidth * 0.04, 20),
                    )),
                Text(
                  controller.user.value.role,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: min(fullWidth * 0.04, 20),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text("current_rating".tr,
                    style: TextStyle(
                      fontSize: min(fullWidth * 0.04, 20),
                    )),
                Text(
                  "${controller.user.value.rating}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: min(fullWidth * 0.04, 20),
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
            const SizedBox(
              height: 20,
            ),
            Text(
              "rating".tr,
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.5,
              child: LineChart(
                LineChartData(
                  titlesData: const FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1000,
                        reservedSize: 30,
                      ),
                    ),
                  ),
                  minY: 0,
                  maxY: 5000,
                  lineBarsData: [
                    LineChartBarData(
                      barWidth: 4,
                      isStrokeCapRound: true,
                      spots: [
                        ...controller.user.value.ratingDelta
                            .asMap()
                            .entries
                            .map(
                              (e) => FlSpot(
                                e.key.toDouble(),
                                (e.value["rating"] as int).toDouble(),
                              ),
                            )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
