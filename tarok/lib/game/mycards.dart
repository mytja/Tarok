import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tarok/constants.dart';
import 'package:tarok/game/premoves.dart';
import 'package:tarok/game/variables.dart';

List<Widget> myCards(
  double cardSize,
  double fullWidth,
  double fullHeight,
  double cardWidth,
  Duration duration,
  Function setState,
) {
  List<Widget> widgets = [];
  for (int i = 0; i < cards.length; i++) {
    Widget w = Container(
      height: cardSize,
      transform: Matrix4.translationValues(
          i *
              min(
                fullWidth / (cards.length + 1),
                fullHeight * 0.15,
              ),
          (fullHeight - cardSize / 1.4),
          0),
      child: GestureDetector(
        onTap: () async {
          if (!turn && PREMOVE) {
            resetPremoves();
            premovedCard = cards[i];
            cards[i].showZoom = true;
            setState(() {});
            return;
          }
          if (!cards[i].valid) return;
          await ws.sendCard(cards[i]);
        },
        child: MouseRegion(
          onEnter: (event) {
            setState(() {
              if (i >= cards.length) return;
              cards[i].showZoom = true;
            });
          },
          onExit: (event) {
            setState(() {
              if (i >= cards.length) return;
              if (premovedCard != null &&
                  premovedCard!.asset == cards[i].asset) {
                return;
              }
              cards[i].showZoom = false;
            });
          },
          child: AnimatedScale(
            duration: duration,
            scale: cards[i].showZoom == true ? 1.4 : 1,
            child: Transform.rotate(
              angle: (pi / 90) * (i - (cards.length / 2).floor()),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10 * (fullWidth / 1000)),
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
                          "assets/tarok${cards[i].asset}.webp",
                        ),
                      ),
                    ),
                    if (!turn)
                      Container(
                        color: Colors.red.withAlpha(120),
                        height: cardSize,
                        width: cardWidth,
                      ),
                    if (turn && !cards[i].valid)
                      Container(
                        color: Colors.red.withAlpha(120),
                        height: cardSize,
                        width: cardWidth,
                      ),
                    if (turn &&
                            (currentPredictions != null &&
                                currentPredictions!.pagatUltimo.id != "" &&
                                cards[i].asset == "/taroki/pagat") ||
                        (currentPredictions != null &&
                            currentPredictions!.kraljUltimo.id != "" &&
                            cards[i].asset == selectedKing))
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
    );
    widgets.add(w);
  }

  widgets = [...widgets];

  return widgets;
}
