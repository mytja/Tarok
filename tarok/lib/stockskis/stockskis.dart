// ignore_for_file: avoid_print, prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import "dart:developer";
import "dart:math";

import "package:tarok/constants.dart";
import "package:tarok/messages.pb.dart" as Messages;

import "../constants.dart" as constants;

class StihAnalysis {
  StihAnalysis({required this.cardPicks, required this.worth});

  Card cardPicks;
  int worth;
}

class User {
  User({
    required this.user,
    required this.cards,
    required this.playing,
    required this.secretlyPlaying,
    required this.botType,
  });

  final constants.User user;
  List<Card> cards;
  // uporabnik igra, ve se da on igra
  bool playing;
  // uporabnik igra, ampak se še ne ve, kajti kralj ni padel
  bool secretlyPlaying;
  // bot
  final String botType;
}

class Stih {
  Stih();

  List<Card> stih = [];
  String? picksUp;
}

class Card {
  Card({required this.card, required this.user});

  final constants.LocalCard card;
  String user;
}

class Move {
  Move({required this.card, required this.evaluation});

  final Card card;
  final int evaluation;
}

class StockSkis {
  StockSkis({required this.users, required this.stihiCount});

  Map<String, User> users;
  List<List<Card>> stihi = [[]];
  List<Card> talon = [];
  final int stihiCount;
  bool kingFallen = false;
  int gamemode = -1;

  List<Move> evaluateMoves(String userId) {
    List<Move> moves = [];

    if (users[userId] == null) return [];
    User user = users[userId]!;

    List<Card> stih = stihi.last;
    print(stihi);

    int taroki = 0;
    int srci = 0;
    int piki = 0;
    int krizi = 0;
    int kare = 0;
    int tarokiWorth = 0;
    int srciWorth = 0;
    int pikiWorth = 0;
    int kriziWorth = 0;
    int kareWorth = 0;
    for (int i = 0; i < user.cards.length; i++) {
      Card card = user.cards[i];
      String cardType = card.card.asset.split("/")[1];
      if (cardType == "taroki") {
        taroki++;
        // palčka je na 6
        int worthOver = (card.card.worthOver - 6);
        tarokiWorth += (pow(worthOver, 1.5) / 3).round();
      } else if (cardType == "src") {
        srci++;
        srciWorth += card.card.worth;
      } else if (cardType == "pik") {
        piki++;
        pikiWorth += card.card.worth;
      } else if (cardType == "kara") {
        kare++;
        kareWorth += card.card.worth;
      } else {
        krizi++;
        kriziWorth += card.card.worth;
      }
    }

    if (stih.isEmpty) {
      for (int i = 0; i < user.cards.length; i++) {
        Card card = user.cards[i];
        String cardType = card.card.asset.split("/")[1];

        // pagat generalno ne bi smel prvi past, razen če je to res edina karta
        if (user.cards.length != 1 && card.card.asset == "/taroki/pagat") {
          continue;
        }

        // klop in berač
        if (gamemode == 6 || gamemode == -1) {
          // yes, negativna evaluacija
          if (cardType == "taroki") {
            moves.add(
              Move(
                  card: card,
                  evaluation: -(card.card.worthOver / 3 + tarokiWorth / taroki)
                      .round()),
            );
          } else if (cardType == "src") {
            moves.add(
              Move(
                  card: card,
                  evaluation:
                      -(card.card.worth / 2 + srciWorth / srci).round()),
            );
          } else if (cardType == "pik") {
            moves.add(
              Move(
                  card: card,
                  evaluation:
                      -(card.card.worth / 2 + pikiWorth / piki).round()),
            );
          } else if (cardType == "kara") {
            moves.add(
              Move(
                  card: card,
                  evaluation:
                      -(card.card.worth / 2 + kareWorth / kare).round()),
            );
          } else {
            moves.add(
              Move(
                  card: card,
                  evaluation:
                      -(card.card.worth / 2 + kriziWorth / krizi).round()),
            );
          }
          continue;
        }

        int penalty = 0;

        // pač, to da pagata v prvo vržeš se res ne dela
        if (card.card.asset == "/taroki/pagat") penalty += 100;

        if (cardType == "taroki") {
          if (taroki + stihiCount * 0.2 < stihiCount - stihi.length) {
            // kazen, ker se bot želi znebiti tarokov, ko jih ima malo
            penalty +=
                ((stihiCount - stihi.length) - (taroki + stihiCount * 0.2))
                    .floor();
          } else {
            // če jih ima veliko, se jih lahko znebimo
            // čim višji je tarok, tem bolje je
            penalty -= ((card.card.worthOver - 5) * 0.4).round();
          }
        } else {
          // damo kazen, če mečemo gor točke, pri tem pa imamo ogromno iste barve
          // naj bo kazen eksponentna / 2
          if (cardType == "src") penalty += ((srci * srci) / 2).round();
          if (cardType == "pik") penalty += ((piki * piki) / 2).round();
          if (cardType == "kara") penalty += ((kare * kare) / 2).round();
          if (cardType == "kriz") penalty += ((krizi * krizi) / 2).round();
        }

        // praktično nikoli naj se ne bi začelo z mondom, razen če je padel škis
        if (card.card.asset == "/taroki/mond") {
          bool jePadelSkis = false;
          for (int n = 0; n < stihi.length; n++) {
            List<Card> stih = stihi[n];
            for (int k = 0; k < stih.length; k++) {
              if (stih[k].card.asset == "/taroki/skis") jePadelSkis = true;
              if (jePadelSkis) break;
            }
            if (jePadelSkis) break;
          }
          if (jePadelSkis) {
            penalty -= 1;
          } else {
            penalty += 20;
          }
          print("kazen za monda $penalty");
        }

        moves.add(
          Move(
            card: card,
            evaluation: card.card.worth - penalty,
          ),
        );
      }
    } else {
      String cardType = stih.first.card.asset.split("/")[1];
      StihAnalysis analysis = analyzeStih(stih)!;
      bool hasColor = false;
      bool hasTarocks = false;
      for (int n = 0; n < user.cards.length; n++) {
        Card cc = user.cards[n];
        String currentCardType = cc.card.asset.split("/")[1];
        if (currentCardType == cardType) hasColor = true;
        if (currentCardType == "taroki") hasTarocks = true;
        if (hasColor && hasTarocks) break;
      }

      bool hasOver = false;
      for (int i = 0; i < user.cards.length; i++) {
        Card card = user.cards[i];
        String currentCardType = card.card.asset.split("/")[1];
        if (hasColor && currentCardType != cardType) continue;
        if (!hasColor && !hasTarocks) break;
        // velja samo za taroke in barvo
        if (card.card.worthOver > analysis.cardPicks.card.worthOver) {
          hasOver = true;
          break;
        }
      }

      bool hasPlayerCard = false;
      List<String> playing = playingUsers();
      for (int i = 0; i < stih.length; i++) {
        Card card = stih[i];
        if (!playing.contains(card.user)) continue;
        hasPlayerCard = true;
        break;
      }

      print(
          "User $userId hasOver=$hasOver, hasColor=$hasColor, hasTarocks=$hasTarocks, stihPicks=${analysis.cardPicks.card.worthOver}, hasPlayerCard=$hasPlayerCard, gamemode=$gamemode");

      for (int i = 0; i < user.cards.length; i++) {
        Card card = user.cards[i];
        String currentCardType = card.card.asset.split("/")[1];
        if (hasColor && cardType != currentCardType) continue;
        if (!hasColor && hasTarocks && currentCardType != "taroki") continue;

        print(
            "Legal move $card with ${card.card.worth} and ${card.card.asset} - ${card.card.worthOver}");

        // klop in berač
        if (gamemode == 6 || gamemode == -1) {
          if (taroki > 1 && card.card.asset == "/taroki/pagat") continue;
          if ((!hasColor && !hasTarocks) || !hasOver || hasPlayerCard) {
            moves.add(Move(card: card, evaluation: card.card.worthOver));
            continue;
          }
          if (card.card.worthOver < analysis.cardPicks.card.worthOver) continue;
          moves.add(Move(card: card, evaluation: -card.card.worthOver));
          continue;
        }

        int penalty = 0;

        // praktično nikoli naj se ne bi začelo z mondom, razen če je padel škis
        if (card.card.asset == "/taroki/mond") {
          bool jePadelSkis = false;
          for (int n = 0; n < stihi.length - 1; n++) {
            List<Card> stih = stihi[n];
            for (int k = 0; k < stih.length; k++) {
              if (stih[k].card.asset == "/taroki/skis") jePadelSkis = true;
              if (jePadelSkis) break;
            }
            if (jePadelSkis) break;
          }
          if (jePadelSkis) {
            penalty -= 1;
          } else {
            penalty += 40;
          }
          print("kazen za monda $penalty");
        }

        // če kdo ponuja monda, ga pobereš
        if (card.card.asset == "/taroki/skis") {
          bool jePadelMond = false;
          for (int k = 0; k < stih.length; k++) {
            if (stih[k].card.asset == "/taroki/skis") jePadelMond = true;
            if (jePadelMond) break;
          }
          if (jePadelMond) {
            penalty -= 100;
          }
        }

        // če se lahko bot stegne, potem ne kaznujemo, ampak celo nagradimo
        // če se lahko stegne, je to bolj vredno kakor če se ne more
        if (analysis.cardPicks.card.worthOver < card.card.worthOver) {
          penalty -= 8 * analysis.worth;
        }

        // če se bot ne more stegniti, naj se čim manj
        // bota nagradimo, če se lahko stegne za malo
        // še vedno ga pa kaznujemo, ker se ne more stegniti
        // to pomeni, da ga kaznujemo za določeno trenutno vrednost talona
        if (analysis.cardPicks.card.worthOver > card.card.worthOver) {
          penalty -=
              6 * (analysis.cardPicks.card.worthOver - card.card.worthOver);
          penalty += (analysis.worth * analysis.worth / 4).round();
        }

        // če se bot preveč stegne, ga kaznujemo
        // to velja samo za taroke
        // pri platelcah generalno želimo, da se stegne čim bolj
        if (cardType == "taroki") {
          penalty +=
              max(0, card.card.worthOver - analysis.cardPicks.card.worthOver);
        }

        // ali bot šenka punte pravi osebi?
        List<Card> currentStih = [...stih, card];
        StihAnalysis newAnalysis = analyzeStih(currentStih)!;
        print(
            "Analysis ${analysis.cardPicks.user} ${analysis.cardPicks.card.asset} for player $userId");
        if (newAnalysis.cardPicks != card) {
          int p = 1;
          if (user.secretlyPlaying || user.playing) {
            int p = 1;
            if (users[analysis.cardPicks.user]!.playing) {
              // kazen bo negativna
              p = -1;
            }
          } else {
            p = -1;
            bool k = kingFallen
                ? (users[analysis.cardPicks.user] != null
                    ? users[analysis.cardPicks.user]!.playing
                    : true)
                : false;
            print(
                "Status kralja: $kingFallen, posledično je kazen (negativna=false) $k");
            if (k) {
              // kazen bo negativna
              p = 1;
            }
          }
          penalty += pow(card.card.worth, 2.5).round() * p;
        }

        print(
            "Evaluation for card ${card.card.asset} with penalty of $penalty");

        moves.add(
          Move(
            card: card,
            evaluation: card.card.worth - penalty,
          ),
        );
      }
    }

    return moves;
  }

  /*
  bool hasColor = false;
  bool hasTarocks = false;
  for (int n = 0; n < currentUserCards.length; n++) {
    Card cc = currentUserCards[n];
    String currentCardType = cc.card.asset.split("/")[1];
    if (currentCardType == cardType) hasColor = true;
    if (currentCardType == "taroki") hasTarocks = true;
    if (hasColor && hasTarocks) break;
  }
  */

  // TODO: palčka pobere škisa pa monda
  StihAnalysis? analyzeStih(List<Card> stih) {
    if (stih.isEmpty) return null;
    Card firstCard = stih.first;
    String cardType = firstCard.card.asset.split("/")[1];
    StihAnalysis analysis =
        StihAnalysis(cardPicks: firstCard, worth: firstCard.card.worth);
    for (int i = 1; i < stih.length; i++) {
      Card currentCard = stih[i];
      analysis.worth += currentCard.card.worth;
      String currentCardType = currentCard.card.asset.split("/")[1];
      if (cardType == currentCardType || currentCardType == "taroki") {
        if (analysis.cardPicks.card.worthOver < currentCard.card.worthOver) {
          analysis.cardPicks = currentCard;
        }
      }
    }
    return analysis;
  }

  List<int> suggestModes(String userId) {
    List<int> modes = [];
    List<String> cards = [];
    User user = users[userId]!;

    if (user.botType == "klop") return [-1];

    int taroki = 0;
    int srci = 0;
    int piki = 0;
    int krizi = 0;
    int kare = 0;
    for (int i = 0; i < user.cards.length; i++) {
      Card card = user.cards[i];
      String cardType = card.card.asset.split("/")[1];
      if (cardType == "taroki") {
        taroki++;
      } else if (cardType == "src") {
        srci += card.card.worthOver;
      } else if (cardType == "pik") {
        piki += card.card.worthOver;
      } else if (cardType == "kara") {
        kare += card.card.worthOver;
      } else {
        krizi += card.card.worthOver;
      }
    }

    int maximumRating = 0;
    for (int i = constants.CARDS.length - 1;
        i > constants.CARDS.length - 1 - ((54 - 6) / users.length);
        i--) {
      maximumRating += constants.CARDS[i].worthOver;
    }

    int myRating = 0;
    for (int i = 0; i < user.cards.length; i++) {
      Card card = user.cards[i];
      myRating += card.card.worthOver;
    }

    print(
        "Evaluacija za osebo $userId je $myRating, kar je ${myRating / maximumRating}% največje evaluacije.");

    // berač
    if (user.botType == "berac" || user.botType == "vrazji") {
      if (myRating < maximumRating * 0.3) modes.add(6);
    } else {
      if (myRating < maximumRating * 0.25) modes.add(6);
    }

    if (user.botType == "vrazji") {
      // odprti berač
      //if (myRating < maximumRating * 0.05) modes.add(8);
      // solo brez
      if (myRating > maximumRating * 0.80) modes.add(7);
      // valat
      if (myRating >= maximumRating * 0.85) modes.add(10);
      // tri
      if (myRating >= maximumRating * 0.3) modes.add(0);
      // dva
      if (myRating >= maximumRating * 0.4) modes.add(1);
      // ena
      if (myRating >= maximumRating * 0.5) modes.add(2);

      // igre, ki se igrajo samo v 4
      if (users.length != 3) {
        // solo tri
        if (myRating >= maximumRating * 0.55) modes.add(3);
        // solo dva
        if (myRating >= maximumRating * 0.65) modes.add(4);
        // solo ena
        if (myRating >= maximumRating * 0.75) modes.add(5);
        // barvni valat
        if (srci >= 25 || piki >= 25 || krizi >= 25 || kare >= 25) modes.add(9);
      }

      // dalje
      if (myRating < maximumRating * 0.35) modes.add(-1);
    } else {
      // odprti berač
      //if (myRating < maximumRating * 0.05) modes.add(8);
      // solo brez
      if (myRating > maximumRating * 0.85) modes.add(7);
      // valat
      if (myRating >= maximumRating * 0.90) modes.add(10);
      // tri
      if (myRating >= maximumRating * 0.35) modes.add(0);
      // dva
      if (myRating >= maximumRating * 0.45) modes.add(1);
      // ena
      if (myRating >= maximumRating * 0.55) modes.add(2);

      // igre, ki se igrajo samo v 4
      if (users.length != 3) {
        // solo tri
        if (myRating >= maximumRating * 0.65) modes.add(3);
        // solo dva
        if (myRating >= maximumRating * 0.75) modes.add(4);
        // solo ena
        if (myRating >= maximumRating * 0.85) modes.add(5);
        // barvni valat
        if (srci >= 27 || piki >= 27 || krizi >= 27 || kare >= 27) modes.add(9);
      }

      // dalje
      if (myRating < maximumRating * 0.45) modes.add(-1);
    }

    modes.sort();
    // evaluation
    inspect(modes);
    return modes;
  }

  String selectKing(String playerId) {
    User user = users[playerId]!;
    List<String> p = ["/kara/kralj", "/kriz/kralj", "/src/kralj", "/pik/kralj"];
    for (int i = 0; i < user.cards.length; i++) {
      Card card = user.cards[i];
      if (card.card.asset == "/kara/kralj") p.remove("/kara/kralj");
      if (card.card.asset == "/kriz/kralj") p.remove("/kriz/kralj");
      if (card.card.asset == "/src/kralj") p.remove("/src/kralj");
      if (card.card.asset == "/pik/kralj") p.remove("/pik/kralj");
    }
    return p[Random().nextInt(p.length)];
  }

  void selectSecretlyPlaying(String king) {
    List<String> keys = users.keys.toList(growable: false);
    for (int i = 0; i < keys.length; i++) {
      User user = users[keys[i]]!;
      for (int n = 0; n < user.cards.length; n++) {
        String card = user.cards[n].card.asset;
        if (card != king) continue;
        users[keys[i]]!.secretlyPlaying = true;
        return;
      }
    }
  }

  void resetContext() {
    List<String> keys = users.keys.toList(growable: false);
    for (int i = 0; i < keys.length; i++) {
      String key = keys[i];
      users[key]!.playing = false;
      users[key]!.secretlyPlaying = false;
      users[key]!.cards = [];
    }
    stihi = [[]];
    talon = [];
    gamemode = -1;
    kingFallen = false;
  }

  void doRandomShuffle() {
    List<constants.LocalCard> cards = constants.CARDS.toList();
    cards.shuffle();
    int player = -1;
    List<String> keys = users.keys.toList(growable: false);
    for (int i = 0; i < (54 - 6); i++) {
      if (i % ((54 - 6) / keys.length) == 0) {
        player++;
      }
      users[keys[player]]!.cards.add(Card(card: cards[0], user: keys[player]));
      cards.removeAt(0);
    }
    talon = cards.map((e) => Card(card: e, user: "")).toList();
  }

  int selectDeck(List<List<Card>> talon) {
    List<int> worth = [];
    for (int i = 0; i < talon.length; i++) {
      int wor = 0;
      for (int n = 0; n < talon[i].length; n++) {
        String cardType = talon[i][n].card.asset.split("/")[1];
        wor += talon[i][n].card.worth;
        if (cardType == "taroki") wor += 2;
      }
      worth.add(wor);
    }
    int max = 0;
    int maxLen = 0;
    for (int i = 0; i < worth.length; i++) {
      if (worth[i] > max) {
        max = worth[i];
        maxLen = i;
      }
    }
    return maxLen;
  }

  bool isValidToStash(Card card) {
    return !(card.card.asset == "/taroki/pagat" ||
        card.card.asset == "/taroki/mond" ||
        card.card.asset == "/taroki/skis" ||
        card.card.asset == "/src/kralj" ||
        card.card.asset == "/pik/kralj" ||
        card.card.asset == "/kriz/kralj" ||
        card.card.asset == "/kara/kralj");
  }

  List<Card> stashCards(String playerId, int toStash, String playedIn) {
    User user = users[playerId]!;
    List<Card> stash = [];

    // striktne omejitve
    for (int i = 0; i < user.cards.length; i++) {
      Card card = user.cards[i];
      String cardType = card.card.asset.split("/")[1];
      if (!isValidToStash(card)) continue;
      if (cardType == playedIn) continue;
      int found = 0;
      for (int n = 0; n < user.cards.length; n++) {
        Card card = user.cards[n];
        if (!isValidToStash(card)) continue;
        String currentCardType = card.card.asset.split("/")[1];
        if (currentCardType == cardType) found++;
      }
      if (found > toStash - stash.length) continue;
      int k = 0;
      for (int n = 0; n < user.cards.length - k; n++) {
        Card card = user.cards[n];
        if (!isValidToStash(card)) continue;
        String currentCardType = card.card.asset.split("/")[1];
        if (currentCardType != cardType) continue;
        user.cards.remove(card);
        stash.add(card);
        k++;
      }

      if (stash.length == toStash) return stash;
    }

    // mehke omejitve
    print("Prišli smo do mehkih omejitev");
    for (int i = 0; i < user.cards.length; i++) {
      Card card = user.cards[i];
      String cardType = card.card.asset.split("/")[1];
      if (!isValidToStash(card)) continue;

      int k = 0;
      for (int n = 0; n < user.cards.length - k; n++) {
        Card card = user.cards[n];
        if (!isValidToStash(card)) continue;
        String currentCardType = card.card.asset.split("/")[1];
        if (currentCardType != cardType) continue;
        user.cards.remove(card);
        stash.add(card);
        k++;
        if (stash.length == toStash) break;
      }

      if (stash.length == toStash) return stash;
    }

    return stash;
  }

  String stihPickedUpBy(List<Card> stih) {
    if (stih.isEmpty) throw Exception("stih's length is 0");
    Card first = stih.first;
    String firstCardType = first.card.asset.split("/")[1];
    Card picksUp = stih.first;
    for (int i = 1; i < stih.length; i++) {
      String cardType = stih[i].card.asset.split("/")[1];
      if ((cardType == firstCardType || cardType == "taroki") &&
          picksUp.card.worthOver < stih[i].card.worthOver) picksUp = stih[i];
    }
    return picksUp.user;
  }

  bool canGameEndEarly() {
    if (gamemode <= 5 && gamemode >= 0) return false;
    String userId = "";
    List<String> keys = users.keys.toList(growable: false);
    for (int i = 0; i < keys.length; i++) {
      if (users[keys[i]]!.playing) {
        userId = users[keys[i]]!.user.id;
        break;
      }
    }
    if (gamemode == -1) {
      // klop
    } else if (gamemode == 6) {
      // berač
      for (int i = 0; i < stihi.length; i++) {
        if (stihi[i].length != users.length) continue;
        String by = stihPickedUpBy(stihi[i]);
        if (by == userId) return true;
      }
    }
    return false;
  }

  int calculateTotal(List<Card> cards) {
    int removed = 0;
    int worth = 0;
    int totalWorth = 0;
    for (int i = 0; i < cards.length; i++) {
      worth += cards[i].card.worth;
      removed++;
      if (removed >= 3) {
        removed = 0;
        totalWorth += worth - 2;
        worth = 0;
      }
    }
    if (removed != 0) {
      totalWorth += worth - (removed - 1);
    }
    return totalWorth;
  }

  List<String> playingUsers() {
    List<String> playing = [];
    List<String> keys = users.keys.toList(growable: false);
    for (int i = 0; i < keys.length; i++) {
      if (users[keys[i]]!.playing) {
        playing.add(users[keys[i]]!.user.id);
        //break;
      }
    }
    return playing;
  }

  Messages.Results calculateGame() {
    Map<String, List<Card>> results = {};
    List<String> playing = playingUsers();
    List<Card> playingPickedUpCards = [];
    List<String> keys = users.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      User user = users[keys[i]]!;
      results[user.user.id] = [];
    }
    String mondFallen = "";
    bool skisFallen = false;
    for (int i = 0; i < stihi.length; i++) {
      List<Card> stih = stihi[i];
      if (stih.isEmpty) continue;
      String by = stihPickedUpBy(stih);
      print(
          "Pobral $by, pri čimer igrajo $playing in štih je dolg ${stih.length}");
      for (int n = 0; n < stih.length; n++) {
        Card card = stih[n];
        if (card.card.asset == "/taroki/mond") mondFallen = card.user;
        if (card.card.asset == "/taroki/skis") skisFallen = true;
        results[by]!.add(card);
      }
      if (!skisFallen || mondFallen == "") {
        mondFallen = "";
        skisFallen = false;
      }
    }
    List<Messages.ResultsUser> newResults = [];
    if (gamemode != -1) {
      // VSE OSTALO KOT KLOP
      int playingPlayed = 0;
      for (int i = 0; i < keys.length; i++) {
        User user = users[keys[i]]!;
        if (playing.contains(user.user.id)) {
          playingPlayed += calculateTotal(results[user.user.id]!);
        }
      }
      print("Igralec je skupaj pobral ${playingPickedUpCards.length} kart.");
      int diff = playingPlayed - 35;
      int gamemodeWorth = 0;
      for (int i = 0; i < GAMES.length; i++) {
        if (GAMES[i].id == gamemode) {
          gamemodeWorth = GAMES[i].worth;
          break;
        }
      }
      print(
          "Rezultat igre $gamemodeWorth z razliko $diff, pri čemer je igralec pobral $playingPlayed.");
      inspect(playingPickedUpCards);
      if (diff <= 0) {
        gamemodeWorth *= -1;
      }
      int total = gamemodeWorth + diff;
      newResults.add(
        Messages.ResultsUser(
          user: users.keys.map((key) => users[key]!.playing
              ? Messages.User(id: key, name: users[key]!.user.name)
              : Messages.User(id: "", name: "")),
          mondfang: false,
          showDifference: true,
          showGamemode: true,
          showKralj: false,
          showKralji: false,
          showPagat: false,
          showTrula: false,
          igra: gamemodeWorth,
          razlika: diff,
          points: total,
        ),
      );
      if (gamemode < 6 && mondFallen != "" && skisFallen) {
        newResults.add(
          Messages.ResultsUser(
            user: [
              Messages.User(id: mondFallen, name: users[mondFallen]!.user.name),
            ],
            mondfang: true,
            showDifference: false,
            showGamemode: false,
            showKralj: false,
            showKralji: false,
            showPagat: false,
            showTrula: false,
          ),
        );
      }
    } else {
      // KLOP
      for (int i = 0; i < keys.length; i++) {
        User user = users[keys[i]]!;
        int diff = -calculateTotal(results[user.user.id]!);
        newResults.add(Messages.ResultsUser(
          user: [Messages.User(id: user.user.id, name: user.user.name)],
          showDifference: true,
          showGamemode: false,
          showKralj: false,
          showKralji: false,
          showPagat: false,
          showTrula: false,
          razlika: diff,
          points: diff,
        ));
      }
    }
    return Messages.Results(user: newResults);
  }

  // 1 = draw
  // >1 = player is winning
  // <1 = player is losing
  double evaluateGame() {
    List<String> playing = [];
    List<String> keys = users.keys.toList(growable: false);
    for (int i = 0; i < keys.length; i++) {
      if (users[keys[i]]!.playing) {
        playing.add(users[keys[i]]!.user.id);
        //break;
      }
    }
    print("Playing $playing");
    List<Card> playingPickedUpCards = [];
    List<Card> notPlayingPickedUpCards = [...talon];
    for (int i = 0; i < stihi.length; i++) {
      if (stihi[i].isEmpty) continue;
      String by = stihPickedUpBy(stihi[i]);
      for (int n = 0; n < stihi[i].length; n++) {
        if (playing.contains(by)) {
          playingPickedUpCards.add(stihi[i][n]);
        } else {
          notPlayingPickedUpCards.add(stihi[i][n]);
        }
      }
    }
    return calculateTotal(playingPickedUpCards) /
        calculateTotal(notPlayingPickedUpCards);
  }

  void revealKing(String msgPlayerId) {
    users[msgPlayerId]!.playing = true;
    kingFallen = true;
  }
}
