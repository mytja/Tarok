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
    required this.licitiral,
  });

  final constants.User user;
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
  StockSkis({
    required this.users,
    required this.stihiCount,
    required this.predictions,
  });

  Map<String, User> users;
  List<List<Card>> stihi = [[]];
  List<Card> talon = [];
  List<constants.User> userPositions = [];
  List<constants.User> userQueue = [];
  final int stihiCount;
  bool kingFallen = false;
  int gamemode = -1;
  Messages.Predictions predictions;
  String selectedKing = "";

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
          if (card.card.asset == "/taroki/mond") {
            // poskusimo, da kdo drug faše monda
            moves.add(
              Move(
                card: card,
                evaluation: 1,
              ),
            );
          } else if (cardType == "taroki") {
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
          // stihiCount = skupno število štihov, katere se pobere skozi igro
          if (taroki + stihiCount * 0.15 < stihiCount - stihi.length) {
            // kazen, ker se bot želi znebiti tarokov, ko jih ima malo
            penalty += pow(
                    ((stihiCount - stihi.length) - (taroki + stihiCount * 0.15))
                        .ceil(),
                    2)
                .toInt();
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

        if (selectedKing == card.card.asset) {
          // s svojim kraljem se tko nikoli ne pride ven, ker je res nepotrebno
          penalty += 200;
        }
        if (selectedKing == card.card.asset &&
            predictions.kraljUltimo.id != "") {
          penalty += 100;
        }
        if (card.card.asset == "/taroki/pagat" &&
            predictions.pagatUltimo.id != "") {
          penalty += 200;
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

      bool stihPobereIgralec = playing.contains(analysis.cardPicks.user);

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
          if (stihi.last.length == users.length - 1) {
            // uporabnik je zadnji, posledično se naj se stegne čim bolj
            moves.add(Move(card: card, evaluation: card.card.worthOver));
            continue;
          }
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
          bool igra = false;
          for (int k = 0; k < stih.length; k++) {
            if (stih[k].card.asset == "/taroki/mond") jePadelMond = true;
            igra = playing.contains(stih[k].user);
            if (jePadelMond) break;
          }
          if (jePadelMond) {
            if (user.playing == igra) {
              // boti ne bodo pobrali monda nekomu, s komer igrajo
              penalty += 200;
            } else {
              penalty -= 100;
            }
          }
        }

        // če se lahko bot stegne, potem ne kaznujemo, ampak celo nagradimo
        // če se lahko stegne, je to bolj vredno kakor če se ne more
        if (analysis.cardPicks.card.worthOver < card.card.worthOver) {
          if (stihi.last.length == users.length - 1) {
            // uporabnik je zadnji, posledično se mora stegniti čim manj
            penalty += card.card.worthOver;
          }
          // bot naj se pravilno ne bi stegnil čez tiste, s katerimi igra, če ti že poberejo štih
          if (stihPobereIgralec == user.playing) {
            penalty += pow(card.card.worthOver / 3, 2).toInt();
          }
          penalty -= 8 * analysis.worth;
        }

        // če se bot ne more stegniti, naj se čim manj
        // bota nagradimo, če se lahko stegne za malo
        // še vedno ga pa kaznujemo, ker se ne more stegniti
        // to pomeni, da ga kaznujemo za določeno trenutno vrednost talona
        if (analysis.cardPicks.card.worthOver > card.card.worthOver) {
          penalty -=
              6 * (analysis.cardPicks.card.worthOver - card.card.worthOver);
          penalty += pow(card.card.worth, 3).round();
          penalty += (pow(analysis.worth, 3) / 2).round();
        }

        // če se bot preveč stegne, ga kaznujemo
        // to velja samo za taroke
        // pri platelcah generalno želimo, da se stegne čim bolj
        if (cardType == "taroki") {
          penalty += pow(
                  max(
                    0,
                    card.card.worthOver - analysis.cardPicks.card.worthOver,
                  ),
                  1.5)
              .round();
        }

        // ali bot šenka punte pravi osebi?
        List<Card> currentStih = [...stih, card];
        StihAnalysis newAnalysis = analyzeStih(currentStih)!;
        print(
          "Analysis ${analysis.cardPicks.user} ${analysis.cardPicks.card.asset} for player $userId, whereas stih consists of ${currentStih.map((e) => e.card.asset).join(" ")}",
        );
        if (newAnalysis.cardPicks != card) {
          int p = 1;
          if (user.secretlyPlaying || user.playing) {
            if (users[analysis.cardPicks.user]!.playing) {
              // kazen bo negativna
              p = -1;
            }
          } else {
            // v tem delu trenutni igralec ne igra
            p = -1;
            bool k = true;
            if (kingFallen) {
              // kralj je padel, vemo kdo igra s kom
              if (users[analysis.cardPicks.user] != null) {
                // če igralec, ki pobere štih igra, bo true.
                k = users[analysis.cardPicks.user]!.playing;
              }
              // else: k = true;
            }
            // else: ker kralj še ni padel smo sus do vseh in nikomur ne šenkamo.

            print(
                "Status kralja: $kingFallen, posledično je kazen (negativna=false) $k");
            if (k) {
              // kazen bo negativna
              p = 1;
            }
          }
          penalty += pow(card.card.worth, 3).round() * p;
        }

        if (selectedKing == card.card.asset &&
            predictions.kraljUltimo.id != "") {
          penalty += 100;
        }
        if (card.card.asset == "/taroki/pagat" &&
            predictions.pagatUltimo.id != "") {
          penalty += 200;
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

  List<int> suggestModes(String userId, {bool canLicitateThree = false}) {
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
      if (canLicitateThree && myRating >= maximumRating * 0.3) modes.add(0);
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
      if (canLicitateThree && myRating >= maximumRating * 0.35) modes.add(0);
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
    selectedKing = king;
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
    selectedKing = "";
    stihi = [[]];
    talon = [];
    gamemode = -1;
    kingFallen = false;

    // naslednja oseba v rotaciji
    constants.User firstUser = userQueue.first;
    userQueue.removeAt(0);
    userQueue.add(firstUser);
  }

  void userFirst() {
    List<constants.User> before = [];
    List<constants.User> after = [];
    int i = 0;
    while (i < userPositions.length) {
      constants.User up = userPositions[i];
      if (up.id == "player") break;
      before.add(up);
      i++;
    }
    while (i < userPositions.length) {
      constants.User up = userPositions[i];
      after.add(up);
      i++;
    }
    userPositions = [...after, ...before];
  }

  int translateQueueToPosition(int queuePosition) {
    constants.User user = userQueue[queuePosition];
    for (int i = 0; i < userPositions.length; i++) {
      if (user.id == userPositions[i].id) return i;
    }
    throw Exception("No such user to translate to");
  }

  int translatePositionToQueue(int position) {
    constants.User user = userPositions[position];
    for (int i = 0; i < userQueue.length; i++) {
      if (user.id == userQueue[i].id) return i;
    }
    throw Exception("No such user to translate to");
  }

  int getPlayer() {
    for (int i = 0; i < userQueue.length; i++) {
      if (userQueue[i].id == "player") return i;
    }
    throw Exception("No such user to translate to");
  }

  void doRandomShuffle() {
    List<constants.LocalCard> cards = constants.CARDS.toList();
    cards.shuffle();
    int player = -1;
    List<String> keys = users.keys.toList(growable: false);
    if (userPositions.isEmpty) {
      for (int i = 0; i < keys.length; i++) {
        userPositions.add(users[keys[i]]!.user);
      }
      userPositions.shuffle();
      userQueue = [...userPositions];
      print(
        "[STOCKŠKIS] userPositions: ${userPositions.map((e) => '${e.id}/${e.name}').join(' ')}; userQueue: ${userQueue.map((e) => '${e.id}/${e.name}').join(' ')}",
      );
      userFirst();
    }
    List<Card> userCards = [];
    if (constants.PRIREDI_IGRO) {
      for (int k = 0; k < cards.length; k++) {
        int i = k - userCards.length;
        if (!(cards[i].asset == "/taroki/pagat" ||
            cards[i].asset == "/taroki/mond" ||
            cards[i].asset == "/taroki/skis" ||
            cards[i].asset == "/taroki/20" ||
            cards[i].asset == "/taroki/19" ||
            cards[i].asset == "/taroki/18" ||
            cards[i].asset == "/taroki/17" ||
            cards[i].asset == "/taroki/16")) continue;
        userCards.add(Card(card: cards[i], user: "player"));
        cards.removeAt(i);
      }
    }
    for (int i = 0; i < (54 - 6); i++) {
      if (i % ((54 - 6) / keys.length) == 0) {
        player++;
      }

      String user = keys[player];
      if (constants.PRIREDI_IGRO && user == "player" && userCards.isNotEmpty) {
        users[user]!.cards.add(userCards[0]);
        userCards.removeAt(0);
        continue;
      }

      constants.LocalCard card = cards[0];

      users[user]!.cards.add(Card(card: card, user: user));
      cards.removeAt(0);

      print(
        "Assigning card ${card.asset} to $user with ID $player. Remainder is ${cards.length}, user now has ${users[user]!.cards.length} cards.",
      );
    }
    talon = cards.map((e) => Card(card: e, user: "")).toList();
    print(
      "Talon consists of the following cards: ${talon.map((e) => e.card.asset).join(" ")}",
    );
  }

  int playingPerson() {
    for (int i = 0; i < userPositions.length; i++) {
      constants.User position = userPositions[i];
      if (users[position.id]!.playing) return i;
    }
    return -1;
  }

  int selectDeck(List<List<Card>> talon) {
    List<int> worth = [];
    for (int i = 0; i < talon.length; i++) {
      int wor = 0;
      for (int n = 0; n < talon[i].length; n++) {
        Card card = talon[i][n];
        String cardType = card.card.asset.split("/")[1];
        wor += card.card.worth;
        if (cardType == "taroki") {
          wor += (pow(card.card.worthOver, 2) / 300).round();
        }
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
    double worth = 0;
    for (int i = 0; i < cards.length; i++) {
      worth += cards[i].card.worth - 2 / 3;
    }
    return worth.round();
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

  constants.User? playingUser() {
    for (int i = 0; i < userQueue.length; i++) {
      constants.User user = userQueue[i];
      if (users[user.id]!.licitiral) {
        return user;
      }
    }
    return null;
  }

  List<String> getAllPlayingUsers() {
    List<String> playing = [];
    List<String> keys = users.keys.toList(growable: false);
    for (int i = 0; i < keys.length; i++) {
      if (users[keys[i]]!.playing || users[keys[i]]!.secretlyPlaying) {
        playing.add(users[keys[i]]!.user.id);
        //break;
      }
    }
    return playing;
  }

  // -1: nasprotniki so zbrali trulo
  // 1: igralci so zbrali trulo
  // 0: nihče ni zbral trule
  int hasTrula() {
    List<String> playing = playingUsers();
    int playingT = 0;
    int notPlayingT = 0;
    for (int i = 0; i < stihi.length; i++) {
      List<Card> stih = stihi[i];
      if (stih.isEmpty) continue;
      String picked = stihPickedUpBy(stih);
      bool playingPickedUp = playing.contains(picked);
      for (int n = 0; n < stih.length; n++) {
        String card = stih[n].card.asset;
        if (!(card == "/taroki/pagat" ||
            card == "/taroki/mond" ||
            card == "/taroki/skis")) continue;
        if (playingPickedUp) {
          print("Karto $card štejem igralcem, ker je igralec pobral.");
          playingT++;
          continue;
        }
        print("Karto $card štejem neigralcem, ker igralec ni pobral.");
        notPlayingT++;
      }
      if (playingT + notPlayingT == 3) break;
    }
    print("notPlayingT: $notPlayingT; playingT: $playingT");
    return playingT == 3 ? 1 : (notPlayingT == 3 ? -1 : 0);
  }

  int hasKralji() {
    List<String> playing = playingUsers();
    int playingT = 0;
    int notPlayingT = 0;
    for (int i = 0; i < stihi.length; i++) {
      List<Card> stih = stihi[i];
      if (stih.isEmpty) continue;
      String picked = stihPickedUpBy(stih);
      bool playingPickedUp = playing.contains(picked);
      for (int n = 0; n < stih.length; n++) {
        String card = stih[n].card.asset;
        if (!(card == "/src/kralj" ||
            card == "/kriz/kralj" ||
            card == "/kara/kralj" ||
            card == "/pik/kralj")) continue;
        if (playingPickedUp) {
          print("Karto $card štejem igralcem, ker je igralec pobral.");
          playingT++;
          continue;
        }
        print("Karto $card štejem neigralcem, ker igralec ni pobral.");
        notPlayingT++;
      }
      if (playingT + notPlayingT == 4) break;
    }
    print("notPlayingT: $notPlayingT; playingT: $playingT");
    return playingT == 4 ? 1 : (notPlayingT == 4 ? -1 : 0);
  }

  /*
  jah lej, to je neka big brain kalkulacija ipd. V glavnem, očitno obstaja neko zaporedje.
  Ne da se mi razlagat, ampak bi moralo delovati.

  tuki imaš latex

  \documentclass{article}
    \usepackage{amsmath}
    \begin{document}
    \[
      f(a, b)=\begin{cases}
                  b; a = 0 \lor b \ne 0 \\
                  -a; a \ne 0 \land b = 0
                \end{cases}
    \]
  \end{document}
  */
  int calculatePrediction(int predict, int collect) {
    if (predict == 0 || collect != 0) return collect;
    return -predict;
  }

  bool canGiveKontra(String person, bool isUserPlaying, int kontra) {
    if (person == "") return false;
    return (!isUserPlaying && kontra % 2 == 0) ||
        (isUserPlaying && kontra % 2 == 1);
  }

  String getCardType(String card) {
    return card.split("/")[1];
  }

  bool predict(String userId) {
    bool changes = false;
    User user = users[userId]!;
    Messages.Predictions newPredictions = Messages.Predictions(
      kraljUltimo: predictions.kraljUltimo,
      kraljUltimoKontra: predictions.kraljUltimoKontra,
      kraljUltimoKontraDal: predictions.kraljUltimoKontraDal,
      trula: predictions.trula,
      kralji: predictions.kralji,
      pagatUltimo: predictions.pagatUltimo,
      pagatUltimoKontra: predictions.pagatUltimoKontra,
      pagatUltimoKontraDal: predictions.pagatUltimoKontraDal,
      igra: predictions.igra,
      igraKontra: predictions.igraKontra,
      igraKontraDal: predictions.igraKontraDal,
      valat: predictions.valat,
      valatKontra: predictions.valatKontra,
      valatKontraDal: predictions.valatKontraDal,
      barvniValat: predictions.barvniValat,
      barvniValatKontra: predictions.barvniValatKontra,
      barvniValatKontraDal: predictions.barvniValatKontraDal,
      gamemode: predictions.gamemode,
    );
    List<Card> cards = user.cards;
    int taroki = 0;
    int rufanKralj = 0;
    if (selectedKing != "") {
      String kingType = getCardType(selectedKing);
      for (int i = 0; i < cards.length; i++) {
        Card card = cards[i];
        String cardType = getCardType(card.card.asset);
        if (cardType == kingType) rufanKralj++;
        if (cardType == "taroki") taroki++;
      }
      for (int i = 0; i < talon.length; i++) {
        if (kingType != getCardType(talon[i].card.asset)) continue;
        rufanKralj++;
      }
    }

    bool imaPagata = false;
    bool imaKralja = false;
    int trula = 0;
    for (int i = 0; i < cards.length; i++) {
      Card card = cards[i];
      if (card.card.asset == "/taroki/pagat") {
        imaPagata = true;
      }
      if (card.card.asset == selectedKing) {
        imaKralja = true;
      }
      if (card.card.asset == "/taroki/pagat" ||
          card.card.asset == "/taroki/mond" ||
          card.card.asset == "/taroki/skis") {
        trula++;
      }
    }

    int cardsPerPerson = 48 ~/ userPositions.length;
    if (cardsPerPerson * 0.65 < taroki) {
      if (canGiveKontra(
          newPredictions.kraljUltimo.id,
          user.playing || user.secretlyPlaying,
          newPredictions.kraljUltimoKontra)) {
        newPredictions.kraljUltimoKontra++;
        newPredictions.kraljUltimoKontraDal = Messages.User(
          id: user.user.id,
          name: user.user.name,
        );
        changes = true;
      }
      if (canGiveKontra(
          newPredictions.pagatUltimo.id,
          user.playing || user.secretlyPlaying,
          newPredictions.pagatUltimoKontra)) {
        newPredictions.pagatUltimoKontra++;
        newPredictions.pagatUltimoKontraDal = Messages.User(
          id: user.user.id,
          name: user.user.name,
        );
        changes = true;
      }
    }
    if (rufanKralj >= 4 && imaKralja && newPredictions.kraljUltimo.id == "") {
      newPredictions.kraljUltimo = Messages.User(
        id: user.user.id,
        name: user.user.name,
      );
      users[userId]!.playing = true;
      changes = true;
    }
    if (cardsPerPerson * 0.65 < taroki &&
        imaPagata &&
        newPredictions.pagatUltimo.id == "") {
      newPredictions.pagatUltimo = Messages.User(
        id: user.user.id,
        name: user.user.name,
      );
      changes = true;
    }
    if (cardsPerPerson * 0.4 < taroki &&
        trula == 3 &&
        newPredictions.trula.id == "") {
      newPredictions.trula = Messages.User(
        id: user.user.id,
        name: user.user.name,
      );
      changes = true;
    }
    // kraljev se tko ne napoveduje, ker ti vsako igro neki nepredvideno režejo
    predictions = newPredictions;
    return changes;
  }

  Messages.StartPredictions getStartPredictions() {
    Messages.StartPredictions startPredictions = Messages.StartPredictions();
    List<String> playing = getAllPlayingUsers();

    bool playerPlaying = playing.contains("player");
    if (predictions.igra.id != "" &&
        !playerPlaying &&
        predictions.igraKontra % 2 == 0) {
      startPredictions.igraKontra = true;
    }

    if (gamemode >= 6) return startPredictions;

    startPredictions.trula = predictions.trula.id == "";
    startPredictions.kralji = predictions.kralji.id == "";

    bool gameKontra = playing.contains(predictions.igraKontraDal.id);
    bool kraljUltimoKontra =
        playing.contains(predictions.kraljUltimoKontraDal.id);
    bool pagatUltimoKontra =
        playing.contains(predictions.pagatUltimoKontraDal.id);
    bool valatKontra = playing.contains(predictions.valatKontraDal.id);
    bool barvicKontra = playing.contains(predictions.barvniValatKontraDal.id);

    if (canGiveKontra(predictions.kraljUltimo.id, playerPlaying,
        predictions.kraljUltimoKontra)) {
      startPredictions.kraljUltimoKontra = true;
    }
    if (canGiveKontra(predictions.pagatUltimo.id, playerPlaying,
        predictions.pagatUltimoKontra)) {
      startPredictions.pagatUltimoKontra = true;
    }

    List<Card> userCards = users["player"]!.cards;
    for (int i = 0; i < userCards.length; i++) {
      Card card = userCards[i];
      if (card.card.asset == "/taroki/pagat" &&
          predictions.pagatUltimo.id == "") {
        startPredictions.pagatUltimo = true;
      }

      if (card.card.asset == selectedKing && predictions.kraljUltimo.id == "") {
        startPredictions.kraljUltimo = true;
      }
    }

    logger.d(
      "predictions.igra.id je ${predictions.igra.id != ""}, ${predictions.igra.id}, kjer igralec (ne) igra: $playerPlaying in je stanje kontre ${predictions.igraKontra}",
    );

    return startPredictions;
  }

  int hasPagatUltimo() {
    // pushamo nov empty [], tako da je dejanski zadnji na -2
    List<Card> stih = stihi[stihi.length - 2];
    bool pagatInside = false;
    for (int i = 0; i < stih.length; i++) {
      print("Stih: ${stih[i].card.asset}");
      if (stih[i].card.asset != "/taroki/pagat") continue;
      pagatInside = true;
      break;
    }

    // pagata ni not v štihu
    if (!pagatInside) return 0;

    StihAnalysis analysis = analyzeStih(stih)!;

    // pagat ni pobral
    if (analysis.cardPicks.card.asset != "/taroki/pagat") return -1;

    List<String> playing = playingUsers();
    String picked = stihPickedUpBy(stih);
    bool playingPickedUp = playing.contains(picked);
    return playingPickedUp ? 1 : -1;
  }

  int hasKraljUltimo() {
    // pushamo nov empty [], tako da je dejanski zadnji na -2
    List<Card> stih = stihi[stihi.length - 2];
    bool kraljInside = false;
    for (int i = 0; i < stih.length; i++) {
      print("Stih: ${stih[i].card.asset} $selectedKing");
      if (stih[i].card.asset != selectedKing) continue;
      kraljInside = true;
      break;
    }

    // pagata ni not v štihu
    if (!kraljInside) return 0;

    List<String> playing = playingUsers();
    String picked = stihPickedUpBy(stih);
    bool playingPickedUp = playing.contains(picked);
    return playingPickedUp ? 1 : -1;
  }

  int isValat() {
    List<String> playing = playingUsers();
    int p = 0;
    int np = 0;
    for (int i = 0; i < stihi.length; i++) {
      if (stihi[i].isEmpty) continue;
      String picked = stihPickedUpBy(stihi[i]);
      if (playing.contains(picked)) {
        p++;
      } else {
        np++;
      }
    }

    if (p == 0) {
      return -1;
    } else if (np == 0) {
      return 1;
    }
    return 0;
  }

  Messages.Results calculateGame() {
    Map<String, List<Card>> results = {};
    List<String> playing = playingUsers();
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
        "Pobral $by, pri čimer igrajo $playing in štih je dolg ${stih.length}",
      );
      if (by == "") {
        logger.e("error while counting points");
        continue;
      }
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

    if (gamemode != -1 && gamemode < 6) {
      // NORMALNE IGRE
      constants.User actuallyPlayingUser = playingUser()!;

      int playingPlayed = 0;
      for (int i = 0; i < keys.length; i++) {
        User user = users[keys[i]]!;
        if (playing.contains(user.user.id)) {
          playingPlayed += calculateTotal(results[user.user.id]!);
        }
      }
      int diff = playingPlayed - 35;
      int gamemodeWorth = 0;
      for (int i = 0; i < GAMES.length; i++) {
        if (GAMES[i].id == gamemode) {
          gamemodeWorth = GAMES[i].worth;
          break;
        }
      }

      int trula = hasTrula();
      bool trulaNapovedana = predictions.trula.id != "";
      int trulaPrediction = !trulaNapovedana
          ? 0
          : (playing.contains(predictions.trula.id) ? 1 : -1);
      int trulaCalc = calculatePrediction(trulaPrediction, trula);
      int trulaTotal = 10 * (trulaNapovedana ? 2 : 1) * trulaCalc;

      int kralji = hasKralji();
      bool kraljiNapovedani = predictions.kralji.id != "";
      int kraljiPrediction = !kraljiNapovedani
          ? 0
          : (playing.contains(predictions.kralji.id) ? 1 : -1);
      int kraljiCalc = calculatePrediction(kraljiPrediction, kralji);
      int kraljiTotal = 10 * (kraljiNapovedani ? 2 : 1) * kraljiCalc;

      int pagatUltimo = hasPagatUltimo();
      bool pagatUltimoNapovedan = predictions.pagatUltimo.id != "";
      int pagatUltimoPrediction = !pagatUltimoNapovedan
          ? 0
          : (playing.contains(predictions.pagatUltimo.id) ? 1 : -1);
      int pagatUltimoCalc =
          calculatePrediction(pagatUltimoPrediction, pagatUltimo);
      int pagatUltimoTotal = 25 *
          (pagatUltimoNapovedan ? 2 : 1) *
          pagatUltimoCalc *
          pow(2, predictions.pagatUltimoKontra).toInt();

      int kraljUltimo = hasKraljUltimo();
      bool kraljUltimoNapovedan = predictions.kraljUltimo.id != "";
      int kraljUltimoPrediction = !kraljUltimoNapovedan
          ? 0
          : (playing.contains(predictions.kraljUltimo.id) ? 1 : -1);
      int kraljUltimoCalc =
          calculatePrediction(kraljUltimoPrediction, kraljUltimo);
      int kraljUltimoTotal = 10 *
          (kraljUltimoNapovedan ? 2 : 1) *
          kraljUltimoCalc *
          pow(2, predictions.kraljUltimoKontra).toInt();

      int valat = isValat();
      bool valatNapovedan = predictions.valat.id != "";
      int valatPrediction = !valatNapovedan
          ? 0
          : (playing.contains(predictions.valat.id) ? 1 : -1);
      int valatCalc = calculatePrediction(valatPrediction, valat);
      int valatTotal = 250 *
          (valatNapovedan ? 2 : 1) *
          valatCalc *
          pow(2, predictions.valatKontra).toInt();

      if (valatTotal != 0) {
        newResults.add(
          Messages.ResultsUser(
            user: users.keys.map((key) => users[key]!.playing
                ? Messages.User(id: key, name: users[key]!.user.name)
                : Messages.User(id: "", name: "")),
            mondfang: false,
            showDifference: false,
            showGamemode: true,
            showKralj: false,
            showKralji: false,
            showPagat: false,
            showTrula: false,
            trula: 0,
            kralji: 0,
            pagat: 0,
            kralj: 0,
            kontraIgra: 0,
            kontraKralj: 0,
            kontraPagat: 0,
            igra: valatTotal,
            razlika: 0,
            points: valatTotal,
          ),
        );
        return Messages.Results(user: newResults);
      }

      print(
          "Rezultat igre $gamemodeWorth z razliko $diff, pri čemer je igralec pobral $playingPlayed.");
      print(
        "Trula se je štela po principu, da ima trulo $trula, stanje napovedi je $trulaNapovedana, trulo je potemtakem napovedal $trulaPrediction. " +
            "Kalkulacija pravi, da je trula skupaj $trulaCalc. Skupaj se je trula štela kot $trulaTotal.",
      );
      print(
        "Pagat ultimo se je štel po principu, da ima ultimo $pagatUltimo, stanje napovedi je $pagatUltimoNapovedan, trulo je potemtakem napovedal $pagatUltimoPrediction. " +
            "Kalkulacija pravi, da je trula skupaj $pagatUltimoCalc. Skupaj se je trula štela kot $pagatUltimoTotal.",
      );
      if (diff <= 0) {
        gamemodeWorth *= -1;
      }

      int kontraIgra = pow(2, predictions.igraKontra).toInt();

      diff *= kontraIgra;
      gamemodeWorth *= kontraIgra;

      if (actuallyPlayingUser.radlci > 0) {
        if (diff > 0) {
          actuallyPlayingUser.radlci--;
        }
        diff *= 2;
      }

      int total = gamemodeWorth +
          diff +
          trulaTotal +
          kraljiTotal +
          pagatUltimoTotal +
          kraljUltimoTotal;

      newResults.add(
        Messages.ResultsUser(
          user: users.keys.map((key) => users[key]!.playing
              ? Messages.User(id: key, name: users[key]!.user.name)
              : Messages.User(id: "", name: "")),
          mondfang: false,
          showDifference: true,
          showGamemode: true,
          showKralj: kraljUltimoNapovedan || kraljUltimo != 0,
          showKralji: kraljiNapovedani || kralji != 0,
          showPagat: pagatUltimoNapovedan || pagatUltimo != 0,
          showTrula: trulaNapovedana || trula != 0,
          trula: trulaTotal,
          kralji: kraljiTotal,
          pagat: pagatUltimoTotal,
          kralj: kraljUltimoTotal,
          kontraIgra: predictions.igraKontra,
          kontraKralj: predictions.kraljUltimoKontra,
          kontraPagat: predictions.pagatUltimoKontra,
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
            points: -21,
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
    } else if (gamemode == 6) {
      // BERAČ, TODO: ODPRTI BERAČ
      constants.User actuallyPlayingUser = playingUser()!;

      int kontraIgra = pow(2, predictions.igraKontra).toInt();
      int gamemode = 70;
      gamemode *= kontraIgra;

      newResults.add(
        Messages.ResultsUser(
          user: users.keys.map((key) => users[key]!.playing
              ? Messages.User(id: key, name: users[key]!.user.name)
              : Messages.User(id: "", name: "")),
          mondfang: false,
          showDifference: false,
          showGamemode: true,
          showKralj: false,
          showKralji: false,
          showPagat: false,
          showTrula: false,
          trula: 0,
          kralji: 0,
          pagat: 0,
          kralj: 0,
          kontraIgra: predictions.igraKontra,
          kontraKralj: predictions.kraljUltimoKontra,
          kontraPagat: predictions.pagatUltimoKontra,
          igra:
              (results[actuallyPlayingUser.id]!.isNotEmpty ? -1 : 1) * gamemode,
          razlika: 0,
          points:
              (results[actuallyPlayingUser.id]!.isNotEmpty ? -1 : 1) * gamemode,
        ),
      );
    } else {
      // KLOP
      bool none = false;
      bool full = false;
      for (int i = 0; i < keys.length; i++) {
        User user = users[keys[i]]!;
        int diff = calculateTotal(results[user.user.id]!);
        if (diff == 0) {
          none = true;
          newResults.add(Messages.ResultsUser(
            user: [Messages.User(id: user.user.id, name: user.user.name)],
            showDifference: true,
            showGamemode: false,
            showKralj: false,
            showKralji: false,
            showPagat: false,
            showTrula: false,
            razlika: 0,
            points: 70,
          ));
        } else if (diff > 35) {
          full = true;
          newResults.add(Messages.ResultsUser(
            user: [Messages.User(id: user.user.id, name: user.user.name)],
            showDifference: true,
            showGamemode: false,
            showKralj: false,
            showKralji: false,
            showPagat: false,
            showTrula: false,
            razlika: -diff,
            points: -70,
          ));
        }
      }
      if (!none && !full) {
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

  int getUser() {
    for (int i = 0; i < userPositions.length; i++) {
      if (userPositions[i].id == "player") return i;
    }
    return -1;
  }
}
