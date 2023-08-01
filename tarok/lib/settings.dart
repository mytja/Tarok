import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockskis/stockskis.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Nastavitve"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Razvijalske opcije'),
            tiles: [
              const CustomSettingsTile(
                child: Text(
                  "Te opcije so namenjene predvsem razvijalcem programa Palčka.si. Mogoče so komu v izziv ali pa malo tako za zabavo, "
                  "tako da jih puščam tukaj na voljo vsem :)."
                  "Te opcije delujejo samo na lokalnih igrah z boti. Nekatere nastavitve so nekompatibilne med sabo.",
                ),
              ),
              if (!BARVIC)
                SettingsTile.switchTile(
                  onToggle: (value) async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool("priredi_igro", value);
                    PRIREDI_IGRO = prefs.getBool("priredi_igro") ?? false;
                    setState(() {});
                  },
                  initialValue: PRIREDI_IGRO,
                  leading: const Text(
                    "🤫",
                    style: TextStyle(fontSize: 30),
                  ),
                  title: const Text('Priredi igro'),
                  description: const Text(
                    "V roke dobite kar dosti visokih tarokov. Odlična stvar za valata ;).",
                  ),
                ),
              SettingsTile.switchTile(
                onToggle: (value) async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool("garantiran_zaruf", value);
                  GARANTIRAN_ZARUF = prefs.getBool("garantiran_zaruf") ?? false;
                  setState(() {});
                },
                initialValue: GARANTIRAN_ZARUF,
                leading: const Icon(Icons.casino),
                title: const Text('Garantiran zaruf'),
                description: const Text(
                  "Le kako so se vsi kralji pojavili v talonu. Čudno naključje.",
                ),
              ),
              SettingsTile.switchTile(
                onToggle: (value) async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool("odprte_igre", value);
                  ODPRTE_IGRE = prefs.getBool("odprte_igre") ?? false;
                  setState(() {});
                },
                initialValue: ODPRTE_IGRE,
                leading: const Icon(Icons.visibility),
                title: const Text('Odprte igre'),
                description: const Text(
                  "Mogoče sem čisto malo pokukal v karte drugih, nič takega ...",
                ),
              ),
              if (!PRIREDI_IGRO)
                SettingsTile.switchTile(
                  onToggle: (value) async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool("barvic", value);
                    BARVIC = prefs.getBool("barvic") ?? false;
                    setState(() {});
                  },
                  initialValue: BARVIC,
                  leading: const Icon(Icons.palette),
                  title: const Text('Barvni valat'),
                  description: const Text(
                    "Barvič, samo da drobceno prirejen.",
                  ),
                ),
              SettingsTile.switchTile(
                onToggle: (value) async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool("autostart_game", value);
                  AUTOSTART_GAME = prefs.getBool("autostart_game") ?? true;
                  setState(() {});
                },
                initialValue: AUTOSTART_GAME,
                leading: const Icon(Icons.pan_tool),
                title: const Text('Avtomatično začni naslednjo igro'),
                description: const Text(
                  "Če je opcija ugasnjena, se bomo lahko šli samo eno igro ...",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
