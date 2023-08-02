import 'dart:convert';
import 'dart:io';

import 'package:stockskis_cli/stockskis_cli.dart' as stockskis_cli;

void main(List<String> arguments) {
  if (arguments.length != 2) {
    print("Invalid amount of parameters");
    exit(1);
  }

  String type = arguments[0];
  String userId = arguments[1];

  String? json = stdin.readLineSync(encoding: utf8);
  if (json == null) {
    print("Invalid JSON");
    exit(1);
  }

  stockskis_cli.StockSkisOperations stockskis =
      stockskis_cli.StockSkisOperations(json);

  if (type == "results") {
    print(stockskis.gameResults());
  } else if (type == "modes") {
    print(stockskis.suggestModes(userId));
  } else {
    print("Invalid type");
    exit(1);
  }

  exit(0);
}
