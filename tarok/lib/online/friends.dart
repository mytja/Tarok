import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tarok/constants.dart';
import 'package:tarok/game/variables.dart';

Future<void> fetchFriends(Function setState) async {
  final response = await dio.get(
    "$BACKEND_URL/friends/get",
    options: Options(
      headers: {"X-Login-Token": await storage.read(key: "token")},
    ),
  );
  if (response.statusCode != 200) return;
  final data = jsonDecode(response.data);
  print(data);
  prijatelji = data["CurrentFriends"];
  setState(() {});
}
