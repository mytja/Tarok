import 'package:flutter/material.dart';
import 'package:tarok/constants.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Palčka"),
        actions: [
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Tarok palcka.si", style: TextStyle(fontSize: 40)),
            Text("Copyright 2023 Mitja Ševerkar"),
            Text("Licencirano pod AGPLv3 licenco."),
            Text("Verzija $RELEASE"),
          ],
        ),
      ),
    );
  }
}
