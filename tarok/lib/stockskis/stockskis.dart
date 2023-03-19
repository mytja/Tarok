import "dart:math";

import "../constants.dart" as constants;

class StihAnalysis {
  StihAnalysis({required this.cardPicks, required this.worth});

  Card cardPicks;
  int worth;
}

class User {
  User(
      {required this.user,
      required this.cards,
      required this.playing,
      required this.secretlyPlaying});

  final constants.User user;
  final List<Card> cards;
  // uporabnik igra, ve se da on igra
  bool playing;
  // uporabnik igra, ampak se še ne ve, kajti kralj ni padel
  bool secretlyPlaying;
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
  int gamemode = -1;

  List<Move> evaluateMoves(String userId) {
    List<Move> moves = [];

    if (users[userId] == null) return [];
    User user = users[userId]!;

    List<Card> stih = stihi.last;
    if (stih.isEmpty) {
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
          srci++;
        } else if (cardType == "pik") {
          piki++;
        } else if (cardType == "kara") {
          kare++;
        } else {
          krizi++;
        }
      }
      for (int i = 0; i < user.cards.length; i++) {
        Card card = user.cards[i];
        String cardType = card.card.asset.split("/")[1];

        int penalty = 0;

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

      for (int i = 0; i < user.cards.length; i++) {
        Card card = user.cards[i];
        String currentCardType = card.card.asset.split("/")[1];
        if (hasColor && cardType != currentCardType) continue;
        if (!hasColor && hasTarocks && currentCardType != "taroki") continue;

        int penalty = 0;

        // če se lahko bot stegne, potem ne kaznujemo, ampak celo nagradimo
        if (analysis.cardPicks.card.worthOver < card.card.worthOver) {
          penalty -= 2;
        }

        // če se bot preveč stegne, ga kaznujemo
        penalty +=
            max(0, card.card.worthOver - analysis.cardPicks.card.worthOver);

        // ali bot šenka punte pravi osebi?
        int p = 1;
        if (user.secretlyPlaying || user.playing) {
          int p = 1;
          if (users[analysis.cardPicks.user]!.playing) {
            // kazen bo negativna
            p = -1;
          }
        } else {
          p = -1;
          if (users[analysis.cardPicks.user]!.playing) {
            // kazen bo negativna
            p = 1;
          }
        }
        penalty += ((card.card.worth * card.card.worth) / 3).round() * p;

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
        srci++;
      } else if (cardType == "pik") {
        piki++;
      } else if (cardType == "kara") {
        kare++;
      } else {
        krizi++;
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

    // berač
    if (myRating < maximumRating * 0.1) modes.add(6);
    // odprti berač
    if (myRating < maximumRating * 0.05) modes.add(8);
    // solo brez
    if (myRating > maximumRating * 0.90) modes.add(7);
    // barvni valat
    if (srci >= 5 || piki >= 5 || krizi >= 5 || kare >= 5) modes.add(9);
    // valat
    if (myRating >= maximumRating * 0.80) modes.add(10);
    // tri
    if (myRating >= maximumRating * 0.40) modes.add(0);
    // dva
    if (myRating >= maximumRating * 0.50) modes.add(1);
    // ena
    if (myRating >= maximumRating * 0.60) modes.add(2);

    // igre, ki se igrajo samo v 4
    if (users.length != 3) {
      // solo tri
      if (myRating >= maximumRating * 0.55) modes.add(3);
      // solo dva
      if (myRating >= maximumRating * 0.65) modes.add(4);
      // solo ena
      if (myRating >= maximumRating * 0.75) modes.add(5);
    }

    // dalje
    if (myRating < maximumRating * 0.45) modes.add(-1);

    modes.sort();
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

  void doRandomShuffle() {
    List<constants.LocalCard> cards = constants.CARDS.toList();
    cards.shuffle();
    int player = -1;
    List<String> keys = users.keys.toList(growable: false);
    for (int i = 0; i < (54 - 6); i++) {
      if (i % ((54 - 6) / keys.length) == 0) {
        player++;
      }
      users[keys[player]]!.cards.add(Card(card: cards[i], user: keys[player]));
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
}
