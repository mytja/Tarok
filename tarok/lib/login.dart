import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tarok/constants.dart';
import 'package:tarok/main.dart';
import 'package:tarok/register.dart';
import 'package:url_launcher/url_launcher.dart';

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
              await storage.write(key: "token", value: data["token"]);
              await storage.write(key: "role", value: data["role"]);
              // ignore: use_build_context_synchronously
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyApp(),
                ),
              );
            },
            child: const Text("Prijava", style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Register(),
                ),
              );
            },
            child: const Text("Registracija", style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  await storage.write(key: "token", value: "a");
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyApp(),
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
                  onPressed: () async {
                    await launchUrl(Uri.parse(
                        "https://nightly.link/mytja/Tarok/workflows/build/main/windows_app.zip?h=8b6e64c52f49d4292ad7ec115786aa6c367c0f65"));
                  },
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
                  onPressed: () async {
                    await launchUrl(Uri.parse(
                        "https://nightly.link/mytja/Tarok/workflows/build/main/linux_app.zip?h=8b6e64c52f49d4292ad7ec115786aa6c367c0f65"));
                  },
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
                  onPressed: () async {
                    await launchUrl(Uri.parse(
                        "https://nightly.link/mytja/Tarok/workflows/build/main/android_app.zip?h=8b6e64c52f49d4292ad7ec115786aa6c367c0f65"));
                  },
                  label: const Text(
                    "Android (APK)",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  icon: const FaIcon(FontAwesomeIcons.android),
                ),
              ),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            if (kIsWeb)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('F-Droid'),
                      content: const Text(
                          'F-Droid je alternativna trgovina za Android naprave. Ta trgovina omogoča vsem odprtokodnim aplikacijam, da preko tega vira uporabnikom dostavljajo aplikacije in posodobitve zanje. Ker ta aplikacija še ni odprtokodna, še ni na voljo za prenos v tej trgovini. Seveda pa bo aplikacija popolnoma brezplačna za prenesti, kot tudi za igrati :).'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  ),
                  label: const Text(
                    "Android (F-Droid)",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  icon: SvgPicture.asset(
                    "assets/icons/fdroid-logo.svg",
                  ),
                ),
              ),
            if (kIsWeb)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Google Play'),
                      content: const Text(
                          'Z veseljem bi rad objavil to aplikacijo v Trgovini Play, ampak še (legalno gledano) ne morem :).'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  ),
                  label: const Text(
                    "Android (Google Play)",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  icon: const FaIcon(FontAwesomeIcons.googlePlay),
                ),
              ),
            if (kIsWeb)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Apple App Store'),
                      content: const Text(
                          'V Applovo trgovino najverjetneje nikoli ne bom objavil aplikacije zaradi tega, ker sam ne uporabljam (in nočem uporabljati) Apple naprav in zaradi Applovega zanemarjanja razvijalcev, ki morajo plačati 100 dolarjev na leto, da lahko objavijo svojo aplikacijo v Applovi trgovini. Še vedno boste pa lahko uporabljali spletno aplikacijo :).'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  ),
                  label: const Text(
                    "iOS, MacOS, iPadOS (Apple App Store)",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  icon: const FaIcon(FontAwesomeIcons.appStore),
                ),
              ),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  await launchUrl(Uri.parse("https://github.com/mytja/Tarok"));
                },
                label: const Text(
                  "Koda",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                icon: const FaIcon(FontAwesomeIcons.github),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
