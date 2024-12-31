import 'dart:convert';

import 'package:stockskis/stockskis.dart';

class StockSkisOperations {
  late StockSkis stockskis;

  StockSkisOperations(String json) {
    DEBUG_LOGGING = false;
    stockskis = StockSkis.fromJSON(json);
  }

  String predict(String userId) {
    List<String> changes = stockskis.predict(userId);
    stockskis.predictions.changed = changes.isNotEmpty;
    Predictions predictions = stockskis.predictions;
    return jsonEncode(predictions.toJson());
  }

  String bestMove(String userId) {
    List<Move> moves = stockskis.evaluateMoves(userId);
    moves.sort((a, b) => a.evaluation.compareTo(b.evaluation));
    return moves.last.card.card.asset;
  }

  String suggestModes(String userId) {
    return jsonEncode(stockskis.suggestModes(userId));
  }

  String suggestTalon(String userId) {
    var (stockskisTalon, _, _) = stockskis.getStockskisTalon();
    return stockskis.selectDeck(userId, stockskisTalon).toString();
  }

  String suggestKing(String userId) {
    return stockskis.selectKing(userId);
  }

  String stashCards(String userId) {
    int m = 0;
    if (stockskis.gamemode == 0 || stockskis.gamemode == 3) m = 3;
    if (stockskis.gamemode == 1 || stockskis.gamemode == 4) m = 2;
    if (stockskis.gamemode == 2 || stockskis.gamemode == 5) m = 1;
    List<Card> r = stockskis.stashCards(userId, m, stockskis.selectedKing);
    return jsonEncode(r);
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
        "kontraMondfang": resultsUser.kontraMondfang,
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
        "skisfang": resultsUser.skisfang,
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

  String getStartPredictions(String userId) {
    return jsonEncode(stockskis.getStartPredictions(userId));
  }
}
