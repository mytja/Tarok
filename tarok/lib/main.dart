import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tarok/constants.dart';
import 'package:tarok/game.dart';
import 'package:tarok/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final token = await storage.read(key: "token");
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((e) => runApp(MyApp(
        renderLogin: token == null,
      )));
  runApp(MyApp(
    renderLogin: token == null,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.renderLogin});

  final bool renderLogin;

  @override
  Widget build(BuildContext context) {
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
      home: MyHomePage(renderLogin: renderLogin),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.renderLogin});

  final bool renderLogin;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void dialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Izberite igro'),
        content: const Text('Izberite število igralcev v igri'),
        actions: <Widget>[
          TextButton(
            onPressed: () async => await quickGameFind(3),
            child: const Text('V tri'),
          ),
          TextButton(
            onPressed: () async => await quickGameFind(4),
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
      data: FormData.fromMap({"token": token, "players": players}),
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

  @override
  Widget build(BuildContext context) {
    if (widget.renderLogin) {
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text('Dobrodošli v Palčka tarok programu.'),
            const Text("Igre na voljo", style: TextStyle(fontSize: 30)),
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
