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

import 'package:flutter/material.dart';
import 'package:tarok/guide/cards.dart';
import 'package:tarok/guide/king_calling.dart';
import 'package:tarok/guide/licitation.dart';
import 'package:tarok/guide/predictions.dart';
import 'package:tarok/guide/stashing.dart';
import 'package:tarok/ui/main_page.dart';

class Guide extends StatelessWidget {
  const Guide({super.key});

  @override
  Widget build(BuildContext context) {
    return PalckaHome(
      automaticallyImplyLeading: true,
      child: ListView(
        padding: const EdgeInsets.all(10.0),
        children: const [
          CardsGuide(),
          LicitationGuide(),
          KingCallingGuide(),
          StashingGuide(),
          PredictionsGuide(),
        ],
      ),
    );
  }
}
