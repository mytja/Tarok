import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tarok/constants.dart';
import 'package:tarok/game.dart';
import 'package:tarok/login.dart';
import 'package:tarok/messages.pb.dart';
import 'package:web_socket_client/web_socket_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final token = await storage.read(key: "token");
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
    Navigator.pop(context);
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Game(gameId: gameId),
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
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Dobrodošli v Palčka tarok programu.'),
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
