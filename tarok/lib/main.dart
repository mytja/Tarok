// Tarok Palčka - a simple tarock program.
// Copyright (C) 2023 Mitja Ševerkar
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

import 'dart:io';

import 'package:dart_discord_rpc/dart_discord_rpc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:get/get.dart' hide FormData;
import 'package:media_kit/media_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockskis/stockskis.dart' hide debugPrint, Card;
import 'package:tarok/about.dart';
import 'package:tarok/admin/users.dart';
import 'package:tarok/constants.dart';
import 'package:tarok/game/game.dart';
import 'package:tarok/guide/guide.dart';
import 'package:tarok/internationalization/languages.dart';
import 'package:tarok/lobby/friends.dart';
import 'package:tarok/lobby/lobby.dart';
import 'package:tarok/lobby/replays.dart';
import 'package:tarok/login/login.dart';
import 'package:tarok/login/password_login_change.dart';
import 'package:tarok/login/password_reset_request.dart';
import 'package:tarok/login/register.dart';
import 'package:tarok/replay.dart';
import 'package:tarok/settings.dart';
import 'package:tarok/sounds.dart';
import 'package:tarok/tms/participants/participants.dart';
import 'package:tarok/tms/rounds/rounds.dart';
import 'package:tarok/tms/statistics/statistics.dart';
import 'package:tarok/tms/tournaments.dart';
import 'package:tarok/user/user.dart';
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
  DISCORD_RPC = prefs.getBool("discordRpc") ?? true;
  RED_FILTER = prefs.getBool("red_filter") ?? true;
  NEXT_ROUND_DELAY = prefs.getInt("next_round_delay") ?? 10;
  BOT_DELAY = prefs.getInt("bot_delay") ?? 500;
  CARD_CLEANUP_DELAY = prefs.getInt("card_cleanup_delay") ?? 1000;
  COUNTERCLOCKWISE_GAME = prefs.getBool("counterclockwise_game") ?? false;
  POINTS_TOOLTIP = prefs.getBool("points_tooltip") ?? false;

  if (kReleaseMode) {
    BACKEND_URL = prefs.getString("api_url") ?? "https://palcka.si/api";
    parseBackendUrls();
  }

  if (!kIsWeb && (Platform.isLinux || Platform.isWindows) && DISCORD_RPC) {
    DiscordRPC.initialize();
    rpc.start(autoRegister: true);
    rpc.updatePresence(
      DiscordPresence(
        details: 'Gleda na začetni zaslon',
        startTimeStamp: DateTime.now().millisecondsSinceEpoch,
        largeImageKey: 'palcka_logo',
        largeImageText: 'Tarok Palčka',
      ),
    );
  }

  String? locale = prefs.getString("locale");
  parseLocale(locale);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  if (THEME == "light") {
    Get.changeThemeMode(ThemeMode.light);
  } else {
    Get.changeThemeMode(ThemeMode.dark);
  }

  String initialRoute = "/";
  var value = await storage.read(key: "token");
  if (value == null) {
    initialRoute = "/login";
  }

  runApp(
    GetMaterialApp(
      title:
          "Tarok Palčka", // this doesn't seem to work with .tr; EDIT: yeah, I don't know why it would work. :sweat_smile:
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      translations: Messages(),
      locale: LOCALE,
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: initialRoute,
      getPages: [
        GetPage(name: '/', page: () => const Lobby()),
        GetPage(name: '/game', page: () => const Game()),
        GetPage(name: '/settings', page: () => const Settings()),
        GetPage(name: '/login', page: () => const Login()),
        GetPage(name: '/registration', page: () => const Register()),
        GetPage(name: '/friends', page: () => const Friends()),
        GetPage(name: '/about', page: () => const About()),
        GetPage(name: '/replays', page: () => const Replays()),
        GetPage(name: '/users', page: () => const Users()),
        GetPage(name: '/profile', page: () => const Profile()),
        GetPage(name: '/guide', page: () => const Guide()),
        GetPage(name: '/tournaments', page: () => const Tournaments()),
        GetPage(
          name: '/tournament/:tournamentId/participants',
          page: () => const TournamentParticipants(),
        ),
        GetPage(
          name: '/tournament/:tournamentId/rounds',
          page: () => const Rounds(),
        ),
        GetPage(
          name: '/tournament/:tournamentId/stats',
          page: () => const Statistics(),
        ),
        GetPage(
            name: '/account/reset', page: () => const PasswordResetRequest()),
        GetPage(
            name: '/password/reset', page: () => const PasswordLoginChange()),
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
        GetPage(
          name: '/email/confirm',
          page: () => FutureBuilder(
            future: confirmEmail(
              Get.parameters["email"]!,
              Get.parameters["regCode"]!,
            ),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data == true) {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 100,
                    ),
                    Text(
                      "account_confirmed".tr,
                      style: const TextStyle(fontSize: 35),
                    ),
                  ],
                ));
              }
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.cancel,
                    color: Colors.red,
                    size: 100,
                  ),
                  Text(
                    "account_not_confirmed".tr,
                    style: const TextStyle(fontSize: 30),
                  ),
                ],
              ));
            },
          ),
        ),
      ],
      darkTheme: ThemeData(
        primaryColor: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      builder: InAppNotifications.init(),
    ),
  );
}
