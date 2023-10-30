import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarok/login/login_controller.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.put(LoginController());

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
                controller: controller.email.value,
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
                controller: controller.name.value,
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
                controller: controller.password1.value,
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
                controller: controller.password2.value,
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
              onPressed: controller.register,
              child: const Text("Registracija", style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Get.toNamed("/login");
              },
              child: const Text("Prijava", style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
