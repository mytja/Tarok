import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tarok/constants.dart';
import 'package:tarok/messages.pb.dart' as Messages;
import 'package:web_socket_channel/status.dart';
import 'package:web_socket_client/web_socket_client.dart';

// na žalost web_socket_
// ne dela z flutter for web
// because javascript is dumb

class Game extends StatefulWidget {
  const Game({super.key, required this.gameId});

  final String gameId;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late WebSocket websocket;
  late String playerId;
  late String name;

  List<User> users = [];
  List<LocalCard> cards = [];
  List<CardWidget> stih = [];
  List<Widget> userWidgets = [];
  Map<int, User> userPosition = {};
  List<LocalGame> games = GAMES.map((o) => o.copyWith()).toList();

  bool turn = false;
  bool licitiranje = false;
  bool licitiram = false;
  bool started = false;
  int myPosition = 0;

  WebSocket websocketConnection(String gameId) {
    const timeout = Duration(seconds: 10);
    final uri = Uri.parse('ws://localhost:8080/ws/$gameId');
    debugPrint("requesting to $uri");
    final socket = WebSocket(
      uri,
    );
    return socket;
  }

  Future<void> login() async {
    final token = await storage.read(key: "token");
    final Uint8List message =
        Messages.Message(loginInfo: Messages.LoginInfo(token: token))
            .writeToBuffer();
    websocket.send(message);
  }

  void sendCard(LocalCard card) {
    if (!turn) return;
    final Uint8List message = Messages.Message(
            card: Messages.Card(id: card.asset, send: Messages.Send()))
        .writeToBuffer();
    websocket.send(message);
    turn = false;
    cards.remove(card);
  }

  void licitiranjeSend(LocalGame game) {
    if (!licitiram || !licitiranje) return;
    final Uint8List message =
        Messages.Message(licitiranje: Messages.Licitiranje(type: game.id))
            .writeToBuffer();
    websocket.send(message);
    licitiram = false;
  }

  @override
  void initState() {
    websocket = websocketConnection(widget.gameId);
    websocket.messages.listen(
      (data) async {
        final msg = Messages.Message.fromBuffer(data);
        debugPrint(msg.toString());
        if (msg.hasLoginRequest()) {
          await login();
          return;
        } else if (msg.hasLoginResponse()) {
          playerId = msg.playerId;
          name = msg.username;
          bool found = false;
          for (int i = 0; i < users.length; i++) {
            if (users[i].id == playerId) {
              found = true;
              break;
            }
          }
          if (!found) users.add(User(id: playerId, name: name));
        } else if (msg.hasConnection()) {
          final conn = msg.connection;
          if (conn.hasJoin()) {
            bool found = false;
            for (int i = 0; i < users.length; i++) {
              if (users[i].id == msg.playerId) {
                found = true;
                break;
              }
            }
            if (!found) users.add(User(id: msg.playerId, name: msg.username));
          } else {
            for (int i = 0; i < users.length; i++) {
              if (users[i].id != msg.playerId) continue;
              users.removeAt(i);
              break;
            }
          }
        } else if (msg.hasCard()) {
          final card = msg.card;
          if (card.hasReceive()) {
            for (int i = 0; i < CARDS.length; i++) {
              if (CARDS[i].asset != card.id) continue;
              cards.add(CARDS[i]);
              List<LocalCard> piki = [];
              List<LocalCard> kare = [];
              List<LocalCard> srci = [];
              List<LocalCard> krizi = [];
              List<LocalCard> taroki = [];
              for (int i = 0; i < cards.length; i++) {
                final card = cards[i];
                if (card.asset.contains("taroki")) taroki.add(card);
                if (card.asset.contains("kriz")) krizi.add(card);
                if (card.asset.contains("src")) srci.add(card);
                if (card.asset.contains("kara")) kare.add(card);
                if (card.asset.contains("pik")) piki.add(card);
              }
              piki.sort((a, b) => a.worthOver.compareTo(b.worthOver));
              kare.sort((a, b) => a.worthOver.compareTo(b.worthOver));
              srci.sort((a, b) => a.worthOver.compareTo(b.worthOver));
              krizi.sort((a, b) => a.worthOver.compareTo(b.worthOver));
              taroki.sort((a, b) => a.worthOver.compareTo(b.worthOver));
              cards = [...piki, ...kare, ...srci, ...krizi, ...taroki];
              break;
            }
          } else if (card.hasSend()) {
            // this packet takes care of a deck (štih)
            // once a card is added to a štih, this message is sent
            started = true;
            print("send received");
            List<User> after = [];
            List<User> before = [];
            for (int i = myPosition + 1; i < users.length; i++) {
              after.add(users[i]);
            }
            for (int i = 0; i < myPosition; i++) {
              before.add(users[i]);
            }
            List<User> allUsers = [...after, ...before, users[myPosition]];
            print(allUsers);
            for (int i = 0; i < allUsers.length; i++) {
              final user = allUsers[i];
              if (user.id != msg.playerId) continue;
              print("Position $i");
              stih.add(CardWidget(
                position: user.id == playerId ? 3 : i,
                widget: Image.asset("assets/tarok${card.id}.webp"),
              ));
              break;
            }
            print(stih.length);
            print(stih);
          } else if (card.hasRequest()) {
            // this packet is sent when it's user's time to send a card
            turn = true;
            licitiram = false;
            licitiranje = false;
            // preventivno, če se uporabnik slučajno disconnecta-reconnecta
            started = true;
          }
        } else if (msg.hasGameStart() || msg.hasUserList()) {
          if (msg.hasGameStart()) {
            licitiranje = true;
            licitiram = false;
          }

          for (int i = 0; i < users.length; i++) {
            users[i].licitiral = -2;
          }
          for (int i = 0; i < CARDS.length; i++) {
            CARDS[i].showZoom = false;
          }
          for (int i = 0; i < cards.length; i++) {
            cards[i].showZoom = false;
          }

          turn = false;
          started = true;

          stih = [];

          final gameStart;
          if (msg.hasGameStart()) {
            gameStart = msg.gameStart;
          } else {
            gameStart = msg.userList;
          }
          final newUsers = gameStart.user;
          for (int i = 0; i < newUsers.length; i++) {
            final newUser = newUsers[i];
            if (newUser.id == playerId) myPosition = newUser.position;
            userPosition[newUser.position] =
                User(id: newUser.id, name: newUser.name);
          }

          if (userPosition.isEmpty) return;

          // uredimo vrstni red naših igralcev
          final firstUser = userPosition[0]!;
          for (int i = 0; i < users.length; i++) {
            if (users[0].id == firstUser.id) break;
            User removed = users.removeAt(0);
            users.add(removed);
          }

          // magija, da dobimo pravilno lokalno zaporedje
          int i = myPosition + 1;
          if (i >= userPosition.length) i = 0;
          int k = 0;
          userWidgets = [];
          print(myPosition);
          print(k);
          print(i);
          while (i < userPosition.length) {
            User user = userPosition[i]!;
            userWidgets.add(
              Text(user.name, style: const TextStyle(fontSize: 20)),
            );
            i++;
            k++;
            if (i >= userPosition.length) i = 0;
            if (i == myPosition) break;
          }
        } else if (msg.hasLicitiranje()) {
          final player = msg.playerId;
          final licitiranje = msg.licitiranje;
          for (int i = 0; i < users.length; i++) {
            if (users[i].id != player) continue;
            users[i].licitiral = licitiranje.type;
            if (licitiranje.type == -1) break;
            for (int n = 1; n < games.length; i++) {
              if (games[1].id > licitiranje.type) break;
              games.removeAt(1);
            }
            break;
          }
        } else if (msg.hasLicitiranjeStart()) {
          // this packet is sent when it's user's time to licitate
          licitiram = true;
        } else if (msg.hasClearDesk()) {
          stih = [];
        } else if (msg.hasResults()) {
          final results = msg.results;
          for (int i = 0; i < results.user.length; i++) {
            final user = results.user[i];
            for (int n = 0; n < users.length; n++) {
              if (users[n].id == user.user.id) {
                users[n].points.add(user.points);
                break;
              }
            }
          }
        }
        setState(() {});
      },
      onDone: () {
        debugPrint('ws channel closed');
      },
      onError: (error) => print(error),
    );

    super.initState();
  }

  @override
  void dispose() {
    websocket.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardSize = max(
      MediaQuery.of(context).size.width / cards.length,
      MediaQuery.of(context).size.width * 0.15,
    );
    final cardWidth = cardSize * 0.55;
    const duration = Duration(milliseconds: 200);
    final m = min(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    const cardK = 0.4;
    final topFromLeft = MediaQuery.of(context).size.width * 0.35;
    final leftFromTop = MediaQuery.of(context).size.height * 0.3;

    return Scaffold(
      body: Stack(
        children: [
          // REZULTATI
          Container(
            alignment: Alignment.topRight,
            child: Card(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width / 4,
                child: Column(
                  children: [
                    const Center(
                      child: Text(
                        "Rezultati",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: [
                        ...users.map((User user) => Expanded(
                              child: Center(
                                child: Text(
                                  user.name,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                    if (users.isNotEmpty)
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 24),
                          child: ListView.builder(
                            itemCount: users[0].points.length,
                            itemBuilder: (BuildContext context, int index) =>
                                Row(
                              children: [
                                ...users.map((e) => Expanded(
                                      child: Center(
                                        child: Text(
                                          e.points[index].toString(),
                                          style: TextStyle(
                                            color: e.points[index] < 0
                                                ? Colors.red
                                                : (e.points[index] == 0
                                                    ? Colors.grey
                                                    : Colors.green),
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
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
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // IMENA
          if (userWidgets.isNotEmpty)
            Positioned(
              top: leftFromTop + (m * cardK * 0.5),
              left: 10,
              height: m * cardK,
              child: userWidgets[0],
            ),
          if (userWidgets.length >= 2)
            Positioned(
              top: 10,
              left: topFromLeft + (m * cardK * 0.25),
              height: m * cardK,
              child: userWidgets[1],
            ),
          if (userWidgets.length >= 3)
            Positioned(
              top: leftFromTop + (m * cardK * 0.5),
              left: topFromLeft + (m * cardK * 1.6),
              height: m * cardK,
              child: userWidgets[2],
            ),

          // ŠTIHI
          ...stih.map((e) {
            if (e.position == 0) {
              return Positioned(
                top: leftFromTop,
                left: topFromLeft - (m * cardK * 0.5),
                height: m * cardK,
                child: Transform.rotate(angle: pi / 2, child: e.widget),
              );
            } else if (e.position == 1) {
              return Positioned(
                top: leftFromTop - (m * cardK * 0.5),
                left: topFromLeft,
                height: m * cardK,
                child: e.widget,
              );
            } else if (e.position == 2) {
              return Positioned(
                top: leftFromTop,
                left: topFromLeft + (m * cardK * 0.5),
                height: m * cardK,
                child: Transform.rotate(angle: pi / 2, child: e.widget),
              );
            }
            return Positioned(
              top: leftFromTop + (m * cardK * 0.5),
              left: topFromLeft,
              height: m * cardK,
              child: e.widget,
            );
          }),

          // MOJE KARTE
          ...cards.asMap().entries.map(
                (entry) => Container(
                  height: cardSize,
                  transform: Matrix4.translationValues(
                      entry.key *
                          min(
                            MediaQuery.of(context).size.width / cards.length,
                            MediaQuery.of(context).size.height * 0.15,
                          ),
                      (MediaQuery.of(context).size.height - cardSize / 1.75),
                      0),
                  child: GestureDetector(
                    onTap: () => sendCard(entry.value),
                    child: MouseRegion(
                      onEnter: (event) {
                        setState(() {
                          cards[entry.key].showZoom = true;
                        });
                      },
                      onExit: (event) {
                        setState(() {
                          cards[entry.key].showZoom = false;
                        });
                      },
                      child: AnimatedScale(
                        duration: duration,
                        scale: cards[entry.key].showZoom == true ? 1.15 : 1,
                        child: Transform.rotate(
                          angle: pi / 32,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Stack(
                              children: [
                                Image.asset(
                                    "assets/tarok${entry.value.asset}.webp"),
                                Container(
                                  color: cards[entry.key].showZoom == false
                                      ? Colors.black.withAlpha(100)
                                      : Colors.transparent,
                                  height: cardSize,
                                  width: cardWidth,
                                ),
                                if (!turn)
                                  Container(
                                    color: Colors.red.withAlpha(100),
                                    height: cardSize,
                                    width: cardWidth,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

          // LICITIRANJE
          if (licitiranje)
            Container(
              alignment: Alignment.center,
              child: Card(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    children: [
                      const Center(
                        child: Text(
                          "Licitiranje",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          ...users.map((User user) => Expanded(
                                child: Center(
                                  child: Text(
                                    user.name,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          ...users.map((User user) => Expanded(
                                child: Center(
                                  child: Text(
                                    user.licitiral == -2
                                        ? ""
                                        : GAMES[user.licitiral + 1].name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                      if (licitiram)
                        Wrap(
                          children: [
                            ...games.map((e) => ElevatedButton(
                                  onPressed: () => licitiranjeSend(e),
                                  child: Text(
                                    e.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                )),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: !started
          ? FloatingActionButton(
              onPressed: () => Navigator.pop(context),
              tooltip: 'Zapusti igro',
              child: const Icon(Icons.close),
            )
          : const SizedBox(),
    );
  }
}
