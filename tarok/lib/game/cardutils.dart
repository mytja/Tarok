import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:stockskis/stockskis.dart' hide debugPrint;
import 'package:tarok/game/variables.dart';

void validCards() {
  if (stash) {
    for (int i = 0; i < cards.length; i++) {
      cards[i].valid = cards[i].worth != 5;
    }
    return;
  }

  debugPrint(
    "Poklicana funkcija validCards, firstCard=${firstCard?.asset}, cardStih=$cardStih",
  );

  int gamemode = -1;
  for (int i = 0; i < users.length; i++) {
    SimpleUser user = users[i];
    gamemode = max(gamemode, user.licitiral);
  }
  int taroki = 0;
  bool imaBarvo = false;
  bool imaVecje = false;
  int maxWorthOver = 0;

  if (firstCard == null) {
    for (int i = 0; i < cards.length; i++) {
      cards[i].valid = true;
      if (gamemode == -1 || gamemode == 6 || gamemode == 8) {
        if (cards[i].asset == "/taroki/pagat" && cards.length != 1) {
          cards[i].valid = false;
        }
      }
    }
    return;
  }

  final color = firstCard!.asset.split("/")[1];
  for (int i = 0; i < cards.length; i++) {
    cards[i].valid = false;
    if (cards[i].asset.contains("taroki")) taroki++;
    if (cards[i].asset.contains(color)) imaBarvo = true;
  }

  int trula = 0;
  for (int i = 0; i < cardStih.length; i++) {
    String card = cardStih[i];
    if (card == "/taroki/mond" || card == "/taroki/skis") {
      trula++;
    }
  }

  if (trula == 2) {
    for (int i = 0; i < cards.length; i++) {
      if (cards[i].asset == "/taroki/pagat") {
        cards[i].valid = true;
        return;
      }
    }
  }

  for (int i = 0; i < CARDS.length; i++) {
    if (!cardStih.contains(CARDS[i].asset)) continue;
    if (imaBarvo && !CARDS[i].asset.contains(color)) continue;
    maxWorthOver = max(maxWorthOver, CARDS[i].worthOver);
  }

  for (int i = 0; i < cards.length; i++) {
    if (imaBarvo && !cards[i].asset.contains(color)) continue;
    if (cards[i].worthOver > maxWorthOver) imaVecje = true;
    if (imaVecje) break;
  }

  debugPrint(
      "taroki=$taroki imaBarvo=$imaBarvo imaVecje=$imaVecje maxWorthOver=$maxWorthOver gamemode=$gamemode cardStih=$cardStih color=$color");

  if (firstCard!.asset.contains("taroki")) {
    for (int i = 0; i < cards.length; i++) {
      if (gamemode == -1 || gamemode == 6 || gamemode == 8) {
        if (imaVecje && cards[i].worthOver < maxWorthOver) continue;
        if (cards[i].asset == "/taroki/pagat" && taroki > 1) continue;
        if (taroki != 0 && !cards[i].asset.contains("taroki")) continue;
        cards[i].valid = true;
      }
      if (taroki == 0 || cards[i].asset.contains("taroki")) {
        cards[i].valid = true;
      }
    }
  } else {
    for (int i = 0; i < cards.length; i++) {
      if ((!imaBarvo && taroki == 0) ||
          (!imaBarvo && taroki > 0 && cards[i].asset.contains("taroki")) ||
          (imaBarvo &&
              !cards[i].asset.contains("taroki") &&
              cards[i].asset.contains(color))) {
        // STANDARDNO
        // Sedaj pa za različne gamemode
        if (gamemode == -1 || gamemode == 6 || gamemode == 8) {
          if (imaBarvo || taroki > 0) {
            if (imaVecje && cards[i].worthOver < maxWorthOver) {
              continue;
            }
            if (cards[i].asset == "/taroki/pagat" && taroki > 1) continue;
          }
        }
        cards[i].valid = true;
      }
    }
  }
}

List<LocalCard> sortCardsToUser(List<LocalCard> cards) {
  List<LocalCard> piki = [];
  List<LocalCard> kare = [];
  List<LocalCard> srci = [];
  List<LocalCard> krizi = [];
  List<LocalCard> taroki = [];
  for (int i = 0; i < cards.length; i++) {
    final card = cards[i];
    if (card.asset.contains("taroki")) taroki.add(card);
    if (card.asset.contains("kriz")) krizi.add(card);
    if (card.asset.contains("src")) srci.add(card);
    if (card.asset.contains("kara")) kare.add(card);
    if (card.asset.contains("pik")) piki.add(card);
  }
  piki.sort((a, b) => a.worthOver.compareTo(b.worthOver));
  kare.sort((a, b) => a.worthOver.compareTo(b.worthOver));
  srci.sort((a, b) => a.worthOver.compareTo(b.worthOver));
  krizi.sort((a, b) => a.worthOver.compareTo(b.worthOver));
  taroki.sort((a, b) => a.worthOver.compareTo(b.worthOver));
  return [...piki, ...kare, ...srci, ...krizi, ...taroki];
}

void sortCards() {
  cards = sortCardsToUser(cards);
}
