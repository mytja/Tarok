import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:get/get.dart' hide FormData;
import 'package:media_kit/media_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockskis/stockskis.dart' hide debugPrint, Card;
import 'package:tarok/about.dart';
import 'package:tarok/constants.dart';
import 'package:tarok/friends.dart';
import 'package:tarok/game.dart';
import 'package:tarok/lobby.dart';
import 'package:tarok/login.dart';
import 'package:tarok/register.dart';
import 'package:tarok/replay.dart';
import 'package:tarok/settings.dart';
import 'package:tarok/sounds.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();

  //binding.addPostFrameCallback((_) async {
  //  BuildContext? context = binding.rootElement;
  //  if (context != null) {
  //    await preloadCards(context);
  //  }
  //});
  MediaKit.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  PRIREDI_IGRO = prefs.getBool("priredi_igro") ?? false;
  GARANTIRAN_ZARUF = prefs.getBool("garantiran_zaruf") ?? false;
  ODPRTE_IGRE = prefs.getBool("odprte_igre") ?? false;
  AUTOSTART_GAME = prefs.getBool("autostart_game") ?? true;
  BARVIC = prefs.getBool("barvic") ?? false;
  OMOGOCI_STOCKSKIS_PREDLOGE = prefs.getBool("stockskis_predlogi") ?? true;
  SLEPI_TAROK = prefs.getBool("slepi_tarok") ?? false;
  BERAC = prefs.getBool("berac") ?? false;
  AVTOPOTRDI_ZALOZITEV = prefs.getBool("avtopotrdi_zalozitev") ?? false;
  AVTOLP = prefs.getBool("avtolp") ?? false;
  PREMOVE = prefs.getBool("premove") ?? false;
  MOND_V_TALONU = prefs.getBool("mond_v_talonu") ?? false;
  SKISFANG = prefs.getBool("skisfang") ?? false;
  SKIS_V_TALONU = prefs.getBool("skis_v_talonu") ?? false;
  NAPOVEDAN_MONDFANG = prefs.getBool("napovedan_mondfang") ?? false;
  THEME = prefs.getString("theme") ?? "dark";
  SOUNDS_ENABLED = prefs.getBool("sounds") ?? true;
  DEVELOPER_MODE = prefs.getBool("developer_mode") ?? false;

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(
    GetMaterialApp(
      title: 'Tarok palcka.si',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const Lobby()),
        GetPage(name: '/game', page: () => const Game()),
        GetPage(name: '/settings', page: () => const Settings()),
        GetPage(name: '/login', page: () => const Login()),
        GetPage(name: '/registration', page: () => const Register()),
        GetPage(name: '/friends', page: () => const Friends()),
        GetPage(name: '/about', page: () => const About()),
        GetPage(
          name: '/replay/:id',
          page: () => FutureBuilder(
            future: joinReplay(
                "https://palcka.si/replay/${Get.parameters['id']}?password=${Get.parameters['password']}"),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return const SizedBox();
            },
          ),
        ),
      ],
      darkTheme: ThemeData(
        primaryColor: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: THEME == "light" ? ThemeMode.light : ThemeMode.dark,
      builder: InAppNotifications.init(),
      home: const Lobby(),
    ),
  );
}
