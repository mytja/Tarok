import 'dart:math';

import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({super.key, required this.cards});

  final List<String> cards;

  @override
  Widget build(BuildContext context) {
    final fullHeight = MediaQuery.of(context).size.height;
    final popupCardSize = max(70, fullHeight * 0.1);
    final border = popupCardSize * 0.008;

    return SizedBox(
      width: (popupCardSize * 0.8 * 1.1 * (cards.length - 1) +
              popupCardSize * 1.1) *
          0.57,
      height: popupCardSize * 1.1,
      child: Stack(
        children: [
          ...cards.asMap().entries.map(
                (king) => Positioned(
                  left: popupCardSize * 1.1 * king.key * 0.8 * 0.57,
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10 * border),
                            child: SizedBox(
                              height: popupCardSize * 1.1,
                              width: popupCardSize * 0.57 * 1.1,
                              child: Stack(
                                children: [
                                  Container(
                                    color: Colors.white,
                                    height: popupCardSize * 1.1,
                                    width: popupCardSize * 0.57 * 1.1,
                                  ),
                                  Center(
                                    child: Image.asset(
                                      "assets/tarok${king.value}.webp",
                                      height: popupCardSize * 1.1,
                                      width: popupCardSize * 0.57 * 1.1,
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
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
