import 'dart:convert';

import 'package:stockskis/stockskis.dart';

class StockSkisOperations {
  late StockSkis stockskis;

  StockSkisOperations(String json) {
    DEBUG_LOGGING = false;
    stockskis = StockSkis.fromJSON(json);
  }

  // TODO
  String predict() {
    return "";
  }

  String suggestModes(String userId) {
    return jsonEncode(stockskis.suggestModes(userId));
  }

  String gameResults() {
    Results r = stockskis.calculateGame();
    List<Map> user = [];
    for (int i = 0; i < r.user.length; i++) {
      ResultsUser resultsUser = r.user[i];
      user.add({
        "igra": resultsUser.igra,
        "kontraIgra": resultsUser.kontraIgra,
        "kontraKralj": resultsUser.kontraKralj,
        "kontraPagat": resultsUser.kontraPagat,
        "kralj": resultsUser.kralj,
        "kralji": resultsUser.kralji,
        "pagat": resultsUser.pagat,
        "mondfang": resultsUser.mondfang,
        "playing": resultsUser.playing,
        "points": resultsUser.points,
        "radelc": resultsUser.radelc,
        "razlika": resultsUser.razlika,
        "showDifference": resultsUser.showDifference,
        "showGamemode": resultsUser.showGamemode,
        "showKralj": resultsUser.showKralj,
        "showKralji": resultsUser.showKralji,
        "showPagat": resultsUser.showPagat,
        "showTrula": resultsUser.showTrula,
        "trula": resultsUser.trula,
        "users": [
          ...resultsUser.user.map((e) => {"id": e.id, "name": e.name})
        ],
      });
    }

    List<Map> stihi = [];
    for (int i = 0; i < r.stih.length; i++) {
      MessagesStih messagesStih = r.stih[i];
      stihi.add({
        "card": [
          ...messagesStih.card.map((e) => {"id": e.card.asset, "user": e.user})
        ],
        "pickedUpBy": messagesStih.pickedUpBy,
        "pickedUpByPlaying": messagesStih.pickedUpByPlaying,
        "worth": messagesStih.worth,
      });
    }

    return jsonEncode({
      "user": user,
      "stih": stihi,
    });
  }

  String lastStihPickedUpBy() {
    return stockskis.stihPickedUpBy(stockskis.stihi.last);
  }

  String canGameEndEarly() {
    return stockskis.canGameEndEarly().toString();
  }
}
