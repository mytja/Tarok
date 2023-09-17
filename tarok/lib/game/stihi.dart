import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tarok/constants.dart';
import 'package:tarok/game/variables.dart';

List<Widget> stihi3(
  double cardK,
  double m,
  double center,
  double leftFromTop,
  double cardToWidth,
  double fullWidth,
) {
  BorderRadius radius = BorderRadius.circular(10 * (fullWidth / 1000));
  double cardHeight = m * cardK;
  double cardWidth = cardHeight * 0.57;

  List<Widget> widgets = [];
  for (int i = 0; i < stih.length; i++) {
    CardWidget e = stih[i];
    if (e.position == 0) {
      widgets.add(
        AnimatedPositioned(
          duration: const Duration(milliseconds: ANIMATION_TIME),
          top: stihBoolValues[0] != true
              ? leftFromTop - (cardHeight * 0.5) - 100
              : leftFromTop - (cardHeight * 0.5),
          left: stihBoolValues[0] != true
              ? cardToWidth - cardHeight / 3 - 100
              : cardToWidth - cardHeight / 3,
          height: cardHeight,
          child: AnimatedRotation(
            duration: const Duration(milliseconds: ANIMATION_TIME),
            turns: stihBoolValues[0] != true ? 0.35 : 0.35 + e.angle,
            child: ClipRRect(
              borderRadius: radius,
              child: Stack(
                children: [
                  Container(
                    color: Colors.white,
                    height: cardHeight,
                    width: cardWidth,
                  ),
                  e.widget,
                ],
              ),
            ),
          ),
        ),
      );
      continue;
    }
    if (e.position == 1) {
      widgets.add(
        AnimatedPositioned(
          duration: const Duration(milliseconds: ANIMATION_TIME),
          top: stihBoolValues[1] != true
              ? leftFromTop - (cardHeight * 0.5) - 100
              : leftFromTop - (cardHeight * 0.5),
          left: stihBoolValues[1] != true
              ? cardToWidth + cardHeight / 3 + 100
              : cardToWidth + cardHeight / 3,
          height: cardHeight,
          child: AnimatedRotation(
            duration: const Duration(milliseconds: ANIMATION_TIME),
            turns: stihBoolValues[1] != true ? -0.35 : -0.35 + e.angle,
            child: ClipRRect(
              borderRadius: radius,
              child: Stack(
                children: [
                  Container(
                    color: Colors.white,
                    height: cardHeight,
                    width: cardWidth,
                  ),
                  e.widget,
                ],
              ),
            ),
          ),
        ),
      );
      continue;
    }
    if (e.position == 100) {
      widgets.add(
        Positioned(
          top: leftFromTop,
          left: cardToWidth,
          height: cardHeight,
          child: Transform.rotate(
            angle: pi / 3,
            child: ClipRRect(
              borderRadius: radius,
              child: Stack(
                children: [
                  Container(
                    color: Colors.white,
                    height: cardHeight,
                    width: cardWidth,
                  ),
                  e.widget,
                ],
              ),
            ),
          ),
        ),
      );
      continue;
    }
    widgets.add(
      AnimatedPositioned(
        duration: const Duration(milliseconds: ANIMATION_TIME),
        top: stihBoolValues[3] != true
            ? leftFromTop + (cardHeight * 0.5) + 100
            : leftFromTop + (cardHeight * 0.5) * 0.7,
        left: cardToWidth,
        height: cardHeight,
        child: AnimatedRotation(
          duration: const Duration(milliseconds: ANIMATION_TIME),
          turns: stihBoolValues[3] != true ? 0 : 0 + e.angle,
          child: ClipRRect(
            borderRadius: radius,
            child: Stack(
              children: [
                Container(
                  color: Colors.white,
                  height: cardHeight,
                  width: cardWidth,
                ),
                e.widget,
              ],
            ),
          ),
        ),
      ),
    );
  }
  return widgets;
}

List<Widget> stihi4(
  double cardK,
  double m,
  double center,
  double leftFromTop,
  double cardToWidth,
  double fullWidth,
) {
  BorderRadius radius = BorderRadius.circular(10 * (fullWidth / 1000));
  double cardHeight = m * cardK;
  double cardWidth = cardHeight * 0.57;

  List<Widget> widgets = [];
  for (int i = 0; i < stih.length; i++) {
    CardWidget e = stih[i];
    if (e.position == 0) {
      widgets.add(
        AnimatedPositioned(
          duration: const Duration(milliseconds: ANIMATION_TIME),
          top: leftFromTop,
          left: stihBoolValues[0] != true ? 0 : center,
          height: cardHeight,
          child: AnimatedRotation(
            duration: const Duration(milliseconds: ANIMATION_TIME),
            turns: stihBoolValues[0] != true ? 0.2 : 0.25 + e.angle,
            child: ClipRRect(
              borderRadius: radius,
              child: Stack(
                children: [
                  Container(
                    color: Colors.white,
                    height: cardHeight,
                    width: cardWidth,
                  ),
                  e.widget,
                ],
              ),
            ),
          ),
        ),
      );
      continue;
    }
    if (e.position == 1) {
      widgets.add(
        AnimatedPositioned(
          duration: const Duration(milliseconds: ANIMATION_TIME),
          top: stihBoolValues[1] != true
              ? leftFromTop - (cardHeight * 0.5) - 100
              : leftFromTop - (cardHeight * 0.5),
          left: cardToWidth,
          height: cardHeight,
          child: AnimatedRotation(
            duration: const Duration(milliseconds: ANIMATION_TIME),
            turns: stihBoolValues[1] != true ? 0 : e.angle,
            child: ClipRRect(
              borderRadius: radius,
              child: Stack(
                children: [
                  Container(
                    color: Colors.white,
                    height: cardHeight,
                    width: cardWidth,
                  ),
                  e.widget,
                ],
              ),
            ),
          ),
        ),
      );
      continue;
    }
    if (e.position == 2) {
      widgets.add(
        AnimatedPositioned(
          duration: const Duration(milliseconds: ANIMATION_TIME),
          top: leftFromTop,
          left: stihBoolValues[2] != true
              ? center + cardHeight + 100
              : center + cardHeight,
          height: cardHeight,
          child: AnimatedRotation(
            duration: const Duration(milliseconds: ANIMATION_TIME),
            turns: stihBoolValues[2] != true ? 0.25 : 0.25 + e.angle,
            child: ClipRRect(
              borderRadius: radius,
              child: Stack(
                children: [
                  Container(
                    color: Colors.white,
                    height: cardHeight,
                    width: cardWidth,
                  ),
                  e.widget,
                ],
              ),
            ),
          ),
        ),
      );
      continue;
    }
    if (e.position == 100) {
      widgets.add(
        Positioned(
          top: leftFromTop,
          left: cardToWidth,
          height: cardHeight,
          child: Transform.rotate(
            angle: pi / 4,
            child: ClipRRect(
              borderRadius: radius,
              child: Stack(
                children: [
                  Container(
                    color: Colors.white,
                    height: cardHeight,
                    width: cardWidth,
                  ),
                  e.widget,
                ],
              ),
            ),
          ),
        ),
      );
      continue;
    }
    widgets.add(
      AnimatedPositioned(
        duration: const Duration(milliseconds: ANIMATION_TIME),
        top: stihBoolValues[3] != true
            ? leftFromTop + (cardHeight * 0.5) + 100
            : leftFromTop + (cardHeight * 0.5),
        left: cardToWidth,
        height: cardHeight,
        child: AnimatedRotation(
          duration: const Duration(milliseconds: ANIMATION_TIME),
          turns: stihBoolValues[3] != true ? 0 : e.angle,
          child: ClipRRect(
            borderRadius: radius,
            child: Stack(
              children: [
                Container(
                  color: Colors.white,
                  height: cardHeight,
                  width: cardWidth,
                ),
                e.widget,
              ],
            ),
          ),
        ),
      ),
    );
  }
  return widgets;
}
