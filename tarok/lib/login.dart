import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tarok/constants.dart';
import 'package:tarok/main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController _username;
  late TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _username = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(20.0),
        children: [
          const Text(
            "Prijava",
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 350,
            child: TextField(
              controller: _username,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Elektronski naslov',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 350,
            child: TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Geslo',
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              final response = await dio.post(
                "$BACKEND_URL/login",
                data: FormData.fromMap(
                  {"email": _username.text, "pass": _password.text},
                ),
              );
              if (response.statusCode != 200) return;
              final data = jsonDecode(response.data);
              storage.write(key: "token", value: data["token"]);
              // ignore: use_build_context_synchronously
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyApp(
                    renderLogin: false,
                  ),
                ),
              );
            },
            child: const Text("Prijava", style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyApp(
                        renderLogin: false,
                      ),
                    ),
                  );
                },
                child: const Text("Gostujoči dostop",
                    style: TextStyle(fontSize: 20)),
              ),
            ),
            if (kIsWeb)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  label: const Text(
                    "Windows",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  icon: const FaIcon(FontAwesomeIcons.windows),
                ),
              ),
            if (kIsWeb)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  label: const Text(
                    "Linux",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  icon: const FaIcon(FontAwesomeIcons.linux),
                ),
              ),
            if (kIsWeb)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  label: const Text(
                    "Android",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  icon: const FaIcon(FontAwesomeIcons.android),
                ),
              ),
          ]),
        ],
      ),
    );
  }
}
