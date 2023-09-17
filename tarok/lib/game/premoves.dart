import 'package:tarok/game/variables.dart';

void resetPremoves() {
  for (int i = 0; i < cards.length; i++) {
    cards[i].showZoom = false;
  }
}
