//
//  Generated code. Do not modify.
//  source: messages.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class LoginRequest extends $pb.GeneratedMessage {
  factory LoginRequest() => create();
  LoginRequest._() : super();
  factory LoginRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoginRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoginRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoginRequest clone() => LoginRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoginRequest copyWith(void Function(LoginRequest) updates) => super.copyWith((message) => updates(message as LoginRequest)) as LoginRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginRequest create() => LoginRequest._();
  LoginRequest createEmptyInstance() => create();
  static $pb.PbList<LoginRequest> createRepeated() => $pb.PbList<LoginRequest>();
  @$core.pragma('dart2js:noInline')
  static LoginRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoginRequest>(create);
  static LoginRequest? _defaultInstance;
}

class LoginInfo extends $pb.GeneratedMessage {
  factory LoginInfo({
    $core.String? token,
  }) {
    final $result = create();
    if (token != null) {
      $result.token = token;
    }
    return $result;
  }
  LoginInfo._() : super();
  factory LoginInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoginInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoginInfo', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoginInfo clone() => LoginInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoginInfo copyWith(void Function(LoginInfo) updates) => super.copyWith((message) => updates(message as LoginInfo)) as LoginInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginInfo create() => LoginInfo._();
  LoginInfo createEmptyInstance() => create();
  static $pb.PbList<LoginInfo> createRepeated() => $pb.PbList<LoginInfo>();
  @$core.pragma('dart2js:noInline')
  static LoginInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoginInfo>(create);
  static LoginInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => clearField(1);
}

class LoginResponse_OK extends $pb.GeneratedMessage {
  factory LoginResponse_OK() => create();
  LoginResponse_OK._() : super();
  factory LoginResponse_OK.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoginResponse_OK.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoginResponse.OK', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoginResponse_OK clone() => LoginResponse_OK()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoginResponse_OK copyWith(void Function(LoginResponse_OK) updates) => super.copyWith((message) => updates(message as LoginResponse_OK)) as LoginResponse_OK;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginResponse_OK create() => LoginResponse_OK._();
  LoginResponse_OK createEmptyInstance() => create();
  static $pb.PbList<LoginResponse_OK> createRepeated() => $pb.PbList<LoginResponse_OK>();
  @$core.pragma('dart2js:noInline')
  static LoginResponse_OK getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoginResponse_OK>(create);
  static LoginResponse_OK? _defaultInstance;
}

class LoginResponse_Fail extends $pb.GeneratedMessage {
  factory LoginResponse_Fail() => create();
  LoginResponse_Fail._() : super();
  factory LoginResponse_Fail.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoginResponse_Fail.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoginResponse.Fail', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoginResponse_Fail clone() => LoginResponse_Fail()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoginResponse_Fail copyWith(void Function(LoginResponse_Fail) updates) => super.copyWith((message) => updates(message as LoginResponse_Fail)) as LoginResponse_Fail;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginResponse_Fail create() => LoginResponse_Fail._();
  LoginResponse_Fail createEmptyInstance() => create();
  static $pb.PbList<LoginResponse_Fail> createRepeated() => $pb.PbList<LoginResponse_Fail>();
  @$core.pragma('dart2js:noInline')
  static LoginResponse_Fail getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoginResponse_Fail>(create);
  static LoginResponse_Fail? _defaultInstance;
}

enum LoginResponse_Type {
  ok, 
  fail, 
  notSet
}

class LoginResponse extends $pb.GeneratedMessage {
  factory LoginResponse({
    LoginResponse_OK? ok,
    LoginResponse_Fail? fail,
  }) {
    final $result = create();
    if (ok != null) {
      $result.ok = ok;
    }
    if (fail != null) {
      $result.fail = fail;
    }
    return $result;
  }
  LoginResponse._() : super();
  factory LoginResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoginResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, LoginResponse_Type> _LoginResponse_TypeByTag = {
    1 : LoginResponse_Type.ok,
    2 : LoginResponse_Type.fail,
    0 : LoginResponse_Type.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoginResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<LoginResponse_OK>(1, _omitFieldNames ? '' : 'ok', subBuilder: LoginResponse_OK.create)
    ..aOM<LoginResponse_Fail>(2, _omitFieldNames ? '' : 'fail', subBuilder: LoginResponse_Fail.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoginResponse clone() => LoginResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoginResponse copyWith(void Function(LoginResponse) updates) => super.copyWith((message) => updates(message as LoginResponse)) as LoginResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginResponse create() => LoginResponse._();
  LoginResponse createEmptyInstance() => create();
  static $pb.PbList<LoginResponse> createRepeated() => $pb.PbList<LoginResponse>();
  @$core.pragma('dart2js:noInline')
  static LoginResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoginResponse>(create);
  static LoginResponse? _defaultInstance;

  LoginResponse_Type whichType() => _LoginResponse_TypeByTag[$_whichOneof(0)]!;
  void clearType() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  LoginResponse_OK get ok => $_getN(0);
  @$pb.TagNumber(1)
  set ok(LoginResponse_OK v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasOk() => $_has(0);
  @$pb.TagNumber(1)
  void clearOk() => clearField(1);
  @$pb.TagNumber(1)
  LoginResponse_OK ensureOk() => $_ensure(0);

  @$pb.TagNumber(2)
  LoginResponse_Fail get fail => $_getN(1);
  @$pb.TagNumber(2)
  set fail(LoginResponse_Fail v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasFail() => $_has(1);
  @$pb.TagNumber(2)
  void clearFail() => clearField(2);
  @$pb.TagNumber(2)
  LoginResponse_Fail ensureFail() => $_ensure(1);
}

class Connect extends $pb.GeneratedMessage {
  factory Connect() => create();
  Connect._() : super();
  factory Connect.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Connect.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Connect', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Connect clone() => Connect()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Connect copyWith(void Function(Connect) updates) => super.copyWith((message) => updates(message as Connect)) as Connect;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Connect create() => Connect._();
  Connect createEmptyInstance() => create();
  static $pb.PbList<Connect> createRepeated() => $pb.PbList<Connect>();
  @$core.pragma('dart2js:noInline')
  static Connect getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Connect>(create);
  static Connect? _defaultInstance;
}

class Disconnect extends $pb.GeneratedMessage {
  factory Disconnect() => create();
  Disconnect._() : super();
  factory Disconnect.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Disconnect.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Disconnect', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Disconnect clone() => Disconnect()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Disconnect copyWith(void Function(Disconnect) updates) => super.copyWith((message) => updates(message as Disconnect)) as Disconnect;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Disconnect create() => Disconnect._();
  Disconnect createEmptyInstance() => create();
  static $pb.PbList<Disconnect> createRepeated() => $pb.PbList<Disconnect>();
  @$core.pragma('dart2js:noInline')
  static Disconnect getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Disconnect>(create);
  static Disconnect? _defaultInstance;
}

class Receive extends $pb.GeneratedMessage {
  factory Receive() => create();
  Receive._() : super();
  factory Receive.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Receive.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Receive', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Receive clone() => Receive()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Receive copyWith(void Function(Receive) updates) => super.copyWith((message) => updates(message as Receive)) as Receive;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Receive create() => Receive._();
  Receive createEmptyInstance() => create();
  static $pb.PbList<Receive> createRepeated() => $pb.PbList<Receive>();
  @$core.pragma('dart2js:noInline')
  static Receive getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Receive>(create);
  static Receive? _defaultInstance;
}

class Send extends $pb.GeneratedMessage {
  factory Send() => create();
  Send._() : super();
  factory Send.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Send.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Send', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Send clone() => Send()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Send copyWith(void Function(Send) updates) => super.copyWith((message) => updates(message as Send)) as Send;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Send create() => Send._();
  Send createEmptyInstance() => create();
  static $pb.PbList<Send> createRepeated() => $pb.PbList<Send>();
  @$core.pragma('dart2js:noInline')
  static Send getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Send>(create);
  static Send? _defaultInstance;
}

class Request extends $pb.GeneratedMessage {
  factory Request({
    $core.int? count,
  }) {
    final $result = create();
    if (count != null) {
      $result.count = count;
    }
    return $result;
  }
  Request._() : super();
  factory Request.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Request.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Request', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'count', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Request clone() => Request()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Request copyWith(void Function(Request) updates) => super.copyWith((message) => updates(message as Request)) as Request;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Request create() => Request._();
  Request createEmptyInstance() => create();
  static $pb.PbList<Request> createRepeated() => $pb.PbList<Request>();
  @$core.pragma('dart2js:noInline')
  static Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Request>(create);
  static Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get count => $_getIZ(0);
  @$pb.TagNumber(1)
  set count($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearCount() => clearField(1);
}

class Remove extends $pb.GeneratedMessage {
  factory Remove() => create();
  Remove._() : super();
  factory Remove.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Remove.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Remove', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Remove clone() => Remove()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Remove copyWith(void Function(Remove) updates) => super.copyWith((message) => updates(message as Remove)) as Remove;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Remove create() => Remove._();
  Remove createEmptyInstance() => create();
  static $pb.PbList<Remove> createRepeated() => $pb.PbList<Remove>();
  @$core.pragma('dart2js:noInline')
  static Remove getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Remove>(create);
  static Remove? _defaultInstance;
}

class ClearDesk extends $pb.GeneratedMessage {
  factory ClearDesk() => create();
  ClearDesk._() : super();
  factory ClearDesk.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ClearDesk.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ClearDesk', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ClearDesk clone() => ClearDesk()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ClearDesk copyWith(void Function(ClearDesk) updates) => super.copyWith((message) => updates(message as ClearDesk)) as ClearDesk;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClearDesk create() => ClearDesk._();
  ClearDesk createEmptyInstance() => create();
  static $pb.PbList<ClearDesk> createRepeated() => $pb.PbList<ClearDesk>();
  @$core.pragma('dart2js:noInline')
  static ClearDesk getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClearDesk>(create);
  static ClearDesk? _defaultInstance;
}

class Notification extends $pb.GeneratedMessage {
  factory Notification() => create();
  Notification._() : super();
  factory Notification.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Notification.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Notification', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Notification clone() => Notification()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Notification copyWith(void Function(Notification) updates) => super.copyWith((message) => updates(message as Notification)) as Notification;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notification create() => Notification._();
  Notification createEmptyInstance() => create();
  static $pb.PbList<Notification> createRepeated() => $pb.PbList<Notification>();
  @$core.pragma('dart2js:noInline')
  static Notification getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Notification>(create);
  static Notification? _defaultInstance;
}

class Leave extends $pb.GeneratedMessage {
  factory Leave() => create();
  Leave._() : super();
  factory Leave.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Leave.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Leave', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Leave clone() => Leave()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Leave copyWith(void Function(Leave) updates) => super.copyWith((message) => updates(message as Leave)) as Leave;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Leave create() => Leave._();
  Leave createEmptyInstance() => create();
  static $pb.PbList<Leave> createRepeated() => $pb.PbList<Leave>();
  @$core.pragma('dart2js:noInline')
  static Leave getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Leave>(create);
  static Leave? _defaultInstance;
}

class ReplayLink extends $pb.GeneratedMessage {
  factory ReplayLink({
    $core.String? replay,
  }) {
    final $result = create();
    if (replay != null) {
      $result.replay = replay;
    }
    return $result;
  }
  ReplayLink._() : super();
  factory ReplayLink.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReplayLink.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReplayLink', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'replay')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReplayLink clone() => ReplayLink()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReplayLink copyWith(void Function(ReplayLink) updates) => super.copyWith((message) => updates(message as ReplayLink)) as ReplayLink;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReplayLink create() => ReplayLink._();
  ReplayLink createEmptyInstance() => create();
  static $pb.PbList<ReplayLink> createRepeated() => $pb.PbList<ReplayLink>();
  @$core.pragma('dart2js:noInline')
  static ReplayLink getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReplayLink>(create);
  static ReplayLink? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get replay => $_getSZ(0);
  @$pb.TagNumber(1)
  set replay($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasReplay() => $_has(0);
  @$pb.TagNumber(1)
  void clearReplay() => clearField(1);
}

class ReplayMove extends $pb.GeneratedMessage {
  factory ReplayMove() => create();
  ReplayMove._() : super();
  factory ReplayMove.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReplayMove.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReplayMove', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReplayMove clone() => ReplayMove()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReplayMove copyWith(void Function(ReplayMove) updates) => super.copyWith((message) => updates(message as ReplayMove)) as ReplayMove;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReplayMove create() => ReplayMove._();
  ReplayMove createEmptyInstance() => create();
  static $pb.PbList<ReplayMove> createRepeated() => $pb.PbList<ReplayMove>();
  @$core.pragma('dart2js:noInline')
  static ReplayMove getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReplayMove>(create);
  static ReplayMove? _defaultInstance;
}

class ReplaySelectGame extends $pb.GeneratedMessage {
  factory ReplaySelectGame({
    $core.int? game,
  }) {
    final $result = create();
    if (game != null) {
      $result.game = game;
    }
    return $result;
  }
  ReplaySelectGame._() : super();
  factory ReplaySelectGame.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReplaySelectGame.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReplaySelectGame', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'game', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReplaySelectGame clone() => ReplaySelectGame()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReplaySelectGame copyWith(void Function(ReplaySelectGame) updates) => super.copyWith((message) => updates(message as ReplaySelectGame)) as ReplaySelectGame;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReplaySelectGame create() => ReplaySelectGame._();
  ReplaySelectGame createEmptyInstance() => create();
  static $pb.PbList<ReplaySelectGame> createRepeated() => $pb.PbList<ReplaySelectGame>();
  @$core.pragma('dart2js:noInline')
  static ReplaySelectGame getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReplaySelectGame>(create);
  static ReplaySelectGame? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get game => $_getIZ(0);
  @$pb.TagNumber(1)
  set game($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGame() => $_has(0);
  @$pb.TagNumber(1)
  void clearGame() => clearField(1);
}

class StartEarly extends $pb.GeneratedMessage {
  factory StartEarly() => create();
  StartEarly._() : super();
  factory StartEarly.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StartEarly.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'StartEarly', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StartEarly clone() => StartEarly()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StartEarly copyWith(void Function(StartEarly) updates) => super.copyWith((message) => updates(message as StartEarly)) as StartEarly;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartEarly create() => StartEarly._();
  StartEarly createEmptyInstance() => create();
  static $pb.PbList<StartEarly> createRepeated() => $pb.PbList<StartEarly>();
  @$core.pragma('dart2js:noInline')
  static StartEarly getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StartEarly>(create);
  static StartEarly? _defaultInstance;
}

class GameInfo extends $pb.GeneratedMessage {
  factory GameInfo({
    $core.int? gamesPlayed,
    $core.int? gamesRequired,
    $core.bool? canExtendGame,
  }) {
    final $result = create();
    if (gamesPlayed != null) {
      $result.gamesPlayed = gamesPlayed;
    }
    if (gamesRequired != null) {
      $result.gamesRequired = gamesRequired;
    }
    if (canExtendGame != null) {
      $result.canExtendGame = canExtendGame;
    }
    return $result;
  }
  GameInfo._() : super();
  factory GameInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GameInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GameInfo', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'gamesPlayed', $pb.PbFieldType.O3, protoName: 'gamesPlayed')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'gamesRequired', $pb.PbFieldType.O3, protoName: 'gamesRequired')
    ..aOB(3, _omitFieldNames ? '' : 'canExtendGame', protoName: 'canExtendGame')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GameInfo clone() => GameInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GameInfo copyWith(void Function(GameInfo) updates) => super.copyWith((message) => updates(message as GameInfo)) as GameInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GameInfo create() => GameInfo._();
  GameInfo createEmptyInstance() => create();
  static $pb.PbList<GameInfo> createRepeated() => $pb.PbList<GameInfo>();
  @$core.pragma('dart2js:noInline')
  static GameInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GameInfo>(create);
  static GameInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get gamesPlayed => $_getIZ(0);
  @$pb.TagNumber(1)
  set gamesPlayed($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGamesPlayed() => $_has(0);
  @$pb.TagNumber(1)
  void clearGamesPlayed() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get gamesRequired => $_getIZ(1);
  @$pb.TagNumber(2)
  set gamesRequired($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGamesRequired() => $_has(1);
  @$pb.TagNumber(2)
  void clearGamesRequired() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get canExtendGame => $_getBF(2);
  @$pb.TagNumber(3)
  set canExtendGame($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCanExtendGame() => $_has(2);
  @$pb.TagNumber(3)
  void clearCanExtendGame() => clearField(3);
}

enum GameEnd_Type {
  results, 
  request, 
  notSet
}

class GameEnd extends $pb.GeneratedMessage {
  factory GameEnd({
    Results? results,
    Request? request,
  }) {
    final $result = create();
    if (results != null) {
      $result.results = results;
    }
    if (request != null) {
      $result.request = request;
    }
    return $result;
  }
  GameEnd._() : super();
  factory GameEnd.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GameEnd.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, GameEnd_Type> _GameEnd_TypeByTag = {
    1 : GameEnd_Type.results,
    2 : GameEnd_Type.request,
    0 : GameEnd_Type.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GameEnd', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<Results>(1, _omitFieldNames ? '' : 'results', subBuilder: Results.create)
    ..aOM<Request>(2, _omitFieldNames ? '' : 'request', subBuilder: Request.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GameEnd clone() => GameEnd()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GameEnd copyWith(void Function(GameEnd) updates) => super.copyWith((message) => updates(message as GameEnd)) as GameEnd;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GameEnd create() => GameEnd._();
  GameEnd createEmptyInstance() => create();
  static $pb.PbList<GameEnd> createRepeated() => $pb.PbList<GameEnd>();
  @$core.pragma('dart2js:noInline')
  static GameEnd getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GameEnd>(create);
  static GameEnd? _defaultInstance;

  GameEnd_Type whichType() => _GameEnd_TypeByTag[$_whichOneof(0)]!;
  void clearType() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Results get results => $_getN(0);
  @$pb.TagNumber(1)
  set results(Results v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasResults() => $_has(0);
  @$pb.TagNumber(1)
  void clearResults() => clearField(1);
  @$pb.TagNumber(1)
  Results ensureResults() => $_ensure(0);

  @$pb.TagNumber(2)
  Request get request => $_getN(1);
  @$pb.TagNumber(2)
  set request(Request v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRequest() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequest() => clearField(2);
  @$pb.TagNumber(2)
  Request ensureRequest() => $_ensure(1);
}

enum Connection_Type {
  join, 
  disconnect, 
  leave, 
  notSet
}

class Connection extends $pb.GeneratedMessage {
  factory Connection({
    $core.int? rating,
    Connect? join,
    Disconnect? disconnect,
    Leave? leave,
  }) {
    final $result = create();
    if (rating != null) {
      $result.rating = rating;
    }
    if (join != null) {
      $result.join = join;
    }
    if (disconnect != null) {
      $result.disconnect = disconnect;
    }
    if (leave != null) {
      $result.leave = leave;
    }
    return $result;
  }
  Connection._() : super();
  factory Connection.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Connection.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, Connection_Type> _Connection_TypeByTag = {
    3 : Connection_Type.join,
    4 : Connection_Type.disconnect,
    5 : Connection_Type.leave,
    0 : Connection_Type.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Connection', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..oo(0, [3, 4, 5])
    ..a<$core.int>(2, _omitFieldNames ? '' : 'rating', $pb.PbFieldType.O3)
    ..aOM<Connect>(3, _omitFieldNames ? '' : 'join', subBuilder: Connect.create)
    ..aOM<Disconnect>(4, _omitFieldNames ? '' : 'disconnect', subBuilder: Disconnect.create)
    ..aOM<Leave>(5, _omitFieldNames ? '' : 'leave', subBuilder: Leave.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Connection clone() => Connection()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Connection copyWith(void Function(Connection) updates) => super.copyWith((message) => updates(message as Connection)) as Connection;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Connection create() => Connection._();
  Connection createEmptyInstance() => create();
  static $pb.PbList<Connection> createRepeated() => $pb.PbList<Connection>();
  @$core.pragma('dart2js:noInline')
  static Connection getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Connection>(create);
  static Connection? _defaultInstance;

  Connection_Type whichType() => _Connection_TypeByTag[$_whichOneof(0)]!;
  void clearType() => clearField($_whichOneof(0));

  @$pb.TagNumber(2)
  $core.int get rating => $_getIZ(0);
  @$pb.TagNumber(2)
  set rating($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(2)
  $core.bool hasRating() => $_has(0);
  @$pb.TagNumber(2)
  void clearRating() => clearField(2);

  @$pb.TagNumber(3)
  Connect get join => $_getN(1);
  @$pb.TagNumber(3)
  set join(Connect v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasJoin() => $_has(1);
  @$pb.TagNumber(3)
  void clearJoin() => clearField(3);
  @$pb.TagNumber(3)
  Connect ensureJoin() => $_ensure(1);

  @$pb.TagNumber(4)
  Disconnect get disconnect => $_getN(2);
  @$pb.TagNumber(4)
  set disconnect(Disconnect v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasDisconnect() => $_has(2);
  @$pb.TagNumber(4)
  void clearDisconnect() => clearField(4);
  @$pb.TagNumber(4)
  Disconnect ensureDisconnect() => $_ensure(2);

  @$pb.TagNumber(5)
  Leave get leave => $_getN(3);
  @$pb.TagNumber(5)
  set leave(Leave v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasLeave() => $_has(3);
  @$pb.TagNumber(5)
  void clearLeave() => clearField(5);
  @$pb.TagNumber(5)
  Leave ensureLeave() => $_ensure(3);
}

class Licitiranje extends $pb.GeneratedMessage {
  factory Licitiranje({
    $core.int? type,
  }) {
    final $result = create();
    if (type != null) {
      $result.type = type;
    }
    return $result;
  }
  Licitiranje._() : super();
  factory Licitiranje.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Licitiranje.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Licitiranje', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'type', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Licitiranje clone() => Licitiranje()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Licitiranje copyWith(void Function(Licitiranje) updates) => super.copyWith((message) => updates(message as Licitiranje)) as Licitiranje;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Licitiranje create() => Licitiranje._();
  Licitiranje createEmptyInstance() => create();
  static $pb.PbList<Licitiranje> createRepeated() => $pb.PbList<Licitiranje>();
  @$core.pragma('dart2js:noInline')
  static Licitiranje getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Licitiranje>(create);
  static Licitiranje? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get type => $_getIZ(0);
  @$pb.TagNumber(1)
  set type($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);
}

class LicitiranjeStart extends $pb.GeneratedMessage {
  factory LicitiranjeStart() => create();
  LicitiranjeStart._() : super();
  factory LicitiranjeStart.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LicitiranjeStart.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LicitiranjeStart', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LicitiranjeStart clone() => LicitiranjeStart()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LicitiranjeStart copyWith(void Function(LicitiranjeStart) updates) => super.copyWith((message) => updates(message as LicitiranjeStart)) as LicitiranjeStart;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LicitiranjeStart create() => LicitiranjeStart._();
  LicitiranjeStart createEmptyInstance() => create();
  static $pb.PbList<LicitiranjeStart> createRepeated() => $pb.PbList<LicitiranjeStart>();
  @$core.pragma('dart2js:noInline')
  static LicitiranjeStart getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LicitiranjeStart>(create);
  static LicitiranjeStart? _defaultInstance;
}

enum Card_Type {
  receive, 
  send, 
  request, 
  remove, 
  notSet
}

class Card extends $pb.GeneratedMessage {
  factory Card({
    $core.String? id,
    $core.String? userId,
    Receive? receive,
    Send? send,
    Request? request,
    Remove? remove,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (userId != null) {
      $result.userId = userId;
    }
    if (receive != null) {
      $result.receive = receive;
    }
    if (send != null) {
      $result.send = send;
    }
    if (request != null) {
      $result.request = request;
    }
    if (remove != null) {
      $result.remove = remove;
    }
    return $result;
  }
  Card._() : super();
  factory Card.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Card.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, Card_Type> _Card_TypeByTag = {
    3 : Card_Type.receive,
    4 : Card_Type.send,
    5 : Card_Type.request,
    6 : Card_Type.remove,
    0 : Card_Type.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Card', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..oo(0, [3, 4, 5, 6])
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'userId', protoName: 'userId')
    ..aOM<Receive>(3, _omitFieldNames ? '' : 'receive', subBuilder: Receive.create)
    ..aOM<Send>(4, _omitFieldNames ? '' : 'send', subBuilder: Send.create)
    ..aOM<Request>(5, _omitFieldNames ? '' : 'request', subBuilder: Request.create)
    ..aOM<Remove>(6, _omitFieldNames ? '' : 'remove', subBuilder: Remove.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Card clone() => Card()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Card copyWith(void Function(Card) updates) => super.copyWith((message) => updates(message as Card)) as Card;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Card create() => Card._();
  Card createEmptyInstance() => create();
  static $pb.PbList<Card> createRepeated() => $pb.PbList<Card>();
  @$core.pragma('dart2js:noInline')
  static Card getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Card>(create);
  static Card? _defaultInstance;

  Card_Type whichType() => _Card_TypeByTag[$_whichOneof(0)]!;
  void clearType() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => clearField(2);

  @$pb.TagNumber(3)
  Receive get receive => $_getN(2);
  @$pb.TagNumber(3)
  set receive(Receive v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasReceive() => $_has(2);
  @$pb.TagNumber(3)
  void clearReceive() => clearField(3);
  @$pb.TagNumber(3)
  Receive ensureReceive() => $_ensure(2);

  @$pb.TagNumber(4)
  Send get send => $_getN(3);
  @$pb.TagNumber(4)
  set send(Send v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasSend() => $_has(3);
  @$pb.TagNumber(4)
  void clearSend() => clearField(4);
  @$pb.TagNumber(4)
  Send ensureSend() => $_ensure(3);

  @$pb.TagNumber(5)
  Request get request => $_getN(4);
  @$pb.TagNumber(5)
  set request(Request v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasRequest() => $_has(4);
  @$pb.TagNumber(5)
  void clearRequest() => clearField(5);
  @$pb.TagNumber(5)
  Request ensureRequest() => $_ensure(4);

  @$pb.TagNumber(6)
  Remove get remove => $_getN(5);
  @$pb.TagNumber(6)
  set remove(Remove v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasRemove() => $_has(5);
  @$pb.TagNumber(6)
  void clearRemove() => clearField(6);
  @$pb.TagNumber(6)
  Remove ensureRemove() => $_ensure(5);
}

class GameStartCountdown extends $pb.GeneratedMessage {
  factory GameStartCountdown({
    $core.int? countdown,
  }) {
    final $result = create();
    if (countdown != null) {
      $result.countdown = countdown;
    }
    return $result;
  }
  GameStartCountdown._() : super();
  factory GameStartCountdown.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GameStartCountdown.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GameStartCountdown', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'countdown', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GameStartCountdown clone() => GameStartCountdown()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GameStartCountdown copyWith(void Function(GameStartCountdown) updates) => super.copyWith((message) => updates(message as GameStartCountdown)) as GameStartCountdown;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GameStartCountdown create() => GameStartCountdown._();
  GameStartCountdown createEmptyInstance() => create();
  static $pb.PbList<GameStartCountdown> createRepeated() => $pb.PbList<GameStartCountdown>();
  @$core.pragma('dart2js:noInline')
  static GameStartCountdown getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GameStartCountdown>(create);
  static GameStartCountdown? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get countdown => $_getIZ(0);
  @$pb.TagNumber(1)
  set countdown($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCountdown() => $_has(0);
  @$pb.TagNumber(1)
  void clearCountdown() => clearField(1);
}

class User extends $pb.GeneratedMessage {
  factory User({
    $core.String? id,
    $core.String? name,
    $core.int? position,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (name != null) {
      $result.name = name;
    }
    if (position != null) {
      $result.position = position;
    }
    return $result;
  }
  User._() : super();
  factory User.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory User.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'User', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'position', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  User clone() => User()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  User copyWith(void Function(User) updates) => super.copyWith((message) => updates(message as User)) as User;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static User create() => User._();
  User createEmptyInstance() => create();
  static $pb.PbList<User> createRepeated() => $pb.PbList<User>();
  @$core.pragma('dart2js:noInline')
  static User getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<User>(create);
  static User? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get position => $_getIZ(2);
  @$pb.TagNumber(3)
  set position($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPosition() => $_has(2);
  @$pb.TagNumber(3)
  void clearPosition() => clearField(3);
}

class ResultsUser extends $pb.GeneratedMessage {
  factory ResultsUser({
    $core.Iterable<User>? user,
    $core.bool? playing,
    $core.int? points,
    $core.int? trula,
    $core.int? pagat,
    $core.int? igra,
    $core.int? razlika,
    $core.int? kralj,
    $core.int? kralji,
    $core.int? kontraPagat,
    $core.int? kontraIgra,
    $core.int? kontraKralj,
    $core.int? kontraMondfang,
    $core.bool? mondfang,
    $core.bool? showGamemode,
    $core.bool? showDifference,
    $core.bool? showKralj,
    $core.bool? showPagat,
    $core.bool? showKralji,
    $core.bool? showTrula,
    $core.bool? radelc,
    $core.bool? skisfang,
  }) {
    final $result = create();
    if (user != null) {
      $result.user.addAll(user);
    }
    if (playing != null) {
      $result.playing = playing;
    }
    if (points != null) {
      $result.points = points;
    }
    if (trula != null) {
      $result.trula = trula;
    }
    if (pagat != null) {
      $result.pagat = pagat;
    }
    if (igra != null) {
      $result.igra = igra;
    }
    if (razlika != null) {
      $result.razlika = razlika;
    }
    if (kralj != null) {
      $result.kralj = kralj;
    }
    if (kralji != null) {
      $result.kralji = kralji;
    }
    if (kontraPagat != null) {
      $result.kontraPagat = kontraPagat;
    }
    if (kontraIgra != null) {
      $result.kontraIgra = kontraIgra;
    }
    if (kontraKralj != null) {
      $result.kontraKralj = kontraKralj;
    }
    if (kontraMondfang != null) {
      $result.kontraMondfang = kontraMondfang;
    }
    if (mondfang != null) {
      $result.mondfang = mondfang;
    }
    if (showGamemode != null) {
      $result.showGamemode = showGamemode;
    }
    if (showDifference != null) {
      $result.showDifference = showDifference;
    }
    if (showKralj != null) {
      $result.showKralj = showKralj;
    }
    if (showPagat != null) {
      $result.showPagat = showPagat;
    }
    if (showKralji != null) {
      $result.showKralji = showKralji;
    }
    if (showTrula != null) {
      $result.showTrula = showTrula;
    }
    if (radelc != null) {
      $result.radelc = radelc;
    }
    if (skisfang != null) {
      $result.skisfang = skisfang;
    }
    return $result;
  }
  ResultsUser._() : super();
  factory ResultsUser.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ResultsUser.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ResultsUser', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..pc<User>(1, _omitFieldNames ? '' : 'user', $pb.PbFieldType.PM, subBuilder: User.create)
    ..aOB(2, _omitFieldNames ? '' : 'playing')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'points', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'trula', $pb.PbFieldType.O3)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'pagat', $pb.PbFieldType.O3)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'igra', $pb.PbFieldType.O3)
    ..a<$core.int>(7, _omitFieldNames ? '' : 'razlika', $pb.PbFieldType.O3)
    ..a<$core.int>(8, _omitFieldNames ? '' : 'kralj', $pb.PbFieldType.O3)
    ..a<$core.int>(9, _omitFieldNames ? '' : 'kralji', $pb.PbFieldType.O3)
    ..a<$core.int>(10, _omitFieldNames ? '' : 'kontraPagat', $pb.PbFieldType.O3)
    ..a<$core.int>(11, _omitFieldNames ? '' : 'kontraIgra', $pb.PbFieldType.O3)
    ..a<$core.int>(12, _omitFieldNames ? '' : 'kontraKralj', $pb.PbFieldType.O3)
    ..a<$core.int>(13, _omitFieldNames ? '' : 'kontraMondfang', $pb.PbFieldType.O3)
    ..aOB(14, _omitFieldNames ? '' : 'mondfang')
    ..aOB(15, _omitFieldNames ? '' : 'showGamemode')
    ..aOB(16, _omitFieldNames ? '' : 'showDifference')
    ..aOB(17, _omitFieldNames ? '' : 'showKralj')
    ..aOB(18, _omitFieldNames ? '' : 'showPagat')
    ..aOB(19, _omitFieldNames ? '' : 'showKralji')
    ..aOB(20, _omitFieldNames ? '' : 'showTrula')
    ..aOB(21, _omitFieldNames ? '' : 'radelc')
    ..aOB(22, _omitFieldNames ? '' : 'skisfang')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ResultsUser clone() => ResultsUser()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ResultsUser copyWith(void Function(ResultsUser) updates) => super.copyWith((message) => updates(message as ResultsUser)) as ResultsUser;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResultsUser create() => ResultsUser._();
  ResultsUser createEmptyInstance() => create();
  static $pb.PbList<ResultsUser> createRepeated() => $pb.PbList<ResultsUser>();
  @$core.pragma('dart2js:noInline')
  static ResultsUser getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ResultsUser>(create);
  static ResultsUser? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<User> get user => $_getList(0);

  @$pb.TagNumber(2)
  $core.bool get playing => $_getBF(1);
  @$pb.TagNumber(2)
  set playing($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPlaying() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlaying() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get points => $_getIZ(2);
  @$pb.TagNumber(3)
  set points($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPoints() => $_has(2);
  @$pb.TagNumber(3)
  void clearPoints() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get trula => $_getIZ(3);
  @$pb.TagNumber(4)
  set trula($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTrula() => $_has(3);
  @$pb.TagNumber(4)
  void clearTrula() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get pagat => $_getIZ(4);
  @$pb.TagNumber(5)
  set pagat($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPagat() => $_has(4);
  @$pb.TagNumber(5)
  void clearPagat() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get igra => $_getIZ(5);
  @$pb.TagNumber(6)
  set igra($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasIgra() => $_has(5);
  @$pb.TagNumber(6)
  void clearIgra() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get razlika => $_getIZ(6);
  @$pb.TagNumber(7)
  set razlika($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasRazlika() => $_has(6);
  @$pb.TagNumber(7)
  void clearRazlika() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get kralj => $_getIZ(7);
  @$pb.TagNumber(8)
  set kralj($core.int v) { $_setSignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasKralj() => $_has(7);
  @$pb.TagNumber(8)
  void clearKralj() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get kralji => $_getIZ(8);
  @$pb.TagNumber(9)
  set kralji($core.int v) { $_setSignedInt32(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasKralji() => $_has(8);
  @$pb.TagNumber(9)
  void clearKralji() => clearField(9);

  @$pb.TagNumber(10)
  $core.int get kontraPagat => $_getIZ(9);
  @$pb.TagNumber(10)
  set kontraPagat($core.int v) { $_setSignedInt32(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasKontraPagat() => $_has(9);
  @$pb.TagNumber(10)
  void clearKontraPagat() => clearField(10);

  @$pb.TagNumber(11)
  $core.int get kontraIgra => $_getIZ(10);
  @$pb.TagNumber(11)
  set kontraIgra($core.int v) { $_setSignedInt32(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasKontraIgra() => $_has(10);
  @$pb.TagNumber(11)
  void clearKontraIgra() => clearField(11);

  @$pb.TagNumber(12)
  $core.int get kontraKralj => $_getIZ(11);
  @$pb.TagNumber(12)
  set kontraKralj($core.int v) { $_setSignedInt32(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasKontraKralj() => $_has(11);
  @$pb.TagNumber(12)
  void clearKontraKralj() => clearField(12);

  @$pb.TagNumber(13)
  $core.int get kontraMondfang => $_getIZ(12);
  @$pb.TagNumber(13)
  set kontraMondfang($core.int v) { $_setSignedInt32(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasKontraMondfang() => $_has(12);
  @$pb.TagNumber(13)
  void clearKontraMondfang() => clearField(13);

  @$pb.TagNumber(14)
  $core.bool get mondfang => $_getBF(13);
  @$pb.TagNumber(14)
  set mondfang($core.bool v) { $_setBool(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasMondfang() => $_has(13);
  @$pb.TagNumber(14)
  void clearMondfang() => clearField(14);

  @$pb.TagNumber(15)
  $core.bool get showGamemode => $_getBF(14);
  @$pb.TagNumber(15)
  set showGamemode($core.bool v) { $_setBool(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasShowGamemode() => $_has(14);
  @$pb.TagNumber(15)
  void clearShowGamemode() => clearField(15);

  @$pb.TagNumber(16)
  $core.bool get showDifference => $_getBF(15);
  @$pb.TagNumber(16)
  set showDifference($core.bool v) { $_setBool(15, v); }
  @$pb.TagNumber(16)
  $core.bool hasShowDifference() => $_has(15);
  @$pb.TagNumber(16)
  void clearShowDifference() => clearField(16);

  @$pb.TagNumber(17)
  $core.bool get showKralj => $_getBF(16);
  @$pb.TagNumber(17)
  set showKralj($core.bool v) { $_setBool(16, v); }
  @$pb.TagNumber(17)
  $core.bool hasShowKralj() => $_has(16);
  @$pb.TagNumber(17)
  void clearShowKralj() => clearField(17);

  @$pb.TagNumber(18)
  $core.bool get showPagat => $_getBF(17);
  @$pb.TagNumber(18)
  set showPagat($core.bool v) { $_setBool(17, v); }
  @$pb.TagNumber(18)
  $core.bool hasShowPagat() => $_has(17);
  @$pb.TagNumber(18)
  void clearShowPagat() => clearField(18);

  @$pb.TagNumber(19)
  $core.bool get showKralji => $_getBF(18);
  @$pb.TagNumber(19)
  set showKralji($core.bool v) { $_setBool(18, v); }
  @$pb.TagNumber(19)
  $core.bool hasShowKralji() => $_has(18);
  @$pb.TagNumber(19)
  void clearShowKralji() => clearField(19);

  @$pb.TagNumber(20)
  $core.bool get showTrula => $_getBF(19);
  @$pb.TagNumber(20)
  set showTrula($core.bool v) { $_setBool(19, v); }
  @$pb.TagNumber(20)
  $core.bool hasShowTrula() => $_has(19);
  @$pb.TagNumber(20)
  void clearShowTrula() => clearField(20);

  @$pb.TagNumber(21)
  $core.bool get radelc => $_getBF(20);
  @$pb.TagNumber(21)
  set radelc($core.bool v) { $_setBool(20, v); }
  @$pb.TagNumber(21)
  $core.bool hasRadelc() => $_has(20);
  @$pb.TagNumber(21)
  void clearRadelc() => clearField(21);

  @$pb.TagNumber(22)
  $core.bool get skisfang => $_getBF(21);
  @$pb.TagNumber(22)
  set skisfang($core.bool v) { $_setBool(21, v); }
  @$pb.TagNumber(22)
  $core.bool hasSkisfang() => $_has(21);
  @$pb.TagNumber(22)
  void clearSkisfang() => clearField(22);
}

class Stih extends $pb.GeneratedMessage {
  factory Stih({
    $core.Iterable<Card>? card,
    $core.double? worth,
    $core.bool? pickedUpByPlaying,
    $core.String? pickedUpBy,
  }) {
    final $result = create();
    if (card != null) {
      $result.card.addAll(card);
    }
    if (worth != null) {
      $result.worth = worth;
    }
    if (pickedUpByPlaying != null) {
      $result.pickedUpByPlaying = pickedUpByPlaying;
    }
    if (pickedUpBy != null) {
      $result.pickedUpBy = pickedUpBy;
    }
    return $result;
  }
  Stih._() : super();
  factory Stih.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Stih.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Stih', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..pc<Card>(1, _omitFieldNames ? '' : 'card', $pb.PbFieldType.PM, subBuilder: Card.create)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'worth', $pb.PbFieldType.OF)
    ..aOB(3, _omitFieldNames ? '' : 'pickedUpByPlaying', protoName: 'pickedUpByPlaying')
    ..aOS(4, _omitFieldNames ? '' : 'pickedUpBy', protoName: 'pickedUpBy')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Stih clone() => Stih()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Stih copyWith(void Function(Stih) updates) => super.copyWith((message) => updates(message as Stih)) as Stih;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Stih create() => Stih._();
  Stih createEmptyInstance() => create();
  static $pb.PbList<Stih> createRepeated() => $pb.PbList<Stih>();
  @$core.pragma('dart2js:noInline')
  static Stih getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Stih>(create);
  static Stih? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Card> get card => $_getList(0);

  @$pb.TagNumber(2)
  $core.double get worth => $_getN(1);
  @$pb.TagNumber(2)
  set worth($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasWorth() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorth() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get pickedUpByPlaying => $_getBF(2);
  @$pb.TagNumber(3)
  set pickedUpByPlaying($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPickedUpByPlaying() => $_has(2);
  @$pb.TagNumber(3)
  void clearPickedUpByPlaying() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get pickedUpBy => $_getSZ(3);
  @$pb.TagNumber(4)
  set pickedUpBy($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPickedUpBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearPickedUpBy() => clearField(4);
}

class Results extends $pb.GeneratedMessage {
  factory Results({
    $core.Iterable<ResultsUser>? user,
    $core.Iterable<Stih>? stih,
    Predictions? predictions,
  }) {
    final $result = create();
    if (user != null) {
      $result.user.addAll(user);
    }
    if (stih != null) {
      $result.stih.addAll(stih);
    }
    if (predictions != null) {
      $result.predictions = predictions;
    }
    return $result;
  }
  Results._() : super();
  factory Results.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Results.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Results', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..pc<ResultsUser>(1, _omitFieldNames ? '' : 'user', $pb.PbFieldType.PM, subBuilder: ResultsUser.create)
    ..pc<Stih>(2, _omitFieldNames ? '' : 'stih', $pb.PbFieldType.PM, subBuilder: Stih.create)
    ..aOM<Predictions>(3, _omitFieldNames ? '' : 'predictions', subBuilder: Predictions.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Results clone() => Results()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Results copyWith(void Function(Results) updates) => super.copyWith((message) => updates(message as Results)) as Results;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Results create() => Results._();
  Results createEmptyInstance() => create();
  static $pb.PbList<Results> createRepeated() => $pb.PbList<Results>();
  @$core.pragma('dart2js:noInline')
  static Results getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Results>(create);
  static Results? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<ResultsUser> get user => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<Stih> get stih => $_getList(1);

  @$pb.TagNumber(3)
  Predictions get predictions => $_getN(2);
  @$pb.TagNumber(3)
  set predictions(Predictions v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasPredictions() => $_has(2);
  @$pb.TagNumber(3)
  void clearPredictions() => clearField(3);
  @$pb.TagNumber(3)
  Predictions ensurePredictions() => $_ensure(2);
}

class GameStart extends $pb.GeneratedMessage {
  factory GameStart({
    $core.Iterable<User>? user,
  }) {
    final $result = create();
    if (user != null) {
      $result.user.addAll(user);
    }
    return $result;
  }
  GameStart._() : super();
  factory GameStart.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GameStart.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GameStart', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..pc<User>(1, _omitFieldNames ? '' : 'user', $pb.PbFieldType.PM, subBuilder: User.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GameStart clone() => GameStart()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GameStart copyWith(void Function(GameStart) updates) => super.copyWith((message) => updates(message as GameStart)) as GameStart;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GameStart create() => GameStart._();
  GameStart createEmptyInstance() => create();
  static $pb.PbList<GameStart> createRepeated() => $pb.PbList<GameStart>();
  @$core.pragma('dart2js:noInline')
  static GameStart getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GameStart>(create);
  static GameStart? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<User> get user => $_getList(0);
}

class UserList extends $pb.GeneratedMessage {
  factory UserList({
    $core.Iterable<User>? user,
  }) {
    final $result = create();
    if (user != null) {
      $result.user.addAll(user);
    }
    return $result;
  }
  UserList._() : super();
  factory UserList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UserList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UserList', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..pc<User>(1, _omitFieldNames ? '' : 'user', $pb.PbFieldType.PM, subBuilder: User.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UserList clone() => UserList()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UserList copyWith(void Function(UserList) updates) => super.copyWith((message) => updates(message as UserList)) as UserList;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserList create() => UserList._();
  UserList createEmptyInstance() => create();
  static $pb.PbList<UserList> createRepeated() => $pb.PbList<UserList>();
  @$core.pragma('dart2js:noInline')
  static UserList getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserList>(create);
  static UserList? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<User> get user => $_getList(0);
}

enum KingSelection_Type {
  request, 
  send, 
  notification, 
  notSet
}

class KingSelection extends $pb.GeneratedMessage {
  factory KingSelection({
    $core.String? card,
    Request? request,
    Send? send,
    Notification? notification,
  }) {
    final $result = create();
    if (card != null) {
      $result.card = card;
    }
    if (request != null) {
      $result.request = request;
    }
    if (send != null) {
      $result.send = send;
    }
    if (notification != null) {
      $result.notification = notification;
    }
    return $result;
  }
  KingSelection._() : super();
  factory KingSelection.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory KingSelection.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, KingSelection_Type> _KingSelection_TypeByTag = {
    2 : KingSelection_Type.request,
    3 : KingSelection_Type.send,
    4 : KingSelection_Type.notification,
    0 : KingSelection_Type.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'KingSelection', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..oo(0, [2, 3, 4])
    ..aOS(1, _omitFieldNames ? '' : 'card')
    ..aOM<Request>(2, _omitFieldNames ? '' : 'request', subBuilder: Request.create)
    ..aOM<Send>(3, _omitFieldNames ? '' : 'send', subBuilder: Send.create)
    ..aOM<Notification>(4, _omitFieldNames ? '' : 'notification', subBuilder: Notification.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  KingSelection clone() => KingSelection()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  KingSelection copyWith(void Function(KingSelection) updates) => super.copyWith((message) => updates(message as KingSelection)) as KingSelection;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static KingSelection create() => KingSelection._();
  KingSelection createEmptyInstance() => create();
  static $pb.PbList<KingSelection> createRepeated() => $pb.PbList<KingSelection>();
  @$core.pragma('dart2js:noInline')
  static KingSelection getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<KingSelection>(create);
  static KingSelection? _defaultInstance;

  KingSelection_Type whichType() => _KingSelection_TypeByTag[$_whichOneof(0)]!;
  void clearType() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get card => $_getSZ(0);
  @$pb.TagNumber(1)
  set card($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCard() => $_has(0);
  @$pb.TagNumber(1)
  void clearCard() => clearField(1);

  @$pb.TagNumber(2)
  Request get request => $_getN(1);
  @$pb.TagNumber(2)
  set request(Request v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRequest() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequest() => clearField(2);
  @$pb.TagNumber(2)
  Request ensureRequest() => $_ensure(1);

  @$pb.TagNumber(3)
  Send get send => $_getN(2);
  @$pb.TagNumber(3)
  set send(Send v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSend() => $_has(2);
  @$pb.TagNumber(3)
  void clearSend() => clearField(3);
  @$pb.TagNumber(3)
  Send ensureSend() => $_ensure(2);

  @$pb.TagNumber(4)
  Notification get notification => $_getN(3);
  @$pb.TagNumber(4)
  set notification(Notification v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasNotification() => $_has(3);
  @$pb.TagNumber(4)
  void clearNotification() => clearField(4);
  @$pb.TagNumber(4)
  Notification ensureNotification() => $_ensure(3);
}

enum TalonSelection_Type {
  request, 
  send, 
  notification, 
  notSet
}

class TalonSelection extends $pb.GeneratedMessage {
  factory TalonSelection({
    $core.int? part,
    Request? request,
    Send? send,
    Notification? notification,
  }) {
    final $result = create();
    if (part != null) {
      $result.part = part;
    }
    if (request != null) {
      $result.request = request;
    }
    if (send != null) {
      $result.send = send;
    }
    if (notification != null) {
      $result.notification = notification;
    }
    return $result;
  }
  TalonSelection._() : super();
  factory TalonSelection.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TalonSelection.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, TalonSelection_Type> _TalonSelection_TypeByTag = {
    2 : TalonSelection_Type.request,
    3 : TalonSelection_Type.send,
    4 : TalonSelection_Type.notification,
    0 : TalonSelection_Type.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TalonSelection', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..oo(0, [2, 3, 4])
    ..a<$core.int>(1, _omitFieldNames ? '' : 'part', $pb.PbFieldType.O3)
    ..aOM<Request>(2, _omitFieldNames ? '' : 'request', subBuilder: Request.create)
    ..aOM<Send>(3, _omitFieldNames ? '' : 'send', subBuilder: Send.create)
    ..aOM<Notification>(4, _omitFieldNames ? '' : 'notification', subBuilder: Notification.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TalonSelection clone() => TalonSelection()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TalonSelection copyWith(void Function(TalonSelection) updates) => super.copyWith((message) => updates(message as TalonSelection)) as TalonSelection;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TalonSelection create() => TalonSelection._();
  TalonSelection createEmptyInstance() => create();
  static $pb.PbList<TalonSelection> createRepeated() => $pb.PbList<TalonSelection>();
  @$core.pragma('dart2js:noInline')
  static TalonSelection getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TalonSelection>(create);
  static TalonSelection? _defaultInstance;

  TalonSelection_Type whichType() => _TalonSelection_TypeByTag[$_whichOneof(0)]!;
  void clearType() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.int get part => $_getIZ(0);
  @$pb.TagNumber(1)
  set part($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPart() => $_has(0);
  @$pb.TagNumber(1)
  void clearPart() => clearField(1);

  @$pb.TagNumber(2)
  Request get request => $_getN(1);
  @$pb.TagNumber(2)
  set request(Request v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRequest() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequest() => clearField(2);
  @$pb.TagNumber(2)
  Request ensureRequest() => $_ensure(1);

  @$pb.TagNumber(3)
  Send get send => $_getN(2);
  @$pb.TagNumber(3)
  set send(Send v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSend() => $_has(2);
  @$pb.TagNumber(3)
  void clearSend() => clearField(3);
  @$pb.TagNumber(3)
  Send ensureSend() => $_ensure(2);

  @$pb.TagNumber(4)
  Notification get notification => $_getN(3);
  @$pb.TagNumber(4)
  set notification(Notification v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasNotification() => $_has(3);
  @$pb.TagNumber(4)
  void clearNotification() => clearField(4);
  @$pb.TagNumber(4)
  Notification ensureNotification() => $_ensure(3);
}

enum Stash_Type {
  request, 
  send, 
  notification, 
  notSet
}

class Stash extends $pb.GeneratedMessage {
  factory Stash({
    $core.Iterable<Card>? card,
    $core.int? length,
    Request? request,
    Send? send,
    Notification? notification,
  }) {
    final $result = create();
    if (card != null) {
      $result.card.addAll(card);
    }
    if (length != null) {
      $result.length = length;
    }
    if (request != null) {
      $result.request = request;
    }
    if (send != null) {
      $result.send = send;
    }
    if (notification != null) {
      $result.notification = notification;
    }
    return $result;
  }
  Stash._() : super();
  factory Stash.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Stash.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, Stash_Type> _Stash_TypeByTag = {
    3 : Stash_Type.request,
    4 : Stash_Type.send,
    5 : Stash_Type.notification,
    0 : Stash_Type.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Stash', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..oo(0, [3, 4, 5])
    ..pc<Card>(1, _omitFieldNames ? '' : 'card', $pb.PbFieldType.PM, subBuilder: Card.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'length', $pb.PbFieldType.O3)
    ..aOM<Request>(3, _omitFieldNames ? '' : 'request', subBuilder: Request.create)
    ..aOM<Send>(4, _omitFieldNames ? '' : 'send', subBuilder: Send.create)
    ..aOM<Notification>(5, _omitFieldNames ? '' : 'notification', subBuilder: Notification.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Stash clone() => Stash()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Stash copyWith(void Function(Stash) updates) => super.copyWith((message) => updates(message as Stash)) as Stash;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Stash create() => Stash._();
  Stash createEmptyInstance() => create();
  static $pb.PbList<Stash> createRepeated() => $pb.PbList<Stash>();
  @$core.pragma('dart2js:noInline')
  static Stash getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Stash>(create);
  static Stash? _defaultInstance;

  Stash_Type whichType() => _Stash_TypeByTag[$_whichOneof(0)]!;
  void clearType() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.List<Card> get card => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get length => $_getIZ(1);
  @$pb.TagNumber(2)
  set length($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLength() => $_has(1);
  @$pb.TagNumber(2)
  void clearLength() => clearField(2);

  @$pb.TagNumber(3)
  Request get request => $_getN(2);
  @$pb.TagNumber(3)
  set request(Request v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasRequest() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequest() => clearField(3);
  @$pb.TagNumber(3)
  Request ensureRequest() => $_ensure(2);

  @$pb.TagNumber(4)
  Send get send => $_getN(3);
  @$pb.TagNumber(4)
  set send(Send v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasSend() => $_has(3);
  @$pb.TagNumber(4)
  void clearSend() => clearField(4);
  @$pb.TagNumber(4)
  Send ensureSend() => $_ensure(3);

  @$pb.TagNumber(5)
  Notification get notification => $_getN(4);
  @$pb.TagNumber(5)
  set notification(Notification v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasNotification() => $_has(4);
  @$pb.TagNumber(5)
  void clearNotification() => clearField(5);
  @$pb.TagNumber(5)
  Notification ensureNotification() => $_ensure(4);
}

class StashedTarock extends $pb.GeneratedMessage {
  factory StashedTarock({
    Card? card,
  }) {
    final $result = create();
    if (card != null) {
      $result.card = card;
    }
    return $result;
  }
  StashedTarock._() : super();
  factory StashedTarock.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StashedTarock.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'StashedTarock', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..aOM<Card>(1, _omitFieldNames ? '' : 'card', subBuilder: Card.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StashedTarock clone() => StashedTarock()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StashedTarock copyWith(void Function(StashedTarock) updates) => super.copyWith((message) => updates(message as StashedTarock)) as StashedTarock;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StashedTarock create() => StashedTarock._();
  StashedTarock createEmptyInstance() => create();
  static $pb.PbList<StashedTarock> createRepeated() => $pb.PbList<StashedTarock>();
  @$core.pragma('dart2js:noInline')
  static StashedTarock getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StashedTarock>(create);
  static StashedTarock? _defaultInstance;

  @$pb.TagNumber(1)
  Card get card => $_getN(0);
  @$pb.TagNumber(1)
  set card(Card v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCard() => $_has(0);
  @$pb.TagNumber(1)
  void clearCard() => clearField(1);
  @$pb.TagNumber(1)
  Card ensureCard() => $_ensure(0);
}

class Radelci extends $pb.GeneratedMessage {
  factory Radelci({
    $core.int? radleci,
  }) {
    final $result = create();
    if (radleci != null) {
      $result.radleci = radleci;
    }
    return $result;
  }
  Radelci._() : super();
  factory Radelci.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Radelci.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Radelci', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'radleci', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Radelci clone() => Radelci()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Radelci copyWith(void Function(Radelci) updates) => super.copyWith((message) => updates(message as Radelci)) as Radelci;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Radelci create() => Radelci._();
  Radelci createEmptyInstance() => create();
  static $pb.PbList<Radelci> createRepeated() => $pb.PbList<Radelci>();
  @$core.pragma('dart2js:noInline')
  static Radelci getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Radelci>(create);
  static Radelci? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get radleci => $_getIZ(0);
  @$pb.TagNumber(1)
  set radleci($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRadleci() => $_has(0);
  @$pb.TagNumber(1)
  void clearRadleci() => clearField(1);
}

class StartPredictions extends $pb.GeneratedMessage {
  factory StartPredictions({
    $core.bool? kraljUltimoKontra,
    $core.bool? pagatUltimoKontra,
    $core.bool? igraKontra,
    $core.bool? valatKontra,
    $core.bool? barvniValatKontra,
    $core.bool? pagatUltimo,
    $core.bool? trula,
    $core.bool? kralji,
    $core.bool? kraljUltimo,
    $core.bool? valat,
    $core.bool? barvniValat,
    $core.bool? mondfang,
    $core.bool? mondfangKontra,
  }) {
    final $result = create();
    if (kraljUltimoKontra != null) {
      $result.kraljUltimoKontra = kraljUltimoKontra;
    }
    if (pagatUltimoKontra != null) {
      $result.pagatUltimoKontra = pagatUltimoKontra;
    }
    if (igraKontra != null) {
      $result.igraKontra = igraKontra;
    }
    if (valatKontra != null) {
      $result.valatKontra = valatKontra;
    }
    if (barvniValatKontra != null) {
      $result.barvniValatKontra = barvniValatKontra;
    }
    if (pagatUltimo != null) {
      $result.pagatUltimo = pagatUltimo;
    }
    if (trula != null) {
      $result.trula = trula;
    }
    if (kralji != null) {
      $result.kralji = kralji;
    }
    if (kraljUltimo != null) {
      $result.kraljUltimo = kraljUltimo;
    }
    if (valat != null) {
      $result.valat = valat;
    }
    if (barvniValat != null) {
      $result.barvniValat = barvniValat;
    }
    if (mondfang != null) {
      $result.mondfang = mondfang;
    }
    if (mondfangKontra != null) {
      $result.mondfangKontra = mondfangKontra;
    }
    return $result;
  }
  StartPredictions._() : super();
  factory StartPredictions.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StartPredictions.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'StartPredictions', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'kraljUltimoKontra')
    ..aOB(4, _omitFieldNames ? '' : 'pagatUltimoKontra')
    ..aOB(5, _omitFieldNames ? '' : 'igraKontra')
    ..aOB(6, _omitFieldNames ? '' : 'valatKontra')
    ..aOB(7, _omitFieldNames ? '' : 'barvniValatKontra')
    ..aOB(8, _omitFieldNames ? '' : 'pagatUltimo')
    ..aOB(9, _omitFieldNames ? '' : 'trula')
    ..aOB(10, _omitFieldNames ? '' : 'kralji')
    ..aOB(11, _omitFieldNames ? '' : 'kraljUltimo')
    ..aOB(12, _omitFieldNames ? '' : 'valat')
    ..aOB(13, _omitFieldNames ? '' : 'barvniValat')
    ..aOB(14, _omitFieldNames ? '' : 'mondfang')
    ..aOB(15, _omitFieldNames ? '' : 'mondfangKontra')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StartPredictions clone() => StartPredictions()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StartPredictions copyWith(void Function(StartPredictions) updates) => super.copyWith((message) => updates(message as StartPredictions)) as StartPredictions;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartPredictions create() => StartPredictions._();
  StartPredictions createEmptyInstance() => create();
  static $pb.PbList<StartPredictions> createRepeated() => $pb.PbList<StartPredictions>();
  @$core.pragma('dart2js:noInline')
  static StartPredictions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StartPredictions>(create);
  static StartPredictions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get kraljUltimoKontra => $_getBF(0);
  @$pb.TagNumber(1)
  set kraljUltimoKontra($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasKraljUltimoKontra() => $_has(0);
  @$pb.TagNumber(1)
  void clearKraljUltimoKontra() => clearField(1);

  /// bool trula_kontra = 2;
  /// bool kralji_kontra = 3;
  @$pb.TagNumber(4)
  $core.bool get pagatUltimoKontra => $_getBF(1);
  @$pb.TagNumber(4)
  set pagatUltimoKontra($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(4)
  $core.bool hasPagatUltimoKontra() => $_has(1);
  @$pb.TagNumber(4)
  void clearPagatUltimoKontra() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get igraKontra => $_getBF(2);
  @$pb.TagNumber(5)
  set igraKontra($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(5)
  $core.bool hasIgraKontra() => $_has(2);
  @$pb.TagNumber(5)
  void clearIgraKontra() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get valatKontra => $_getBF(3);
  @$pb.TagNumber(6)
  set valatKontra($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(6)
  $core.bool hasValatKontra() => $_has(3);
  @$pb.TagNumber(6)
  void clearValatKontra() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get barvniValatKontra => $_getBF(4);
  @$pb.TagNumber(7)
  set barvniValatKontra($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(7)
  $core.bool hasBarvniValatKontra() => $_has(4);
  @$pb.TagNumber(7)
  void clearBarvniValatKontra() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get pagatUltimo => $_getBF(5);
  @$pb.TagNumber(8)
  set pagatUltimo($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(8)
  $core.bool hasPagatUltimo() => $_has(5);
  @$pb.TagNumber(8)
  void clearPagatUltimo() => clearField(8);

  @$pb.TagNumber(9)
  $core.bool get trula => $_getBF(6);
  @$pb.TagNumber(9)
  set trula($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(9)
  $core.bool hasTrula() => $_has(6);
  @$pb.TagNumber(9)
  void clearTrula() => clearField(9);

  @$pb.TagNumber(10)
  $core.bool get kralji => $_getBF(7);
  @$pb.TagNumber(10)
  set kralji($core.bool v) { $_setBool(7, v); }
  @$pb.TagNumber(10)
  $core.bool hasKralji() => $_has(7);
  @$pb.TagNumber(10)
  void clearKralji() => clearField(10);

  @$pb.TagNumber(11)
  $core.bool get kraljUltimo => $_getBF(8);
  @$pb.TagNumber(11)
  set kraljUltimo($core.bool v) { $_setBool(8, v); }
  @$pb.TagNumber(11)
  $core.bool hasKraljUltimo() => $_has(8);
  @$pb.TagNumber(11)
  void clearKraljUltimo() => clearField(11);

  @$pb.TagNumber(12)
  $core.bool get valat => $_getBF(9);
  @$pb.TagNumber(12)
  set valat($core.bool v) { $_setBool(9, v); }
  @$pb.TagNumber(12)
  $core.bool hasValat() => $_has(9);
  @$pb.TagNumber(12)
  void clearValat() => clearField(12);

  @$pb.TagNumber(13)
  $core.bool get barvniValat => $_getBF(10);
  @$pb.TagNumber(13)
  set barvniValat($core.bool v) { $_setBool(10, v); }
  @$pb.TagNumber(13)
  $core.bool hasBarvniValat() => $_has(10);
  @$pb.TagNumber(13)
  void clearBarvniValat() => clearField(13);

  @$pb.TagNumber(14)
  $core.bool get mondfang => $_getBF(11);
  @$pb.TagNumber(14)
  set mondfang($core.bool v) { $_setBool(11, v); }
  @$pb.TagNumber(14)
  $core.bool hasMondfang() => $_has(11);
  @$pb.TagNumber(14)
  void clearMondfang() => clearField(14);

  @$pb.TagNumber(15)
  $core.bool get mondfangKontra => $_getBF(12);
  @$pb.TagNumber(15)
  set mondfangKontra($core.bool v) { $_setBool(12, v); }
  @$pb.TagNumber(15)
  $core.bool hasMondfangKontra() => $_has(12);
  @$pb.TagNumber(15)
  void clearMondfangKontra() => clearField(15);
}

class Predictions extends $pb.GeneratedMessage {
  factory Predictions({
    User? kraljUltimo,
    $core.int? kraljUltimoKontra,
    User? kraljUltimoKontraDal,
    User? trula,
    User? kralji,
    User? pagatUltimo,
    $core.int? pagatUltimoKontra,
    User? pagatUltimoKontraDal,
    User? igra,
    $core.int? igraKontra,
    User? igraKontraDal,
    User? valat,
    User? barvniValat,
    User? mondfang,
    $core.int? mondfangKontra,
    User? mondfangKontraDal,
    $core.int? gamemode,
    $core.bool? changed,
  }) {
    final $result = create();
    if (kraljUltimo != null) {
      $result.kraljUltimo = kraljUltimo;
    }
    if (kraljUltimoKontra != null) {
      $result.kraljUltimoKontra = kraljUltimoKontra;
    }
    if (kraljUltimoKontraDal != null) {
      $result.kraljUltimoKontraDal = kraljUltimoKontraDal;
    }
    if (trula != null) {
      $result.trula = trula;
    }
    if (kralji != null) {
      $result.kralji = kralji;
    }
    if (pagatUltimo != null) {
      $result.pagatUltimo = pagatUltimo;
    }
    if (pagatUltimoKontra != null) {
      $result.pagatUltimoKontra = pagatUltimoKontra;
    }
    if (pagatUltimoKontraDal != null) {
      $result.pagatUltimoKontraDal = pagatUltimoKontraDal;
    }
    if (igra != null) {
      $result.igra = igra;
    }
    if (igraKontra != null) {
      $result.igraKontra = igraKontra;
    }
    if (igraKontraDal != null) {
      $result.igraKontraDal = igraKontraDal;
    }
    if (valat != null) {
      $result.valat = valat;
    }
    if (barvniValat != null) {
      $result.barvniValat = barvniValat;
    }
    if (mondfang != null) {
      $result.mondfang = mondfang;
    }
    if (mondfangKontra != null) {
      $result.mondfangKontra = mondfangKontra;
    }
    if (mondfangKontraDal != null) {
      $result.mondfangKontraDal = mondfangKontraDal;
    }
    if (gamemode != null) {
      $result.gamemode = gamemode;
    }
    if (changed != null) {
      $result.changed = changed;
    }
    return $result;
  }
  Predictions._() : super();
  factory Predictions.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Predictions.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Predictions', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..aOM<User>(1, _omitFieldNames ? '' : 'kraljUltimo', subBuilder: User.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'kraljUltimoKontra', $pb.PbFieldType.O3)
    ..aOM<User>(3, _omitFieldNames ? '' : 'kraljUltimoKontraDal', subBuilder: User.create)
    ..aOM<User>(4, _omitFieldNames ? '' : 'trula', subBuilder: User.create)
    ..aOM<User>(7, _omitFieldNames ? '' : 'kralji', subBuilder: User.create)
    ..aOM<User>(10, _omitFieldNames ? '' : 'pagatUltimo', subBuilder: User.create)
    ..a<$core.int>(11, _omitFieldNames ? '' : 'pagatUltimoKontra', $pb.PbFieldType.O3)
    ..aOM<User>(12, _omitFieldNames ? '' : 'pagatUltimoKontraDal', subBuilder: User.create)
    ..aOM<User>(13, _omitFieldNames ? '' : 'igra', subBuilder: User.create)
    ..a<$core.int>(14, _omitFieldNames ? '' : 'igraKontra', $pb.PbFieldType.O3)
    ..aOM<User>(15, _omitFieldNames ? '' : 'igraKontraDal', subBuilder: User.create)
    ..aOM<User>(16, _omitFieldNames ? '' : 'valat', subBuilder: User.create)
    ..aOM<User>(17, _omitFieldNames ? '' : 'barvniValat', subBuilder: User.create)
    ..aOM<User>(18, _omitFieldNames ? '' : 'mondfang', subBuilder: User.create)
    ..a<$core.int>(19, _omitFieldNames ? '' : 'mondfangKontra', $pb.PbFieldType.O3)
    ..aOM<User>(20, _omitFieldNames ? '' : 'mondfangKontraDal', subBuilder: User.create)
    ..a<$core.int>(22, _omitFieldNames ? '' : 'gamemode', $pb.PbFieldType.O3)
    ..aOB(23, _omitFieldNames ? '' : 'changed')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Predictions clone() => Predictions()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Predictions copyWith(void Function(Predictions) updates) => super.copyWith((message) => updates(message as Predictions)) as Predictions;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Predictions create() => Predictions._();
  Predictions createEmptyInstance() => create();
  static $pb.PbList<Predictions> createRepeated() => $pb.PbList<Predictions>();
  @$core.pragma('dart2js:noInline')
  static Predictions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Predictions>(create);
  static Predictions? _defaultInstance;

  @$pb.TagNumber(1)
  User get kraljUltimo => $_getN(0);
  @$pb.TagNumber(1)
  set kraljUltimo(User v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasKraljUltimo() => $_has(0);
  @$pb.TagNumber(1)
  void clearKraljUltimo() => clearField(1);
  @$pb.TagNumber(1)
  User ensureKraljUltimo() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get kraljUltimoKontra => $_getIZ(1);
  @$pb.TagNumber(2)
  set kraljUltimoKontra($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasKraljUltimoKontra() => $_has(1);
  @$pb.TagNumber(2)
  void clearKraljUltimoKontra() => clearField(2);

  @$pb.TagNumber(3)
  User get kraljUltimoKontraDal => $_getN(2);
  @$pb.TagNumber(3)
  set kraljUltimoKontraDal(User v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasKraljUltimoKontraDal() => $_has(2);
  @$pb.TagNumber(3)
  void clearKraljUltimoKontraDal() => clearField(3);
  @$pb.TagNumber(3)
  User ensureKraljUltimoKontraDal() => $_ensure(2);

  @$pb.TagNumber(4)
  User get trula => $_getN(3);
  @$pb.TagNumber(4)
  set trula(User v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasTrula() => $_has(3);
  @$pb.TagNumber(4)
  void clearTrula() => clearField(4);
  @$pb.TagNumber(4)
  User ensureTrula() => $_ensure(3);

  @$pb.TagNumber(7)
  User get kralji => $_getN(4);
  @$pb.TagNumber(7)
  set kralji(User v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasKralji() => $_has(4);
  @$pb.TagNumber(7)
  void clearKralji() => clearField(7);
  @$pb.TagNumber(7)
  User ensureKralji() => $_ensure(4);

  @$pb.TagNumber(10)
  User get pagatUltimo => $_getN(5);
  @$pb.TagNumber(10)
  set pagatUltimo(User v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasPagatUltimo() => $_has(5);
  @$pb.TagNumber(10)
  void clearPagatUltimo() => clearField(10);
  @$pb.TagNumber(10)
  User ensurePagatUltimo() => $_ensure(5);

  @$pb.TagNumber(11)
  $core.int get pagatUltimoKontra => $_getIZ(6);
  @$pb.TagNumber(11)
  set pagatUltimoKontra($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(11)
  $core.bool hasPagatUltimoKontra() => $_has(6);
  @$pb.TagNumber(11)
  void clearPagatUltimoKontra() => clearField(11);

  @$pb.TagNumber(12)
  User get pagatUltimoKontraDal => $_getN(7);
  @$pb.TagNumber(12)
  set pagatUltimoKontraDal(User v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasPagatUltimoKontraDal() => $_has(7);
  @$pb.TagNumber(12)
  void clearPagatUltimoKontraDal() => clearField(12);
  @$pb.TagNumber(12)
  User ensurePagatUltimoKontraDal() => $_ensure(7);

  @$pb.TagNumber(13)
  User get igra => $_getN(8);
  @$pb.TagNumber(13)
  set igra(User v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasIgra() => $_has(8);
  @$pb.TagNumber(13)
  void clearIgra() => clearField(13);
  @$pb.TagNumber(13)
  User ensureIgra() => $_ensure(8);

  @$pb.TagNumber(14)
  $core.int get igraKontra => $_getIZ(9);
  @$pb.TagNumber(14)
  set igraKontra($core.int v) { $_setSignedInt32(9, v); }
  @$pb.TagNumber(14)
  $core.bool hasIgraKontra() => $_has(9);
  @$pb.TagNumber(14)
  void clearIgraKontra() => clearField(14);

  @$pb.TagNumber(15)
  User get igraKontraDal => $_getN(10);
  @$pb.TagNumber(15)
  set igraKontraDal(User v) { setField(15, v); }
  @$pb.TagNumber(15)
  $core.bool hasIgraKontraDal() => $_has(10);
  @$pb.TagNumber(15)
  void clearIgraKontraDal() => clearField(15);
  @$pb.TagNumber(15)
  User ensureIgraKontraDal() => $_ensure(10);

  @$pb.TagNumber(16)
  User get valat => $_getN(11);
  @$pb.TagNumber(16)
  set valat(User v) { setField(16, v); }
  @$pb.TagNumber(16)
  $core.bool hasValat() => $_has(11);
  @$pb.TagNumber(16)
  void clearValat() => clearField(16);
  @$pb.TagNumber(16)
  User ensureValat() => $_ensure(11);

  @$pb.TagNumber(17)
  User get barvniValat => $_getN(12);
  @$pb.TagNumber(17)
  set barvniValat(User v) { setField(17, v); }
  @$pb.TagNumber(17)
  $core.bool hasBarvniValat() => $_has(12);
  @$pb.TagNumber(17)
  void clearBarvniValat() => clearField(17);
  @$pb.TagNumber(17)
  User ensureBarvniValat() => $_ensure(12);

  @$pb.TagNumber(18)
  User get mondfang => $_getN(13);
  @$pb.TagNumber(18)
  set mondfang(User v) { setField(18, v); }
  @$pb.TagNumber(18)
  $core.bool hasMondfang() => $_has(13);
  @$pb.TagNumber(18)
  void clearMondfang() => clearField(18);
  @$pb.TagNumber(18)
  User ensureMondfang() => $_ensure(13);

  @$pb.TagNumber(19)
  $core.int get mondfangKontra => $_getIZ(14);
  @$pb.TagNumber(19)
  set mondfangKontra($core.int v) { $_setSignedInt32(14, v); }
  @$pb.TagNumber(19)
  $core.bool hasMondfangKontra() => $_has(14);
  @$pb.TagNumber(19)
  void clearMondfangKontra() => clearField(19);

  @$pb.TagNumber(20)
  User get mondfangKontraDal => $_getN(15);
  @$pb.TagNumber(20)
  set mondfangKontraDal(User v) { setField(20, v); }
  @$pb.TagNumber(20)
  $core.bool hasMondfangKontraDal() => $_has(15);
  @$pb.TagNumber(20)
  void clearMondfangKontraDal() => clearField(20);
  @$pb.TagNumber(20)
  User ensureMondfangKontraDal() => $_ensure(15);

  @$pb.TagNumber(22)
  $core.int get gamemode => $_getIZ(16);
  @$pb.TagNumber(22)
  set gamemode($core.int v) { $_setSignedInt32(16, v); }
  @$pb.TagNumber(22)
  $core.bool hasGamemode() => $_has(16);
  @$pb.TagNumber(22)
  void clearGamemode() => clearField(22);

  @$pb.TagNumber(23)
  $core.bool get changed => $_getBF(17);
  @$pb.TagNumber(23)
  set changed($core.bool v) { $_setBool(17, v); }
  @$pb.TagNumber(23)
  $core.bool hasChanged() => $_has(17);
  @$pb.TagNumber(23)
  void clearChanged() => clearField(23);
}

class TalonReveal extends $pb.GeneratedMessage {
  factory TalonReveal({
    $core.Iterable<Stih>? stih,
  }) {
    final $result = create();
    if (stih != null) {
      $result.stih.addAll(stih);
    }
    return $result;
  }
  TalonReveal._() : super();
  factory TalonReveal.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TalonReveal.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TalonReveal', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..pc<Stih>(1, _omitFieldNames ? '' : 'stih', $pb.PbFieldType.PM, subBuilder: Stih.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TalonReveal clone() => TalonReveal()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TalonReveal copyWith(void Function(TalonReveal) updates) => super.copyWith((message) => updates(message as TalonReveal)) as TalonReveal;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TalonReveal create() => TalonReveal._();
  TalonReveal createEmptyInstance() => create();
  static $pb.PbList<TalonReveal> createRepeated() => $pb.PbList<TalonReveal>();
  @$core.pragma('dart2js:noInline')
  static TalonReveal getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TalonReveal>(create);
  static TalonReveal? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Stih> get stih => $_getList(0);
}

class PlayingReveal extends $pb.GeneratedMessage {
  factory PlayingReveal({
    User? playing,
  }) {
    final $result = create();
    if (playing != null) {
      $result.playing = playing;
    }
    return $result;
  }
  PlayingReveal._() : super();
  factory PlayingReveal.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PlayingReveal.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PlayingReveal', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..aOM<User>(1, _omitFieldNames ? '' : 'playing', subBuilder: User.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PlayingReveal clone() => PlayingReveal()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PlayingReveal copyWith(void Function(PlayingReveal) updates) => super.copyWith((message) => updates(message as PlayingReveal)) as PlayingReveal;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayingReveal create() => PlayingReveal._();
  PlayingReveal createEmptyInstance() => create();
  static $pb.PbList<PlayingReveal> createRepeated() => $pb.PbList<PlayingReveal>();
  @$core.pragma('dart2js:noInline')
  static PlayingReveal getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlayingReveal>(create);
  static PlayingReveal? _defaultInstance;

  @$pb.TagNumber(1)
  User get playing => $_getN(0);
  @$pb.TagNumber(1)
  set playing(User v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPlaying() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlaying() => clearField(1);
  @$pb.TagNumber(1)
  User ensurePlaying() => $_ensure(0);
}

class InvitePlayer extends $pb.GeneratedMessage {
  factory InvitePlayer() => create();
  InvitePlayer._() : super();
  factory InvitePlayer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory InvitePlayer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'InvitePlayer', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  InvitePlayer clone() => InvitePlayer()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  InvitePlayer copyWith(void Function(InvitePlayer) updates) => super.copyWith((message) => updates(message as InvitePlayer)) as InvitePlayer;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InvitePlayer create() => InvitePlayer._();
  InvitePlayer createEmptyInstance() => create();
  static $pb.PbList<InvitePlayer> createRepeated() => $pb.PbList<InvitePlayer>();
  @$core.pragma('dart2js:noInline')
  static InvitePlayer getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InvitePlayer>(create);
  static InvitePlayer? _defaultInstance;
}

class ClearHand extends $pb.GeneratedMessage {
  factory ClearHand() => create();
  ClearHand._() : super();
  factory ClearHand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ClearHand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ClearHand', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ClearHand clone() => ClearHand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ClearHand copyWith(void Function(ClearHand) updates) => super.copyWith((message) => updates(message as ClearHand)) as ClearHand;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClearHand create() => ClearHand._();
  ClearHand createEmptyInstance() => create();
  static $pb.PbList<ClearHand> createRepeated() => $pb.PbList<ClearHand>();
  @$core.pragma('dart2js:noInline')
  static ClearHand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClearHand>(create);
  static ClearHand? _defaultInstance;
}

class Time extends $pb.GeneratedMessage {
  factory Time({
    $core.double? currentTime,
    $core.bool? start,
  }) {
    final $result = create();
    if (currentTime != null) {
      $result.currentTime = currentTime;
    }
    if (start != null) {
      $result.start = start;
    }
    return $result;
  }
  Time._() : super();
  factory Time.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Time.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Time', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'currentTime', $pb.PbFieldType.OF, protoName: 'currentTime')
    ..aOB(2, _omitFieldNames ? '' : 'start')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Time clone() => Time()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Time copyWith(void Function(Time) updates) => super.copyWith((message) => updates(message as Time)) as Time;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Time create() => Time._();
  Time createEmptyInstance() => create();
  static $pb.PbList<Time> createRepeated() => $pb.PbList<Time>();
  @$core.pragma('dart2js:noInline')
  static Time getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Time>(create);
  static Time? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get currentTime => $_getN(0);
  @$pb.TagNumber(1)
  set currentTime($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCurrentTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrentTime() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get start => $_getBF(1);
  @$pb.TagNumber(2)
  set start($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStart() => $_has(1);
  @$pb.TagNumber(2)
  void clearStart() => clearField(2);
}

class ChatMessage extends $pb.GeneratedMessage {
  factory ChatMessage({
    $core.String? userId,
    $core.String? message,
  }) {
    final $result = create();
    if (userId != null) {
      $result.userId = userId;
    }
    if (message != null) {
      $result.message = message;
    }
    return $result;
  }
  ChatMessage._() : super();
  factory ChatMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChatMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChatMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChatMessage clone() => ChatMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChatMessage copyWith(void Function(ChatMessage) updates) => super.copyWith((message) => updates(message as ChatMessage)) as ChatMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatMessage create() => ChatMessage._();
  ChatMessage createEmptyInstance() => create();
  static $pb.PbList<ChatMessage> createRepeated() => $pb.PbList<ChatMessage>();
  @$core.pragma('dart2js:noInline')
  static ChatMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatMessage>(create);
  static ChatMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);
}

enum Message_Data {
  connection, 
  licitiranje, 
  card, 
  licitiranjeStart, 
  gameStart, 
  loginRequest, 
  loginInfo, 
  loginResponse, 
  clearDesk, 
  results, 
  userList, 
  kingSelection, 
  startPredictions, 
  predictions, 
  talonReveal, 
  playingReveal, 
  talonSelection, 
  stash, 
  gameEnd, 
  gameStartCountdown, 
  predictionsResend, 
  radelci, 
  time, 
  chatMessage, 
  invitePlayer, 
  stashedTarock, 
  clearHand, 
  replayLink, 
  replayMove, 
  replaySelectGame, 
  gameInfo, 
  startEarly, 
  notSet
}

class Message extends $pb.GeneratedMessage {
  factory Message({
    $core.String? username,
    $core.String? playerId,
    $core.bool? silent,
    Connection? connection,
    Licitiranje? licitiranje,
    Card? card,
    LicitiranjeStart? licitiranjeStart,
    GameStart? gameStart,
    LoginRequest? loginRequest,
    LoginInfo? loginInfo,
    LoginResponse? loginResponse,
    ClearDesk? clearDesk,
    Results? results,
    UserList? userList,
    KingSelection? kingSelection,
    StartPredictions? startPredictions,
    Predictions? predictions,
    TalonReveal? talonReveal,
    PlayingReveal? playingReveal,
    TalonSelection? talonSelection,
    Stash? stash,
    GameEnd? gameEnd,
    GameStartCountdown? gameStartCountdown,
    Predictions? predictionsResend,
    Radelci? radelci,
    Time? time,
    ChatMessage? chatMessage,
    InvitePlayer? invitePlayer,
    StashedTarock? stashedTarock,
    ClearHand? clearHand,
    ReplayLink? replayLink,
    ReplayMove? replayMove,
    ReplaySelectGame? replaySelectGame,
    GameInfo? gameInfo,
    StartEarly? startEarly,
  }) {
    final $result = create();
    if (username != null) {
      $result.username = username;
    }
    if (playerId != null) {
      $result.playerId = playerId;
    }
    if (silent != null) {
      $result.silent = silent;
    }
    if (connection != null) {
      $result.connection = connection;
    }
    if (licitiranje != null) {
      $result.licitiranje = licitiranje;
    }
    if (card != null) {
      $result.card = card;
    }
    if (licitiranjeStart != null) {
      $result.licitiranjeStart = licitiranjeStart;
    }
    if (gameStart != null) {
      $result.gameStart = gameStart;
    }
    if (loginRequest != null) {
      $result.loginRequest = loginRequest;
    }
    if (loginInfo != null) {
      $result.loginInfo = loginInfo;
    }
    if (loginResponse != null) {
      $result.loginResponse = loginResponse;
    }
    if (clearDesk != null) {
      $result.clearDesk = clearDesk;
    }
    if (results != null) {
      $result.results = results;
    }
    if (userList != null) {
      $result.userList = userList;
    }
    if (kingSelection != null) {
      $result.kingSelection = kingSelection;
    }
    if (startPredictions != null) {
      $result.startPredictions = startPredictions;
    }
    if (predictions != null) {
      $result.predictions = predictions;
    }
    if (talonReveal != null) {
      $result.talonReveal = talonReveal;
    }
    if (playingReveal != null) {
      $result.playingReveal = playingReveal;
    }
    if (talonSelection != null) {
      $result.talonSelection = talonSelection;
    }
    if (stash != null) {
      $result.stash = stash;
    }
    if (gameEnd != null) {
      $result.gameEnd = gameEnd;
    }
    if (gameStartCountdown != null) {
      $result.gameStartCountdown = gameStartCountdown;
    }
    if (predictionsResend != null) {
      $result.predictionsResend = predictionsResend;
    }
    if (radelci != null) {
      $result.radelci = radelci;
    }
    if (time != null) {
      $result.time = time;
    }
    if (chatMessage != null) {
      $result.chatMessage = chatMessage;
    }
    if (invitePlayer != null) {
      $result.invitePlayer = invitePlayer;
    }
    if (stashedTarock != null) {
      $result.stashedTarock = stashedTarock;
    }
    if (clearHand != null) {
      $result.clearHand = clearHand;
    }
    if (replayLink != null) {
      $result.replayLink = replayLink;
    }
    if (replayMove != null) {
      $result.replayMove = replayMove;
    }
    if (replaySelectGame != null) {
      $result.replaySelectGame = replaySelectGame;
    }
    if (gameInfo != null) {
      $result.gameInfo = gameInfo;
    }
    if (startEarly != null) {
      $result.startEarly = startEarly;
    }
    return $result;
  }
  Message._() : super();
  factory Message.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Message.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, Message_Data> _Message_DataByTag = {
    10 : Message_Data.connection,
    11 : Message_Data.licitiranje,
    12 : Message_Data.card,
    13 : Message_Data.licitiranjeStart,
    14 : Message_Data.gameStart,
    15 : Message_Data.loginRequest,
    16 : Message_Data.loginInfo,
    17 : Message_Data.loginResponse,
    18 : Message_Data.clearDesk,
    19 : Message_Data.results,
    20 : Message_Data.userList,
    21 : Message_Data.kingSelection,
    22 : Message_Data.startPredictions,
    23 : Message_Data.predictions,
    24 : Message_Data.talonReveal,
    25 : Message_Data.playingReveal,
    26 : Message_Data.talonSelection,
    27 : Message_Data.stash,
    28 : Message_Data.gameEnd,
    29 : Message_Data.gameStartCountdown,
    30 : Message_Data.predictionsResend,
    31 : Message_Data.radelci,
    32 : Message_Data.time,
    33 : Message_Data.chatMessage,
    34 : Message_Data.invitePlayer,
    35 : Message_Data.stashedTarock,
    36 : Message_Data.clearHand,
    37 : Message_Data.replayLink,
    38 : Message_Data.replayMove,
    39 : Message_Data.replaySelectGame,
    40 : Message_Data.gameInfo,
    41 : Message_Data.startEarly,
    0 : Message_Data.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Message', package: const $pb.PackageName(_omitMessageNames ? '' : 'game_messages'), createEmptyInstance: create)
    ..oo(0, [10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41])
    ..aOS(1, _omitFieldNames ? '' : 'username')
    ..aOS(2, _omitFieldNames ? '' : 'playerId')
    ..aOB(4, _omitFieldNames ? '' : 'silent')
    ..aOM<Connection>(10, _omitFieldNames ? '' : 'connection', subBuilder: Connection.create)
    ..aOM<Licitiranje>(11, _omitFieldNames ? '' : 'licitiranje', subBuilder: Licitiranje.create)
    ..aOM<Card>(12, _omitFieldNames ? '' : 'card', subBuilder: Card.create)
    ..aOM<LicitiranjeStart>(13, _omitFieldNames ? '' : 'licitiranjeStart', subBuilder: LicitiranjeStart.create)
    ..aOM<GameStart>(14, _omitFieldNames ? '' : 'gameStart', subBuilder: GameStart.create)
    ..aOM<LoginRequest>(15, _omitFieldNames ? '' : 'loginRequest', subBuilder: LoginRequest.create)
    ..aOM<LoginInfo>(16, _omitFieldNames ? '' : 'loginInfo', subBuilder: LoginInfo.create)
    ..aOM<LoginResponse>(17, _omitFieldNames ? '' : 'loginResponse', subBuilder: LoginResponse.create)
    ..aOM<ClearDesk>(18, _omitFieldNames ? '' : 'clearDesk', subBuilder: ClearDesk.create)
    ..aOM<Results>(19, _omitFieldNames ? '' : 'results', subBuilder: Results.create)
    ..aOM<UserList>(20, _omitFieldNames ? '' : 'userList', subBuilder: UserList.create)
    ..aOM<KingSelection>(21, _omitFieldNames ? '' : 'kingSelection', subBuilder: KingSelection.create)
    ..aOM<StartPredictions>(22, _omitFieldNames ? '' : 'startPredictions', subBuilder: StartPredictions.create)
    ..aOM<Predictions>(23, _omitFieldNames ? '' : 'predictions', subBuilder: Predictions.create)
    ..aOM<TalonReveal>(24, _omitFieldNames ? '' : 'talonReveal', subBuilder: TalonReveal.create)
    ..aOM<PlayingReveal>(25, _omitFieldNames ? '' : 'playingReveal', subBuilder: PlayingReveal.create)
    ..aOM<TalonSelection>(26, _omitFieldNames ? '' : 'talonSelection', subBuilder: TalonSelection.create)
    ..aOM<Stash>(27, _omitFieldNames ? '' : 'stash', subBuilder: Stash.create)
    ..aOM<GameEnd>(28, _omitFieldNames ? '' : 'gameEnd', subBuilder: GameEnd.create)
    ..aOM<GameStartCountdown>(29, _omitFieldNames ? '' : 'gameStartCountdown', subBuilder: GameStartCountdown.create)
    ..aOM<Predictions>(30, _omitFieldNames ? '' : 'predictionsResend', subBuilder: Predictions.create)
    ..aOM<Radelci>(31, _omitFieldNames ? '' : 'radelci', subBuilder: Radelci.create)
    ..aOM<Time>(32, _omitFieldNames ? '' : 'time', subBuilder: Time.create)
    ..aOM<ChatMessage>(33, _omitFieldNames ? '' : 'chatMessage', subBuilder: ChatMessage.create)
    ..aOM<InvitePlayer>(34, _omitFieldNames ? '' : 'invitePlayer', subBuilder: InvitePlayer.create)
    ..aOM<StashedTarock>(35, _omitFieldNames ? '' : 'stashedTarock', subBuilder: StashedTarock.create)
    ..aOM<ClearHand>(36, _omitFieldNames ? '' : 'clearHand', subBuilder: ClearHand.create)
    ..aOM<ReplayLink>(37, _omitFieldNames ? '' : 'replayLink', subBuilder: ReplayLink.create)
    ..aOM<ReplayMove>(38, _omitFieldNames ? '' : 'replayMove', subBuilder: ReplayMove.create)
    ..aOM<ReplaySelectGame>(39, _omitFieldNames ? '' : 'replaySelectGame', subBuilder: ReplaySelectGame.create)
    ..aOM<GameInfo>(40, _omitFieldNames ? '' : 'gameInfo', subBuilder: GameInfo.create)
    ..aOM<StartEarly>(41, _omitFieldNames ? '' : 'startEarly', subBuilder: StartEarly.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Message clone() => Message()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Message copyWith(void Function(Message) updates) => super.copyWith((message) => updates(message as Message)) as Message;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Message create() => Message._();
  Message createEmptyInstance() => create();
  static $pb.PbList<Message> createRepeated() => $pb.PbList<Message>();
  @$core.pragma('dart2js:noInline')
  static Message getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Message>(create);
  static Message? _defaultInstance;

  Message_Data whichData() => _Message_DataByTag[$_whichOneof(0)]!;
  void clearData() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get username => $_getSZ(0);
  @$pb.TagNumber(1)
  set username($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUsername() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsername() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get playerId => $_getSZ(1);
  @$pb.TagNumber(2)
  set playerId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPlayerId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayerId() => clearField(2);

  @$pb.TagNumber(4)
  $core.bool get silent => $_getBF(2);
  @$pb.TagNumber(4)
  set silent($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(4)
  $core.bool hasSilent() => $_has(2);
  @$pb.TagNumber(4)
  void clearSilent() => clearField(4);

  @$pb.TagNumber(10)
  Connection get connection => $_getN(3);
  @$pb.TagNumber(10)
  set connection(Connection v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasConnection() => $_has(3);
  @$pb.TagNumber(10)
  void clearConnection() => clearField(10);
  @$pb.TagNumber(10)
  Connection ensureConnection() => $_ensure(3);

  @$pb.TagNumber(11)
  Licitiranje get licitiranje => $_getN(4);
  @$pb.TagNumber(11)
  set licitiranje(Licitiranje v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasLicitiranje() => $_has(4);
  @$pb.TagNumber(11)
  void clearLicitiranje() => clearField(11);
  @$pb.TagNumber(11)
  Licitiranje ensureLicitiranje() => $_ensure(4);

  @$pb.TagNumber(12)
  Card get card => $_getN(5);
  @$pb.TagNumber(12)
  set card(Card v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasCard() => $_has(5);
  @$pb.TagNumber(12)
  void clearCard() => clearField(12);
  @$pb.TagNumber(12)
  Card ensureCard() => $_ensure(5);

  @$pb.TagNumber(13)
  LicitiranjeStart get licitiranjeStart => $_getN(6);
  @$pb.TagNumber(13)
  set licitiranjeStart(LicitiranjeStart v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasLicitiranjeStart() => $_has(6);
  @$pb.TagNumber(13)
  void clearLicitiranjeStart() => clearField(13);
  @$pb.TagNumber(13)
  LicitiranjeStart ensureLicitiranjeStart() => $_ensure(6);

  @$pb.TagNumber(14)
  GameStart get gameStart => $_getN(7);
  @$pb.TagNumber(14)
  set gameStart(GameStart v) { setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasGameStart() => $_has(7);
  @$pb.TagNumber(14)
  void clearGameStart() => clearField(14);
  @$pb.TagNumber(14)
  GameStart ensureGameStart() => $_ensure(7);

  @$pb.TagNumber(15)
  LoginRequest get loginRequest => $_getN(8);
  @$pb.TagNumber(15)
  set loginRequest(LoginRequest v) { setField(15, v); }
  @$pb.TagNumber(15)
  $core.bool hasLoginRequest() => $_has(8);
  @$pb.TagNumber(15)
  void clearLoginRequest() => clearField(15);
  @$pb.TagNumber(15)
  LoginRequest ensureLoginRequest() => $_ensure(8);

  @$pb.TagNumber(16)
  LoginInfo get loginInfo => $_getN(9);
  @$pb.TagNumber(16)
  set loginInfo(LoginInfo v) { setField(16, v); }
  @$pb.TagNumber(16)
  $core.bool hasLoginInfo() => $_has(9);
  @$pb.TagNumber(16)
  void clearLoginInfo() => clearField(16);
  @$pb.TagNumber(16)
  LoginInfo ensureLoginInfo() => $_ensure(9);

  @$pb.TagNumber(17)
  LoginResponse get loginResponse => $_getN(10);
  @$pb.TagNumber(17)
  set loginResponse(LoginResponse v) { setField(17, v); }
  @$pb.TagNumber(17)
  $core.bool hasLoginResponse() => $_has(10);
  @$pb.TagNumber(17)
  void clearLoginResponse() => clearField(17);
  @$pb.TagNumber(17)
  LoginResponse ensureLoginResponse() => $_ensure(10);

  @$pb.TagNumber(18)
  ClearDesk get clearDesk => $_getN(11);
  @$pb.TagNumber(18)
  set clearDesk(ClearDesk v) { setField(18, v); }
  @$pb.TagNumber(18)
  $core.bool hasClearDesk() => $_has(11);
  @$pb.TagNumber(18)
  void clearClearDesk() => clearField(18);
  @$pb.TagNumber(18)
  ClearDesk ensureClearDesk() => $_ensure(11);

  @$pb.TagNumber(19)
  Results get results => $_getN(12);
  @$pb.TagNumber(19)
  set results(Results v) { setField(19, v); }
  @$pb.TagNumber(19)
  $core.bool hasResults() => $_has(12);
  @$pb.TagNumber(19)
  void clearResults() => clearField(19);
  @$pb.TagNumber(19)
  Results ensureResults() => $_ensure(12);

  @$pb.TagNumber(20)
  UserList get userList => $_getN(13);
  @$pb.TagNumber(20)
  set userList(UserList v) { setField(20, v); }
  @$pb.TagNumber(20)
  $core.bool hasUserList() => $_has(13);
  @$pb.TagNumber(20)
  void clearUserList() => clearField(20);
  @$pb.TagNumber(20)
  UserList ensureUserList() => $_ensure(13);

  @$pb.TagNumber(21)
  KingSelection get kingSelection => $_getN(14);
  @$pb.TagNumber(21)
  set kingSelection(KingSelection v) { setField(21, v); }
  @$pb.TagNumber(21)
  $core.bool hasKingSelection() => $_has(14);
  @$pb.TagNumber(21)
  void clearKingSelection() => clearField(21);
  @$pb.TagNumber(21)
  KingSelection ensureKingSelection() => $_ensure(14);

  @$pb.TagNumber(22)
  StartPredictions get startPredictions => $_getN(15);
  @$pb.TagNumber(22)
  set startPredictions(StartPredictions v) { setField(22, v); }
  @$pb.TagNumber(22)
  $core.bool hasStartPredictions() => $_has(15);
  @$pb.TagNumber(22)
  void clearStartPredictions() => clearField(22);
  @$pb.TagNumber(22)
  StartPredictions ensureStartPredictions() => $_ensure(15);

  @$pb.TagNumber(23)
  Predictions get predictions => $_getN(16);
  @$pb.TagNumber(23)
  set predictions(Predictions v) { setField(23, v); }
  @$pb.TagNumber(23)
  $core.bool hasPredictions() => $_has(16);
  @$pb.TagNumber(23)
  void clearPredictions() => clearField(23);
  @$pb.TagNumber(23)
  Predictions ensurePredictions() => $_ensure(16);

  @$pb.TagNumber(24)
  TalonReveal get talonReveal => $_getN(17);
  @$pb.TagNumber(24)
  set talonReveal(TalonReveal v) { setField(24, v); }
  @$pb.TagNumber(24)
  $core.bool hasTalonReveal() => $_has(17);
  @$pb.TagNumber(24)
  void clearTalonReveal() => clearField(24);
  @$pb.TagNumber(24)
  TalonReveal ensureTalonReveal() => $_ensure(17);

  @$pb.TagNumber(25)
  PlayingReveal get playingReveal => $_getN(18);
  @$pb.TagNumber(25)
  set playingReveal(PlayingReveal v) { setField(25, v); }
  @$pb.TagNumber(25)
  $core.bool hasPlayingReveal() => $_has(18);
  @$pb.TagNumber(25)
  void clearPlayingReveal() => clearField(25);
  @$pb.TagNumber(25)
  PlayingReveal ensurePlayingReveal() => $_ensure(18);

  @$pb.TagNumber(26)
  TalonSelection get talonSelection => $_getN(19);
  @$pb.TagNumber(26)
  set talonSelection(TalonSelection v) { setField(26, v); }
  @$pb.TagNumber(26)
  $core.bool hasTalonSelection() => $_has(19);
  @$pb.TagNumber(26)
  void clearTalonSelection() => clearField(26);
  @$pb.TagNumber(26)
  TalonSelection ensureTalonSelection() => $_ensure(19);

  @$pb.TagNumber(27)
  Stash get stash => $_getN(20);
  @$pb.TagNumber(27)
  set stash(Stash v) { setField(27, v); }
  @$pb.TagNumber(27)
  $core.bool hasStash() => $_has(20);
  @$pb.TagNumber(27)
  void clearStash() => clearField(27);
  @$pb.TagNumber(27)
  Stash ensureStash() => $_ensure(20);

  @$pb.TagNumber(28)
  GameEnd get gameEnd => $_getN(21);
  @$pb.TagNumber(28)
  set gameEnd(GameEnd v) { setField(28, v); }
  @$pb.TagNumber(28)
  $core.bool hasGameEnd() => $_has(21);
  @$pb.TagNumber(28)
  void clearGameEnd() => clearField(28);
  @$pb.TagNumber(28)
  GameEnd ensureGameEnd() => $_ensure(21);

  @$pb.TagNumber(29)
  GameStartCountdown get gameStartCountdown => $_getN(22);
  @$pb.TagNumber(29)
  set gameStartCountdown(GameStartCountdown v) { setField(29, v); }
  @$pb.TagNumber(29)
  $core.bool hasGameStartCountdown() => $_has(22);
  @$pb.TagNumber(29)
  void clearGameStartCountdown() => clearField(29);
  @$pb.TagNumber(29)
  GameStartCountdown ensureGameStartCountdown() => $_ensure(22);

  @$pb.TagNumber(30)
  Predictions get predictionsResend => $_getN(23);
  @$pb.TagNumber(30)
  set predictionsResend(Predictions v) { setField(30, v); }
  @$pb.TagNumber(30)
  $core.bool hasPredictionsResend() => $_has(23);
  @$pb.TagNumber(30)
  void clearPredictionsResend() => clearField(30);
  @$pb.TagNumber(30)
  Predictions ensurePredictionsResend() => $_ensure(23);

  @$pb.TagNumber(31)
  Radelci get radelci => $_getN(24);
  @$pb.TagNumber(31)
  set radelci(Radelci v) { setField(31, v); }
  @$pb.TagNumber(31)
  $core.bool hasRadelci() => $_has(24);
  @$pb.TagNumber(31)
  void clearRadelci() => clearField(31);
  @$pb.TagNumber(31)
  Radelci ensureRadelci() => $_ensure(24);

  @$pb.TagNumber(32)
  Time get time => $_getN(25);
  @$pb.TagNumber(32)
  set time(Time v) { setField(32, v); }
  @$pb.TagNumber(32)
  $core.bool hasTime() => $_has(25);
  @$pb.TagNumber(32)
  void clearTime() => clearField(32);
  @$pb.TagNumber(32)
  Time ensureTime() => $_ensure(25);

  @$pb.TagNumber(33)
  ChatMessage get chatMessage => $_getN(26);
  @$pb.TagNumber(33)
  set chatMessage(ChatMessage v) { setField(33, v); }
  @$pb.TagNumber(33)
  $core.bool hasChatMessage() => $_has(26);
  @$pb.TagNumber(33)
  void clearChatMessage() => clearField(33);
  @$pb.TagNumber(33)
  ChatMessage ensureChatMessage() => $_ensure(26);

  @$pb.TagNumber(34)
  InvitePlayer get invitePlayer => $_getN(27);
  @$pb.TagNumber(34)
  set invitePlayer(InvitePlayer v) { setField(34, v); }
  @$pb.TagNumber(34)
  $core.bool hasInvitePlayer() => $_has(27);
  @$pb.TagNumber(34)
  void clearInvitePlayer() => clearField(34);
  @$pb.TagNumber(34)
  InvitePlayer ensureInvitePlayer() => $_ensure(27);

  @$pb.TagNumber(35)
  StashedTarock get stashedTarock => $_getN(28);
  @$pb.TagNumber(35)
  set stashedTarock(StashedTarock v) { setField(35, v); }
  @$pb.TagNumber(35)
  $core.bool hasStashedTarock() => $_has(28);
  @$pb.TagNumber(35)
  void clearStashedTarock() => clearField(35);
  @$pb.TagNumber(35)
  StashedTarock ensureStashedTarock() => $_ensure(28);

  @$pb.TagNumber(36)
  ClearHand get clearHand => $_getN(29);
  @$pb.TagNumber(36)
  set clearHand(ClearHand v) { setField(36, v); }
  @$pb.TagNumber(36)
  $core.bool hasClearHand() => $_has(29);
  @$pb.TagNumber(36)
  void clearClearHand() => clearField(36);
  @$pb.TagNumber(36)
  ClearHand ensureClearHand() => $_ensure(29);

  @$pb.TagNumber(37)
  ReplayLink get replayLink => $_getN(30);
  @$pb.TagNumber(37)
  set replayLink(ReplayLink v) { setField(37, v); }
  @$pb.TagNumber(37)
  $core.bool hasReplayLink() => $_has(30);
  @$pb.TagNumber(37)
  void clearReplayLink() => clearField(37);
  @$pb.TagNumber(37)
  ReplayLink ensureReplayLink() => $_ensure(30);

  @$pb.TagNumber(38)
  ReplayMove get replayMove => $_getN(31);
  @$pb.TagNumber(38)
  set replayMove(ReplayMove v) { setField(38, v); }
  @$pb.TagNumber(38)
  $core.bool hasReplayMove() => $_has(31);
  @$pb.TagNumber(38)
  void clearReplayMove() => clearField(38);
  @$pb.TagNumber(38)
  ReplayMove ensureReplayMove() => $_ensure(31);

  @$pb.TagNumber(39)
  ReplaySelectGame get replaySelectGame => $_getN(32);
  @$pb.TagNumber(39)
  set replaySelectGame(ReplaySelectGame v) { setField(39, v); }
  @$pb.TagNumber(39)
  $core.bool hasReplaySelectGame() => $_has(32);
  @$pb.TagNumber(39)
  void clearReplaySelectGame() => clearField(39);
  @$pb.TagNumber(39)
  ReplaySelectGame ensureReplaySelectGame() => $_ensure(32);

  @$pb.TagNumber(40)
  GameInfo get gameInfo => $_getN(33);
  @$pb.TagNumber(40)
  set gameInfo(GameInfo v) { setField(40, v); }
  @$pb.TagNumber(40)
  $core.bool hasGameInfo() => $_has(33);
  @$pb.TagNumber(40)
  void clearGameInfo() => clearField(40);
  @$pb.TagNumber(40)
  GameInfo ensureGameInfo() => $_ensure(33);

  @$pb.TagNumber(41)
  StartEarly get startEarly => $_getN(34);
  @$pb.TagNumber(41)
  set startEarly(StartEarly v) { setField(41, v); }
  @$pb.TagNumber(41)
  $core.bool hasStartEarly() => $_has(34);
  @$pb.TagNumber(41)
  void clearStartEarly() => clearField(41);
  @$pb.TagNumber(41)
  StartEarly ensureStartEarly() => $_ensure(34);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
