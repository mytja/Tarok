// StockŠkis - simple tarock bots.
// Copyright (C) 2023 Mitja Ševerkar
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

import 'package:stockskis/src/types.dart';

final List<LocalGame> GAMES = [
  LocalGame(id: -1, name: "onward", playsThree: true, worth: 0),
  LocalGame(id: 0, name: "three", playsThree: true, worth: 10),
  LocalGame(id: 1, name: "two", playsThree: true, worth: 20),
  LocalGame(id: 2, name: "one", playsThree: true, worth: 30),
  LocalGame(id: 3, name: "solo_three", playsThree: false, worth: 40),
  LocalGame(id: 4, name: "solo_two", playsThree: false, worth: 50),
  LocalGame(id: 5, name: "solo_one", playsThree: false, worth: 60),
  LocalGame(id: 6, name: "beggar", playsThree: true, worth: 70),
  LocalGame(id: 7, name: "solo_without", playsThree: true, worth: 80),
  LocalGame(id: 8, name: "open_beggar", playsThree: true, worth: 90),
  LocalGame(id: 9, name: "color_valat", playsThree: false, worth: 250),
  LocalGame(id: 10, name: "valat", playsThree: true, worth: 500),
];
