import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:media_kit/media_kit.dart';
import 'package:tarok/constants.dart';

class Sounds {
  static Future<void> card() async {
    int r = Random().nextInt(2);
    final Media playable;
    if (r == 0) {
      playable = Media('${kIsWeb ? "assets/" : ""}assets/zvoki/karta.ogg');
    } else {
      playable = Media('${kIsWeb ? "assets/" : ""}assets/zvoki/karta2.mp3');
    }
    await player.open(playable);
  }

  static Future<void> click() async {
    final playable = Media('${kIsWeb ? "assets/" : ""}assets/zvoki/click1.wav');
    await player.open(playable);
  }
}
