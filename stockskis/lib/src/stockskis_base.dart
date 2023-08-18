// ignore_for_file: avoid_print, prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings, library_prefixes

import "dart:convert";
import "dart:developer";
import "dart:math";

import "package:logger/logger.dart";
import "package:stockskis/src/cards.dart";
import "package:stockskis/src/configuration.dart";
import "package:stockskis/src/gamemodes.dart";
import "package:stockskis/src/types.dart";

var logger = Logger();

void debugPrint(Object? p) {
  if (!DEBUG_LOGGING) return;
  print(p);
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
  List<String> userPositions = [];
  final int stihiCount;
  bool kingFallen = false;
  int gamemode = -1;
  Predictions predictions;
  String selectedKing = "";
  bool skisfang = false;

  static StockSkis fromJSON(String json) {
    final j = jsonDecode(json);

    List<List<Card>> stihi = [];
    for (int i = 0; i < j["stihi"].length; i++) {
      List<Card> stih = [];
      for (int n = 0; n < j["stihi"][i].length; n++) {
        final card = j["stihi"][i][n];
        stih.add(
          Card(
            card: LocalCard(
              asset: card["asset"],
              worth: card["worth"],
              worthOver: card["worthOver"],
              alt: "",
            ),
            user: card["user"],
          ),
        );
      }
      stihi.add(stih);
    }

    int stihiCount = ((54 - 6) / j["users"].length).round();

    Map<String, User> users = {};
    List<String> userPositions = [];
    for (int i = 0; i < j["users"].length; i++) {
      final user = j["users"][i];
      List<Card> karte = [];
      for (int n = 0; n < user["cards"].length; n++) {
        final card = user["cards"][n];
        karte.add(
          Card(
            card: LocalCard(
              asset: card["asset"],
              worth: card["worth"],
              worthOver: card["worthOver"],
              alt: "",
            ),
            user: user["id"],
          ),
        );
      }

      final su = SimpleUser(id: user["id"], name: user["name"]);

      User u = User(
        user: su,
        cards: karte,
        playing: user["playing"],
        secretlyPlaying: user["secretlyPlaying"],
        botType: "normal",
        licitiral: user["licitated"],
      );

      users[user["id"]] = u;
      userPositions.add(su.id);
    }

    List<Card> talon = [];
    for (int i = 0; i < j["talon"].length; i++) {
      final card = j["talon"][i];
      talon.add(
        Card(
          card: LocalCard(
              asset: card["asset"],
              worth: card["worth"],
              worthOver: card["worthOver"],
              alt: ""),
          user: "",
        ),
      );
    }

    final p = j["predictions"];
    Predictions predictions = Predictions(
      kraljUltimo: SimpleUser(
        id: p["kraljUltimo"]["id"],
        name: p["kraljUltimo"]["name"],
      ),
      kraljUltimoKontra: p["kraljUltimoKontra"],
      kraljUltimoKontraDal: SimpleUser(
        id: p["kraljUltimoKontraDal"]["id"],
        name: p["kraljUltimoKontraDal"]["name"],
      ),
      pagatUltimo: SimpleUser(
        id: p["pagatUltimo"]["id"],
        name: p["pagatUltimo"]["name"],
      ),
      pagatUltimoKontra: p["pagatUltimoKontra"],
      pagatUltimoKontraDal: SimpleUser(
        id: p["pagatUltimoKontraDal"]["id"],
        name: p["pagatUltimoKontraDal"]["name"],
      ),
      igra: SimpleUser(
        id: p["igra"]["id"],
        name: p["igra"]["name"],
      ),
      igraKontra: p["igraKontra"],
      igraKontraDal: SimpleUser(
        id: p["igraKontraDal"]["id"],
        name: p["igraKontraDal"]["name"],
      ),
      valat: SimpleUser(
        id: p["valat"]["id"],
        name: p["valat"]["name"],
      ),
      valatKontra: p["valatKontra"],
      valatKontraDal: SimpleUser(
        id: p["valatKontraDal"]["id"],
        name: p["valatKontraDal"]["name"],
      ),
      barvniValat: SimpleUser(
        id: p["barvniValat"]["id"],
        name: p["barvniValat"]["name"],
      ),
      barvniValatKontra: p["barvniValatKontra"],
      barvniValatKontraDal: SimpleUser(
        id: p["barvniValatKontraDal"]["id"],
        name: p["barvniValatKontraDal"]["name"],
      ),
      trula: SimpleUser(
        id: p["trula"]["id"],
        name: p["trula"]["name"],
      ),
      kralji: SimpleUser(
        id: p["kralji"]["id"],
        name: p["kralji"]["name"],
      ),
      gamemode: p["gamemode"],
      changed: false,
    );

    bool kingFallen = j["kingFallen"];
    String selectedKing = j["selectedKing"];
    int gamemode = j["gamemode"];
    bool skisfang = j["skisfang"];

    StockSkis stockskis = StockSkis(
        users: users, stihiCount: stihiCount, predictions: predictions)
      ..stihi = stihi
      ..talon = talon
      ..userPositions = userPositions
      ..kingFallen = kingFallen
      ..gamemode = gamemode
      ..selectedKing = selectedKing
      ..skisfang = skisfang;

    return stockskis;
  }

  List<Move> evaluateMoves(String userId) {
    List<Move> moves = [];

    if (users[userId] == null) return [];
    User user = users[userId]!;

    List<Card> stih = stihi.last;
    debugPrint(stihi);

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
        // palčka je na 11
        int worthOver = (card.card.worthOver - 11);
        tarokiWorth += pow(worthOver, 1.5).round();
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

    int krogKare = 0;
    int krogKriza = 0;
    int krogPika = 0;
    int krogSrca = 0;
    for (int i = 0; i < stihi.length; i++) {
      if (stihi[i].isEmpty) continue;
      Card prvaKarta = stihi[i].first;
      String type = getCardType(prvaKarta.card.asset);
      if (type == "kara") {
        krogKare++;
      } else if (type == "kriz") {
        krogKriza++;
      } else if (type == "pik") {
        krogPika++;
      } else if (type == "src") {
        krogSrca++;
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

        // klop in oba berača
        if (gamemode == -1 ||
            ((gamemode == 6 || gamemode == 8) && !user.playing)) {
          // klop in oba berača (samo za neigralce)
          // yes, negativna evaluacija
          if (card.card.asset == "/taroki/mond" && gamemode == 1) {
            // poskusimo, da kdo drug faše monda, seveda samo pri klopu
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
                  evaluation:
                      -((card.card.worthOver - 11) + tarokiWorth / taroki)
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
        } else if (gamemode == 6 || gamemode == 8 && user.playing) {
          // berač in odprti berač (samo za igralca, vrže najbolj riskantno karto)
          if (cardType == "taroki") {
            moves.add(
              Move(
                card: card,
                evaluation: pow(((card.card.worthOver - 11) / 3), 1.5).round(),
              ),
            );
          } else if (cardType == "src") {
            moves.add(
              Move(
                card: card,
                evaluation:
                    (srciWorth - pow(srci, 1.5) - pow(card.card.worth / 2, 2))
                        .round(),
              ),
            );
          } else if (cardType == "pik") {
            moves.add(
              Move(
                card: card,
                evaluation:
                    (pikiWorth - pow(piki, 1.5) - pow(card.card.worth / 2, 2))
                        .round(),
              ),
            );
          } else if (cardType == "kara") {
            moves.add(
              Move(
                card: card,
                evaluation:
                    (kareWorth - pow(kare, 1.5) - pow(card.card.worth / 2, 2))
                        .round(),
              ),
            );
          } else {
            moves.add(
              Move(
                card: card,
                evaluation:
                    (kriziWorth - pow(krizi, 1.5) - pow(card.card.worth / 2, 2))
                        .round(),
              ),
            );
          }
          continue;
        }

        int penalty = 0;

        // BARVNI VALAT
        if (gamemode == 9) {
          String prevCardType =
              stihi.length - 1 > 0 && stihi[stihi.length - 1].isNotEmpty
                  ? getCardType(stihi[stihi.length - 1][0].card.asset)
                  : "";
          if (cardType == "src") {
            penalty -= (srci * srci).round();
          } else if (cardType == "pik") {
            penalty -= (piki * piki).round();
          } else if (cardType == "kara") {
            penalty -= (kare * kare).round();
          } else if (cardType == "kriz") {
            penalty -= (krizi * krizi).round();
          } else if (cardType == "taroki") {
            penalty += 100;
          }

          if (cardType == prevCardType) {
            penalty *= 10;
          }

          moves.add(
            Move(
              card: card,
              evaluation: card.card.worthOver - penalty,
            ),
          );

          continue;
        }

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

          // čim bolj proti koncu igre gremo, tem bolj si želimo imeti taroke
          penalty += pow(stihi.length, 2).toInt();
        } else {
          // damo kazen, če mečemo gor točke, pri tem pa imamo ogromno iste barve + je bilo že veliko krogov te iste barve
          // naj bo kazen barva^2 / 2
          int maxSafe = (7 / userPositions.length).floor();
          if (cardType == "src") {
            penalty += ((srci * srci) / 2).round();
            if (maxSafe < krogSrca) {
              penalty += pow(card.card.worth, krogSrca).round();
            }
          } else if (cardType == "pik") {
            penalty += ((piki * piki) / 2).round();
            if (maxSafe < krogPika) {
              penalty += pow(card.card.worth, krogPika).round();
            }
          } else if (cardType == "kara") {
            penalty += ((kare * kare) / 2).round();
            if (maxSafe < krogKare) {
              penalty += pow(card.card.worth, krogKare).round();
            }
          } else if (cardType == "kriz") {
            penalty += ((krizi * krizi) / 2).round();
            if (maxSafe < krogKriza) {
              penalty += pow(card.card.worth, krogKriza).round();
            }
          }
          if (selectedKing != "") {
            // reskiraš da boš to karto vrgel nasprotni ekipi
            if (getCardType(selectedKing) != getCardType(card.card.asset)) {
              penalty += pow(card.card.worth, 2).round();
            }
          }
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
          debugPrint("kazen za monda $penalty");
        }

        if (selectedKing != "" &&
            getCardType(selectedKing) == getCardType(card.card.asset) &&
            user.secretlyPlaying) {
          // s svojo barvo se tko nikoli ne pride ven, ker je res nepotrebno
          penalty += 200;
        }
        if (selectedKing == card.card.asset &&
            predictions.kraljUltimo.id != "") {
          penalty += 200;
        }
        if (card.card.asset == "/taroki/pagat" &&
            predictions.pagatUltimo.id != "") {
          penalty += 300;
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

      debugPrint(
          "User $userId hasOver=$hasOver, hasColor=$hasColor, hasTarocks=$hasTarocks, stihPicks=${analysis.cardPicks.card.worthOver}, hasPlayerCard=$hasPlayerCard, gamemode=$gamemode");

      for (int i = 0; i < user.cards.length; i++) {
        Card card = user.cards[i];
        String currentCardType = card.card.asset.split("/")[1];
        if (hasColor && cardType != currentCardType) continue;
        if (!hasColor && hasTarocks && currentCardType != "taroki") continue;

        debugPrint(
            "Legal move $card with ${card.card.worth} and ${card.card.asset} - ${card.card.worthOver}");

        // barvič
        if (gamemode == 9) {
          if (currentCardType == cardType &&
              card.card.worthOver > analysis.cardPicks.card.worthOver) {
            moves.add(Move(card: card, evaluation: card.card.worthOver));
            continue;
          }
          moves.add(Move(card: card, evaluation: -card.card.worthOver));
          continue;
        }

        // klop in berač
        if (gamemode == 6 || gamemode == 8 || gamemode == -1) {
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

        // monda se ne da kar tako ven, razen če je padel škis
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
          debugPrint("kazen za monda $penalty");
        }

        // če igramo na pagat ultimo, moramo zbijati taroke - enako velja če neigrajoči napove pagatka
        if (currentCardType == "taroki" &&
            card.card.asset != "/taroki/pagat" &&
            predictions.pagatUltimo.id != "" &&
            user.secretlyPlaying) {
          penalty -= card.card.worthOver - 11;
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

        String firstCardType = getCardType(stih.first.card.asset);

        // če se lahko bot stegne, potem ne kaznujemo, ampak celo nagradimo
        // če se lahko stegne, je to bolj vredno kakor če se ne more
        if (analysis.cardPicks.card.worthOver < card.card.worthOver) {
          if (stihi.last.length == users.length - 1) {
            // uporabnik je zadnji, posledično se mora stegniti čim manj
            penalty += card.card.worthOver;
            penalty -= pow(card.card.worth, 2).toInt();
          }
          // bot naj se pravilno ne bi stegnil čez tiste, s katerimi igra, če ti že poberejo štih
          if (stihPobereIgralec == user.playing) {
            penalty += pow(card.card.worthOver / 3, 2).toInt();
          }
          // če je to eden izmed prvih štihov, naj se ne stegne preveč
          // ko pridemo do višjega kroga, se bo bolj stegnil
          // slednje velja samo za taroke
          // seveda če je igralec zadnji, se to ne upošteva
          if (currentCardType == "taroki" &&
              stihi.last.length != users.length - 1) {
            // palčke prav tako nikoli ne poskušaj pripeljati čez na 2. krog
            if (firstCardType == "kara") {
              penalty += pow(
                card.card.worthOver / 2,
                (12 / userPositions.length - krogKare),
              ).toInt();
              if (card.card.asset == "/taroki/pagat" && krogKare >= 2) {
                penalty += pow(10, krogKare).toInt();
              }
            } else if (firstCardType == "pik") {
              penalty += pow(
                card.card.worthOver / 2,
                (12 / userPositions.length - krogPika),
              ).toInt();
              if (card.card.asset == "/taroki/pagat" && krogPika >= 2) {
                penalty += pow(10, krogPika).toInt();
              }
            } else if (firstCardType == "kriz") {
              penalty += pow(
                card.card.worthOver / 2,
                (12 / userPositions.length - krogKriza),
              ).toInt();
              if (card.card.asset == "/taroki/pagat" && krogKriza >= 2) {
                penalty += pow(10, krogKriza).toInt();
              }
            } else if (firstCardType == "src") {
              penalty += pow(
                card.card.worthOver / 2,
                (12 / userPositions.length - krogSrca),
              ).toInt();
              if (card.card.asset == "/taroki/pagat" && krogSrca >= 2) {
                penalty += pow(10, krogSrca).toInt();
              }
            }
          }
          penalty -= pow(analysis.worth, 2).toInt();
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
        debugPrint(
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

            debugPrint(
                "Status kralja: $kingFallen, posledično je kazen (negativna=false) $k");
            if (k) {
              // kazen bo negativna
              p = 1;
            }
          }
          penalty += pow(card.card.worth, 3).round() * p;
        }

        // poskušaj se ne znebiti kart če imaš napovedan kralj ultimo
        if (selectedKing != "" &&
            getCardType(selectedKing) == currentCardType &&
            predictions.kraljUltimo.id == user.user.id) {
          penalty += 100;
        }
        if (card.card.asset == "/taroki/pagat" &&
            predictions.pagatUltimo.id != "") {
          penalty += 200;
        }

        debugPrint(
            "Evaluation for card ${card.card.asset} with penalty of $penalty");

        moves.add(
          Move(
            card: card,
            evaluation: card.card.worth - penalty,
          ),
        );
      }
    }

    debugPrint(
      "=========== StockŠkis evaluacija za uporabnika ${user.user.id} ===========",
    );
    for (int i = 0; i < moves.length; i++) {
      debugPrint(
        "Karta ${moves[i].card.card.asset} z evaluacijo ${moves[i].evaluation}",
      );
    }
    debugPrint(
      "==========================================================================",
    );

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
      if (gamemode == 9) {
        if (cardType == currentCardType &&
            analysis.cardPicks.card.worthOver < currentCard.card.worthOver) {
          analysis.cardPicks = currentCard;
        }
        continue;
      }
      if (!(cardType == currentCardType || currentCardType == "taroki")) {
        continue;
      }
      if (analysis.cardPicks.card.worthOver < currentCard.card.worthOver) {
        analysis.cardPicks = currentCard;
      }
    }
    return analysis;
  }

  // napovej/igre/game/gamemodes
  List<int> suggestModes(String userId, {bool canLicitateThree = false}) {
    debugPrint(
        "Funkcija suggestModes($userId, $canLicitateThree) je bila klicana");

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
    for (int i = CARDS.length - 1;
        i > CARDS.length - 1 - ((54 - 6) / users.length);
        i--) {
      maximumRating += CARDS[i].worthOver;
    }

    int myRating = 0;
    for (int i = 0; i < user.cards.length; i++) {
      Card card = user.cards[i];
      myRating += card.card.worthOver;
    }

    logger.d(
        "Evaluacija za osebo $userId je $myRating, kar je ${myRating / maximumRating}% največje evaluacije.");

    // berač
    if (user.botType == "berac" || user.botType == "vrazji") {
      if (myRating < maximumRating * 0.3 &&
          !(srci >= 25 || piki >= 25 || krizi >= 25 || kare >= 25)) {
        modes.add(6);
      }
      if (myRating < maximumRating * 0.25) modes.add(8);
    } else {
      if (myRating < maximumRating * 0.27 &&
          !(srci >= 27 || piki >= 27 || krizi >= 27 || kare >= 27)) {
        modes.add(6);
      }
      if (myRating < maximumRating * 0.22) modes.add(8);
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
        // solo tri (barvni valat)
        if (myRating >= maximumRating * 0.55 ||
            srci >= 25 ||
            piki >= 25 ||
            krizi >= 25 ||
            kare >= 25) modes.add(3);
        // solo dva
        if (myRating >= maximumRating * 0.65) modes.add(4);
        // solo ena
        if (myRating >= maximumRating * 0.75) modes.add(5);
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
        // solo tri (barvni valat)
        if (myRating >= maximumRating * 0.65 ||
            srci >= 27 ||
            piki >= 27 ||
            krizi >= 27 ||
            kare >= 27) modes.add(3);
        // solo dva
        if (myRating >= maximumRating * 0.75) modes.add(4);
        // solo ena
        if (myRating >= maximumRating * 0.85) modes.add(5);
      }

      // dalje
      if (myRating < maximumRating * 0.45) modes.add(-1);
    }

    modes.sort();
    // evaluation
    inspect(modes);

    bool isMandatory = userPositions.last == userId;
    List<int> toRemove = [];
    for (int i = 0; i < modes.length; i++) {
      if (modes[i] == -1) continue;
      if (modes[i] >= gamemode && isMandatory) continue;
      if (modes[i] > gamemode) continue;
      toRemove.add(modes[i]);
    }
    for (int i = 0; i < toRemove.length; i++) {
      modes.remove(toRemove[i]);
    }
    modes.sort();

    if (modes.isEmpty) {
      modes.add(-1);
    }

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

  bool barvic(String userId) {
    User user = users[userId]!;

    int srci = 0;
    int piki = 0;
    int krizi = 0;
    int kare = 0;
    for (int i = 0; i < user.cards.length; i++) {
      Card card = user.cards[i];
      String cardType = card.card.asset.split("/")[1];
      if (cardType == "src") {
        srci += card.card.worthOver;
      } else if (cardType == "pik") {
        piki += card.card.worthOver;
      } else if (cardType == "kara") {
        kare += card.card.worthOver;
      } else {
        krizi += card.card.worthOver;
      }
    }

    return (user.botType == "vrazji" &&
            (srci >= 25 || piki >= 25 || krizi >= 25 || kare >= 25)) ||
        (srci >= 27 || piki >= 27 || krizi >= 27 || kare >= 27);
  }

  void resetContext() {
    List<String> keys = users.keys.toList(growable: false);
    for (int i = 0; i < keys.length; i++) {
      String key = keys[i];
      users[key]!.playing = false;
      users[key]!.secretlyPlaying = false;
      users[key]!.licitiral = false;
      users[key]!.cards = [];
    }
    selectedKing = "";
    stihi = [[]];
    talon = [];
    gamemode = -1;
    kingFallen = false;

    // naslednja oseba v rotaciji
    String firstUser = userPositions.first;
    userPositions.removeAt(0);
    userPositions.add(firstUser);
  }

  List<User> buildPositions() {
    List<User> u = [];
    for (int i = 0; i < userPositions.length; i++) {
      u.add(users[userPositions[i]]!);
    }
    return u;
  }

  List<SimpleUser> buildPositionsSimple() {
    List<SimpleUser> u = [];
    for (int i = 0; i < userPositions.length; i++) {
      u.add(users[userPositions[i]]!.user);
    }
    return u;
  }

  void userFirst() {
    List<String> before = [];
    List<String> after = [];
    int i = 0;
    while (i < userPositions.length) {
      String up = userPositions[i];
      if (up == "player") break;
      before.add(up);
      i++;
    }
    while (i < userPositions.length) {
      String up = userPositions[i];
      after.add(up);
      i++;
    }
    userPositions = [...after, ...before];
  }

  List<Card> sortCards(List<Card> cards) {
    List<Card> piki = [];
    List<Card> kare = [];
    List<Card> srci = [];
    List<Card> krizi = [];
    List<Card> taroki = [];
    for (int i = 0; i < cards.length; i++) {
      final card = cards[i];
      if (card.card.asset.contains("taroki")) taroki.add(card);
      if (card.card.asset.contains("kriz")) krizi.add(card);
      if (card.card.asset.contains("src")) srci.add(card);
      if (card.card.asset.contains("kara")) kare.add(card);
      if (card.card.asset.contains("pik")) piki.add(card);
    }
    piki.sort((a, b) => a.card.worthOver.compareTo(b.card.worthOver));
    kare.sort((a, b) => a.card.worthOver.compareTo(b.card.worthOver));
    srci.sort((a, b) => a.card.worthOver.compareTo(b.card.worthOver));
    krizi.sort((a, b) => a.card.worthOver.compareTo(b.card.worthOver));
    taroki.sort((a, b) => a.card.worthOver.compareTo(b.card.worthOver));
    return [...piki, ...kare, ...srci, ...krizi, ...taroki];
  }

  void sortAllCards() {
    List<String> keys = users.keys.toList(growable: false);
    for (int i = 0; i < keys.length; i++) {
      String user = keys[i];
      users[user]!.cards = sortCards(users[user]!.cards);
    }
  }

  void doRandomShuffle() {
    while (true) {
      List<LocalCard> cards = CARDS.toList();
      cards.shuffle();
      int player = -1;
      List<String> keys = users.keys.toList(growable: false);
      if (userPositions.isEmpty) {
        for (int i = 0; i < keys.length; i++) {
          userPositions.add(users[keys[i]]!.user.id);
        }
        userPositions.shuffle();
        debugPrint(
          "[STOCKŠKIS] userPositions: ${userPositions.join(' ')}",
        );
        userFirst();
      }

      List<Card> kralji = [];
      List<Card> userCards = [];

      if (PRIREDI_IGRO) {
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
      } else if (BARVIC) {
        debugPrint("Izbiram karte za barviča");
        for (int k = 0; k < cards.length; k++) {
          int i = k - userCards.length;
          if (!(cards[i].asset == "/src/kralj" ||
              cards[i].asset == "/src/dama" ||
              cards[i].asset == "/src/kaval" ||
              cards[i].asset == "/src/pob" ||
              cards[i].asset == "/src/4" ||
              cards[i].asset == "/kriz/kralj" ||
              cards[i].asset == "/kriz/dama" ||
              cards[i].asset == "/kriz/kaval" ||
              cards[i].asset == "/kriz/pob" ||
              cards[i].asset == "/kriz/10" ||
              cards[i].asset == "/pik/kralj" ||
              cards[i].asset == "/taroki/pagat")) continue;
          userCards.add(Card(card: cards[i], user: HEKE_DOBI));
          cards.removeAt(i);
        }
      } else if (BERAC) {
        debugPrint("Izbiram karte za berača");
        for (int k = 0; k < cards.length; k++) {
          int i = k - userCards.length;
          if (!(cards[i].asset == "/src/4" ||
              cards[i].asset == "/src/3" ||
              cards[i].asset == "/src/2" ||
              cards[i].asset == "/kara/4" ||
              cards[i].asset == "/kara/3" ||
              cards[i].asset == "/kara/2" ||
              cards[i].asset == "/kriz/7" ||
              cards[i].asset == "/kriz/8" ||
              cards[i].asset == "/kriz/9" ||
              cards[i].asset == "/pik/7" ||
              cards[i].asset == "/pik/8" ||
              cards[i].asset == "/taroki/pagat")) continue;
          userCards.add(Card(card: cards[i], user: HEKE_DOBI));
          cards.removeAt(i);
        }
      }

      if (GARANTIRAN_ZARUF) {
        for (int k = 0; k < cards.length; k++) {
          int i = k - kralji.length;
          if (!(cards[i].asset == "/src/kralj" ||
              cards[i].asset == "/kriz/kralj" ||
              cards[i].asset == "/pik/kralj" ||
              cards[i].asset == "/kara/kralj")) continue;
          kralji.add(Card(card: cards[i], user: HEKE_DOBI));
          cards.removeAt(i);
        }
      }

      bool imaTaroka = false;

      for (int i = 0; i < (54 - 6); i++) {
        if (i % ((54 - 6) / keys.length) == 0) {
          player++;
          if (player > 0 && !imaTaroka) {
            break;
          }
          imaTaroka = false;
        }

        String user = keys[player];
        if ((PRIREDI_IGRO || BARVIC || BERAC) &&
            user == HEKE_DOBI &&
            userCards.isNotEmpty) {
          if (userCards[0].card.asset.contains("taroki")) {
            imaTaroka = true;
          }
          users[user]!.cards.add(userCards[0]);
          userCards.removeAt(0);
          continue;
        }

        LocalCard card = cards[0];
        if (card.asset.contains("taroki")) {
          imaTaroka = true;
        }

        users[user]!.cards.add(Card(card: card, user: user));
        cards.removeAt(0);

        debugPrint(
          "Assigning card ${card.asset} to $user with ID $player $user. Remainder is ${cards.length}, user now has ${users[user]!.cards.length} cards.",
        );
      }

      if (!imaTaroka) {
        for (int i = 0; i < keys.length; i++) {
          String user = keys[i];
          users[user]!.cards = [];
        }
        continue;
      }

      for (int i = 0; i < keys.length; i++) {
        String user = keys[i];
        users[user]!.cards = sortCards(users[user]!.cards);
      }

      talon = [
        ...cards.map((e) => Card(card: e, user: "")).toList(),
        ...kralji
      ];
      debugPrint(
        "Talon consists of the following cards: ${talon.map((e) => e.card.asset).join(" ")}",
      );

      return;
    }
  }

  int playingPerson() {
    for (int i = 0; i < userPositions.length; i++) {
      User position = users[userPositions[i]]!;
      if (users[position.user.id]!.playing) return i;
    }
    return -1;
  }

  int getPlayer() {
    for (int i = 1; i < userPositions.length; i++) {
      if (userPositions[i] == "player") return i;
    }
    return 0;
  }

  int selectDeck(String playerId, List<List<Card>> talon) {
    int totalWorth = 0;
    for (int i = 0; i < talon.length; i++) {
      for (int n = 0; n < talon[i].length; n++) {
        totalWorth += talon[i][n].card.worth;
      }
    }
    int f = 0;
    if (selectedKing != "") {
      String kingType = getCardType(selectedKing);
      List<Card> myCards = users[playerId]!.cards;
      for (int i = 0; i < myCards.length; i++) {
        if (getCardType(myCards[i].card.asset) == kingType) {
          f++;
        }
      }
    }

    List<int> worth = [];
    for (int i = 0; i < talon.length; i++) {
      int wor = 0;
      for (int n = 0; n < talon[i].length; n++) {
        Card card = talon[i][n];
        String cardType = card.card.asset.split("/")[1];
        wor += card.card.worth;
        if (card.card.asset == "/taroki/pagat") {
          wor += 5;
        } else if (card.card.asset == "/taroki/skis") {
          wor += 3;
        } else if (card.card.asset == "/taroki/mond") {
          wor += 5;
        } else if (card.card.asset == selectedKing) {
          wor += (totalWorth - pow(f, 2)).toInt();
        }
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

  // TODO: na novo napiši ta drek od kode
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

    /*if (gamemode >= 3 && gamemode <= 5 && barvic(playerId)) {
      int srci = 0;
      int piki = 0;
      int krizi = 0;
      int kare = 0;
      bool srciImajoKralja = false;
      bool pikiImajoKralja = false;
      bool kriziImajoKralja = false;
      bool kareImajoKralja = false;
      for (int i = 0; i < user.cards.length; i++) {
        Card card = user.cards[i];
        String cardType = card.card.asset.split("/")[1];
        if (cardType == "src") {
          srci += card.card.worthOver;
          if (card.card.asset.contains("kralj")) {
            srciImajoKralja = true;
          }
        } else if (cardType == "pik") {
          piki += card.card.worthOver;
          if (card.card.asset.contains("kralj")) {
            pikiImajoKralja = true;
          }
        } else if (cardType == "kara") {
          kare += card.card.worthOver;
          if (card.card.asset.contains("kralj")) {
            kareImajoKralja = true;
          }
        } else {
          krizi += card.card.worthOver;
          if (card.card.asset.contains("kralj")) {
            kriziImajoKralja = true;
          }
        }
      }

      // TODO: poglej še talon

      debugPrint("Prišli smo do barvnih mehkih omejitev");

      if (srci > 0 && !srciImajoKralja) {
        while (true) {
          bool odstranjena = false;
          for (int i = 0; i < user.cards.length; i++) {
            Card card = user.cards[i];
            String cardType = card.card.asset.split("/")[1];
            if (cardType == "src") {
              user.cards.remove(card);
              odstranjena = true;
              break;
            }
          }
          if (!odstranjena) break;
        }
      } else if (piki > 0 && !pikiImajoKralja) {
        while (true) {
          bool odstranjena = false;
          for (int i = 0; i < user.cards.length; i++) {
            Card card = user.cards[i];
            String cardType = card.card.asset.split("/")[1];
            if (cardType == "src") {
              user.cards.remove(card);
              odstranjena = true;
              break;
            }
          }
          if (!odstranjena) break;
        }
      }
    }*/

    // najmanjše omejitve
    debugPrint("Prišli smo do najmanjših omejitev");
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
    int trulaCount = 0;
    for (int i = 0; i < stih.length; i++) {
      // če dobimo karto, katero si lasti talon jo preskočimo
      if (stih[i].user == "talon") continue;

      String cardType = stih[i].card.asset.split("/")[1];
      if (stih[i].card.asset == "/taroki/pagat" ||
          stih[i].card.asset == "/taroki/mond" ||
          stih[i].card.asset == "/taroki/skis") {
        trulaCount++;
      }
      if (gamemode == 9) {
        // BARVNI VALAT
        // pri barvnem valatu se taroki ne štejejo, niso bolj vredni od barve
        if ((cardType == firstCardType) &&
            picksUp.card.worthOver < stih[i].card.worthOver) picksUp = stih[i];
        continue;
      }
      if ((cardType == firstCardType || cardType == "taroki") &&
          picksUp.card.worthOver < stih[i].card.worthOver) picksUp = stih[i];
    }
    // palčka pobere škisa pa monda
    if (trulaCount == 3) {
      // pri barviču mora še vedno barva pobrati
      if (picksUp.card.asset == "/taroki/skis") {
        for (int i = 0; i < stih.length; i++) {
          if (stih[i].card.asset != "/taroki/pagat") {
            continue;
          }
          picksUp = stih[i];
          break;
        }
      }
    }
    return picksUp.user;
  }

  bool canGameEndEarly() {
    String userId = "";
    List<String> keys = users.keys.toList(growable: false);
    for (int i = 0; i < keys.length; i++) {
      if (users[keys[i]]!.playing) {
        userId = users[keys[i]]!.user.id;
        break;
      }
    }

    List<String> playing = getAllPlayingUsers();
    bool imajoNasprotnikiTaroke = false;
    bool nasprotnikImaSamoTaroke = false;
    List<UserEvaluation> userEvaluation = [];
    for (int i = 0; i < keys.length; i++) {
      User user = users[keys[i]]!;
      if (playing.contains(user.user.id)) continue;

      UserEvaluation eval = UserEvaluation()..userId = user.user.id;
      int taroki = 0;
      for (int n = 0; n < user.cards.length; n++) {
        Card karta = user.cards[n];
        String cardType = getCardType(karta.card.asset);
        if (cardType == "taroki") {
          imajoNasprotnikiTaroke = true;
        }
        if (cardType == "taroki" &&
            karta.card.worthOver > eval.najvisjiTarok.worthOver) {
          eval.najvisjiTarok = karta.card;
          taroki++;
        } else if (cardType == "pik" &&
            karta.card.worthOver > eval.najvisjiPik.worthOver) {
          eval.najvisjiPik = karta.card;
        } else if (cardType == "src" &&
            karta.card.worthOver > eval.najvisjiSrc.worthOver) {
          eval.najvisjiSrc = karta.card;
        } else if (cardType == "kara" &&
            karta.card.worthOver > eval.najvisjaKara.worthOver) {
          eval.najvisjaKara = karta.card;
        } else if (cardType == "kriz" &&
            karta.card.worthOver > eval.najvisjiKriz.worthOver) {
          eval.najvisjiKriz = karta.card;
        }
      }
      if (taroki == user.cards.length) {
        nasprotnikImaSamoTaroke = true;
      }
      userEvaluation.add(eval);
    }

    if (gamemode == -1) {
      // klop
    } else if (gamemode == 6 || gamemode == 8) {
      // (odprti) berač
      SimpleUser actuallyPlayingUser = playingUser()!;

      for (int i = 0; i < stihi.length; i++) {
        if (stihi[i].length != users.length) continue;
        String by = stihPickedUpBy(stihi[i]);
        if (by == userId) return true;
      }

      bool imaTaroke = false;
      for (int n = 0; n < users[actuallyPlayingUser.id]!.cards.length; n++) {
        Card c = users[actuallyPlayingUser.id]!.cards[n];
        if (getCardType(c.card.asset) == "taroki") {
          imaTaroke = true;
          break;
        }
      }

      if (imaTaroke) {
        return false;
      }

      if (nasprotnikImaSamoTaroke) return true;

      // ali ima igralec najnižje karte
      for (int i = 0; i < keys.length; i++) {
        User user = users[keys[i]]!;
        if (!playing.contains(user.user.id)) continue;

        for (int n = 0; n < user.cards.length; n++) {
          Card karta = user.cards[n];
          String cardType = getCardType(karta.card.asset);

          for (int k = 0; k < userEvaluation.length; k++) {
            UserEvaluation eval = userEvaluation[k];

            if (cardType == "taroki" &&
                eval.najvisjiTarok.worthOver > 0 &&
                karta.card.worthOver > eval.najvisjiTarok.worthOver) {
              return false;
            } else if (cardType == "pik" &&
                eval.najvisjiPik.worthOver > 0 &&
                karta.card.worthOver > eval.najvisjiPik.worthOver) {
              return false;
            } else if (cardType == "src" &&
                eval.najvisjiSrc.worthOver > 0 &&
                karta.card.worthOver > eval.najvisjiSrc.worthOver) {
              return false;
            } else if (cardType == "kara" &&
                eval.najvisjaKara.worthOver > 0 &&
                karta.card.worthOver > eval.najvisjaKara.worthOver) {
              return false;
            } else if (cardType == "kriz" &&
                eval.najvisjiKriz.worthOver > 0 &&
                karta.card.worthOver > eval.najvisjiKriz.worthOver) {
              return false;
            }
          }
        }
      }
    } else if (gamemode == 9 || gamemode == 10) {
      // (barvni) valat se lahko konča prej, če igralec ne zbere valata
      int valat = isValat();
      int valatCalc = calculatePrediction(1, valat);
      if (valatCalc < 0) {
        return true; // igralec ni pobral enega izmed štihov, igro lahko zaključimo
      }

      if (imajoNasprotnikiTaroke) {
        return false;
      }

      for (int i = 0; i < keys.length; i++) {
        User user = users[keys[i]]!;
        if (!playing.contains(user.user.id)) continue;

        for (int n = 0; n < user.cards.length; n++) {
          Card karta = user.cards[n];
          String cardType = getCardType(karta.card.asset);

          for (int k = 0; k < userEvaluation.length; k++) {
            UserEvaluation eval = userEvaluation[k];

            if (cardType == "taroki" &&
                karta.card.worthOver < eval.najvisjiTarok.worthOver) {
              return false;
            } else if (cardType == "pik" &&
                karta.card.worthOver < eval.najvisjiPik.worthOver) {
              return false;
            } else if (cardType == "src" &&
                karta.card.worthOver < eval.najvisjiSrc.worthOver) {
              return false;
            } else if (cardType == "kara" &&
                karta.card.worthOver < eval.najvisjaKara.worthOver) {
              return false;
            } else if (cardType == "kriz" &&
                karta.card.worthOver < eval.najvisjiKriz.worthOver) {
              return false;
            }
          }
        }
      }

      return true;
    } else if ((gamemode >= 0 && gamemode <= 5) || gamemode == 7) {
      // v igrah med tri in solo ena + solo brez se da narediti tudi valata, sicer nenapovedanega ampak vseeno
      int valat = isValat();
      debugPrint("$valat, $imajoNasprotnikiTaroke");

      if (valat == 0) {
        return false; // nihče ni zbral valata, ne moremo predčasno končati igre
      }

      if (imajoNasprotnikiTaroke) {
        return false;
      }

      for (int i = 0; i < keys.length; i++) {
        User user = users[keys[i]]!;
        if (!playing.contains(user.user.id)) continue;

        for (int n = 0; n < user.cards.length; n++) {
          Card karta = user.cards[n];
          String cardType = getCardType(karta.card.asset);

          for (int k = 0; k < userEvaluation.length; k++) {
            UserEvaluation eval = userEvaluation[k];

            if (cardType == "taroki" &&
                karta.card.worthOver < eval.najvisjiTarok.worthOver) {
              return false;
            } else if (cardType == "pik" &&
                karta.card.worthOver < eval.najvisjiPik.worthOver) {
              return false;
            } else if (cardType == "src" &&
                karta.card.worthOver < eval.najvisjiSrc.worthOver) {
              return false;
            } else if (cardType == "kara" &&
                karta.card.worthOver < eval.najvisjaKara.worthOver) {
              return false;
            } else if (cardType == "kriz" &&
                karta.card.worthOver < eval.najvisjiKriz.worthOver) {
              return false;
            }
          }
        }
      }

      return true;
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

  SimpleUser? playingUser() {
    for (int i = 0; i < userPositions.length; i++) {
      User user = users[userPositions[i]]!;
      if (users[user.user.id]!.licitiral) {
        return user.user;
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
          debugPrint("Karto $card štejem igralcem, ker je igralec pobral.");
          playingT++;
          continue;
        }
        debugPrint("Karto $card štejem neigralcem, ker igralec ni pobral.");
        notPlayingT++;
      }
      if (playingT + notPlayingT == 3) break;
    }
    debugPrint("notPlayingT: $notPlayingT; playingT: $playingT");
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
          debugPrint("Karto $card štejem igralcem, ker je igralec pobral.");
          playingT++;
          continue;
        }
        debugPrint("Karto $card štejem neigralcem, ker igralec ni pobral.");
        notPlayingT++;
      }
      if (playingT + notPlayingT == 4) break;
    }
    debugPrint("notPlayingT: $notPlayingT; playingT: $playingT");
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

  bool canGiveKontra(
    String person,
    bool isUserPlaying,
    bool isPredictedUserPlaying,
    int currentKontra,
  ) {
    if (person == "") return false;
    if (currentKontra >= 4) return false;
    return isPredictedUserPlaying && !isUserPlaying ||
        !isPredictedUserPlaying && isUserPlaying;
  }

  String getCardType(String card) {
    return card.split("/")[1];
  }

  bool jeZaruf() {
    // tudi v trojicah lahko damo kontro če imamo vsaj 40% roke tarokov (verjetno)
    return gamemode >= 0 && gamemode <= 2 && getAllPlayingUsers().length < 2;
  }

  bool predict(String userId) {
    bool changes = false;
    User user = users[userId]!;
    Predictions newPredictions = Predictions(
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
      gamemode: gamemode,
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

    List<String> playing = getAllPlayingUsers();

    int cardsPerPerson = 48 ~/ userPositions.length;

    bool zaruf = jeZaruf();

    // kontra igra
    // dodamo še dodatni člen zarufa
    if (cardsPerPerson *
            (0.6 +
                (zaruf ? 0.01875 : 0.0125) *
                    pow(2, newPredictions.igraKontra + 1) -
                (zaruf ? 0.2 : 0)) <
        taroki) {
      // kontra: igra
      bool isPlaying = playing.contains(
        newPredictions.igraKontraDal.id == ""
            ? newPredictions.igra.id
            : newPredictions.igraKontraDal.id,
      );
      if (canGiveKontra(
        newPredictions.igra.id,
        user.playing || user.secretlyPlaying,
        isPlaying,
        newPredictions.igraKontra,
      )) {
        newPredictions.igraKontra++;
        newPredictions.igraKontraDal = SimpleUser(
          id: user.user.id,
          name: user.user.name,
        );
        changes = true;
      }
    }

    if (user.playing && gamemode >= 3 && gamemode <= 5) {
      if (barvic(userId)) {
        // barvni valat
        gamemode = 9;
        newPredictions.gamemode = 9;
      }
    }

    // če je igra nad ali enaka beraču ne moreš ničesar drugega kontrirati kot igre
    if (gamemode >= 6) {
      predictions = newPredictions;
      return changes;
    }

    // kontre
    if (cardsPerPerson *
            (0.6 + 0.025 * pow(2, newPredictions.kraljUltimoKontra)) <
        taroki) {
      // kontra: kralj ultimo
      bool isPlaying = playing.contains(
        newPredictions.kraljUltimoKontraDal.id == ""
            ? newPredictions.kraljUltimo.id
            : newPredictions.kraljUltimoKontraDal.id,
      );
      if (canGiveKontra(
        newPredictions.kraljUltimo.id,
        user.playing || user.secretlyPlaying,
        isPlaying,
        newPredictions.kraljUltimoKontra,
      )) {
        newPredictions.kraljUltimoKontra++;
        newPredictions.kraljUltimoKontraDal = SimpleUser(
          id: user.user.id,
          name: user.user.name,
        );
        changes = true;
      }

      // kontra: pagat ultimo
      isPlaying = playing.contains(
        newPredictions.pagatUltimoKontraDal.id == ""
            ? newPredictions.pagatUltimo.id
            : newPredictions.pagatUltimoKontraDal.id,
      );
      if (canGiveKontra(
        newPredictions.pagatUltimo.id,
        user.playing || user.secretlyPlaying,
        isPlaying,
        newPredictions.pagatUltimoKontra,
      )) {
        newPredictions.pagatUltimoKontra++;
        newPredictions.pagatUltimoKontraDal = SimpleUser(
          id: user.user.id,
          name: user.user.name,
        );
        changes = true;
      }
    }

    // napoved: kralj ultimo
    if (rufanKralj >= 4 && imaKralja && newPredictions.kraljUltimo.id == "") {
      newPredictions.kraljUltimo = SimpleUser(
        id: user.user.id,
        name: user.user.name,
      );
      users[userId]!.playing = true;
      changes = true;
    }

    // napoved: pagat ultimo
    if (cardsPerPerson * (zaruf ? 0.7 : 0.6) < taroki &&
        imaPagata &&
        newPredictions.pagatUltimo.id == "") {
      newPredictions.pagatUltimo = SimpleUser(
        id: user.user.id,
        name: user.user.name,
      );
      changes = true;
    }

    // napoved: trula
    if (cardsPerPerson * 0.4 < taroki &&
        trula == 3 &&
        newPredictions.trula.id == "") {
      newPredictions.trula = SimpleUser(
        id: user.user.id,
        name: user.user.name,
      );
      changes = true;
    }

    // kraljev se tko ne napoveduje, ker ti vsako igro neki nepredvideno režejo
    predictions = newPredictions;
    return changes;
  }

  StartPredictions getStartPredictions(String userId) {
    StartPredictions startPredictions = StartPredictions();
    List<String> playing = getAllPlayingUsers();

    String actuallyPlayingUser = playingUser()!.id;

    bool playerPlaying = playing.contains(userId);
    if (predictions.igra.id != "" &&
        !playerPlaying &&
        predictions.igraKontra % 2 == 0) {
      startPredictions.igraKontra = true;
    }

    if (actuallyPlayingUser == userId && predictions.valat.id == "") {
      startPredictions.valat = true;
      if (gamemode >= 3 && gamemode <= 5) {
        startPredictions.barvniValat = true;
      }
    }

    if (gamemode >= 6) return startPredictions;

    startPredictions.trula = predictions.trula.id == "";
    startPredictions.kralji = predictions.kralji.id == "";

    bool isPlaying = playing.contains(
      predictions.kraljUltimoKontraDal.id == ""
          ? predictions.kraljUltimo.id
          : predictions.kraljUltimoKontraDal.id,
    );
    if (canGiveKontra(
      predictions.kraljUltimo.id,
      playerPlaying,
      isPlaying,
      predictions.kraljUltimoKontra,
    )) {
      startPredictions.kraljUltimoKontra = true;
    }

    isPlaying = playing.contains(
      predictions.pagatUltimoKontraDal.id == ""
          ? predictions.pagatUltimo.id
          : predictions.pagatUltimoKontraDal.id,
    );
    if (canGiveKontra(
      predictions.pagatUltimo.id,
      playerPlaying,
      isPlaying,
      predictions.pagatUltimoKontra,
    )) {
      startPredictions.pagatUltimoKontra = true;
    }

    List<Card> userCards = users[userId]!.cards;
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

    debugPrint(
      "predictions.igra.id je ${predictions.igra.id != ""}, ${predictions.igra.id}, kjer igralec (ne) igra: $playerPlaying in je stanje kontre ${predictions.igraKontra}",
    );

    return startPredictions;
  }

  int hasPagatUltimo() {
    List<Card> stih = stihi.last;
    if (stih.isEmpty) {
      // pushamo nov empty [], tako da je dejanski zadnji na -2
      // to ne velja za CLI
      stih = stihi[stihi.length - 2];
    }
    List<String> playing = playingUsers();
    bool pagatInside = false;
    bool pagataDalIgralec = false;
    for (int i = 0; i < stih.length; i++) {
      debugPrint("Stih: ${stih[i].card.asset}");
      if (stih[i].card.asset != "/taroki/pagat") continue;
      pagatInside = true;
      pagataDalIgralec = playing.contains(stih[i].user);
      break;
    }

    // pagata ni not v štihu
    if (!pagatInside) return 0;

    StihAnalysis analysis = analyzeStih(stih)!;

    // pagat ni pobral
    if (analysis.cardPicks.card.asset != "/taroki/pagat") {
      return pagataDalIgralec ? -1 : 1;
    }

    String picked = stihPickedUpBy(stih);
    bool playingPickedUp = playing.contains(picked);
    return playingPickedUp ? 1 : -1;
  }

  int hasKraljUltimo() {
    List<Card> stih = stihi.last;
    if (stih.isEmpty) {
      // pushamo nov empty [], tako da je dejanski zadnji na -2
      // to ne velja za CLI
      stih = stihi[stihi.length - 2];
    }
    bool kraljInside = false;
    for (int i = 0; i < stih.length; i++) {
      debugPrint("Stih: ${stih[i].card.asset} $selectedKing");
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

  void dodajRadelce() {
    List<String> keys = users.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      users[keys[i]]!.user.radlci++;
      logger.i("Dodajam radlce ${users[keys[i]]!.user.id}");
    }
  }

  (List<List<Card>>, List<List<LocalCard>>, bool) getStockskisTalon() {
    bool zaruf = false;
    int m = 0;
    if (gamemode == 0 || gamemode == 3) m = 2;
    if (gamemode == 1 || gamemode == 4) m = 3;
    if (gamemode == 2 || gamemode == 5) m = 6;
    int k = 0;
    List<List<Card>> stockskisTalon = [];
    List<List<LocalCard>> localTalon = [];
    for (int i = 0; i < m; i++) {
      List<LocalCard> cards = [];
      List<Card> c = [];
      for (int n = 0; n < 6 / m; n++) {
        if (talon[k].card.asset == selectedKing) {
          zaruf = true;
        }
        cards.add(talon[k].card);
        c.add(talon[k]);
        k++;
      }
      localTalon.add(cards);
      stockskisTalon.add(c);
    }
    return (stockskisTalon, localTalon, zaruf);
  }

  Results calculateGame() {
    Map<String, List<Card>> results = {};
    List<String> playing = playingUsers();
    List<String> keys = users.keys.toList();
    List<MessagesStih> stihiMessage = [];
    for (int i = 0; i < keys.length; i++) {
      User user = users[keys[i]]!;
      results[user.user.id] = [];
    }
    bool ttrula = false;
    String mondFallen = "";
    String skisFallen = "";
    for (int i = 0; i < stihi.length; i++) {
      List<Card> stih = stihi[i];
      if (stih.isEmpty) continue;
      String by = stihPickedUpBy(stih);
      stihiMessage.add(
        MessagesStih(
          card: stih,
          worth: calculateTotal(stih).toDouble(),
          pickedUpByPlaying: playing.contains(by),
          pickedUpBy: users[by]!.user.name,
        ),
      );
      debugPrint(
        "Pobral $by, pri čimer igrajo $playing in štih je dolg ${stih.length}",
      );
      if (by == "") {
        logger.e("error while counting points");
        continue;
      }
      int t = 0;
      for (int n = 0; n < stih.length; n++) {
        Card card = stih[n];
        if (card.card.asset == "/taroki/mond") {
          mondFallen = card.user;
          t++;
        }
        if (card.card.asset == "/taroki/skis") {
          skisFallen = card.user;
          t++;
        }
        if (card.card.asset == "/taroki/pagat") {
          t++;
        }
        results[by]!.add(card);
      }
      if (skisFallen == "" || mondFallen == "") {
        mondFallen = "";
        skisFallen = "";
      }
      if (t == 3) {
        ttrula = true;
      }
    }

    stihiMessage.add(
      MessagesStih(
        card: talon,
        worth: calculateTotal(talon).toDouble(),
        pickedUpByPlaying: false,
        pickedUpBy: "",
      ),
    );

    List<ResultsUser> newResults = [];

    if (gamemode != -1 && gamemode < 6) {
      // NORMALNE IGRE
      SimpleUser actuallyPlayingUser = playingUser()!;

      bool mondTalon = false;
      bool skisTalon = false;
      for (int i = 0; i < talon.length; i++) {
        if (talon[i].card.asset == "/taroki/mond") {
          mondTalon = true;
          break;
        } else if (talon[i].card.asset == "/taroki/skis") {
          skisTalon = true;
          break;
        }
      }
      if (mondTalon) {
        newResults.add(
          ResultsUser(
            user: [
              actuallyPlayingUser,
            ],
            playing: true,
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
      if (skisTalon && skisfang) {
        newResults.add(
          ResultsUser(
            user: [
              actuallyPlayingUser,
            ],
            playing: true,
            points: -100,
            mondfang: false,
            skisfang: true,
            showDifference: false,
            showGamemode: false,
            showKralj: false,
            showKralji: false,
            showPagat: false,
            showTrula: false,
          ),
        );
      }

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
        bool radelc = actuallyPlayingUser.radlci > 0;
        if (radelc) {
          if (valatTotal > 0) {
            actuallyPlayingUser.radlci--;
          }
        }
        newResults.add(
          ResultsUser(
            user: users.keys.map((key) => users[key]!.playing
                ? SimpleUser(id: key, name: users[key]!.user.name)
                : SimpleUser(id: "", name: "")),
            playing: true,
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
            radelc: radelc,
            points: valatTotal * (radelc ? 2 : 1),
          ),
        );
        dodajRadelce();
        return Results(user: newResults, stih: stihiMessage);
      }

      debugPrint(
          "Rezultat igre $gamemodeWorth z razliko $diff, pri čemer je igralec pobral $playingPlayed.");
      debugPrint(
        "Trula se je štela po principu, da ima trulo $trula, stanje napovedi je $trulaNapovedana, trulo je potemtakem napovedal $trulaPrediction. " +
            "Kalkulacija pravi, da je trula skupaj $trulaCalc. Skupaj se je trula štela kot $trulaTotal.",
      );
      debugPrint(
        "Pagat ultimo se je štel po principu, da ima ultimo $pagatUltimo, stanje napovedi je $pagatUltimoNapovedan, trulo je potemtakem napovedal $pagatUltimoPrediction. " +
            "Kalkulacija pravi, da je trula skupaj $pagatUltimoCalc. Skupaj se je trula štela kot $pagatUltimoTotal.",
      );
      debugPrint(
          "mondTalon=$mondTalon, skisTalon=$skisTalon, mondFallen=$mondFallen, skisFallen=$skisFallen, ttrula=$ttrula");
      if (diff <= 0) {
        gamemodeWorth *= -1;
      }

      int kontraIgra = pow(2, predictions.igraKontra).toInt();

      diff *= kontraIgra;
      gamemodeWorth *= kontraIgra;

      int total = gamemodeWorth +
          diff +
          trulaTotal +
          kraljiTotal +
          pagatUltimoTotal +
          kraljUltimoTotal;

      bool radelc = actuallyPlayingUser.radlci > 0;
      if (radelc) {
        if (diff > 0) {
          actuallyPlayingUser.radlci--;
        }
        total *= 2;
      }

      newResults.add(
        ResultsUser(
          user: users.keys.map((key) => users[key]!.playing
              ? SimpleUser(id: key, name: users[key]!.user.name)
              : SimpleUser(id: "", name: "")),
          playing: true,
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
          radelc: radelc,
          points: total,
        ),
      );
      if (!mondTalon && gamemode < 6 && mondFallen != "" && skisFallen != "") {
        newResults.add(
          ResultsUser(
            user: [
              SimpleUser(id: mondFallen, name: users[mondFallen]!.user.name),
            ],
            playing: users[mondFallen]!.playing,
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
      if (ttrula && skisFallen != "") {
        newResults.add(
          ResultsUser(
            user: [
              SimpleUser(id: skisFallen, name: users[skisFallen]!.user.name),
            ],
            playing: users[skisFallen]!.playing,
            points: -100,
            mondfang: false,
            skisfang: true,
            showDifference: false,
            showGamemode: false,
            showKralj: false,
            showKralji: false,
            showPagat: false,
            showTrula: false,
          ),
        );
      }
    } else if (gamemode == 6 || gamemode == 8) {
      // BERAČ, TODO: ODPRTI BERAČ
      SimpleUser actuallyPlayingUser = playingUser()!;

      int kontraIgra = pow(2, predictions.igraKontra).toInt();
      int gm = gamemode == 6 ? 70 : 90;
      gm *= kontraIgra;

      bool radelc = actuallyPlayingUser.radlci > 0;
      if (radelc) {
        if (gm > 0) {
          actuallyPlayingUser.radlci--;
        }
        gm *= 2;
      }

      logger.d(
        "gamemode = $gamemode, actuallyPlayingUser = (${actuallyPlayingUser.id}, ${actuallyPlayingUser.name}, ${actuallyPlayingUser.licitiral})",
      );

      newResults.add(
        ResultsUser(
          user: [actuallyPlayingUser],
          playing: true,
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
          igra: (results[actuallyPlayingUser.id]!.isEmpty ? 1 : -1) * gm,
          razlika: 0,
          radelc: radelc,
          points: (results[actuallyPlayingUser.id]!.isEmpty ? 1 : -1) * gm,
        ),
      );
      dodajRadelce();
    } else if (gamemode == 7) {
      // SOLO BREZ
      SimpleUser actuallyPlayingUser = playingUser()!;

      int valat = isValat();
      int valatPrediction = 0;
      int valatCalc = calculatePrediction(valatPrediction, valat);
      int valatTotal =
          250 * valatCalc * pow(2, predictions.valatKontra).toInt();

      if (valatTotal != 0) {
        bool radelc = actuallyPlayingUser.radlci > 0;
        if (radelc) {
          if (valatTotal > 0) {
            actuallyPlayingUser.radlci--;
          }
        }
        dodajRadelce();
        return Results(
          user: [
            ResultsUser(
              user: [actuallyPlayingUser],
              playing: true,
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
              igra: valatTotal,
              razlika: 0,
              radelc: radelc,
              points: valatTotal * (radelc ? 2 : 1),
            ),
          ],
          stih: stihiMessage,
        );
      }

      int kontraIgra = pow(2, predictions.igraKontra).toInt();
      int gm = 80;
      gm *= kontraIgra;

      int total = calculateTotal(results[actuallyPlayingUser.id]!);

      bool radelc = actuallyPlayingUser.radlci > 0;
      if (radelc) {
        if (total > 35) {
          actuallyPlayingUser.radlci--;
        }
        gm *= 2;
      }

      newResults.add(
        ResultsUser(
          user: [actuallyPlayingUser],
          playing: true,
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
          igra: (total > 35 ? 1 : -1) * gm,
          razlika: 0,
          radelc: radelc,
          points: (total > 35 ? 1 : -1) * gm,
        ),
      );

      dodajRadelce();
    } else if (gamemode == 9) {
      // BARVNI VALAT
      SimpleUser actuallyPlayingUser = playingUser()!;

      int valat = isValat();
      int valatPrediction = (playing.contains(predictions.igra.id) ? 1 : -1);
      int valatCalc = calculatePrediction(valatPrediction, valat);
      int valatTotal =
          125 * valatCalc * pow(2, predictions.valatKontra).toInt();

      bool radelc = actuallyPlayingUser.radlci > 0;
      if (radelc) {
        if (valatTotal > 0) {
          actuallyPlayingUser.radlci--;
        }
      }

      newResults.add(
        ResultsUser(
          user: [actuallyPlayingUser],
          playing: true,
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
          igra: valatTotal,
          razlika: 0,
          radelc: radelc,
          points: valatTotal * (radelc ? 2 : 1),
        ),
      );

      dodajRadelce();
    } else if (gamemode == 10) {
      // VALAT
      // napovedanega valata lahko naredita tudi dve osebi (ob napovedi se gamemode spremeni v 10)
      SimpleUser actuallyPlayingUser = playingUser()!;

      int valat = isValat();
      int valatPrediction = (playing.contains(predictions.igra.id) ? 1 : -1);
      int valatCalc = calculatePrediction(valatPrediction, valat);
      int valatTotal =
          500 * valatCalc * pow(2, predictions.valatKontra).toInt();

      bool radelc = actuallyPlayingUser.radlci > 0;
      if (radelc) {
        if (valatTotal > 0) {
          actuallyPlayingUser.radlci--;
        }
      }

      newResults.add(
        ResultsUser(
          user: users.keys.map((key) => users[key]!.playing
              ? SimpleUser(id: key, name: users[key]!.user.name)
              : SimpleUser(id: "", name: "")),
          playing: true,
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
          igra: valatTotal,
          razlika: 0,
          radelc: radelc,
          points: valatTotal * (radelc ? 2 : 1),
        ),
      );

      dodajRadelce();
    } else {
      // KLOP
      bool none = false;
      bool full = false;
      for (int i = 0; i < keys.length; i++) {
        User user = users[keys[i]]!;
        int diff = calculateTotal(results[user.user.id]!);
        if (diff == 0) {
          bool radelc = users[user.user.id]!.user.radlci > 0;
          if (radelc) {
            users[user.user.id]!.user.radlci--;
          }
          none = true;
          newResults.add(ResultsUser(
            user: [SimpleUser(id: user.user.id, name: user.user.name)],
            playing: true,
            showDifference: true,
            showGamemode: false,
            showKralj: false,
            showKralji: false,
            showPagat: false,
            showTrula: false,
            razlika: 0,
            radelc: radelc,
            points: 70 * (radelc ? 2 : 1),
          ));
        } else if (diff > 35) {
          bool radelc = users[user.user.id]!.user.radlci > 0;
          full = true;
          newResults.add(ResultsUser(
            user: [SimpleUser(id: user.user.id, name: user.user.name)],
            playing: true,
            showDifference: true,
            showGamemode: false,
            showKralj: false,
            showKralji: false,
            showPagat: false,
            showTrula: false,
            razlika: -diff,
            radelc: radelc,
            points: -70 * (radelc ? 2 : 1),
          ));
        }
      }
      if (!none && !full) {
        for (int i = 0; i < keys.length; i++) {
          User user = users[keys[i]]!;
          bool radelc = user.user.radlci > 0;
          if (radelc) {
            user.user.radlci--;
          }
          int diff = -calculateTotal(results[user.user.id]!);
          newResults.add(ResultsUser(
            user: [user.user],
            playing: true,
            showDifference: true,
            showGamemode: false,
            showKralj: false,
            showKralji: false,
            showPagat: false,
            showTrula: false,
            razlika: diff,
            radelc: radelc,
            points: diff * (radelc ? 2 : 1),
          ));
        }
      }

      dodajRadelce();
    }
    return Results(user: newResults, stih: stihiMessage);
  }

  // 1 = draw
  // >1 = player is winning
  // <1 = player is losing
  double evaluateGame() {
    List<String> playing = playingUsers();
    debugPrint("Playing $playing");
    List<Card> playingPickedUpCards = [];
    List<Card> notPlayingPickedUpCards = [...talon];
    for (int i = 0; i < stihi.length; i++) {
      if (stihi[i].isEmpty) continue;
      StihAnalysis by = analyzeStih(stihi[i])!;
      for (int n = 0; n < stihi[i].length; n++) {
        if (playing.contains(by.cardPicks.user)) {
          playingPickedUpCards.add(stihi[i][n]);
        } else {
          notPlayingPickedUpCards.add(stihi[i][n]);
        }
      }
      debugPrint(
        "Analyzed štih #$i, that's worth ${by.worth} and owned by ${by.cardPicks.user}:${by.cardPicks.card.asset} and has a length of ${stihi[i].length}",
      );
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
      if (userPositions[i] == "player") return i;
    }
    return -1;
  }
}
