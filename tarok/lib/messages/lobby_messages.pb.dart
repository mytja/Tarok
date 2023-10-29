///
//  Generated code. Do not modify.
//  source: lobby_messages.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class LoginRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LoginRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'lobby_messages'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  LoginRequest._() : super();
  factory LoginRequest() => create();
  factory LoginRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoginRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoginRequest clone() => LoginRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoginRequest copyWith(void Function(LoginRequest) updates) => super.copyWith((message) => updates(message as LoginRequest)) as LoginRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LoginInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'lobby_messages'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'token')
    ..hasRequiredFields = false
  ;

  LoginInfo._() : super();
  factory LoginInfo({
    $core.String? token,
  }) {
    final _result = create();
    if (token != null) {
      _result.token = token;
    }
    return _result;
  }
  factory LoginInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoginInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoginInfo clone() => LoginInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoginInfo copyWith(void Function(LoginInfo) updates) => super.copyWith((message) => updates(message as LoginInfo)) as LoginInfo; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LoginResponse.OK', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'lobby_messages'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  LoginResponse_OK._() : super();
  factory LoginResponse_OK() => create();
  factory LoginResponse_OK.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoginResponse_OK.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoginResponse_OK clone() => LoginResponse_OK()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoginResponse_OK copyWith(void Function(LoginResponse_OK) updates) => super.copyWith((message) => updates(message as LoginResponse_OK)) as LoginResponse_OK; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LoginResponse.Fail', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'lobby_messages'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  LoginResponse_Fail._() : super();
  factory LoginResponse_Fail() => create();
  factory LoginResponse_Fail.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoginResponse_Fail.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoginResponse_Fail clone() => LoginResponse_Fail()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoginResponse_Fail copyWith(void Function(LoginResponse_Fail) updates) => super.copyWith((message) => updates(message as LoginResponse_Fail)) as LoginResponse_Fail; // ignore: deprecated_member_use
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
  static const $core.Map<$core.int, LoginResponse_Type> _LoginResponse_TypeByTag = {
    1 : LoginResponse_Type.ok,
    2 : LoginResponse_Type.fail,
    0 : LoginResponse_Type.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LoginResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'lobby_messages'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<LoginResponse_OK>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ok', subBuilder: LoginResponse_OK.create)
    ..aOM<LoginResponse_Fail>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fail', subBuilder: LoginResponse_Fail.create)
    ..hasRequiredFields = false
  ;

  LoginResponse._() : super();
  factory LoginResponse({
    LoginResponse_OK? ok,
    LoginResponse_Fail? fail,
  }) {
    final _result = create();
    if (ok != null) {
      _result.ok = ok;
    }
    if (fail != null) {
      _result.fail = fail;
    }
    return _result;
  }
  factory LoginResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoginResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoginResponse clone() => LoginResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoginResponse copyWith(void Function(LoginResponse) updates) => super.copyWith((message) => updates(message as LoginResponse)) as LoginResponse; // ignore: deprecated_member_use
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

class Player extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Player', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'lobby_messages'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rating', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  Player._() : super();
  factory Player({
    $core.String? id,
    $core.String? name,
    $core.int? rating,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (name != null) {
      _result.name = name;
    }
    if (rating != null) {
      _result.rating = rating;
    }
    return _result;
  }
  factory Player.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Player.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Player clone() => Player()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Player copyWith(void Function(Player) updates) => super.copyWith((message) => updates(message as Player)) as Player; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Player create() => Player._();
  Player createEmptyInstance() => create();
  static $pb.PbList<Player> createRepeated() => $pb.PbList<Player>();
  @$core.pragma('dart2js:noInline')
  static Player getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Player>(create);
  static Player? _defaultInstance;

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
  $core.int get rating => $_getIZ(2);
  @$pb.TagNumber(3)
  set rating($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRating() => $_has(2);
  @$pb.TagNumber(3)
  void clearRating() => clearField(3);
}

class GameCreated extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GameCreated', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'lobby_messages'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gameId', protoName: 'gameId')
    ..pc<Player>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'players', $pb.PbFieldType.PM, subBuilder: Player.create)
    ..aOB(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mondfangRadelci')
    ..aOB(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'skisfang')
    ..aOB(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'napovedanMondfang')
    ..aOB(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'kontraKazen')
    ..a<$core.int>(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'totalTime', $pb.PbFieldType.O3)
    ..a<$core.double>(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'additionalTime', $pb.PbFieldType.OF)
    ..aOS(17, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type')
    ..a<$core.int>(18, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'requiredPlayers', $pb.PbFieldType.O3, protoName: 'requiredPlayers')
    ..aOB(19, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'started')
    ..aOB(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'private')
    ..aOB(21, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'priority')
    ..hasRequiredFields = false
  ;

  GameCreated._() : super();
  factory GameCreated({
    $core.String? gameId,
    $core.Iterable<Player>? players,
    $core.bool? mondfangRadelci,
    $core.bool? skisfang,
    $core.bool? napovedanMondfang,
    $core.bool? kontraKazen,
    $core.int? totalTime,
    $core.double? additionalTime,
    $core.String? type,
    $core.int? requiredPlayers,
    $core.bool? started,
    $core.bool? private,
    $core.bool? priority,
  }) {
    final _result = create();
    if (gameId != null) {
      _result.gameId = gameId;
    }
    if (players != null) {
      _result.players.addAll(players);
    }
    if (mondfangRadelci != null) {
      _result.mondfangRadelci = mondfangRadelci;
    }
    if (skisfang != null) {
      _result.skisfang = skisfang;
    }
    if (napovedanMondfang != null) {
      _result.napovedanMondfang = napovedanMondfang;
    }
    if (kontraKazen != null) {
      _result.kontraKazen = kontraKazen;
    }
    if (totalTime != null) {
      _result.totalTime = totalTime;
    }
    if (additionalTime != null) {
      _result.additionalTime = additionalTime;
    }
    if (type != null) {
      _result.type = type;
    }
    if (requiredPlayers != null) {
      _result.requiredPlayers = requiredPlayers;
    }
    if (started != null) {
      _result.started = started;
    }
    if (private != null) {
      _result.private = private;
    }
    if (priority != null) {
      _result.priority = priority;
    }
    return _result;
  }
  factory GameCreated.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GameCreated.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GameCreated clone() => GameCreated()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GameCreated copyWith(void Function(GameCreated) updates) => super.copyWith((message) => updates(message as GameCreated)) as GameCreated; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GameCreated create() => GameCreated._();
  GameCreated createEmptyInstance() => create();
  static $pb.PbList<GameCreated> createRepeated() => $pb.PbList<GameCreated>();
  @$core.pragma('dart2js:noInline')
  static GameCreated getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GameCreated>(create);
  static GameCreated? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gameId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gameId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGameId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGameId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<Player> get players => $_getList(1);

  @$pb.TagNumber(5)
  $core.bool get mondfangRadelci => $_getBF(2);
  @$pb.TagNumber(5)
  set mondfangRadelci($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(5)
  $core.bool hasMondfangRadelci() => $_has(2);
  @$pb.TagNumber(5)
  void clearMondfangRadelci() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get skisfang => $_getBF(3);
  @$pb.TagNumber(6)
  set skisfang($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(6)
  $core.bool hasSkisfang() => $_has(3);
  @$pb.TagNumber(6)
  void clearSkisfang() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get napovedanMondfang => $_getBF(4);
  @$pb.TagNumber(7)
  set napovedanMondfang($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(7)
  $core.bool hasNapovedanMondfang() => $_has(4);
  @$pb.TagNumber(7)
  void clearNapovedanMondfang() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get kontraKazen => $_getBF(5);
  @$pb.TagNumber(8)
  set kontraKazen($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(8)
  $core.bool hasKontraKazen() => $_has(5);
  @$pb.TagNumber(8)
  void clearKontraKazen() => clearField(8);

  @$pb.TagNumber(15)
  $core.int get totalTime => $_getIZ(6);
  @$pb.TagNumber(15)
  set totalTime($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(15)
  $core.bool hasTotalTime() => $_has(6);
  @$pb.TagNumber(15)
  void clearTotalTime() => clearField(15);

  @$pb.TagNumber(16)
  $core.double get additionalTime => $_getN(7);
  @$pb.TagNumber(16)
  set additionalTime($core.double v) { $_setFloat(7, v); }
  @$pb.TagNumber(16)
  $core.bool hasAdditionalTime() => $_has(7);
  @$pb.TagNumber(16)
  void clearAdditionalTime() => clearField(16);

  @$pb.TagNumber(17)
  $core.String get type => $_getSZ(8);
  @$pb.TagNumber(17)
  set type($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(17)
  $core.bool hasType() => $_has(8);
  @$pb.TagNumber(17)
  void clearType() => clearField(17);

  @$pb.TagNumber(18)
  $core.int get requiredPlayers => $_getIZ(9);
  @$pb.TagNumber(18)
  set requiredPlayers($core.int v) { $_setSignedInt32(9, v); }
  @$pb.TagNumber(18)
  $core.bool hasRequiredPlayers() => $_has(9);
  @$pb.TagNumber(18)
  void clearRequiredPlayers() => clearField(18);

  @$pb.TagNumber(19)
  $core.bool get started => $_getBF(10);
  @$pb.TagNumber(19)
  set started($core.bool v) { $_setBool(10, v); }
  @$pb.TagNumber(19)
  $core.bool hasStarted() => $_has(10);
  @$pb.TagNumber(19)
  void clearStarted() => clearField(19);

  @$pb.TagNumber(20)
  $core.bool get private => $_getBF(11);
  @$pb.TagNumber(20)
  set private($core.bool v) { $_setBool(11, v); }
  @$pb.TagNumber(20)
  $core.bool hasPrivate() => $_has(11);
  @$pb.TagNumber(20)
  void clearPrivate() => clearField(20);

  @$pb.TagNumber(21)
  $core.bool get priority => $_getBF(12);
  @$pb.TagNumber(21)
  set priority($core.bool v) { $_setBool(12, v); }
  @$pb.TagNumber(21)
  $core.bool hasPriority() => $_has(12);
  @$pb.TagNumber(21)
  void clearPriority() => clearField(21);
}

class GameDisbanded extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GameDisbanded', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'lobby_messages'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gameId', protoName: 'gameId')
    ..hasRequiredFields = false
  ;

  GameDisbanded._() : super();
  factory GameDisbanded({
    $core.String? gameId,
  }) {
    final _result = create();
    if (gameId != null) {
      _result.gameId = gameId;
    }
    return _result;
  }
  factory GameDisbanded.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GameDisbanded.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GameDisbanded clone() => GameDisbanded()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GameDisbanded copyWith(void Function(GameDisbanded) updates) => super.copyWith((message) => updates(message as GameDisbanded)) as GameDisbanded; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GameDisbanded create() => GameDisbanded._();
  GameDisbanded createEmptyInstance() => create();
  static $pb.PbList<GameDisbanded> createRepeated() => $pb.PbList<GameDisbanded>();
  @$core.pragma('dart2js:noInline')
  static GameDisbanded getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GameDisbanded>(create);
  static GameDisbanded? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gameId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gameId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGameId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGameId() => clearField(1);
}

class GameJoin extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GameJoin', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'lobby_messages'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gameId', protoName: 'gameId')
    ..aOM<Player>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'player', subBuilder: Player.create)
    ..hasRequiredFields = false
  ;

  GameJoin._() : super();
  factory GameJoin({
    $core.String? gameId,
    Player? player,
  }) {
    final _result = create();
    if (gameId != null) {
      _result.gameId = gameId;
    }
    if (player != null) {
      _result.player = player;
    }
    return _result;
  }
  factory GameJoin.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GameJoin.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GameJoin clone() => GameJoin()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GameJoin copyWith(void Function(GameJoin) updates) => super.copyWith((message) => updates(message as GameJoin)) as GameJoin; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GameJoin create() => GameJoin._();
  GameJoin createEmptyInstance() => create();
  static $pb.PbList<GameJoin> createRepeated() => $pb.PbList<GameJoin>();
  @$core.pragma('dart2js:noInline')
  static GameJoin getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GameJoin>(create);
  static GameJoin? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gameId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gameId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGameId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGameId() => clearField(1);

  @$pb.TagNumber(2)
  Player get player => $_getN(1);
  @$pb.TagNumber(2)
  set player(Player v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPlayer() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayer() => clearField(2);
  @$pb.TagNumber(2)
  Player ensurePlayer() => $_ensure(1);
}

class GameLeave extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GameLeave', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'lobby_messages'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gameId', protoName: 'gameId')
    ..aOM<Player>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'player', subBuilder: Player.create)
    ..hasRequiredFields = false
  ;

  GameLeave._() : super();
  factory GameLeave({
    $core.String? gameId,
    Player? player,
  }) {
    final _result = create();
    if (gameId != null) {
      _result.gameId = gameId;
    }
    if (player != null) {
      _result.player = player;
    }
    return _result;
  }
  factory GameLeave.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GameLeave.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GameLeave clone() => GameLeave()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GameLeave copyWith(void Function(GameLeave) updates) => super.copyWith((message) => updates(message as GameLeave)) as GameLeave; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GameLeave create() => GameLeave._();
  GameLeave createEmptyInstance() => create();
  static $pb.PbList<GameLeave> createRepeated() => $pb.PbList<GameLeave>();
  @$core.pragma('dart2js:noInline')
  static GameLeave getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GameLeave>(create);
  static GameLeave? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gameId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gameId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGameId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGameId() => clearField(1);

  @$pb.TagNumber(2)
  Player get player => $_getN(1);
  @$pb.TagNumber(2)
  set player(Player v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPlayer() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayer() => clearField(2);
  @$pb.TagNumber(2)
  Player ensurePlayer() => $_ensure(1);
}

class GameInvite extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GameInvite', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'lobby_messages'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gameId', protoName: 'gameId')
    ..hasRequiredFields = false
  ;

  GameInvite._() : super();
  factory GameInvite({
    $core.String? gameId,
  }) {
    final _result = create();
    if (gameId != null) {
      _result.gameId = gameId;
    }
    return _result;
  }
  factory GameInvite.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GameInvite.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GameInvite clone() => GameInvite()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GameInvite copyWith(void Function(GameInvite) updates) => super.copyWith((message) => updates(message as GameInvite)) as GameInvite; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GameInvite create() => GameInvite._();
  GameInvite createEmptyInstance() => create();
  static $pb.PbList<GameInvite> createRepeated() => $pb.PbList<GameInvite>();
  @$core.pragma('dart2js:noInline')
  static GameInvite getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GameInvite>(create);
  static GameInvite? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gameId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gameId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGameId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGameId() => clearField(1);
}

class GameMove extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GameMove', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'lobby_messages'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gameId', protoName: 'gameId')
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'priority')
    ..hasRequiredFields = false
  ;

  GameMove._() : super();
  factory GameMove({
    $core.String? gameId,
    $core.bool? priority,
  }) {
    final _result = create();
    if (gameId != null) {
      _result.gameId = gameId;
    }
    if (priority != null) {
      _result.priority = priority;
    }
    return _result;
  }
  factory GameMove.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GameMove.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GameMove clone() => GameMove()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GameMove copyWith(void Function(GameMove) updates) => super.copyWith((message) => updates(message as GameMove)) as GameMove; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GameMove create() => GameMove._();
  GameMove createEmptyInstance() => create();
  static $pb.PbList<GameMove> createRepeated() => $pb.PbList<GameMove>();
  @$core.pragma('dart2js:noInline')
  static GameMove getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GameMove>(create);
  static GameMove? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gameId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gameId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGameId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGameId() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get priority => $_getBF(1);
  @$pb.TagNumber(2)
  set priority($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPriority() => $_has(1);
  @$pb.TagNumber(2)
  void clearPriority() => clearField(2);
}

enum LobbyMessage_Data {
  loginRequest, 
  loginInfo, 
  loginResponse, 
  gameCreated, 
  gameDisbanded, 
  gameJoin, 
  gameLeave, 
  gameMove, 
  gameInvite, 
  notSet
}

class LobbyMessage extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, LobbyMessage_Data> _LobbyMessage_DataByTag = {
    10 : LobbyMessage_Data.loginRequest,
    11 : LobbyMessage_Data.loginInfo,
    12 : LobbyMessage_Data.loginResponse,
    13 : LobbyMessage_Data.gameCreated,
    14 : LobbyMessage_Data.gameDisbanded,
    15 : LobbyMessage_Data.gameJoin,
    16 : LobbyMessage_Data.gameLeave,
    17 : LobbyMessage_Data.gameMove,
    18 : LobbyMessage_Data.gameInvite,
    0 : LobbyMessage_Data.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LobbyMessage', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'lobby_messages'), createEmptyInstance: create)
    ..oo(0, [10, 11, 12, 13, 14, 15, 16, 17, 18])
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playerId')
    ..aOM<LoginRequest>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'loginRequest', subBuilder: LoginRequest.create)
    ..aOM<LoginInfo>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'loginInfo', subBuilder: LoginInfo.create)
    ..aOM<LoginResponse>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'loginResponse', subBuilder: LoginResponse.create)
    ..aOM<GameCreated>(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gameCreated', subBuilder: GameCreated.create)
    ..aOM<GameDisbanded>(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gameDisbanded', subBuilder: GameDisbanded.create)
    ..aOM<GameJoin>(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gameJoin', subBuilder: GameJoin.create)
    ..aOM<GameLeave>(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gameLeave', subBuilder: GameLeave.create)
    ..aOM<GameMove>(17, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gameMove', subBuilder: GameMove.create)
    ..aOM<GameInvite>(18, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gameInvite', subBuilder: GameInvite.create)
    ..hasRequiredFields = false
  ;

  LobbyMessage._() : super();
  factory LobbyMessage({
    $core.String? playerId,
    LoginRequest? loginRequest,
    LoginInfo? loginInfo,
    LoginResponse? loginResponse,
    GameCreated? gameCreated,
    GameDisbanded? gameDisbanded,
    GameJoin? gameJoin,
    GameLeave? gameLeave,
    GameMove? gameMove,
    GameInvite? gameInvite,
  }) {
    final _result = create();
    if (playerId != null) {
      _result.playerId = playerId;
    }
    if (loginRequest != null) {
      _result.loginRequest = loginRequest;
    }
    if (loginInfo != null) {
      _result.loginInfo = loginInfo;
    }
    if (loginResponse != null) {
      _result.loginResponse = loginResponse;
    }
    if (gameCreated != null) {
      _result.gameCreated = gameCreated;
    }
    if (gameDisbanded != null) {
      _result.gameDisbanded = gameDisbanded;
    }
    if (gameJoin != null) {
      _result.gameJoin = gameJoin;
    }
    if (gameLeave != null) {
      _result.gameLeave = gameLeave;
    }
    if (gameMove != null) {
      _result.gameMove = gameMove;
    }
    if (gameInvite != null) {
      _result.gameInvite = gameInvite;
    }
    return _result;
  }
  factory LobbyMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LobbyMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LobbyMessage clone() => LobbyMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LobbyMessage copyWith(void Function(LobbyMessage) updates) => super.copyWith((message) => updates(message as LobbyMessage)) as LobbyMessage; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LobbyMessage create() => LobbyMessage._();
  LobbyMessage createEmptyInstance() => create();
  static $pb.PbList<LobbyMessage> createRepeated() => $pb.PbList<LobbyMessage>();
  @$core.pragma('dart2js:noInline')
  static LobbyMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LobbyMessage>(create);
  static LobbyMessage? _defaultInstance;

  LobbyMessage_Data whichData() => _LobbyMessage_DataByTag[$_whichOneof(0)]!;
  void clearData() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get playerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set playerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPlayerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlayerId() => clearField(1);

  @$pb.TagNumber(10)
  LoginRequest get loginRequest => $_getN(1);
  @$pb.TagNumber(10)
  set loginRequest(LoginRequest v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasLoginRequest() => $_has(1);
  @$pb.TagNumber(10)
  void clearLoginRequest() => clearField(10);
  @$pb.TagNumber(10)
  LoginRequest ensureLoginRequest() => $_ensure(1);

  @$pb.TagNumber(11)
  LoginInfo get loginInfo => $_getN(2);
  @$pb.TagNumber(11)
  set loginInfo(LoginInfo v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasLoginInfo() => $_has(2);
  @$pb.TagNumber(11)
  void clearLoginInfo() => clearField(11);
  @$pb.TagNumber(11)
  LoginInfo ensureLoginInfo() => $_ensure(2);

  @$pb.TagNumber(12)
  LoginResponse get loginResponse => $_getN(3);
  @$pb.TagNumber(12)
  set loginResponse(LoginResponse v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasLoginResponse() => $_has(3);
  @$pb.TagNumber(12)
  void clearLoginResponse() => clearField(12);
  @$pb.TagNumber(12)
  LoginResponse ensureLoginResponse() => $_ensure(3);

  @$pb.TagNumber(13)
  GameCreated get gameCreated => $_getN(4);
  @$pb.TagNumber(13)
  set gameCreated(GameCreated v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasGameCreated() => $_has(4);
  @$pb.TagNumber(13)
  void clearGameCreated() => clearField(13);
  @$pb.TagNumber(13)
  GameCreated ensureGameCreated() => $_ensure(4);

  @$pb.TagNumber(14)
  GameDisbanded get gameDisbanded => $_getN(5);
  @$pb.TagNumber(14)
  set gameDisbanded(GameDisbanded v) { setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasGameDisbanded() => $_has(5);
  @$pb.TagNumber(14)
  void clearGameDisbanded() => clearField(14);
  @$pb.TagNumber(14)
  GameDisbanded ensureGameDisbanded() => $_ensure(5);

  @$pb.TagNumber(15)
  GameJoin get gameJoin => $_getN(6);
  @$pb.TagNumber(15)
  set gameJoin(GameJoin v) { setField(15, v); }
  @$pb.TagNumber(15)
  $core.bool hasGameJoin() => $_has(6);
  @$pb.TagNumber(15)
  void clearGameJoin() => clearField(15);
  @$pb.TagNumber(15)
  GameJoin ensureGameJoin() => $_ensure(6);

  @$pb.TagNumber(16)
  GameLeave get gameLeave => $_getN(7);
  @$pb.TagNumber(16)
  set gameLeave(GameLeave v) { setField(16, v); }
  @$pb.TagNumber(16)
  $core.bool hasGameLeave() => $_has(7);
  @$pb.TagNumber(16)
  void clearGameLeave() => clearField(16);
  @$pb.TagNumber(16)
  GameLeave ensureGameLeave() => $_ensure(7);

  @$pb.TagNumber(17)
  GameMove get gameMove => $_getN(8);
  @$pb.TagNumber(17)
  set gameMove(GameMove v) { setField(17, v); }
  @$pb.TagNumber(17)
  $core.bool hasGameMove() => $_has(8);
  @$pb.TagNumber(17)
  void clearGameMove() => clearField(17);
  @$pb.TagNumber(17)
  GameMove ensureGameMove() => $_ensure(8);

  @$pb.TagNumber(18)
  GameInvite get gameInvite => $_getN(9);
  @$pb.TagNumber(18)
  set gameInvite(GameInvite v) { setField(18, v); }
  @$pb.TagNumber(18)
  $core.bool hasGameInvite() => $_has(9);
  @$pb.TagNumber(18)
  void clearGameInvite() => clearField(18);
  @$pb.TagNumber(18)
  GameInvite ensureGameInvite() => $_ensure(9);
}

