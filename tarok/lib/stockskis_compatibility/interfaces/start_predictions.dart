import 'package:tarok/messages/messages.pb.dart' as Messages;
import 'package:stockskis/stockskis.dart' as stockskis;

class StartPredictionsCompLayer {
  // compatibility layer between Messages.Predictions and stockskis.Predictions

  static stockskis.StartPredictions messagesToStockSkis(
      Messages.StartPredictions message) {
    final predictions = stockskis.StartPredictions();
    predictions.barvniValat = message.barvniValat;
    predictions.barvniValatKontra = message.barvniValatKontra;
    predictions.igraKontra = message.igraKontra;
    predictions.kraljUltimo = message.kraljUltimo;
    predictions.kraljUltimoKontra = message.kraljUltimoKontra;
    predictions.kralji = message.kralji;
    predictions.pagatUltimo = message.pagatUltimo;
    predictions.pagatUltimoKontra = message.pagatUltimoKontra;
    predictions.trula = message.trula;
    predictions.valat = message.valat;
    predictions.valatKontra = message.valatKontra;
    predictions.mondfang = message.mondfang;
    predictions.mondfangKontra = message.mondfangKontra;
    return predictions;
  }

  static Messages.StartPredictions stockSkisToMessages(
      stockskis.StartPredictions message) {
    final predictions = Messages.StartPredictions();
    predictions.barvniValat = message.barvniValat;
    predictions.barvniValatKontra = message.barvniValatKontra;
    predictions.igraKontra = message.igraKontra;
    predictions.kraljUltimo = message.kraljUltimo;
    predictions.kraljUltimoKontra = message.kraljUltimoKontra;
    predictions.kralji = message.kralji;
    predictions.pagatUltimo = message.pagatUltimo;
    predictions.pagatUltimoKontra = message.pagatUltimoKontra;
    predictions.trula = message.trula;
    predictions.valat = message.valat;
    predictions.valatKontra = message.valatKontra;
    predictions.mondfang = message.mondfang;
    predictions.mondfangKontra = message.mondfangKontra;
    return predictions;
  }
}
