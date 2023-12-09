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

import 'package:dart_discord_rpc/dart_discord_rpc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:media_kit/media_kit.dart';
import 'package:stockskis/stockskis.dart';
import 'package:tarok/lobby/lobby_controller.dart';

part 'constants.g.dart';

DiscordRPC rpc = DiscordRPC(
  applicationId: '1175161862086721616',
);

const BACKEND_URL =
    kReleaseMode ? "https://palcka.si/api" : "http://localhost:8080";
const WS_URL =
    kReleaseMode ? "wss://palcka.si/api/ws" : "ws://localhost:8080/ws";
const LOBBY_WS_URL =
    kReleaseMode ? "wss://palcka.si/api/lobby" : "ws://localhost:8080/lobby";
const RELEASE = "0.0.7";
bool OMOGOCI_STOCKSKIS_PREDLOGE = true;
bool SLEPI_TAROK = false;
bool AVTOPOTRDI_ZALOZITEV = false;
bool AVTOLP = false;
bool PREMOVE = false;
bool DEVELOPER_MODE = false;
bool SKISFANG = false;
bool DISCORD_RPC = true;
String THEME = "";
Locale LOCALE = Get.deviceLocale ?? const Locale("sl", "SI");

const double ANGLE = 25;
const int ANIMATION_TIME = 75;

var logger = Logger();

final Player player = Player();

//const BACKEND_URL = "http://localhost:8080";
//const WS_URL = "http://localhost:8080/ws";

final dio = Dio();
const storage = FlutterSecureStorage();

class CardWidget {
  const CardWidget(
      {required this.position, required this.widget, required this.angle});

  final int position;
  final Widget widget;
  final double angle;
}

const GAME_DESC = [
  "KL",
  "3",
  "2",
  "1",
  "S3",
  "S2",
  "S1",
  "B",
  "SB",
  "OB",
  "BV",
  "V",
];

final List<LocalCard> KINGS = [
  LocalCard(asset: "/pik/kralj", worth: 5, worthOver: 8, alt: "Pik kralj"),
  LocalCard(asset: "/kara/kralj", worth: 5, worthOver: 8, alt: "Kara kralj"),
  LocalCard(asset: "/src/kralj", worth: 5, worthOver: 8, alt: "Src kralj"),
  LocalCard(asset: "/kriz/kralj", worth: 5, worthOver: 8, alt: "Križ kralj"),
];

List<String> KONTRE = [
  "no_kontra".tr,
  "kontra".tr,
  "rekontra".tr,
  "subkontra".tr,
  "mortkontra".tr,
];

const List<String> BOT_NAMES = [
  "Janez",
  "Jože",
  "Joško",
  //"Marko",
  "Marija",
  "Franc",
  //"Ana",
  //"Ivan",
  "Anton",
  //"Maja",
  "Mojca",
  "Gal",
  "Tim",
  "Nik",
  "Anže",
  "Aleksej",
  "Vid",
  "Mitja",
  "Mark",
  "Žiga",
];

List BOTS = [
  {
    "type": "normalni",
    "preferred_names": BOT_NAMES,
    "name": "normal_bots".tr,
  },
  {
    "type": "vrazji",
    "preferred_names": [
      "Tim",
      "Nik",
      "Gal",
      "Anže",
      "Janez",
      "Vid",
      "Aleksej",
      "Žiga",
      "Mark",
    ],
    "name": "advanced_bots".tr,
  },
  {
    "type": "berac",
    "preferred_names": [
      "Ana",
      "Maja",
      "Marko",
      "Lojze",
    ],
    "name": "beggar_bots".tr,
  },
  {
    "type": "klop",
    "preferred_names": [
      "Mitja",
      "Jože",
      "Marija",
      "Marko",
    ],
    "name": "klop_bots".tr,
  },
];

int hashCode(String str) {
  int hash = 0;
  for (var i = 0; i < str.length; i++) {
    hash = str[i].hashCode + ((hash << 5) - hash);
  }
  return hash;
}

Future<void> logout() async {
  String? token = await storage.read(key: "token");
  if (!(token == "a" || token == "" || token == null)) {
    try {
      await dio.post(
        '$BACKEND_URL/logout',
        options: Options(
          headers: {"X-Login-Token": token},
          validateStatus: (s) {
            return true;
          },
        ),
      );
    } catch (e) {}
  }
  await storage.deleteAll();
  await Get.toNamed("/login");
  await Get.delete<LobbyController>();
}

void parseLocale(String? locale) {
  if (locale == null) return;
  List locales = locale.split("_");
  LOCALE = Locale(
    locales[0].toString().toLowerCase(),
    locales[1].toString().toUpperCase(),
  );
}
