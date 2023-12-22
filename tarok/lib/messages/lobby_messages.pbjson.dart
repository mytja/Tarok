//
//  Generated code. Do not modify.
//  source: lobby_messages.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use loginRequestDescriptor instead')
const LoginRequest$json = {
  '1': 'LoginRequest',
};

/// Descriptor for `LoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestDescriptor = $convert.base64Decode(
    'CgxMb2dpblJlcXVlc3Q=');

@$core.Deprecated('Use loginInfoDescriptor instead')
const LoginInfo$json = {
  '1': 'LoginInfo',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `LoginInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginInfoDescriptor = $convert.base64Decode(
    'CglMb2dpbkluZm8SFAoFdG9rZW4YASABKAlSBXRva2Vu');

@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse$json = {
  '1': 'LoginResponse',
  '2': [
    {'1': 'ok', '3': 1, '4': 1, '5': 11, '6': '.lobby_messages.LoginResponse.OK', '9': 0, '10': 'ok'},
    {'1': 'fail', '3': 2, '4': 1, '5': 11, '6': '.lobby_messages.LoginResponse.Fail', '9': 0, '10': 'fail'},
  ],
  '3': [LoginResponse_OK$json, LoginResponse_Fail$json],
  '8': [
    {'1': 'type'},
  ],
};

@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse_OK$json = {
  '1': 'OK',
};

@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse_Fail$json = {
  '1': 'Fail',
};

/// Descriptor for `LoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode(
    'Cg1Mb2dpblJlc3BvbnNlEjIKAm9rGAEgASgLMiAubG9iYnlfbWVzc2FnZXMuTG9naW5SZXNwb2'
    '5zZS5PS0gAUgJvaxI4CgRmYWlsGAIgASgLMiIubG9iYnlfbWVzc2FnZXMuTG9naW5SZXNwb25z'
    'ZS5GYWlsSABSBGZhaWwaBAoCT0saBgoERmFpbEIGCgR0eXBl');

@$core.Deprecated('Use playerDescriptor instead')
const Player$json = {
  '1': 'Player',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'rating', '3': 3, '4': 1, '5': 5, '10': 'rating'},
  ],
};

/// Descriptor for `Player`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playerDescriptor = $convert.base64Decode(
    'CgZQbGF5ZXISDgoCaWQYASABKAlSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSFgoGcmF0aW5nGA'
    'MgASgFUgZyYXRpbmc=');

@$core.Deprecated('Use gameCreatedDescriptor instead')
const GameCreated$json = {
  '1': 'GameCreated',
  '2': [
    {'1': 'gameId', '3': 1, '4': 1, '5': 9, '10': 'gameId'},
    {'1': 'players', '3': 2, '4': 3, '5': 11, '6': '.lobby_messages.Player', '10': 'players'},
    {'1': 'mondfang_radelci', '3': 5, '4': 1, '5': 8, '10': 'mondfangRadelci'},
    {'1': 'skisfang', '3': 6, '4': 1, '5': 8, '10': 'skisfang'},
    {'1': 'napovedan_mondfang', '3': 7, '4': 1, '5': 8, '10': 'napovedanMondfang'},
    {'1': 'kontra_kazen', '3': 8, '4': 1, '5': 8, '10': 'kontraKazen'},
    {'1': 'total_time', '3': 15, '4': 1, '5': 5, '10': 'totalTime'},
    {'1': 'additional_time', '3': 16, '4': 1, '5': 2, '10': 'additionalTime'},
    {'1': 'type', '3': 17, '4': 1, '5': 9, '10': 'type'},
    {'1': 'requiredPlayers', '3': 18, '4': 1, '5': 5, '10': 'requiredPlayers'},
    {'1': 'started', '3': 19, '4': 1, '5': 8, '10': 'started'},
    {'1': 'private', '3': 20, '4': 1, '5': 8, '10': 'private'},
    {'1': 'priority', '3': 21, '4': 1, '5': 8, '10': 'priority'},
  ],
};

/// Descriptor for `GameCreated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameCreatedDescriptor = $convert.base64Decode(
    'CgtHYW1lQ3JlYXRlZBIWCgZnYW1lSWQYASABKAlSBmdhbWVJZBIwCgdwbGF5ZXJzGAIgAygLMh'
    'YubG9iYnlfbWVzc2FnZXMuUGxheWVyUgdwbGF5ZXJzEikKEG1vbmRmYW5nX3JhZGVsY2kYBSAB'
    'KAhSD21vbmRmYW5nUmFkZWxjaRIaCghza2lzZmFuZxgGIAEoCFIIc2tpc2ZhbmcSLQoSbmFwb3'
    'ZlZGFuX21vbmRmYW5nGAcgASgIUhFuYXBvdmVkYW5Nb25kZmFuZxIhCgxrb250cmFfa2F6ZW4Y'
    'CCABKAhSC2tvbnRyYUthemVuEh0KCnRvdGFsX3RpbWUYDyABKAVSCXRvdGFsVGltZRInCg9hZG'
    'RpdGlvbmFsX3RpbWUYECABKAJSDmFkZGl0aW9uYWxUaW1lEhIKBHR5cGUYESABKAlSBHR5cGUS'
    'KAoPcmVxdWlyZWRQbGF5ZXJzGBIgASgFUg9yZXF1aXJlZFBsYXllcnMSGAoHc3RhcnRlZBgTIA'
    'EoCFIHc3RhcnRlZBIYCgdwcml2YXRlGBQgASgIUgdwcml2YXRlEhoKCHByaW9yaXR5GBUgASgI'
    'Ughwcmlvcml0eQ==');

@$core.Deprecated('Use gameDisbandedDescriptor instead')
const GameDisbanded$json = {
  '1': 'GameDisbanded',
  '2': [
    {'1': 'gameId', '3': 1, '4': 1, '5': 9, '10': 'gameId'},
  ],
};

/// Descriptor for `GameDisbanded`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameDisbandedDescriptor = $convert.base64Decode(
    'Cg1HYW1lRGlzYmFuZGVkEhYKBmdhbWVJZBgBIAEoCVIGZ2FtZUlk');

@$core.Deprecated('Use gameJoinDescriptor instead')
const GameJoin$json = {
  '1': 'GameJoin',
  '2': [
    {'1': 'gameId', '3': 1, '4': 1, '5': 9, '10': 'gameId'},
    {'1': 'player', '3': 2, '4': 1, '5': 11, '6': '.lobby_messages.Player', '10': 'player'},
  ],
};

/// Descriptor for `GameJoin`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameJoinDescriptor = $convert.base64Decode(
    'CghHYW1lSm9pbhIWCgZnYW1lSWQYASABKAlSBmdhbWVJZBIuCgZwbGF5ZXIYAiABKAsyFi5sb2'
    'JieV9tZXNzYWdlcy5QbGF5ZXJSBnBsYXllcg==');

@$core.Deprecated('Use gameLeaveDescriptor instead')
const GameLeave$json = {
  '1': 'GameLeave',
  '2': [
    {'1': 'gameId', '3': 1, '4': 1, '5': 9, '10': 'gameId'},
    {'1': 'player', '3': 2, '4': 1, '5': 11, '6': '.lobby_messages.Player', '10': 'player'},
  ],
};

/// Descriptor for `GameLeave`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameLeaveDescriptor = $convert.base64Decode(
    'CglHYW1lTGVhdmUSFgoGZ2FtZUlkGAEgASgJUgZnYW1lSWQSLgoGcGxheWVyGAIgASgLMhYubG'
    '9iYnlfbWVzc2FnZXMuUGxheWVyUgZwbGF5ZXI=');

@$core.Deprecated('Use gameInviteDescriptor instead')
const GameInvite$json = {
  '1': 'GameInvite',
  '2': [
    {'1': 'gameId', '3': 1, '4': 1, '5': 9, '10': 'gameId'},
  ],
};

/// Descriptor for `GameInvite`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameInviteDescriptor = $convert.base64Decode(
    'CgpHYW1lSW52aXRlEhYKBmdhbWVJZBgBIAEoCVIGZ2FtZUlk');

@$core.Deprecated('Use gameMoveDescriptor instead')
const GameMove$json = {
  '1': 'GameMove',
  '2': [
    {'1': 'gameId', '3': 1, '4': 1, '5': 9, '10': 'gameId'},
    {'1': 'priority', '3': 2, '4': 1, '5': 8, '10': 'priority'},
  ],
};

/// Descriptor for `GameMove`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameMoveDescriptor = $convert.base64Decode(
    'CghHYW1lTW92ZRIWCgZnYW1lSWQYASABKAlSBmdhbWVJZBIaCghwcmlvcml0eRgCIAEoCFIIcH'
    'Jpb3JpdHk=');

@$core.Deprecated('Use friendOnlineStatusDescriptor instead')
const FriendOnlineStatus$json = {
  '1': 'FriendOnlineStatus',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 5, '10': 'status'},
  ],
};

/// Descriptor for `FriendOnlineStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List friendOnlineStatusDescriptor = $convert.base64Decode(
    'ChJGcmllbmRPbmxpbmVTdGF0dXMSFgoGc3RhdHVzGAEgASgFUgZzdGF0dXM=');

@$core.Deprecated('Use friendDescriptor instead')
const Friend$json = {
  '1': 'Friend',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 5, '10': 'status'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'email', '3': 3, '4': 1, '5': 9, '10': 'email'},
    {'1': 'id', '3': 4, '4': 1, '5': 9, '10': 'id'},
    {'1': 'connected', '3': 5, '4': 1, '5': 11, '6': '.lobby_messages.Friend.Connected', '9': 0, '10': 'connected'},
    {'1': 'outgoing', '3': 6, '4': 1, '5': 11, '6': '.lobby_messages.Friend.Outgoing', '9': 0, '10': 'outgoing'},
    {'1': 'incoming', '3': 7, '4': 1, '5': 11, '6': '.lobby_messages.Friend.Incoming', '9': 0, '10': 'incoming'},
  ],
  '3': [Friend_Incoming$json, Friend_Outgoing$json, Friend_Connected$json],
  '8': [
    {'1': 'data'},
  ],
};

@$core.Deprecated('Use friendDescriptor instead')
const Friend_Incoming$json = {
  '1': 'Incoming',
};

@$core.Deprecated('Use friendDescriptor instead')
const Friend_Outgoing$json = {
  '1': 'Outgoing',
};

@$core.Deprecated('Use friendDescriptor instead')
const Friend_Connected$json = {
  '1': 'Connected',
};

/// Descriptor for `Friend`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List friendDescriptor = $convert.base64Decode(
    'CgZGcmllbmQSFgoGc3RhdHVzGAEgASgFUgZzdGF0dXMSEgoEbmFtZRgCIAEoCVIEbmFtZRIUCg'
    'VlbWFpbBgDIAEoCVIFZW1haWwSDgoCaWQYBCABKAlSAmlkEkAKCWNvbm5lY3RlZBgFIAEoCzIg'
    'LmxvYmJ5X21lc3NhZ2VzLkZyaWVuZC5Db25uZWN0ZWRIAFIJY29ubmVjdGVkEj0KCG91dGdvaW'
    '5nGAYgASgLMh8ubG9iYnlfbWVzc2FnZXMuRnJpZW5kLk91dGdvaW5nSABSCG91dGdvaW5nEj0K'
    'CGluY29taW5nGAcgASgLMh8ubG9iYnlfbWVzc2FnZXMuRnJpZW5kLkluY29taW5nSABSCGluY2'
    '9taW5nGgoKCEluY29taW5nGgoKCE91dGdvaW5nGgsKCUNvbm5lY3RlZEIGCgRkYXRh');

@$core.Deprecated('Use friendRequestAcceptDeclineDescriptor instead')
const FriendRequestAcceptDecline$json = {
  '1': 'FriendRequestAcceptDecline',
  '2': [
    {'1': 'relationshipId', '3': 1, '4': 1, '5': 9, '10': 'relationshipId'},
    {'1': 'accept', '3': 2, '4': 1, '5': 8, '10': 'accept'},
  ],
};

/// Descriptor for `FriendRequestAcceptDecline`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List friendRequestAcceptDeclineDescriptor = $convert.base64Decode(
    'ChpGcmllbmRSZXF1ZXN0QWNjZXB0RGVjbGluZRImCg5yZWxhdGlvbnNoaXBJZBgBIAEoCVIOcm'
    'VsYXRpb25zaGlwSWQSFgoGYWNjZXB0GAIgASgIUgZhY2NlcHQ=');

@$core.Deprecated('Use friendRequestSendDescriptor instead')
const FriendRequestSend$json = {
  '1': 'FriendRequestSend',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
  ],
};

/// Descriptor for `FriendRequestSend`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List friendRequestSendDescriptor = $convert.base64Decode(
    'ChFGcmllbmRSZXF1ZXN0U2VuZBIUCgVlbWFpbBgBIAEoCVIFZW1haWw=');

@$core.Deprecated('Use removeFriendDescriptor instead')
const RemoveFriend$json = {
  '1': 'RemoveFriend',
  '2': [
    {'1': 'relationshipId', '3': 1, '4': 1, '5': 9, '10': 'relationshipId'},
  ],
};

/// Descriptor for `RemoveFriend`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeFriendDescriptor = $convert.base64Decode(
    'CgxSZW1vdmVGcmllbmQSJgoOcmVsYXRpb25zaGlwSWQYASABKAlSDnJlbGF0aW9uc2hpcElk');

@$core.Deprecated('Use replayDescriptor instead')
const Replay$json = {
  '1': 'Replay',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
    {'1': 'gameId', '3': 2, '4': 1, '5': 9, '10': 'gameId'},
    {'1': 'createdAt', '3': 3, '4': 1, '5': 9, '10': 'createdAt'},
  ],
};

/// Descriptor for `Replay`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List replayDescriptor = $convert.base64Decode(
    'CgZSZXBsYXkSEAoDdXJsGAEgASgJUgN1cmwSFgoGZ2FtZUlkGAIgASgJUgZnYW1lSWQSHAoJY3'
    'JlYXRlZEF0GAMgASgJUgljcmVhdGVkQXQ=');

@$core.Deprecated('Use lobbyMessageDescriptor instead')
const LobbyMessage$json = {
  '1': 'LobbyMessage',
  '2': [
    {'1': 'player_id', '3': 1, '4': 1, '5': 9, '10': 'playerId'},
    {'1': 'login_request', '3': 10, '4': 1, '5': 11, '6': '.lobby_messages.LoginRequest', '9': 0, '10': 'loginRequest'},
    {'1': 'login_info', '3': 11, '4': 1, '5': 11, '6': '.lobby_messages.LoginInfo', '9': 0, '10': 'loginInfo'},
    {'1': 'login_response', '3': 12, '4': 1, '5': 11, '6': '.lobby_messages.LoginResponse', '9': 0, '10': 'loginResponse'},
    {'1': 'game_created', '3': 13, '4': 1, '5': 11, '6': '.lobby_messages.GameCreated', '9': 0, '10': 'gameCreated'},
    {'1': 'game_disbanded', '3': 14, '4': 1, '5': 11, '6': '.lobby_messages.GameDisbanded', '9': 0, '10': 'gameDisbanded'},
    {'1': 'game_join', '3': 15, '4': 1, '5': 11, '6': '.lobby_messages.GameJoin', '9': 0, '10': 'gameJoin'},
    {'1': 'game_leave', '3': 16, '4': 1, '5': 11, '6': '.lobby_messages.GameLeave', '9': 0, '10': 'gameLeave'},
    {'1': 'game_move', '3': 17, '4': 1, '5': 11, '6': '.lobby_messages.GameMove', '9': 0, '10': 'gameMove'},
    {'1': 'game_invite', '3': 18, '4': 1, '5': 11, '6': '.lobby_messages.GameInvite', '9': 0, '10': 'gameInvite'},
    {'1': 'friend_online_status', '3': 20, '4': 1, '5': 11, '6': '.lobby_messages.FriendOnlineStatus', '9': 0, '10': 'friendOnlineStatus'},
    {'1': 'friend', '3': 21, '4': 1, '5': 11, '6': '.lobby_messages.Friend', '9': 0, '10': 'friend'},
    {'1': 'friend_request_accept_decline', '3': 22, '4': 1, '5': 11, '6': '.lobby_messages.FriendRequestAcceptDecline', '9': 0, '10': 'friendRequestAcceptDecline'},
    {'1': 'friend_request_send', '3': 23, '4': 1, '5': 11, '6': '.lobby_messages.FriendRequestSend', '9': 0, '10': 'friendRequestSend'},
    {'1': 'remove_friend', '3': 24, '4': 1, '5': 11, '6': '.lobby_messages.RemoveFriend', '9': 0, '10': 'removeFriend'},
    {'1': 'replay', '3': 25, '4': 1, '5': 11, '6': '.lobby_messages.Replay', '9': 0, '10': 'replay'},
  ],
  '8': [
    {'1': 'data'},
  ],
};

/// Descriptor for `LobbyMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lobbyMessageDescriptor = $convert.base64Decode(
    'CgxMb2JieU1lc3NhZ2USGwoJcGxheWVyX2lkGAEgASgJUghwbGF5ZXJJZBJDCg1sb2dpbl9yZX'
    'F1ZXN0GAogASgLMhwubG9iYnlfbWVzc2FnZXMuTG9naW5SZXF1ZXN0SABSDGxvZ2luUmVxdWVz'
    'dBI6Cgpsb2dpbl9pbmZvGAsgASgLMhkubG9iYnlfbWVzc2FnZXMuTG9naW5JbmZvSABSCWxvZ2'
    'luSW5mbxJGCg5sb2dpbl9yZXNwb25zZRgMIAEoCzIdLmxvYmJ5X21lc3NhZ2VzLkxvZ2luUmVz'
    'cG9uc2VIAFINbG9naW5SZXNwb25zZRJACgxnYW1lX2NyZWF0ZWQYDSABKAsyGy5sb2JieV9tZX'
    'NzYWdlcy5HYW1lQ3JlYXRlZEgAUgtnYW1lQ3JlYXRlZBJGCg5nYW1lX2Rpc2JhbmRlZBgOIAEo'
    'CzIdLmxvYmJ5X21lc3NhZ2VzLkdhbWVEaXNiYW5kZWRIAFINZ2FtZURpc2JhbmRlZBI3CglnYW'
    '1lX2pvaW4YDyABKAsyGC5sb2JieV9tZXNzYWdlcy5HYW1lSm9pbkgAUghnYW1lSm9pbhI6Cgpn'
    'YW1lX2xlYXZlGBAgASgLMhkubG9iYnlfbWVzc2FnZXMuR2FtZUxlYXZlSABSCWdhbWVMZWF2ZR'
    'I3CglnYW1lX21vdmUYESABKAsyGC5sb2JieV9tZXNzYWdlcy5HYW1lTW92ZUgAUghnYW1lTW92'
    'ZRI9CgtnYW1lX2ludml0ZRgSIAEoCzIaLmxvYmJ5X21lc3NhZ2VzLkdhbWVJbnZpdGVIAFIKZ2'
    'FtZUludml0ZRJWChRmcmllbmRfb25saW5lX3N0YXR1cxgUIAEoCzIiLmxvYmJ5X21lc3NhZ2Vz'
    'LkZyaWVuZE9ubGluZVN0YXR1c0gAUhJmcmllbmRPbmxpbmVTdGF0dXMSMAoGZnJpZW5kGBUgAS'
    'gLMhYubG9iYnlfbWVzc2FnZXMuRnJpZW5kSABSBmZyaWVuZBJvCh1mcmllbmRfcmVxdWVzdF9h'
    'Y2NlcHRfZGVjbGluZRgWIAEoCzIqLmxvYmJ5X21lc3NhZ2VzLkZyaWVuZFJlcXVlc3RBY2NlcH'
    'REZWNsaW5lSABSGmZyaWVuZFJlcXVlc3RBY2NlcHREZWNsaW5lElMKE2ZyaWVuZF9yZXF1ZXN0'
    'X3NlbmQYFyABKAsyIS5sb2JieV9tZXNzYWdlcy5GcmllbmRSZXF1ZXN0U2VuZEgAUhFmcmllbm'
    'RSZXF1ZXN0U2VuZBJDCg1yZW1vdmVfZnJpZW5kGBggASgLMhwubG9iYnlfbWVzc2FnZXMuUmVt'
    'b3ZlRnJpZW5kSABSDHJlbW92ZUZyaWVuZBIwCgZyZXBsYXkYGSABKAsyFi5sb2JieV9tZXNzYW'
    'dlcy5SZXBsYXlIAFIGcmVwbGF5QgYKBGRhdGE=');

