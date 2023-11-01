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

import 'package:flutter/material.dart';
import 'package:rounded_background_text/rounded_background_text.dart';
import 'package:stockskis/stockskis.dart' as stockskis;

class UserTimer extends StatefulWidget {
  const UserTimer(
      {super.key,
      required this.user,
      required this.userSquareSize,
      required this.timerOn});

  final stockskis.SimpleUser user;
  final double userSquareSize;
  final bool timerOn;

  @override
  State<UserTimer> createState() => _UserTimerState();
}

class _UserTimerState extends State<UserTimer> {
  double t = 0;

  void countdownUserTimer() async {
    t = widget.user.timer;
    if (!widget.timerOn) return;
    /*Timer.periodic(const Duration(milliseconds: 100), (timer) {
      t -= 0.1;
      t = (t * 10).roundToDouble() / 10;
      if (t < 0) {
        timer.cancel();
        return;
      }
      t = max(t, 0);
      try {
        setState(() {});
      } catch (e) {}
    });*/
  }

  @override
  void didUpdateWidget(UserTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    //print("didUpdateWidget called on UserTimer");
    countdownUserTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.userSquareSize * 0.7,
      left: 10,
      child: SizedBox(
        height: widget.userSquareSize,
        width: widget.userSquareSize,
        child: RoundedBackgroundText(
          t < 0 ? "0.00" : t.toStringAsFixed(2),
          style: const TextStyle(color: Colors.white),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}
