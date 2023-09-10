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

class MyColorMapper implements ColorMapper {
  const MyColorMapper({
    required this.baseColor,
    this.accentColor,
  });

  static const _rawBaseColor = Color(0xFF293540);
  static const _rawAccentColor = Color(0xFFFFFFFF);

  final Color baseColor;
  final Color? accentColor;

  @override
  Color substitute(
      String? id, String elementName, String attributeName, Color color) {
    if (color == _rawBaseColor) return baseColor;

    final accentColor = this.accentColor;
    if (accentColor != null && color == _rawAccentColor) return accentColor;

    return color;
  }
}

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
          const Divider(),
          const SizedBox(
            height: 20,
          ),
          GridView.count(
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: (MediaQuery.of(context).size.width / 500).round(),
            childAspectRatio: 11,
            children: <Widget>[
              ElevatedButton(
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
              ElevatedButton.icon(
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
              ElevatedButton.icon(
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
              ElevatedButton.icon(
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
              ElevatedButton.icon(
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
              ElevatedButton.icon(
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
                  height: 30,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Google Play'),
                    content: const Text(
                      'Ko bo aplikacija izšla v polni obliki jo bom izdal tudi v Google Play trgovini.',
                    ),
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
              ElevatedButton.icon(
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
            ],
          ),
        ],
      ),
    );
  }
}
