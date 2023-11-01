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

import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:get/get.dart';
import 'package:tarok/constants.dart';
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
            final cardToWidth = fullWidth * 0.35 - (m * cardK * 0.57 * 0.6);
            final center = cardToWidth - m * cardK * 0.57 * 0.6;
            final userSquareSize = min(fullHeight / 5, 100.0).toDouble();
            final border = (fullWidth / 800);
            final popupCardSize = fullHeight / 2.5;
            const kCoverUp = 0.6;

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
                              ? 5 -
                                  (DEVELOPER_MODE ? 0 : 1) -
                                  (controller.bots ? 2 : 0)
                              : 4 -
                                  (DEVELOPER_MODE ? 0 : 1) -
                                  (controller.bots ? 2 : 0),
                          child: Scaffold(
                            appBar: AppBar(
                              automaticallyImplyLeading: false,
                              elevation: 0,
                              flexibleSpace: TabBar(
                                  onTap: (index) {
                                    if (index == 1) {
                                      controller.unreadMessages.value = 0;
                                    }
                                  },
                                  tabs: [
                                    const Tab(icon: Icon(Icons.timeline)),
                                    if (!controller.bots)
                                      Tab(
                                        icon: controller.unreadMessages.value ==
                                                0
                                            ? const Icon(Icons.chat)
                                            : Badge(
                                                label: Text(
                                                  controller
                                                      .unreadMessages.value
                                                      .toString(),
                                                ),
                                                child: const Icon(Icons.chat),
                                              ),
                                      ),
                                    if (controller.replay)
                                      const Tab(icon: Icon(Icons.fast_rewind)),
                                    if (DEVELOPER_MODE)
                                      const Tab(icon: Icon(Icons.bug_report)),
                                    if (!controller.bots)
                                      const Tab(icon: Icon(Icons.info)),
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
                                                        : (controller
                                                                    .selectedKing
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
                                                    fontSize:
                                                        0.15 * userSquareSize)),
                                          ),
                                        ),
                                    ]),
                                  ),
                                  if (!controller.bots &&
                                      controller.userWidgets.isNotEmpty)
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            max(
                                                    controller
                                                        .userWidgets.last.timer,
                                                    0)
                                                .toStringAsFixed(2),
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                        ]),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "${controller.gamesPlayed.value}/${controller.gamesRequired.value == -1 ? '∞' : controller.gamesRequired.value}",
                                        ),
                                      ]),
                                  const SizedBox(width: 5),
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
                                                Initicon(
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
                                  const Center(
                                    child: Text(
                                      "Odpravljanje hroščev",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Prva karta: ${controller.firstCard.value == null ? '' : controller.firstCard.value!.asset}",
                                  ),
                                  Text("Štih: ${controller.cardStih}"),
                                  Text(
                                      "Izbran kralj: ${controller.selectedKing.value}"),
                                  Text(
                                      "Uporabnik s kraljem: ${controller.userHasKing.value}"),
                                  Text(
                                      "Karte založene: ${controller.stashAmount.value}"),
                                  Text(
                                      "Talon izbran: ${controller.talonSelected.value}"),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      textStyle: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    onPressed: () {
                                      controller.validCards();
                                    },
                                    child: const Text(
                                      "Ponovno evaluiraj karte",
                                    ),
                                  ),
                                ]),
                              if (!controller.bots)
                                ListView(children: [
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Get.dialog(
                                          AlertDialog(
                                            title:
                                                const Text("Povabi prijatelja"),
                                            content: SizedBox(
                                              width: double.maxFinite,
                                              child: Friends(
                                                gameId: controller.gameId,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text("Povabi prijatelje"),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await controller.manuallyStartGame();
                                      },
                                      child: const Text("Začni igro"),
                                    ),
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
                                      if (!controller.turn.value)
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
                              const SizedBox(height: 10),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ...controller.users.map(
                                    (stockskis.SimpleUser user) => Row(
                                      children: [
                                        Column(
                                          children: [
                                            Center(
                                              child: Text(
                                                user.name,
                                                style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 18,
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
                                                        .name,
                                                style: const TextStyle(
                                                  fontSize: 18,
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
                                      BoxConstraints(maxWidth: fullWidth / 2),
                                  child: GridView.count(
                                    shrinkWrap: true,
                                    primary: false,
                                    padding: const EdgeInsets.all(20),
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    crossAxisCount: 4,
                                    childAspectRatio: 3,
                                    children: [
                                      ...controller.games.map((e) {
                                        if (controller.users.length == 3 &&
                                            !e.playsThree) {
                                          return const SizedBox();
                                        }
                                        return SizedBox(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: controller
                                                      .suggestions
                                                      .contains(e.id)
                                                  ? Colors.purpleAccent.shade400
                                                  : null,
                                              textStyle: TextStyle(
                                                fontSize: fullHeight / 35,
                                              ),
                                            ),
                                            onPressed: () async {
                                              await controller
                                                  .licitiranjeSend(e);
                                            },
                                            child: Text(
                                              e.name,
                                            ),
                                          ),
                                        );
                                      })
                                    ],
                                  ),
                                ),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ...KINGS.map(
                                  (king) => GestureDetector(
                                    onTap: () async {
                                      await controller.selectKing(king.asset);
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
                                                height: popupCardSize,
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      color: Colors.white,
                                                      height: popupCardSize,
                                                      width:
                                                          popupCardSize * 0.57,
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
                                        if (controller.selectedKing.value !=
                                                king.asset &&
                                            !controller.kingSelect.value)
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                10 * border),
                                            child: Container(
                                              color:
                                                  Colors.black.withAlpha(100),
                                              height: popupCardSize,
                                              width: popupCardSize * 0.57,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                                const Text("Založeni taroki:",
                                    style: TextStyle(fontSize: 18)),
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
                                      child: Text(
                                        'Igra (${stockskis.GAMES[controller.currentPredictions.value!.gamemode + 1].name == "Naprej" ? "Klop" : stockskis.GAMES[controller.currentPredictions.value!.gamemode + 1].name})',
                                      ),
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
                                        const DataCell(Text('Trula')),
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
                                        const DataCell(Text('Kralji')),
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
                                        const DataCell(Text('Pagat ultimo')),
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
                                        const DataCell(Text('Kralj ultimo')),
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
                                        const DataCell(Text('Mondfang')),
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
                                        const DataCell(Text('Barvni valat')),
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
                                        const DataCell(Text('Valat')),
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
                                      child: const Text(
                                        "Pokaži talon",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  if (controller.startPredicting.value)
                                    ElevatedButton(
                                      onPressed: controller.predict,
                                      child: const Text(
                                        "Napovej",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
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
                              Text(
                                "${controller.users.map((e) {
                                  //debugPrint("igra ${currentPredictions!.igra.id} ${e.id}");
                                  if (e.id ==
                                      controller
                                          .currentPredictions.value!.igra.id) {
                                    return e.name;
                                  }
                                  return "";
                                }).join("")} igra v ${controller.selectedKing.value == "/pik/kralj" ? "piku" : controller.selectedKing.value == "/kara/kralj" ? "kari" : controller.selectedKing.value == "/src/kralj" ? "srcu" : "križu"}.",
                              ),
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
                                                              child:
                                                                  Image.asset(
                                                                "assets/tarok${entry.value.asset}.webp",
                                                              ),
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
                            if (controller.zaruf.value)
                              const Text(
                                  "Uf, tole pa bo zaruf. Če izbereš kralja in ga uspešno pripelješ čez, dobiš še preostanek talona in v primeru, da je v talonu mond, ne pišeš -21 dol."),
                            ElevatedButton(
                              onPressed: () {
                                controller.showTalon.value = false;
                              },
                              child: const Text(
                                "Skrij talon",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
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
                              const Text(
                                "Trenutno si zalagate naslednje karte.",
                              ),
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
                                    child: const Text(
                                      "Potrdi",
                                    ),
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
                                    child: const Text(
                                      "Zamenjaj karte",
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
                                    !controller.requestedGameEnd.value)
                                  ElevatedButton(
                                      onPressed: () async =>
                                          await controller.gameStartEarly(),
                                      child: const Text("Takoj naprej")),
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
                                        columns: const <DataColumn>[
                                          DataColumn(
                                            label: Expanded(
                                              child: Text(
                                                'Napoved',
                                                style: TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Expanded(
                                              child: Text(
                                                'Kontra',
                                                style: TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Expanded(
                                              child: Text(
                                                'Rezultat',
                                                style: TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Expanded(
                                              child: Text(
                                                'Napovedal',
                                                style: TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Expanded(
                                              child: Text(
                                                'Kontro dal',
                                                style: TextStyle(
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
                                                const DataCell(Text('Igra')),
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
                                                const DataCell(Text('Razlika')),
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
                                                const DataCell(Text('Trula')),
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
                                                const DataCell(Text('Kralji')),
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
                                                const DataCell(
                                                    Text('Kralj ultimo')),
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
                                                const DataCell(
                                                    Text('Pagat ultimo')),
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
                                                const DataCell(
                                                    Text('Izguba monda')),
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
                                            const DataRow(
                                              cells: <DataCell>[
                                                DataCell(Text('Škisfang')),
                                                DataCell(Text('/')),
                                                DataCell(Text(
                                                  '-100',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                )),
                                                DataCell(Text("")),
                                                DataCell(Text("")),
                                              ],
                                            ),
                                          DataRow(
                                            cells: <DataCell>[
                                              const DataCell(Text('Skupaj')),
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
                                    controller.canExtendGame.value)
                                  const SizedBox(height: 20),
                                if ((controller.gamesPlayed.value ==
                                            controller.gamesRequired.value ||
                                        controller.gamesRequired.value == -1) &&
                                    controller.canExtendGame.value)
                                  DataTable(
                                    dataRowMaxHeight: 40,
                                    dataRowMinHeight: 40,
                                    headingRowHeight: 40,
                                    columns: const <DataColumn>[
                                      DataColumn(
                                        label: Expanded(
                                          child: Text(
                                            'Igralec',
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Text(
                                            'Število dodatnih rund',
                                            style: TextStyle(
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
                                      ? const Text(
                                          "Skrij točkovanje po štihih",
                                        )
                                      : const Text(
                                          "Prikaži točkovanje po štihih",
                                        ),
                                ),

                                // pobrane karte v štihu
                                if (controller.razpriKarte.value)
                                  const Text("Pobrane karte:",
                                      style: TextStyle(fontSize: 30)),
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
                                                          controller.currentPredictions.value!
                                                                          .gamemode >=
                                                                      0 &&
                                                                  controller
                                                                          .currentPredictions
                                                                          .value!
                                                                          .gamemode <=
                                                                      5
                                                              ? (e.key == 0
                                                                  ? "Založeno"
                                                                  : e.key + 1 ==
                                                                          controller
                                                                              .results
                                                                              .value!
                                                                              .stih
                                                                              .length
                                                                      ? "Talon"
                                                                      : "${e.key}. štih")
                                                              : (controller
                                                                          .currentPredictions
                                                                          .value!
                                                                          .gamemode ==
                                                                      -1
                                                                  ? "${e.key + 1}. štih"
                                                                  : (e.key + 1 ==
                                                                          controller
                                                                              .results
                                                                              .value!
                                                                              .stih
                                                                              .length
                                                                      ? "Talon"
                                                                      : "${e.key + 1}. štih")),
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
                                                        Text(
                                                          "Štih je vreden ${e.value.worth.round()} ${e.value.worth == 3 || e.value.worth == 4 ? 'točke' : e.value.worth == 2 ? 'točki' : e.value.worth == 1 ? 'točko' : 'točk'}.",
                                                        ),
                                                        if (e.value
                                                                .pickedUpBy !=
                                                            "")
                                                          Text(
                                                            "Štih je pobral ${e.value.pickedUpBy}.",
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
                                  child: const Text(
                                    "Zapri vpogled v rezultate",
                                  ),
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
                              const Text(
                                "Hvala za igro",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              DataTable(
                                dataRowMaxHeight: 40,
                                dataRowMinHeight: 40,
                                headingRowHeight: 40,
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Igralec',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Rezultat',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Rating',
                                        style: TextStyle(
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
                                          const DataCell(Text(
                                            "+0",
                                            style: TextStyle(
                                              color: 0 < 0
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
      floatingActionButton: Obx(
        () => (!(controller.started.value && !controller.bots) ||
                controller.replay)
            ? FloatingActionButton(
                onPressed: () {
                  try {
                    controller.socket.close(1000, 'CLOSE_NORMAL');
                  } catch (e) {}
                  Navigator.pop(context);
                },
                tooltip: 'Zapusti igro',
                child: const Icon(Icons.close),
              )
            : const SizedBox(),
      ),
    );
  }
}
