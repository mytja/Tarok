import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'constants.g.dart';

const BACKEND_URL = "http://localhost:8080";
final dio = Dio();
final storage = new FlutterSecureStorage();

@CopyWith()
class LocalCard {
  LocalCard({
    required this.asset,
    required this.worth,
    required this.worthOver,
    required this.alt,
    this.showZoom = false,
    this.valid = false,
  });

  final String asset;
  final int worth;
  final int worthOver;
  final String alt;
  bool showZoom;
  bool valid;
}

@CopyWith()
class User {
  User({
    required this.id,
    required this.name,
    //this.points,
  });

  final String id;
  final String name;
  int licitiral = -2;
  List<int> points = [];
  int total = 0;
  bool endGame = false;
  //int rating;
}

@CopyWith()
class LocalGame {
  const LocalGame({
    required this.id,
    required this.name,
    required this.playsThree,
    required this.worth,
  });

  final int id;
  final String name;
  final bool playsThree;
  final int worth;
}

class CardWidget {
  const CardWidget({required this.position, required this.widget});

  final int position;
  final Widget widget;
}

final List<LocalCard> CARDS = [
  LocalCard(asset: "/kara/1", worth: 1, worthOver: 4, alt: "1 kara"),
  LocalCard(asset: "/kara/2", worth: 1, worthOver: 3, alt: "2 kara"),
  LocalCard(asset: "/kara/3", worth: 1, worthOver: 2, alt: "3 kara"),
  LocalCard(asset: "/kara/4", worth: 1, worthOver: 1, alt: "4 kara"),
  LocalCard(asset: "/kara/pob", worth: 2, worthOver: 5, alt: "Kara pob"),
  LocalCard(asset: "/kara/kaval", worth: 3, worthOver: 6, alt: "Kara kaval"),
  LocalCard(asset: "/kara/dama", worth: 4, worthOver: 7, alt: "Kara dama"),
  LocalCard(asset: "/kara/kralj", worth: 5, worthOver: 8, alt: "Kara kralj"),
  LocalCard(asset: "/kriz/7", worth: 1, worthOver: 1, alt: "7 križ"),
  LocalCard(asset: "/kriz/8", worth: 1, worthOver: 2, alt: "8 križ"),
  LocalCard(asset: "/kriz/9", worth: 1, worthOver: 3, alt: "9 križ"),
  LocalCard(asset: "/kriz/10", worth: 1, worthOver: 4, alt: "10 križ"),
  LocalCard(asset: "/kriz/pob", worth: 2, worthOver: 5, alt: "Križ pob"),
  LocalCard(asset: "/kriz/kaval", worth: 3, worthOver: 6, alt: "Križ kaval"),
  LocalCard(asset: "/kriz/dama", worth: 4, worthOver: 7, alt: "Križ dama"),
  LocalCard(asset: "/kriz/kralj", worth: 5, worthOver: 8, alt: "Križ kralj"),
  LocalCard(asset: "/pik/7", worth: 1, worthOver: 1, alt: "7 pik"),
  LocalCard(asset: "/pik/8", worth: 1, worthOver: 2, alt: "8 pik"),
  LocalCard(asset: "/pik/9", worth: 1, worthOver: 3, alt: "9 pik"),
  LocalCard(asset: "/pik/10", worth: 1, worthOver: 4, alt: "10 pik"),
  LocalCard(asset: "/pik/pob", worth: 2, worthOver: 5, alt: "Pik pob"),
  LocalCard(asset: "/pik/kaval", worth: 3, worthOver: 6, alt: "Pik kaval"),
  LocalCard(asset: "/pik/dama", worth: 4, worthOver: 7, alt: "Pik dama"),
  LocalCard(asset: "/pik/kralj", worth: 5, worthOver: 8, alt: "Pik kralj"),
  LocalCard(asset: "/src/1", worth: 1, worthOver: 4, alt: "1 src"),
  LocalCard(asset: "/src/2", worth: 1, worthOver: 3, alt: "2 src"),
  LocalCard(asset: "/src/3", worth: 1, worthOver: 2, alt: "3 src"),
  LocalCard(asset: "/src/4", worth: 1, worthOver: 1, alt: "4 src"),
  LocalCard(asset: "/src/pob", worth: 2, worthOver: 5, alt: "Src pob"),
  LocalCard(asset: "/src/kaval", worth: 3, worthOver: 6, alt: "Src kaval"),
  LocalCard(asset: "/src/dama", worth: 4, worthOver: 7, alt: "Src dama"),
  LocalCard(asset: "/src/kralj", worth: 5, worthOver: 8, alt: "Src kralj"),
  LocalCard(asset: "/taroki/pagat", worth: 5, worthOver: 11, alt: "Pagat"),
  LocalCard(asset: "/taroki/2", worth: 1, worthOver: 12, alt: "2"),
  LocalCard(asset: "/taroki/3", worth: 1, worthOver: 13, alt: "3"),
  LocalCard(asset: "/taroki/4", worth: 1, worthOver: 14, alt: "4"),
  LocalCard(asset: "/taroki/5", worth: 1, worthOver: 15, alt: "5"),
  LocalCard(asset: "/taroki/6", worth: 1, worthOver: 16, alt: "6"),
  LocalCard(asset: "/taroki/7", worth: 1, worthOver: 17, alt: "7"),
  LocalCard(asset: "/taroki/8", worth: 1, worthOver: 18, alt: "8"),
  LocalCard(asset: "/taroki/9", worth: 1, worthOver: 19, alt: "9"),
  LocalCard(asset: "/taroki/10", worth: 1, worthOver: 20, alt: "10"),
  LocalCard(asset: "/taroki/11", worth: 5, worthOver: 21, alt: "11"),
  LocalCard(asset: "/taroki/12", worth: 1, worthOver: 22, alt: "12"),
  LocalCard(asset: "/taroki/13", worth: 1, worthOver: 23, alt: "13"),
  LocalCard(asset: "/taroki/14", worth: 1, worthOver: 24, alt: "14"),
  LocalCard(asset: "/taroki/15", worth: 1, worthOver: 25, alt: "15"),
  LocalCard(asset: "/taroki/16", worth: 1, worthOver: 26, alt: "16"),
  LocalCard(asset: "/taroki/17", worth: 1, worthOver: 27, alt: "17"),
  LocalCard(asset: "/taroki/18", worth: 1, worthOver: 28, alt: "18"),
  LocalCard(asset: "/taroki/19", worth: 1, worthOver: 29, alt: "19"),
  LocalCard(asset: "/taroki/20", worth: 1, worthOver: 30, alt: "20"),
  LocalCard(asset: "/taroki/mond", worth: 5, worthOver: 31, alt: "Mond"),
  LocalCard(asset: "/taroki/skis", worth: 5, worthOver: 32, alt: "Škis"),
];

const List<LocalGame> GAMES = [
  LocalGame(id: -1, name: "Naprej", playsThree: true, worth: 0),
  LocalGame(id: 0, name: "Tri", playsThree: true, worth: 10),
  LocalGame(id: 1, name: "Dva", playsThree: true, worth: 20),
  LocalGame(id: 2, name: "Ena", playsThree: true, worth: 30),
  LocalGame(id: 3, name: "Solo tri", playsThree: false, worth: 40),
  LocalGame(id: 4, name: "Solo dva", playsThree: false, worth: 50),
  LocalGame(id: 5, name: "Solo ena", playsThree: false, worth: 60),
  LocalGame(id: 6, name: "Berač", playsThree: true, worth: 70),
  LocalGame(id: 7, name: "Solo brez", playsThree: true, worth: 80),
  //LocalGame(id: 8, name: "Odprti berač", playsThree: true),
  LocalGame(id: 9, name: "Barvni valat", playsThree: false, worth: 250),
  LocalGame(id: 10, name: "Valat", playsThree: true, worth: 500),
];

const GAME_DESC = [
  "3",
  "2",
  "1",
  "S3",
  "S2",
  "S1",
  "B",
  "SB",
  //"OB",
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
  "Joško",
  "Marko",
  "Marija",
  "Franc",
  "Ana",
  "Ivan",
  "Anton",
  "Maja",
  "Mojca",
];
