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
import 'package:get/get.dart';
import 'package:tarok/tms/rounds/rounds_controller.dart';
import 'package:tarok/ui/main_page.dart';

class Rounds extends StatelessWidget {
  const Rounds({super.key});

  @override
  Widget build(BuildContext context) {
    RoundsController controller = Get.put(RoundsController());

    final fullHeight = MediaQuery.of(context).size.height;
    final fullWidth = MediaQuery.of(context).size.width;

    return PalckaHome(
      floatingActionButton: FloatingActionButton(
        onPressed: controller.newRoundDialog,
        tooltip: "new_round".tr,
        child: const Icon(Icons.add),
      ),
      automaticallyImplyLeading: true,
      child: Obx(
        () {
          final border = (fullWidth / 800);
          final popupCardSize = fullHeight / 4;

          return Container(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: ListView(
              children: <Widget>[
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "rounds".tr,
                  style: const TextStyle(fontSize: 30),
                ),
                ...controller.rounds.map((e) => Card(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${e.roundId}. ${'round'.tr} (${e.time}s)",
                                style: const TextStyle(fontSize: 30),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      await controller
                                          .clearTournamentCards(e.id);
                                    },
                                    child: Text("clear_round_cards".tr),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await controller.reshuffleCards(e.id);
                                    },
                                    child: Text("reshuffle_cards".tr),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await controller.deleteRound(e.id);
                                    },
                                    child: Text("delete_round".tr),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SegmentedButton<Cards>(
                                segments: <ButtonSegment<Cards>>[
                                  ButtonSegment<Cards>(
                                    value: Cards.person1,
                                    label: Text("person_1".tr),
                                    icon: const Icon(Icons.person),
                                  ),
                                  ButtonSegment<Cards>(
                                    value: Cards.person2,
                                    label: Text("person_2".tr),
                                    icon: const Icon(Icons.person_2),
                                  ),
                                  ButtonSegment<Cards>(
                                    value: Cards.person3,
                                    label: Text("person_3".tr),
                                    icon: const Icon(Icons.person_3),
                                  ),
                                  ButtonSegment<Cards>(
                                    value: Cards.person4,
                                    label: Text("person_4".tr),
                                    icon: const Icon(Icons.person_4),
                                  ),
                                  ButtonSegment<Cards>(
                                    value: Cards.talon,
                                    label: Text("talon".tr),
                                    icon: const Icon(Icons.casino),
                                  ),
                                ],
                                selected: <Cards>{e.selectedDeck.value},
                                onSelectionChanged: (Set<Cards> newSelection) {
                                  e.selectedDeck.value = newSelection.first;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              if ((e.selectedDeck.value == Cards.talon &&
                                      e.talon.length < 6) ||
                                  (e.selectedDeck.value != Cards.talon &&
                                      e.cards[e.selectedDeck.value.index]
                                              .length <
                                          12))
                                DropdownMenu<String>(
                                  initialSelection: e.availableCards.first,
                                  onSelected: (String? value) async {
                                    debugPrint(
                                        "Selected card, adding to round $value");
                                    if (value == null) return;
                                    await controller.addCard(
                                      e.id,
                                      value,
                                      e.selectedDeck.value == Cards.talon
                                          ? -1
                                          : e.selectedDeck.value.index + 1,
                                    );
                                  },
                                  dropdownMenuEntries: e.availableCards
                                      .map<DropdownMenuEntry<String>>(
                                          (String value) {
                                    return DropdownMenuEntry<String>(
                                        value: value, label: value);
                                  }).toList(),
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: popupCardSize * 1.1,
                                width: popupCardSize *
                                    0.57 *
                                    1.1 *
                                    (e.selectedDeck.value == Cards.talon
                                        ? 6
                                        : 12),
                                child: Stack(
                                  children: [
                                    ...(e.selectedDeck.value == Cards.talon
                                            ? e.talon
                                            : e.cards[
                                                e.selectedDeck.value.index])
                                        .asMap()
                                        .entries
                                        .map(
                                          (card) => Positioned(
                                            left: popupCardSize *
                                                1.1 *
                                                card.key *
                                                0.7 *
                                                0.57,
                                            child: GestureDetector(
                                              onTap: () async {
                                                await controller.deleteCard(
                                                  e.id,
                                                  card.value,
                                                  e.selectedDeck.value.index +
                                                      1,
                                                );
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10 * border),
                                                child: SizedBox(
                                                  height: popupCardSize * 1.1,
                                                  width: popupCardSize *
                                                      0.57 *
                                                      1.1,
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        color: Colors.white,
                                                        height:
                                                            popupCardSize * 1.1,
                                                        width: popupCardSize *
                                                            0.57 *
                                                            1.1,
                                                      ),
                                                      Image.asset(
                                                          "assets/tarok${card.value}.webp"),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ]),
                      ),
                    )),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
