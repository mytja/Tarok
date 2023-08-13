import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockskis/stockskis.dart';
import 'package:tarok/constants.dart';

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
              if (!BARVIC && !BERAC)
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
              if (!PRIREDI_IGRO && !BERAC)
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
              if (!PRIREDI_IGRO && !BARVIC)
                SettingsTile.switchTile(
                  onToggle: (value) async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool("berac", value);
                    BERAC = prefs.getBool("berac") ?? false;
                    setState(() {});
                  },
                  initialValue: BERAC,
                  leading: const Icon(Icons.money_off),
                  title: const Text('Berač'),
                  description: const Text(
                    "Karte za berača.",
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
          SettingsSection(
            title: const Text('Modifikacije'),
            tiles: [
              const CustomSettingsTile(
                child: Text(
                  "Če želite izzive lahko prilagodite naslednje opcije.",
                ),
              ),
              SettingsTile.switchTile(
                onToggle: (value) async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool("stockskis_predlogi", value);
                  OMOGOCI_STOCKSKIS_PREDLOGE =
                      prefs.getBool("stockskis_predlogi") ?? true;
                  setState(() {});
                },
                initialValue: OMOGOCI_STOCKSKIS_PREDLOGE,
                leading: const Icon(Icons.smart_toy),
                title: const Text('StockŠkis predlogi'),
                description: const Text(
                  "StockŠkis vam predlaga igre pri licitiranju. Če to izklopite, ne boste več dobivali predlogov.",
                ),
              ),
              SettingsTile.switchTile(
                onToggle: (value) async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool("slepi_tarok", value);
                  SLEPI_TAROK = prefs.getBool("slepi_tarok") ?? false;
                  setState(() {});
                },
                initialValue: SLEPI_TAROK,
                leading: const Icon(Icons.blind),
                title: const Text('Slepi tarok'),
                description: const Text(
                  "Odigrajte igro ne da bi videli kaj je bilo v štihu. Deluje samo v igrah z boti.",
                ),
              ),
              SettingsTile.switchTile(
                onToggle: (value) async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool("avtopotrdi_zalozitev", value);
                  AVTOPOTRDI_ZALOZITEV =
                      prefs.getBool("avtopotrdi_zalozitev") ?? false;
                  setState(() {});
                },
                initialValue: AVTOPOTRDI_ZALOZITEV,
                leading: const Icon(Icons.precision_manufacturing),
                title: const Text('Avtopotrdi založitev'),
                description: const Text(
                  "Avtopotrdite založitev. To vklopite samo če res veste kaj delate in se ne morete zaklikati.",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
