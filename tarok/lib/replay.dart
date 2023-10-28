import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tarok/constants.dart';

Future<String?> replayFetch(String url) async {
  final r = RegExp(r"(https:\/\/.*\/replay\/)(.*)(\?password=)(.*)");
  final match = r.firstMatch(url);
  if (match == null) {
    return null;
  }
  String? uid = match.group(2);
  if (uid == null) {
    return null;
  }
  String? password = match.group(4);
  if (password == null) {
    return null;
  }
  password = Uri.encodeFull(password);
  uid = Uri.encodeFull(uid);

  debugPrint("$uid $password");

  final token = await storage.read(key: "token");
  if (token == null) return null;
  final response = await dio.get(
    '$BACKEND_URL/replay/$uid?password=$password',
    options: Options(
      headers: {"X-Login-Token": await storage.read(key: "token")},
    ),
  );
  return response.data;
}

Future<void> joinReplay(String url) async {
  String? r = await replayFetch(url);
  if (r == null) {
    return;
  }
  Map s = jsonDecode(r);
  String gameId = s["replayId"].toString();
  String players = s["playerCount"].toString();
  Get.toNamed("/game", parameters: {
    "playing": players,
    "gameId": gameId,
    "bots": "false",
    "replay": "true",
  });
}
