import 'dart:math';

import 'package:flutter/material.dart' show Image;
import 'package:stockskis/stockskis.dart';
import 'package:tarok/constants.dart';
import 'package:tarok/game/variables.dart';

void klopTalon(Function setState) {
  if (stockskisContext!.gamemode == -1 && stockskisContext!.talon.isNotEmpty) {
    Card card = stockskisContext!.talon.first;
    stockskisContext!.talon.removeAt(0);
    card.user = "talon";
    stockskisContext!.stihi.last.add(card);
    cardStih.add(card.card.asset);
    stih.add(CardWidget(
      position: 100,
      widget: Image.asset("assets/tarok${card.card.asset}.webp"),
      angle: (Random().nextDouble() - 0.5) / ANGLE,
    ));
    setState(() {});
  }
}
