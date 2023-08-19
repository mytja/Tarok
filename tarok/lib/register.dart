import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tarok/constants.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late TextEditingController _email;
  late TextEditingController _username;
  late TextEditingController _password;
  late TextEditingController _password2;
  late TextEditingController _regCode;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _username = TextEditingController();
    _password = TextEditingController();
    _password2 = TextEditingController();
    _regCode = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _username.dispose();
    _password.dispose();
    _password2.dispose();
    _regCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Palčka"),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20.0),
          children: [
            const Text(
              "Registracija",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 350,
              child: TextField(
                controller: _email,
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
                controller: _username,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Ime profila',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 350,
              child: TextField(
                controller: _password2,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Geslo',
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
                  labelText: 'Ponovite geslo',
                ),
              ),
            ),
            /*const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 350,
              child: TextField(
                controller: _regCode,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Registracijska koda',
                ),
              ),
            ),*/
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_password.text != _password2.text) {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Gesli se ne ujemata'),
                      content: const SizedBox(),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                  return;
                }
                final response = await dio.post(
                  "$BACKEND_URL/register",
                  data: FormData.fromMap(
                    {
                      "email": _email.text,
                      "pass": _password.text,
                      "name": _username.text,
                      "regCode": _regCode.text
                    },
                  ),
                );
                if (response.statusCode != 201) return;
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const Text("Registracija", style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Prijava", style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
