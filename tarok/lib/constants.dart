import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:logger/logger.dart';
import 'package:stockskis/stockskis.dart';

part 'constants.g.dart';

const BACKEND_URL =
    kReleaseMode ? "https://palcka.si/api" : "http://localhost:8080";
const WS_URL =
    kReleaseMode ? "wss://palcka.si/api/ws" : "ws://localhost:8080/ws";
const RELEASE = "DEBUG";

var logger = Logger();

//const BACKEND_URL = "http://localhost:8080";
//const WS_URL = "http://localhost:8080/ws";

final dio = Dio();
const storage = FlutterSecureStorage();

class CardWidget {
  const CardWidget({required this.position, required this.widget});

  final int position;
  final Widget widget;
}

const GAME_DESC = [
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
  LocalCard(asset: "/kara/kralj", worth: 5, worthOver: 8, alt: "Kara kralj"),
  LocalCard(asset: "/kriz/kralj", worth: 5, worthOver: 8, alt: "Križ kralj"),
  LocalCard(asset: "/pik/kralj", worth: 5, worthOver: 8, alt: "Pik kralj"),
  LocalCard(asset: "/src/kralj", worth: 5, worthOver: 8, alt: "Src kralj"),
];

const List<String> KONTRE = [
  "Ni kontre",
  "Kontra",
  "Rekontra",
  "Subkontra",
  "Mortkontra",
];

const List<String> BOT_NAMES = [
  "Janez",
  "Jože",
  //"Joško",
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
];

const BOTS = [
  {
    "type": "normalni",
    "preferred_names": BOT_NAMES,
    "name": "Normalni boti",
  },
  {
    "type": "vrazji",
    "preferred_names": [
      "Tim",
      "Nik",
      "Gal",
      "Anže",
      "Mitja",
      "Vid",
      "Aleksej",
      "Janez",
    ],
    "name": "Vražji boti",
  },
  {
    "type": "berac",
    "preferred_names": [
      "Tim",
      "Nik",
      "Gal",
    ],
    "name": "Berač boti",
  },
  {
    "type": "klop",
    "preferred_names": [
      "Mitja",
      "Jože",
      "Marija",
    ],
    "name": "Klop boti",
  },
];

int hashCode(String str) {
  int hash = 0;
  for (var i = 0; i < str.length; i++) {
    hash = str[i].hashCode + ((hash << 5) - hash);
  }
  return hash;
}
