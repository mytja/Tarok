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

import 'package:get/get.dart';
import 'package:stockskis/stockskis.dart' as stockskis;

String name = "player".tr;

List<stockskis.LocalCard> sortCardsToUser(List<stockskis.LocalCard> cards) {
  List<stockskis.LocalCard> piki = [];
  List<stockskis.LocalCard> kare = [];
  List<stockskis.LocalCard> srci = [];
  List<stockskis.LocalCard> krizi = [];
  List<stockskis.LocalCard> taroki = [];
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

List<String> sortStringCards(List<String> cards) {
  List<String> piki = [];
  List<String> kare = [];
  List<String> srci = [];
  List<String> krizi = [];
  List<String> taroki = [];
  for (int i = 0; i < cards.length; i++) {
    final card = cards[i];
    if (card.contains("taroki")) taroki.add(card);
    if (card.contains("kriz")) krizi.add(card);
    if (card.contains("src")) srci.add(card);
    if (card.contains("kara")) kare.add(card);
    if (card.contains("pik")) piki.add(card);
  }
  piki.sort((a, b) => stockskis.CARDS_MAP[a]!.worthOver
      .compareTo(stockskis.CARDS_MAP[b]!.worthOver));
  kare.sort((a, b) => stockskis.CARDS_MAP[a]!.worthOver
      .compareTo(stockskis.CARDS_MAP[b]!.worthOver));
  srci.sort((a, b) => stockskis.CARDS_MAP[a]!.worthOver
      .compareTo(stockskis.CARDS_MAP[b]!.worthOver));
  krizi.sort((a, b) => stockskis.CARDS_MAP[a]!.worthOver
      .compareTo(stockskis.CARDS_MAP[b]!.worthOver));
  taroki.sort((a, b) => stockskis.CARDS_MAP[a]!.worthOver
      .compareTo(stockskis.CARDS_MAP[b]!.worthOver));
  return [...piki, ...kare, ...srci, ...krizi, ...taroki];
}
