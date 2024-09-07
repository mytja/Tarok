// StockŠkis - simple tarock bots.
// Copyright (C) 2023 Mitja Ševerkar
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

// ignore_for_file: avoid_print, prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings, library_prefixes

import "dart:convert";
import "dart:developer";
import "dart:math";

import "package:logger/logger.dart";
import "package:stockskis/src/cards.dart";
import "package:stockskis/src/configuration.dart";
import "package:stockskis/src/gamemodes.dart";
import "package:stockskis/src/kombinatorika.dart";
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
  int krogovLicitiranja = -1;

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
        name: "",
      ),
      kraljUltimoKontra: p["kraljUltimoKontra"],
      kraljUltimoKontraDal: SimpleUser(
        id: p["kraljUltimoKontraDal"]["id"],
        name: "",
      ),
      pagatUltimo: SimpleUser(
        id: p["pagatUltimo"]["id"],
        name: "",
      ),
      pagatUltimoKontra: p["pagatUltimoKontra"],
      pagatUltimoKontraDal: SimpleUser(
        id: p["pagatUltimoKontraDal"]["id"],
        name: "",
      ),
      igra: SimpleUser(
        id: p["igra"]["id"],
        name: "",
      ),
      igraKontra: p["igraKontra"],
      igraKontraDal: SimpleUser(
        id: p["igraKontraDal"]["id"],
        name: "",
      ),
      valat: SimpleUser(
        id: p["valat"]["id"],
        name: "",
      ),
      barvniValat: SimpleUser(
        id: p["barvniValat"]["id"],
        name: "",
      ),
      trula: SimpleUser(
        id: p["trula"]["id"],
        name: "",
      ),
      kralji: SimpleUser(
        id: p["kralji"]["id"],
        name: "",
      ),
      mondfang: SimpleUser(
        id: p["mondfang"]["id"],
        name: "",
      ),
      mondfangKontra: p["mondfangKontra"],
      mondfangKontraDal: SimpleUser(
        id: p["mondfangKontraDal"]["id"],
        name: "",
      ),
      gamemode: p["gamemode"],
      changed: false,
    );

    bool kingFallen = j["kingFallen"];
    String selectedKing = j["selectedKing"];
    int gamemode = j["gamemode"];
    int krogovLicitiranja = j["krogovLicitiranja"];
    bool skisfang = j["skisfang"];
    bool napovedanMondfang = j["napovedanMondfang"];

    if (userPositions.length != 4) {
      kingFallen = true;
    }

    NAPOVEDAN_MONDFANG = napovedanMondfang;

    StockSkis stockskis = StockSkis(
        users: users, stihiCount: stihiCount, predictions: predictions)
      ..stihi = stihi
      ..talon = talon
      ..userPositions = userPositions
      ..kingFallen = kingFallen
      ..gamemode = gamemode
      ..selectedKing = selectedKing
      ..krogovLicitiranja = krogovLicitiranja
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
    int visjiTaroki = 0;

    bool isPlayingAfter = false;
    String stihZacne = stih.isEmpty ? userId : stih.first.user;
    int l = userPositions.indexWhere((element) => element == userId);
    int sz = userPositions.indexWhere((element) => element == stihZacne);
    if (l == -1) return moves;
    l++;
    while (true) {
      if (l >= userPositions.length) l = 0;
      if (l == sz) break;
      if (users[userPositions[l]]!.playing ||
          users[userPositions[l]]!.secretlyPlaying) {
        isPlayingAfter = true;
        break;
      }
      l++;
    }

    debugPrint(
        "Pogruntano je bilo, da ${isPlayingAfter ? 'je' : 'ni'} igralec po trenutnemu igralcu $userId");

    for (int i = 0; i < user.cards.length; i++) {
      Card card = user.cards[i];
      String cardType = card.card.asset.split("/")[1];

      /*if ((card.card.asset == "/taroki/mond") && stih.isEmpty) {
        return [Move(card: card, evaluation: 1)];
      }*/

      if (cardType == "taroki") {
        taroki++;
        // palčka je na 11
        int worthOver = (card.card.worthOver - 11);
        tarokiWorth += pow(worthOver, 1.5).round();
        if (card.card.worthOver - 11 >= 18) visjiTaroki++;
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

    List<String> keys = users.keys.toList();
    int tarokovIgri = 0;
    int brezTarokov = 0;
    for (int i = 0; i < keys.length; i++) {
      User user = users[keys[i]]!;
      if (user.user.id == userId) continue;
      bool brez = true;
      for (int n = 0; n < user.cards.length; n++) {
        Card card = user.cards[n];
        String cardType = card.card.asset.split("/")[1];
        if (cardType == "taroki") {
          tarokovIgri++;
          brez = false;
        }
      }
      if (brez) {
        brezTarokov++;
      }
    }

    int trula = 0;
    for (int i = 0; i < stih.length; i++) {
      if (stih[i].card.asset == "/taroki/mond" ||
          stih[i].card.asset == "/taroki/skis") {
        trula++;
      }
      if (trula >= 2) {
        break;
      }
    }
    if (trula == 2) {
      // palčka mora pasti poleg škisa in monda
      for (int i = 0; i < user.cards.length; i++) {
        Card c = user.cards[i];
        if (c.card.asset == "/taroki/pagat") {
          return [
            Move(card: c, evaluation: 1),
          ];
        }
      }
    }

    List<String> allPlaying = getAllPlayingUsers();

    int krogKare = 0;
    int krogKriza = 0;
    int krogPika = 0;
    int krogSrca = 0;
    bool valatNamera = stihi.length <= 1;
    bool valatDoZdaj = true;
    for (int i = 0; i < stihi.length; i++) {
      if (stihi[i].isEmpty) continue;
      Card prvaKarta = stihi[i].first;
      StihAnalysis? s = analyzeStih(stihi[i], gamemode);
      if (s != null &&
          !allPlaying.contains(s.cardPicks.user) &&
          stihi[i].length >= users.length) {
        valatDoZdaj = false;
      } else if (s == null) {
        valatDoZdaj = false;
      }

      String type = getCardType(prvaKarta.card.asset);
      if (type == "kara") {
        krogKare++;
      } else if (type == "kriz") {
        krogKriza++;
      } else if (type == "pik") {
        krogPika++;
      } else if (type == "src") {
        krogSrca++;
      } else if (type == "taroki") {
        if ((prvaKarta.card.asset == "/taroki/skis" ||
                prvaKarta.card.asset == "/taroki/mond" ||
                prvaKarta.card.asset == "/taroki/20" ||
                prvaKarta.card.asset == "/taroki/19" ||
                prvaKarta.card.asset == "/taroki/18") &&
            allPlaying.contains(prvaKarta.user)) {
          valatNamera = true;
        }
      }
    }

    debugPrint("valatNamera=$valatNamera, valatDoZdaj=$valatDoZdaj");

    int stihov = 48 ~/ users.length;

    List<String> playing = playingUsers();
    bool userIsPlaying = user.secretlyPlaying || user.playing;

    if (stih.isEmpty) {
      for (int i = 0; i < user.cards.length; i++) {
        Card card = user.cards[i];
        String cardType = card.card.asset.split("/")[1];

        // pagat generalno ne bi smel prvi pasti, razen če je to res edina karta
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
          debugPrint("Izbiram evaluacijo kart za barvnega valata");

          String prevCardType =
              stihi.length - 2 > 0 && stihi[stihi.length - 2].isNotEmpty
                  ? getCardType(stihi[stihi.length - 2].first.card.asset)
                  : "";
          if (cardType == "src") {
            penalty -= pow(srci, 2).round();
          } else if (cardType == "pik") {
            penalty -= pow(piki, 2).round();
          } else if (cardType == "kara") {
            penalty -= pow(kare, 2).round();
          } else if (cardType == "kriz") {
            penalty -= pow(krizi, 2).round();
          } else if (cardType == "taroki") {
            penalty += 100;
          }

          debugPrint("$cardType $prevCardType");

          if (cardType == prevCardType) {
            penalty -= 100;
          }

          if (cardType != "taroki") {
            penalty -= pow(card.card.worthOver, 2).round();
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
            penalty -= ((srci * srci) / 2).round();
            if (maxSafe < krogSrca) {
              penalty += pow(card.card.worth, krogSrca).round();
            } else {
              // da mi ne meče kar dam
              if (!card.card.asset.contains("kralj")) {
                penalty += pow(card.card.worth, 2).round();
              }
              penalty -=
                  pow(card.card.worth * 2, maxSafe - krogSrca + 1).round();
            }
          } else if (cardType == "pik") {
            penalty -= ((piki * piki) / 2).round();
            if (maxSafe < krogPika) {
              penalty += pow(card.card.worth, krogPika).round();
            } else {
              if (!card.card.asset.contains("kralj")) {
                penalty += pow(card.card.worth, 2).round();
              }
              penalty -=
                  pow(card.card.worth * 2, maxSafe - krogPika + 1).round();
            }
          } else if (cardType == "kara") {
            penalty -= ((kare * kare) / 2).round();
            if (maxSafe < krogKare) {
              penalty += pow(card.card.worth, krogKare).round();
            } else {
              if (!card.card.asset.contains("kralj")) {
                penalty += pow(card.card.worth, 2).round();
              }
              penalty -=
                  pow(card.card.worth * 2, maxSafe - krogKare + 1).round();
            }
          } else if (cardType == "kriz") {
            penalty -= ((krizi * krizi) / 2).round();
            if (maxSafe < krogKriza) {
              penalty += pow(card.card.worth, krogKriza + 1).round();
            } else {
              if (!card.card.asset.contains("kralj")) {
                penalty += pow(card.card.worth, 2).round();
              }
              penalty -=
                  pow(card.card.worth * 2, maxSafe - krogKriza + 1).round();
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
          for (int n = 0; n < talon.length; n++) {
            if (talon[n].card.asset == "/taroki/skis") jePadelSkis = true;
            if (jePadelSkis) break;
          }
          for (int n = 0; n < stihi.length; n++) {
            if (jePadelSkis) break;
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
            penalty += 400;
          }
          debugPrint("kazen za monda $penalty");
        }

        if (playing.contains(userId) &&
            predictions.pagatUltimo.id != "" &&
            card.card.asset.contains("taroki")) {
          penalty -= pow(card.card.worthOver - 10, 1.5).round();
        }

        if (cardType == "taroki" && valatDoZdaj && userIsPlaying) {
          if (visjiTaroki >= (3 - stihi.length)) {
            penalty -= pow(card.card.worthOver, 2).round();
          }
          if (valatNamera && (3 - stihi.length) < 0) {
            penalty += pow(card.card.worthOver / 2, 2).round();
          }
        }

        if (valatDoZdaj && userIsPlaying) {
          penalty -= pow(card.card.worthOver, 2.5).round();
        }

        if (selectedKing != "" &&
            getCardType(selectedKing) == getCardType(card.card.asset) &&
            user.secretlyPlaying) {
          // s svojo barvo se tko nikoli ne pride ven, ker je res nepotrebno
          penalty += 200;
        }
        if (selectedKing == card.card.asset &&
            predictions.kraljUltimo.id != "") {
          penalty += 500;
        }
        if (card.card.asset == "/taroki/pagat" &&
            predictions.pagatUltimo.id != "") {
          penalty += 1000;
        }

        debugPrint(
            "Ugotovitev: ${predictions.igra.id != user.user.id && user.secretlyPlaying}");

        if (predictions.igra.id != user.user.id && user.secretlyPlaying) {
          // če je rufani igralec, šmiramo licitirajočemu, a le če je ta po nas.
          if (!isPlayingAfter) {
            penalty += pow(card.card.worth * 2, 2).round();
          }
        } else {
          // če je katerikoli izmed drugih igralcev, naj si praviloma ne bi šmirali
          // ne smemo spet toliko kaznovati, da bodo tudi neigralci raje metali tarokov ven raje kot punte
          penalty += pow(card.card.worth * 2, 2).round();
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
      StihAnalysis analysis = analyzeStih(stih, gamemode)!;
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
          int penalty = 0;
          if (card.card.asset.contains("src")) {
            penalty += pow(krogSrca * 1.7, 2).round() - card.card.worthOver;
          } else if (card.card.asset.contains("pik")) {
            penalty += pow(krogPika * 1.7, 2).round() - card.card.worthOver;
          } else if (card.card.asset.contains("kriz")) {
            penalty += pow(krogKriza * 1.7, 2).round() - card.card.worthOver;
          } else if (card.card.asset.contains("kara")) {
            penalty += pow(krogKare * 1.7, 2).round() - card.card.worthOver;
          }

          if (card.card.asset.contains("taroki")) {
            if (cardType == "src") {
              penalty += pow(card.card.worthOver, 3 - krogSrca).round();
            } else if (cardType == "pik") {
              penalty += pow(card.card.worthOver, 3 - krogPika).round();
            } else if (cardType == "kriz") {
              penalty += pow(card.card.worthOver, 3 - krogKriza).round();
            } else if (cardType == "kara") {
              penalty += pow(card.card.worthOver, 3 - krogKare).round();
            }
            moves.add(Move(card: card, evaluation: penalty));
            continue;
          }

          moves.add(
              Move(card: card, evaluation: -card.card.worthOver - penalty));
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
            penalty -= pow(analysis.worth, 2).round();
          } else {
            penalty += 200;
          }
          debugPrint("kazen za monda $penalty");
        }

        if (card.card.asset == "/taroki/mond") {
          // nikoli IN RES NIKOLI ne daj monda če je škis v štihu (razen seveda, če je nujno)
          for (int i = 0; i < stihi.last.length; i++) {
            Card c = stihi.last[i];
            if (c.card.asset == "/taroki/skis") {
              penalty += 10000;
              break;
            }
          }
        }

        // če igramo na pagat ultimo, moramo zbijati taroke - enako velja če neigrajoči napove pagatka
        if (currentCardType == "taroki" &&
            card.card.asset != "/taroki/pagat" &&
            predictions.pagatUltimo.id != "" &&
            user.secretlyPlaying) {
          penalty -= card.card.worthOver - 11;
        }

        // če kdo ponuja monda, ga pobereš, razen če je odkrito, da sta v isti ekipi
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
              penalty += 1000;
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
            penalty +=
                pow(analysis.cardPicks.card.worthOver - card.card.worthOver, 2)
                    .toInt();
            penalty -= pow(card.card.worth, 1.5).toInt();

            if (card.card.asset == "/taroki/mond") {
              penalty -= 200;
            }
          }

          // monda naj bi poskušali varno pripeljati čez
          if (card.card.asset == "/taroki/mond" && taroki <= 3) {
            // že pri 3 tarokih se izniči kazen za škisa
            penalty -= pow(9 - taroki, 3).toInt();
          }

          // bot naj se pravilno ne bi stegnil čez tiste, s katerimi igra, če ti že poberejo štih
          if (stihPobereIgralec == user.playing) {
            penalty += pow(card.card.worthOver / 3, 1.5).toInt();
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
          penalty -= pow(analysis.worth * 2, 3).toInt();
        }

        // če se bot ne more stegniti, naj se čim manj
        // bota nagradimo, če se lahko stegne za malo
        // še vedno ga pa kaznujemo, ker se ne more stegniti
        // to pomeni, da ga kaznujemo za določeno trenutno vrednost talona
        if (analysis.cardPicks.card.worthOver > card.card.worthOver) {
          penalty -=
              6 * (analysis.cardPicks.card.worthOver - card.card.worthOver);
          penalty += (pow(analysis.worth * 3, 2) / 2).round();
        }

        // TODO: problem verjetno nastane ker gledamo v roke in ne v štihe. Lahko da igralec s palčko pade ravno na sredo talona in napačno prekalkuliramo štihe.
        // največ je možnih 13 štihov v 4 (1 zalagalni + 12 štihov)
        // v 4 je možno kalkulirati samo 12 štihov, posledično bo začel razmišljati na predzadnjem štihu
        if (stihi.length >= stihov && card.card.asset == "/taroki/pagat") {
          // odštejemo sebe iz enačbe, nato pa prekalkuliramo koliko oseb dejansko še ima taroke
          // če sta samo še dva štiha do konca (trenutni štih je dejanski 11., 12. če štejemo zalagalnega, torej predzadnji)
          // če je v igri vsaj toliko tarokov kot je igralcev s taroki + 1 za zadnji štih, si premislimo in droppamo pagata.
          int imaTaroke = users.length - 1 - brezTarokov;
          int potrebnihTarokov = imaTaroke + 1;
          if (potrebnihTarokov >= tarokovIgri) {
            // vrzi pagata, ne more priti čez
            penalty -= 1000;
          }
        }

        // če se bot preveč stegne, ga kaznujemo
        // to velja samo za taroke
        // pri platelcah generalno želimo, da se stegne čim bolj
        if (cardType == "taroki" &&
            analysis.cardPicks.card.worthOver < card.card.worthOver) {
          penalty += pow(
                  (card.card.worthOver - analysis.cardPicks.card.worthOver) * 2,
                  1.3)
              .round();

          penalty -= (pow(analysis.worth, 2) / 2).round();
        }

        // ali bot šenka punte pravi osebi?
        List<Card> currentStih = [...stih, card];
        StihAnalysis newAnalysis = analyzeStih(currentStih, gamemode)!;
        debugPrint(
          "Analysis ${newAnalysis.cardPicks.user} ${newAnalysis.cardPicks.card.asset} for player $userId, whereas stih consists of ${currentStih.map((e) => e.card.asset).join(" ")}",
        );
        if (newAnalysis.cardPicks != card) {
          if (cardType == "taroki") {
            penalty += (analysis.cardPicks.card.worthOver / 2).round();
            // da iz glave izbijemo idejo šmiranja stvari na nizke taroke
            penalty += pow(card.card.worth * 2, 2).round();
          }
        }

        if (userIsPlaying == isPlayingAfter &&
            ((user.secretlyPlaying && !user.playing) || kingFallen)) {
          // igra = igralec je po
          // ne igra = igralca ni po
          // torej si sorodni igralci šmirajo med sabo
          // to podpiramo, a le če to pobere sorodni igralec
          int k = playing.contains(analysis.cardPicks.user) == userIsPlaying
              ? 1
              : -1;
          penalty -= pow(card.card.worth * 1.5, 3).round() * k;
        } else {
          penalty += pow(card.card.worth * 1.5, 3).round();
        }

        if (stihi.last.length == users.length - 1 &&
            currentCardType != "taroki") {
          // uporabnik je zadnji, posledično se naj se stegne čim bolj, če gre za barve in on tudi pobere zadevo
          penalty -= pow(card.card.worth + card.card.worthOver, 2).round();
        }

        // poskušaj se ne znebiti kart če imaš napovedan kralj ultimo
        if (selectedKing != "" &&
            getCardType(selectedKing) == currentCardType &&
            predictions.kraljUltimo.id == user.user.id) {
          penalty += 1000 * (selectedKing == card.card.asset ? 2 : 1);
        }
        if (card.card.asset == "/taroki/pagat" &&
            predictions.pagatUltimo.id != "") {
          penalty += 2000;
        }

        // prva karta je tarok
        if (cardType == "taroki") {
          if (userIsPlaying &&
              valatNamera &&
              valatDoZdaj &&
              card.card.worthOver - stih.first.card.worthOver > 6) {
            penalty -= pow(card.card.worthOver, 2).round();
          }
        } else {
          // v primeru, da je prva karta farba
          if (userIsPlaying &&
              valatNamera &&
              valatDoZdaj &&
              card.card.worthOver - stih.first.card.worthOver > 3) {
            penalty -= pow(card.card.worthOver, 2).round();
          }
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

  static StihAnalysis? analyzeStih(List<Card> stih, int gamemode) {
    if (stih.isEmpty) return null;

    Card first = stih.first;
    String firstCardType = first.card.asset.split("/")[1];
    Card picksUp = stih.first;
    int trulaCount = 0;
    double worth = 0;
    for (int i = 0; i < stih.length; i++) {
      // če dobimo karto, katero si lasti talon jo preskočimo
      if (stih[i].user == "talon") continue;

      worth += stih[i].card.worth - 2 / 3;

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

    StihAnalysis analysis = StihAnalysis(cardPicks: picksUp, worth: worth);

    return analysis;
  }

  // napovej/igre/game/gamemodes
  List<int> suggestModes(String userId, {bool canLicitateThree = false}) {
    debugPrint(
        "Funkcija suggestModes($userId, $canLicitateThree) je bila klicana");

    List<int> modes = [];
    User user = users[userId]!;

    if (GAMEMODE_CONFIGURATION.isNotEmpty) {
      bool isMandatory = userPositions.last == userId;
      modes = [...GAMEMODE_CONFIGURATION];
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

    if (user.botType == "klop") return [-1];

    int taroki = 0;
    int srci = 0;
    int piki = 0;
    int krizi = 0;
    int kare = 0;
    int kraljev = 0;
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

      if (card.card.asset.contains("kralj")) {
        kraljev++;
      }
    }

    if (barvic(userId) && users.length != 3) return [3];

    int maximumRating = 0;
    List<LocalCard> localCards = [...CARDS];
    localCards.sort((a, b) => (a.worthOver + pow(a.worth, 2))
        .compareTo(b.worthOver + pow(b.worth, 2)));
    localCards = localCards.reversed.toList();
    for (int i = 0; i < localCards.length; i++) {
      //debugPrint(localCards[i].asset);
      maximumRating +=
          localCards[i].worthOver + pow(localCards[i].worth, 2).round();
      // hočemo tudi nižje taroke od 15 vključiti v ta sistem, v tem primeru vse kralje, dame in taroke do 9 + palčka
      if (i == 22) {
        debugPrint("maximumRating=$maximumRating");
        break;
      }
    }

    int myRating = 0;
    for (int i = 0; i < user.cards.length; i++) {
      Card card = user.cards[i];
      myRating += card.card.worthOver + pow(card.card.worth, 2).round();
    }

    double VRAZJI_SOLO_BREZ = 0.77 * maximumRating;
    double VRAZJI_VALAT = 0.90 * maximumRating;
    double VRAZJI_TRI =
        (0.26 + (users.length == 3 ? 0.13 : 0.0) - taroki * 0.003) *
            maximumRating;
    double VRAZJI_DVE =
        (0.30 + (users.length == 3 ? 0.14 : 0.0) - taroki * 0.0035) *
            maximumRating;
    double VRAZJI_ENA =
        (0.40 + (users.length == 3 ? 0.15 : 0.0) - taroki * 0.004) *
            maximumRating;
    double VRAZJI_SOLO_TRI = (0.52 - taroki * 0.007) * maximumRating;
    double VRAZJI_SOLO_DVA = (0.56 - taroki * 0.0075) * maximumRating;
    double VRAZJI_SOLO_ENA = (0.60 - taroki * 0.008) * maximumRating;
    double VRAZJI_BERAC = 0.24 * maximumRating +
        ((gamemode == 6 || gamemode == 8) ? 0 : max(0, gamemode - 2)) *
            0.012 *
            maximumRating;
    double VRAZJI_ODPRTI_BERAC = 0.20 * maximumRating +
        ((gamemode == 6 || gamemode == 8) ? 0 : max(0, gamemode - 2)) *
            0.012 *
            maximumRating;

    // poskrbeti moramo tudi da nima vseh kraljev, drugače se bo prisiljen porufati
    List<BotGameMode> VRAZJI = [
      if (canLicitateThree &&
          (users.length == 3 || (users.length != 3 && kraljev < 4)))
        BotGameMode(id: 0, points: VRAZJI_TRI),
      if (users.length == 3 || (users.length != 3 && kraljev < 4))
        BotGameMode(id: 1, points: VRAZJI_DVE),
      if (users.length == 3 || (users.length != 3 && kraljev < 4))
        BotGameMode(id: 2, points: VRAZJI_ENA),
      if (users.length != 3) BotGameMode(id: 3, points: VRAZJI_SOLO_TRI),
      if (users.length != 3) BotGameMode(id: 4, points: VRAZJI_SOLO_DVA),
      if (users.length != 3) BotGameMode(id: 5, points: VRAZJI_SOLO_ENA),
      BotGameMode(id: 7, points: VRAZJI_SOLO_BREZ),
      BotGameMode(id: 10, points: VRAZJI_VALAT),
      // vključimo zato, da ne pride do tega da ima karte za valat, pa ga ne napove
      BotGameMode(id: 10, points: maximumRating + 1),
    ];

    double SOLO_BREZ = 0.8 * maximumRating;
    double VALAT = 0.90 * maximumRating;
    double TRI = (0.29 + (users.length == 3 ? 0.13 : 0.0) - taroki * 0.003) *
        maximumRating;
    double DVE = (0.33 + (users.length == 3 ? 0.14 : 0.0) - taroki * 0.0035) *
        maximumRating;
    double ENA = (0.42 + (users.length == 3 ? 0.15 : 0.0) - taroki * 0.004) *
        maximumRating;
    double SOLO_TRI = (0.55 - taroki * 0.007) * maximumRating;
    double SOLO_DVA = (0.60 - taroki * 0.0075) * maximumRating;
    double SOLO_ENA = (0.65 - taroki * 0.008) * maximumRating;
    double BERAC = 0.22 * maximumRating +
        ((gamemode == 6 || gamemode == 8) ? 0 : max(0, gamemode - 2)) *
            0.01 *
            maximumRating;
    double ODPRTI_BERAC = 0.18 * maximumRating +
        ((gamemode == 6 || gamemode == 8) ? 0 : max(0, gamemode - 2)) *
            0.01 *
            maximumRating;
    if (gamemode == 6) {
      SOLO_BREZ -= 0.35 * maximumRating;
      VRAZJI_SOLO_BREZ -= 0.35 * maximumRating;
    }

    List<BotGameMode> NORMALNI = [
      if (canLicitateThree &&
          (users.length == 3 || (users.length != 3 && kraljev < 4)))
        BotGameMode(id: 0, points: TRI),
      if (users.length == 3 || (users.length != 3 && kraljev < 4))
        BotGameMode(id: 1, points: DVE),
      if (users.length == 3 || (users.length != 3 && kraljev < 4))
        BotGameMode(id: 2, points: ENA),
      if (users.length != 3) BotGameMode(id: 3, points: SOLO_TRI),
      if (users.length != 3) BotGameMode(id: 4, points: SOLO_DVA),
      if (users.length != 3) BotGameMode(id: 5, points: SOLO_ENA),
      BotGameMode(id: 7, points: SOLO_BREZ),
      BotGameMode(id: 10, points: VALAT),
      // vključimo zato, da ne pride do tega da ima karte za valat, pa ga ne napove
      BotGameMode(id: 10, points: maximumRating + 1),
    ];

    NORMALNI.sort((a, b) => a.points.compareTo(b.points));
    VRAZJI.sort((a, b) => a.points.compareTo(b.points));

    logger.d(
        "Evaluacija za osebo $userId je $myRating, kar je ${myRating / maximumRating}% največje evaluacije. Igra je $gamemode.");

    bool jeBrezBarve = (kare != 0 && piki != 0 && krizi != 0 && srci != 0) ||
        ((kare == 0 || piki == 0 || krizi == 0 || srci == 0) && taroki <= 1);
    List<int> beracTaroki =
        (user.cards.map((e) => max(e.card.worthOver - 10, 0)).toList());
    beracTaroki.sort((a, b) => a.compareTo(b));
    beracTaroki.removeLast(); // ta zadnjega se bomo itak verjetno znebili
    int tarokiWorth = beracTaroki.fold(0, (p, c) => p + c);
    // deljenje z nič go brrrr
    bool imaRokoBerac =
        taroki - 1 != 0 ? tarokiWorth / (taroki - 1) <= 7 : true;

    // berač
    if (user.botType == "berac" || user.botType == "vrazji") {
      if (myRating < VRAZJI_BERAC && jeBrezBarve && imaRokoBerac) {
        modes.add(6);
      }
      if (myRating < VRAZJI_ODPRTI_BERAC && jeBrezBarve && imaRokoBerac) {
        modes.add(8);
      }
    } else {
      if (myRating < BERAC && jeBrezBarve && imaRokoBerac) {
        modes.add(6);
      }
      if (myRating < ODPRTI_BERAC && jeBrezBarve && imaRokoBerac) {
        modes.add(8);
      }
    }

    if (myRating < BERAC) {
      myRating -= (myRating * krogovLicitiranja * 0.02).round();
    } else {
      myRating += (myRating * krogovLicitiranja * 0.02).round();
    }

    logger.d(
      "Evaluacija za osebo $userId je $myRating (po prilagoditvi zaradi krogov), kar je ${myRating / maximumRating}% največje evaluacije. Meja za berača je $BERAC, meja za odprtiča pa $ODPRTI_BERAC.",
    );
    logger.d(
      "Meje za igre so ${NORMALNI.map((e) => "${e.id}/${e.points}").toList()}",
    );

    if (user.botType == "vrazji") {
      for (int i = 0; i < VRAZJI.length; i++) {
        if (min(VRAZJI[i].points - myRating, 0) <= maximumRating * 0.2) {
          modes.add(VRAZJI[i].id);
        }

        if (VRAZJI[i].points <= myRating) {
          continue;
        }

        if (i == 0) {
          modes.add(-1);
          break;
        }

        double lower = (VRAZJI[i - 1].points - myRating).abs();
        double higher = (VRAZJI[i].points - myRating).abs();
        higher *= 1.3;
        debugPrint("lower=$lower, higher=$higher");
        modes.add(lower < higher ? VRAZJI[i - 1].id : VRAZJI[i].id);
        break;
      }

      // dalje
      if (myRating < VRAZJI_DVE) modes.add(-1);
    } else {
      for (int i = 0; i < NORMALNI.length; i++) {
        num f = min(NORMALNI[i].points - myRating, 0);
        double maxR = -(maximumRating * 0.2);
        debugPrint("f=$f, maxR=$maxR");
        if (f < 0 && f >= maxR) {
          modes.add(NORMALNI[i].id);
        }

        if (NORMALNI[i].points <= myRating) {
          continue;
        }

        if (i == 0) {
          modes.add(-1);
          break;
        }

        double lower = (NORMALNI[i - 1].points - myRating).abs();
        double higher = (NORMALNI[i].points - myRating).abs();
        higher *= 1.3;
        debugPrint("lower=$lower, higher=$higher");
        modes.add(lower < higher ? NORMALNI[i - 1].id : NORMALNI[i].id);
        break;
      }

      // dalje
      if (myRating < DVE) modes.add(-1);
    }

    modes.sort();
    // evaluation
    inspect(modes);

    bool isMandatory =
        userPositions.isEmpty ? canLicitateThree : userPositions.last == userId;
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

    int srci = 0;
    int piki = 0;
    int krizi = 0;
    int kare = 0;
    for (int i = 0; i < users[playerId]!.cards.length; i++) {
      Card card = users[playerId]!.cards[i];
      String cardType = card.card.asset.split("/")[1];
      if (cardType == "taroki") continue;
      if (cardType == "src") {
        srci++;
      } else if (cardType == "pik") {
        piki++;
      } else if (cardType == "kara") {
        kare++;
      } else {
        krizi++;
      }
    }

    List<String> p = ["kara", "kriz", "src", "pik"];
    for (int i = 0; i < user.cards.length; i++) {
      Card card = user.cards[i];
      if (card.card.asset == "/kara/kralj") p.remove("kara");
      if (card.card.asset == "/kriz/kralj") p.remove("kriz");
      if (card.card.asset == "/src/kralj") p.remove("src");
      if (card.card.asset == "/pik/kralj") p.remove("pik");
    }

    if (p.isEmpty) {
      // uporabnik drži vse kralje, izberemo naključnega, če že moramo
      p = ["/kara/kralj", "/kriz/kralj", "/src/kralj", "/pik/kralj"];
      return p[Random().nextInt(p.length)];
    }

    // rufaj kralja, katerega barve držiš največ
    int maxI = 0;
    int maximum = 0;
    for (int i = 0; i < p.length; i++) {
      if (p[i] == "src" && srci > maximum) {
        maximum = srci;
        maxI = i;
      } else if (p[i] == "kriz" && krizi > maximum) {
        maximum = krizi;
        maxI = i;
      } else if (p[i] == "pik" && piki > maximum) {
        maximum = piki;
        maxI = i;
      } else if (p[i] == "kara" && kare > maximum) {
        maximum = kare;
        maxI = i;
      }
    }

    return "/${p[maxI]}/kralj";
  }

  void selectSecretlyPlaying(String king) {
    if (userPositions.length != 4) {
      kingFallen = true;
      return;
    }

    selectedKing = king;
    List<String> keys = users.keys.toList(growable: false);
    for (int i = 0; i < keys.length; i++) {
      User user = users[keys[i]]!;
      for (int n = 0; n < user.cards.length; n++) {
        String card = user.cards[n].card.asset;
        if (card != king) continue;
        users[keys[i]]!.secretlyPlaying = true;
        if (getAllPlayingUsers().length == 1) {
          kingFallen = true;
        }
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
      if (cardType == "taroki") continue;
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
    // če imamo 4 igralce, kralj še ni odkrit, drugače pa je (v tri)
    kingFallen = userPositions.length == 4 ? false : true;
    krogovLicitiranja = -1;

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

      if (MOND_V_TALONU) {
        int csl = cards.length;
        for (int k = 0; k < csl; k++) {
          if (cards[k].asset != "/taroki/mond") continue;
          kralji.add(Card(card: cards[k], user: ""));
          cards.removeAt(k);
          break;
        }
      }

      if (SKIS_V_TALONU) {
        int csl = cards.length;
        for (int k = 0; k < csl; k++) {
          if (cards[k].asset != "/taroki/skis") continue;
          kralji.add(Card(card: cards[k], user: ""));
          cards.removeAt(k);
          break;
        }
      }

      if (PRIREDI_IGRO) {
        int csl = cards.length;
        for (int k = 0; k < csl; k++) {
          int i = k - userCards.length;
          if (!(cards[i].asset == "/taroki/pagat" ||
              cards[i].asset == "/taroki/mond" ||
              cards[i].asset == "/taroki/skis" ||
              cards[i].asset == "/taroki/20" ||
              cards[i].asset == "/taroki/19" ||
              cards[i].asset == "/taroki/18" ||
              cards[i].asset == "/taroki/17" ||
              cards[i].asset == "/taroki/16")) continue;
          userCards.add(Card(card: cards[i], user: HEKE_DOBI));
          cards.removeAt(i);
        }
      } else if (BARVIC) {
        int csl = cards.length;
        debugPrint("Izbiram karte za barviča");
        for (int k = 0; k < csl; k++) {
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
        int csl = cards.length;
        debugPrint("Izbiram karte za berača");
        for (int k = 0; k < csl; k++) {
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
        int csl = cards.length;
        int kr = 0;
        for (int k = 0; k < csl; k++) {
          int i = k - kr;
          if (!(cards[i].asset == "/src/kralj" ||
              cards[i].asset == "/kriz/kralj" ||
              cards[i].asset == "/pik/kralj" ||
              cards[i].asset == "/kara/kralj")) continue;
          kralji.add(Card(card: cards[i], user: ""));
          cards.removeAt(i);
          kr++;
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

    int srci = 0;
    int piki = 0;
    int krizi = 0;
    int kare = 0;
    for (int i = 0; i < users[playerId]!.cards.length; i++) {
      Card card = users[playerId]!.cards[i];
      String cardType = card.card.asset.split("/")[1];
      if (cardType == "taroki") continue;
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

    List<int> worth = [];

    if (barvic(playerId)) {
      debugPrint("Uporabljam evaluacijo talona za barvni valat");

      for (int i = 0; i < talon.length; i++) {
        int eval = 0;
        for (int n = 0; n < talon[i].length; n++) {
          Card card = talon[i][n];
          // pagat nima neke dodatne prednosti pri barviču
          eval += card.card.asset == "/taroki/pagat" ? 1 : card.card.worth;
          String type = getCardType(card.card.asset);
          if (srci > 25 && type == "src") {
            debugPrint("Izbiram srce na podlagi $srci");
            eval +=
                pow(card.card.worth + card.card.worthOver, 2).round() + srci;
          } else if (krizi > 25 && type == "kriz") {
            eval +=
                pow(card.card.worth + card.card.worthOver, 2).round() + krizi;
          } else if (kare > 25 && type == "kara") {
            eval +=
                pow(card.card.worth + card.card.worthOver, 2).round() + kare;
          } else if (piki > 25 && type == "pik") {
            eval +=
                pow(card.card.worth + card.card.worthOver, 2).round() + piki;
          }
          if (type == "taroki") {
            eval += ((card.card.worthOver - 10) * 0.5).round();
          }
        }
        worth.add(eval);
      }
    } else {
      debugPrint("Uporabljam evaluacijo talona za navadno igro");

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
            wor += (pow(card.card.worthOver - 10, 2) / 70).round();
          }
        }
        worth.add(wor);
      }
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

    bool b = barvic(playerId);

    int srci = 0;
    int piki = 0;
    int krizi = 0;
    int kare = 0;
    int taroki = 0;
    for (int i = 0; i < users[playerId]!.cards.length; i++) {
      Card card = users[playerId]!.cards[i];
      String cardType = card.card.asset.split("/")[1];
      // izpustimo tisto farbo, v kateri igralec igra
      if (cardType == playedIn) continue;
      if (cardType == "src" && !card.card.asset.contains("kralj")) {
        srci++;
      } else if (cardType == "pik" && !card.card.asset.contains("kralj")) {
        piki++;
      } else if (cardType == "kara" && !card.card.asset.contains("kralj")) {
        kare++;
      } else if (cardType == "kriz" && !card.card.asset.contains("kralj")) {
        krizi++;
      } else if (cardType == "taroki" && isValidToStash(card) && b) {
        debugPrint("prištevam tarok ${card.card.asset}");
        taroki++;
      }
    }

    List<int> kombinacije = [srci, piki, krizi, kare, taroki];

    // torej s kombinatoriko izvemo najboljši način, da si založimo toStash kart.
    // ne vemo katere barve so to, vemo pa da je najbolje, če si založimo karte, katere barva ima natanko n-kart
    List<int> barve = rekurzivnaKombinatorika(kombinacije, [], toStash);
    debugPrint("b: $barve $kombinacije");

    // prvo si založimo vse prej podane barve
    // to so vse barve razen rufane
    // če igramo solo 3 (barvič?) si še vedno založimo barve z najmanj kartami
    while (barve.isNotEmpty) {
      int b = barve.first;
      if (srci == b) {
        for (int i = 0; i < user.cards.length; i++) {
          Card card = user.cards[i];
          String cardType = card.card.asset.split("/")[1];
          if (!isValidToStash(card)) continue;
          if (cardType != "src") continue;
          debugPrint("zalagam ${card.card.asset} v1");
          stash.add(card);
          srci--;
          if (stash.length == toStash) return stash;
        }
      } else if (krizi == b) {
        for (int i = 0; i < user.cards.length; i++) {
          Card card = user.cards[i];
          String cardType = card.card.asset.split("/")[1];
          if (!isValidToStash(card)) continue;
          if (cardType != "kriz") continue;
          debugPrint("zalagam ${card.card.asset} v1");
          stash.add(card);
          krizi--;
          if (stash.length == toStash) return stash;
        }
      } else if (piki == b) {
        for (int i = 0; i < user.cards.length; i++) {
          Card card = user.cards[i];
          String cardType = card.card.asset.split("/")[1];
          if (!isValidToStash(card)) continue;
          if (cardType != "pik") continue;
          debugPrint("zalagam ${card.card.asset} v1");
          stash.add(card);
          piki--;
          if (stash.length == toStash) return stash;
        }
      } else if (kare == b) {
        for (int i = 0; i < user.cards.length; i++) {
          Card card = user.cards[i];
          String cardType = card.card.asset.split("/")[1];
          if (!isValidToStash(card)) continue;
          if (cardType != "kara") continue;
          debugPrint("zalagam ${card.card.asset} v1");
          stash.add(card);
          kare--;
          if (stash.length == toStash) return stash;
        }
      } else if (taroki == b) {
        // taroke pa preferiraj kot zadnje
        for (int i = 0; i < user.cards.length; i++) {
          Card card = user.cards[i];
          String cardType = card.card.asset.split("/")[1];
          if (!isValidToStash(card)) continue;
          if (cardType != "taroki") continue;
          debugPrint("zalagam ${card.card.asset} v1");
          stash.add(card);
          taroki--;
          if (stash.length == toStash) return stash;
        }
      }
      barve.removeAt(0);
    }

    while (srci + piki + kare + krizi > 0) {
      if (srci > 0) {
        for (int i = 0; i < user.cards.length; i++) {
          Card card = user.cards[i];
          String cardType = card.card.asset.split("/")[1];
          if (!isValidToStash(card)) continue;
          if (cardType != "src") continue;
          debugPrint("zalagam ${card.card.asset} v2");
          stash.add(card);
          srci--;
          if (stash.length == toStash) return stash;
        }
      } else if (krizi > 0) {
        for (int i = 0; i < user.cards.length; i++) {
          Card card = user.cards[i];
          String cardType = card.card.asset.split("/")[1];
          if (!isValidToStash(card)) continue;
          if (cardType != "kriz") continue;
          debugPrint("zalagam ${card.card.asset} v2");
          stash.add(card);
          krizi--;
          if (stash.length == toStash) return stash;
        }
      } else if (piki > 0) {
        for (int i = 0; i < user.cards.length; i++) {
          Card card = user.cards[i];
          String cardType = card.card.asset.split("/")[1];
          if (!isValidToStash(card)) continue;
          if (cardType != "pik") continue;
          debugPrint("zalagam ${card.card.asset} v2");
          stash.add(card);
          piki--;
          if (stash.length == toStash) return stash;
        }
      } else if (kare > 0) {
        for (int i = 0; i < user.cards.length; i++) {
          Card card = user.cards[i];
          String cardType = card.card.asset.split("/")[1];
          if (!isValidToStash(card)) continue;
          if (cardType != "kara") continue;
          debugPrint("zalagam ${card.card.asset} v2");
          stash.add(card);
          kare--;
          if (stash.length == toStash) return stash;
        }
      }
    }

    // če še kar nimamo dovolj kart založenih, gremo zalagati vse od rufane barve
    for (int i = 0; i < user.cards.length; i++) {
      Card card = user.cards[i];
      String cardType = card.card.asset.split("/")[1];
      if (!isValidToStash(card)) continue;
      if (cardType != playedIn) continue;
      debugPrint("zalagam ${card.card.asset} v3");
      stash.add(card);
      if (stash.length == toStash) return stash;
    }

    // če še kar nimamo dovolj kart založenih, gremo zalagati taroke
    // pred tem sortiramo zadeve od najnižje do najvišje, tako da zalagamo le najnižje taroke.
    user.cards.sort((a, b) => a.card.worthOver.compareTo(b.card.worthOver));
    for (int i = 0; i < user.cards.length; i++) {
      Card card = user.cards[i];
      String cardType = card.card.asset.split("/")[1];
      if (!isValidToStash(card)) continue;
      if (cardType != "taroki") continue;
      debugPrint("zalagam ${card.card.asset} v4");
      stash.add(card);
      if (stash.length == toStash) return stash;
    }

    // če še kar ne moremo založiti, potem pa javimo napako
    throw Exception("Could not stash enough cards");
  }

  String stihPickedUpBy(List<Card> stih) {
    if (stih.isEmpty) throw Exception("stih's length is 0");
    StihAnalysis analysis = analyzeStih(stih, gamemode)!;
    return analysis.cardPicks.user;
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
          taroki++;
        }
        if (cardType == "taroki" &&
            karta.card.worthOver > eval.najvisjiTarok.worthOver) {
          eval.najvisjiTarok = karta.card;
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

      debugPrint(
        "imaTaroke=$imaTaroke, nasprotnikImaSamoTaroke=$nasprotnikImaSamoTaroke",
      );

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

  double calculateTotal(List<Card> cards) {
    double worth = 0;
    for (int i = 0; i < cards.length; i++) {
      worth += cards[i].card.worth - 2 / 3;
    }
    return worth;
  }

  List<String> playingUsers() {
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

  SimpleUser? playingUser() {
    for (int i = 0; i < userPositions.length; i++) {
      User user = users[userPositions[i]]!;
      if (users[user.user.id]!.licitiral) {
        return user.user;
      }
    }
    return null;
  }

  SimpleUser? imaMonda() {
    for (int i = 0; i < userPositions.length; i++) {
      User user = users[userPositions[i]]!;
      for (int n = 0; n < user.cards.length; n++) {
        if (user.cards[n].card.asset != "/taroki/mond") continue;
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
    List<List<Card>> skupaj = [...stihi, talon];
    for (int i = 0; i < skupaj.length; i++) {
      List<Card> stih = skupaj[i];
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
    List<List<Card>> skupaj = [...stihi, talon];
    for (int i = 0; i < skupaj.length; i++) {
      List<Card> stih = skupaj[i];
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
      barvniValat: predictions.barvniValat,
      mondfang: predictions.mondfang,
      mondfangKontra: predictions.mondfangKontra,
      mondfangKontraDal: predictions.mondfangKontraDal,
      gamemode: gamemode,
    );

    List<Card> cards = user.cards;

    if (gamemode == -1) {
      if (newPredictions.igraKontra != 0) return false;

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
          "Evaluacija kontre pri klopu za osebo $userId je $myRating, kar je ${myRating / maximumRating}% največje evaluacije.");

      if (myRating / maximumRating > 0.35) return false;

      newPredictions.igraKontraDal = user.user;
      newPredictions.igraKontra = 1;
      predictions = newPredictions;

      return true;
    }

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
        newPredictions.barvniValat = user.user;
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

    if (gamemode == -1) {
      if (predictions.igraKontra == 0) {
        startPredictions.igraKontra = true;
      }
      return startPredictions;
    }

    bool playerPlaying = playing.contains(userId);
    if ((!playerPlaying && predictions.igraKontra % 2 == 0) ||
        (playerPlaying && predictions.igraKontra % 2 == 1) &&
            predictions.igraKontra < 4) {
      startPredictions.igraKontra = true;
    }

    if (actuallyPlayingUser == userId && predictions.valat.id == "") {
      startPredictions.valat = true;
      if (gamemode >= 3 && gamemode <= 5) {
        startPredictions.barvniValat = true;
      }
    }

    if (gamemode >= 6) return startPredictions;

    if (NAPOVEDAN_MONDFANG) {
      SimpleUser? monda = imaMonda();
      String mondfangDal = predictions.mondfang.id == ""
          ? predictions.mondfang.id
          : predictions.mondfangKontraDal.id;
      bool playerPlayingMond =
          (monda == null && actuallyPlayingUser == userId) ||
              (monda != null && monda.id == userId);
      bool isPlayingMond =
          (monda == null && actuallyPlayingUser == mondfangDal) ||
              (monda != null && monda.id == mondfangDal);
      if (predictions.mondfang.id == "") {
        // napovemo
        if (monda == null) {
          // mond je torej v talonu, ga ne more napovedati igralec
          if (actuallyPlayingUser != userId) {
            startPredictions.mondfang = true;
          }
        } else {
          if (monda.id != userId) {
            startPredictions.mondfang = true;
          }
        }
      } else {
        // kontriramo
        if (canGiveKontra(
          predictions.mondfang.id,
          playerPlayingMond,
          isPlayingMond,
          predictions.mondfangKontra,
        )) {
          startPredictions.mondfangKontra = true;
        }
      }
    }

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

    bool napovedalUltimo = predictions.pagatUltimo.id == userId ||
        predictions.kraljUltimo.id == userId;
    if (napovedalUltimo) {
      startPredictions.pagatUltimo = false;
      startPredictions.kraljUltimo = false;
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

    StihAnalysis analysis = analyzeStih(stih, gamemode)!;

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
    SimpleUser? actuallyPlayingUser = playingUser();
    List<String> keys = users.keys.toList();
    List<MessagesStih> stihiMessage = [];
    for (int i = 0; i < keys.length; i++) {
      User user = users[keys[i]]!;
      results[user.user.id] = [];
    }
    bool ttrula = false;
    String mondFallen = "";
    String skisFallen = "";
    String mondaIma = "";

    if (actuallyPlayingUser != null && gamemode >= 0 && gamemode <= 2) {
      for (int i = 0; i < stihi.length; i++) {
        List<Card> stih = stihi[i];
        if (stih.isEmpty) continue;
        StihAnalysis analysis = analyzeStih(stih, gamemode)!;
        if (analysis.cardPicks.card.asset == selectedKing &&
            analysis.cardPicks.user == actuallyPlayingUser.id) {
          // zaruf, prištejemo talon
          int k = talon.length;

          debugPrint("Prištevam talon zarufancu (talon ima velikost $k)");

          while (k > 0) {
            talon[0].user = actuallyPlayingUser.id;
            stihi[0].add(talon[0]);
            talon.removeAt(0);
            k--;
          }

          break;
        }
      }
    }

    for (int i = 0; i < stihi.length; i++) {
      List<Card> stih = stihi[i];
      if (stih.isEmpty) continue;
      //debugPrint(i);
      //debugPrint(stih.map((e) => e.card.asset));
      //debugPrint(stih.length);
      StihAnalysis analysis = analyzeStih(stih, gamemode)!;

      stihiMessage.add(
        MessagesStih(
          card: stih,
          worth: analysis.worth,
          pickedUpByPlaying: playing.contains(analysis.cardPicks.user),
          pickedUpBy: users[analysis.cardPicks.user]!.user.name,
        ),
      );
      debugPrint(
        "Pobral ${analysis.cardPicks.user}, pri čimer igrajo $playing, štih je dolg ${stih.length} in vreden ${analysis.worth}",
      );
      if (analysis.cardPicks.user == "") {
        logger.e("error while counting points");
        continue;
      }
      int t = 0;

      for (int n = 0; n < stih.length; n++) {
        Card card = stih[n];
        if (card.card.asset == "/taroki/mond") {
          mondFallen = card.user;
          mondaIma = card.user;
          t++;
        }
        if (card.card.asset == "/taroki/skis") {
          skisFallen = card.user;
          t++;
        }
        if (card.card.asset == "/taroki/pagat") {
          t++;
        }
        results[analysis.cardPicks.user]!.add(card);
      }

      // če se je zarufal in sta v talonu bila tako škis kot tudi mond mu ne štejemo mondfanga/škisfanga na 1. štihu (zalagalnem štihu)
      // to sicer lahko razširimo tudi na igre <= 5 (solo ena), saj imamo tudi tam zalagalni štih, v katerega pa si tako ali tako ne moremo založiti
      // monda in škisa, tako da je irelavantno ali damo ali ne
      if (gamemode <= 5 && gamemode >= 0 && i == 0) {
        skisFallen = "";
        mondFallen = "";
        continue;
      }

      if (skisFallen == "" || mondFallen == "") {
        mondFallen = "";
        skisFallen = "";
      }
      if (t == 3) {
        ttrula = true;
      }
    }

    if (talon.isNotEmpty) {
      stihiMessage.add(
        MessagesStih(
          card: talon,
          worth: calculateTotal(talon).toDouble(),
          pickedUpByPlaying: false,
          pickedUpBy: "",
        ),
      );
    }

    List<ResultsUser> newResults = [];

    if (gamemode != -1 && gamemode < 6) {
      // NORMALNE IGRE
      if (actuallyPlayingUser == null) {
        debugPrint("actuallyPlayingUser == null. Končujem izvajanje programa.");
        return Results(
          user: newResults,
          stih: stihiMessage,
          predictions: predictions,
        );
      }

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

      double pp = 0;
      for (int i = 0; i < keys.length; i++) {
        User user = users[keys[i]]!;
        if (playing.contains(user.user.id)) {
          pp += calculateTotal(results[user.user.id]!);
          debugPrint(
            "Prištevam karte igralca ${user.user.id} igralcem. Trenutne zbrane točke $pp.",
          );
        }
      }
      int playingPlayed = pp.round();
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
          pow(2, predictions.igraKontra).toInt();

      if (valatTotal != 0) {
        bool radelc = actuallyPlayingUser.radlci > 0;
        if (radelc) {
          if (valatTotal > 0) {
            actuallyPlayingUser.radlci--;
          }
        }
        newResults.add(
          ResultsUser(
            user: users.keys.map((key) =>
                users[key]!.playing || users[key]!.secretlyPlaying
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
        return Results(
          user: newResults,
          stih: stihiMessage,
          predictions: predictions,
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
          user: users.keys.map((key) =>
              users[key]!.playing || users[key]!.secretlyPlaying
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

      bool mondfang = mondTalon ||
          (!mondTalon && gamemode < 6 && mondFallen != "" && skisFallen != "");
      bool mondfangNapovedan =
          NAPOVEDAN_MONDFANG && predictions.mondfang.id != "";
      int mondfangKontra =
          pow(2, NAPOVEDAN_MONDFANG ? predictions.mondfangKontra : 0).toInt();
      int mondfangTotal = 21 *
          (mondfangNapovedan ? 2 : (mondfang ? 1 : 0)) *
          (mondfang ? -1 : 1) *
          mondfangKontra;

      // mond je v talonu, posledično ga igralcu štejemo v minus
      if (mondaIma == "") {
        mondaIma = actuallyPlayingUser.id;
      }

      if (mondfangTotal != 0) {
        newResults.add(
          ResultsUser(
            user: [
              SimpleUser(id: mondaIma, name: users[mondaIma]!.user.name),
            ],
            playing: true,
            points: mondfangTotal,
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

      if (ttrula && skisFallen != "" && skisfang) {
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
      // BERAČ, ODPRTI BERAČ
      if (actuallyPlayingUser == null) {
        debugPrint("actuallyPlayingUser == null. Končujem izvajanje programa.");
        return Results(
          user: newResults,
          stih: stihiMessage,
          predictions: predictions,
        );
      }

      int kontraIgra = pow(2, predictions.igraKontra).toInt();
      int gm = gamemode == 6 ? 70 : 90;
      gm *= kontraIgra;
      gm *= (results[actuallyPlayingUser.id]!.isEmpty ? 1 : -1);

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
          igra: gm,
          razlika: 0,
          radelc: radelc,
          points: gm,
        ),
      );
      dodajRadelce();
    } else if (gamemode == 7) {
      // SOLO BREZ
      if (actuallyPlayingUser == null) {
        debugPrint("actuallyPlayingUser == null. Končujem izvajanje programa.");
        return Results(
          user: newResults,
          stih: stihiMessage,
          predictions: predictions,
        );
      }

      int valat = isValat();
      int valatPrediction = 0;
      int valatCalc = calculatePrediction(valatPrediction, valat);
      int valatTotal = 250 * valatCalc * pow(2, predictions.igraKontra).toInt();

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
          predictions: predictions,
        );
      }

      int kontraIgra = pow(2, predictions.igraKontra).toInt();
      int gm = 80;
      gm *= kontraIgra;

      int total = calculateTotal(results[actuallyPlayingUser.id]!).round();

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
      if (actuallyPlayingUser == null) {
        debugPrint("actuallyPlayingUser == null. Končujem izvajanje programa.");
        return Results(
          user: newResults,
          stih: stihiMessage,
          predictions: predictions,
        );
      }

      int valat = isValat();
      int valatPrediction = (playing.contains(predictions.igra.id) ? 1 : -1);
      int valatCalc = calculatePrediction(valatPrediction, valat);
      int valatTotal = 125 * valatCalc * pow(2, predictions.igraKontra).toInt();

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
      if (actuallyPlayingUser == null) {
        debugPrint("actuallyPlayingUser == null. Končujem izvajanje programa.");
        return Results(
          user: newResults,
          stih: stihiMessage,
          predictions: predictions,
        );
      }

      int valat = isValat();
      int valatPrediction = (playing.contains(predictions.igra.id) ? 1 : -1);
      int valatCalc = calculatePrediction(valatPrediction, valat);
      int valatTotal = 500 * valatCalc * pow(2, predictions.igraKontra).toInt();

      bool radelc = actuallyPlayingUser.radlci > 0;
      if (radelc) {
        if (valatTotal > 0) {
          actuallyPlayingUser.radlci--;
        }
      }

      newResults.add(
        ResultsUser(
          user: users.keys.map((key) =>
              users[key]!.playing || users[key]!.secretlyPlaying
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

      int maximum = 0;
      String maximumAchievedBy = predictions.igraKontraDal.id;

      for (int i = 0; i < keys.length; i++) {
        User user = users[keys[i]]!;
        int diff = calculateTotal(results[user.user.id]!).round();
        if (diff == 0) {
          none = true;
          newResults.add(ResultsUser(
            user: [user.user],
            playing: true,
            showDifference: true,
            showGamemode: false,
            showKralj: false,
            showKralji: false,
            showPagat: false,
            showTrula: false,
            radelc: false,
            kontraIgra: predictions.igraKontra,
            razlika: 0,
            points: 70,
          ));
        } else if (diff > 35) {
          if (diff > maximum) {
            maximum = diff;
            maximumAchievedBy = user.user.id;
          }

          full = true;
          newResults.add(ResultsUser(
            user: [user.user],
            playing: true,
            showDifference: true,
            showGamemode: false,
            showKralj: false,
            showKralji: false,
            showPagat: false,
            showTrula: false,
            razlika: -diff,
            kontraIgra: predictions.igraKontra,
            radelc: false,
            points: -70,
          ));
        }
      }

      if (!none && !full) {
        for (int i = 0; i < keys.length; i++) {
          User user = users[keys[i]]!;
          int total = calculateTotal(results[user.user.id]!).round();
          int diff = -total;

          if (total > maximum) {
            maximum = total;
            maximumAchievedBy = user.user.id;
          }

          newResults.add(ResultsUser(
            user: [user.user],
            playing: true,
            showDifference: true,
            showGamemode: false,
            showKralj: false,
            showKralji: false,
            showPagat: false,
            showTrula: false,
            kontraIgra: predictions.igraKontra,
            razlika: diff,
            radelc: false,
            points: diff,
          ));
        }
      }

      debugPrint(
          "maximumAchievedBy=$maximumAchievedBy, igraKontraDal=${predictions.igraKontraDal.id}");

      if (predictions.igraKontra == 1) {
        for (int i = 0; i < newResults.length; i++) {
          if (maximumAchievedBy == predictions.igraKontraDal.id &&
              newResults[i].user.first.id != maximumAchievedBy) {
            continue;
          }
          newResults[i].points *= 2;
        }
      }

      newResults.sort(
        (a, b) => a.razlika.compareTo(b.razlika),
      );

      dodajRadelce();
    }
    return Results(
      user: newResults,
      stih: stihiMessage,
      predictions: predictions,
    );
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
      StihAnalysis by = analyzeStih(stihi[i], gamemode)!;
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
