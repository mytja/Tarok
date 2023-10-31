///
//  Generated code. Do not modify.
//  source: messages.proto
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
    const {'1': 'ok', '3': 1, '4': 1, '5': 11, '6': '.game_messages.LoginResponse.OK', '9': 0, '10': 'ok'},
    const {'1': 'fail', '3': 2, '4': 1, '5': 11, '6': '.game_messages.LoginResponse.Fail', '9': 0, '10': 'fail'},
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
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode('Cg1Mb2dpblJlc3BvbnNlEjEKAm9rGAEgASgLMh8uZ2FtZV9tZXNzYWdlcy5Mb2dpblJlc3BvbnNlLk9LSABSAm9rEjcKBGZhaWwYAiABKAsyIS5nYW1lX21lc3NhZ2VzLkxvZ2luUmVzcG9uc2UuRmFpbEgAUgRmYWlsGgQKAk9LGgYKBEZhaWxCBgoEdHlwZQ==');
@$core.Deprecated('Use connectDescriptor instead')
const Connect$json = const {
  '1': 'Connect',
};

/// Descriptor for `Connect`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectDescriptor = $convert.base64Decode('CgdDb25uZWN0');
@$core.Deprecated('Use disconnectDescriptor instead')
const Disconnect$json = const {
  '1': 'Disconnect',
};

/// Descriptor for `Disconnect`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disconnectDescriptor = $convert.base64Decode('CgpEaXNjb25uZWN0');
@$core.Deprecated('Use receiveDescriptor instead')
const Receive$json = const {
  '1': 'Receive',
};

/// Descriptor for `Receive`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List receiveDescriptor = $convert.base64Decode('CgdSZWNlaXZl');
@$core.Deprecated('Use sendDescriptor instead')
const Send$json = const {
  '1': 'Send',
};

/// Descriptor for `Send`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendDescriptor = $convert.base64Decode('CgRTZW5k');
@$core.Deprecated('Use requestDescriptor instead')
const Request$json = const {
  '1': 'Request',
  '2': const [
    const {'1': 'count', '3': 1, '4': 1, '5': 5, '10': 'count'},
  ],
};

/// Descriptor for `Request`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestDescriptor = $convert.base64Decode('CgdSZXF1ZXN0EhQKBWNvdW50GAEgASgFUgVjb3VudA==');
@$core.Deprecated('Use removeDescriptor instead')
const Remove$json = const {
  '1': 'Remove',
};

/// Descriptor for `Remove`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeDescriptor = $convert.base64Decode('CgZSZW1vdmU=');
@$core.Deprecated('Use clearDeskDescriptor instead')
const ClearDesk$json = const {
  '1': 'ClearDesk',
};

/// Descriptor for `ClearDesk`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearDeskDescriptor = $convert.base64Decode('CglDbGVhckRlc2s=');
@$core.Deprecated('Use notificationDescriptor instead')
const Notification$json = const {
  '1': 'Notification',
};

/// Descriptor for `Notification`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationDescriptor = $convert.base64Decode('CgxOb3RpZmljYXRpb24=');
@$core.Deprecated('Use leaveDescriptor instead')
const Leave$json = const {
  '1': 'Leave',
};

/// Descriptor for `Leave`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List leaveDescriptor = $convert.base64Decode('CgVMZWF2ZQ==');
@$core.Deprecated('Use replayLinkDescriptor instead')
const ReplayLink$json = const {
  '1': 'ReplayLink',
  '2': const [
    const {'1': 'replay', '3': 1, '4': 1, '5': 9, '10': 'replay'},
  ],
};

/// Descriptor for `ReplayLink`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List replayLinkDescriptor = $convert.base64Decode('CgpSZXBsYXlMaW5rEhYKBnJlcGxheRgBIAEoCVIGcmVwbGF5');
@$core.Deprecated('Use replayMoveDescriptor instead')
const ReplayMove$json = const {
  '1': 'ReplayMove',
};

/// Descriptor for `ReplayMove`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List replayMoveDescriptor = $convert.base64Decode('CgpSZXBsYXlNb3Zl');
@$core.Deprecated('Use replaySelectGameDescriptor instead')
const ReplaySelectGame$json = const {
  '1': 'ReplaySelectGame',
  '2': const [
    const {'1': 'game', '3': 1, '4': 1, '5': 5, '10': 'game'},
  ],
};

/// Descriptor for `ReplaySelectGame`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List replaySelectGameDescriptor = $convert.base64Decode('ChBSZXBsYXlTZWxlY3RHYW1lEhIKBGdhbWUYASABKAVSBGdhbWU=');
@$core.Deprecated('Use startEarlyDescriptor instead')
const StartEarly$json = const {
  '1': 'StartEarly',
};

/// Descriptor for `StartEarly`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startEarlyDescriptor = $convert.base64Decode('CgpTdGFydEVhcmx5');
@$core.Deprecated('Use gameInfoDescriptor instead')
const GameInfo$json = const {
  '1': 'GameInfo',
  '2': const [
    const {'1': 'gamesPlayed', '3': 1, '4': 1, '5': 5, '10': 'gamesPlayed'},
    const {'1': 'gamesRequired', '3': 2, '4': 1, '5': 5, '10': 'gamesRequired'},
    const {'1': 'canExtendGame', '3': 3, '4': 1, '5': 8, '10': 'canExtendGame'},
  ],
};

/// Descriptor for `GameInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameInfoDescriptor = $convert.base64Decode('CghHYW1lSW5mbxIgCgtnYW1lc1BsYXllZBgBIAEoBVILZ2FtZXNQbGF5ZWQSJAoNZ2FtZXNSZXF1aXJlZBgCIAEoBVINZ2FtZXNSZXF1aXJlZBIkCg1jYW5FeHRlbmRHYW1lGAMgASgIUg1jYW5FeHRlbmRHYW1l');
@$core.Deprecated('Use gameEndDescriptor instead')
const GameEnd$json = const {
  '1': 'GameEnd',
  '2': const [
    const {'1': 'results', '3': 1, '4': 1, '5': 11, '6': '.game_messages.Results', '9': 0, '10': 'results'},
    const {'1': 'request', '3': 2, '4': 1, '5': 11, '6': '.game_messages.Request', '9': 0, '10': 'request'},
  ],
  '8': const [
    const {'1': 'type'},
  ],
};

/// Descriptor for `GameEnd`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameEndDescriptor = $convert.base64Decode('CgdHYW1lRW5kEjIKB3Jlc3VsdHMYASABKAsyFi5nYW1lX21lc3NhZ2VzLlJlc3VsdHNIAFIHcmVzdWx0cxIyCgdyZXF1ZXN0GAIgASgLMhYuZ2FtZV9tZXNzYWdlcy5SZXF1ZXN0SABSB3JlcXVlc3RCBgoEdHlwZQ==');
@$core.Deprecated('Use connectionDescriptor instead')
const Connection$json = const {
  '1': 'Connection',
  '2': const [
    const {'1': 'rating', '3': 2, '4': 1, '5': 5, '10': 'rating'},
    const {'1': 'join', '3': 3, '4': 1, '5': 11, '6': '.game_messages.Connect', '9': 0, '10': 'join'},
    const {'1': 'disconnect', '3': 4, '4': 1, '5': 11, '6': '.game_messages.Disconnect', '9': 0, '10': 'disconnect'},
    const {'1': 'leave', '3': 5, '4': 1, '5': 11, '6': '.game_messages.Leave', '9': 0, '10': 'leave'},
  ],
  '8': const [
    const {'1': 'type'},
  ],
};

/// Descriptor for `Connection`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectionDescriptor = $convert.base64Decode('CgpDb25uZWN0aW9uEhYKBnJhdGluZxgCIAEoBVIGcmF0aW5nEiwKBGpvaW4YAyABKAsyFi5nYW1lX21lc3NhZ2VzLkNvbm5lY3RIAFIEam9pbhI7CgpkaXNjb25uZWN0GAQgASgLMhkuZ2FtZV9tZXNzYWdlcy5EaXNjb25uZWN0SABSCmRpc2Nvbm5lY3QSLAoFbGVhdmUYBSABKAsyFC5nYW1lX21lc3NhZ2VzLkxlYXZlSABSBWxlYXZlQgYKBHR5cGU=');
@$core.Deprecated('Use licitiranjeDescriptor instead')
const Licitiranje$json = const {
  '1': 'Licitiranje',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 5, '10': 'type'},
  ],
};

/// Descriptor for `Licitiranje`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List licitiranjeDescriptor = $convert.base64Decode('CgtMaWNpdGlyYW5qZRISCgR0eXBlGAEgASgFUgR0eXBl');
@$core.Deprecated('Use licitiranjeStartDescriptor instead')
const LicitiranjeStart$json = const {
  '1': 'LicitiranjeStart',
};

/// Descriptor for `LicitiranjeStart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List licitiranjeStartDescriptor = $convert.base64Decode('ChBMaWNpdGlyYW5qZVN0YXJ0');
@$core.Deprecated('Use cardDescriptor instead')
const Card$json = const {
  '1': 'Card',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'userId', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'receive', '3': 3, '4': 1, '5': 11, '6': '.game_messages.Receive', '9': 0, '10': 'receive'},
    const {'1': 'send', '3': 4, '4': 1, '5': 11, '6': '.game_messages.Send', '9': 0, '10': 'send'},
    const {'1': 'request', '3': 5, '4': 1, '5': 11, '6': '.game_messages.Request', '9': 0, '10': 'request'},
    const {'1': 'remove', '3': 6, '4': 1, '5': 11, '6': '.game_messages.Remove', '9': 0, '10': 'remove'},
  ],
  '8': const [
    const {'1': 'type'},
  ],
};

/// Descriptor for `Card`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cardDescriptor = $convert.base64Decode('CgRDYXJkEg4KAmlkGAEgASgJUgJpZBIWCgZ1c2VySWQYAiABKAlSBnVzZXJJZBIyCgdyZWNlaXZlGAMgASgLMhYuZ2FtZV9tZXNzYWdlcy5SZWNlaXZlSABSB3JlY2VpdmUSKQoEc2VuZBgEIAEoCzITLmdhbWVfbWVzc2FnZXMuU2VuZEgAUgRzZW5kEjIKB3JlcXVlc3QYBSABKAsyFi5nYW1lX21lc3NhZ2VzLlJlcXVlc3RIAFIHcmVxdWVzdBIvCgZyZW1vdmUYBiABKAsyFS5nYW1lX21lc3NhZ2VzLlJlbW92ZUgAUgZyZW1vdmVCBgoEdHlwZQ==');
@$core.Deprecated('Use gameStartCountdownDescriptor instead')
const GameStartCountdown$json = const {
  '1': 'GameStartCountdown',
  '2': const [
    const {'1': 'countdown', '3': 1, '4': 1, '5': 5, '10': 'countdown'},
  ],
};

/// Descriptor for `GameStartCountdown`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameStartCountdownDescriptor = $convert.base64Decode('ChJHYW1lU3RhcnRDb3VudGRvd24SHAoJY291bnRkb3duGAEgASgFUgljb3VudGRvd24=');
@$core.Deprecated('Use userDescriptor instead')
const User$json = const {
  '1': 'User',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'position', '3': 3, '4': 1, '5': 5, '10': 'position'},
  ],
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode('CgRVc2VyEg4KAmlkGAEgASgJUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEhoKCHBvc2l0aW9uGAMgASgFUghwb3NpdGlvbg==');
@$core.Deprecated('Use resultsUserDescriptor instead')
const ResultsUser$json = const {
  '1': 'ResultsUser',
  '2': const [
    const {'1': 'user', '3': 1, '4': 3, '5': 11, '6': '.game_messages.User', '10': 'user'},
    const {'1': 'playing', '3': 2, '4': 1, '5': 8, '10': 'playing'},
    const {'1': 'points', '3': 3, '4': 1, '5': 5, '10': 'points'},
    const {'1': 'trula', '3': 4, '4': 1, '5': 5, '10': 'trula'},
    const {'1': 'pagat', '3': 5, '4': 1, '5': 5, '10': 'pagat'},
    const {'1': 'igra', '3': 6, '4': 1, '5': 5, '10': 'igra'},
    const {'1': 'razlika', '3': 7, '4': 1, '5': 5, '10': 'razlika'},
    const {'1': 'kralj', '3': 8, '4': 1, '5': 5, '10': 'kralj'},
    const {'1': 'kralji', '3': 9, '4': 1, '5': 5, '10': 'kralji'},
    const {'1': 'kontra_pagat', '3': 10, '4': 1, '5': 5, '10': 'kontraPagat'},
    const {'1': 'kontra_igra', '3': 11, '4': 1, '5': 5, '10': 'kontraIgra'},
    const {'1': 'kontra_kralj', '3': 12, '4': 1, '5': 5, '10': 'kontraKralj'},
    const {'1': 'kontra_mondfang', '3': 13, '4': 1, '5': 5, '10': 'kontraMondfang'},
    const {'1': 'mondfang', '3': 14, '4': 1, '5': 8, '10': 'mondfang'},
    const {'1': 'show_gamemode', '3': 15, '4': 1, '5': 8, '10': 'showGamemode'},
    const {'1': 'show_difference', '3': 16, '4': 1, '5': 8, '10': 'showDifference'},
    const {'1': 'show_kralj', '3': 17, '4': 1, '5': 8, '10': 'showKralj'},
    const {'1': 'show_pagat', '3': 18, '4': 1, '5': 8, '10': 'showPagat'},
    const {'1': 'show_kralji', '3': 19, '4': 1, '5': 8, '10': 'showKralji'},
    const {'1': 'show_trula', '3': 20, '4': 1, '5': 8, '10': 'showTrula'},
    const {'1': 'radelc', '3': 21, '4': 1, '5': 8, '10': 'radelc'},
    const {'1': 'skisfang', '3': 22, '4': 1, '5': 8, '10': 'skisfang'},
  ],
};

/// Descriptor for `ResultsUser`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resultsUserDescriptor = $convert.base64Decode('CgtSZXN1bHRzVXNlchInCgR1c2VyGAEgAygLMhMuZ2FtZV9tZXNzYWdlcy5Vc2VyUgR1c2VyEhgKB3BsYXlpbmcYAiABKAhSB3BsYXlpbmcSFgoGcG9pbnRzGAMgASgFUgZwb2ludHMSFAoFdHJ1bGEYBCABKAVSBXRydWxhEhQKBXBhZ2F0GAUgASgFUgVwYWdhdBISCgRpZ3JhGAYgASgFUgRpZ3JhEhgKB3Jhemxpa2EYByABKAVSB3Jhemxpa2ESFAoFa3JhbGoYCCABKAVSBWtyYWxqEhYKBmtyYWxqaRgJIAEoBVIGa3JhbGppEiEKDGtvbnRyYV9wYWdhdBgKIAEoBVILa29udHJhUGFnYXQSHwoLa29udHJhX2lncmEYCyABKAVSCmtvbnRyYUlncmESIQoMa29udHJhX2tyYWxqGAwgASgFUgtrb250cmFLcmFsahInCg9rb250cmFfbW9uZGZhbmcYDSABKAVSDmtvbnRyYU1vbmRmYW5nEhoKCG1vbmRmYW5nGA4gASgIUghtb25kZmFuZxIjCg1zaG93X2dhbWVtb2RlGA8gASgIUgxzaG93R2FtZW1vZGUSJwoPc2hvd19kaWZmZXJlbmNlGBAgASgIUg5zaG93RGlmZmVyZW5jZRIdCgpzaG93X2tyYWxqGBEgASgIUglzaG93S3JhbGoSHQoKc2hvd19wYWdhdBgSIAEoCFIJc2hvd1BhZ2F0Eh8KC3Nob3dfa3JhbGppGBMgASgIUgpzaG93S3JhbGppEh0KCnNob3dfdHJ1bGEYFCABKAhSCXNob3dUcnVsYRIWCgZyYWRlbGMYFSABKAhSBnJhZGVsYxIaCghza2lzZmFuZxgWIAEoCFIIc2tpc2Zhbmc=');
@$core.Deprecated('Use stihDescriptor instead')
const Stih$json = const {
  '1': 'Stih',
  '2': const [
    const {'1': 'card', '3': 1, '4': 3, '5': 11, '6': '.game_messages.Card', '10': 'card'},
    const {'1': 'worth', '3': 2, '4': 1, '5': 2, '10': 'worth'},
    const {'1': 'pickedUpByPlaying', '3': 3, '4': 1, '5': 8, '10': 'pickedUpByPlaying'},
    const {'1': 'pickedUpBy', '3': 4, '4': 1, '5': 9, '10': 'pickedUpBy'},
  ],
};

/// Descriptor for `Stih`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stihDescriptor = $convert.base64Decode('CgRTdGloEicKBGNhcmQYASADKAsyEy5nYW1lX21lc3NhZ2VzLkNhcmRSBGNhcmQSFAoFd29ydGgYAiABKAJSBXdvcnRoEiwKEXBpY2tlZFVwQnlQbGF5aW5nGAMgASgIUhFwaWNrZWRVcEJ5UGxheWluZxIeCgpwaWNrZWRVcEJ5GAQgASgJUgpwaWNrZWRVcEJ5');
@$core.Deprecated('Use resultsDescriptor instead')
const Results$json = const {
  '1': 'Results',
  '2': const [
    const {'1': 'user', '3': 1, '4': 3, '5': 11, '6': '.game_messages.ResultsUser', '10': 'user'},
    const {'1': 'stih', '3': 2, '4': 3, '5': 11, '6': '.game_messages.Stih', '10': 'stih'},
    const {'1': 'predictions', '3': 3, '4': 1, '5': 11, '6': '.game_messages.Predictions', '10': 'predictions'},
  ],
};

/// Descriptor for `Results`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resultsDescriptor = $convert.base64Decode('CgdSZXN1bHRzEi4KBHVzZXIYASADKAsyGi5nYW1lX21lc3NhZ2VzLlJlc3VsdHNVc2VyUgR1c2VyEicKBHN0aWgYAiADKAsyEy5nYW1lX21lc3NhZ2VzLlN0aWhSBHN0aWgSPAoLcHJlZGljdGlvbnMYAyABKAsyGi5nYW1lX21lc3NhZ2VzLlByZWRpY3Rpb25zUgtwcmVkaWN0aW9ucw==');
@$core.Deprecated('Use gameStartDescriptor instead')
const GameStart$json = const {
  '1': 'GameStart',
  '2': const [
    const {'1': 'user', '3': 1, '4': 3, '5': 11, '6': '.game_messages.User', '10': 'user'},
  ],
};

/// Descriptor for `GameStart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameStartDescriptor = $convert.base64Decode('CglHYW1lU3RhcnQSJwoEdXNlchgBIAMoCzITLmdhbWVfbWVzc2FnZXMuVXNlclIEdXNlcg==');
@$core.Deprecated('Use userListDescriptor instead')
const UserList$json = const {
  '1': 'UserList',
  '2': const [
    const {'1': 'user', '3': 1, '4': 3, '5': 11, '6': '.game_messages.User', '10': 'user'},
  ],
};

/// Descriptor for `UserList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userListDescriptor = $convert.base64Decode('CghVc2VyTGlzdBInCgR1c2VyGAEgAygLMhMuZ2FtZV9tZXNzYWdlcy5Vc2VyUgR1c2Vy');
@$core.Deprecated('Use kingSelectionDescriptor instead')
const KingSelection$json = const {
  '1': 'KingSelection',
  '2': const [
    const {'1': 'card', '3': 1, '4': 1, '5': 9, '10': 'card'},
    const {'1': 'request', '3': 2, '4': 1, '5': 11, '6': '.game_messages.Request', '9': 0, '10': 'request'},
    const {'1': 'send', '3': 3, '4': 1, '5': 11, '6': '.game_messages.Send', '9': 0, '10': 'send'},
    const {'1': 'notification', '3': 4, '4': 1, '5': 11, '6': '.game_messages.Notification', '9': 0, '10': 'notification'},
  ],
  '8': const [
    const {'1': 'type'},
  ],
};

/// Descriptor for `KingSelection`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List kingSelectionDescriptor = $convert.base64Decode('Cg1LaW5nU2VsZWN0aW9uEhIKBGNhcmQYASABKAlSBGNhcmQSMgoHcmVxdWVzdBgCIAEoCzIWLmdhbWVfbWVzc2FnZXMuUmVxdWVzdEgAUgdyZXF1ZXN0EikKBHNlbmQYAyABKAsyEy5nYW1lX21lc3NhZ2VzLlNlbmRIAFIEc2VuZBJBCgxub3RpZmljYXRpb24YBCABKAsyGy5nYW1lX21lc3NhZ2VzLk5vdGlmaWNhdGlvbkgAUgxub3RpZmljYXRpb25CBgoEdHlwZQ==');
@$core.Deprecated('Use talonSelectionDescriptor instead')
const TalonSelection$json = const {
  '1': 'TalonSelection',
  '2': const [
    const {'1': 'part', '3': 1, '4': 1, '5': 5, '10': 'part'},
    const {'1': 'request', '3': 2, '4': 1, '5': 11, '6': '.game_messages.Request', '9': 0, '10': 'request'},
    const {'1': 'send', '3': 3, '4': 1, '5': 11, '6': '.game_messages.Send', '9': 0, '10': 'send'},
    const {'1': 'notification', '3': 4, '4': 1, '5': 11, '6': '.game_messages.Notification', '9': 0, '10': 'notification'},
  ],
  '8': const [
    const {'1': 'type'},
  ],
};

/// Descriptor for `TalonSelection`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List talonSelectionDescriptor = $convert.base64Decode('Cg5UYWxvblNlbGVjdGlvbhISCgRwYXJ0GAEgASgFUgRwYXJ0EjIKB3JlcXVlc3QYAiABKAsyFi5nYW1lX21lc3NhZ2VzLlJlcXVlc3RIAFIHcmVxdWVzdBIpCgRzZW5kGAMgASgLMhMuZ2FtZV9tZXNzYWdlcy5TZW5kSABSBHNlbmQSQQoMbm90aWZpY2F0aW9uGAQgASgLMhsuZ2FtZV9tZXNzYWdlcy5Ob3RpZmljYXRpb25IAFIMbm90aWZpY2F0aW9uQgYKBHR5cGU=');
@$core.Deprecated('Use stashDescriptor instead')
const Stash$json = const {
  '1': 'Stash',
  '2': const [
    const {'1': 'card', '3': 1, '4': 3, '5': 11, '6': '.game_messages.Card', '10': 'card'},
    const {'1': 'length', '3': 2, '4': 1, '5': 5, '10': 'length'},
    const {'1': 'request', '3': 3, '4': 1, '5': 11, '6': '.game_messages.Request', '9': 0, '10': 'request'},
    const {'1': 'send', '3': 4, '4': 1, '5': 11, '6': '.game_messages.Send', '9': 0, '10': 'send'},
    const {'1': 'notification', '3': 5, '4': 1, '5': 11, '6': '.game_messages.Notification', '9': 0, '10': 'notification'},
  ],
  '8': const [
    const {'1': 'type'},
  ],
};

/// Descriptor for `Stash`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stashDescriptor = $convert.base64Decode('CgVTdGFzaBInCgRjYXJkGAEgAygLMhMuZ2FtZV9tZXNzYWdlcy5DYXJkUgRjYXJkEhYKBmxlbmd0aBgCIAEoBVIGbGVuZ3RoEjIKB3JlcXVlc3QYAyABKAsyFi5nYW1lX21lc3NhZ2VzLlJlcXVlc3RIAFIHcmVxdWVzdBIpCgRzZW5kGAQgASgLMhMuZ2FtZV9tZXNzYWdlcy5TZW5kSABSBHNlbmQSQQoMbm90aWZpY2F0aW9uGAUgASgLMhsuZ2FtZV9tZXNzYWdlcy5Ob3RpZmljYXRpb25IAFIMbm90aWZpY2F0aW9uQgYKBHR5cGU=');
@$core.Deprecated('Use stashedTarockDescriptor instead')
const StashedTarock$json = const {
  '1': 'StashedTarock',
  '2': const [
    const {'1': 'card', '3': 1, '4': 1, '5': 11, '6': '.game_messages.Card', '10': 'card'},
  ],
};

/// Descriptor for `StashedTarock`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stashedTarockDescriptor = $convert.base64Decode('Cg1TdGFzaGVkVGFyb2NrEicKBGNhcmQYASABKAsyEy5nYW1lX21lc3NhZ2VzLkNhcmRSBGNhcmQ=');
@$core.Deprecated('Use radelciDescriptor instead')
const Radelci$json = const {
  '1': 'Radelci',
  '2': const [
    const {'1': 'radleci', '3': 1, '4': 1, '5': 5, '10': 'radleci'},
  ],
};

/// Descriptor for `Radelci`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List radelciDescriptor = $convert.base64Decode('CgdSYWRlbGNpEhgKB3JhZGxlY2kYASABKAVSB3JhZGxlY2k=');
@$core.Deprecated('Use startPredictionsDescriptor instead')
const StartPredictions$json = const {
  '1': 'StartPredictions',
  '2': const [
    const {'1': 'kralj_ultimo_kontra', '3': 1, '4': 1, '5': 8, '10': 'kraljUltimoKontra'},
    const {'1': 'pagat_ultimo_kontra', '3': 4, '4': 1, '5': 8, '10': 'pagatUltimoKontra'},
    const {'1': 'igra_kontra', '3': 5, '4': 1, '5': 8, '10': 'igraKontra'},
    const {'1': 'valat_kontra', '3': 6, '4': 1, '5': 8, '10': 'valatKontra'},
    const {'1': 'barvni_valat_kontra', '3': 7, '4': 1, '5': 8, '10': 'barvniValatKontra'},
    const {'1': 'pagat_ultimo', '3': 8, '4': 1, '5': 8, '10': 'pagatUltimo'},
    const {'1': 'trula', '3': 9, '4': 1, '5': 8, '10': 'trula'},
    const {'1': 'kralji', '3': 10, '4': 1, '5': 8, '10': 'kralji'},
    const {'1': 'kralj_ultimo', '3': 11, '4': 1, '5': 8, '10': 'kraljUltimo'},
    const {'1': 'valat', '3': 12, '4': 1, '5': 8, '10': 'valat'},
    const {'1': 'barvni_valat', '3': 13, '4': 1, '5': 8, '10': 'barvniValat'},
    const {'1': 'mondfang', '3': 14, '4': 1, '5': 8, '10': 'mondfang'},
    const {'1': 'mondfang_kontra', '3': 15, '4': 1, '5': 8, '10': 'mondfangKontra'},
  ],
};

/// Descriptor for `StartPredictions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startPredictionsDescriptor = $convert.base64Decode('ChBTdGFydFByZWRpY3Rpb25zEi4KE2tyYWxqX3VsdGltb19rb250cmEYASABKAhSEWtyYWxqVWx0aW1vS29udHJhEi4KE3BhZ2F0X3VsdGltb19rb250cmEYBCABKAhSEXBhZ2F0VWx0aW1vS29udHJhEh8KC2lncmFfa29udHJhGAUgASgIUgppZ3JhS29udHJhEiEKDHZhbGF0X2tvbnRyYRgGIAEoCFILdmFsYXRLb250cmESLgoTYmFydm5pX3ZhbGF0X2tvbnRyYRgHIAEoCFIRYmFydm5pVmFsYXRLb250cmESIQoMcGFnYXRfdWx0aW1vGAggASgIUgtwYWdhdFVsdGltbxIUCgV0cnVsYRgJIAEoCFIFdHJ1bGESFgoGa3JhbGppGAogASgIUgZrcmFsamkSIQoMa3JhbGpfdWx0aW1vGAsgASgIUgtrcmFsalVsdGltbxIUCgV2YWxhdBgMIAEoCFIFdmFsYXQSIQoMYmFydm5pX3ZhbGF0GA0gASgIUgtiYXJ2bmlWYWxhdBIaCghtb25kZmFuZxgOIAEoCFIIbW9uZGZhbmcSJwoPbW9uZGZhbmdfa29udHJhGA8gASgIUg5tb25kZmFuZ0tvbnRyYQ==');
@$core.Deprecated('Use predictionsDescriptor instead')
const Predictions$json = const {
  '1': 'Predictions',
  '2': const [
    const {'1': 'kralj_ultimo', '3': 1, '4': 1, '5': 11, '6': '.game_messages.User', '10': 'kraljUltimo'},
    const {'1': 'kralj_ultimo_kontra', '3': 2, '4': 1, '5': 5, '10': 'kraljUltimoKontra'},
    const {'1': 'kralj_ultimo_kontra_dal', '3': 3, '4': 1, '5': 11, '6': '.game_messages.User', '10': 'kraljUltimoKontraDal'},
    const {'1': 'trula', '3': 4, '4': 1, '5': 11, '6': '.game_messages.User', '10': 'trula'},
    const {'1': 'kralji', '3': 7, '4': 1, '5': 11, '6': '.game_messages.User', '10': 'kralji'},
    const {'1': 'pagat_ultimo', '3': 10, '4': 1, '5': 11, '6': '.game_messages.User', '10': 'pagatUltimo'},
    const {'1': 'pagat_ultimo_kontra', '3': 11, '4': 1, '5': 5, '10': 'pagatUltimoKontra'},
    const {'1': 'pagat_ultimo_kontra_dal', '3': 12, '4': 1, '5': 11, '6': '.game_messages.User', '10': 'pagatUltimoKontraDal'},
    const {'1': 'igra', '3': 13, '4': 1, '5': 11, '6': '.game_messages.User', '10': 'igra'},
    const {'1': 'igra_kontra', '3': 14, '4': 1, '5': 5, '10': 'igraKontra'},
    const {'1': 'igra_kontra_dal', '3': 15, '4': 1, '5': 11, '6': '.game_messages.User', '10': 'igraKontraDal'},
    const {'1': 'valat', '3': 16, '4': 1, '5': 11, '6': '.game_messages.User', '10': 'valat'},
    const {'1': 'barvni_valat', '3': 17, '4': 1, '5': 11, '6': '.game_messages.User', '10': 'barvniValat'},
    const {'1': 'mondfang', '3': 18, '4': 1, '5': 11, '6': '.game_messages.User', '10': 'mondfang'},
    const {'1': 'mondfang_kontra', '3': 19, '4': 1, '5': 5, '10': 'mondfangKontra'},
    const {'1': 'mondfang_kontra_dal', '3': 20, '4': 1, '5': 11, '6': '.game_messages.User', '10': 'mondfangKontraDal'},
    const {'1': 'gamemode', '3': 22, '4': 1, '5': 5, '10': 'gamemode'},
    const {'1': 'changed', '3': 23, '4': 1, '5': 8, '10': 'changed'},
  ],
};

/// Descriptor for `Predictions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List predictionsDescriptor = $convert.base64Decode('CgtQcmVkaWN0aW9ucxI2CgxrcmFsal91bHRpbW8YASABKAsyEy5nYW1lX21lc3NhZ2VzLlVzZXJSC2tyYWxqVWx0aW1vEi4KE2tyYWxqX3VsdGltb19rb250cmEYAiABKAVSEWtyYWxqVWx0aW1vS29udHJhEkoKF2tyYWxqX3VsdGltb19rb250cmFfZGFsGAMgASgLMhMuZ2FtZV9tZXNzYWdlcy5Vc2VyUhRrcmFsalVsdGltb0tvbnRyYURhbBIpCgV0cnVsYRgEIAEoCzITLmdhbWVfbWVzc2FnZXMuVXNlclIFdHJ1bGESKwoGa3JhbGppGAcgASgLMhMuZ2FtZV9tZXNzYWdlcy5Vc2VyUgZrcmFsamkSNgoMcGFnYXRfdWx0aW1vGAogASgLMhMuZ2FtZV9tZXNzYWdlcy5Vc2VyUgtwYWdhdFVsdGltbxIuChNwYWdhdF91bHRpbW9fa29udHJhGAsgASgFUhFwYWdhdFVsdGltb0tvbnRyYRJKChdwYWdhdF91bHRpbW9fa29udHJhX2RhbBgMIAEoCzITLmdhbWVfbWVzc2FnZXMuVXNlclIUcGFnYXRVbHRpbW9Lb250cmFEYWwSJwoEaWdyYRgNIAEoCzITLmdhbWVfbWVzc2FnZXMuVXNlclIEaWdyYRIfCgtpZ3JhX2tvbnRyYRgOIAEoBVIKaWdyYUtvbnRyYRI7Cg9pZ3JhX2tvbnRyYV9kYWwYDyABKAsyEy5nYW1lX21lc3NhZ2VzLlVzZXJSDWlncmFLb250cmFEYWwSKQoFdmFsYXQYECABKAsyEy5nYW1lX21lc3NhZ2VzLlVzZXJSBXZhbGF0EjYKDGJhcnZuaV92YWxhdBgRIAEoCzITLmdhbWVfbWVzc2FnZXMuVXNlclILYmFydm5pVmFsYXQSLwoIbW9uZGZhbmcYEiABKAsyEy5nYW1lX21lc3NhZ2VzLlVzZXJSCG1vbmRmYW5nEicKD21vbmRmYW5nX2tvbnRyYRgTIAEoBVIObW9uZGZhbmdLb250cmESQwoTbW9uZGZhbmdfa29udHJhX2RhbBgUIAEoCzITLmdhbWVfbWVzc2FnZXMuVXNlclIRbW9uZGZhbmdLb250cmFEYWwSGgoIZ2FtZW1vZGUYFiABKAVSCGdhbWVtb2RlEhgKB2NoYW5nZWQYFyABKAhSB2NoYW5nZWQ=');
@$core.Deprecated('Use talonRevealDescriptor instead')
const TalonReveal$json = const {
  '1': 'TalonReveal',
  '2': const [
    const {'1': 'stih', '3': 1, '4': 3, '5': 11, '6': '.game_messages.Stih', '10': 'stih'},
  ],
};

/// Descriptor for `TalonReveal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List talonRevealDescriptor = $convert.base64Decode('CgtUYWxvblJldmVhbBInCgRzdGloGAEgAygLMhMuZ2FtZV9tZXNzYWdlcy5TdGloUgRzdGlo');
@$core.Deprecated('Use playingRevealDescriptor instead')
const PlayingReveal$json = const {
  '1': 'PlayingReveal',
  '2': const [
    const {'1': 'playing', '3': 1, '4': 1, '5': 11, '6': '.game_messages.User', '10': 'playing'},
  ],
};

/// Descriptor for `PlayingReveal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playingRevealDescriptor = $convert.base64Decode('Cg1QbGF5aW5nUmV2ZWFsEi0KB3BsYXlpbmcYASABKAsyEy5nYW1lX21lc3NhZ2VzLlVzZXJSB3BsYXlpbmc=');
@$core.Deprecated('Use invitePlayerDescriptor instead')
const InvitePlayer$json = const {
  '1': 'InvitePlayer',
};

/// Descriptor for `InvitePlayer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List invitePlayerDescriptor = $convert.base64Decode('CgxJbnZpdGVQbGF5ZXI=');
@$core.Deprecated('Use clearHandDescriptor instead')
const ClearHand$json = const {
  '1': 'ClearHand',
};

/// Descriptor for `ClearHand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearHandDescriptor = $convert.base64Decode('CglDbGVhckhhbmQ=');
@$core.Deprecated('Use timeDescriptor instead')
const Time$json = const {
  '1': 'Time',
  '2': const [
    const {'1': 'currentTime', '3': 1, '4': 1, '5': 2, '10': 'currentTime'},
    const {'1': 'start', '3': 2, '4': 1, '5': 8, '10': 'start'},
  ],
};

/// Descriptor for `Time`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timeDescriptor = $convert.base64Decode('CgRUaW1lEiAKC2N1cnJlbnRUaW1lGAEgASgCUgtjdXJyZW50VGltZRIUCgVzdGFydBgCIAEoCFIFc3RhcnQ=');
@$core.Deprecated('Use chatMessageDescriptor instead')
const ChatMessage$json = const {
  '1': 'ChatMessage',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `ChatMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatMessageDescriptor = $convert.base64Decode('CgtDaGF0TWVzc2FnZRIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSGAoHbWVzc2FnZRgCIAEoCVIHbWVzc2FnZQ==');
@$core.Deprecated('Use messageDescriptor instead')
const Message$json = const {
  '1': 'Message',
  '2': const [
    const {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
    const {'1': 'player_id', '3': 2, '4': 1, '5': 9, '10': 'playerId'},
    const {'1': 'silent', '3': 4, '4': 1, '5': 8, '10': 'silent'},
    const {'1': 'connection', '3': 10, '4': 1, '5': 11, '6': '.game_messages.Connection', '9': 0, '10': 'connection'},
    const {'1': 'licitiranje', '3': 11, '4': 1, '5': 11, '6': '.game_messages.Licitiranje', '9': 0, '10': 'licitiranje'},
    const {'1': 'card', '3': 12, '4': 1, '5': 11, '6': '.game_messages.Card', '9': 0, '10': 'card'},
    const {'1': 'licitiranje_start', '3': 13, '4': 1, '5': 11, '6': '.game_messages.LicitiranjeStart', '9': 0, '10': 'licitiranjeStart'},
    const {'1': 'game_start', '3': 14, '4': 1, '5': 11, '6': '.game_messages.GameStart', '9': 0, '10': 'gameStart'},
    const {'1': 'login_request', '3': 15, '4': 1, '5': 11, '6': '.game_messages.LoginRequest', '9': 0, '10': 'loginRequest'},
    const {'1': 'login_info', '3': 16, '4': 1, '5': 11, '6': '.game_messages.LoginInfo', '9': 0, '10': 'loginInfo'},
    const {'1': 'login_response', '3': 17, '4': 1, '5': 11, '6': '.game_messages.LoginResponse', '9': 0, '10': 'loginResponse'},
    const {'1': 'clear_desk', '3': 18, '4': 1, '5': 11, '6': '.game_messages.ClearDesk', '9': 0, '10': 'clearDesk'},
    const {'1': 'results', '3': 19, '4': 1, '5': 11, '6': '.game_messages.Results', '9': 0, '10': 'results'},
    const {'1': 'user_list', '3': 20, '4': 1, '5': 11, '6': '.game_messages.UserList', '9': 0, '10': 'userList'},
    const {'1': 'king_selection', '3': 21, '4': 1, '5': 11, '6': '.game_messages.KingSelection', '9': 0, '10': 'kingSelection'},
    const {'1': 'start_predictions', '3': 22, '4': 1, '5': 11, '6': '.game_messages.StartPredictions', '9': 0, '10': 'startPredictions'},
    const {'1': 'predictions', '3': 23, '4': 1, '5': 11, '6': '.game_messages.Predictions', '9': 0, '10': 'predictions'},
    const {'1': 'talon_reveal', '3': 24, '4': 1, '5': 11, '6': '.game_messages.TalonReveal', '9': 0, '10': 'talonReveal'},
    const {'1': 'playing_reveal', '3': 25, '4': 1, '5': 11, '6': '.game_messages.PlayingReveal', '9': 0, '10': 'playingReveal'},
    const {'1': 'talon_selection', '3': 26, '4': 1, '5': 11, '6': '.game_messages.TalonSelection', '9': 0, '10': 'talonSelection'},
    const {'1': 'stash', '3': 27, '4': 1, '5': 11, '6': '.game_messages.Stash', '9': 0, '10': 'stash'},
    const {'1': 'game_end', '3': 28, '4': 1, '5': 11, '6': '.game_messages.GameEnd', '9': 0, '10': 'gameEnd'},
    const {'1': 'game_start_countdown', '3': 29, '4': 1, '5': 11, '6': '.game_messages.GameStartCountdown', '9': 0, '10': 'gameStartCountdown'},
    const {'1': 'predictions_resend', '3': 30, '4': 1, '5': 11, '6': '.game_messages.Predictions', '9': 0, '10': 'predictionsResend'},
    const {'1': 'radelci', '3': 31, '4': 1, '5': 11, '6': '.game_messages.Radelci', '9': 0, '10': 'radelci'},
    const {'1': 'time', '3': 32, '4': 1, '5': 11, '6': '.game_messages.Time', '9': 0, '10': 'time'},
    const {'1': 'chat_message', '3': 33, '4': 1, '5': 11, '6': '.game_messages.ChatMessage', '9': 0, '10': 'chatMessage'},
    const {'1': 'invite_player', '3': 34, '4': 1, '5': 11, '6': '.game_messages.InvitePlayer', '9': 0, '10': 'invitePlayer'},
    const {'1': 'stashed_tarock', '3': 35, '4': 1, '5': 11, '6': '.game_messages.StashedTarock', '9': 0, '10': 'stashedTarock'},
    const {'1': 'clear_hand', '3': 36, '4': 1, '5': 11, '6': '.game_messages.ClearHand', '9': 0, '10': 'clearHand'},
    const {'1': 'replay_link', '3': 37, '4': 1, '5': 11, '6': '.game_messages.ReplayLink', '9': 0, '10': 'replayLink'},
    const {'1': 'replay_move', '3': 38, '4': 1, '5': 11, '6': '.game_messages.ReplayMove', '9': 0, '10': 'replayMove'},
    const {'1': 'replay_select_game', '3': 39, '4': 1, '5': 11, '6': '.game_messages.ReplaySelectGame', '9': 0, '10': 'replaySelectGame'},
    const {'1': 'game_info', '3': 40, '4': 1, '5': 11, '6': '.game_messages.GameInfo', '9': 0, '10': 'gameInfo'},
    const {'1': 'start_early', '3': 41, '4': 1, '5': 11, '6': '.game_messages.StartEarly', '9': 0, '10': 'startEarly'},
  ],
  '8': const [
    const {'1': 'data'},
  ],
};

/// Descriptor for `Message`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageDescriptor = $convert.base64Decode('CgdNZXNzYWdlEhoKCHVzZXJuYW1lGAEgASgJUgh1c2VybmFtZRIbCglwbGF5ZXJfaWQYAiABKAlSCHBsYXllcklkEhYKBnNpbGVudBgEIAEoCFIGc2lsZW50EjsKCmNvbm5lY3Rpb24YCiABKAsyGS5nYW1lX21lc3NhZ2VzLkNvbm5lY3Rpb25IAFIKY29ubmVjdGlvbhI+CgtsaWNpdGlyYW5qZRgLIAEoCzIaLmdhbWVfbWVzc2FnZXMuTGljaXRpcmFuamVIAFILbGljaXRpcmFuamUSKQoEY2FyZBgMIAEoCzITLmdhbWVfbWVzc2FnZXMuQ2FyZEgAUgRjYXJkEk4KEWxpY2l0aXJhbmplX3N0YXJ0GA0gASgLMh8uZ2FtZV9tZXNzYWdlcy5MaWNpdGlyYW5qZVN0YXJ0SABSEGxpY2l0aXJhbmplU3RhcnQSOQoKZ2FtZV9zdGFydBgOIAEoCzIYLmdhbWVfbWVzc2FnZXMuR2FtZVN0YXJ0SABSCWdhbWVTdGFydBJCCg1sb2dpbl9yZXF1ZXN0GA8gASgLMhsuZ2FtZV9tZXNzYWdlcy5Mb2dpblJlcXVlc3RIAFIMbG9naW5SZXF1ZXN0EjkKCmxvZ2luX2luZm8YECABKAsyGC5nYW1lX21lc3NhZ2VzLkxvZ2luSW5mb0gAUglsb2dpbkluZm8SRQoObG9naW5fcmVzcG9uc2UYESABKAsyHC5nYW1lX21lc3NhZ2VzLkxvZ2luUmVzcG9uc2VIAFINbG9naW5SZXNwb25zZRI5CgpjbGVhcl9kZXNrGBIgASgLMhguZ2FtZV9tZXNzYWdlcy5DbGVhckRlc2tIAFIJY2xlYXJEZXNrEjIKB3Jlc3VsdHMYEyABKAsyFi5nYW1lX21lc3NhZ2VzLlJlc3VsdHNIAFIHcmVzdWx0cxI2Cgl1c2VyX2xpc3QYFCABKAsyFy5nYW1lX21lc3NhZ2VzLlVzZXJMaXN0SABSCHVzZXJMaXN0EkUKDmtpbmdfc2VsZWN0aW9uGBUgASgLMhwuZ2FtZV9tZXNzYWdlcy5LaW5nU2VsZWN0aW9uSABSDWtpbmdTZWxlY3Rpb24STgoRc3RhcnRfcHJlZGljdGlvbnMYFiABKAsyHy5nYW1lX21lc3NhZ2VzLlN0YXJ0UHJlZGljdGlvbnNIAFIQc3RhcnRQcmVkaWN0aW9ucxI+CgtwcmVkaWN0aW9ucxgXIAEoCzIaLmdhbWVfbWVzc2FnZXMuUHJlZGljdGlvbnNIAFILcHJlZGljdGlvbnMSPwoMdGFsb25fcmV2ZWFsGBggASgLMhouZ2FtZV9tZXNzYWdlcy5UYWxvblJldmVhbEgAUgt0YWxvblJldmVhbBJFCg5wbGF5aW5nX3JldmVhbBgZIAEoCzIcLmdhbWVfbWVzc2FnZXMuUGxheWluZ1JldmVhbEgAUg1wbGF5aW5nUmV2ZWFsEkgKD3RhbG9uX3NlbGVjdGlvbhgaIAEoCzIdLmdhbWVfbWVzc2FnZXMuVGFsb25TZWxlY3Rpb25IAFIOdGFsb25TZWxlY3Rpb24SLAoFc3Rhc2gYGyABKAsyFC5nYW1lX21lc3NhZ2VzLlN0YXNoSABSBXN0YXNoEjMKCGdhbWVfZW5kGBwgASgLMhYuZ2FtZV9tZXNzYWdlcy5HYW1lRW5kSABSB2dhbWVFbmQSVQoUZ2FtZV9zdGFydF9jb3VudGRvd24YHSABKAsyIS5nYW1lX21lc3NhZ2VzLkdhbWVTdGFydENvdW50ZG93bkgAUhJnYW1lU3RhcnRDb3VudGRvd24SSwoScHJlZGljdGlvbnNfcmVzZW5kGB4gASgLMhouZ2FtZV9tZXNzYWdlcy5QcmVkaWN0aW9uc0gAUhFwcmVkaWN0aW9uc1Jlc2VuZBIyCgdyYWRlbGNpGB8gASgLMhYuZ2FtZV9tZXNzYWdlcy5SYWRlbGNpSABSB3JhZGVsY2kSKQoEdGltZRggIAEoCzITLmdhbWVfbWVzc2FnZXMuVGltZUgAUgR0aW1lEj8KDGNoYXRfbWVzc2FnZRghIAEoCzIaLmdhbWVfbWVzc2FnZXMuQ2hhdE1lc3NhZ2VIAFILY2hhdE1lc3NhZ2USQgoNaW52aXRlX3BsYXllchgiIAEoCzIbLmdhbWVfbWVzc2FnZXMuSW52aXRlUGxheWVySABSDGludml0ZVBsYXllchJFCg5zdGFzaGVkX3Rhcm9jaxgjIAEoCzIcLmdhbWVfbWVzc2FnZXMuU3Rhc2hlZFRhcm9ja0gAUg1zdGFzaGVkVGFyb2NrEjkKCmNsZWFyX2hhbmQYJCABKAsyGC5nYW1lX21lc3NhZ2VzLkNsZWFySGFuZEgAUgljbGVhckhhbmQSPAoLcmVwbGF5X2xpbmsYJSABKAsyGS5nYW1lX21lc3NhZ2VzLlJlcGxheUxpbmtIAFIKcmVwbGF5TGluaxI8CgtyZXBsYXlfbW92ZRgmIAEoCzIZLmdhbWVfbWVzc2FnZXMuUmVwbGF5TW92ZUgAUgpyZXBsYXlNb3ZlEk8KEnJlcGxheV9zZWxlY3RfZ2FtZRgnIAEoCzIfLmdhbWVfbWVzc2FnZXMuUmVwbGF5U2VsZWN0R2FtZUgAUhByZXBsYXlTZWxlY3RHYW1lEjYKCWdhbWVfaW5mbxgoIAEoCzIXLmdhbWVfbWVzc2FnZXMuR2FtZUluZm9IAFIIZ2FtZUluZm8SPAoLc3RhcnRfZWFybHkYKSABKAsyGS5nYW1lX21lc3NhZ2VzLlN0YXJ0RWFybHlIAFIKc3RhcnRFYXJseUIGCgRkYXRh');
