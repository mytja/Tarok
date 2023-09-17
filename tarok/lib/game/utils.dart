import 'dart:convert';

import 'package:stockskis/stockskis.dart';
import 'package:tarok/game/variables.dart';

bool isPlayerMandatory(String playerId) {
  return users.last.id == playerId;
}

SimpleUser getUserFromPosition(String userId) {
  for (int i = 0; i < users.length; i++) {
    if (users[i].id == userId) return users[i];
  }
  throw Exception("no user was found");
}

void removeInvalidGames(String playerId, int l,
    {bool shraniLicitacijo = true, bool imaPrednost = false}) {
  for (int i = 0; i < users.length; i++) {
    if (users[i].id != playerId) continue;
    if (shraniLicitacijo) users[i].licitiral = l;
    if (l == -1) break;
    for (int n = 1; n < games.length; i++) {
      if (games[1].id >= l && imaPrednost) break;
      if (games[1].id > l) break;
      games.removeAt(1);
    }
    break;
  }
}

void resetPredictions() {
  kontraIgra = false;
  kontraPagat = false;
  kontraKralj = false;
  trula = false;
  kralji = false;
  kraljUltimo = false;
  pagatUltimo = false;
  valat = false;
  mondfang = false;
  kontraMondfang = false;
  barvic = false;
}

void copyGames() {
  games = [
    ...(jsonDecode(
      jsonEncode(
        GAMES,
        toEncodable: (Object? value) => value is LocalGame
            ? LocalGame.toJson(value)
            : throw UnsupportedError('Cannot convert to JSON: $value'),
      ),
    ) as List<dynamic>)
        .map((e) => LocalGame.fromJson(e)),
  ];
}
