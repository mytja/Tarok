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

import 'package:tarok/messages/messages.pb.dart' as Messages;
import 'package:stockskis/stockskis.dart' as stockskis;
import 'package:tarok/stockskis_compatibility/interfaces/predictions.dart';

class CardCompLayer {
  // compatibility layer between Messages.Predictions and stockskis.Predictions

  static stockskis.Card messagesToStockSkis(Messages.Card message) {
    late stockskis.LocalCard card;
    for (int i = 0; i < stockskis.CARDS.length; i++) {
      stockskis.LocalCard currentCard = stockskis.CARDS[i];
      if (currentCard.asset == message.id) {
        card = currentCard;
        break;
      }
    }
    return stockskis.Card(card: card, user: message.userId);
  }

  static Messages.Card stockSkisToMessages(stockskis.Card message) {
    return Messages.Card(id: message.card.asset, userId: message.user);
  }
}

class ResultsUserCompLayer {
  // compatibility layer between Messages.Predictions and stockskis.Predictions

  static stockskis.ResultsUser messagesToStockSkis(
      Messages.ResultsUser message) {
    return stockskis.ResultsUser(
      playing: message.playing,
      user: message.user.map((e) => stockskis.SimpleUser(
            id: e.id,
            name: e.name,
          )),
      points: message.points,
      trula: message.trula,
      pagat: message.pagat,
      igra: message.igra,
      razlika: message.razlika,
      kralj: message.kralj,
      kralji: message.kralji,
      kontraPagat: message.kontraPagat,
      kontraIgra: message.kontraIgra,
      kontraKralj: message.kontraKralj,
      mondfang: message.mondfang,
      showGamemode: message.showGamemode,
      showDifference: message.showDifference,
      showKralj: message.showKralj,
      showPagat: message.showPagat,
      showKralji: message.showKralji,
      showTrula: message.showTrula,
      radelc: message.radelc,
      skisfang: message.skisfang,
    );
  }

  static Messages.ResultsUser stockSkisToMessages(
      stockskis.ResultsUser message) {
    return Messages.ResultsUser(
      playing: message.playing,
      user: message.user.map((e) => Messages.User(
            id: e.id,
            name: e.name,
          )),
      points: message.points,
      trula: message.trula,
      pagat: message.pagat,
      igra: message.igra,
      razlika: message.razlika,
      kralj: message.kralj,
      kralji: message.kralji,
      kontraPagat: message.kontraPagat,
      kontraIgra: message.kontraIgra,
      kontraKralj: message.kontraKralj,
      mondfang: message.mondfang,
      showGamemode: message.showGamemode,
      showDifference: message.showDifference,
      showKralj: message.showKralj,
      showPagat: message.showPagat,
      showKralji: message.showKralji,
      showTrula: message.showTrula,
      radelc: message.radelc,
      skisfang: message.skisfang,
    );
  }
}

class ResultsCompLayer {
  // compatibility layer between Messages.Predictions and stockskis.Predictions

  static stockskis.Results messagesToStockSkis(Messages.Results message) {
    return stockskis.Results(
      stih: [
        ...message.stih.map((e) => stockskis.MessagesStih(
              card: [
                ...e.card.map((e) => CardCompLayer.messagesToStockSkis(e))
              ],
              pickedUpBy: e.pickedUpBy,
              pickedUpByPlaying: e.pickedUpByPlaying,
              worth: e.worth,
            ))
      ],
      user: [
        ...message.user.map((e) => ResultsUserCompLayer.messagesToStockSkis(e))
      ],
      predictions:
          PredictionsCompLayer.messagesToStockSkis(message.predictions),
    );
  }

  static Messages.Results stockSkisToMessages(stockskis.Results message) {
    return Messages.Results(
      stih: [
        ...message.stih.map((e) => Messages.Stih(
              card: [
                ...e.card.map((e) => CardCompLayer.stockSkisToMessages(e))
              ],
              pickedUpBy: e.pickedUpBy,
              pickedUpByPlaying: e.pickedUpByPlaying,
              worth: e.worth,
            ))
      ],
      user: [
        ...message.user.map((e) => ResultsUserCompLayer.stockSkisToMessages(e))
      ],
      predictions:
          PredictionsCompLayer.stockSkisToMessages(message.predictions),
    );
  }
}
