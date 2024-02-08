//
//  Generated code. Do not modify.
//  source: messages.proto
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
    {'1': 'ok', '3': 1, '4': 1, '5': 11, '6': '.game_messages.LoginResponse.OK', '9': 0, '10': 'ok'},
    {'1': 'fail', '3': 2, '4': 1, '5': 11, '6': '.game_messages.LoginResponse.Fail', '9': 0, '10': 'fail'},
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
    'Cg1Mb2dpblJlc3BvbnNlEjEKAm9rGAEgASgLMh8uZ2FtZV9tZXNzYWdlcy5Mb2dpblJlc3Bvbn'
    'NlLk9LSABSAm9rEjcKBGZhaWwYAiABKAsyIS5nYW1lX21lc3NhZ2VzLkxvZ2luUmVzcG9uc2Uu'
    'RmFpbEgAUgRmYWlsGgQKAk9LGgYKBEZhaWxCBgoEdHlwZQ==');

@$core.Deprecated('Use connectDescriptor instead')
const Connect$json = {
  '1': 'Connect',
};

/// Descriptor for `Connect`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectDescriptor = $convert.base64Decode(
    'CgdDb25uZWN0');

@$core.Deprecated('Use disconnectDescriptor instead')
const Disconnect$json = {
  '1': 'Disconnect',
};

/// Descriptor for `Disconnect`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disconnectDescriptor = $convert.base64Decode(
    'CgpEaXNjb25uZWN0');

@$core.Deprecated('Use receiveDescriptor instead')
const Receive$json = {
  '1': 'Receive',
};

/// Descriptor for `Receive`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List receiveDescriptor = $convert.base64Decode(
    'CgdSZWNlaXZl');

@$core.Deprecated('Use sendDescriptor instead')
const Send$json = {
  '1': 'Send',
};

/// Descriptor for `Send`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendDescriptor = $convert.base64Decode(
    'CgRTZW5k');

@$core.Deprecated('Use requestDescriptor instead')
const Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'count', '3': 1, '4': 1, '5': 5, '10': 'count'},
  ],
};

/// Descriptor for `Request`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestDescriptor = $convert.base64Decode(
    'CgdSZXF1ZXN0EhQKBWNvdW50GAEgASgFUgVjb3VudA==');

@$core.Deprecated('Use removeDescriptor instead')
const Remove$json = {
  '1': 'Remove',
};

/// Descriptor for `Remove`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeDescriptor = $convert.base64Decode(
    'CgZSZW1vdmU=');

@$core.Deprecated('Use clearDeskDescriptor instead')
const ClearDesk$json = {
  '1': 'ClearDesk',
};

/// Descriptor for `ClearDesk`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearDeskDescriptor = $convert.base64Decode(
    'CglDbGVhckRlc2s=');

@$core.Deprecated('Use notificationDescriptor instead')
const Notification$json = {
  '1': 'Notification',
};

/// Descriptor for `Notification`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationDescriptor = $convert.base64Decode(
    'CgxOb3RpZmljYXRpb24=');

@$core.Deprecated('Use leaveDescriptor instead')
const Leave$json = {
  '1': 'Leave',
};

/// Descriptor for `Leave`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List leaveDescriptor = $convert.base64Decode(
    'CgVMZWF2ZQ==');

@$core.Deprecated('Use replayLinkDescriptor instead')
const ReplayLink$json = {
  '1': 'ReplayLink',
  '2': [
    {'1': 'replay', '3': 1, '4': 1, '5': 9, '10': 'replay'},
  ],
};

/// Descriptor for `ReplayLink`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List replayLinkDescriptor = $convert.base64Decode(
    'CgpSZXBsYXlMaW5rEhYKBnJlcGxheRgBIAEoCVIGcmVwbGF5');

@$core.Deprecated('Use replayMoveDescriptor instead')
const ReplayMove$json = {
  '1': 'ReplayMove',
};

/// Descriptor for `ReplayMove`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List replayMoveDescriptor = $convert.base64Decode(
    'CgpSZXBsYXlNb3Zl');

@$core.Deprecated('Use replaySelectGameDescriptor instead')
const ReplaySelectGame$json = {
  '1': 'ReplaySelectGame',
  '2': [
    {'1': 'game', '3': 1, '4': 1, '5': 5, '10': 'game'},
  ],
};

/// Descriptor for `ReplaySelectGame`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List replaySelectGameDescriptor = $convert.base64Decode(
    'ChBSZXBsYXlTZWxlY3RHYW1lEhIKBGdhbWUYASABKAVSBGdhbWU=');

@$core.Deprecated('Use startEarlyDescriptor instead')
const StartEarly$json = {
  '1': 'StartEarly',
};

/// Descriptor for `StartEarly`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startEarlyDescriptor = $convert.base64Decode(
    'CgpTdGFydEVhcmx5');

@$core.Deprecated('Use gameInfoDescriptor instead')
const GameInfo$json = {
  '1': 'GameInfo',
  '2': [
    {'1': 'gamesPlayed', '3': 1, '4': 1, '5': 5, '10': 'gamesPlayed'},
    {'1': 'gamesRequired', '3': 2, '4': 1, '5': 5, '10': 'gamesRequired'},
    {'1': 'canExtendGame', '3': 3, '4': 1, '5': 8, '10': 'canExtendGame'},
  ],
};

/// Descriptor for `GameInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameInfoDescriptor = $convert.base64Decode(
    'CghHYW1lSW5mbxIgCgtnYW1lc1BsYXllZBgBIAEoBVILZ2FtZXNQbGF5ZWQSJAoNZ2FtZXNSZX'
    'F1aXJlZBgCIAEoBVINZ2FtZXNSZXF1aXJlZBIkCg1jYW5FeHRlbmRHYW1lGAMgASgIUg1jYW5F'
    'eHRlbmRHYW1l');

@$core.Deprecated('Use gameEndDescriptor instead')
const GameEnd$json = {
  '1': 'GameEnd',
  '2': [
    {'1': 'results', '3': 1, '4': 1, '5': 11, '6': '.game_messages.Results', '9': 0, '10': 'results'},
    {'1': 'request', '3': 2, '4': 1, '5': 11, '6': '.game_messages.Request', '9': 0, '10': 'request'},
  ],
  '8': [
    {'1': 'type'},
  ],
};

/// Descriptor for `GameEnd`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameEndDescriptor = $convert.base64Decode(
    'CgdHYW1lRW5kEjIKB3Jlc3VsdHMYASABKAsyFi5nYW1lX21lc3NhZ2VzLlJlc3VsdHNIAFIHcm'
    'VzdWx0cxIyCgdyZXF1ZXN0GAIgASgLMhYuZ2FtZV9tZXNzYWdlcy5SZXF1ZXN0SABSB3JlcXVl'
    'c3RCBgoEdHlwZQ==');

@$core.Deprecated('Use connectionDescriptor instead')
const Connection$json = {
  '1': 'Connection',
  '2': [
    {'1': 'custom_profile_picture', '3': 1, '4': 1, '5': 8, '10': 'customProfilePicture'},
    {'1': 'rating', '3': 2, '4': 1, '5': 5, '10': 'rating'},
    {'1': 'join', '3': 3, '4': 1, '5': 11, '6': '.game_messages.Connect', '9': 0, '10': 'join'},
    {'1': 'disconnect', '3': 4, '4': 1, '5': 11, '6': '.game_messages.Disconnect', '9': 0, '10': 'disconnect'},
    {'1': 'leave', '3': 5, '4': 1, '5': 11, '6': '.game_messages.Leave', '9': 0, '10': 'leave'},
  ],
  '8': [
    {'1': 'type'},
  ],
};

/// Descriptor for `Connection`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectionDescriptor = $convert.base64Decode(
    'CgpDb25uZWN0aW9uEjQKFmN1c3RvbV9wcm9maWxlX3BpY3R1cmUYASABKAhSFGN1c3RvbVByb2'
    'ZpbGVQaWN0dXJlEhYKBnJhdGluZxgCIAEoBVIGcmF0aW5nEiwKBGpvaW4YAyABKAsyFi5nYW1l'
    'X21lc3NhZ2VzLkNvbm5lY3RIAFIEam9pbhI7CgpkaXNjb25uZWN0GAQgASgLMhkuZ2FtZV9tZX'
    'NzYWdlcy5EaXNjb25uZWN0SABSCmRpc2Nvbm5lY3QSLAoFbGVhdmUYBSABKAsyFC5nYW1lX21l'
    'c3NhZ2VzLkxlYXZlSABSBWxlYXZlQgYKBHR5cGU=');

@$core.Deprecated('Use licitiranjeDescriptor instead')
const Licitiranje$json = {
  '1': 'Licitiranje',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 5, '10': 'type'},
  ],
};

/// Descriptor for `Licitiranje`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List licitiranjeDescriptor = $convert.base64Decode(
    'CgtMaWNpdGlyYW5qZRISCgR0eXBlGAEgASgFUgR0eXBl');

@$core.Deprecated('Use licitiranjeStartDescriptor instead')
const LicitiranjeStart$json = {
  '1': 'LicitiranjeStart',
};

/// Descriptor for `LicitiranjeStart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List licitiranjeStartDescriptor = $convert.base64Decode(
    'ChBMaWNpdGlyYW5qZVN0YXJ0');

@$core.Deprecated('Use cardDescriptor instead')
const Card$json = {
  '1': 'Card',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'userId', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'receive', '3': 3, '4': 1, '5': 11, '6': '.game_messages.Receive', '9': 0, '10': 'receive'},
    {'1': 'send', '3': 4, '4': 1, '5': 11, '6': '.game_messages.Send', '9': 0, '10': 'send'},
    {'1': 'request', '3': 5, '4': 1, '5': 11, '6': '.game_messages.Request', '9': 0, '10': 'request'},
    {'1': 'remove', '3': 6, '4': 1, '5': 11, '6': '.game_messages.Remove', '9': 0, '10': 'remove'},
  ],
  '8': [
    {'1': 'type'},
  ],
};

/// Descriptor for `Card`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cardDescriptor = $convert.base64Decode(
    'CgRDYXJkEg4KAmlkGAEgASgJUgJpZBIWCgZ1c2VySWQYAiABKAlSBnVzZXJJZBIyCgdyZWNlaX'
    'ZlGAMgASgLMhYuZ2FtZV9tZXNzYWdlcy5SZWNlaXZlSABSB3JlY2VpdmUSKQoEc2VuZBgEIAEo'
    'CzITLmdhbWVfbWVzc2FnZXMuU2VuZEgAUgRzZW5kEjIKB3JlcXVlc3QYBSABKAsyFi5nYW1lX2'
    '1lc3NhZ2VzLlJlcXVlc3RIAFIHcmVxdWVzdBIvCgZyZW1vdmUYBiABKAsyFS5nYW1lX21lc3Nh'
    'Z2VzLlJlbW92ZUgAUgZyZW1vdmVCBgoEdHlwZQ==');

@$core.Deprecated('Use gameStartCountdownDescriptor instead')
const GameStartCountdown$json = {
  '1': 'GameStartCountdown',
  '2': [
    {'1': 'countdown', '3': 1, '4': 1, '5': 5, '10': 'countdown'},
  ],
};

/// Descriptor for `GameStartCountdown`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameStartCountdownDescriptor = $convert.base64Decode(
    'ChJHYW1lU3RhcnRDb3VudGRvd24SHAoJY291bnRkb3duGAEgASgFUgljb3VudGRvd24=');

@$core.Deprecated('Use userDescriptor instead')
const User$json = {
  '1': 'User',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'position', '3': 3, '4': 1, '5': 5, '10': 'position'},
    {'1': 'customProfilePicture', '3': 4, '4': 1, '5': 8, '10': 'customProfilePicture'},
  ],
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode(
    'CgRVc2VyEg4KAmlkGAEgASgJUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEhoKCHBvc2l0aW9uGA'
    'MgASgFUghwb3NpdGlvbhIyChRjdXN0b21Qcm9maWxlUGljdHVyZRgEIAEoCFIUY3VzdG9tUHJv'
    'ZmlsZVBpY3R1cmU=');

@$core.Deprecated('Use resultsUserDescriptor instead')
const ResultsUser$json = {
  '1': 'ResultsUser',
  '2': [
    {'1': 'user', '3': 1, '4': 3, '5': 11, '6': '.game_messages.User', '10': 'user'},
    {'1': 'playing', '3': 2, '4': 1, '5': 8, '10': 'playing'},
    {'1': 'points', '3': 3, '4': 1, '5': 5, '10': 'points'},
    {'1': 'trula', '3': 4, '4': 1, '5': 5, '10': 'trula'},
    {'1': 'pagat', '3': 5, '4': 1, '5': 5, '10': 'pagat'},
    {'1': 'igra', '3': 6, '4': 1, '5': 5, '10': 'igra'},
    {'1': 'razlika', '3': 7, '4': 1, '5': 5, '10': 'razlika'},
    {'1': 'kralj', '3': 8, '4': 1, '5': 5, '10': 'kralj'},
    {'1': 'kralji', '3': 9, '4': 1, '5': 5, '10': 'kralji'},
    {'1': 'kontra_pagat', '3': 10, '4': 1, '5': 5, '10': 'kontraPagat'},
    {'1': 'kontra_igra', '3': 11, '4': 1, '5': 5, '10': 'kontraIgra'},
    {'1': 'kontra_kralj', '3': 12, '4': 1, '5': 5, '10': 'kontraKralj'},
    {'1': 'kontra_mondfang', '3': 13, '4': 1, '5': 5, '10': 'kontraMondfang'},
    {'1': 'mondfang', '3': 14, '4': 1, '5': 8, '10': 'mondfang'},
    {'1': 'show_gamemode', '3': 15, '4': 1, '5': 8, '10': 'showGamemode'},
    {'1': 'show_difference', '3': 16, '4': 1, '5': 8, '10': 'showDifference'},
    {'1': 'show_kralj', '3': 17, '4': 1, '5': 8, '10': 'showKralj'},
    {'1': 'show_pagat', '3': 18, '4': 1, '5': 8, '10': 'showPagat'},
    {'1': 'show_kralji', '3': 19, '4': 1, '5': 8, '10': 'showKralji'},
    {'1': 'show_trula', '3': 20, '4': 1, '5': 8, '10': 'showTrula'},
    {'1': 'radelc', '3': 21, '4': 1, '5': 8, '10': 'radelc'},
    {'1': 'skisfang', '3': 22, '4': 1, '5': 8, '10': 'skisfang'},
    {'1': 'rating_delta', '3': 23, '4': 1, '5': 5, '10': 'ratingDelta'},
  ],
};

/// Descriptor for `ResultsUser`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resultsUserDescriptor = $convert.base64Decode(
    'CgtSZXN1bHRzVXNlchInCgR1c2VyGAEgAygLMhMuZ2FtZV9tZXNzYWdlcy5Vc2VyUgR1c2VyEh'
    'gKB3BsYXlpbmcYAiABKAhSB3BsYXlpbmcSFgoGcG9pbnRzGAMgASgFUgZwb2ludHMSFAoFdHJ1'
    'bGEYBCABKAVSBXRydWxhEhQKBXBhZ2F0GAUgASgFUgVwYWdhdBISCgRpZ3JhGAYgASgFUgRpZ3'
    'JhEhgKB3Jhemxpa2EYByABKAVSB3Jhemxpa2ESFAoFa3JhbGoYCCABKAVSBWtyYWxqEhYKBmty'
    'YWxqaRgJIAEoBVIGa3JhbGppEiEKDGtvbnRyYV9wYWdhdBgKIAEoBVILa29udHJhUGFnYXQSHw'
    'oLa29udHJhX2lncmEYCyABKAVSCmtvbnRyYUlncmESIQoMa29udHJhX2tyYWxqGAwgASgFUgtr'
    'b250cmFLcmFsahInCg9rb250cmFfbW9uZGZhbmcYDSABKAVSDmtvbnRyYU1vbmRmYW5nEhoKCG'
    '1vbmRmYW5nGA4gASgIUghtb25kZmFuZxIjCg1zaG93X2dhbWVtb2RlGA8gASgIUgxzaG93R2Ft'
    'ZW1vZGUSJwoPc2hvd19kaWZmZXJlbmNlGBAgASgIUg5zaG93RGlmZmVyZW5jZRIdCgpzaG93X2'
    'tyYWxqGBEgASgIUglzaG93S3JhbGoSHQoKc2hvd19wYWdhdBgSIAEoCFIJc2hvd1BhZ2F0Eh8K'
    'C3Nob3dfa3JhbGppGBMgASgIUgpzaG93S3JhbGppEh0KCnNob3dfdHJ1bGEYFCABKAhSCXNob3'
    'dUcnVsYRIWCgZyYWRlbGMYFSABKAhSBnJhZGVsYxIaCghza2lzZmFuZxgWIAEoCFIIc2tpc2Zh'
    'bmcSIQoMcmF0aW5nX2RlbHRhGBcgASgFUgtyYXRpbmdEZWx0YQ==');

@$core.Deprecated('Use stihDescriptor instead')
const Stih$json = {
  '1': 'Stih',
  '2': [
    {'1': 'card', '3': 1, '4': 3, '5': 11, '6': '.game_messages.Card', '10': 'card'},
    {'1': 'worth', '3': 2, '4': 1, '5': 2, '10': 'worth'},
    {'1': 'pickedUpByPlaying', '3': 3, '4': 1, '5': 8, '10': 'pickedUpByPlaying'},
    {'1': 'pickedUpBy', '3': 4, '4': 1, '5': 9, '10': 'pickedUpBy'},
  ],
};

/// Descriptor for `Stih`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stihDescriptor = $convert.base64Decode(
    'CgRTdGloEicKBGNhcmQYASADKAsyEy5nYW1lX21lc3NhZ2VzLkNhcmRSBGNhcmQSFAoFd29ydG'
    'gYAiABKAJSBXdvcnRoEiwKEXBpY2tlZFVwQnlQbGF5aW5nGAMgASgIUhFwaWNrZWRVcEJ5UGxh'
    'eWluZxIeCgpwaWNrZWRVcEJ5GAQgASgJUgpwaWNrZWRVcEJ5');

@$core.Deprecated('Use resultsDescriptor instead')
const Results$json = {
  '1': 'Results',
  '2': [
    {'1': 'user', '3': 1, '4': 3, '5': 11, '6': '.game_messages.ResultsUser', '10': 'user'},
    {'1': 'stih', '3': 2, '4': 3, '5': 11, '6': '.game_messages.Stih', '10': 'stih'},
    {'1': 'predictions', '3': 3, '4': 1, '5': 11, '6': '.game_messages.Predictions', '10': 'predictions'},
  ],
};

/// Descriptor for `Results`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resultsDescriptor = $convert.base64Decode(
    'CgdSZXN1bHRzEi4KBHVzZXIYASADKAsyGi5nYW1lX21lc3NhZ2VzLlJlc3VsdHNVc2VyUgR1c2'
    'VyEicKBHN0aWgYAiADKAsyEy5nYW1lX21lc3NhZ2VzLlN0aWhSBHN0aWgSPAoLcHJlZGljdGlv'
    'bnMYAyABKAsyGi5nYW1lX21lc3NhZ2VzLlByZWRpY3Rpb25zUgtwcmVkaWN0aW9ucw==');

@$core.Deprecated('Use gameStartDescriptor instead')
const GameStart$json = {
  '1': 'GameStart',
  '2': [
    {'1': 'user', '3': 1, '4': 3, '5': 11, '6': '.game_messages.User', '10': 'user'},
  ],
};

/// Descriptor for `GameStart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameStartDescriptor = $convert.base64Decode(
    'CglHYW1lU3RhcnQSJwoEdXNlchgBIAMoCzITLmdhbWVfbWVzc2FnZXMuVXNlclIEdXNlcg==');

@$core.Deprecated('Use userListDescriptor instead')
const UserList$json = {
  '1': 'UserList',
  '2': [
    {'1': 'user', '3': 1, '4': 3, '5': 11, '6': '.game_messages.User', '10': 'user'},
  ],
};

/// Descriptor for `UserList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userListDescriptor = $convert.base64Decode(
    'CghVc2VyTGlzdBInCgR1c2VyGAEgAygLMhMuZ2FtZV9tZXNzYWdlcy5Vc2VyUgR1c2Vy');

@$core.Deprecated('Use kingSelectionDescriptor instead')
const KingSelection$json = {
  '1': 'KingSelection',
  '2': [
    {'1': 'card', '3': 1, '4': 1, '5': 9, '10': 'card'},
    {'1': 'request', '3': 2, '4': 1, '5': 11, '6': '.game_messages.Request', '9': 0, '10': 'request'},
    {'1': 'send', '3': 3, '4': 1, '5': 11, '6': '.game_messages.Send', '9': 0, '10': 'send'},
    {'1': 'notification', '3': 4, '4': 1, '5': 11, '6': '.game_messages.Notification', '9': 0, '10': 'notification'},
  ],
  '8': [
    {'1': 'type'},
  ],
};

/// Descriptor for `KingSelection`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List kingSelectionDescriptor = $convert.base64Decode(
    'Cg1LaW5nU2VsZWN0aW9uEhIKBGNhcmQYASABKAlSBGNhcmQSMgoHcmVxdWVzdBgCIAEoCzIWLm'
    'dhbWVfbWVzc2FnZXMuUmVxdWVzdEgAUgdyZXF1ZXN0EikKBHNlbmQYAyABKAsyEy5nYW1lX21l'
    'c3NhZ2VzLlNlbmRIAFIEc2VuZBJBCgxub3RpZmljYXRpb24YBCABKAsyGy5nYW1lX21lc3NhZ2'
    'VzLk5vdGlmaWNhdGlvbkgAUgxub3RpZmljYXRpb25CBgoEdHlwZQ==');

@$core.Deprecated('Use talonSelectionDescriptor instead')
const TalonSelection$json = {
  '1': 'TalonSelection',
  '2': [
    {'1': 'part', '3': 1, '4': 1, '5': 5, '10': 'part'},
    {'1': 'request', '3': 2, '4': 1, '5': 11, '6': '.game_messages.Request', '9': 0, '10': 'request'},
    {'1': 'send', '3': 3, '4': 1, '5': 11, '6': '.game_messages.Send', '9': 0, '10': 'send'},
    {'1': 'notification', '3': 4, '4': 1, '5': 11, '6': '.game_messages.Notification', '9': 0, '10': 'notification'},
  ],
  '8': [
    {'1': 'type'},
  ],
};

/// Descriptor for `TalonSelection`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List talonSelectionDescriptor = $convert.base64Decode(
    'Cg5UYWxvblNlbGVjdGlvbhISCgRwYXJ0GAEgASgFUgRwYXJ0EjIKB3JlcXVlc3QYAiABKAsyFi'
    '5nYW1lX21lc3NhZ2VzLlJlcXVlc3RIAFIHcmVxdWVzdBIpCgRzZW5kGAMgASgLMhMuZ2FtZV9t'
    'ZXNzYWdlcy5TZW5kSABSBHNlbmQSQQoMbm90aWZpY2F0aW9uGAQgASgLMhsuZ2FtZV9tZXNzYW'
    'dlcy5Ob3RpZmljYXRpb25IAFIMbm90aWZpY2F0aW9uQgYKBHR5cGU=');

@$core.Deprecated('Use stashDescriptor instead')
const Stash$json = {
  '1': 'Stash',
  '2': [
    {'1': 'card', '3': 1, '4': 3, '5': 11, '6': '.game_messages.Card', '10': 'card'},
    {'1': 'length', '3': 2, '4': 1, '5': 5, '10': 'length'},
    {'1': 'request', '3': 3, '4': 1, '5': 11, '6': '.game_messages.Request', '9': 0, '10': 'request'},
    {'1': 'send', '3': 4, '4': 1, '5': 11, '6': '.game_messages.Send', '9': 0, '10': 'send'},
    {'1': 'notification', '3': 5, '4': 1, '5': 11, '6': '.game_messages.Notification', '9': 0, '10': 'notification'},
  ],
  '8': [
    {'1': 'type'},
  ],
};

/// Descriptor for `Stash`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stashDescriptor = $convert.base64Decode(
    'CgVTdGFzaBInCgRjYXJkGAEgAygLMhMuZ2FtZV9tZXNzYWdlcy5DYXJkUgRjYXJkEhYKBmxlbm'
    'd0aBgCIAEoBVIGbGVuZ3RoEjIKB3JlcXVlc3QYAyABKAsyFi5nYW1lX21lc3NhZ2VzLlJlcXVl'
    'c3RIAFIHcmVxdWVzdBIpCgRzZW5kGAQgASgLMhMuZ2FtZV9tZXNzYWdlcy5TZW5kSABSBHNlbm'
    'QSQQoMbm90aWZpY2F0aW9uGAUgASgLMhsuZ2FtZV9tZXNzYWdlcy5Ob3RpZmljYXRpb25IAFIM'
    'bm90aWZpY2F0aW9uQgYKBHR5cGU=');

@$core.Deprecated('Use stashedTarockDescriptor instead')
const StashedTarock$json = {
  '1': 'StashedTarock',
  '2': [
    {'1': 'card', '3': 1, '4': 1, '5': 11, '6': '.game_messages.Card', '10': 'card'},
  ],
};

/// Descriptor for `StashedTarock`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stashedTarockDescriptor = $convert.base64Decode(
    'Cg1TdGFzaGVkVGFyb2NrEicKBGNhcmQYASABKAsyEy5nYW1lX21lc3NhZ2VzLkNhcmRSBGNhcm'
    'Q=');

@$core.Deprecated('Use radelciDescriptor instead')
const Radelci$json = {
  '1': 'Radelci',
  '2': [
    {'1': 'radleci', '3': 1, '4': 1, '5': 5, '10': 'radleci'},
  ],
};

/// Descriptor for `Radelci`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List radelciDescriptor = $convert.base64Decode(
    'CgdSYWRlbGNpEhgKB3JhZGxlY2kYASABKAVSB3JhZGxlY2k=');

@$core.Deprecated('Use startPredictionsDescriptor instead')
const StartPredictions$json = {
  '1': 'StartPredictions',
  '2': [
    {'1': 'kralj_ultimo_kontra', '3': 1, '4': 1, '5': 8, '10': 'kraljUltimoKontra'},
    {'1': 'pagat_ultimo_kontra', '3': 4, '4': 1, '5': 8, '10': 'pagatUltimoKontra'},
    {'1': 'igra_kontra', '3': 5, '4': 1, '5': 8, '10': 'igraKontra'},
    {'1': 'valat_kontra', '3': 6, '4': 1, '5': 8, '10': 'valatKontra'},
    {'1': 'barvni_valat_kontra', '3': 7, '4': 1, '5': 8, '10': 'barvniValatKontra'},
    {'1': 'pagat_ultimo', '3': 8, '4': 1, '5': 8, '10': 'pagatUltimo'},
    {'1': 'trula', '3': 9, '4': 1, '5': 8, '10': 'trula'},
    {'1': 'kralji', '3': 10, '4': 1, '5': 8, '10': 'kralji'},
    {'1': 'kralj_ultimo', '3': 11, '4': 1, '5': 8, '10': 'kraljUltimo'},
    {'1': 'valat', '3': 12, '4': 1, '5': 8, '10': 'valat'},
    {'1': 'barvni_valat', '3': 13, '4': 1, '5': 8, '10': 'barvniValat'},
    {'1': 'mondfang', '3': 14, '4': 1, '5': 8, '10': 'mondfang'},
    {'1': 'mondfang_kontra', '3': 15, '4': 1, '5': 8, '10': 'mondfangKontra'},
  ],
};

/// Descriptor for `StartPredictions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startPredictionsDescriptor = $convert.base64Decode(
    'ChBTdGFydFByZWRpY3Rpb25zEi4KE2tyYWxqX3VsdGltb19rb250cmEYASABKAhSEWtyYWxqVW'
    'x0aW1vS29udHJhEi4KE3BhZ2F0X3VsdGltb19rb250cmEYBCABKAhSEXBhZ2F0VWx0aW1vS29u'
    'dHJhEh8KC2lncmFfa29udHJhGAUgASgIUgppZ3JhS29udHJhEiEKDHZhbGF0X2tvbnRyYRgGIA'
    'EoCFILdmFsYXRLb250cmESLgoTYmFydm5pX3ZhbGF0X2tvbnRyYRgHIAEoCFIRYmFydm5pVmFs'
    'YXRLb250cmESIQoMcGFnYXRfdWx0aW1vGAggASgIUgtwYWdhdFVsdGltbxIUCgV0cnVsYRgJIA'
    'EoCFIFdHJ1bGESFgoGa3JhbGppGAogASgIUgZrcmFsamkSIQoMa3JhbGpfdWx0aW1vGAsgASgI'
    'UgtrcmFsalVsdGltbxIUCgV2YWxhdBgMIAEoCFIFdmFsYXQSIQoMYmFydm5pX3ZhbGF0GA0gAS'
    'gIUgtiYXJ2bmlWYWxhdBIaCghtb25kZmFuZxgOIAEoCFIIbW9uZGZhbmcSJwoPbW9uZGZhbmdf'
    'a29udHJhGA8gASgIUg5tb25kZmFuZ0tvbnRyYQ==');

@$core.Deprecated('Use predictionsDescriptor instead')
const Predictions$json = {
  '1': 'Predictions',
  '2': [
    {'1': 'kralj_ultimo', '3': 1, '4': 1, '5': 11, '6': '.game_messages.User', '10': 'kraljUltimo'},
    {'1': 'kralj_ultimo_kontra', '3': 2, '4': 1, '5': 5, '10': 'kraljUltimoKontra'},
    {'1': 'kralj_ultimo_kontra_dal', '3': 3, '4': 1, '5': 11, '6': '.game_messages.User', '10': 'kraljUltimoKontraDal'},
    {'1': 'trula', '3': 4, '4': 1, '5': 11, '6': '.game_messages.User', '10': 'trula'},
    {'1': 'kralji', '3': 7, '4': 1, '5': 11, '6': '.game_messages.User', '10': 'kralji'},
    {'1': 'pagat_ultimo', '3': 10, '4': 1, '5': 11, '6': '.game_messages.User', '10': 'pagatUltimo'},
    {'1': 'pagat_ultimo_kontra', '3': 11, '4': 1, '5': 5, '10': 'pagatUltimoKontra'},
    {'1': 'pagat_ultimo_kontra_dal', '3': 12, '4': 1, '5': 11, '6': '.game_messages.User', '10': 'pagatUltimoKontraDal'},
    {'1': 'igra', '3': 13, '4': 1, '5': 11, '6': '.game_messages.User', '10': 'igra'},
    {'1': 'igra_kontra', '3': 14, '4': 1, '5': 5, '10': 'igraKontra'},
    {'1': 'igra_kontra_dal', '3': 15, '4': 1, '5': 11, '6': '.game_messages.User', '10': 'igraKontraDal'},
    {'1': 'valat', '3': 16, '4': 1, '5': 11, '6': '.game_messages.User', '10': 'valat'},
    {'1': 'barvni_valat', '3': 17, '4': 1, '5': 11, '6': '.game_messages.User', '10': 'barvniValat'},
    {'1': 'mondfang', '3': 18, '4': 1, '5': 11, '6': '.game_messages.User', '10': 'mondfang'},
    {'1': 'mondfang_kontra', '3': 19, '4': 1, '5': 5, '10': 'mondfangKontra'},
    {'1': 'mondfang_kontra_dal', '3': 20, '4': 1, '5': 11, '6': '.game_messages.User', '10': 'mondfangKontraDal'},
    {'1': 'gamemode', '3': 22, '4': 1, '5': 5, '10': 'gamemode'},
    {'1': 'changed', '3': 23, '4': 1, '5': 8, '10': 'changed'},
  ],
};

/// Descriptor for `Predictions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List predictionsDescriptor = $convert.base64Decode(
    'CgtQcmVkaWN0aW9ucxI2CgxrcmFsal91bHRpbW8YASABKAsyEy5nYW1lX21lc3NhZ2VzLlVzZX'
    'JSC2tyYWxqVWx0aW1vEi4KE2tyYWxqX3VsdGltb19rb250cmEYAiABKAVSEWtyYWxqVWx0aW1v'
    'S29udHJhEkoKF2tyYWxqX3VsdGltb19rb250cmFfZGFsGAMgASgLMhMuZ2FtZV9tZXNzYWdlcy'
    '5Vc2VyUhRrcmFsalVsdGltb0tvbnRyYURhbBIpCgV0cnVsYRgEIAEoCzITLmdhbWVfbWVzc2Fn'
    'ZXMuVXNlclIFdHJ1bGESKwoGa3JhbGppGAcgASgLMhMuZ2FtZV9tZXNzYWdlcy5Vc2VyUgZrcm'
    'FsamkSNgoMcGFnYXRfdWx0aW1vGAogASgLMhMuZ2FtZV9tZXNzYWdlcy5Vc2VyUgtwYWdhdFVs'
    'dGltbxIuChNwYWdhdF91bHRpbW9fa29udHJhGAsgASgFUhFwYWdhdFVsdGltb0tvbnRyYRJKCh'
    'dwYWdhdF91bHRpbW9fa29udHJhX2RhbBgMIAEoCzITLmdhbWVfbWVzc2FnZXMuVXNlclIUcGFn'
    'YXRVbHRpbW9Lb250cmFEYWwSJwoEaWdyYRgNIAEoCzITLmdhbWVfbWVzc2FnZXMuVXNlclIEaW'
    'dyYRIfCgtpZ3JhX2tvbnRyYRgOIAEoBVIKaWdyYUtvbnRyYRI7Cg9pZ3JhX2tvbnRyYV9kYWwY'
    'DyABKAsyEy5nYW1lX21lc3NhZ2VzLlVzZXJSDWlncmFLb250cmFEYWwSKQoFdmFsYXQYECABKA'
    'syEy5nYW1lX21lc3NhZ2VzLlVzZXJSBXZhbGF0EjYKDGJhcnZuaV92YWxhdBgRIAEoCzITLmdh'
    'bWVfbWVzc2FnZXMuVXNlclILYmFydm5pVmFsYXQSLwoIbW9uZGZhbmcYEiABKAsyEy5nYW1lX2'
    '1lc3NhZ2VzLlVzZXJSCG1vbmRmYW5nEicKD21vbmRmYW5nX2tvbnRyYRgTIAEoBVIObW9uZGZh'
    'bmdLb250cmESQwoTbW9uZGZhbmdfa29udHJhX2RhbBgUIAEoCzITLmdhbWVfbWVzc2FnZXMuVX'
    'NlclIRbW9uZGZhbmdLb250cmFEYWwSGgoIZ2FtZW1vZGUYFiABKAVSCGdhbWVtb2RlEhgKB2No'
    'YW5nZWQYFyABKAhSB2NoYW5nZWQ=');

@$core.Deprecated('Use talonRevealDescriptor instead')
const TalonReveal$json = {
  '1': 'TalonReveal',
  '2': [
    {'1': 'stih', '3': 1, '4': 3, '5': 11, '6': '.game_messages.Stih', '10': 'stih'},
  ],
};

/// Descriptor for `TalonReveal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List talonRevealDescriptor = $convert.base64Decode(
    'CgtUYWxvblJldmVhbBInCgRzdGloGAEgAygLMhMuZ2FtZV9tZXNzYWdlcy5TdGloUgRzdGlo');

@$core.Deprecated('Use playingRevealDescriptor instead')
const PlayingReveal$json = {
  '1': 'PlayingReveal',
  '2': [
    {'1': 'playing', '3': 1, '4': 1, '5': 11, '6': '.game_messages.User', '10': 'playing'},
  ],
};

/// Descriptor for `PlayingReveal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playingRevealDescriptor = $convert.base64Decode(
    'Cg1QbGF5aW5nUmV2ZWFsEi0KB3BsYXlpbmcYASABKAsyEy5nYW1lX21lc3NhZ2VzLlVzZXJSB3'
    'BsYXlpbmc=');

@$core.Deprecated('Use invitePlayerDescriptor instead')
const InvitePlayer$json = {
  '1': 'InvitePlayer',
};

/// Descriptor for `InvitePlayer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List invitePlayerDescriptor = $convert.base64Decode(
    'CgxJbnZpdGVQbGF5ZXI=');

@$core.Deprecated('Use clearHandDescriptor instead')
const ClearHand$json = {
  '1': 'ClearHand',
};

/// Descriptor for `ClearHand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearHandDescriptor = $convert.base64Decode(
    'CglDbGVhckhhbmQ=');

@$core.Deprecated('Use timeDescriptor instead')
const Time$json = {
  '1': 'Time',
  '2': [
    {'1': 'currentTime', '3': 1, '4': 1, '5': 2, '10': 'currentTime'},
    {'1': 'start', '3': 2, '4': 1, '5': 8, '10': 'start'},
  ],
};

/// Descriptor for `Time`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timeDescriptor = $convert.base64Decode(
    'CgRUaW1lEiAKC2N1cnJlbnRUaW1lGAEgASgCUgtjdXJyZW50VGltZRIUCgVzdGFydBgCIAEoCF'
    'IFc3RhcnQ=');

@$core.Deprecated('Use tournamentStatisticsDescriptor instead')
const TournamentStatistics$json = {
  '1': 'TournamentStatistics',
  '2': [
    {'1': 'place', '3': 1, '4': 1, '5': 5, '10': 'place'},
    {'1': 'players', '3': 2, '4': 1, '5': 5, '10': 'players'},
    {'1': 'top_player_points', '3': 3, '4': 1, '5': 5, '10': 'topPlayerPoints'},
  ],
};

/// Descriptor for `TournamentStatistics`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tournamentStatisticsDescriptor = $convert.base64Decode(
    'ChRUb3VybmFtZW50U3RhdGlzdGljcxIUCgVwbGFjZRgBIAEoBVIFcGxhY2USGAoHcGxheWVycx'
    'gCIAEoBVIHcGxheWVycxIqChF0b3BfcGxheWVyX3BvaW50cxgDIAEoBVIPdG9wUGxheWVyUG9p'
    'bnRz');

@$core.Deprecated('Use tournamentGameStatisticInnerDescriptor instead')
const TournamentGameStatisticInner$json = {
  '1': 'TournamentGameStatisticInner',
  '2': [
    {'1': 'game', '3': 1, '4': 1, '5': 5, '10': 'game'},
    {'1': 'bots', '3': 2, '4': 1, '5': 8, '10': 'bots'},
    {'1': 'amount', '3': 3, '4': 1, '5': 5, '10': 'amount'},
  ],
};

/// Descriptor for `TournamentGameStatisticInner`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tournamentGameStatisticInnerDescriptor = $convert.base64Decode(
    'ChxUb3VybmFtZW50R2FtZVN0YXRpc3RpY0lubmVyEhIKBGdhbWUYASABKAVSBGdhbWUSEgoEYm'
    '90cxgCIAEoCFIEYm90cxIWCgZhbW91bnQYAyABKAVSBmFtb3VudA==');

@$core.Deprecated('Use tournamentGameStatisticsDescriptor instead')
const TournamentGameStatistics$json = {
  '1': 'TournamentGameStatistics',
  '2': [
    {'1': 'statistics', '3': 1, '4': 3, '5': 11, '6': '.game_messages.TournamentGameStatisticInner', '10': 'statistics'},
  ],
};

/// Descriptor for `TournamentGameStatistics`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tournamentGameStatisticsDescriptor = $convert.base64Decode(
    'ChhUb3VybmFtZW50R2FtZVN0YXRpc3RpY3MSSwoKc3RhdGlzdGljcxgBIAMoCzIrLmdhbWVfbW'
    'Vzc2FnZXMuVG91cm5hbWVudEdhbWVTdGF0aXN0aWNJbm5lclIKc3RhdGlzdGljcw==');

@$core.Deprecated('Use chatMessageDescriptor instead')
const ChatMessage$json = {
  '1': 'ChatMessage',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'custom_profile_picture', '3': 3, '4': 1, '5': 8, '10': 'customProfilePicture'},
  ],
};

/// Descriptor for `ChatMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatMessageDescriptor = $convert.base64Decode(
    'CgtDaGF0TWVzc2FnZRIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSGAoHbWVzc2FnZRgCIAEoCV'
    'IHbWVzc2FnZRI0ChZjdXN0b21fcHJvZmlsZV9waWN0dXJlGAMgASgIUhRjdXN0b21Qcm9maWxl'
    'UGljdHVyZQ==');

@$core.Deprecated('Use normalDescriptor instead')
const Normal$json = {
  '1': 'Normal',
};

/// Descriptor for `Normal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List normalDescriptor = $convert.base64Decode(
    'CgZOb3JtYWw=');

@$core.Deprecated('Use tournamentDescriptor instead')
const Tournament$json = {
  '1': 'Tournament',
};

/// Descriptor for `Tournament`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tournamentDescriptor = $convert.base64Decode(
    'CgpUb3VybmFtZW50');

@$core.Deprecated('Use prepareGameModeDescriptor instead')
const PrepareGameMode$json = {
  '1': 'PrepareGameMode',
  '2': [
    {'1': 'normal', '3': 1, '4': 1, '5': 11, '6': '.game_messages.Normal', '9': 0, '10': 'normal'},
    {'1': 'tournament', '3': 2, '4': 1, '5': 11, '6': '.game_messages.Tournament', '9': 0, '10': 'tournament'},
  ],
  '8': [
    {'1': 'mode'},
  ],
};

/// Descriptor for `PrepareGameMode`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List prepareGameModeDescriptor = $convert.base64Decode(
    'Cg9QcmVwYXJlR2FtZU1vZGUSLwoGbm9ybWFsGAEgASgLMhUuZ2FtZV9tZXNzYWdlcy5Ob3JtYW'
    'xIAFIGbm9ybWFsEjsKCnRvdXJuYW1lbnQYAiABKAsyGS5nYW1lX21lc3NhZ2VzLlRvdXJuYW1l'
    'bnRIAFIKdG91cm5hbWVudEIGCgRtb2Rl');

@$core.Deprecated('Use messageDescriptor instead')
const Message$json = {
  '1': 'Message',
  '2': [
    {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
    {'1': 'player_id', '3': 2, '4': 1, '5': 9, '10': 'playerId'},
    {'1': 'silent', '3': 4, '4': 1, '5': 8, '10': 'silent'},
    {'1': 'connection', '3': 10, '4': 1, '5': 11, '6': '.game_messages.Connection', '9': 0, '10': 'connection'},
    {'1': 'licitiranje', '3': 11, '4': 1, '5': 11, '6': '.game_messages.Licitiranje', '9': 0, '10': 'licitiranje'},
    {'1': 'card', '3': 12, '4': 1, '5': 11, '6': '.game_messages.Card', '9': 0, '10': 'card'},
    {'1': 'licitiranje_start', '3': 13, '4': 1, '5': 11, '6': '.game_messages.LicitiranjeStart', '9': 0, '10': 'licitiranjeStart'},
    {'1': 'game_start', '3': 14, '4': 1, '5': 11, '6': '.game_messages.GameStart', '9': 0, '10': 'gameStart'},
    {'1': 'login_request', '3': 15, '4': 1, '5': 11, '6': '.game_messages.LoginRequest', '9': 0, '10': 'loginRequest'},
    {'1': 'login_info', '3': 16, '4': 1, '5': 11, '6': '.game_messages.LoginInfo', '9': 0, '10': 'loginInfo'},
    {'1': 'login_response', '3': 17, '4': 1, '5': 11, '6': '.game_messages.LoginResponse', '9': 0, '10': 'loginResponse'},
    {'1': 'clear_desk', '3': 18, '4': 1, '5': 11, '6': '.game_messages.ClearDesk', '9': 0, '10': 'clearDesk'},
    {'1': 'results', '3': 19, '4': 1, '5': 11, '6': '.game_messages.Results', '9': 0, '10': 'results'},
    {'1': 'user_list', '3': 20, '4': 1, '5': 11, '6': '.game_messages.UserList', '9': 0, '10': 'userList'},
    {'1': 'king_selection', '3': 21, '4': 1, '5': 11, '6': '.game_messages.KingSelection', '9': 0, '10': 'kingSelection'},
    {'1': 'start_predictions', '3': 22, '4': 1, '5': 11, '6': '.game_messages.StartPredictions', '9': 0, '10': 'startPredictions'},
    {'1': 'predictions', '3': 23, '4': 1, '5': 11, '6': '.game_messages.Predictions', '9': 0, '10': 'predictions'},
    {'1': 'talon_reveal', '3': 24, '4': 1, '5': 11, '6': '.game_messages.TalonReveal', '9': 0, '10': 'talonReveal'},
    {'1': 'playing_reveal', '3': 25, '4': 1, '5': 11, '6': '.game_messages.PlayingReveal', '9': 0, '10': 'playingReveal'},
    {'1': 'talon_selection', '3': 26, '4': 1, '5': 11, '6': '.game_messages.TalonSelection', '9': 0, '10': 'talonSelection'},
    {'1': 'stash', '3': 27, '4': 1, '5': 11, '6': '.game_messages.Stash', '9': 0, '10': 'stash'},
    {'1': 'game_end', '3': 28, '4': 1, '5': 11, '6': '.game_messages.GameEnd', '9': 0, '10': 'gameEnd'},
    {'1': 'game_start_countdown', '3': 29, '4': 1, '5': 11, '6': '.game_messages.GameStartCountdown', '9': 0, '10': 'gameStartCountdown'},
    {'1': 'predictions_resend', '3': 30, '4': 1, '5': 11, '6': '.game_messages.Predictions', '9': 0, '10': 'predictionsResend'},
    {'1': 'radelci', '3': 31, '4': 1, '5': 11, '6': '.game_messages.Radelci', '9': 0, '10': 'radelci'},
    {'1': 'time', '3': 32, '4': 1, '5': 11, '6': '.game_messages.Time', '9': 0, '10': 'time'},
    {'1': 'chat_message', '3': 33, '4': 1, '5': 11, '6': '.game_messages.ChatMessage', '9': 0, '10': 'chatMessage'},
    {'1': 'invite_player', '3': 34, '4': 1, '5': 11, '6': '.game_messages.InvitePlayer', '9': 0, '10': 'invitePlayer'},
    {'1': 'stashed_tarock', '3': 35, '4': 1, '5': 11, '6': '.game_messages.StashedTarock', '9': 0, '10': 'stashedTarock'},
    {'1': 'clear_hand', '3': 36, '4': 1, '5': 11, '6': '.game_messages.ClearHand', '9': 0, '10': 'clearHand'},
    {'1': 'replay_link', '3': 37, '4': 1, '5': 11, '6': '.game_messages.ReplayLink', '9': 0, '10': 'replayLink'},
    {'1': 'replay_move', '3': 38, '4': 1, '5': 11, '6': '.game_messages.ReplayMove', '9': 0, '10': 'replayMove'},
    {'1': 'replay_select_game', '3': 39, '4': 1, '5': 11, '6': '.game_messages.ReplaySelectGame', '9': 0, '10': 'replaySelectGame'},
    {'1': 'game_info', '3': 40, '4': 1, '5': 11, '6': '.game_messages.GameInfo', '9': 0, '10': 'gameInfo'},
    {'1': 'start_early', '3': 41, '4': 1, '5': 11, '6': '.game_messages.StartEarly', '9': 0, '10': 'startEarly'},
    {'1': 'prepare_game_mode', '3': 42, '4': 1, '5': 11, '6': '.game_messages.PrepareGameMode', '9': 0, '10': 'prepareGameMode'},
    {'1': 'tournament_statistics', '3': 43, '4': 1, '5': 11, '6': '.game_messages.TournamentStatistics', '9': 0, '10': 'tournamentStatistics'},
    {'1': 'tournament_game_statistics', '3': 44, '4': 1, '5': 11, '6': '.game_messages.TournamentGameStatistics', '9': 0, '10': 'tournamentGameStatistics'},
  ],
  '8': [
    {'1': 'data'},
  ],
};

/// Descriptor for `Message`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageDescriptor = $convert.base64Decode(
    'CgdNZXNzYWdlEhoKCHVzZXJuYW1lGAEgASgJUgh1c2VybmFtZRIbCglwbGF5ZXJfaWQYAiABKA'
    'lSCHBsYXllcklkEhYKBnNpbGVudBgEIAEoCFIGc2lsZW50EjsKCmNvbm5lY3Rpb24YCiABKAsy'
    'GS5nYW1lX21lc3NhZ2VzLkNvbm5lY3Rpb25IAFIKY29ubmVjdGlvbhI+CgtsaWNpdGlyYW5qZR'
    'gLIAEoCzIaLmdhbWVfbWVzc2FnZXMuTGljaXRpcmFuamVIAFILbGljaXRpcmFuamUSKQoEY2Fy'
    'ZBgMIAEoCzITLmdhbWVfbWVzc2FnZXMuQ2FyZEgAUgRjYXJkEk4KEWxpY2l0aXJhbmplX3N0YX'
    'J0GA0gASgLMh8uZ2FtZV9tZXNzYWdlcy5MaWNpdGlyYW5qZVN0YXJ0SABSEGxpY2l0aXJhbmpl'
    'U3RhcnQSOQoKZ2FtZV9zdGFydBgOIAEoCzIYLmdhbWVfbWVzc2FnZXMuR2FtZVN0YXJ0SABSCW'
    'dhbWVTdGFydBJCCg1sb2dpbl9yZXF1ZXN0GA8gASgLMhsuZ2FtZV9tZXNzYWdlcy5Mb2dpblJl'
    'cXVlc3RIAFIMbG9naW5SZXF1ZXN0EjkKCmxvZ2luX2luZm8YECABKAsyGC5nYW1lX21lc3NhZ2'
    'VzLkxvZ2luSW5mb0gAUglsb2dpbkluZm8SRQoObG9naW5fcmVzcG9uc2UYESABKAsyHC5nYW1l'
    'X21lc3NhZ2VzLkxvZ2luUmVzcG9uc2VIAFINbG9naW5SZXNwb25zZRI5CgpjbGVhcl9kZXNrGB'
    'IgASgLMhguZ2FtZV9tZXNzYWdlcy5DbGVhckRlc2tIAFIJY2xlYXJEZXNrEjIKB3Jlc3VsdHMY'
    'EyABKAsyFi5nYW1lX21lc3NhZ2VzLlJlc3VsdHNIAFIHcmVzdWx0cxI2Cgl1c2VyX2xpc3QYFC'
    'ABKAsyFy5nYW1lX21lc3NhZ2VzLlVzZXJMaXN0SABSCHVzZXJMaXN0EkUKDmtpbmdfc2VsZWN0'
    'aW9uGBUgASgLMhwuZ2FtZV9tZXNzYWdlcy5LaW5nU2VsZWN0aW9uSABSDWtpbmdTZWxlY3Rpb2'
    '4STgoRc3RhcnRfcHJlZGljdGlvbnMYFiABKAsyHy5nYW1lX21lc3NhZ2VzLlN0YXJ0UHJlZGlj'
    'dGlvbnNIAFIQc3RhcnRQcmVkaWN0aW9ucxI+CgtwcmVkaWN0aW9ucxgXIAEoCzIaLmdhbWVfbW'
    'Vzc2FnZXMuUHJlZGljdGlvbnNIAFILcHJlZGljdGlvbnMSPwoMdGFsb25fcmV2ZWFsGBggASgL'
    'MhouZ2FtZV9tZXNzYWdlcy5UYWxvblJldmVhbEgAUgt0YWxvblJldmVhbBJFCg5wbGF5aW5nX3'
    'JldmVhbBgZIAEoCzIcLmdhbWVfbWVzc2FnZXMuUGxheWluZ1JldmVhbEgAUg1wbGF5aW5nUmV2'
    'ZWFsEkgKD3RhbG9uX3NlbGVjdGlvbhgaIAEoCzIdLmdhbWVfbWVzc2FnZXMuVGFsb25TZWxlY3'
    'Rpb25IAFIOdGFsb25TZWxlY3Rpb24SLAoFc3Rhc2gYGyABKAsyFC5nYW1lX21lc3NhZ2VzLlN0'
    'YXNoSABSBXN0YXNoEjMKCGdhbWVfZW5kGBwgASgLMhYuZ2FtZV9tZXNzYWdlcy5HYW1lRW5kSA'
    'BSB2dhbWVFbmQSVQoUZ2FtZV9zdGFydF9jb3VudGRvd24YHSABKAsyIS5nYW1lX21lc3NhZ2Vz'
    'LkdhbWVTdGFydENvdW50ZG93bkgAUhJnYW1lU3RhcnRDb3VudGRvd24SSwoScHJlZGljdGlvbn'
    'NfcmVzZW5kGB4gASgLMhouZ2FtZV9tZXNzYWdlcy5QcmVkaWN0aW9uc0gAUhFwcmVkaWN0aW9u'
    'c1Jlc2VuZBIyCgdyYWRlbGNpGB8gASgLMhYuZ2FtZV9tZXNzYWdlcy5SYWRlbGNpSABSB3JhZG'
    'VsY2kSKQoEdGltZRggIAEoCzITLmdhbWVfbWVzc2FnZXMuVGltZUgAUgR0aW1lEj8KDGNoYXRf'
    'bWVzc2FnZRghIAEoCzIaLmdhbWVfbWVzc2FnZXMuQ2hhdE1lc3NhZ2VIAFILY2hhdE1lc3NhZ2'
    'USQgoNaW52aXRlX3BsYXllchgiIAEoCzIbLmdhbWVfbWVzc2FnZXMuSW52aXRlUGxheWVySABS'
    'DGludml0ZVBsYXllchJFCg5zdGFzaGVkX3Rhcm9jaxgjIAEoCzIcLmdhbWVfbWVzc2FnZXMuU3'
    'Rhc2hlZFRhcm9ja0gAUg1zdGFzaGVkVGFyb2NrEjkKCmNsZWFyX2hhbmQYJCABKAsyGC5nYW1l'
    'X21lc3NhZ2VzLkNsZWFySGFuZEgAUgljbGVhckhhbmQSPAoLcmVwbGF5X2xpbmsYJSABKAsyGS'
    '5nYW1lX21lc3NhZ2VzLlJlcGxheUxpbmtIAFIKcmVwbGF5TGluaxI8CgtyZXBsYXlfbW92ZRgm'
    'IAEoCzIZLmdhbWVfbWVzc2FnZXMuUmVwbGF5TW92ZUgAUgpyZXBsYXlNb3ZlEk8KEnJlcGxheV'
    '9zZWxlY3RfZ2FtZRgnIAEoCzIfLmdhbWVfbWVzc2FnZXMuUmVwbGF5U2VsZWN0R2FtZUgAUhBy'
    'ZXBsYXlTZWxlY3RHYW1lEjYKCWdhbWVfaW5mbxgoIAEoCzIXLmdhbWVfbWVzc2FnZXMuR2FtZU'
    'luZm9IAFIIZ2FtZUluZm8SPAoLc3RhcnRfZWFybHkYKSABKAsyGS5nYW1lX21lc3NhZ2VzLlN0'
    'YXJ0RWFybHlIAFIKc3RhcnRFYXJseRJMChFwcmVwYXJlX2dhbWVfbW9kZRgqIAEoCzIeLmdhbW'
    'VfbWVzc2FnZXMuUHJlcGFyZUdhbWVNb2RlSABSD3ByZXBhcmVHYW1lTW9kZRJaChV0b3VybmFt'
    'ZW50X3N0YXRpc3RpY3MYKyABKAsyIy5nYW1lX21lc3NhZ2VzLlRvdXJuYW1lbnRTdGF0aXN0aW'
    'NzSABSFHRvdXJuYW1lbnRTdGF0aXN0aWNzEmcKGnRvdXJuYW1lbnRfZ2FtZV9zdGF0aXN0aWNz'
    'GCwgASgLMicuZ2FtZV9tZXNzYWdlcy5Ub3VybmFtZW50R2FtZVN0YXRpc3RpY3NIAFIYdG91cm'
    '5hbWVudEdhbWVTdGF0aXN0aWNzQgYKBGRhdGE=');

