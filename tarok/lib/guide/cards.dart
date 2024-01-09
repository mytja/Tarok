import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockskis/stockskis.dart' as stockskis;

class CardsGuide extends StatelessWidget {
  const CardsGuide({super.key});

  @override
  Widget build(BuildContext context) {
    List<stockskis.LocalCard> kare = stockskis.CARDS.sublist(0, 8);
    List<stockskis.LocalCard> krizi = stockskis.CARDS.sublist(8, 16);
    List<stockskis.LocalCard> piki = stockskis.CARDS.sublist(16, 24);
    List<stockskis.LocalCard> srci = stockskis.CARDS.sublist(24, 32);
    List<stockskis.LocalCard> taroki = stockskis.CARDS.sublist(32, 40);
    List<stockskis.LocalCard> taroki2 = stockskis.CARDS.sublist(40, 48);
    List<stockskis.LocalCard> taroki3 = stockskis.CARDS.sublist(48);
    kare.sort((a, b) => a.worthOver.compareTo(b.worthOver));
    krizi.sort((a, b) => a.worthOver.compareTo(b.worthOver));
    piki.sort((a, b) => a.worthOver.compareTo(b.worthOver));
    srci.sort((a, b) => a.worthOver.compareTo(b.worthOver));
    taroki.sort((a, b) => a.worthOver.compareTo(b.worthOver));
    taroki2.sort((a, b) => a.worthOver.compareTo(b.worthOver));
    taroki3.sort((a, b) => a.worthOver.compareTo(b.worthOver));

    double k = 0.8;

    double width = MediaQuery.of(context).size.width;

    double cardHeight = min(width, 1000) * 0.13 * (1 / 0.57);
    double cardWidth = cardHeight * 0.57;

    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("cards".tr, style: const TextStyle(fontSize: 26)),
            Text("cards_guide_desc".tr),
            const SizedBox(
              height: 5,
            ),
            Text("diamonds".tr, style: const TextStyle(fontSize: 19)),
            SizedBox(
              width: cardWidth * kare.length,
              height: cardHeight,
              child: Stack(
                children: [
                  ...kare.asMap().entries.map(
                        (e) => Positioned(
                          top: 0,
                          left: cardWidth * k * e.key,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              height: cardHeight,
                              width: cardWidth,
                              child: Stack(
                                children: [
                                  Container(
                                    color: Colors.white,
                                    height: cardHeight,
                                    width: cardWidth,
                                  ),
                                  SizedBox(
                                    height: cardHeight,
                                    width: cardWidth,
                                    child: Image.asset(
                                      "assets/tarok${e.value.asset}.webp",
                                    ),
                                  ),
                                ],
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
            Text("spades".tr, style: const TextStyle(fontSize: 19)),
            SizedBox(
              width: cardWidth * piki.length,
              height: cardHeight,
              child: Stack(
                children: [
                  ...piki.asMap().entries.map(
                        (e) => Positioned(
                          top: 0,
                          left: cardWidth * k * e.key,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              height: cardHeight,
                              width: cardWidth,
                              child: Stack(
                                children: [
                                  Container(
                                    color: Colors.white,
                                    height: cardHeight,
                                    width: cardWidth,
                                  ),
                                  SizedBox(
                                    height: cardHeight,
                                    width: cardWidth,
                                    child: Image.asset(
                                      "assets/tarok${e.value.asset}.webp",
                                    ),
                                  ),
                                ],
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
            Text("hearts".tr, style: const TextStyle(fontSize: 19)),
            SizedBox(
              width: cardWidth * srci.length,
              height: cardHeight,
              child: Stack(
                children: [
                  ...srci.asMap().entries.map(
                        (e) => Positioned(
                          top: 0,
                          left: cardWidth * k * e.key,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              height: cardHeight,
                              width: cardWidth,
                              child: Stack(
                                children: [
                                  Container(
                                    color: Colors.white,
                                    height: cardHeight,
                                    width: cardWidth,
                                  ),
                                  SizedBox(
                                    height: cardHeight,
                                    width: cardWidth,
                                    child: Image.asset(
                                      "assets/tarok${e.value.asset}.webp",
                                    ),
                                  ),
                                ],
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
            Text("clubs".tr, style: const TextStyle(fontSize: 19)),
            SizedBox(
              width: cardWidth * krizi.length,
              height: cardHeight,
              child: Stack(
                children: [
                  ...krizi.asMap().entries.map(
                        (e) => Positioned(
                          top: 0,
                          left: cardWidth * k * e.key,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              height: cardHeight,
                              width: cardWidth,
                              child: Stack(
                                children: [
                                  Container(
                                    color: Colors.white,
                                    height: cardHeight,
                                    width: cardWidth,
                                  ),
                                  SizedBox(
                                    height: cardHeight,
                                    width: cardWidth,
                                    child: Image.asset(
                                      "assets/tarok${e.value.asset}.webp",
                                    ),
                                  ),
                                ],
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
            Text("tarocks".tr, style: const TextStyle(fontSize: 19)),
            SizedBox(
              width: cardWidth * taroki.length,
              height: cardHeight,
              child: Stack(
                children: [
                  ...taroki.asMap().entries.map(
                        (e) => Positioned(
                          top: 0,
                          left: cardWidth * k * e.key,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              height: cardHeight,
                              width: cardWidth,
                              child: Stack(
                                children: [
                                  Container(
                                    color: Colors.white,
                                    height: cardHeight,
                                    width: cardWidth,
                                  ),
                                  SizedBox(
                                    height: cardHeight,
                                    width: cardWidth,
                                    child: Image.asset(
                                      "assets/tarok${e.value.asset}.webp",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
            SizedBox(
              width: cardWidth * taroki2.length,
              height: cardHeight,
              child: Stack(
                children: [
                  ...taroki2.asMap().entries.map(
                        (e) => Positioned(
                          top: 0,
                          left: cardWidth * k * e.key,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              height: cardHeight,
                              width: cardWidth,
                              child: Stack(
                                children: [
                                  Container(
                                    color: Colors.white,
                                    height: cardHeight,
                                    width: cardWidth,
                                  ),
                                  SizedBox(
                                    height: cardHeight,
                                    width: cardWidth,
                                    child: Image.asset(
                                      "assets/tarok${e.value.asset}.webp",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
            SizedBox(
              width: cardWidth * taroki3.length,
              height: cardHeight,
              child: Stack(
                children: [
                  ...taroki3.asMap().entries.map(
                        (e) => Positioned(
                          top: 0,
                          left: cardWidth * k * e.key,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              height: cardHeight,
                              width: cardWidth,
                              child: Stack(
                                children: [
                                  Container(
                                    color: Colors.white,
                                    height: cardHeight,
                                    width: cardWidth,
                                  ),
                                  SizedBox(
                                    height: cardHeight,
                                    width: cardWidth,
                                    child: Image.asset(
                                      "assets/tarok${e.value.asset}.webp",
                                    ),
                                  ),
                                ],
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
            Text("tarocks_desc".tr),
            const SizedBox(
              height: 15,
            ),
            Text("general_card_play_rules".tr,
                style: const TextStyle(fontSize: 19)),
            Text("card_play_rules".tr),
            Text("mondfang_rule".tr),
            Text("pagat_picks".tr),
          ],
        ),
      ),
    );
  }
}
