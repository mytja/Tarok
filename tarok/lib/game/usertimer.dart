import 'package:tarok/game/variables.dart';

void countdownUserTimer(String userId, Function setState) {
  for (int i = 0; i < userWidgets.length; i++) {
    if (userWidgets[i].id != userId) continue;
    userWidgets[i].timerOn = true;
    break;
  }
  setState(() {});
}
