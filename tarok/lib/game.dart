import 'dart:math';

import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:tarok/constants.dart';
import 'package:tarok/game/cardutils.dart';
import 'package:tarok/game/mycards.dart';
import 'package:tarok/game/names.dart';
import 'package:tarok/game/premoves.dart';
import 'package:tarok/game/stihi.dart';
import 'package:tarok/game/utils.dart';
import 'package:tarok/game/variables.dart';
import 'package:tarok/online/friends.dart';
import 'package:tarok/online/websocket.dart';
import 'package:stockskis/stockskis.dart' as stockskis;

import 'stockskis_compatibility/compatibility.dart';

class Game extends StatefulWidget {
  const Game(
      {super.key,
      required this.gameId,
      required this.bots,
      required this.playing});

  final String gameId;
  final bool bots;
  final int playing;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  void initState() {
    resetVariables();

    bots = widget.bots;
    playingCount = widget.playing;

    controller = TextEditingController();

    ws = WS(setState: setState);
    ws.init();

    // BOTI - OFFLINE
    if (widget.bots) {
      playerId = "player";
      ws.offline.startGame();
      super.initState();
      return;
    }

    fetchFriends(setState);

    // ONLINE
    ws.connect(widget.gameId);
    ws.listen();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    try {
      ws.socket.close();
    } catch (e) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fullHeight = MediaQuery.of(context).size.height;
    final fullWidth = MediaQuery.of(context).size.width;

    final cardSize = min(
      max(
        fullWidth / cards.length,
        fullWidth * 0.2,
      ),
      fullHeight * 0.5,
    );
    final cardWidth = cardSize * 0.573;
    const duration = Duration(milliseconds: 150);
    final m = min(fullHeight, fullWidth);
    const cardK = 0.38;
    final leftFromTop = fullHeight * 0.30;
    final cardToWidth = fullWidth * 0.35 - 50 - (m * cardK * 0.57) / 2 + 50;
    final center = cardToWidth - m * cardK * 0.57 * 0.8;
    final userSquareSize = min(fullHeight / 5, 100.0).toDouble();
    final border = (fullWidth / 800);
    final popupCardSize = fullHeight / 2.5;
    const kCoverUp = 0.6;

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          resetPremoves();
          premovedCard = null;
          setState(() {});

          int validCards = 0;
          for (int i = 0; i < cards.length; i++) {
            if (cards[i].valid) validCards++;
            if (validCards > 1) return;
          }
          if (validCards == 0) return;
          if (!turn) return;
          for (int i = 0; i < cards.length; i++) {
            if (!cards[i].valid) continue;
            ws.sendCard(cards[i]);
            break;
          }
        },
        child: Stack(
          children: [
            // COUNTDOWN
            if (countdown != 0)
              Positioned(
                left: center * 1.5,
                top: userSquareSize,
                child: Text(
                  countdown.toString(),
                  style: TextStyle(
                    fontSize: fullHeight / 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            // REZULTATI, KLEPET, CHAT
            Container(
              alignment: Alignment.topRight,
              child: Card(
                elevation: 10,
                child: SizedBox(
                  height: fullHeight / 1.6,
                  width: fullWidth / 4,
                  child: DefaultTabController(
                      length: 4,
                      child: Scaffold(
                        appBar: AppBar(
                          automaticallyImplyLeading: false,
                          elevation: 0,
                          flexibleSpace: const TabBar(tabs: [
                            Tab(icon: Icon(Icons.timeline)),
                            Tab(icon: Icon(Icons.chat)),
                            Tab(icon: Icon(Icons.bug_report)),
                            Tab(icon: Icon(Icons.info)),
                          ]),
                        ),
                        body: TabBarView(children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  ...users.map(
                                      (stockskis.SimpleUser user) => Expanded(
                                            child: Center(
                                              child: Text(
                                                user.name,
                                                style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          )),
                                ],
                              ),
                              Row(
                                children: [
                                  ...users.map(
                                      (stockskis.SimpleUser user) => Expanded(
                                            child: Center(
                                              child: Text(
                                                user.radlci > 5
                                                    ? "${user.radlci} ✪"
                                                    : List.generate(user.radlci,
                                                        (e) => "✪").join(" "),
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          )),
                                ],
                              ),
                              if (users.isNotEmpty)
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    child: ListView.builder(
                                      itemCount: users[0].points.length,
                                      itemBuilder:
                                          (BuildContext context, int index) =>
                                              GestureDetector(
                                        onTap: () {
                                          results = ResultsCompLayer
                                              .stockSkisToMessages(
                                            users.first.points[index].results,
                                          );
                                          setState(() {});
                                        },
                                        child: Row(
                                          children: [
                                            ...users.map(
                                              (e) => Expanded(
                                                child: Center(
                                                  child: Text(
                                                    e.points[index].points
                                                            .toString() +
                                                        (e.points[index]
                                                                    .playing &&
                                                                e.points[index]
                                                                    .radelc
                                                            ? e.points[index]
                                                                        .points >=
                                                                    0
                                                                ? " 🔺"
                                                                : " 🔻"
                                                            : ""),
                                                    style: TextStyle(
                                                      color: e.points[index]
                                                                  .points <
                                                              0
                                                          ? Colors.red
                                                          : (e.points[index]
                                                                      .points ==
                                                                  0
                                                              ? Colors.grey
                                                              : Colors.green),
                                                      fontSize: 12,
                                                      fontWeight: e
                                                              .points[index]
                                                              .playing
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              Row(
                                children: [
                                  ...users.map((e) => Expanded(
                                        child: Center(
                                          child: Text(
                                            e.total.toString(),
                                            style: TextStyle(
                                              color: e.total < 0
                                                  ? Colors.red
                                                  : (e.total == 0
                                                      ? Colors.grey
                                                      : Colors.green),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ],
                          ),
                          Column(children: [
                            Expanded(
                              child: ListView(
                                children: chat
                                    .map((e) => Row(children: [
                                          Initicon(
                                            text: getUserFromPosition(e.userId)
                                                .name,
                                            elevation: 4,
                                            size: 40,
                                            backgroundColor: HSLColor.fromAHSL(
                                                    1,
                                                    hashCode(
                                                            getUserFromPosition(
                                                                    e.userId)
                                                                .name) %
                                                        360,
                                                    1,
                                                    0.6)
                                                .toColor(),
                                            borderRadius: BorderRadius.zero,
                                          ),
                                          const SizedBox(width: 10),
                                          Flexible(
                                            child: Text(
                                                "${getUserFromPosition(e.userId).name}: ${e.message}"),
                                          ),
                                        ]))
                                    .toList(),
                              ),
                            ),
                            TextField(
                              controller: controller,
                              onSubmitted: (String value) async {
                                await ws.sendMessage();
                              },
                            ),
                          ]),
                          ListView(children: [
                            const Center(
                              child: Text(
                                "Odpravljanje hroščev",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Text(
                              "Prva karta: ${firstCard == null ? '' : firstCard!.asset}",
                            ),
                            Text("Štih: $cardStih"),
                            Text("Izbran kralj: $selectedKing"),
                            Text("Uporabnik s kraljem: $userHasKing"),
                            Text("Karte založene: $stashAmount"),
                            Text("Talon izbran: $talonSelected"),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              onPressed: () {
                                validCards();
                                setState(() {});
                              },
                              child: const Text(
                                "Ponovno evaluiraj karte",
                              ),
                            ),
                          ]),
                          ListView(children: [
                            ...userWidgets.map(
                              (e) => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (e.id == userHasKing || e.licitiral > -1)
                                      Text(e.name,
                                          style: TextStyle(
                                            fontSize: userSquareSize / 3,
                                          )),
                                    const SizedBox(width: 20),
                                    if (e.licitiral > -1)
                                      Container(
                                        height: userSquareSize / 2,
                                        width: userSquareSize / 2,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          border: Border.all(
                                            color: zaruf
                                                ? Colors.red
                                                : Colors.black,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            GAME_DESC[e.licitiral + 1],
                                            style: TextStyle(
                                              fontSize: 0.3 * userSquareSize,
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (e.id == userHasKing ||
                                        (e.licitiral > -1 && e.licitiral < 6))
                                      Container(
                                        height: userSquareSize / 2,
                                        width: userSquareSize / 2,
                                        decoration: BoxDecoration(
                                          color: selectedKing == "/pik/kralj" ||
                                                  selectedKing == "/kriz/kralj"
                                              ? Colors.black
                                              : Colors.red,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: Center(
                                          child: Text(
                                              selectedKing == "/pik/kralj"
                                                  ? "♠️"
                                                  : (selectedKing ==
                                                          "/src/kralj"
                                                      ? "❤️"
                                                      : (selectedKing ==
                                                              "/kriz/kralj"
                                                          ? "♣️"
                                                          : "♦️")),
                                              style: TextStyle(
                                                  fontSize:
                                                      0.3 * userSquareSize)),
                                        ),
                                      ),
                                  ]),
                            ),
                            const Center(child: Text("Povabi prijatelje")),
                            ...prijatelji.map(
                              (e) => Row(
                                children: [
                                  Text("${e["User"]["Name"]}"),
                                  const Spacer(),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await ws.invitePlayer(e["User"]["ID"]);
                                    },
                                    child: const Text("Povabi"),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  await ws.manuallyStartGame();
                                },
                                child: const Text("Začni igro"),
                              ),
                            ),
                          ]),
                        ]),
                      )),
                ),
              ),
            ),

            // EVAL BAR
            if (widget.bots)
              Positioned(
                top: 0,
                right: fullWidth / 4,
                child: Container(
                  margin: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 3)),
                  child: Stack(
                    children: [
                      Container(
                        height: fullHeight / 3,
                        width: 25,
                        color: Colors.white,
                      ),
                      AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        color: Colors.black,
                        height: fullHeight / 3 * max(0, min(1, 1 - eval / 2)),
                        width: 25,
                      ),
                    ],
                  ),
                ),
              ),

            if (widget.bots)
              Positioned(
                top: fullHeight / 3 + 25,
                right: fullWidth / 4 + 20,
                child: Text(
                  (eval).toStringAsFixed(1),
                ),
              ),

            // ŠTIHI
            if (widget.playing == 3 && !(widget.bots && SLEPI_TAROK))
              ...stihi3(
                cardK,
                m,
                center,
                leftFromTop,
                cardToWidth,
                fullWidth,
              ),
            if (widget.playing == 4 && !(widget.bots && SLEPI_TAROK))
              ...stihi4(
                cardK,
                m,
                center,
                leftFromTop,
                cardToWidth,
                fullWidth,
              ),

            // MOJE KARTE
            ...myCards(
              cardSize,
              fullWidth,
              fullHeight,
              cardWidth,
              duration,
              setState,
            ),

            // IMENA
            if (widget.playing == 4)
              ...generateNames4(
                leftFromTop,
                m,
                cardK,
                userSquareSize,
                fullWidth,
                fullHeight,
              ),
            if (widget.playing == 3)
              ...generateNames3(
                leftFromTop,
                m,
                cardK,
                userSquareSize,
                fullWidth,
                fullHeight,
              ),

            // LICITIRANJE
            if (licitiranje)
              DraggableWidget(
                initialPosition: AnchoringPosition.center,
                child: Card(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ...users.map(
                                (stockskis.SimpleUser user) => Row(
                                  children: [
                                    Column(
                                      children: [
                                        Center(
                                          child: Text(
                                            user.name,
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            user.licitiral == -2
                                                ? ""
                                                : stockskis
                                                    .GAMES[user.licitiral + 1]
                                                    .name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (licitiram)
                            Container(
                              constraints:
                                  BoxConstraints(maxWidth: fullWidth / 2),
                              child: GridView.count(
                                shrinkWrap: true,
                                primary: false,
                                padding: const EdgeInsets.all(20),
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                crossAxisCount: 4,
                                childAspectRatio: 3,
                                children: [
                                  ...games.map((e) {
                                    if (users.length == 3 && !e.playsThree) {
                                      return const SizedBox();
                                    }
                                    return SizedBox(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              suggestions.contains(e.id)
                                                  ? Colors.purpleAccent.shade400
                                                  : null,
                                          textStyle: TextStyle(
                                            fontSize: fullHeight / 30,
                                          ),
                                        ),
                                        onPressed: () async {
                                          await ws.licitiranjeSend(e);
                                        },
                                        child: Text(
                                          e.name,
                                        ),
                                      ),
                                    );
                                  })
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // KRALJI
            if (kingSelection)
              DraggableWidget(
                initialPosition: AnchoringPosition.center,
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ...KINGS.map(
                              (king) => GestureDetector(
                                onTap: () async {
                                  await ws.selectKing(king.asset);
                                },
                                child: Stack(
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              10 * border),
                                          child: SizedBox(
                                            height: popupCardSize,
                                            child: Stack(
                                              children: [
                                                Container(
                                                  color: Colors.white,
                                                  height: popupCardSize,
                                                  width: popupCardSize * 0.57,
                                                ),
                                                Image.asset(
                                                    "assets/tarok${king.asset}.webp"),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                    if (selectedKing != king.asset &&
                                        !kingSelect)
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10 * border),
                                        child: Container(
                                          color: Colors.black.withAlpha(100),
                                          height: popupCardSize,
                                          width: popupCardSize * 0.57,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // NAPOVEDI
            if (predictions && currentPredictions != null)
              DraggableWidget(
                initialPosition: AnchoringPosition.center,
                child: Card(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DataTable(
                            dataRowMaxHeight: 40,
                            dataRowMinHeight: 40,
                            headingRowHeight: 40,
                            columns: <DataColumn>[
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'Igra (${stockskis.GAMES[currentPredictions!.gamemode + 1].name == "Naprej" ? "Klop" : stockskis.GAMES[currentPredictions!.gamemode + 1].name})',
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(users.map((e) {
                                    if (e.id == currentPredictions!.igra.id) {
                                      return e.name;
                                    }
                                    return "";
                                  }).join("")),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Row(
                                    children: [
                                      if (myPredictions != null &&
                                          myPredictions!.igraKontra)
                                        Switch(
                                          value: kontraIgra,
                                          onChanged: (bool value) {
                                            setState(() {
                                              if (value) {
                                                currentPredictions!
                                                    .igraKontra++;
                                              } else {
                                                currentPredictions!
                                                    .igraKontra--;
                                              }
                                              kontraIgra = value;
                                            });
                                          },
                                        ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                          "${KONTRE[currentPredictions!.igraKontra]} (${users.map((e) {
                                        if (e.id ==
                                            currentPredictions!.igraKontraDal
                                                .id) return e.name;
                                        return "";
                                      }).join("")})"),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            rows: <DataRow>[
                              if (!(valat ||
                                  barvic ||
                                  currentPredictions!.gamemode >= 6 ||
                                  currentPredictions!.gamemode == -1))
                                DataRow(
                                  cells: <DataCell>[
                                    const DataCell(Text('Trula')),
                                    if (myPredictions != null &&
                                        myPredictions!.trula &&
                                        users.map((e) {
                                              if (e.id ==
                                                  currentPredictions!
                                                      .trula.id) {
                                                return e.name;
                                              }
                                              return "";
                                            }).join("") ==
                                            "")
                                      DataCell(
                                        Switch(
                                          value: trula,
                                          onChanged: (bool value) {
                                            setState(() {
                                              trula = value;
                                            });
                                          },
                                        ),
                                      )
                                    else
                                      DataCell(Text(users.map((e) {
                                        if (e.id ==
                                            currentPredictions!.trula.id) {
                                          return e.name;
                                        }
                                        return "";
                                      }).join(""))),
                                    const DataCell(
                                      Row(
                                        children: [
                                          Text("/"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              if (!(valat ||
                                  barvic ||
                                  currentPredictions!.gamemode >= 6 ||
                                  currentPredictions!.gamemode == -1))
                                DataRow(
                                  cells: <DataCell>[
                                    const DataCell(Text('Kralji')),
                                    if (myPredictions != null &&
                                        myPredictions!.kralji &&
                                        users.map((e) {
                                              if (e.id ==
                                                  currentPredictions!
                                                      .kralji.id) {
                                                return e.name;
                                              }
                                              return "";
                                            }).join("") ==
                                            "")
                                      DataCell(
                                        Switch(
                                          value: kralji,
                                          onChanged: (bool value) {
                                            setState(() {
                                              kralji = value;
                                            });
                                          },
                                        ),
                                      )
                                    else
                                      DataCell(Text(users.map((e) {
                                        if (e.id ==
                                            currentPredictions!.kralji.id) {
                                          return e.name;
                                        }
                                        return "";
                                      }).join(""))),
                                    const DataCell(
                                      Row(
                                        children: [
                                          Text("/"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              if (!(valat ||
                                  barvic ||
                                  currentPredictions!.gamemode >= 6 ||
                                  currentPredictions!.gamemode == -1))
                                DataRow(
                                  cells: <DataCell>[
                                    const DataCell(Text('Pagat ultimo')),
                                    if (myPredictions != null &&
                                        myPredictions!.pagatUltimo &&
                                        !kraljUltimo)
                                      DataCell(
                                        Switch(
                                          value: pagatUltimo,
                                          onChanged: (bool value) {
                                            setState(() {
                                              pagatUltimo = value;
                                            });
                                          },
                                        ),
                                      )
                                    else
                                      DataCell(Text(users.map((e) {
                                        if (e.id ==
                                            currentPredictions!
                                                .pagatUltimo.id) {
                                          return e.name;
                                        }
                                        return "";
                                      }).join(""))),
                                    DataCell(
                                      Row(
                                        children: [
                                          if (myPredictions != null &&
                                              myPredictions!.pagatUltimoKontra)
                                            Switch(
                                              value: kontraPagat,
                                              onChanged: (bool value) {
                                                setState(() {
                                                  if (value) {
                                                    currentPredictions!
                                                        .pagatUltimoKontra++;
                                                  } else {
                                                    currentPredictions!
                                                        .pagatUltimoKontra--;
                                                  }
                                                  kontraPagat = value;
                                                });
                                              },
                                            ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                              "${KONTRE[currentPredictions!.pagatUltimoKontra]} (${users.map((e) {
                                            if (e.id ==
                                                currentPredictions!
                                                    .pagatUltimoKontraDal
                                                    .id) return e.name;
                                            return "";
                                          }).join("")})"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              if (!(valat ||
                                  barvic ||
                                  currentPredictions!.gamemode >= 6 ||
                                  currentPredictions!.gamemode == -1))
                                DataRow(
                                  cells: <DataCell>[
                                    const DataCell(Text('Kralj ultimo')),
                                    if (myPredictions != null &&
                                        myPredictions!.kraljUltimo &&
                                        !pagatUltimo)
                                      DataCell(
                                        Switch(
                                          value: kraljUltimo,
                                          onChanged: (bool value) {
                                            setState(() {
                                              kraljUltimo = value;
                                            });
                                          },
                                        ),
                                      )
                                    else
                                      DataCell(Text(users.map((e) {
                                        if (e.id ==
                                            currentPredictions!
                                                .kraljUltimo.id) {
                                          return e.name;
                                        }
                                        return "";
                                      }).join(""))),
                                    DataCell(
                                      Row(
                                        children: [
                                          if (myPredictions != null &&
                                              myPredictions!.kraljUltimoKontra)
                                            Switch(
                                              value: kontraKralj,
                                              onChanged: (bool value) {
                                                setState(() {
                                                  if (value) {
                                                    currentPredictions!
                                                        .kraljUltimoKontra++;
                                                  } else {
                                                    currentPredictions!
                                                        .kraljUltimoKontra--;
                                                  }
                                                  kontraKralj = value;
                                                });
                                              },
                                            ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                              "${KONTRE[currentPredictions!.kraljUltimoKontra]} (${users.map((e) {
                                            if (e.id ==
                                                currentPredictions!
                                                    .kraljUltimoKontraDal
                                                    .id) return e.name;
                                            return "";
                                          }).join("")})"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              if (!valat &&
                                  !barvic &&
                                  (currentPredictions!.mondfang.id != "" ||
                                      (myPredictions != null &&
                                          myPredictions!.mondfang)) &&
                                  currentPredictions!.gamemode >= 0 &&
                                  currentPredictions!.gamemode <= 5)
                                DataRow(
                                  cells: <DataCell>[
                                    const DataCell(Text('Mondfang')),
                                    if (myPredictions != null &&
                                        myPredictions!.mondfang)
                                      DataCell(
                                        Switch(
                                          value: mondfang,
                                          onChanged: (bool value) {
                                            setState(() {
                                              mondfang = value;
                                            });
                                          },
                                        ),
                                      )
                                    else
                                      DataCell(Text(users.map((e) {
                                        if (e.id ==
                                            currentPredictions!.mondfang.id) {
                                          return e.name;
                                        }
                                        return "";
                                      }).join(""))),
                                    DataCell(
                                      Row(
                                        children: [
                                          if (myPredictions != null &&
                                              myPredictions!.mondfangKontra)
                                            Switch(
                                              value: kontraMondfang,
                                              onChanged: (bool value) {
                                                setState(() {
                                                  if (value) {
                                                    currentPredictions!
                                                        .mondfangKontra++;
                                                  } else {
                                                    currentPredictions!
                                                        .mondfangKontra--;
                                                  }
                                                  kontraMondfang = value;
                                                });
                                              },
                                            ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                              "${KONTRE[currentPredictions!.mondfangKontra]} (${users.map((e) {
                                            if (e.id ==
                                                currentPredictions!
                                                    .mondfangKontraDal
                                                    .id) return e.name;
                                            return "";
                                          }).join("")})"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              if (!(valat ||
                                  currentPredictions!.gamemode >= 6 ||
                                  currentPredictions!.gamemode <= 2 ||
                                  currentPredictions!.gamemode == -1 ||
                                  !playing))
                                DataRow(
                                  cells: <DataCell>[
                                    const DataCell(Text('Barvni valat')),
                                    if (myPredictions != null &&
                                        myPredictions!.barvniValat)
                                      DataCell(
                                        Switch(
                                          value: barvic,
                                          onChanged: (bool value) {
                                            setState(() {
                                              barvic = value;
                                            });
                                          },
                                        ),
                                      )
                                    else
                                      DataCell(Text(users.map((e) {
                                        if (e.id ==
                                            currentPredictions!
                                                .barvniValat.id) {
                                          return e.name;
                                        }
                                        return "";
                                      }).join(""))),
                                    const DataCell(SizedBox()),
                                  ],
                                ),
                              if (!(barvic ||
                                  currentPredictions!.gamemode >= 6 ||
                                  currentPredictions!.gamemode == -1 ||
                                  !playing))
                                DataRow(
                                  cells: <DataCell>[
                                    const DataCell(Text('Valat')),
                                    if (myPredictions != null &&
                                        myPredictions!.valat)
                                      DataCell(
                                        Switch(
                                          value: valat,
                                          onChanged: (bool value) {
                                            setState(() {
                                              valat = value;
                                            });
                                          },
                                        ),
                                      )
                                    else
                                      DataCell(Text(users.map((e) {
                                        if (e.id ==
                                            currentPredictions!.valat.id) {
                                          return e.name;
                                        }
                                        return "";
                                      }).join(""))),
                                    const DataCell(SizedBox()),
                                  ],
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (talon.isNotEmpty)
                                ElevatedButton(
                                  onPressed: () {
                                    showTalon = true;
                                    setState(() {});
                                  },
                                  child: const Text(
                                    "Pokaži talon",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              if (startPredicting)
                                ElevatedButton(
                                  onPressed: ws.predict,
                                  child: const Text(
                                    "Napovej",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // TALON
            if (showTalon)
              DraggableWidget(
                initialPosition: AnchoringPosition.center,
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (selectedKing != "")
                          Text(
                            "${users.map((e) {
                              //debugPrint("igra ${currentPredictions!.igra.id} ${e.id}");
                              if (e.id == currentPredictions!.igra.id) {
                                return e.name;
                              }
                              return "";
                            }).join("")} igra v ${selectedKing == "/pik/kralj" ? "piku" : selectedKing == "/kara/kralj" ? "kari" : selectedKing == "/src/kralj" ? "srcu" : "križu"}.",
                          ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...talon.asMap().entries.map(
                                  (stih) => GestureDetector(
                                    onTap: () async {
                                      await ws.selectTalon(stih.key);
                                    },
                                    child: SizedBox(
                                      width: popupCardSize *
                                              0.573 *
                                              (1 +
                                                  kCoverUp *
                                                      (stih.value.length - 1)) +
                                          stih.value.length * 3,
                                      height: popupCardSize,
                                      child: Stack(
                                        children: [
                                          ...stih.value.asMap().entries.map(
                                                (entry) => Positioned(
                                                  left: (popupCardSize *
                                                          0.573 *
                                                          kCoverUp *
                                                          entry.key)
                                                      .toDouble(), // neka bs konstanta, ki izvira iz nekaj vrstic bolj gor
                                                  // ali imam mentalne probleme? ja.
                                                  // ali me briga? ne.
                                                  // fuck bad code quality
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10 *
                                                                (fullWidth /
                                                                    1000)),
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          color: Colors.white,
                                                          width: popupCardSize *
                                                              0.57,
                                                          height: popupCardSize,
                                                        ),
                                                        SizedBox(
                                                          height: popupCardSize,
                                                          child: Image.asset(
                                                            "assets/tarok${entry.value.asset}.webp",
                                                          ),
                                                        ),
                                                        if (talonSelected !=
                                                                -1 &&
                                                            talonSelected !=
                                                                stih.key)
                                                          Container(
                                                            color: Colors.black
                                                                .withAlpha(100),
                                                            height:
                                                                popupCardSize,
                                                            width:
                                                                popupCardSize *
                                                                    0.57,
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (zaruf)
                          const Text(
                              "Uf, tole pa bo zaruf. Če izbereš kralja in ga uspešno pripelješ čez, dobiš še preostanek talona in v primeru, da je v talonu mond, ne pišeš -21 dol."),
                        ElevatedButton(
                          onPressed: () {
                            showTalon = false;
                            setState(() {});
                          },
                          child: const Text(
                            "Skrij talon",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // ZALOŽITEV KART
            // POTRDI ZALOŽITEV
            if (stashedCards.length >= stashAmount && stashAmount > 0)
              DraggableWidget(
                initialPosition: AnchoringPosition.center,
                child: Card(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Trenutno si zalagate naslednje karte.",
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...stashedCards.map(
                                (king) => Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          10 * (fullWidth / 800)),
                                      child: SizedBox(
                                        height: popupCardSize,
                                        child: Stack(
                                          children: [
                                            Container(
                                              color: Colors.white,
                                              height: popupCardSize,
                                              width: popupCardSize * 0.57,
                                            ),
                                            Image.asset(
                                                "assets/tarok${king.asset}.webp"),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  await ws.stashEnd(true);
                                  stashedCards = [];
                                  setState(() {});
                                },
                                child: const Text(
                                  "Potrdi",
                                ),
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: () async {
                                  int k = stashedCards.length;
                                  for (int i = 0; i < k; i++) {
                                    debugPrint(
                                        "return card: ${stashedCards[0]}");
                                    cards.add(stashedCards[0]);
                                    stashedCards.removeAt(0);
                                  }
                                  turn = true;
                                  sortCards();
                                  setState(() {});
                                },
                                child: const Text(
                                  "Zamenjaj karte",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // REZULTATI IGRE
            if (results != null)
              DraggableWidget(
                initialPosition: AnchoringPosition.center,
                child: Card(
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth:
                            fullWidth < 1000 ? fullWidth : fullWidth / 1.5,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...results!.user.map(
                            (e) => Column(
                              children: [
                                ...e.user.map(
                                  (e2) => e2.name != ""
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: Initicon(
                                                text: e2.name,
                                                elevation: 4,
                                                size: 30,
                                                backgroundColor:
                                                    HSLColor.fromAHSL(
                                                            1,
                                                            hashCode(e2.name) %
                                                                360,
                                                            1,
                                                            0.6)
                                                        .toColor(),
                                                borderRadius: BorderRadius.zero,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              e2.name,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                ),
                                DataTable(
                                  dataRowMaxHeight: 40,
                                  dataRowMinHeight: 40,
                                  headingRowHeight: 40,
                                  columns: const <DataColumn>[
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Napoved',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Kontra',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Rezultat',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Napovedal',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Kontro dal',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: <DataRow>[
                                    if (e.showGamemode)
                                      DataRow(
                                        cells: <DataCell>[
                                          const DataCell(Text('Igra')),
                                          DataCell(
                                              Text('${pow(2, e.kontraIgra)}x')),
                                          DataCell(Text(
                                            '${e.igra}',
                                            style: TextStyle(
                                              color: e.igra < 0
                                                  ? Colors.red
                                                  : Colors.green,
                                            ),
                                          )),
                                          DataCell(Text(
                                              currentPredictions!.igra.name)),
                                          DataCell(Text(currentPredictions!
                                              .igraKontraDal.name)),
                                        ],
                                      ),
                                    if (e.showDifference)
                                      DataRow(
                                        cells: <DataCell>[
                                          const DataCell(Text('Razlika')),
                                          DataCell(
                                              Text('${pow(2, e.kontraIgra)}x')),
                                          DataCell(Text(
                                            '${e.razlika}',
                                            style: TextStyle(
                                              color: e.razlika < 0
                                                  ? Colors.red
                                                  : Colors.green,
                                            ),
                                          )),
                                          const DataCell(Text("")),
                                          DataCell(
                                            Text(currentPredictions!
                                                .igraKontraDal.name),
                                          ),
                                        ],
                                      ),
                                    if (e.showTrula)
                                      DataRow(
                                        cells: <DataCell>[
                                          const DataCell(Text('Trula')),
                                          const DataCell(Text('1x')),
                                          DataCell(Text(
                                            '${e.trula}',
                                            style: TextStyle(
                                              color: e.trula < 0
                                                  ? Colors.red
                                                  : Colors.green,
                                            ),
                                          )),
                                          DataCell(Text(
                                              currentPredictions!.trula.name)),
                                          const DataCell(Text("")),
                                        ],
                                      ),
                                    if (e.showKralji)
                                      DataRow(
                                        cells: <DataCell>[
                                          const DataCell(Text('Kralji')),
                                          const DataCell(Text('1x')),
                                          DataCell(Text(
                                            '${e.kralji}',
                                            style: TextStyle(
                                              color: e.kralji < 0
                                                  ? Colors.red
                                                  : Colors.green,
                                            ),
                                          )),
                                          DataCell(Text(
                                              currentPredictions!.kralji.name)),
                                          const DataCell(Text("")),
                                        ],
                                      ),
                                    if (e.showKralj)
                                      DataRow(
                                        cells: <DataCell>[
                                          const DataCell(Text('Kralj ultimo')),
                                          DataCell(Text(
                                              '${pow(2, e.kontraKralj)}x')),
                                          DataCell(Text(
                                            '${e.kralj}',
                                            style: TextStyle(
                                              color: e.kralj < 0
                                                  ? Colors.red
                                                  : Colors.green,
                                            ),
                                          )),
                                          DataCell(Text(currentPredictions!
                                              .kraljUltimo.name)),
                                          DataCell(Text(currentPredictions!
                                              .kraljUltimoKontraDal.name)),
                                        ],
                                      ),
                                    if (e.showPagat)
                                      DataRow(
                                        cells: <DataCell>[
                                          const DataCell(Text('Pagat ultimo')),
                                          DataCell(Text(
                                              '${pow(2, e.kontraPagat)}x')),
                                          DataCell(Text(
                                            '${e.pagat}',
                                            style: TextStyle(
                                              color: e.pagat < 0
                                                  ? Colors.red
                                                  : Colors.green,
                                            ),
                                          )),
                                          DataCell(Text(currentPredictions!
                                              .pagatUltimo.name)),
                                          DataCell(Text(currentPredictions!
                                              .pagatUltimoKontraDal.name)),
                                        ],
                                      ),
                                    if (e.mondfang)
                                      DataRow(
                                        cells: <DataCell>[
                                          const DataCell(Text('Izguba monda')),
                                          DataCell(Text(
                                              '${pow(2, e.kontraMondfang)}x')),
                                          DataCell(Text(
                                            "${e.points}",
                                            style: TextStyle(
                                              color: e.points < 0
                                                  ? Colors.red
                                                  : Colors.green,
                                            ),
                                          )),
                                          DataCell(Text(currentPredictions!
                                              .mondfang.name)),
                                          DataCell(Text(currentPredictions!
                                              .mondfangKontraDal.name)),
                                        ],
                                      ),
                                    if (e.skisfang)
                                      const DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text('Škisfang')),
                                          DataCell(Text('/')),
                                          DataCell(Text(
                                            '-100',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          )),
                                          DataCell(Text("")),
                                          DataCell(Text("")),
                                        ],
                                      ),
                                    DataRow(
                                      cells: <DataCell>[
                                        const DataCell(Text('Skupaj')),
                                        const DataCell(Text('')),
                                        DataCell(
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                if (e.radelc)
                                                  TextSpan(
                                                    text:
                                                        '${e.points ~/ 2} * 2 = ',
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                TextSpan(
                                                  text: '${e.points}',
                                                  style: TextStyle(
                                                    color: e.points < 0
                                                        ? Colors.red
                                                        : Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const DataCell(Text("")),
                                        const DataCell(Text("")),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          ...users.map((user) => user.endGame
                              ? Text("${user.name} želi končati igro.")
                              : const SizedBox()),
                          if (!requestedGameEnd && !widget.bots)
                            ElevatedButton(
                              onPressed: ws.gameEndSend,
                              child: const Text(
                                "Zaključi igro",
                              ),
                            ),
                          const SizedBox(height: 30),

                          ElevatedButton(
                            onPressed: () {
                              razpriKarte = !razpriKarte;
                              setState(() {});
                            },
                            child: razpriKarte
                                ? const Text(
                                    "Skrij točkovanje po štihih",
                                  )
                                : const Text(
                                    "Prikaži točkovanje po štihih",
                                  ),
                          ),

                          // pobrane karte v štihu
                          if (razpriKarte)
                            const Text("Pobrane karte:",
                                style: TextStyle(fontSize: 30)),
                          if (razpriKarte)
                            Wrap(
                              children: [
                                ...results!.stih.asMap().entries.map(
                                      (e) => e.value.card.isNotEmpty
                                          ? Card(
                                              elevation: 6,
                                              child: Column(
                                                children: [
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    currentPredictions!
                                                                    .gamemode >=
                                                                0 &&
                                                            currentPredictions!
                                                                    .gamemode <=
                                                                5
                                                        ? (e.key == 0
                                                            ? "Založeno"
                                                            : e.key + 1 ==
                                                                    results!
                                                                        .stih
                                                                        .length
                                                                ? "Talon"
                                                                : "${e.key}. štih")
                                                        : (currentPredictions!
                                                                    .gamemode ==
                                                                -1
                                                            ? "${e.key + 1}. štih"
                                                            : (e.key + 1 ==
                                                                    results!
                                                                        .stih
                                                                        .length
                                                                ? "Talon"
                                                                : "${e.key + 1}. štih")),
                                                    style: TextStyle(
                                                      fontWeight: e.value
                                                              .pickedUpByPlaying
                                                          ? FontWeight.bold
                                                          : FontWeight.w300,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  SizedBox(
                                                    // neka bs konstanta, ki izvira iz nekaj vrstic bolj gor
                                                    // ali imam mentalne probleme? ja.
                                                    // ali me briga? ne.
                                                    // fuck bad code quality      (e) => SizedBox(
                                                    width: fullHeight /
                                                            8 *
                                                            0.573 *
                                                            (1 +
                                                                0.7 *
                                                                    (e.value.card
                                                                            .length -
                                                                        1)) +
                                                        e.value.card.length * 3,
                                                    height: fullHeight / 8,
                                                    child: Stack(
                                                      children: [
                                                        ...e.value.card
                                                            .asMap()
                                                            .entries
                                                            .map(
                                                              (entry) =>
                                                                  Positioned(
                                                                left: (fullHeight /
                                                                        8 *
                                                                        0.573 *
                                                                        0.7 *
                                                                        entry
                                                                            .key)
                                                                    .toDouble(),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius.circular(10 *
                                                                          (fullWidth /
                                                                              10000)),
                                                                  child: Stack(
                                                                    children: [
                                                                      Container(
                                                                        color: Colors
                                                                            .white,
                                                                        width: fullHeight /
                                                                            8 *
                                                                            0.57,
                                                                        height:
                                                                            fullHeight /
                                                                                8,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            fullHeight /
                                                                                8,
                                                                        child: Image
                                                                            .asset(
                                                                          "assets/tarok${entry.value.id}.webp",
                                                                          filterQuality:
                                                                              FilterQuality.medium,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    "Štih je vreden ${e.value.worth.round()} ${e.value.worth == 3 || e.value.worth == 4 ? 'točke' : e.value.worth == 2 ? 'točki' : e.value.worth == 1 ? 'točko' : 'točk'}.",
                                                  ),
                                                  if (e.value.pickedUpBy != "")
                                                    Text(
                                                      "Štih je pobral ${e.value.pickedUpBy}.",
                                                    ),
                                                  const SizedBox(height: 10),
                                                ],
                                              ),
                                            )
                                          : const SizedBox(),
                                    ),
                              ],
                            ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              results = null;
                              setState(() {});
                            },
                            child: const Text(
                              "Zapri vpogled v rezultate",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // KONEC IGRE
            if (gameDone)
              DraggableWidget(
                initialPosition: AnchoringPosition.center,
                child: Card(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Hvala za igro",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          DataTable(
                            dataRowMaxHeight: 40,
                            dataRowMinHeight: 40,
                            headingRowHeight: 40,
                            columns: const <DataColumn>[
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'Igralec',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'Rezultat',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'Rating',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                            ],
                            rows: users
                                .map(
                                  (user) => DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(user.name)),
                                      DataCell(Text(
                                        user.total.toString(),
                                        style: TextStyle(
                                          color: user.total < 0
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                      )),
                                      const DataCell(Text(
                                        "+0",
                                        style: TextStyle(
                                          color:
                                              0 < 0 ? Colors.red : Colors.green,
                                        ),
                                      )),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: !(started && !widget.bots)
          ? FloatingActionButton(
              onPressed: () {
                try {
                  ws.socket.close(1000, 'CLOSE_NORMAL');
                } catch (e) {}
                Navigator.pop(context);
              },
              tooltip: 'Zapusti igro',
              child: const Icon(Icons.close),
            )
          : const SizedBox(),
    );
  }
}
