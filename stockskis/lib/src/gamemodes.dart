import 'package:stockskis/src/types.dart';

final List<LocalGame> GAMES = [
  LocalGame(id: -1, name: "Naprej", playsThree: true, worth: 0),
  LocalGame(id: 0, name: "Tri", playsThree: true, worth: 10),
  LocalGame(id: 1, name: "Dva", playsThree: true, worth: 20),
  LocalGame(id: 2, name: "Ena", playsThree: true, worth: 30),
  LocalGame(id: 3, name: "Solo tri", playsThree: false, worth: 40),
  LocalGame(id: 4, name: "Solo dva", playsThree: false, worth: 50),
  LocalGame(id: 5, name: "Solo ena", playsThree: false, worth: 60),
  LocalGame(id: 6, name: "Berač", playsThree: true, worth: 70),
  LocalGame(id: 7, name: "Solo brez", playsThree: true, worth: 80),
  LocalGame(id: 8, name: "Odprti berač", playsThree: true, worth: 90),
  LocalGame(id: 9, name: "Barvni valat", playsThree: false, worth: 250),
  LocalGame(id: 10, name: "Valat", playsThree: true, worth: 500),
];
