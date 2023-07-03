import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:tarok/about.dart';
import 'package:tarok/constants.dart';
import 'package:tarok/game.dart';
import 'package:tarok/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Phoenix(
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MaterialApp(
      title: 'Tarok palcka.si',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isAdmin = false;
  List codes = [];
  List bots = [];
  late TextEditingController _controller;
  late TextEditingController _playerNameController;
  bool renderLogin = false;
  bool guest = false;

  void dialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Izberite igro'),
        content: const Text('Izberite število igralcev v igri'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              if (guest) {
                botGame(3);
                return;
              }
              await quickGameFind(3);
            },
            child: const Text('V tri'),
          ),
          TextButton(
            onPressed: () async {
              if (guest) {
                botGame(4);
                return;
              }
              await quickGameFind(4);
            },
            child: const Text('V štiri'),
          ),
        ],
      ),
    );
  }

  Future<void> quickGameFind(int players) async {
    final token = await storage.read(key: "token");
    if (token == null) return;
    final response = await dio.post(
      '$BACKEND_URL/quick',
      data: FormData.fromMap({"players": players}),
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    final gameId = response.data.toString();
    // ignore: use_build_context_synchronously
    //Navigator.pop(context);
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Game(gameId: gameId, bots: false, playing: players),
      ),
    );
  }

  void botGame(int players) {
    //Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Game(gameId: "", bots: true, playing: players),
      ),
    );
  }

  void rerenderLogin() {
    storage.read(key: "token").then((value) {
      renderLogin = value == null;
      guest = value == "a";
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    storage.read(key: "role").then((value) {
      debugPrint(value);
      isAdmin = value == "admin";
      if (!isAdmin) return;
      setState(() {});
    });
    _controller = TextEditingController();
    _playerNameController = TextEditingController();
    rerenderLogin();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _playerNameController.dispose();
  }

  Future<List> getRegistrationCodes() async {
    final response = await dio.get(
      "$BACKEND_URL/admin/reg_code",
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    if (response.statusCode != 200) return codes;
    debugPrint(response.data);
    try {
      codes = jsonDecode(response.data);
    } catch (e) {
      codes = [];
    }
    return codes;
  }

  Future getBots() async {
    String? response = await storage.read(key: "bots");
    if (response == null) {
      await storage.write(key: "bots", value: "[]");
      response = "[]";
    }
    bots = jsonDecode(response);
  }

  Future<void> newBot(String name, String type) async {
    bots.add({"name": name, "type": type});
    await storage.write(key: "bots", value: jsonEncode(bots));
    await getBots();
  }

  String randomBotName() {
    for (int i = 0; i < BOTS.length; i++) {
      Map bot = BOTS[i];
      if (bot["type"] != dropdownValue["type"]) continue;
      int preferred = Random().nextInt(bot["preferred_names"].length);
      return bot["preferred_names"][preferred];
    }
    int preferred = Random().nextInt(BOT_NAMES.length);
    return BOT_NAMES[preferred];
  }

  Future<void> deleteBot(String name, String type) async {
    for (int i = 0; i < bots.length; i++) {
      Map bot = bots[i];
      if (bot["type"] != type || bot["name"] != name) continue;
      debugPrint("Here I am");
      bots.removeAt(i);
      await storage.write(key: "bots", value: jsonEncode(bots));
      return;
    }
  }

  Map dropdownValue = BOTS.first;

  @override
  Widget build(BuildContext context) {
    if (renderLogin) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Palčka"),
        ),
        body: const Login(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Palčka"),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const About(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await storage.deleteAll();
              // ignore: use_build_context_synchronously
              Phoenix.rebirth(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text('Dobrodošli v Palčka tarok programu.',
                style: TextStyle(fontSize: 40)),
            if (guest)
              const Text("Uporabljate gostujoči dostop",
                  style: TextStyle(fontSize: 20)),
            const Text("Igre na voljo", style: TextStyle(fontSize: 30)),
            if (!guest)
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("S pravimi igralci"),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton.icon(
                  onPressed: () => quickGameFind(3),
                  label: const Text(
                    "V tri",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  icon: const Icon(Icons.face),
                ),
                ElevatedButton.icon(
                  onPressed: () => quickGameFind(4),
                  label: const Text(
                    "V štiri",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  icon: const Icon(Icons.face),
                ),
              ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("Z računalniškimi igralci"),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton.icon(
                onPressed: () => botGame(3),
                label: const Text(
                  "V tri",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                icon: const Icon(Icons.smart_toy),
              ),
              ElevatedButton.icon(
                onPressed: () => botGame(4),
                label: const Text(
                  "V štiri",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                icon: const Icon(Icons.smart_toy),
              ),
            ]),
            const SizedBox(
              height: 10,
            ),
            if (isAdmin)
              ElevatedButton(
                onPressed: () => showDialog<String>(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return AlertDialog(
                          title: const Text('Administratorska plošča'),
                          content: SingleChildScrollView(
                            child: Column(children: [
                              const Text(
                                'Na tej plošči lahko kot administrator urejate razne nastavitve tarok programa Palčka',
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              FutureBuilder(
                                future: getRegistrationCodes(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    return DataTable(
                                      columns: const <DataColumn>[
                                        DataColumn(
                                          label: Expanded(
                                            child: Text(
                                              'Registracijska koda',
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Text(
                                              'Izbriši',
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: [
                                        ...codes.map(
                                          (code) => DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text(code["Code"])),
                                              DataCell(
                                                IconButton(
                                                  icon:
                                                      const Icon(Icons.delete),
                                                  onPressed: () async {
                                                    await dio.delete(
                                                      "$BACKEND_URL/admin/reg_code",
                                                      data: FormData.fromMap(
                                                        {
                                                          "code": code["Code"],
                                                        },
                                                      ),
                                                      options: Options(
                                                        headers: {
                                                          "X-Login-Token":
                                                              await storage.read(
                                                                  key: "token")
                                                        },
                                                      ),
                                                    );
                                                    getRegistrationCodes();
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                              Row(children: [
                                Expanded(
                                  child: TextField(
                                    controller: _controller,
                                    decoration: const InputDecoration(
                                      border: UnderlineInputBorder(),
                                      labelText: 'Nova registracijska koda',
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.save),
                                  onPressed: () async {
                                    await dio.post(
                                      "$BACKEND_URL/admin/reg_code",
                                      data: FormData.fromMap(
                                        {
                                          "code": _controller.text,
                                        },
                                      ),
                                      options: Options(
                                        headers: {
                                          "X-Login-Token":
                                              await storage.read(key: "token")
                                        },
                                      ),
                                    );
                                    getRegistrationCodes();
                                    setState(() {});
                                  },
                                ),
                              ]),
                            ]),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      });
                    }),
                child: const Text("Administratorska plošča"),
              ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () => showDialog<String>(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return AlertDialog(
                        title: const Text('Prilagodi računalniške igralce'),
                        content: SingleChildScrollView(
                          child: Column(children: [
                            const Text(
                              'Tukaj lahko urejate, kakšne bote želite videti v svojih igrah. Program bo ob vstopu v igro avtomatično izbral naključne igralce iz tega seznama, če jih je vsaj toliko, kot zahteva ta igra.',
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            FutureBuilder(
                              future: getBots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (bots.isNotEmpty) {
                                  return DataTable(
                                    columns: const <DataColumn>[
                                      DataColumn(
                                        label: Expanded(
                                          child: Text(
                                            'Bot',
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Text(
                                            'Ime',
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Text(
                                            'Izbriši',
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: [
                                      ...bots.map(
                                        (e) => DataRow(
                                          cells: <DataCell>[
                                            DataCell(Text(e["type"])),
                                            DataCell(Text(e["name"])),
                                            DataCell(
                                              IconButton(
                                                icon: const Icon(Icons.delete),
                                                onPressed: () async {
                                                  await deleteBot(
                                                    e["name"],
                                                    e["type"],
                                                  );
                                                  await getBots();
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                            Row(children: [
                              Expanded(
                                child: TextField(
                                  controller: _playerNameController,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Ime igralca',
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.replay_outlined),
                                onPressed: () async {
                                  String botName = randomBotName();
                                  _playerNameController.text = botName;
                                  setState(() {});
                                },
                              ),
                            ]),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: SegmentedButton<Map>(
                                segments: <ButtonSegment<Map>>[
                                  ...BOTS.map(
                                    (e) => ButtonSegment<Map>(
                                      value: e,
                                      label: Text(e["name"].toString()),
                                    ),
                                  )
                                ],
                                selected: <Map>{dropdownValue},
                                onSelectionChanged: (Set<Map> newSelection) {
                                  setState(() {
                                    dropdownValue = newSelection.first;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton.icon(
                              onPressed: () async {
                                await newBot(
                                  _playerNameController.text,
                                  dropdownValue["type"],
                                );
                                setState(() {});
                              },
                              label: const Text(
                                "Dodaj bota na seznam",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              icon: const Icon(Icons.add),
                            ),
                          ]),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Končaj z urejanjem'),
                          ),
                        ],
                      );
                    });
                  }),
              child: const Text("Prilagodi računalniške igralce"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: dialog,
        tooltip: 'Poišči igro',
        child: const Icon(Icons.search),
      ),
    );
  }
}
