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

import 'dart:convert';
import 'dart:math';

import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:get/get.dart';
import 'package:tarok/constants.dart';
import 'package:tarok/game/huge_spacer.dart';
import 'package:tarok/lobby/friends.dart';
import 'package:tarok/game/game_controller.dart';
import 'package:stockskis/stockskis.dart' as stockskis;

import '../stockskis_compatibility/compatibility.dart';

class Game extends StatelessWidget {
  const Game({super.key});

  @override
  Widget build(BuildContext context) {
    GameController controller = Get.put(GameController());

    final fullHeight = MediaQuery.of(context).size.height;
    final fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async => await controller.dropOnlyValidCard(),
        child: Obx(
          () {
            final cardSize = fullHeight * 0.35;
            final cardWidth = cardSize * 0.573;
            const duration = Duration(milliseconds: 150);
            final m = min(fullHeight, fullWidth);
            const cardK = 0.38;
            final leftFromTop = fullHeight * 0.3;
            final cardToWidth = fullWidth * 0.4 - (m * cardK * 0.57 * 0.6);
            final center = cardToWidth - m * cardK * 0.57 * 0.6;
            final userSquareSize = min(fullHeight / 5, 100.0).toDouble();
            final border = (fullWidth / 800);
            final popupCardSize = fullHeight / 2.5;
            const kCoverUp = 0.6;

            bool smallDevice = fullHeight < 500;

            return Stack(
              children: [
                // COUNTDOWN
                if (controller.countdown.value != 0)
                  Positioned(
                    left: center * 1.5,
                    top: userSquareSize,
                    child: Text(
                      controller.countdown.value.toString(),
                      style: TextStyle(
                        fontSize: fullHeight / 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                // RESULTS
                // REZULTATI
                // KLEPET
                // CHAT
                Container(
                  alignment: Alignment.topRight,
                  child: Card(
                    elevation: 10,
                    child: SizedBox(
                      height: fullHeight,
                      width: fullWidth / 5.5,
                      child: DefaultTabController(
                          length: controller.replay
                              ? 7 -
                                  (DEVELOPER_MODE ? 0 : 1) -
                                  (controller.bots ? 2 : 0)
                              : 6 -
                                  (DEVELOPER_MODE ? 0 : 1) -
                                  (controller.bots ? 2 : 0),
                          child: Scaffold(
                            appBar: AppBar(
                              toolbarHeight: smallDevice ? 30 : kToolbarHeight,
                              automaticallyImplyLeading: false,
                              elevation: 0,
                              flexibleSpace: TabBar(
                                  onTap: (index) {
                                    if (index == 1) {
                                      controller.unreadMessages.value = 0;
                                    }
                                  },
                                  tabs: [
                                    Tab(
                                        icon: Icon(
                                      Icons.timeline,
                                      size: smallDevice ? 14 : 24,
                                    )),
                                    if (!controller.bots)
                                      Tab(
                                        icon: controller.unreadMessages.value ==
                                                0
                                            ? Icon(
                                                Icons.chat,
                                                size: smallDevice ? 14 : 24,
                                              )
                                            : Badge(
                                                label: Text(
                                                  controller
                                                      .unreadMessages.value
                                                      .toString(),
                                                ),
                                                child: Icon(
                                                  Icons.chat,
                                                  size: smallDevice ? 14 : 24,
                                                ),
                                              ),
                                      ),
                                    if (controller.replay)
                                      Tab(
                                          icon: Icon(
                                        Icons.fast_rewind,
                                        size: smallDevice ? 14 : 24,
                                      )),
                                    if (DEVELOPER_MODE)
                                      Tab(
                                          icon: Icon(
                                        Icons.bug_report,
                                        size: smallDevice ? 14 : 24,
                                      )),
                                    if (!controller.bots)
                                      Tab(
                                          icon: Icon(
                                        Icons.info,
                                        size: smallDevice ? 14 : 24,
                                      )),
                                    GestureDetector(
                                      child: Tab(
                                        icon: Icon(
                                          Icons.settings,
                                          size: smallDevice ? 14 : 24,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        Get.back();
                                      },
                                      child: Tab(
                                        icon: Icon(
                                          Icons.exit_to_app,
                                          size: smallDevice ? 14 : 24,
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                            body: TabBarView(children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...controller.userWidgets.map(
                                    (e) => Row(children: [
                                      if (e.id ==
                                              controller.userHasKing.value ||
                                          e.licitiral > -1)
                                        Text(e.name,
                                            style: TextStyle(
                                              fontSize: userSquareSize / 6,
                                            )),
                                      const SizedBox(width: 10),
                                      if (e.licitiral > -1)
                                        Container(
                                          height: userSquareSize / 3,
                                          width: userSquareSize / 3,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            border: Border.all(
                                              color: controller.zaruf.value
                                                  ? Colors.red
                                                  : Colors.black,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                          ),
                                          child: Center(
                                            child: Text(
                                              GAME_DESC[controller
                                                          .currentPredictions
                                                          .value!
                                                          .igra
                                                          .id ==
                                                      ""
                                                  ? e.licitiral + 1
                                                  : controller
                                                          .currentPredictions
                                                          .value!
                                                          .gamemode +
                                                      1],
                                              style: TextStyle(
                                                fontSize: 0.15 * userSquareSize,
                                              ),
                                            ),
                                          ),
                                        ),
                                      if (e.id ==
                                              controller.userHasKing.value ||
                                          (e.licitiral > -1 &&
                                              e.licitiral < 3 &&
                                              controller.playing == 4))
                                        Container(
                                          height: userSquareSize / 3,
                                          width: userSquareSize / 3,
                                          decoration: BoxDecoration(
                                            color:
                                                controller.selectedKing.value ==
                                                            "/pik/kralj" ||
                                                        controller.selectedKing
                                                                .value ==
                                                            "/kriz/kralj"
                                                    ? Colors.black
                                                    : Colors.red,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                          ),
                                          child: Center(
                                            child: Text(
                                              controller.selectedKing.value ==
                                                      "/pik/kralj"
                                                  ? "♠️"
                                                  : (controller.selectedKing
                                                              .value ==
                                                          "/src/kralj"
                                                      ? "❤️"
                                                      : (controller.selectedKing
                                                                  .value ==
                                                              "/kriz/kralj"
                                                          ? "♣️"
                                                          : (controller
                                                                      .selectedKing
                                                                      .value ==
                                                                  "/kara/kralj"
                                                              ? "♦️"
                                                              : "?"))),
                                              style: TextStyle(
                                                fontSize: 0.15 * userSquareSize,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ]),
                                  ),
                                  !controller.bots &&
                                          controller.userWidgets.isNotEmpty
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                              controller.userWidgets.last
                                                              .timer <=
                                                          0 &&
                                                      controller
                                                          .tournamentGame.value
                                                  ? const CircularProgressIndicator(
                                                      semanticsLabel:
                                                          'Circular progress indicator',
                                                    )
                                                  : Text(
                                                      max(
                                                              controller
                                                                  .userWidgets
                                                                  .last
                                                                  .timer,
                                                              0)
                                                          .toStringAsFixed(2),
                                                      style: const TextStyle(
                                                          fontSize: 20),
                                                    ),
                                            ])
                                      : !controller.bots
                                          ? const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                  CircularProgressIndicator(
                                                    semanticsLabel:
                                                        'Circular progress indicator',
                                                  )
                                                ])
                                          : const SizedBox(),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "${controller.gamesPlayed.value}/${controller.gamesRequired.value == -1 ? '∞' : controller.gamesRequired.value}",
                                        ),
                                      ]),
                                  const SizedBox(width: 5),
                                  const Divider(),
                                  if (controller
                                      .tournamentGameStatistics.isNotEmpty)
                                    Text(
                                      "other_players_are_playing".tr,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ...controller.tournamentGameStatistics,
                                  if (controller
                                      .tournamentGameStatistics.isNotEmpty)
                                    const Divider(),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      ...controller.users.map(
                                          (stockskis.SimpleUser user) =>
                                              Expanded(
                                                child: Center(
                                                  child: Text(
                                                    user.name,
                                                    style: const TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      ...controller.users.map(
                                          (stockskis.SimpleUser user) =>
                                              Expanded(
                                                child: Center(
                                                  child: Text(
                                                    user.radlci > 4
                                                        ? "${user.radlci} ✪"
                                                        : List.generate(
                                                                user.radlci,
                                                                (e) => "✪")
                                                            .join(" "),
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      ...controller.users.map((e) => Expanded(
                                            child: Center(
                                              child: Text(
                                                e.total.toString(),
                                                style: TextStyle(
                                                  color: e.total < 0
                                                      ? Colors.red
                                                      : (e.total == 0
                                                          ? Colors.grey
                                                          : Colors.green),
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                  if (controller.users.isNotEmpty)
                                    Container(
                                      margin: const EdgeInsets.only(top: 5),
                                      child: ListView.builder(
                                        reverse: true,
                                        shrinkWrap: true,
                                        itemCount:
                                            controller.users[0].points.length,
                                        itemBuilder:
                                            (BuildContext context, int index) =>
                                                GestureDetector(
                                          onTap: () {
                                            controller.sendReplayGame(index);
                                            controller.results.value =
                                                ResultsCompLayer
                                                    .stockSkisToMessages(
                                              controller.users.first
                                                  .points[index].results,
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              ...controller.users.map(
                                                (e) => Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      e.points[index].points
                                                              .toString() +
                                                          (e.points[index]
                                                                      .playing &&
                                                                  e
                                                                      .points[
                                                                          index]
                                                                      .radelc
                                                              ? e.points[index]
                                                                          .points >=
                                                                      0
                                                                  ? " 🔺"
                                                                  : " 🔻"
                                                              : ""),
                                                      style: TextStyle(
                                                        color: e.points[index]
                                                                    .points <
                                                                0
                                                            ? Colors.red
                                                            : (e.points[index]
                                                                        .points ==
                                                                    0
                                                                ? Colors.grey
                                                                : Colors.green),
                                                        fontSize: 12,
                                                        fontWeight: e
                                                                .points[index]
                                                                .playing
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              if (!controller.bots)
                                SingleChildScrollView(
                                  child: Column(children: [
                                    TextField(
                                      controller: controller.controller.value,
                                      onSubmitted: (String value) async {
                                        await controller.sendMessage();
                                      },
                                    ),
                                    ListView(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: controller.chat
                                          .map((e) => Row(children: [
                                                e.customProfilePicture
                                                    ? Image.network(
                                                        "$BACKEND_URL/user/${e.userId}/profile_picture",
                                                        width: 40,
                                                        height: 40,
                                                      )
                                                    : Initicon(
                                                        text: controller
                                                            .getUserFromPosition(
                                                                e.userId)
                                                            .name,
                                                        elevation: 4,
                                                        size: 40,
                                                        backgroundColor: HSLColor.fromAHSL(
                                                                1,
                                                                hashCode(controller
                                                                        .getUserFromPosition(
                                                                            e.userId)
                                                                        .name) %
                                                                    360,
                                                                1,
                                                                0.6)
                                                            .toColor(),
                                                        borderRadius:
                                                            BorderRadius.zero,
                                                      ),
                                                const SizedBox(width: 10),
                                                Flexible(
                                                  child: Text(
                                                      "${controller.getUserFromPosition(e.userId).name}: ${e.message}"),
                                                ),
                                              ]))
                                          .toList(),
                                    ),
                                  ]),
                                ),
                              if (controller.replay)
                                Column(children: [
                                  Center(
                                    child: IconButton(
                                      onPressed: () async {
                                        await controller.sendReplayNext();
                                      },
                                      icon: const Icon(Icons.fast_forward),
                                    ),
                                  ),
                                ]),
                              if (DEVELOPER_MODE)
                                ListView(children: [
                                  Center(
                                    child: Text(
                                      "debugging".tr,
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Text("first_card".trParams({
                                    "card": controller.firstCard.value == null
                                        ? ''
                                        : controller.firstCard.value!.asset
                                  })),
                                  Text("trick".trParams({
                                    "trick": jsonEncode(controller.cardStih),
                                  })),
                                  Text("selected_king".trParams(
                                      {"king": controller.selectedKing.value})),
                                  Text("player_with_king".trParams({
                                    "player": controller.userHasKing.value
                                  })),
                                  Text("stashed_cards".trParams({
                                    "stashed":
                                        jsonEncode(controller.stashAmount.value)
                                  })),
                                  Text("talon_picked".trParams({
                                    "talon": controller.talonSelected.value
                                        .toString()
                                  })),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      controller.validCards();
                                    },
                                    child: Text("reevaluate_cards".tr),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      controller.socket.close();
                                      controller.connect(controller.gameId!);
                                      controller.listen();
                                    },
                                    child: Text("reset_websocket".tr),
                                  )
                                ]),
                              if (!controller.bots)
                                ListView(children: [
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Get.dialog(
                                          AlertDialog(
                                            title: Text("invite_friend".tr),
                                            content: SizedBox(
                                              width: double.maxFinite,
                                              child: Friends(
                                                gameId: controller.gameId!,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text("invite_friends".tr),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await controller.manuallyStartGame();
                                      },
                                      child: Text("start_game".tr),
                                    ),
                                  ),
                                ]),
                              ListView(children: [
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await Get.toNamed("/settings");
                                    },
                                    child: Text("open_settings".tr),
                                  ),
                                ),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await Get.toNamed("/guide");
                                    },
                                    child: Text("open_guide".tr),
                                  ),
                                ),
                              ]),
                              ListView(children: [
                                FloatingActionButton(
                                  onPressed: () {
                                    try {
                                      controller.socket
                                          .close(1000, 'CLOSE_NORMAL');
                                    } catch (e) {}
                                    Get.back();
                                    Get.delete<GameController>();
                                  },
                                  tooltip: "leave_game".tr,
                                  child: const Icon(Icons.close),
                                ),
                              ]),
                            ]),
                          )),
                    ),
                  ),
                ),

                // EVAL BAR
                if (controller.bots)
                  Positioned(
                    top: 0,
                    right: fullWidth / 5.5,
                    child: Container(
                      margin: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 3)),
                      child: Stack(
                        children: [
                          Container(
                            height: fullHeight / 3,
                            width: 25,
                            color: Colors.white,
                          ),
                          AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            color: Colors.black,
                            height: fullHeight /
                                3 *
                                max(0, min(1, 1 - controller.eval.value / 2)),
                            width: 25,
                          ),
                        ],
                      ),
                    ),
                  ),

                if (controller.bots)
                  Positioned(
                    top: fullHeight / 3 + 25,
                    right: fullWidth / 5.5 + 20,
                    child: Text(
                      (controller.eval.value).toStringAsFixed(1),
                    ),
                  ),

                // ŠTIHI
                if (controller.playing == 3 &&
                    !(controller.bots && SLEPI_TAROK))
                  ...controller.stihi3(
                    cardK,
                    m,
                    center,
                    leftFromTop,
                    cardToWidth,
                    fullWidth,
                  ),
                if (controller.playing == 4 &&
                    !(controller.bots && SLEPI_TAROK))
                  ...controller.stihi4(
                    cardK,
                    m,
                    center,
                    leftFromTop,
                    cardToWidth,
                    fullWidth,
                  ),

                // IMENA
                if (controller.playing == 4)
                  ...controller.generateNames4(
                    leftFromTop,
                    m,
                    cardK,
                    userSquareSize,
                    fullWidth,
                    fullHeight,
                  ),
                if (controller.playing == 3)
                  ...controller.generateNames3(
                    leftFromTop,
                    m,
                    cardK,
                    userSquareSize,
                    fullWidth,
                    fullHeight,
                  ),

                // LICITIRANJE
                if (controller.licitiranje.value)
                  DraggableWidget(
                    initialPosition: AnchoringPosition.center,
                    child: Card(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ...(COUNTERCLOCKWISE_GAME && !controller.bots
                                          ? controller.users.reversed
                                          : controller.users)
                                      .map(
                                    (stockskis.SimpleUser user) => Row(
                                      children: [
                                        Column(
                                          children: [
                                            Center(
                                              child: Text(
                                                user.name,
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize:
                                                      smallDevice ? 13 : 18,
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                user.licitiral == -2
                                                    ? ""
                                                    : stockskis
                                                        .GAMES[
                                                            user.licitiral + 1]
                                                        .name
                                                        .tr,
                                                style: TextStyle(
                                                  fontSize:
                                                      smallDevice ? 13 : 18,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 50,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (controller.licitiram.value)
                                Container(
                                  constraints:
                                      BoxConstraints(maxWidth: fullWidth / 1.8),
                                  child: GridView.count(
                                    shrinkWrap: true,
                                    primary: false,
                                    padding: const EdgeInsets.all(20),
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    crossAxisCount: 4,
                                    childAspectRatio: 3,
                                    children:
                                        controller.gameListAssemble(fullHeight),
                                  ),
                                ),
                              const HugeSpacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                // KRALJI
                if (controller.kingSelection.value)
                  DraggableWidget(
                    initialPosition: AnchoringPosition.center,
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: (popupCardSize * 0.8 * 1.1 * 3 +
                                      popupCardSize * 1.1) *
                                  0.57,
                              height: popupCardSize * 1.1,
                              child: Stack(
                                children: [
                                  ...KINGS.asMap().entries.map(
                                        (king) => Positioned(
                                          left: popupCardSize *
                                              1.1 *
                                              king.key *
                                              0.8 *
                                              0.57,
                                          child: GestureDetector(
                                            onTap: () async {
                                              await controller
                                                  .selectKing(king.value.asset);
                                            },
                                            child: Stack(
                                              children: [
                                                Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10 * border),
                                                      child: SizedBox(
                                                        height:
                                                            popupCardSize * 1.1,
                                                        width: popupCardSize *
                                                            0.57 *
                                                            1.1,
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              color:
                                                                  Colors.white,
                                                              height:
                                                                  popupCardSize *
                                                                      1.1,
                                                              width:
                                                                  popupCardSize *
                                                                      0.57 *
                                                                      1.1,
                                                            ),
                                                            Center(
                                                              child:
                                                                  Image.asset(
                                                                "assets/tarok${king.value.asset}.webp",
                                                                height:
                                                                    popupCardSize *
                                                                        1.1,
                                                                width:
                                                                    popupCardSize *
                                                                        0.57 *
                                                                        1.1,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                  ],
                                                ),
                                                if (controller.selectedKing
                                                            .value !=
                                                        king.value.asset &&
                                                    !controller
                                                        .kingSelect.value)
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10 * border),
                                                    child: Container(
                                                      color: Colors.black
                                                          .withAlpha(100),
                                                      height:
                                                          popupCardSize * 1.1,
                                                      width: popupCardSize *
                                                          0.57 *
                                                          1.1,
                                                    ),
                                                  ),
                                                if (controller
                                                    .hasCard(king.value.asset))
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          width: 10.0,
                                                          color: Colors.red,
                                                        ),
                                                        color: Colors.black
                                                            .withAlpha(30),
                                                        borderRadius: BorderRadius
                                                            .all(Radius
                                                                .circular(10 *
                                                                    (fullWidth /
                                                                        1000)))),
                                                    width: popupCardSize *
                                                        0.57 *
                                                        1.1,
                                                    height: popupCardSize * 1.1,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                ],
                              ),
                            ),
                            const HugeSpacer(),
                          ],
                        ),
                      ),
                    ),
                  ),

                // PREDICTIONS
                // NAPOVEDI
                if (controller.predictions.value &&
                    controller.currentPredictions.value != null)
                  DraggableWidget(
                    initialPosition: AnchoringPosition.center,
                    child: Card(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (controller.zalozeniTaroki.isNotEmpty)
                                Text(
                                  "stashed_tarocks".tr,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              if (controller.zalozeniTaroki.isNotEmpty)
                                const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ...controller.zalozeniTaroki.map(
                                    (tarok) => Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5 * border),
                                          child: SizedBox(
                                            height: popupCardSize / 2,
                                            child: Stack(
                                              children: [
                                                Container(
                                                  color: Colors.white,
                                                  height: popupCardSize / 2,
                                                  width: (popupCardSize / 2) *
                                                      0.57,
                                                ),
                                                Image.asset(
                                                    "assets/tarok${tarok.asset}.webp"),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (controller.zalozeniTaroki.isNotEmpty)
                                const SizedBox(height: 10),
                              DataTable(
                                dataRowMaxHeight: 40,
                                dataRowMinHeight: 40,
                                headingRowHeight: 40,
                                columns: <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text("game".trParams({
                                        "type":
                                            "(${stockskis.GAMES[controller.currentPredictions.value!.gamemode + 1].name == "onward" ? "klop".tr : stockskis.GAMES[controller.currentPredictions.value!.gamemode + 1].name.tr})"
                                      })),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(controller.users.map((e) {
                                        if (e.id ==
                                            controller.currentPredictions.value!
                                                .igra.id) {
                                          return e.name;
                                        }
                                        return "";
                                      }).join("")),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Row(
                                        children: [
                                          if (controller.myPredictions.value !=
                                                  null &&
                                              controller.myPredictions.value!
                                                  .igraKontra)
                                            Switch(
                                              value:
                                                  controller.kontraIgra.value,
                                              onChanged: (bool value) {
                                                if (value) {
                                                  controller.currentPredictions
                                                      .value!.igraKontra++;
                                                } else {
                                                  controller.currentPredictions
                                                      .value!.igraKontra--;
                                                }
                                                controller.kontraIgra.value =
                                                    value;
                                              },
                                            ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                              "${KONTRE[controller.currentPredictions.value!.igraKontra]} (${controller.users.map((e) {
                                            if (e.id ==
                                                controller
                                                    .currentPredictions
                                                    .value!
                                                    .igraKontraDal
                                                    .id) return e.name;
                                            return "";
                                          }).join("")})"),
                                        ],
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        "points_prediction".trParams(
                                          {
                                            "points": (stockskis
                                                        .GAMES[controller
                                                                .currentPredictions
                                                                .value!
                                                                .gamemode +
                                                            1]
                                                        .worth *
                                                    pow(
                                                        2,
                                                        controller
                                                            .currentPredictions
                                                            .value!
                                                            .igraKontra))
                                                .toString(),
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: <DataRow>[
                                  if (!(controller.valat.value ||
                                      controller.barvic.value ||
                                      controller.currentPredictions.value!
                                              .gamemode >=
                                          6 ||
                                      controller.currentPredictions.value!
                                              .gamemode ==
                                          -1))
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text("trula".tr)),
                                        if (controller.myPredictions.value !=
                                                null &&
                                            controller
                                                .myPredictions.value!.trula &&
                                            controller.users.map((e) {
                                                  if (e.id ==
                                                      controller
                                                          .currentPredictions
                                                          .value!
                                                          .trula
                                                          .id) {
                                                    return e.name;
                                                  }
                                                  return "";
                                                }).join("") ==
                                                "")
                                          DataCell(
                                            Switch(
                                              value: controller.trula.value,
                                              onChanged: (bool value) {
                                                controller.trula.value = value;
                                              },
                                            ),
                                          )
                                        else
                                          DataCell(
                                              Text(controller.users.map((e) {
                                            if (e.id ==
                                                controller.currentPredictions
                                                    .value!.trula.id) {
                                              return e.name;
                                            }
                                            return "";
                                          }).join(""))),
                                        const DataCell(
                                          Row(
                                            children: [
                                              Text("/"),
                                            ],
                                          ),
                                        ),
                                        DataCell(
                                          Row(
                                            children: [
                                              Text(
                                                  "points_prediction".trParams({
                                                "points": controller
                                                            .trula.value ||
                                                        controller
                                                                .currentPredictions
                                                                .value!
                                                                .trula
                                                                .id !=
                                                            ""
                                                    ? "20"
                                                    : "0"
                                              })),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (!(controller.valat.value ||
                                      controller.barvic.value ||
                                      controller.currentPredictions.value!
                                              .gamemode >=
                                          6 ||
                                      controller.currentPredictions.value!
                                              .gamemode ==
                                          -1))
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text("kings".tr)),
                                        if (controller.myPredictions.value !=
                                                null &&
                                            controller
                                                .myPredictions.value!.kralji &&
                                            controller.users.map((e) {
                                                  if (e.id ==
                                                      controller
                                                          .currentPredictions
                                                          .value!
                                                          .kralji
                                                          .id) {
                                                    return e.name;
                                                  }
                                                  return "";
                                                }).join("") ==
                                                "")
                                          DataCell(
                                            Switch(
                                              value: controller.kralji.value,
                                              onChanged: (bool value) {
                                                controller.kralji.value = value;
                                              },
                                            ),
                                          )
                                        else
                                          DataCell(
                                              Text(controller.users.map((e) {
                                            if (e.id ==
                                                controller.currentPredictions
                                                    .value!.kralji.id) {
                                              return e.name;
                                            }
                                            return "";
                                          }).join(""))),
                                        const DataCell(
                                          Row(
                                            children: [
                                              Text("/"),
                                            ],
                                          ),
                                        ),
                                        DataCell(
                                          Row(
                                            children: [
                                              Text(
                                                  "points_prediction".trParams({
                                                "points": controller
                                                            .kralji.value ||
                                                        controller
                                                                .currentPredictions
                                                                .value!
                                                                .kralji
                                                                .id !=
                                                            ""
                                                    ? "20"
                                                    : "0"
                                              })),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (!(controller.valat.value ||
                                      controller.barvic.value ||
                                      controller.currentPredictions.value!
                                              .gamemode >=
                                          6 ||
                                      controller.currentPredictions.value!
                                              .gamemode ==
                                          -1))
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text("pagat_ultimo".tr)),
                                        if (controller.myPredictions.value !=
                                                null &&
                                            controller.myPredictions.value!
                                                .pagatUltimo &&
                                            !controller.kraljUltimo.value)
                                          DataCell(
                                            Switch(
                                              value:
                                                  controller.pagatUltimo.value,
                                              onChanged: (bool value) {
                                                controller.pagatUltimo.value =
                                                    value;
                                              },
                                            ),
                                          )
                                        else
                                          DataCell(
                                              Text(controller.users.map((e) {
                                            if (e.id ==
                                                controller.currentPredictions
                                                    .value!.pagatUltimo.id) {
                                              return e.name;
                                            }
                                            return "";
                                          }).join(""))),
                                        DataCell(
                                          Row(
                                            children: [
                                              if (controller.myPredictions
                                                          .value !=
                                                      null &&
                                                  controller.myPredictions
                                                      .value!.pagatUltimoKontra)
                                                Switch(
                                                  value: controller
                                                      .kontraPagat.value,
                                                  onChanged: (bool value) {
                                                    if (value) {
                                                      controller
                                                          .currentPredictions
                                                          .value!
                                                          .pagatUltimoKontra++;
                                                    } else {
                                                      controller
                                                          .currentPredictions
                                                          .value!
                                                          .pagatUltimoKontra--;
                                                    }
                                                    controller.kontraPagat
                                                        .value = value;
                                                  },
                                                ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                  "${KONTRE[controller.currentPredictions.value!.pagatUltimoKontra]} (${controller.users.map((e) {
                                                if (e.id ==
                                                    controller
                                                        .currentPredictions
                                                        .value!
                                                        .pagatUltimoKontraDal
                                                        .id) return e.name;
                                                return "";
                                              }).join("")})"),
                                            ],
                                          ),
                                        ),
                                        DataCell(
                                          Row(
                                            children: [
                                              Text(
                                                  "points_prediction".trParams({
                                                "points": controller.pagatUltimo
                                                            .value ||
                                                        controller
                                                                .currentPredictions
                                                                .value!
                                                                .pagatUltimo
                                                                .id !=
                                                            ""
                                                    ? (50 *
                                                            pow(
                                                                2,
                                                                controller
                                                                    .currentPredictions
                                                                    .value!
                                                                    .pagatUltimoKontra))
                                                        .toString()
                                                    : "0",
                                              })),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (!(controller.valat.value ||
                                      controller.barvic.value ||
                                      controller.currentPredictions.value!
                                              .gamemode >=
                                          6 ||
                                      controller.currentPredictions.value!
                                              .gamemode ==
                                          -1))
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text("king_ultimo".tr)),
                                        if (controller.myPredictions.value !=
                                                null &&
                                            controller.myPredictions.value!
                                                .kraljUltimo &&
                                            !controller.pagatUltimo.value)
                                          DataCell(
                                            Switch(
                                              value:
                                                  controller.kraljUltimo.value,
                                              onChanged: (bool value) {
                                                controller.kraljUltimo.value =
                                                    value;
                                              },
                                            ),
                                          )
                                        else
                                          DataCell(
                                              Text(controller.users.map((e) {
                                            if (e.id ==
                                                controller.currentPredictions
                                                    .value!.kraljUltimo.id) {
                                              return e.name;
                                            }
                                            return "";
                                          }).join(""))),
                                        DataCell(
                                          Row(
                                            children: [
                                              if (controller.myPredictions
                                                          .value !=
                                                      null &&
                                                  controller.myPredictions
                                                      .value!.kraljUltimoKontra)
                                                Switch(
                                                  value: controller
                                                      .kontraKralj.value,
                                                  onChanged: (bool value) {
                                                    if (value) {
                                                      controller
                                                          .currentPredictions
                                                          .value!
                                                          .kraljUltimoKontra++;
                                                    } else {
                                                      controller
                                                          .currentPredictions
                                                          .value!
                                                          .kraljUltimoKontra--;
                                                    }
                                                    controller.kontraKralj
                                                        .value = value;
                                                  },
                                                ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                  "${KONTRE[controller.currentPredictions.value!.kraljUltimoKontra]} (${controller.users.map((e) {
                                                if (e.id ==
                                                    controller
                                                        .currentPredictions
                                                        .value!
                                                        .kraljUltimoKontraDal
                                                        .id) return e.name;
                                                return "";
                                              }).join("")})"),
                                            ],
                                          ),
                                        ),
                                        DataCell(
                                          Row(
                                            children: [
                                              Text(
                                                  "points_prediction".trParams({
                                                "points": controller.kraljUltimo
                                                            .value ||
                                                        controller
                                                                .currentPredictions
                                                                .value!
                                                                .kraljUltimo
                                                                .id !=
                                                            ""
                                                    ? (20 *
                                                            pow(
                                                                2,
                                                                controller
                                                                    .currentPredictions
                                                                    .value!
                                                                    .kraljUltimoKontra))
                                                        .toString()
                                                    : "0",
                                              })),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (!controller.valat.value &&
                                      !controller.barvic.value &&
                                      (controller.currentPredictions.value!
                                                  .mondfang.id !=
                                              "" ||
                                          (controller.myPredictions.value !=
                                                  null &&
                                              controller.myPredictions.value!
                                                  .mondfang)) &&
                                      controller.currentPredictions.value!
                                              .gamemode >=
                                          0 &&
                                      controller.currentPredictions.value!
                                              .gamemode <=
                                          5)
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text("mondfang".tr)),
                                        if (controller.myPredictions.value !=
                                                null &&
                                            controller
                                                .myPredictions.value!.mondfang)
                                          DataCell(
                                            Switch(
                                              value: controller.mondfang.value,
                                              onChanged: (bool value) {
                                                controller.mondfang.value =
                                                    value;
                                              },
                                            ),
                                          )
                                        else
                                          DataCell(
                                              Text(controller.users.map((e) {
                                            if (e.id ==
                                                controller.currentPredictions
                                                    .value!.mondfang.id) {
                                              return e.name;
                                            }
                                            return "";
                                          }).join(""))),
                                        DataCell(
                                          Row(
                                            children: [
                                              if (controller.myPredictions
                                                          .value !=
                                                      null &&
                                                  controller.myPredictions
                                                      .value!.mondfangKontra)
                                                Switch(
                                                  value: controller
                                                      .kontraMondfang.value,
                                                  onChanged: (bool value) {
                                                    if (value) {
                                                      controller
                                                          .currentPredictions
                                                          .value!
                                                          .mondfangKontra++;
                                                    } else {
                                                      controller
                                                          .currentPredictions
                                                          .value!
                                                          .mondfangKontra--;
                                                    }
                                                    controller.kontraMondfang
                                                        .value = value;
                                                  },
                                                ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                  "${KONTRE[controller.currentPredictions.value!.mondfangKontra]} (${controller.users.map((e) {
                                                if (e.id ==
                                                    controller
                                                        .currentPredictions
                                                        .value!
                                                        .mondfangKontraDal
                                                        .id) return e.name;
                                                return "";
                                              }).join("")})"),
                                            ],
                                          ),
                                        ),
                                        DataCell(
                                          Row(
                                            children: [
                                              Text(
                                                  "points_prediction".trParams({
                                                "points": controller
                                                            .mondfang.value ||
                                                        controller
                                                                .currentPredictions
                                                                .value!
                                                                .mondfang
                                                                .id !=
                                                            ""
                                                    ? (21 *
                                                            pow(
                                                                2,
                                                                controller
                                                                    .currentPredictions
                                                                    .value!
                                                                    .mondfangKontra))
                                                        .toString()
                                                    : "0",
                                              })),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (!(controller.valat.value ||
                                      controller
                                              .currentPredictions.value!.gamemode >=
                                          6 ||
                                      controller
                                              .currentPredictions.value!.gamemode <=
                                          2 ||
                                      controller.currentPredictions.value!
                                              .gamemode ==
                                          -1 ||
                                      !controller.isPlaying.value))
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text("color_valat".tr)),
                                        if (controller.myPredictions.value !=
                                                null &&
                                            controller.myPredictions.value!
                                                .barvniValat)
                                          DataCell(
                                            Switch(
                                              value: controller.barvic.value,
                                              onChanged: (bool value) {
                                                controller.barvic.value = value;
                                              },
                                            ),
                                          )
                                        else
                                          DataCell(
                                              Text(controller.users.map((e) {
                                            if (e.id ==
                                                controller.currentPredictions
                                                    .value!.barvniValat.id) {
                                              return e.name;
                                            }
                                            return "";
                                          }).join(""))),
                                        const DataCell(SizedBox()),
                                        DataCell(
                                          Row(
                                            children: [
                                              Text(
                                                  "points_prediction".trParams({
                                                "points": controller
                                                            .barvic.value ||
                                                        controller
                                                                .currentPredictions
                                                                .value!
                                                                .barvniValat
                                                                .id !=
                                                            ""
                                                    ? "125"
                                                    : "0",
                                              })),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (!(controller.barvic.value ||
                                      controller
                                              .currentPredictions.value!.gamemode >=
                                          6 ||
                                      controller.currentPredictions.value!
                                              .gamemode ==
                                          -1 ||
                                      !controller.isPlaying.value))
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text("valat".tr)),
                                        if (controller.myPredictions.value !=
                                                null &&
                                            controller
                                                .myPredictions.value!.valat)
                                          DataCell(
                                            Switch(
                                              value: controller.valat.value,
                                              onChanged: (bool value) {
                                                controller.valat.value = value;
                                              },
                                            ),
                                          )
                                        else
                                          DataCell(
                                              Text(controller.users.map((e) {
                                            if (e.id ==
                                                controller.currentPredictions
                                                    .value!.valat.id) {
                                              return e.name;
                                            }
                                            return "";
                                          }).join(""))),
                                        const DataCell(SizedBox()),
                                        DataCell(
                                          Row(
                                            children: [
                                              Text(
                                                  "points_prediction".trParams({
                                                "points": controller
                                                            .valat.value ||
                                                        controller
                                                                .currentPredictions
                                                                .value!
                                                                .valat
                                                                .id !=
                                                            ""
                                                    ? "500"
                                                    : "0",
                                              })),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (controller.talon.isNotEmpty)
                                    ElevatedButton(
                                      onPressed: () {
                                        controller.showTalon.value = true;
                                      },
                                      child: Text(
                                        "show_talon".tr,
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  if (controller.startPredicting.value)
                                    ElevatedButton(
                                      onPressed: controller.predict,
                                      child: Text(
                                        "predict".tr,
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const HugeSpacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                // TALON
                if (controller.showTalon.value)
                  DraggableWidget(
                    initialPosition: AnchoringPosition.center,
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (controller.selectedKing.value != "")
                              Text("playing_in".trParams(
                                {
                                  "player": controller.users.map((e) {
                                    //debugPrint("igra ${currentPredictions!.igra.id} ${e.id}");
                                    if (e.id ==
                                        controller.currentPredictions.value!
                                            .igra.id) {
                                      return e.name;
                                    }
                                    return "";
                                  }).join(""),
                                  "color": controller.selectedKing.value ==
                                          "/pik/kralj"
                                      ? "piku".tr
                                      : controller.selectedKing.value ==
                                              "/kara/kralj"
                                          ? "kari".tr
                                          : controller.selectedKing.value ==
                                                  "/src/kralj"
                                              ? "srcu".tr
                                              : "križu".tr,
                                },
                              )),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ...controller.talon.asMap().entries.map(
                                      (stih) => GestureDetector(
                                        onTap: () async {
                                          await controller
                                              .selectTalon(stih.key);
                                        },
                                        child: SizedBox(
                                          width: popupCardSize *
                                                  0.573 *
                                                  (1 +
                                                      kCoverUp *
                                                          (stih.value.length -
                                                              1)) +
                                              stih.value.length * 3,
                                          height: popupCardSize,
                                          child: Stack(
                                            children: [
                                              ...stih.value.asMap().entries.map(
                                                    (entry) => Positioned(
                                                      left: (popupCardSize *
                                                              0.573 *
                                                              kCoverUp *
                                                              entry.key)
                                                          .toDouble(), // neka bs konstanta, ki izvira iz nekaj vrstic bolj gor
                                                      // ali imam mentalne probleme? ja.
                                                      // ali me briga? ne.
                                                      // fuck bad code quality
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10 *
                                                                    (fullWidth /
                                                                        1000)),
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              color:
                                                                  Colors.white,
                                                              width:
                                                                  popupCardSize *
                                                                      0.57,
                                                              height:
                                                                  popupCardSize,
                                                            ),
                                                            SizedBox(
                                                              height:
                                                                  popupCardSize,
                                                              width:
                                                                  popupCardSize *
                                                                      0.57,
                                                              child: Center(
                                                                child:
                                                                    Image.asset(
                                                                  "assets/tarok${entry.value.asset}.webp",
                                                                ),
                                                              ),
                                                            ),
                                                            if (controller
                                                                    .selectedKing
                                                                    .value ==
                                                                entry.value
                                                                    .asset)
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                        border: Border
                                                                            .all(
                                                                          width:
                                                                              10.0,
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10 *
                                                                                (fullWidth / 1000)))),
                                                                width:
                                                                    popupCardSize *
                                                                        0.57,
                                                                height:
                                                                    popupCardSize,
                                                              ),
                                                            if (controller
                                                                        .talonSelected
                                                                        .value !=
                                                                    -1 &&
                                                                controller
                                                                        .talonSelected
                                                                        .value !=
                                                                    stih.key)
                                                              Container(
                                                                color: Colors
                                                                    .black
                                                                    .withAlpha(
                                                                        100),
                                                                height:
                                                                    popupCardSize,
                                                                width:
                                                                    popupCardSize *
                                                                        0.57,
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (controller.zaruf.value && !isWebMobile)
                              Text("zaruf".tr),
                            ElevatedButton(
                              onPressed: () {
                                controller.showTalon.value = false;
                              },
                              child: Text(
                                "hide_talon".tr,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const HugeSpacer(),
                          ],
                        ),
                      ),
                    ),
                  ),

                // ZALOŽITEV KART
                // POTRDI ZALOŽITEV
                if (controller.stashedCards.length >=
                        controller.stashAmount.value &&
                    controller.stashAmount.value > 0)
                  DraggableWidget(
                    initialPosition: AnchoringPosition.center,
                    child: Card(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("stashing_cards".tr),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ...controller.stashedCards.map(
                                    (king) => Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              10 * (fullWidth / 800)),
                                          child: SizedBox(
                                            height: popupCardSize,
                                            child: Stack(
                                              children: [
                                                Container(
                                                  color: Colors.white,
                                                  height: popupCardSize,
                                                  width: popupCardSize * 0.57,
                                                ),
                                                Image.asset(
                                                    "assets/tarok${king.asset}.webp"),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      await controller.stashEnd(true);
                                      controller.stashedCards.value = [];
                                    },
                                    child: Text("confirm".tr),
                                  ),
                                  const SizedBox(width: 20),
                                  ElevatedButton(
                                    onPressed: () async {
                                      int k = controller.stashedCards.length;
                                      for (int i = 0; i < k; i++) {
                                        debugPrint(
                                            "return card: ${controller.stashedCards[0]}");
                                        controller.cards
                                            .add(controller.stashedCards[0]);
                                        controller.stashedCards.removeAt(0);
                                      }
                                      controller.turn.value = true;
                                      controller.sortCards();
                                    },
                                    child: Text("change_card_selection".tr),
                                  ),
                                ],
                              ),
                              const HugeSpacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                // MOJE KARTE
                ...controller.cards.asMap().entries.map(
                      (e) => Container(
                        height: cardSize,
                        transform: Matrix4.translationValues(
                            e.key *
                                min(
                                  fullWidth / (controller.cards.length + 1),
                                  fullHeight * 0.135,
                                ),
                            (fullHeight - cardSize / 1.3),
                            0),
                        child: GestureDetector(
                          onTap: () async {
                            debugPrint("Clicked a card");
                            if (!controller.turn.value && PREMOVE) {
                              controller.resetPremoves();
                              controller.premovedCard.value =
                                  controller.cards[e.key];
                              controller.cards[e.key].showZoom = true;
                              controller.cards.refresh();
                              return;
                            }
                            if (!e.value.valid) return;
                            await controller.sendCard(e.value);
                          },
                          child: MouseRegion(
                            onEnter: (event) {
                              debugPrint("Entered mouse region");
                              if (e.key >= controller.cards.length) return;
                              controller.cards[e.key].showZoom = true;
                              controller.cards.refresh();
                            },
                            onExit: (event) {
                              if (e.key >= controller.cards.length) return;
                              if (controller.premovedCard.value != null &&
                                  controller.premovedCard.value!.asset ==
                                      e.value.asset) {
                                return;
                              }
                              controller.cards[e.key].showZoom = false;
                              controller.cards.refresh();
                            },
                            child: AnimatedScale(
                              duration: duration,
                              scale: e.value.showZoom == true ? 1.4 : 1,
                              child: Transform.rotate(
                                angle: (pi / 135) *
                                    (e.key -
                                        (controller.cards.length / 2).floor()),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      10 * (fullWidth / 1000)),
                                  child: Stack(
                                    children: [
                                      Container(
                                        color: Colors.white,
                                        height: cardSize,
                                        width: cardWidth,
                                      ),
                                      SizedBox(
                                        height: cardSize,
                                        width: cardWidth,
                                        child: Center(
                                          child: Image.asset(
                                            "assets/tarok${e.value.asset}.webp",
                                          ),
                                        ),
                                      ),
                                      if (!controller.turn.value && RED_FILTER)
                                        Container(
                                          color: Colors.red.withAlpha(120),
                                          height: cardSize,
                                          width: cardWidth,
                                        ),
                                      if (controller.turn.value &&
                                          !e.value.valid)
                                        Container(
                                          color: Colors.red.withAlpha(120),
                                          height: cardSize,
                                          width: cardWidth,
                                        ),
                                      if (controller.turn.value &&
                                              (controller.currentPredictions
                                                          .value !=
                                                      null &&
                                                  controller
                                                          .currentPredictions
                                                          .value!
                                                          .pagatUltimo
                                                          .id !=
                                                      "" &&
                                                  e.value.asset ==
                                                      "/taroki/pagat") ||
                                          (controller.currentPredictions
                                                      .value !=
                                                  null &&
                                              controller.currentPredictions
                                                      .value!.kraljUltimo.id !=
                                                  "" &&
                                              e.value.asset ==
                                                  controller
                                                      .selectedKing.value))
                                        Container(
                                          color: Colors.yellow.withAlpha(70),
                                          height: cardSize,
                                          width: cardWidth,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                // REZULTATI IGRE
                if (controller.results.value != null)
                  DraggableWidget(
                    initialPosition: AnchoringPosition.center,
                    child: Card(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: IntrinsicWidth(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (controller.gamesPlayed.value !=
                                        controller.gamesRequired.value &&
                                    !controller.bots &&
                                    controller.gamesRequired.value != -1 &&
                                    !controller.requestedGameEnd.value &&
                                    !controller.tournamentGame.value)
                                  ElevatedButton(
                                      onPressed: () async =>
                                          await controller.gameStartEarly(),
                                      child: Text("immediately_onward".tr)),
                                if (controller.tournamentGame.value)
                                  const CircularProgressIndicator(
                                    semanticsLabel:
                                        'Circular progress indicator',
                                  ),
                                if (controller.tournamentGame.value)
                                  const SizedBox(
                                    height: 10,
                                  ),
                                if (controller.tournamentGame.value &&
                                    controller.gamesPlayed.value !=
                                        controller.gamesRequired.value)
                                  Text("tournament_continue_soon".tr),
                                if (controller.tournamentGame.value &&
                                    controller.gamesPlayed.value ==
                                        controller.gamesRequired.value)
                                  Text("tournament_ending".tr),
                                if (controller.tournamentGame.value)
                                  const SizedBox(
                                    height: 20,
                                  ),
                                if (controller.tournamentGame.value)
                                  Text(
                                    max(controller.userWidgets.last.timer, 0)
                                        .toStringAsFixed(2),
                                    style: const TextStyle(fontSize: 30),
                                  ),
                                if (controller.tournamentGame.value)
                                  const SizedBox(
                                    height: 20,
                                  ),
                                if (controller.tournamentGame.value &&
                                    controller.tournamentStatistics.value !=
                                        null)
                                  Text("previous_game_stats".trParams({
                                    "bestPoints":
                                        "${controller.tournamentStatistics.value!.topPlayerPoints}",
                                    "place":
                                        "${controller.tournamentStatistics.value!.place}",
                                    "total":
                                        "${controller.tournamentStatistics.value!.players}",
                                  })),
                                if (controller.tournamentGame.value &&
                                    controller.tournamentStatistics.value !=
                                        null)
                                  const SizedBox(
                                    height: 20,
                                  ),
                                if (controller.gamesPlayed.value !=
                                        controller.gamesRequired.value &&
                                    !controller.bots)
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ...controller.results.value!.user.map(
                                  (e) => Column(
                                    children: [
                                      ...e.user.map(
                                        (e2) => e2.name != ""
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: 30,
                                                    width: 30,
                                                    child: Initicon(
                                                      text: e2.name,
                                                      elevation: 4,
                                                      size: 30,
                                                      backgroundColor:
                                                          HSLColor.fromAHSL(
                                                                  1,
                                                                  hashCode(e2
                                                                          .name) %
                                                                      360,
                                                                  1,
                                                                  0.6)
                                                              .toColor(),
                                                      borderRadius:
                                                          BorderRadius.zero,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    e2.name,
                                                    style: const TextStyle(
                                                        fontSize: 20),
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                      ),
                                      DataTable(
                                        dataRowMaxHeight: 40,
                                        dataRowMinHeight: 40,
                                        headingRowHeight: 40,
                                        columns: <DataColumn>[
                                          DataColumn(
                                            label: Expanded(
                                              child: Text(
                                                "prediction".tr,
                                                style: const TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Expanded(
                                              child: Text(
                                                "kontra".tr,
                                                style: const TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Expanded(
                                              child: Text(
                                                "result".tr,
                                                style: const TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Expanded(
                                              child: Text(
                                                "predicted_by".tr,
                                                style: const TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Expanded(
                                              child: Text(
                                                "kontra_by".tr,
                                                style: const TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                          ),
                                        ],
                                        rows: <DataRow>[
                                          if (e.showGamemode)
                                            DataRow(
                                              cells: <DataCell>[
                                                DataCell(Text("game".trParams({
                                                  "type":
                                                      "(${stockskis.GAMES[controller.results.value!.predictions.gamemode + 1].name == "onward" ? "klop".tr : stockskis.GAMES[controller.results.value!.predictions.gamemode + 1].name.tr})"
                                                }))),
                                                DataCell(Text(
                                                    '${pow(2, e.kontraIgra)}x')),
                                                DataCell(Text(
                                                  '${e.igra}',
                                                  style: TextStyle(
                                                    color: e.igra < 0
                                                        ? Colors.red
                                                        : Colors.green,
                                                  ),
                                                )),
                                                DataCell(Text(controller
                                                    .results
                                                    .value!
                                                    .predictions
                                                    .igra
                                                    .name)),
                                                DataCell(Text(controller
                                                    .results
                                                    .value!
                                                    .predictions
                                                    .igraKontraDal
                                                    .name)),
                                              ],
                                            ),
                                          if (e.showDifference)
                                            DataRow(
                                              cells: <DataCell>[
                                                DataCell(Text("difference".tr)),
                                                DataCell(Text(
                                                    '${pow(2, e.kontraIgra)}x')),
                                                DataCell(Text(
                                                  '${e.razlika}',
                                                  style: TextStyle(
                                                    color: e.razlika < 0
                                                        ? Colors.red
                                                        : Colors.green,
                                                  ),
                                                )),
                                                const DataCell(Text("")),
                                                DataCell(
                                                  Text(controller
                                                      .results
                                                      .value!
                                                      .predictions
                                                      .igraKontraDal
                                                      .name),
                                                ),
                                              ],
                                            ),
                                          if (e.showTrula)
                                            DataRow(
                                              cells: <DataCell>[
                                                DataCell(Text("trula".tr)),
                                                const DataCell(Text('1x')),
                                                DataCell(Text(
                                                  '${e.trula}',
                                                  style: TextStyle(
                                                    color: e.trula < 0
                                                        ? Colors.red
                                                        : Colors.green,
                                                  ),
                                                )),
                                                DataCell(Text(controller
                                                    .results
                                                    .value!
                                                    .predictions
                                                    .trula
                                                    .name)),
                                                const DataCell(Text("")),
                                              ],
                                            ),
                                          if (e.showKralji)
                                            DataRow(
                                              cells: <DataCell>[
                                                DataCell(Text("kings".tr)),
                                                const DataCell(Text('1x')),
                                                DataCell(Text(
                                                  '${e.kralji}',
                                                  style: TextStyle(
                                                    color: e.kralji < 0
                                                        ? Colors.red
                                                        : Colors.green,
                                                  ),
                                                )),
                                                DataCell(Text(controller
                                                    .results
                                                    .value!
                                                    .predictions
                                                    .kralji
                                                    .name)),
                                                const DataCell(Text("")),
                                              ],
                                            ),
                                          if (e.showKralj)
                                            DataRow(
                                              cells: <DataCell>[
                                                DataCell(
                                                    Text("king_ultimo".tr)),
                                                DataCell(Text(
                                                    '${pow(2, e.kontraKralj)}x')),
                                                DataCell(Text(
                                                  '${e.kralj}',
                                                  style: TextStyle(
                                                    color: e.kralj < 0
                                                        ? Colors.red
                                                        : Colors.green,
                                                  ),
                                                )),
                                                DataCell(Text(controller
                                                    .results
                                                    .value!
                                                    .predictions
                                                    .kraljUltimo
                                                    .name)),
                                                DataCell(Text(controller
                                                    .results
                                                    .value!
                                                    .predictions
                                                    .kraljUltimoKontraDal
                                                    .name)),
                                              ],
                                            ),
                                          if (e.showPagat)
                                            DataRow(
                                              cells: <DataCell>[
                                                DataCell(
                                                    Text("pagat_ultimo".tr)),
                                                DataCell(Text(
                                                    '${pow(2, e.kontraPagat)}x')),
                                                DataCell(Text(
                                                  '${e.pagat}',
                                                  style: TextStyle(
                                                    color: e.pagat < 0
                                                        ? Colors.red
                                                        : Colors.green,
                                                  ),
                                                )),
                                                DataCell(Text(controller
                                                    .results
                                                    .value!
                                                    .predictions
                                                    .pagatUltimo
                                                    .name)),
                                                DataCell(Text(controller
                                                    .results
                                                    .value!
                                                    .predictions
                                                    .pagatUltimoKontraDal
                                                    .name)),
                                              ],
                                            ),
                                          if (e.mondfang)
                                            DataRow(
                                              cells: <DataCell>[
                                                DataCell(Text("mondfang".tr)),
                                                DataCell(Text(
                                                    '${pow(2, e.kontraMondfang)}x')),
                                                DataCell(Text(
                                                  "${e.points}",
                                                  style: TextStyle(
                                                    color: e.points < 0
                                                        ? Colors.red
                                                        : Colors.green,
                                                  ),
                                                )),
                                                DataCell(Text(controller
                                                    .results
                                                    .value!
                                                    .predictions
                                                    .mondfang
                                                    .name)),
                                                DataCell(Text(controller
                                                    .results
                                                    .value!
                                                    .predictions
                                                    .mondfangKontraDal
                                                    .name)),
                                              ],
                                            ),
                                          if (e.skisfang)
                                            DataRow(
                                              cells: <DataCell>[
                                                DataCell(Text("skisfang".tr)),
                                                const DataCell(Text('/')),
                                                const DataCell(Text(
                                                  '-100',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                )),
                                                const DataCell(Text("")),
                                                const DataCell(Text("")),
                                              ],
                                            ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text("total".tr)),
                                              const DataCell(Text('')),
                                              DataCell(
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      if (e.radelc)
                                                        TextSpan(
                                                          text:
                                                              '${e.points ~/ 2} * 2 = ',
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      TextSpan(
                                                        text: '${e.points}',
                                                        style: TextStyle(
                                                          color: e.points < 0
                                                              ? Colors.red
                                                              : Colors.green,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const DataCell(Text("")),
                                              const DataCell(Text("")),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                if ((controller.gamesPlayed.value ==
                                            controller.gamesRequired.value ||
                                        controller.gamesRequired.value == -1) &&
                                    controller.canExtendGame.value &&
                                    !controller.tournamentGame.value)
                                  const SizedBox(height: 20),
                                if ((controller.gamesPlayed.value ==
                                            controller.gamesRequired.value ||
                                        controller.gamesRequired.value == -1) &&
                                    controller.canExtendGame.value &&
                                    !controller.tournamentGame.value)
                                  DataTable(
                                    dataRowMaxHeight: 40,
                                    dataRowMinHeight: 40,
                                    headingRowHeight: 40,
                                    columns: <DataColumn>[
                                      DataColumn(
                                        label: Expanded(
                                          child: Text(
                                            "player".tr,
                                            style: const TextStyle(
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Text(
                                            "num_additional_rounds".tr,
                                            style: const TextStyle(
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: controller.users
                                        .map(
                                          (user) => DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text(user.name)),
                                              DataCell(
                                                user.endGame != -1
                                                    ? Text(
                                                        user.endGame == 0 ||
                                                                user.endGame > 1
                                                            ? user.endGame
                                                                .toString()
                                                            : user.endGame == 1
                                                                ? "Š"
                                                                : "",
                                                        style: const TextStyle(
                                                            fontSize: 26),
                                                      )
                                                    : user.id ==
                                                            controller
                                                                .playerId.value
                                                        ? Row(children: [
                                                            ElevatedButton(
                                                                onPressed: () async =>
                                                                    await controller
                                                                        .gameEndSend(
                                                                            0),
                                                                child:
                                                                    const Text(
                                                                        "0")),
                                                            ElevatedButton(
                                                                onPressed: () async =>
                                                                    await controller
                                                                        .gameEndSend(
                                                                            1),
                                                                child:
                                                                    const Text(
                                                                        "Š")),
                                                            ElevatedButton(
                                                                onPressed: () async =>
                                                                    await controller
                                                                        .gameEndSend(
                                                                            4),
                                                                child:
                                                                    const Text(
                                                                        "4")),
                                                            ElevatedButton(
                                                                onPressed: () async =>
                                                                    await controller
                                                                        .gameEndSend(
                                                                            8),
                                                                child:
                                                                    const Text(
                                                                        "8")),
                                                            ElevatedButton(
                                                                onPressed: () async =>
                                                                    await controller
                                                                        .gameEndSend(
                                                                            12),
                                                                child:
                                                                    const Text(
                                                                        "12")),
                                                            ElevatedButton(
                                                                onPressed: () async =>
                                                                    await controller
                                                                        .gameEndSend(
                                                                            16),
                                                                child:
                                                                    const Text(
                                                                        "16")),
                                                            ElevatedButton(
                                                                onPressed: () async =>
                                                                    await controller
                                                                        .gameEndSend(
                                                                            20),
                                                                child:
                                                                    const Text(
                                                                        "20")),
                                                          ])
                                                        : const SizedBox(),
                                              ),
                                            ],
                                          ),
                                        )
                                        .toList(),
                                  ),
                                const SizedBox(height: 30),

                                ElevatedButton(
                                  onPressed: () {
                                    controller.razpriKarte.value =
                                        !controller.razpriKarte.value;
                                  },
                                  child: controller.razpriKarte.value
                                      ? Text("hide_point_count_by_tricks".tr)
                                      : Text("show_point_count_by_tricks".tr),
                                ),

                                // pobrane karte v štihu
                                if (controller.razpriKarte.value)
                                  Text("picked_up_cards".tr,
                                      style: const TextStyle(fontSize: 30)),
                                if (controller.razpriKarte.value)
                                  Wrap(
                                    children: [
                                      ...controller.results.value!.stih
                                          .asMap()
                                          .entries
                                          .map(
                                            (e) => e.value.card.isNotEmpty
                                                ? Card(
                                                    elevation: 6,
                                                    child: Column(
                                                      children: [
                                                        const SizedBox(
                                                            height: 10),
                                                        Text(
                                                          controller.currentPredictions.value!.gamemode >= 0 &&
                                                                  controller
                                                                          .currentPredictions
                                                                          .value!
                                                                          .gamemode <=
                                                                      5
                                                              ? (e.key == 0
                                                                  ? "stashed".tr
                                                                  : e.key + 1 ==
                                                                          controller
                                                                              .results
                                                                              .value!
                                                                              .stih
                                                                              .length
                                                                      ? "talon"
                                                                          .tr
                                                                      : "trick_nr".trParams({
                                                                          "number": e
                                                                              .key
                                                                              .toString()
                                                                        }))
                                                              : (controller
                                                                          .currentPredictions
                                                                          .value!
                                                                          .gamemode ==
                                                                      -1
                                                                  ? "trick_nr"
                                                                      .trParams({
                                                                      "number": e
                                                                          .key
                                                                          .toString()
                                                                    })
                                                                  : (e.key + 1 ==
                                                                          controller.results.value!.stih.length
                                                                      ? "talon".tr
                                                                      : "trick_nr".trParams({"number": e.key.toString()}))),
                                                          style: TextStyle(
                                                            fontWeight: e.value
                                                                    .pickedUpByPlaying
                                                                ? FontWeight
                                                                    .bold
                                                                : FontWeight
                                                                    .w300,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        SizedBox(
                                                          // neka bs konstanta, ki izvira iz nekaj vrstic bolj gor
                                                          // ali imam mentalne probleme? ja.
                                                          // ali me briga? ne.
                                                          // fuck bad code quality      (e) => SizedBox(
                                                          width: fullHeight /
                                                                  8 *
                                                                  0.573 *
                                                                  (1 +
                                                                      0.7 *
                                                                          (e.value.card.length -
                                                                              1)) +
                                                              e.value.card
                                                                      .length *
                                                                  3,
                                                          height:
                                                              fullHeight / 8,
                                                          child: Stack(
                                                            children: [
                                                              ...e.value.card
                                                                  .asMap()
                                                                  .entries
                                                                  .map(
                                                                    (entry) =>
                                                                        Positioned(
                                                                      left: (fullHeight /
                                                                              8 *
                                                                              0.573 *
                                                                              0.7 *
                                                                              entry.key)
                                                                          .toDouble(),
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10 *
                                                                                (fullWidth / 10000)),
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            Container(
                                                                              color: Colors.white,
                                                                              width: fullHeight / 8 * 0.57,
                                                                              height: fullHeight / 8,
                                                                            ),
                                                                            SizedBox(
                                                                              height: fullHeight / 8,
                                                                              child: Image.asset(
                                                                                "assets/tarok${entry.value.id}.webp",
                                                                                filterQuality: FilterQuality.medium,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        Text("trick_is_worth"
                                                            .trParams({
                                                          "points": e
                                                              .value.worth
                                                              .round()
                                                              .toString(),
                                                          "ptext": e.value.worth ==
                                                                      3 ||
                                                                  e.value.worth ==
                                                                      4
                                                              ? 'točke'.tr
                                                              : e.value.worth ==
                                                                      2
                                                                  ? 'točki'.tr
                                                                  : e.value.worth ==
                                                                          1
                                                                      ? 'točko'
                                                                          .tr
                                                                      : 'točk'
                                                                          .tr
                                                        })),
                                                        if (e.value
                                                                .pickedUpBy !=
                                                            "")
                                                          Text(
                                                            "trick_picked_up_by"
                                                                .trParams({
                                                              "player": e.value
                                                                  .pickedUpBy
                                                            }),
                                                          ),
                                                        const SizedBox(
                                                            height: 10),
                                                      ],
                                                    ),
                                                  )
                                                : const SizedBox(),
                                          ),
                                    ],
                                  ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    controller.results.value = null;
                                  },
                                  child: Text("close_results".tr),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                // KONEC IGRE
                if (controller.gameDone.value)
                  DraggableWidget(
                    initialPosition: AnchoringPosition.center,
                    child: Card(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "thanks_game".tr,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              DataTable(
                                dataRowMaxHeight: 40,
                                dataRowMinHeight: 40,
                                headingRowHeight: 40,
                                columns: <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        "player".tr,
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        "result".tr,
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        "rating".tr,
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: controller.users
                                    .map(
                                      (user) => DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text(user.name)),
                                          DataCell(Text(
                                            user.total.toString(),
                                            style: TextStyle(
                                              color: user.total < 0
                                                  ? Colors.red
                                                  : Colors.green,
                                            ),
                                          )),
                                          DataCell(Text(
                                            user.ratingDelta >= 0
                                                ? "+${user.ratingDelta}"
                                                : "${user.ratingDelta}",
                                            style: TextStyle(
                                              color: user.ratingDelta < 0
                                                  ? Colors.red
                                                  : Colors.green,
                                            ),
                                          )),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              if (controller.gameLinkController.value.text !=
                                  "")
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IntrinsicWidth(
                                      child: TextField(
                                        controller:
                                            controller.gameLinkController.value,
                                        readOnly: true,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        Clipboard.setData(ClipboardData(
                                          text: controller
                                              .gameLinkController.value.text,
                                        ));
                                      },
                                      icon: const Icon(Icons.copy),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      // mobilne naprave imajo že tako ali tako back gumbe
      floatingActionButton: Obx(
        () => ((!(controller.started.value && !controller.bots) ||
                    controller.replay) &&
                MediaQuery.of(context).size.height >= 500)
            ? FloatingActionButton(
                onPressed: () {
                  try {
                    controller.socket.close(1000, 'CLOSE_NORMAL');
                  } catch (e) {}
                  Get.back();
                  Get.delete<GameController>();
                },
                tooltip: "leave_game".tr,
                child: const Icon(Icons.close),
              )
            : const SizedBox(),
      ),
    );
  }
}
