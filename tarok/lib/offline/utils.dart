import 'package:tarok/game/variables.dart';

int afterPlayer() {
  for (int i = 0; i < stockskisContext!.userPositions.length; i++) {
    if (stockskisContext!.userPositions[i] == "player") {
      if (i == stockskisContext!.userPositions.length - 1) {
        return 0;
      } else {
        return i + 1;
      }
    }
  }
  return 0;
}

int getPlayedGame() {
  int m = -1;
  for (int i = 0; i < users.length; i++) {
    if (m < users[i].licitiral) {
      m = users[i].licitiral;
      stockskisContext!.users[users[i].id]!.playing = true;
      stockskisContext!.users[users[i].id]!.secretlyPlaying = true;
      stockskisContext!.users[users[i].id]!.licitiral = true;
      stockskisContext!.gamemode = m;
      currentPredictions!.gamemode = m;
      return m;
    }
  }
  return m;
}
