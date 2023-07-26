///
//  Generated code. Do not modify.
//  source: messages.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
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
};

/// Descriptor for `Request`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestDescriptor = $convert.base64Decode('CgdSZXF1ZXN0');
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
@$core.Deprecated('Use gameEndDescriptor instead')
const GameEnd$json = const {
  '1': 'GameEnd',
  '2': const [
    const {'1': 'results', '3': 1, '4': 1, '5': 11, '6': '.Results', '9': 0, '10': 'results'},
    const {'1': 'request', '3': 2, '4': 1, '5': 11, '6': '.Request', '9': 0, '10': 'request'},
  ],
  '8': const [
    const {'1': 'type'},
  ],
};

/// Descriptor for `GameEnd`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameEndDescriptor = $convert.base64Decode('CgdHYW1lRW5kEiQKB3Jlc3VsdHMYASABKAsyCC5SZXN1bHRzSABSB3Jlc3VsdHMSJAoHcmVxdWVzdBgCIAEoCzIILlJlcXVlc3RIAFIHcmVxdWVzdEIGCgR0eXBl');
@$core.Deprecated('Use connectionDescriptor instead')
const Connection$json = const {
  '1': 'Connection',
  '2': const [
    const {'1': 'rating', '3': 2, '4': 1, '5': 5, '10': 'rating'},
    const {'1': 'join', '3': 3, '4': 1, '5': 11, '6': '.Connect', '9': 0, '10': 'join'},
    const {'1': 'disconnect', '3': 4, '4': 1, '5': 11, '6': '.Disconnect', '9': 0, '10': 'disconnect'},
  ],
  '8': const [
    const {'1': 'type'},
  ],
};

/// Descriptor for `Connection`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectionDescriptor = $convert.base64Decode('CgpDb25uZWN0aW9uEhYKBnJhdGluZxgCIAEoBVIGcmF0aW5nEh4KBGpvaW4YAyABKAsyCC5Db25uZWN0SABSBGpvaW4SLQoKZGlzY29ubmVjdBgEIAEoCzILLkRpc2Nvbm5lY3RIAFIKZGlzY29ubmVjdEIGCgR0eXBl');
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
    const {'1': 'receive', '3': 2, '4': 1, '5': 11, '6': '.Receive', '9': 0, '10': 'receive'},
    const {'1': 'send', '3': 3, '4': 1, '5': 11, '6': '.Send', '9': 0, '10': 'send'},
    const {'1': 'request', '3': 4, '4': 1, '5': 11, '6': '.Request', '9': 0, '10': 'request'},
  ],
  '8': const [
    const {'1': 'type'},
  ],
};

/// Descriptor for `Card`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cardDescriptor = $convert.base64Decode('CgRDYXJkEg4KAmlkGAEgASgJUgJpZBIkCgdyZWNlaXZlGAIgASgLMgguUmVjZWl2ZUgAUgdyZWNlaXZlEhsKBHNlbmQYAyABKAsyBS5TZW5kSABSBHNlbmQSJAoHcmVxdWVzdBgEIAEoCzIILlJlcXVlc3RIAFIHcmVxdWVzdEIGCgR0eXBl');
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
    const {'1': 'user', '3': 1, '4': 3, '5': 11, '6': '.User', '10': 'user'},
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
    const {'1': 'mondfang', '3': 13, '4': 1, '5': 8, '10': 'mondfang'},
    const {'1': 'show_gamemode', '3': 14, '4': 1, '5': 8, '10': 'showGamemode'},
    const {'1': 'show_difference', '3': 15, '4': 1, '5': 8, '10': 'showDifference'},
    const {'1': 'show_kralj', '3': 16, '4': 1, '5': 8, '10': 'showKralj'},
    const {'1': 'show_pagat', '3': 17, '4': 1, '5': 8, '10': 'showPagat'},
    const {'1': 'show_kralji', '3': 18, '4': 1, '5': 8, '10': 'showKralji'},
    const {'1': 'show_trula', '3': 19, '4': 1, '5': 8, '10': 'showTrula'},
  ],
};

/// Descriptor for `ResultsUser`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resultsUserDescriptor = $convert.base64Decode('CgtSZXN1bHRzVXNlchIZCgR1c2VyGAEgAygLMgUuVXNlclIEdXNlchIYCgdwbGF5aW5nGAIgASgIUgdwbGF5aW5nEhYKBnBvaW50cxgDIAEoBVIGcG9pbnRzEhQKBXRydWxhGAQgASgFUgV0cnVsYRIUCgVwYWdhdBgFIAEoBVIFcGFnYXQSEgoEaWdyYRgGIAEoBVIEaWdyYRIYCgdyYXpsaWthGAcgASgFUgdyYXpsaWthEhQKBWtyYWxqGAggASgFUgVrcmFsahIWCgZrcmFsamkYCSABKAVSBmtyYWxqaRIhCgxrb250cmFfcGFnYXQYCiABKAVSC2tvbnRyYVBhZ2F0Eh8KC2tvbnRyYV9pZ3JhGAsgASgFUgprb250cmFJZ3JhEiEKDGtvbnRyYV9rcmFsahgMIAEoBVILa29udHJhS3JhbGoSGgoIbW9uZGZhbmcYDSABKAhSCG1vbmRmYW5nEiMKDXNob3dfZ2FtZW1vZGUYDiABKAhSDHNob3dHYW1lbW9kZRInCg9zaG93X2RpZmZlcmVuY2UYDyABKAhSDnNob3dEaWZmZXJlbmNlEh0KCnNob3dfa3JhbGoYECABKAhSCXNob3dLcmFsahIdCgpzaG93X3BhZ2F0GBEgASgIUglzaG93UGFnYXQSHwoLc2hvd19rcmFsamkYEiABKAhSCnNob3dLcmFsamkSHQoKc2hvd190cnVsYRgTIAEoCFIJc2hvd1RydWxh');
@$core.Deprecated('Use stihDescriptor instead')
const Stih$json = const {
  '1': 'Stih',
  '2': const [
    const {'1': 'card', '3': 1, '4': 3, '5': 11, '6': '.Card', '10': 'card'},
    const {'1': 'worth', '3': 2, '4': 1, '5': 2, '10': 'worth'},
    const {'1': 'pickedUpByPlaying', '3': 3, '4': 1, '5': 8, '10': 'pickedUpByPlaying'},
    const {'1': 'pickedUpBy', '3': 4, '4': 1, '5': 9, '10': 'pickedUpBy'},
  ],
};

/// Descriptor for `Stih`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stihDescriptor = $convert.base64Decode('CgRTdGloEhkKBGNhcmQYASADKAsyBS5DYXJkUgRjYXJkEhQKBXdvcnRoGAIgASgCUgV3b3J0aBIsChFwaWNrZWRVcEJ5UGxheWluZxgDIAEoCFIRcGlja2VkVXBCeVBsYXlpbmcSHgoKcGlja2VkVXBCeRgEIAEoCVIKcGlja2VkVXBCeQ==');
@$core.Deprecated('Use resultsDescriptor instead')
const Results$json = const {
  '1': 'Results',
  '2': const [
    const {'1': 'user', '3': 1, '4': 3, '5': 11, '6': '.ResultsUser', '10': 'user'},
    const {'1': 'stih', '3': 2, '4': 3, '5': 11, '6': '.Stih', '10': 'stih'},
  ],
};

/// Descriptor for `Results`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resultsDescriptor = $convert.base64Decode('CgdSZXN1bHRzEiAKBHVzZXIYASADKAsyDC5SZXN1bHRzVXNlclIEdXNlchIZCgRzdGloGAIgAygLMgUuU3RpaFIEc3RpaA==');
@$core.Deprecated('Use gameStartDescriptor instead')
const GameStart$json = const {
  '1': 'GameStart',
  '2': const [
    const {'1': 'user', '3': 1, '4': 3, '5': 11, '6': '.User', '10': 'user'},
  ],
};

/// Descriptor for `GameStart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameStartDescriptor = $convert.base64Decode('CglHYW1lU3RhcnQSGQoEdXNlchgBIAMoCzIFLlVzZXJSBHVzZXI=');
@$core.Deprecated('Use userListDescriptor instead')
const UserList$json = const {
  '1': 'UserList',
  '2': const [
    const {'1': 'user', '3': 1, '4': 3, '5': 11, '6': '.User', '10': 'user'},
  ],
};

/// Descriptor for `UserList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userListDescriptor = $convert.base64Decode('CghVc2VyTGlzdBIZCgR1c2VyGAEgAygLMgUuVXNlclIEdXNlcg==');
@$core.Deprecated('Use kingSelectionDescriptor instead')
const KingSelection$json = const {
  '1': 'KingSelection',
  '2': const [
    const {'1': 'card', '3': 1, '4': 1, '5': 9, '10': 'card'},
    const {'1': 'request', '3': 2, '4': 1, '5': 11, '6': '.Request', '9': 0, '10': 'request'},
    const {'1': 'send', '3': 3, '4': 1, '5': 11, '6': '.Send', '9': 0, '10': 'send'},
    const {'1': 'notification', '3': 4, '4': 1, '5': 11, '6': '.Notification', '9': 0, '10': 'notification'},
  ],
  '8': const [
    const {'1': 'type'},
  ],
};

/// Descriptor for `KingSelection`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List kingSelectionDescriptor = $convert.base64Decode('Cg1LaW5nU2VsZWN0aW9uEhIKBGNhcmQYASABKAlSBGNhcmQSJAoHcmVxdWVzdBgCIAEoCzIILlJlcXVlc3RIAFIHcmVxdWVzdBIbCgRzZW5kGAMgASgLMgUuU2VuZEgAUgRzZW5kEjMKDG5vdGlmaWNhdGlvbhgEIAEoCzINLk5vdGlmaWNhdGlvbkgAUgxub3RpZmljYXRpb25CBgoEdHlwZQ==');
@$core.Deprecated('Use talonSelectionDescriptor instead')
const TalonSelection$json = const {
  '1': 'TalonSelection',
  '2': const [
    const {'1': 'part', '3': 1, '4': 1, '5': 5, '10': 'part'},
    const {'1': 'request', '3': 2, '4': 1, '5': 11, '6': '.Request', '9': 0, '10': 'request'},
    const {'1': 'send', '3': 3, '4': 1, '5': 11, '6': '.Send', '9': 0, '10': 'send'},
    const {'1': 'notification', '3': 4, '4': 1, '5': 11, '6': '.Notification', '9': 0, '10': 'notification'},
  ],
  '8': const [
    const {'1': 'type'},
  ],
};

/// Descriptor for `TalonSelection`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List talonSelectionDescriptor = $convert.base64Decode('Cg5UYWxvblNlbGVjdGlvbhISCgRwYXJ0GAEgASgFUgRwYXJ0EiQKB3JlcXVlc3QYAiABKAsyCC5SZXF1ZXN0SABSB3JlcXVlc3QSGwoEc2VuZBgDIAEoCzIFLlNlbmRIAFIEc2VuZBIzCgxub3RpZmljYXRpb24YBCABKAsyDS5Ob3RpZmljYXRpb25IAFIMbm90aWZpY2F0aW9uQgYKBHR5cGU=');
@$core.Deprecated('Use stashDescriptor instead')
const Stash$json = const {
  '1': 'Stash',
  '2': const [
    const {'1': 'card', '3': 1, '4': 3, '5': 11, '6': '.Card', '10': 'card'},
    const {'1': 'length', '3': 2, '4': 1, '5': 5, '10': 'length'},
    const {'1': 'request', '3': 3, '4': 1, '5': 11, '6': '.Request', '9': 0, '10': 'request'},
    const {'1': 'send', '3': 4, '4': 1, '5': 11, '6': '.Send', '9': 0, '10': 'send'},
    const {'1': 'notification', '3': 5, '4': 1, '5': 11, '6': '.Notification', '9': 0, '10': 'notification'},
  ],
  '8': const [
    const {'1': 'type'},
  ],
};

/// Descriptor for `Stash`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stashDescriptor = $convert.base64Decode('CgVTdGFzaBIZCgRjYXJkGAEgAygLMgUuQ2FyZFIEY2FyZBIWCgZsZW5ndGgYAiABKAVSBmxlbmd0aBIkCgdyZXF1ZXN0GAMgASgLMgguUmVxdWVzdEgAUgdyZXF1ZXN0EhsKBHNlbmQYBCABKAsyBS5TZW5kSABSBHNlbmQSMwoMbm90aWZpY2F0aW9uGAUgASgLMg0uTm90aWZpY2F0aW9uSABSDG5vdGlmaWNhdGlvbkIGCgR0eXBl');
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
  ],
};

/// Descriptor for `StartPredictions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startPredictionsDescriptor = $convert.base64Decode('ChBTdGFydFByZWRpY3Rpb25zEi4KE2tyYWxqX3VsdGltb19rb250cmEYASABKAhSEWtyYWxqVWx0aW1vS29udHJhEi4KE3BhZ2F0X3VsdGltb19rb250cmEYBCABKAhSEXBhZ2F0VWx0aW1vS29udHJhEh8KC2lncmFfa29udHJhGAUgASgIUgppZ3JhS29udHJhEiEKDHZhbGF0X2tvbnRyYRgGIAEoCFILdmFsYXRLb250cmESLgoTYmFydm5pX3ZhbGF0X2tvbnRyYRgHIAEoCFIRYmFydm5pVmFsYXRLb250cmESIQoMcGFnYXRfdWx0aW1vGAggASgIUgtwYWdhdFVsdGltbxIUCgV0cnVsYRgJIAEoCFIFdHJ1bGESFgoGa3JhbGppGAogASgIUgZrcmFsamkSIQoMa3JhbGpfdWx0aW1vGAsgASgIUgtrcmFsalVsdGltbxIUCgV2YWxhdBgMIAEoCFIFdmFsYXQSIQoMYmFydm5pX3ZhbGF0GA0gASgIUgtiYXJ2bmlWYWxhdA==');
@$core.Deprecated('Use predictionsDescriptor instead')
const Predictions$json = const {
  '1': 'Predictions',
  '2': const [
    const {'1': 'kralj_ultimo', '3': 1, '4': 1, '5': 11, '6': '.User', '10': 'kraljUltimo'},
    const {'1': 'kralj_ultimo_kontra', '3': 2, '4': 1, '5': 5, '10': 'kraljUltimoKontra'},
    const {'1': 'kralj_ultimo_kontra_dal', '3': 3, '4': 1, '5': 11, '6': '.User', '10': 'kraljUltimoKontraDal'},
    const {'1': 'trula', '3': 4, '4': 1, '5': 11, '6': '.User', '10': 'trula'},
    const {'1': 'kralji', '3': 7, '4': 1, '5': 11, '6': '.User', '10': 'kralji'},
    const {'1': 'pagat_ultimo', '3': 10, '4': 1, '5': 11, '6': '.User', '10': 'pagatUltimo'},
    const {'1': 'pagat_ultimo_kontra', '3': 11, '4': 1, '5': 5, '10': 'pagatUltimoKontra'},
    const {'1': 'pagat_ultimo_kontra_dal', '3': 12, '4': 1, '5': 11, '6': '.User', '10': 'pagatUltimoKontraDal'},
    const {'1': 'igra', '3': 13, '4': 1, '5': 11, '6': '.User', '10': 'igra'},
    const {'1': 'igra_kontra', '3': 14, '4': 1, '5': 5, '10': 'igraKontra'},
    const {'1': 'igra_kontra_dal', '3': 15, '4': 1, '5': 11, '6': '.User', '10': 'igraKontraDal'},
    const {'1': 'valat', '3': 16, '4': 1, '5': 11, '6': '.User', '10': 'valat'},
    const {'1': 'valat_kontra', '3': 17, '4': 1, '5': 5, '10': 'valatKontra'},
    const {'1': 'valat_kontra_dal', '3': 18, '4': 1, '5': 11, '6': '.User', '10': 'valatKontraDal'},
    const {'1': 'barvni_valat', '3': 19, '4': 1, '5': 11, '6': '.User', '10': 'barvniValat'},
    const {'1': 'barvni_valat_kontra', '3': 20, '4': 1, '5': 5, '10': 'barvniValatKontra'},
    const {'1': 'barvni_valat_kontra_dal', '3': 21, '4': 1, '5': 11, '6': '.User', '10': 'barvniValatKontraDal'},
    const {'1': 'gamemode', '3': 22, '4': 1, '5': 5, '10': 'gamemode'},
    const {'1': 'changed', '3': 23, '4': 1, '5': 8, '10': 'changed'},
  ],
};

/// Descriptor for `Predictions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List predictionsDescriptor = $convert.base64Decode('CgtQcmVkaWN0aW9ucxIoCgxrcmFsal91bHRpbW8YASABKAsyBS5Vc2VyUgtrcmFsalVsdGltbxIuChNrcmFsal91bHRpbW9fa29udHJhGAIgASgFUhFrcmFsalVsdGltb0tvbnRyYRI8ChdrcmFsal91bHRpbW9fa29udHJhX2RhbBgDIAEoCzIFLlVzZXJSFGtyYWxqVWx0aW1vS29udHJhRGFsEhsKBXRydWxhGAQgASgLMgUuVXNlclIFdHJ1bGESHQoGa3JhbGppGAcgASgLMgUuVXNlclIGa3JhbGppEigKDHBhZ2F0X3VsdGltbxgKIAEoCzIFLlVzZXJSC3BhZ2F0VWx0aW1vEi4KE3BhZ2F0X3VsdGltb19rb250cmEYCyABKAVSEXBhZ2F0VWx0aW1vS29udHJhEjwKF3BhZ2F0X3VsdGltb19rb250cmFfZGFsGAwgASgLMgUuVXNlclIUcGFnYXRVbHRpbW9Lb250cmFEYWwSGQoEaWdyYRgNIAEoCzIFLlVzZXJSBGlncmESHwoLaWdyYV9rb250cmEYDiABKAVSCmlncmFLb250cmESLQoPaWdyYV9rb250cmFfZGFsGA8gASgLMgUuVXNlclINaWdyYUtvbnRyYURhbBIbCgV2YWxhdBgQIAEoCzIFLlVzZXJSBXZhbGF0EiEKDHZhbGF0X2tvbnRyYRgRIAEoBVILdmFsYXRLb250cmESLwoQdmFsYXRfa29udHJhX2RhbBgSIAEoCzIFLlVzZXJSDnZhbGF0S29udHJhRGFsEigKDGJhcnZuaV92YWxhdBgTIAEoCzIFLlVzZXJSC2JhcnZuaVZhbGF0Ei4KE2JhcnZuaV92YWxhdF9rb250cmEYFCABKAVSEWJhcnZuaVZhbGF0S29udHJhEjwKF2JhcnZuaV92YWxhdF9rb250cmFfZGFsGBUgASgLMgUuVXNlclIUYmFydm5pVmFsYXRLb250cmFEYWwSGgoIZ2FtZW1vZGUYFiABKAVSCGdhbWVtb2RlEhgKB2NoYW5nZWQYFyABKAhSB2NoYW5nZWQ=');
@$core.Deprecated('Use talonRevealDescriptor instead')
const TalonReveal$json = const {
  '1': 'TalonReveal',
  '2': const [
    const {'1': 'stih', '3': 1, '4': 3, '5': 11, '6': '.Stih', '10': 'stih'},
  ],
};

/// Descriptor for `TalonReveal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List talonRevealDescriptor = $convert.base64Decode('CgtUYWxvblJldmVhbBIZCgRzdGloGAEgAygLMgUuU3RpaFIEc3RpaA==');
@$core.Deprecated('Use playingRevealDescriptor instead')
const PlayingReveal$json = const {
  '1': 'PlayingReveal',
  '2': const [
    const {'1': 'playing', '3': 1, '4': 1, '5': 11, '6': '.User', '10': 'playing'},
  ],
};

/// Descriptor for `PlayingReveal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playingRevealDescriptor = $convert.base64Decode('Cg1QbGF5aW5nUmV2ZWFsEh8KB3BsYXlpbmcYASABKAsyBS5Vc2VyUgdwbGF5aW5n');
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
    const {'1': 'ok', '3': 1, '4': 1, '5': 11, '6': '.LoginResponse.OK', '9': 0, '10': 'ok'},
    const {'1': 'fail', '3': 2, '4': 1, '5': 11, '6': '.LoginResponse.Fail', '9': 0, '10': 'fail'},
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
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode('Cg1Mb2dpblJlc3BvbnNlEiMKAm9rGAEgASgLMhEuTG9naW5SZXNwb25zZS5PS0gAUgJvaxIpCgRmYWlsGAIgASgLMhMuTG9naW5SZXNwb25zZS5GYWlsSABSBGZhaWwaBAoCT0saBgoERmFpbEIGCgR0eXBl');
@$core.Deprecated('Use messageDescriptor instead')
const Message$json = const {
  '1': 'Message',
  '2': const [
    const {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
    const {'1': 'player_id', '3': 2, '4': 1, '5': 9, '10': 'playerId'},
    const {'1': 'game_id', '3': 3, '4': 1, '5': 9, '10': 'gameId'},
    const {'1': 'connection', '3': 4, '4': 1, '5': 11, '6': '.Connection', '9': 0, '10': 'connection'},
    const {'1': 'licitiranje', '3': 5, '4': 1, '5': 11, '6': '.Licitiranje', '9': 0, '10': 'licitiranje'},
    const {'1': 'card', '3': 6, '4': 1, '5': 11, '6': '.Card', '9': 0, '10': 'card'},
    const {'1': 'licitiranje_start', '3': 7, '4': 1, '5': 11, '6': '.LicitiranjeStart', '9': 0, '10': 'licitiranjeStart'},
    const {'1': 'game_start', '3': 8, '4': 1, '5': 11, '6': '.GameStart', '9': 0, '10': 'gameStart'},
    const {'1': 'login_request', '3': 9, '4': 1, '5': 11, '6': '.LoginRequest', '9': 0, '10': 'loginRequest'},
    const {'1': 'login_info', '3': 10, '4': 1, '5': 11, '6': '.LoginInfo', '9': 0, '10': 'loginInfo'},
    const {'1': 'login_response', '3': 11, '4': 1, '5': 11, '6': '.LoginResponse', '9': 0, '10': 'loginResponse'},
    const {'1': 'clear_desk', '3': 12, '4': 1, '5': 11, '6': '.ClearDesk', '9': 0, '10': 'clearDesk'},
    const {'1': 'results', '3': 13, '4': 1, '5': 11, '6': '.Results', '9': 0, '10': 'results'},
    const {'1': 'user_list', '3': 14, '4': 1, '5': 11, '6': '.UserList', '9': 0, '10': 'userList'},
    const {'1': 'king_selection', '3': 15, '4': 1, '5': 11, '6': '.KingSelection', '9': 0, '10': 'kingSelection'},
    const {'1': 'start_predictions', '3': 16, '4': 1, '5': 11, '6': '.StartPredictions', '9': 0, '10': 'startPredictions'},
    const {'1': 'predictions', '3': 17, '4': 1, '5': 11, '6': '.Predictions', '9': 0, '10': 'predictions'},
    const {'1': 'talon_reveal', '3': 18, '4': 1, '5': 11, '6': '.TalonReveal', '9': 0, '10': 'talonReveal'},
    const {'1': 'playing_reveal', '3': 19, '4': 1, '5': 11, '6': '.PlayingReveal', '9': 0, '10': 'playingReveal'},
    const {'1': 'talon_selection', '3': 20, '4': 1, '5': 11, '6': '.TalonSelection', '9': 0, '10': 'talonSelection'},
    const {'1': 'stash', '3': 21, '4': 1, '5': 11, '6': '.Stash', '9': 0, '10': 'stash'},
    const {'1': 'game_end', '3': 22, '4': 1, '5': 11, '6': '.GameEnd', '9': 0, '10': 'gameEnd'},
    const {'1': 'game_start_countdown', '3': 23, '4': 1, '5': 11, '6': '.GameStartCountdown', '9': 0, '10': 'gameStartCountdown'},
  ],
  '8': const [
    const {'1': 'data'},
  ],
};

/// Descriptor for `Message`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageDescriptor = $convert.base64Decode('CgdNZXNzYWdlEhoKCHVzZXJuYW1lGAEgASgJUgh1c2VybmFtZRIbCglwbGF5ZXJfaWQYAiABKAlSCHBsYXllcklkEhcKB2dhbWVfaWQYAyABKAlSBmdhbWVJZBItCgpjb25uZWN0aW9uGAQgASgLMgsuQ29ubmVjdGlvbkgAUgpjb25uZWN0aW9uEjAKC2xpY2l0aXJhbmplGAUgASgLMgwuTGljaXRpcmFuamVIAFILbGljaXRpcmFuamUSGwoEY2FyZBgGIAEoCzIFLkNhcmRIAFIEY2FyZBJAChFsaWNpdGlyYW5qZV9zdGFydBgHIAEoCzIRLkxpY2l0aXJhbmplU3RhcnRIAFIQbGljaXRpcmFuamVTdGFydBIrCgpnYW1lX3N0YXJ0GAggASgLMgouR2FtZVN0YXJ0SABSCWdhbWVTdGFydBI0Cg1sb2dpbl9yZXF1ZXN0GAkgASgLMg0uTG9naW5SZXF1ZXN0SABSDGxvZ2luUmVxdWVzdBIrCgpsb2dpbl9pbmZvGAogASgLMgouTG9naW5JbmZvSABSCWxvZ2luSW5mbxI3Cg5sb2dpbl9yZXNwb25zZRgLIAEoCzIOLkxvZ2luUmVzcG9uc2VIAFINbG9naW5SZXNwb25zZRIrCgpjbGVhcl9kZXNrGAwgASgLMgouQ2xlYXJEZXNrSABSCWNsZWFyRGVzaxIkCgdyZXN1bHRzGA0gASgLMgguUmVzdWx0c0gAUgdyZXN1bHRzEigKCXVzZXJfbGlzdBgOIAEoCzIJLlVzZXJMaXN0SABSCHVzZXJMaXN0EjcKDmtpbmdfc2VsZWN0aW9uGA8gASgLMg4uS2luZ1NlbGVjdGlvbkgAUg1raW5nU2VsZWN0aW9uEkAKEXN0YXJ0X3ByZWRpY3Rpb25zGBAgASgLMhEuU3RhcnRQcmVkaWN0aW9uc0gAUhBzdGFydFByZWRpY3Rpb25zEjAKC3ByZWRpY3Rpb25zGBEgASgLMgwuUHJlZGljdGlvbnNIAFILcHJlZGljdGlvbnMSMQoMdGFsb25fcmV2ZWFsGBIgASgLMgwuVGFsb25SZXZlYWxIAFILdGFsb25SZXZlYWwSNwoOcGxheWluZ19yZXZlYWwYEyABKAsyDi5QbGF5aW5nUmV2ZWFsSABSDXBsYXlpbmdSZXZlYWwSOgoPdGFsb25fc2VsZWN0aW9uGBQgASgLMg8uVGFsb25TZWxlY3Rpb25IAFIOdGFsb25TZWxlY3Rpb24SHgoFc3Rhc2gYFSABKAsyBi5TdGFzaEgAUgVzdGFzaBIlCghnYW1lX2VuZBgWIAEoCzIILkdhbWVFbmRIAFIHZ2FtZUVuZBJHChRnYW1lX3N0YXJ0X2NvdW50ZG93bhgXIAEoCzITLkdhbWVTdGFydENvdW50ZG93bkgAUhJnYW1lU3RhcnRDb3VudGRvd25CBgoEZGF0YQ==');
