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

import 'dart:math';

import 'package:media_kit/media_kit.dart';
import 'package:tarok/constants.dart';

bool SOUNDS_ENABLED = true;

class Sounds {
  static Future<void> card() async {
    if (!SOUNDS_ENABLED) {
      return;
    }
    int r = Random().nextInt(2);
    final Media playable;
    if (r == 0) {
      playable = Media('asset:///assets/zvoki/karta.ogg');
    } else {
      playable = Media('asset:///assets/zvoki/karta2.mp3');
    }
    await player.open(playable);
  }

  static Future<void> click() async {
    if (!SOUNDS_ENABLED) {
      return;
    }
    final playable = Media('asset:///assets/zvoki/click1.wav');
    await player.open(playable);
  }

  static Future<void> inviteNotification() async {
    if (!SOUNDS_ENABLED) {
      return;
    }
    final playable = Media('asset:///assets/zvoki/notification1.mp3');
    await player.open(playable);
  }
}
