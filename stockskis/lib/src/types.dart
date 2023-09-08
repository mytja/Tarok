class StihAnalysis {
  StihAnalysis({required this.cardPicks, required this.worth});

  Card cardPicks;
  double worth;
}

class SimpleUser {
  SimpleUser({
    required this.id,
    required this.name,
    //this.points,
  });

  final String id;
  final String name;
  int radlci = 0;
  int licitiral = -2;
  List<ResultsPoints> points = [];
  List<Card> cards = [];
  int total = 0;
  bool endGame = false;
  bool connected = true;
  double timer = 0;
  bool timerOn = false;
  int onlineStatus = 0;
  //int rating;
}

class UserEvaluation {
  late String userId;
  LocalCard najvisjaKara = LocalCard(
    asset: "",
    worth: 0,
    worthOver: 0,
    alt: "",
  );
  LocalCard najvisjiKriz = LocalCard(
    asset: "",
    worth: 0,
    worthOver: 0,
    alt: "",
  );
  LocalCard najvisjiPik = LocalCard(
    asset: "",
    worth: 0,
    worthOver: 0,
    alt: "",
  );
  LocalCard najvisjiSrc = LocalCard(
    asset: "",
    worth: 0,
    worthOver: 0,
    alt: "",
  );
  LocalCard najvisjiTarok = LocalCard(
    asset: "",
    worth: 0,
    worthOver: 0,
    alt: "",
  );
}

class Stih {
  Stih();

  List<Card> stih = [];
  String? picksUp;
}

class Card {
  Card({required this.card, required this.user});

  final LocalCard card;
  String user;

  Map toJson() {
    return {
      "card": {
        "alt": card.alt,
        "asset": card.asset,
        "worth": card.worth,
        "worthOver": card.worthOver,
      },
      "user": user,
    };
  }
}

class Move {
  Move({required this.card, required this.evaluation});

  final Card card;
  final int evaluation;
}

class Predictions {
  Predictions({
    SimpleUser? kraljUltimo,
    this.kraljUltimoKontra = 0,
    SimpleUser? kraljUltimoKontraDal,
    SimpleUser? trula,
    SimpleUser? kralji,
    SimpleUser? pagatUltimo,
    this.pagatUltimoKontra = 0,
    SimpleUser? pagatUltimoKontraDal,
    SimpleUser? igra,
    this.igraKontra = 0,
    SimpleUser? igraKontraDal,
    SimpleUser? valat,
    SimpleUser? barvniValat,
    SimpleUser? mondfang,
    this.mondfangKontra = 0,
    SimpleUser? mondfangKontraDal,
    this.gamemode = -1,
    this.changed = false,
  })  : kraljUltimo = kraljUltimo ?? SimpleUser(id: "", name: ""),
        kraljUltimoKontraDal =
            kraljUltimoKontraDal ?? SimpleUser(id: "", name: ""),
        trula = trula ?? SimpleUser(id: "", name: ""),
        kralji = kralji ?? SimpleUser(id: "", name: ""),
        pagatUltimo = pagatUltimo ?? SimpleUser(id: "", name: ""),
        pagatUltimoKontraDal =
            pagatUltimoKontraDal ?? SimpleUser(id: "", name: ""),
        igra = igra ?? SimpleUser(id: "", name: ""),
        igraKontraDal = igraKontraDal ?? SimpleUser(id: "", name: ""),
        valat = valat ?? SimpleUser(id: "", name: ""),
        barvniValat = barvniValat ?? SimpleUser(id: "", name: ""),
        mondfang = mondfang ?? SimpleUser(id: "", name: ""),
        mondfangKontraDal = mondfangKontraDal ?? SimpleUser(id: "", name: "");

  SimpleUser kraljUltimo;
  int kraljUltimoKontra;
  SimpleUser kraljUltimoKontraDal;

  SimpleUser trula;
  SimpleUser kralji;

  SimpleUser pagatUltimo;
  int pagatUltimoKontra;
  SimpleUser pagatUltimoKontraDal;

  SimpleUser igra;
  int igraKontra;
  SimpleUser igraKontraDal;

  SimpleUser valat;
  SimpleUser barvniValat;

  SimpleUser mondfang;
  int mondfangKontra;
  SimpleUser mondfangKontraDal;

  int gamemode;
  bool changed;

  Map toJson() {
    return {
      "kraljUltimo": {
        "id": kraljUltimo.id,
      },
      "kraljUltimoKontra": kraljUltimoKontra,
      "kraljUltimoKontraDal": {
        "id": kraljUltimoKontraDal.id,
      },
      "trula": {
        "id": trula.id,
      },
      "kralji": {
        "id": kralji.id,
      },
      "pagatUltimo": {
        "id": pagatUltimo.id,
      },
      "pagatUltimoKontra": pagatUltimoKontra,
      "pagatUltimoKontraDal": {
        "id": pagatUltimoKontraDal.id,
      },
      "igra": {
        "id": igra.id,
      },
      "igraKontra": igraKontra,
      "igraKontraDal": {
        "id": igraKontraDal.id,
      },
      "valat": {
        "id": valat.id,
      },
      "barvniValat": {
        "id": barvniValat.id,
      },
      "mondfang": {
        "id": mondfang.id,
      },
      "mondfangKontra": mondfangKontra,
      "mondfangKontraDal": {
        "id": mondfangKontraDal.id,
      },
      "gamemode": gamemode,
      "changed": changed,
    };
  }
}

class User {
  User({
    required this.user,
    required this.cards,
    required this.playing,
    required this.secretlyPlaying,
    required this.botType,
    required this.licitiral,
  });

  final SimpleUser user;
  List<Card> cards;
  // uporabnik igra, ve se da on igra
  bool playing;
  // uporabnik igra, ampak se še ne ve, kajti kralj ni padel
  bool secretlyPlaying;
  // licitiral
  bool licitiral;
  // bot
  final String botType;
}

class LocalCard {
  LocalCard({
    required this.asset,
    required this.worth,
    required this.worthOver,
    required this.alt,
    this.showZoom = false,
    this.valid = false,
  });

  final String asset;
  final int worth;
  final int worthOver;
  final String alt;
  bool showZoom;
  bool valid;
}

class MessagesStih {
  MessagesStih({
    required this.card,
    required this.worth,
    required this.pickedUpByPlaying,
    required this.pickedUpBy,
  });

  List<Card> card;
  double worth;
  bool pickedUpByPlaying;
  String pickedUpBy;
}

class Results {
  Results({
    required this.user,
    required this.stih,
  });

  List<ResultsUser> user;
  List<MessagesStih> stih;
}

class ResultsUser {
  ResultsUser({
    required this.user,
    required this.playing,
    this.points = 0,
    this.trula = 0,
    this.pagat = 0,
    this.igra = 0,
    this.razlika = 0,
    this.kralj = 0,
    this.kralji = 0,
    this.kontraPagat = 0,
    this.kontraIgra = 0,
    this.kontraKralj = 0,
    this.kontraMondfang = 0,
    this.mondfang = false,
    this.showGamemode = false,
    this.showDifference = false,
    this.showKralj = false,
    this.showPagat = false,
    this.showKralji = false,
    this.showTrula = false,
    this.radelc = false,
    this.skisfang = false,
  });

  Iterable<SimpleUser> user;
  bool playing;
  int points;
  int trula;
  int pagat;
  int igra;
  int razlika;
  int kralj;
  int kralji;
  int kontraPagat;
  int kontraIgra;
  int kontraKralj;
  int kontraMondfang;
  bool mondfang;
  bool showGamemode;
  bool showDifference;
  bool showKralj;
  bool showPagat;
  bool showKralji;
  bool showTrula;
  bool radelc;
  bool skisfang;
}

class ResultsPoints {
  ResultsPoints({
    required this.points,
    required this.playing,
    required this.results,
    required this.radelc,
  });

  int points;
  bool playing;
  Results results;
  bool radelc;
}

class StartPredictions {
  bool kraljUltimoKontra = false;
  bool pagatUltimoKontra = false;
  bool igraKontra = false;
  bool valatKontra = false;
  bool barvniValatKontra = false;
  bool pagatUltimo = false;
  bool trula = false;
  bool kralji = false;
  bool kraljUltimo = false;
  bool valat = false;
  bool barvniValat = false;
  bool mondfang = false;
  bool mondfangKontra = false;

  static Map toJson(StartPredictions game) {
    return {
      "kraljUltimoKontra": game.kraljUltimoKontra,
      "pagatUltimoKontra": game.pagatUltimoKontra,
      "igraKontra": game.igraKontra,
      "valatKontra": game.valatKontra,
      "barvniValatKontra": game.barvniValatKontra,
      "pagatUltimo": game.pagatUltimo,
      "trula": game.trula,
      "kralji": game.kralji,
      "kraljUltimo": game.kraljUltimo,
      "valat": game.valat,
      "barvniValat": game.barvniValat,
      "mondfang": game.mondfang,
      "mondfangKontra": game.mondfangKontra,
    };
  }
}

class LocalGame {
  LocalGame({
    required this.id,
    required this.name,
    required this.playsThree,
    required this.worth,
  });

  final int id;
  final String name;
  final bool playsThree;
  final int worth;

  LocalGame.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        playsThree = json["playsThree"],
        worth = json["worth"];

  static Map toJson(LocalGame game) {
    return {
      "id": game.id,
      "name": game.name,
      "playsThree": game.playsThree,
      "worth": game.worth,
    };
  }
}
