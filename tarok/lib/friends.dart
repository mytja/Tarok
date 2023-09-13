import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:tarok/about.dart';
import 'package:tarok/constants.dart';
import 'package:tarok/main.dart';
import 'package:tarok/settings.dart';

class Friends extends StatefulWidget {
  const Friends({super.key});

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  List<dynamic> odhodne = [];
  List<dynamic> prihodne = [];
  List<dynamic> prijatelji = [];
  late TextEditingController _email;

  void dialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Dodaj prijatelja'),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                children: [
                  const Text('Elektronski naslov prijatelja'),
                  TextField(
                    controller: _email,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  await addFriend();
                },
                child: const Text('Dodaj'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> fetchFriends() async {
    /*
    data: FormData.fromMap(
        {
          "email": _email.text,
          "pass": _password.text,
          "name": _username.text,
          "regCode": _regCode.text
        },
      ),
      */
    final response = await dio.get(
      "$BACKEND_URL/friends/get",
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
    );
    if (response.statusCode != 200) return;
    final data = jsonDecode(response.data);
    print(data);
    prijatelji = data["CurrentFriends"];
    prihodne = data["Incoming"];
    odhodne = data["Outgoing"];
    setState(() {});
  }

  Future<void> addFriend() async {
    final response = await dio.post(
      "$BACKEND_URL/friends/add",
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
      data: FormData.fromMap(
        {
          "email": _email.text,
        },
      ),
    );
    if (response.statusCode != 200) return;
    await fetchFriends();
    setState(() {});
  }

  Future<void> friendRequest(String relationId, bool accept) async {
    final response = await dio.post(
      "$BACKEND_URL/friends/accept_decline",
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
      data: FormData.fromMap(
        {
          "relationship": relationId,
          "friendRequest": accept,
        },
      ),
    );
    if (response.statusCode != 200) return;
    await fetchFriends();
    setState(() {});
  }

  Future<void> removeRelation(String relationId) async {
    final response = await dio.post(
      "$BACKEND_URL/friends/remove",
      options: Options(
        headers: {"X-Login-Token": await storage.read(key: "token")},
      ),
      data: FormData.fromMap(
        {
          "relationship": relationId,
        },
      ),
    );
    if (response.statusCode != 200) return;
    await fetchFriends();
    setState(() {});
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchFriends();
    Timer.periodic(const Duration(seconds: 60), (e) {
      fetchFriends();
    });
    _email = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Text(
                'Palčka.si tarok program',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Domov'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Prijatelji'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Friends()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Palčka"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Settings(),
                ),
              );
            },
          ),
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
        child: ListView(
          children: <Widget>[
            const Center(
              child: Text(
                'Moji prijatelji',
                style: TextStyle(fontSize: 40),
              ),
            ),
            const Center(
              child: Text(
                'Prihodne prošnje za prijateljstvo',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ...prihodne.map(
              (e) => Row(
                children: [
                  const SizedBox(
                    width: 100,
                  ),
                  Text(e["User"]["Name"]),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () async {
                      await friendRequest(e["ID"], true);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.block),
                    onPressed: () async {
                      await friendRequest(e["ID"], false);
                    },
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                ],
              ),
            ),
            const Center(
              child: Text(
                'Odhodne prošnje za prijateljstvo',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ...odhodne.map(
              (e) => Row(
                children: [
                  const SizedBox(
                    width: 100,
                  ),
                  Text(e["User"]["Name"]),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () async {
                      await removeRelation(e["ID"]);
                    },
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                ],
              ),
            ),
            const Center(
              child: Text(
                'Prijatelji',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ...prijatelji.map(
              (e) => Row(
                children: [
                  const SizedBox(
                    width: 100,
                  ),
                  Text(e["User"]["Name"]),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () async {
                      await removeRelation(e["ID"]);
                    },
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: dialog,
        tooltip: 'Dodaj prijatelja',
        child: const Icon(Icons.add),
      ),
    );
  }
}
