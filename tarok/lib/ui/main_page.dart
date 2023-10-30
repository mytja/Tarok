import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarok/constants.dart';

class PalckaHome extends StatelessWidget {
  const PalckaHome({
    super.key,
    required this.child,
    this.floatingActionButton,
  });

  final Widget child;
  final Widget? floatingActionButton;

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
                Get.toNamed("/");
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Prijatelji'),
              onTap: () {
                Get.toNamed("/friends");
              },
            ),
            ListTile(
              leading: const Icon(Icons.replay),
              title: const Text('Posnetki iger'),
              onTap: () {
                Get.toNamed("/replays");
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
              Get.toNamed("/settings");
            },
          ),
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () async {
              Get.toNamed("/about");
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await storage.deleteAll();
              Get.toNamed("/login");
            },
          ),
        ],
      ),
      body: Center(child: child),
      floatingActionButton: floatingActionButton,
    );
  }
}
