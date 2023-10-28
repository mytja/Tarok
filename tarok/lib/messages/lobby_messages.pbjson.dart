///
//  Generated code. Do not modify.
//  source: lobby_messages.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use loginRequestDescriptor instead')
const LoginRequest$json = const {
  '1': 'LoginRequest',
};

/// Descriptor for `LoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestDescriptor = $convert.base64Decode('CgxMb2dpblJlcXVlc3Q=');
@$core.Deprecated('Use loginInfoDescriptor instead')
const LoginInfo$json = const {
  '1': 'LoginInfo',
  '2': const [
    const {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `LoginInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginInfoDescriptor = $convert.base64Decode('CglMb2dpbkluZm8SFAoFdG9rZW4YASABKAlSBXRva2Vu');
@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse$json = const {
  '1': 'LoginResponse',
  '2': const [
    const {'1': 'ok', '3': 1, '4': 1, '5': 11, '6': '.lobby_messages.LoginResponse.OK', '9': 0, '10': 'ok'},
    const {'1': 'fail', '3': 2, '4': 1, '5': 11, '6': '.lobby_messages.LoginResponse.Fail', '9': 0, '10': 'fail'},
  ],
  '3': const [LoginResponse_OK$json, LoginResponse_Fail$json],
  '8': const [
    const {'1': 'type'},
  ],
};

@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse_OK$json = const {
  '1': 'OK',
};

@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse_Fail$json = const {
  '1': 'Fail',
};

/// Descriptor for `LoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode('Cg1Mb2dpblJlc3BvbnNlEjIKAm9rGAEgASgLMiAubG9iYnlfbWVzc2FnZXMuTG9naW5SZXNwb25zZS5PS0gAUgJvaxI4CgRmYWlsGAIgASgLMiIubG9iYnlfbWVzc2FnZXMuTG9naW5SZXNwb25zZS5GYWlsSABSBGZhaWwaBAoCT0saBgoERmFpbEIGCgR0eXBl');
@$core.Deprecated('Use playerDescriptor instead')
const Player$json = const {
  '1': 'Player',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'rating', '3': 3, '4': 1, '5': 5, '10': 'rating'},
  ],
};

/// Descriptor for `Player`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playerDescriptor = $convert.base64Decode('CgZQbGF5ZXISDgoCaWQYASABKAlSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSFgoGcmF0aW5nGAMgASgFUgZyYXRpbmc=');
@$core.Deprecated('Use gameCreatedDescriptor instead')
const GameCreated$json = const {
  '1': 'GameCreated',
  '2': const [
    const {'1': 'gameId', '3': 1, '4': 1, '5': 9, '10': 'gameId'},
    const {'1': 'players', '3': 2, '4': 3, '5': 11, '6': '.lobby_messages.Player', '10': 'players'},
    const {'1': 'mondfang_radelci', '3': 5, '4': 1, '5': 8, '10': 'mondfangRadelci'},
    const {'1': 'skisfang', '3': 6, '4': 1, '5': 8, '10': 'skisfang'},
    const {'1': 'napovedan_mondfang', '3': 7, '4': 1, '5': 8, '10': 'napovedanMondfang'},
    const {'1': 'kontra_kazen', '3': 8, '4': 1, '5': 8, '10': 'kontraKazen'},
    const {'1': 'total_time', '3': 15, '4': 1, '5': 5, '10': 'totalTime'},
    const {'1': 'additional_time', '3': 16, '4': 1, '5': 2, '10': 'additionalTime'},
    const {'1': 'type', '3': 17, '4': 1, '5': 9, '10': 'type'},
    const {'1': 'requiredPlayers', '3': 18, '4': 1, '5': 5, '10': 'requiredPlayers'},
    const {'1': 'started', '3': 19, '4': 1, '5': 8, '10': 'started'},
    const {'1': 'private', '3': 20, '4': 1, '5': 8, '10': 'private'},
    const {'1': 'priority', '3': 21, '4': 1, '5': 8, '10': 'priority'},
  ],
};

/// Descriptor for `GameCreated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameCreatedDescriptor = $convert.base64Decode('CgtHYW1lQ3JlYXRlZBIWCgZnYW1lSWQYASABKAlSBmdhbWVJZBIwCgdwbGF5ZXJzGAIgAygLMhYubG9iYnlfbWVzc2FnZXMuUGxheWVyUgdwbGF5ZXJzEikKEG1vbmRmYW5nX3JhZGVsY2kYBSABKAhSD21vbmRmYW5nUmFkZWxjaRIaCghza2lzZmFuZxgGIAEoCFIIc2tpc2ZhbmcSLQoSbmFwb3ZlZGFuX21vbmRmYW5nGAcgASgIUhFuYXBvdmVkYW5Nb25kZmFuZxIhCgxrb250cmFfa2F6ZW4YCCABKAhSC2tvbnRyYUthemVuEh0KCnRvdGFsX3RpbWUYDyABKAVSCXRvdGFsVGltZRInCg9hZGRpdGlvbmFsX3RpbWUYECABKAJSDmFkZGl0aW9uYWxUaW1lEhIKBHR5cGUYESABKAlSBHR5cGUSKAoPcmVxdWlyZWRQbGF5ZXJzGBIgASgFUg9yZXF1aXJlZFBsYXllcnMSGAoHc3RhcnRlZBgTIAEoCFIHc3RhcnRlZBIYCgdwcml2YXRlGBQgASgIUgdwcml2YXRlEhoKCHByaW9yaXR5GBUgASgIUghwcmlvcml0eQ==');
@$core.Deprecated('Use gameDisbandedDescriptor instead')
const GameDisbanded$json = const {
  '1': 'GameDisbanded',
  '2': const [
    const {'1': 'gameId', '3': 1, '4': 1, '5': 9, '10': 'gameId'},
  ],
};

/// Descriptor for `GameDisbanded`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameDisbandedDescriptor = $convert.base64Decode('Cg1HYW1lRGlzYmFuZGVkEhYKBmdhbWVJZBgBIAEoCVIGZ2FtZUlk');
@$core.Deprecated('Use gameJoinDescriptor instead')
const GameJoin$json = const {
  '1': 'GameJoin',
  '2': const [
    const {'1': 'gameId', '3': 1, '4': 1, '5': 9, '10': 'gameId'},
    const {'1': 'player', '3': 2, '4': 1, '5': 11, '6': '.lobby_messages.Player', '10': 'player'},
  ],
};

/// Descriptor for `GameJoin`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameJoinDescriptor = $convert.base64Decode('CghHYW1lSm9pbhIWCgZnYW1lSWQYASABKAlSBmdhbWVJZBIuCgZwbGF5ZXIYAiABKAsyFi5sb2JieV9tZXNzYWdlcy5QbGF5ZXJSBnBsYXllcg==');
@$core.Deprecated('Use gameLeaveDescriptor instead')
const GameLeave$json = const {
  '1': 'GameLeave',
  '2': const [
    const {'1': 'gameId', '3': 1, '4': 1, '5': 9, '10': 'gameId'},
    const {'1': 'player', '3': 2, '4': 1, '5': 11, '6': '.lobby_messages.Player', '10': 'player'},
  ],
};

/// Descriptor for `GameLeave`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameLeaveDescriptor = $convert.base64Decode('CglHYW1lTGVhdmUSFgoGZ2FtZUlkGAEgASgJUgZnYW1lSWQSLgoGcGxheWVyGAIgASgLMhYubG9iYnlfbWVzc2FnZXMuUGxheWVyUgZwbGF5ZXI=');
@$core.Deprecated('Use lobbyMessageDescriptor instead')
const LobbyMessage$json = const {
  '1': 'LobbyMessage',
  '2': const [
    const {'1': 'player_id', '3': 1, '4': 1, '5': 9, '10': 'playerId'},
    const {'1': 'login_request', '3': 10, '4': 1, '5': 11, '6': '.lobby_messages.LoginRequest', '9': 0, '10': 'loginRequest'},
    const {'1': 'login_info', '3': 11, '4': 1, '5': 11, '6': '.lobby_messages.LoginInfo', '9': 0, '10': 'loginInfo'},
    const {'1': 'login_response', '3': 12, '4': 1, '5': 11, '6': '.lobby_messages.LoginResponse', '9': 0, '10': 'loginResponse'},
    const {'1': 'game_created', '3': 13, '4': 1, '5': 11, '6': '.lobby_messages.GameCreated', '9': 0, '10': 'gameCreated'},
    const {'1': 'game_disbanded', '3': 14, '4': 1, '5': 11, '6': '.lobby_messages.GameDisbanded', '9': 0, '10': 'gameDisbanded'},
    const {'1': 'game_join', '3': 15, '4': 1, '5': 11, '6': '.lobby_messages.GameJoin', '9': 0, '10': 'gameJoin'},
    const {'1': 'game_leave', '3': 16, '4': 1, '5': 11, '6': '.lobby_messages.GameLeave', '9': 0, '10': 'gameLeave'},
  ],
  '8': const [
    const {'1': 'data'},
  ],
};

/// Descriptor for `LobbyMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lobbyMessageDescriptor = $convert.base64Decode('CgxMb2JieU1lc3NhZ2USGwoJcGxheWVyX2lkGAEgASgJUghwbGF5ZXJJZBJDCg1sb2dpbl9yZXF1ZXN0GAogASgLMhwubG9iYnlfbWVzc2FnZXMuTG9naW5SZXF1ZXN0SABSDGxvZ2luUmVxdWVzdBI6Cgpsb2dpbl9pbmZvGAsgASgLMhkubG9iYnlfbWVzc2FnZXMuTG9naW5JbmZvSABSCWxvZ2luSW5mbxJGCg5sb2dpbl9yZXNwb25zZRgMIAEoCzIdLmxvYmJ5X21lc3NhZ2VzLkxvZ2luUmVzcG9uc2VIAFINbG9naW5SZXNwb25zZRJACgxnYW1lX2NyZWF0ZWQYDSABKAsyGy5sb2JieV9tZXNzYWdlcy5HYW1lQ3JlYXRlZEgAUgtnYW1lQ3JlYXRlZBJGCg5nYW1lX2Rpc2JhbmRlZBgOIAEoCzIdLmxvYmJ5X21lc3NhZ2VzLkdhbWVEaXNiYW5kZWRIAFINZ2FtZURpc2JhbmRlZBI3CglnYW1lX2pvaW4YDyABKAsyGC5sb2JieV9tZXNzYWdlcy5HYW1lSm9pbkgAUghnYW1lSm9pbhI6CgpnYW1lX2xlYXZlGBAgASgLMhkubG9iYnlfbWVzc2FnZXMuR2FtZUxlYXZlSABSCWdhbWVMZWF2ZUIGCgRkYXRh');
