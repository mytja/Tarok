import 'dart:math';

import 'package:flutter/material.dart' hide Card;
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:rounded_background_text/rounded_background_text.dart';
import 'package:stockskis/stockskis.dart';
import 'package:tarok/constants.dart';
import 'package:tarok/game/variables.dart';
import 'package:tarok/timer.dart';

bool kartePogoj(int i) {
  return (ODPRTE_IGRE && bots) ||
      userWidgets[i].cards.isNotEmpty ||
      (bots &&
          !predictions &&
          currentPredictions!.gamemode == 8 &&
          userWidgets[i].id == currentPredictions!.igra.id);
}

List<Card> pridobiKarte(int i) {
  return userWidgets[i].cards.isNotEmpty
      ? userWidgets[i].cards
      : stockskisContext!.users[userWidgets[i].id]!.cards;
}

List<Widget> generateNames3(
  double leftFromTop,
  double m,
  double cardK,
  double userSquareSize,
  double fullWidth,
  double fullHeight,
) {
  List<Widget> widgets = [];

  if (userWidgets.isEmpty) {
    return widgets;
  }

  if (currentPredictions == null) {
    return widgets;
  }

  final miniCardHeight = fullHeight / 7;
  final miniCardWidth = miniCardHeight * 0.57;

  widgets.add(
    Positioned(
      top: 10,
      left: fullWidth * 0.15 - userSquareSize / 2,
      height: userSquareSize,
      width: userSquareSize,
      child: Stack(
        children: [
          SizedBox(
            height: userSquareSize,
            width: userSquareSize,
            child: Initicon(
              text: userWidgets[0].name,
              elevation: 4,
              backgroundColor: HSLColor.fromAHSL(
                      1, hashCode(userWidgets[0].name) % 360, 1, 0.6)
                  .toColor(),
              borderRadius: BorderRadius.zero,
            ),
          ),
          if (!userWidgets[0].connected)
            Container(
              height: userSquareSize,
              width: userSquareSize,
              color: Colors.black.withAlpha(200),
            ),
          Positioned(
            top: 5,
            left: 10,
            child: SizedBox(
              height: userSquareSize,
              width: userSquareSize,
              child: RoundedBackgroundText(
                userWidgets[0].name,
                style: const TextStyle(color: Colors.white),
                backgroundColor: Colors.black,
              ),
            ),
          ),
          UserTimer(
            user: userWidgets[0],
            userSquareSize: userSquareSize,
            timerOn: userWidgets[0].timerOn,
          ),
        ],
      ),
    ),
  );

  if (currentPredictions!.igra.id == userWidgets[0].id) {
    widgets.add(
      Positioned(
        top: 10,
        left: fullWidth * 0.15 + userSquareSize / 2,
        child: Container(
          height: userSquareSize / 2,
          width: userSquareSize / 2,
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              color: zaruf ? Colors.red : Colors.black,
            ),
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(20),
            ),
          ),
          child: Center(
            child: Text(
              GAME_DESC[currentPredictions!.gamemode + 1],
              style: TextStyle(
                fontSize: 0.3 * userSquareSize,
              ),
            ),
          ),
        ),
      ),
    );
  }

  if (kartePogoj(0)) {
    widgets.addAll(
      pridobiKarte(0).asMap().entries.map(
            (e) => Positioned(
              top: e.key * (miniCardWidth * 0.5) - 10,
              child: Transform.rotate(
                angle: -pi / 2,
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      width: miniCardWidth,
                      height: miniCardHeight,
                    ),
                    SizedBox(
                      height: miniCardHeight,
                      child: Image.asset(
                        "assets/tarok${e.value.card.asset}.webp",
                        filterQuality: FilterQuality.medium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  if (userWidgets.length < 2) {
    return widgets;
  }

  widgets.add(
    Positioned(
      top: 10,
      left: fullWidth * 0.55 - userSquareSize / 2,
      child: Stack(
        children: [
          SizedBox(
            height: userSquareSize,
            width: userSquareSize,
            child: Initicon(
              text: userWidgets[1].name,
              elevation: 4,
              borderRadius: BorderRadius.zero,
              backgroundColor: HSLColor.fromAHSL(
                      1, hashCode(userWidgets[1].name) % 360, 1, 0.6)
                  .toColor(),
            ),
          ),
          if (!userWidgets[1].connected)
            Container(
              height: userSquareSize,
              width: userSquareSize,
              color: Colors.black.withAlpha(200),
            ),
          Positioned(
            top: 5,
            left: 10,
            child: SizedBox(
              height: userSquareSize,
              width: userSquareSize,
              child: RoundedBackgroundText(
                userWidgets[1].name,
                style: const TextStyle(color: Colors.white),
                backgroundColor: Colors.black,
              ),
            ),
          ),
          UserTimer(
            user: userWidgets[1],
            userSquareSize: userSquareSize,
            timerOn: userWidgets[1].timerOn,
          ),
        ],
      ),
    ),
  );

  if (currentPredictions!.igra.id == userWidgets[1].id) {
    widgets.add(
      Positioned(
        top: 10,
        left: fullWidth * 0.55 + userSquareSize / 2,
        child: Container(
          height: userSquareSize / 2,
          width: userSquareSize / 2,
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              color: zaruf ? Colors.red : Colors.black,
            ),
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(20),
            ),
          ),
          child: Center(
            child: Text(
              GAME_DESC[currentPredictions!.gamemode + 1],
              style: TextStyle(
                fontSize: 0.3 * userSquareSize,
              ),
            ),
          ),
        ),
      ),
    );
  }

  if (kartePogoj(1)) {
    widgets.addAll(
      pridobiKarte(1).asMap().entries.map(
            (e) => Positioned(
              top: e.key * (miniCardWidth * 0.5) - 10,
              right: fullWidth * 0.3,
              child: Transform.rotate(
                angle: pi / 2,
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      width: miniCardWidth,
                      height: miniCardHeight,
                    ),
                    SizedBox(
                      height: miniCardHeight,
                      child: Image.asset(
                        "assets/tarok${e.value.card.asset}.webp",
                        filterQuality: FilterQuality.medium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  return widgets;
}

List<Widget> generateNames4(
  double leftFromTop,
  double m,
  double cardK,
  double userSquareSize,
  double fullWidth,
  double fullHeight,
) {
  List<Widget> widgets = [];

  if (userWidgets.isEmpty) {
    return widgets;
  }

  if (currentPredictions == null) {
    return widgets;
  }

  final miniCardHeight = fullHeight / 7;
  final miniCardWidth = miniCardHeight * 0.57;

  widgets.add(
    Positioned(
      top: leftFromTop + (m * cardK * 0.5) - userSquareSize / 2,
      left: 10,
      height: userSquareSize,
      width: userSquareSize,
      child: Stack(
        children: [
          SizedBox(
            height: userSquareSize,
            width: userSquareSize,
            child: Initicon(
              text: userWidgets[0].name,
              elevation: 4,
              backgroundColor: HSLColor.fromAHSL(
                      1, hashCode(userWidgets[0].name) % 360, 1, 0.6)
                  .toColor(),
              borderRadius: BorderRadius.zero,
            ),
          ),
          if (!userWidgets[0].connected)
            Container(
              height: userSquareSize,
              width: userSquareSize,
              color: Colors.black.withAlpha(200),
            ),
          Positioned(
            top: 5,
            left: 10,
            child: SizedBox(
              height: userSquareSize,
              width: userSquareSize,
              child: RoundedBackgroundText(
                userWidgets[0].name,
                style: const TextStyle(color: Colors.white),
                backgroundColor: Colors.black,
              ),
            ),
          ),
          UserTimer(
            user: userWidgets[0],
            userSquareSize: userSquareSize,
            timerOn: userWidgets[0].timerOn,
          ),
        ],
      ),
    ),
  );

  if (currentPredictions!.igra.id == userWidgets[0].id) {
    widgets.add(
      Positioned(
        top: leftFromTop + (m * cardK * 0.5) - userSquareSize / 2,
        left: 10 + userSquareSize,
        child: Container(
          height: userSquareSize / 2,
          width: userSquareSize / 2,
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              color: zaruf ? Colors.red : Colors.black,
            ),
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(20),
            ),
          ),
          child: Center(
            child: Text(
              GAME_DESC[currentPredictions!.gamemode + 1],
              style: TextStyle(
                fontSize: 0.3 * userSquareSize,
              ),
            ),
          ),
        ),
      ),
    );
  }

  if (userHasKing == userWidgets[0].id ||
      (currentPredictions!.igra.id == userWidgets[0].id &&
          selectedKing != "")) {
    widgets.add(
      Positioned(
        top: leftFromTop + (m * cardK * 0.5),
        left: 10 + userSquareSize,
        child: Container(
          height: userSquareSize / 2,
          width: userSquareSize / 2,
          decoration: BoxDecoration(
            color: selectedKing == "/pik/kralj" || selectedKing == "/kriz/kralj"
                ? Colors.black
                : Colors.red,
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(20),
            ),
          ),
          child: Center(
            child: Text(
                selectedKing == "/pik/kralj"
                    ? "♠️"
                    : (selectedKing == "/src/kralj"
                        ? "❤️"
                        : (selectedKing == "/kriz/kralj" ? "♣️" : "♦️")),
                style: TextStyle(fontSize: 0.3 * userSquareSize)),
          ),
        ),
      ),
    );
  }

  if (kartePogoj(0)) {
    widgets.addAll(
      pridobiKarte(0).asMap().entries.map(
            (e) => Positioned(
              top: e.key * (miniCardWidth * 0.5) - 10,
              child: Transform.rotate(
                angle: -pi / 2,
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      width: miniCardWidth,
                      height: miniCardHeight,
                    ),
                    SizedBox(
                      height: miniCardHeight,
                      child: Image.asset(
                        "assets/tarok${e.value.card.asset}.webp",
                        filterQuality: FilterQuality.medium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  if (userWidgets.length < 2) {
    return widgets;
  }

  widgets.add(
    Positioned(
      top: 10,
      left: fullWidth * 0.35 - userSquareSize / 2,
      child: Stack(
        children: [
          SizedBox(
            height: userSquareSize,
            width: userSquareSize,
            child: Initicon(
              text: userWidgets[1].name,
              elevation: 4,
              borderRadius: BorderRadius.zero,
              backgroundColor: HSLColor.fromAHSL(
                      1, hashCode(userWidgets[1].name) % 360, 1, 0.6)
                  .toColor(),
            ),
          ),
          if (!userWidgets[1].connected)
            Container(
              height: userSquareSize,
              width: userSquareSize,
              color: Colors.black.withAlpha(200),
            ),
          Positioned(
            top: 5,
            left: 10,
            child: SizedBox(
              height: userSquareSize,
              width: userSquareSize,
              child: RoundedBackgroundText(
                userWidgets[1].name,
                style: const TextStyle(color: Colors.white),
                backgroundColor: Colors.black,
              ),
            ),
          ),
          UserTimer(
            user: userWidgets[1],
            userSquareSize: userSquareSize,
            timerOn: userWidgets[1].timerOn,
          ),
        ],
      ),
    ),
  );

  if (currentPredictions!.igra.id == userWidgets[1].id) {
    widgets.add(
      Positioned(
        top: 10,
        left: fullWidth * 0.35 + userSquareSize / 2,
        child: Container(
          height: userSquareSize / 2,
          width: userSquareSize / 2,
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              color: zaruf ? Colors.red : Colors.black,
            ),
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(20),
            ),
          ),
          child: Center(
            child: Text(
              GAME_DESC[currentPredictions!.gamemode + 1],
              style: TextStyle(
                fontSize: 0.3 * userSquareSize,
              ),
            ),
          ),
        ),
      ),
    );
  }

  if (userHasKing == userWidgets[1].id ||
      (currentPredictions!.igra.id == userWidgets[1].id &&
          selectedKing != "")) {
    widgets.add(
      Positioned(
        top: 10 + userSquareSize / 2,
        left: fullWidth * 0.35 + userSquareSize / 2,
        child: Container(
          height: userSquareSize / 2,
          width: userSquareSize / 2,
          decoration: BoxDecoration(
            color: selectedKing == "/pik/kralj" || selectedKing == "/kriz/kralj"
                ? Colors.black
                : Colors.red,
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(20),
            ),
          ),
          child: Center(
            child: Text(
                selectedKing == "/pik/kralj"
                    ? "♠️"
                    : (selectedKing == "/src/kralj"
                        ? "❤️"
                        : (selectedKing == "/kriz/kralj" ? "♣️" : "♦️")),
                style: TextStyle(fontSize: 0.3 * userSquareSize)),
          ),
        ),
      ),
    );
  }

  if (kartePogoj(1)) {
    widgets.addAll(
      pridobiKarte(1).asMap().entries.map(
            (e) => Positioned(
              left: fullWidth * 0.35 +
                  userSquareSize +
                  10 +
                  e.key * (miniCardWidth * 0.5),
              child: Transform.rotate(
                angle: 0,
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      width: miniCardWidth,
                      height: miniCardHeight,
                    ),
                    SizedBox(
                      height: miniCardHeight,
                      child: Image.asset(
                        "assets/tarok${e.value.card.asset}.webp",
                        filterQuality: FilterQuality.medium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  if (userWidgets.length < 3) {
    return widgets;
  }

  widgets.add(
    Positioned(
      top: leftFromTop + (m * cardK * 0.5) - userSquareSize / 2,
      right: fullWidth * 0.3,
      child: Stack(
        children: [
          SizedBox(
            height: userSquareSize,
            width: userSquareSize,
            child: Initicon(
              text: userWidgets[2].name,
              elevation: 4,
              borderRadius: BorderRadius.zero,
              backgroundColor: HSLColor.fromAHSL(
                      1, hashCode(userWidgets[2].name) % 360, 1, 0.6)
                  .toColor(),
            ),
          ),
          if (!userWidgets[2].connected)
            Container(
              height: userSquareSize,
              width: userSquareSize,
              color: Colors.black.withAlpha(200),
            ),
          Positioned(
            top: 5,
            left: 10,
            child: SizedBox(
              height: userSquareSize,
              width: userSquareSize,
              child: RoundedBackgroundText(
                userWidgets[2].name,
                style: const TextStyle(color: Colors.white),
                backgroundColor: Colors.black,
              ),
            ),
          ),
          UserTimer(
            user: userWidgets[2],
            userSquareSize: userSquareSize,
            timerOn: userWidgets[2].timerOn,
          ),
        ],
      ),
    ),
  );

  if (currentPredictions!.igra.id == userWidgets[2].id) {
    widgets.add(
      Positioned(
        top: leftFromTop + (m * cardK * 0.5) - userSquareSize / 2,
        right: fullWidth * 0.3 - userSquareSize / 2,
        child: Container(
          height: userSquareSize / 2,
          width: userSquareSize / 2,
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              color: zaruf ? Colors.red : Colors.black,
            ),
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(20),
            ),
          ),
          child: Center(
            child: Text(
              GAME_DESC[currentPredictions!.gamemode + 1],
              style: TextStyle(
                fontSize: 0.3 * userSquareSize,
              ),
            ),
          ),
        ),
      ),
    );
  }

  if (userHasKing == userWidgets[2].id ||
      (currentPredictions!.igra.id == userWidgets[2].id &&
          selectedKing != "")) {
    widgets.add(
      Positioned(
        top: leftFromTop + (m * cardK * 0.5),
        right: fullWidth * 0.3 - userSquareSize / 2,
        child: Container(
          height: userSquareSize / 2,
          width: userSquareSize / 2,
          decoration: BoxDecoration(
            color: selectedKing == "/pik/kralj" || selectedKing == "/kriz/kralj"
                ? Colors.black
                : Colors.red,
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(20),
            ),
          ),
          child: Center(
            child: Text(
              selectedKing == "/pik/kralj"
                  ? "♠️"
                  : (selectedKing == "/src/kralj"
                      ? "❤️"
                      : (selectedKing == "/kriz/kralj" ? "♣️" : "♦️")),
              style: TextStyle(fontSize: 0.3 * userSquareSize),
            ),
          ),
        ),
      ),
    );
  }

  if (kartePogoj(2)) {
    widgets.addAll(
      pridobiKarte(2).asMap().entries.map(
            (e) => Positioned(
              top: e.key * (miniCardWidth * 0.5),
              right: fullWidth * 0.3,
              child: Transform.rotate(
                angle: pi / 2,
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      width: miniCardWidth,
                      height: miniCardHeight,
                    ),
                    SizedBox(
                      height: miniCardHeight,
                      child: Image.asset(
                        "assets/tarok${e.value.card.asset}.webp",
                        filterQuality: FilterQuality.medium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  return widgets;
}
