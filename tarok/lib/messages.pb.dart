///
//  Generated code. Do not modify.
//  source: messages.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Connect extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Connect', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  Connect._() : super();
  factory Connect() => create();
  factory Connect.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Connect.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Connect clone() => Connect()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Connect copyWith(void Function(Connect) updates) => super.copyWith((message) => updates(message as Connect)) as Connect; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Disconnect', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  Disconnect._() : super();
  factory Disconnect() => create();
  factory Disconnect.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Disconnect.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Disconnect clone() => Disconnect()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Disconnect copyWith(void Function(Disconnect) updates) => super.copyWith((message) => updates(message as Disconnect)) as Disconnect; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Receive', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  Receive._() : super();
  factory Receive() => create();
  factory Receive.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Receive.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Receive clone() => Receive()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Receive copyWith(void Function(Receive) updates) => super.copyWith((message) => updates(message as Receive)) as Receive; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Send', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  Send._() : super();
  factory Send() => create();
  factory Send.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Send.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Send clone() => Send()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Send copyWith(void Function(Send) updates) => super.copyWith((message) => updates(message as Send)) as Send; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Request', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  Request._() : super();
  factory Request() => create();
  factory Request.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Request.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Request clone() => Request()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Request copyWith(void Function(Request) updates) => super.copyWith((message) => updates(message as Request)) as Request; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Request create() => Request._();
  Request createEmptyInstance() => create();
  static $pb.PbList<Request> createRepeated() => $pb.PbList<Request>();
  @$core.pragma('dart2js:noInline')
  static Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Request>(create);
  static Request? _defaultInstance;
}

class Remove extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Remove', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  Remove._() : super();
  factory Remove() => create();
  factory Remove.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Remove.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Remove clone() => Remove()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Remove copyWith(void Function(Remove) updates) => super.copyWith((message) => updates(message as Remove)) as Remove; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ClearDesk', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  ClearDesk._() : super();
  factory ClearDesk() => create();
  factory ClearDesk.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ClearDesk.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ClearDesk clone() => ClearDesk()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ClearDesk copyWith(void Function(ClearDesk) updates) => super.copyWith((message) => updates(message as ClearDesk)) as ClearDesk; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Notification', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  Notification._() : super();
  factory Notification() => create();
  factory Notification.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Notification.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Notification clone() => Notification()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Notification copyWith(void Function(Notification) updates) => super.copyWith((message) => updates(message as Notification)) as Notification; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Leave', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  Leave._() : super();
  factory Leave() => create();
  factory Leave.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Leave.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Leave clone() => Leave()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Leave copyWith(void Function(Leave) updates) => super.copyWith((message) => updates(message as Leave)) as Leave; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Leave create() => Leave._();
  Leave createEmptyInstance() => create();
  static $pb.PbList<Leave> createRepeated() => $pb.PbList<Leave>();
  @$core.pragma('dart2js:noInline')
  static Leave getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Leave>(create);
  static Leave? _defaultInstance;
}

enum GameEnd_Type {
  results, 
  request, 
  notSet
}

class GameEnd extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, GameEnd_Type> _GameEnd_TypeByTag = {
    1 : GameEnd_Type.results,
    2 : GameEnd_Type.request,
    0 : GameEnd_Type.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GameEnd', createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<Results>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'results', subBuilder: Results.create)
    ..aOM<Request>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'request', subBuilder: Request.create)
    ..hasRequiredFields = false
  ;

  GameEnd._() : super();
  factory GameEnd({
    Results? results,
    Request? request,
  }) {
    final _result = create();
    if (results != null) {
      _result.results = results;
    }
    if (request != null) {
      _result.request = request;
    }
    return _result;
  }
  factory GameEnd.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GameEnd.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GameEnd clone() => GameEnd()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GameEnd copyWith(void Function(GameEnd) updates) => super.copyWith((message) => updates(message as GameEnd)) as GameEnd; // ignore: deprecated_member_use
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
  static const $core.Map<$core.int, Connection_Type> _Connection_TypeByTag = {
    3 : Connection_Type.join,
    4 : Connection_Type.disconnect,
    5 : Connection_Type.leave,
    0 : Connection_Type.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Connection', createEmptyInstance: create)
    ..oo(0, [3, 4, 5])
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rating', $pb.PbFieldType.O3)
    ..aOM<Connect>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'join', subBuilder: Connect.create)
    ..aOM<Disconnect>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'disconnect', subBuilder: Disconnect.create)
    ..aOM<Leave>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'leave', subBuilder: Leave.create)
    ..hasRequiredFields = false
  ;

  Connection._() : super();
  factory Connection({
    $core.int? rating,
    Connect? join,
    Disconnect? disconnect,
    Leave? leave,
  }) {
    final _result = create();
    if (rating != null) {
      _result.rating = rating;
    }
    if (join != null) {
      _result.join = join;
    }
    if (disconnect != null) {
      _result.disconnect = disconnect;
    }
    if (leave != null) {
      _result.leave = leave;
    }
    return _result;
  }
  factory Connection.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Connection.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Connection clone() => Connection()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Connection copyWith(void Function(Connection) updates) => super.copyWith((message) => updates(message as Connection)) as Connection; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Licitiranje', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  Licitiranje._() : super();
  factory Licitiranje({
    $core.int? type,
  }) {
    final _result = create();
    if (type != null) {
      _result.type = type;
    }
    return _result;
  }
  factory Licitiranje.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Licitiranje.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Licitiranje clone() => Licitiranje()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Licitiranje copyWith(void Function(Licitiranje) updates) => super.copyWith((message) => updates(message as Licitiranje)) as Licitiranje; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LicitiranjeStart', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  LicitiranjeStart._() : super();
  factory LicitiranjeStart() => create();
  factory LicitiranjeStart.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LicitiranjeStart.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LicitiranjeStart clone() => LicitiranjeStart()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LicitiranjeStart copyWith(void Function(LicitiranjeStart) updates) => super.copyWith((message) => updates(message as LicitiranjeStart)) as LicitiranjeStart; // ignore: deprecated_member_use
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
  static const $core.Map<$core.int, Card_Type> _Card_TypeByTag = {
    3 : Card_Type.receive,
    4 : Card_Type.send,
    5 : Card_Type.request,
    6 : Card_Type.remove,
    0 : Card_Type.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Card', createEmptyInstance: create)
    ..oo(0, [3, 4, 5, 6])
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId', protoName: 'userId')
    ..aOM<Receive>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'receive', subBuilder: Receive.create)
    ..aOM<Send>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'send', subBuilder: Send.create)
    ..aOM<Request>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'request', subBuilder: Request.create)
    ..aOM<Remove>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'remove', subBuilder: Remove.create)
    ..hasRequiredFields = false
  ;

  Card._() : super();
  factory Card({
    $core.String? id,
    $core.String? userId,
    Receive? receive,
    Send? send,
    Request? request,
    Remove? remove,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (userId != null) {
      _result.userId = userId;
    }
    if (receive != null) {
      _result.receive = receive;
    }
    if (send != null) {
      _result.send = send;
    }
    if (request != null) {
      _result.request = request;
    }
    if (remove != null) {
      _result.remove = remove;
    }
    return _result;
  }
  factory Card.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Card.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Card clone() => Card()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Card copyWith(void Function(Card) updates) => super.copyWith((message) => updates(message as Card)) as Card; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GameStartCountdown', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'countdown', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  GameStartCountdown._() : super();
  factory GameStartCountdown({
    $core.int? countdown,
  }) {
    final _result = create();
    if (countdown != null) {
      _result.countdown = countdown;
    }
    return _result;
  }
  factory GameStartCountdown.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GameStartCountdown.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GameStartCountdown clone() => GameStartCountdown()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GameStartCountdown copyWith(void Function(GameStartCountdown) updates) => super.copyWith((message) => updates(message as GameStartCountdown)) as GameStartCountdown; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'User', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'position', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  User._() : super();
  factory User({
    $core.String? id,
    $core.String? name,
    $core.int? position,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (name != null) {
      _result.name = name;
    }
    if (position != null) {
      _result.position = position;
    }
    return _result;
  }
  factory User.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory User.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  User clone() => User()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  User copyWith(void Function(User) updates) => super.copyWith((message) => updates(message as User)) as User; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ResultsUser', createEmptyInstance: create)
    ..pc<User>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'user', $pb.PbFieldType.PM, subBuilder: User.create)
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playing')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'points', $pb.PbFieldType.O3)
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'trula', $pb.PbFieldType.O3)
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagat', $pb.PbFieldType.O3)
    ..a<$core.int>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'igra', $pb.PbFieldType.O3)
    ..a<$core.int>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'razlika', $pb.PbFieldType.O3)
    ..a<$core.int>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'kralj', $pb.PbFieldType.O3)
    ..a<$core.int>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'kralji', $pb.PbFieldType.O3)
    ..a<$core.int>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'kontraPagat', $pb.PbFieldType.O3)
    ..a<$core.int>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'kontraIgra', $pb.PbFieldType.O3)
    ..a<$core.int>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'kontraKralj', $pb.PbFieldType.O3)
    ..aOB(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mondfang')
    ..aOB(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'showGamemode')
    ..aOB(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'showDifference')
    ..aOB(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'showKralj')
    ..aOB(17, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'showPagat')
    ..aOB(18, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'showKralji')
    ..aOB(19, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'showTrula')
    ..aOB(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'radelc')
    ..aOB(21, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'skisfang')
    ..hasRequiredFields = false
  ;

  ResultsUser._() : super();
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
    final _result = create();
    if (user != null) {
      _result.user.addAll(user);
    }
    if (playing != null) {
      _result.playing = playing;
    }
    if (points != null) {
      _result.points = points;
    }
    if (trula != null) {
      _result.trula = trula;
    }
    if (pagat != null) {
      _result.pagat = pagat;
    }
    if (igra != null) {
      _result.igra = igra;
    }
    if (razlika != null) {
      _result.razlika = razlika;
    }
    if (kralj != null) {
      _result.kralj = kralj;
    }
    if (kralji != null) {
      _result.kralji = kralji;
    }
    if (kontraPagat != null) {
      _result.kontraPagat = kontraPagat;
    }
    if (kontraIgra != null) {
      _result.kontraIgra = kontraIgra;
    }
    if (kontraKralj != null) {
      _result.kontraKralj = kontraKralj;
    }
    if (mondfang != null) {
      _result.mondfang = mondfang;
    }
    if (showGamemode != null) {
      _result.showGamemode = showGamemode;
    }
    if (showDifference != null) {
      _result.showDifference = showDifference;
    }
    if (showKralj != null) {
      _result.showKralj = showKralj;
    }
    if (showPagat != null) {
      _result.showPagat = showPagat;
    }
    if (showKralji != null) {
      _result.showKralji = showKralji;
    }
    if (showTrula != null) {
      _result.showTrula = showTrula;
    }
    if (radelc != null) {
      _result.radelc = radelc;
    }
    if (skisfang != null) {
      _result.skisfang = skisfang;
    }
    return _result;
  }
  factory ResultsUser.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ResultsUser.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ResultsUser clone() => ResultsUser()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ResultsUser copyWith(void Function(ResultsUser) updates) => super.copyWith((message) => updates(message as ResultsUser)) as ResultsUser; // ignore: deprecated_member_use
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
  $core.bool get mondfang => $_getBF(12);
  @$pb.TagNumber(13)
  set mondfang($core.bool v) { $_setBool(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasMondfang() => $_has(12);
  @$pb.TagNumber(13)
  void clearMondfang() => clearField(13);

  @$pb.TagNumber(14)
  $core.bool get showGamemode => $_getBF(13);
  @$pb.TagNumber(14)
  set showGamemode($core.bool v) { $_setBool(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasShowGamemode() => $_has(13);
  @$pb.TagNumber(14)
  void clearShowGamemode() => clearField(14);

  @$pb.TagNumber(15)
  $core.bool get showDifference => $_getBF(14);
  @$pb.TagNumber(15)
  set showDifference($core.bool v) { $_setBool(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasShowDifference() => $_has(14);
  @$pb.TagNumber(15)
  void clearShowDifference() => clearField(15);

  @$pb.TagNumber(16)
  $core.bool get showKralj => $_getBF(15);
  @$pb.TagNumber(16)
  set showKralj($core.bool v) { $_setBool(15, v); }
  @$pb.TagNumber(16)
  $core.bool hasShowKralj() => $_has(15);
  @$pb.TagNumber(16)
  void clearShowKralj() => clearField(16);

  @$pb.TagNumber(17)
  $core.bool get showPagat => $_getBF(16);
  @$pb.TagNumber(17)
  set showPagat($core.bool v) { $_setBool(16, v); }
  @$pb.TagNumber(17)
  $core.bool hasShowPagat() => $_has(16);
  @$pb.TagNumber(17)
  void clearShowPagat() => clearField(17);

  @$pb.TagNumber(18)
  $core.bool get showKralji => $_getBF(17);
  @$pb.TagNumber(18)
  set showKralji($core.bool v) { $_setBool(17, v); }
  @$pb.TagNumber(18)
  $core.bool hasShowKralji() => $_has(17);
  @$pb.TagNumber(18)
  void clearShowKralji() => clearField(18);

  @$pb.TagNumber(19)
  $core.bool get showTrula => $_getBF(18);
  @$pb.TagNumber(19)
  set showTrula($core.bool v) { $_setBool(18, v); }
  @$pb.TagNumber(19)
  $core.bool hasShowTrula() => $_has(18);
  @$pb.TagNumber(19)
  void clearShowTrula() => clearField(19);

  @$pb.TagNumber(20)
  $core.bool get radelc => $_getBF(19);
  @$pb.TagNumber(20)
  set radelc($core.bool v) { $_setBool(19, v); }
  @$pb.TagNumber(20)
  $core.bool hasRadelc() => $_has(19);
  @$pb.TagNumber(20)
  void clearRadelc() => clearField(20);

  @$pb.TagNumber(21)
  $core.bool get skisfang => $_getBF(20);
  @$pb.TagNumber(21)
  set skisfang($core.bool v) { $_setBool(20, v); }
  @$pb.TagNumber(21)
  $core.bool hasSkisfang() => $_has(20);
  @$pb.TagNumber(21)
  void clearSkisfang() => clearField(21);
}

class Stih extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Stih', createEmptyInstance: create)
    ..pc<Card>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'card', $pb.PbFieldType.PM, subBuilder: Card.create)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'worth', $pb.PbFieldType.OF)
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pickedUpByPlaying', protoName: 'pickedUpByPlaying')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pickedUpBy', protoName: 'pickedUpBy')
    ..hasRequiredFields = false
  ;

  Stih._() : super();
  factory Stih({
    $core.Iterable<Card>? card,
    $core.double? worth,
    $core.bool? pickedUpByPlaying,
    $core.String? pickedUpBy,
  }) {
    final _result = create();
    if (card != null) {
      _result.card.addAll(card);
    }
    if (worth != null) {
      _result.worth = worth;
    }
    if (pickedUpByPlaying != null) {
      _result.pickedUpByPlaying = pickedUpByPlaying;
    }
    if (pickedUpBy != null) {
      _result.pickedUpBy = pickedUpBy;
    }
    return _result;
  }
  factory Stih.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Stih.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Stih clone() => Stih()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Stih copyWith(void Function(Stih) updates) => super.copyWith((message) => updates(message as Stih)) as Stih; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Results', createEmptyInstance: create)
    ..pc<ResultsUser>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'user', $pb.PbFieldType.PM, subBuilder: ResultsUser.create)
    ..pc<Stih>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'stih', $pb.PbFieldType.PM, subBuilder: Stih.create)
    ..hasRequiredFields = false
  ;

  Results._() : super();
  factory Results({
    $core.Iterable<ResultsUser>? user,
    $core.Iterable<Stih>? stih,
  }) {
    final _result = create();
    if (user != null) {
      _result.user.addAll(user);
    }
    if (stih != null) {
      _result.stih.addAll(stih);
    }
    return _result;
  }
  factory Results.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Results.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Results clone() => Results()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Results copyWith(void Function(Results) updates) => super.copyWith((message) => updates(message as Results)) as Results; // ignore: deprecated_member_use
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
}

class GameStart extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GameStart', createEmptyInstance: create)
    ..pc<User>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'user', $pb.PbFieldType.PM, subBuilder: User.create)
    ..hasRequiredFields = false
  ;

  GameStart._() : super();
  factory GameStart({
    $core.Iterable<User>? user,
  }) {
    final _result = create();
    if (user != null) {
      _result.user.addAll(user);
    }
    return _result;
  }
  factory GameStart.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GameStart.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GameStart clone() => GameStart()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GameStart copyWith(void Function(GameStart) updates) => super.copyWith((message) => updates(message as GameStart)) as GameStart; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UserList', createEmptyInstance: create)
    ..pc<User>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'user', $pb.PbFieldType.PM, subBuilder: User.create)
    ..hasRequiredFields = false
  ;

  UserList._() : super();
  factory UserList({
    $core.Iterable<User>? user,
  }) {
    final _result = create();
    if (user != null) {
      _result.user.addAll(user);
    }
    return _result;
  }
  factory UserList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UserList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UserList clone() => UserList()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UserList copyWith(void Function(UserList) updates) => super.copyWith((message) => updates(message as UserList)) as UserList; // ignore: deprecated_member_use
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
  static const $core.Map<$core.int, KingSelection_Type> _KingSelection_TypeByTag = {
    2 : KingSelection_Type.request,
    3 : KingSelection_Type.send,
    4 : KingSelection_Type.notification,
    0 : KingSelection_Type.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'KingSelection', createEmptyInstance: create)
    ..oo(0, [2, 3, 4])
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'card')
    ..aOM<Request>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'request', subBuilder: Request.create)
    ..aOM<Send>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'send', subBuilder: Send.create)
    ..aOM<Notification>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'notification', subBuilder: Notification.create)
    ..hasRequiredFields = false
  ;

  KingSelection._() : super();
  factory KingSelection({
    $core.String? card,
    Request? request,
    Send? send,
    Notification? notification,
  }) {
    final _result = create();
    if (card != null) {
      _result.card = card;
    }
    if (request != null) {
      _result.request = request;
    }
    if (send != null) {
      _result.send = send;
    }
    if (notification != null) {
      _result.notification = notification;
    }
    return _result;
  }
  factory KingSelection.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory KingSelection.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  KingSelection clone() => KingSelection()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  KingSelection copyWith(void Function(KingSelection) updates) => super.copyWith((message) => updates(message as KingSelection)) as KingSelection; // ignore: deprecated_member_use
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
  static const $core.Map<$core.int, TalonSelection_Type> _TalonSelection_TypeByTag = {
    2 : TalonSelection_Type.request,
    3 : TalonSelection_Type.send,
    4 : TalonSelection_Type.notification,
    0 : TalonSelection_Type.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TalonSelection', createEmptyInstance: create)
    ..oo(0, [2, 3, 4])
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'part', $pb.PbFieldType.O3)
    ..aOM<Request>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'request', subBuilder: Request.create)
    ..aOM<Send>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'send', subBuilder: Send.create)
    ..aOM<Notification>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'notification', subBuilder: Notification.create)
    ..hasRequiredFields = false
  ;

  TalonSelection._() : super();
  factory TalonSelection({
    $core.int? part,
    Request? request,
    Send? send,
    Notification? notification,
  }) {
    final _result = create();
    if (part != null) {
      _result.part = part;
    }
    if (request != null) {
      _result.request = request;
    }
    if (send != null) {
      _result.send = send;
    }
    if (notification != null) {
      _result.notification = notification;
    }
    return _result;
  }
  factory TalonSelection.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TalonSelection.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TalonSelection clone() => TalonSelection()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TalonSelection copyWith(void Function(TalonSelection) updates) => super.copyWith((message) => updates(message as TalonSelection)) as TalonSelection; // ignore: deprecated_member_use
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
  static const $core.Map<$core.int, Stash_Type> _Stash_TypeByTag = {
    3 : Stash_Type.request,
    4 : Stash_Type.send,
    5 : Stash_Type.notification,
    0 : Stash_Type.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Stash', createEmptyInstance: create)
    ..oo(0, [3, 4, 5])
    ..pc<Card>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'card', $pb.PbFieldType.PM, subBuilder: Card.create)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'length', $pb.PbFieldType.O3)
    ..aOM<Request>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'request', subBuilder: Request.create)
    ..aOM<Send>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'send', subBuilder: Send.create)
    ..aOM<Notification>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'notification', subBuilder: Notification.create)
    ..hasRequiredFields = false
  ;

  Stash._() : super();
  factory Stash({
    $core.Iterable<Card>? card,
    $core.int? length,
    Request? request,
    Send? send,
    Notification? notification,
  }) {
    final _result = create();
    if (card != null) {
      _result.card.addAll(card);
    }
    if (length != null) {
      _result.length = length;
    }
    if (request != null) {
      _result.request = request;
    }
    if (send != null) {
      _result.send = send;
    }
    if (notification != null) {
      _result.notification = notification;
    }
    return _result;
  }
  factory Stash.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Stash.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Stash clone() => Stash()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Stash copyWith(void Function(Stash) updates) => super.copyWith((message) => updates(message as Stash)) as Stash; // ignore: deprecated_member_use
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

class Radelci extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Radelci', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'radleci', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  Radelci._() : super();
  factory Radelci({
    $core.int? radleci,
  }) {
    final _result = create();
    if (radleci != null) {
      _result.radleci = radleci;
    }
    return _result;
  }
  factory Radelci.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Radelci.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Radelci clone() => Radelci()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Radelci copyWith(void Function(Radelci) updates) => super.copyWith((message) => updates(message as Radelci)) as Radelci; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StartPredictions', createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'kraljUltimoKontra')
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagatUltimoKontra')
    ..aOB(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'igraKontra')
    ..aOB(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'valatKontra')
    ..aOB(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'barvniValatKontra')
    ..aOB(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagatUltimo')
    ..aOB(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'trula')
    ..aOB(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'kralji')
    ..aOB(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'kraljUltimo')
    ..aOB(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'valat')
    ..aOB(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'barvniValat')
    ..hasRequiredFields = false
  ;

  StartPredictions._() : super();
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
  }) {
    final _result = create();
    if (kraljUltimoKontra != null) {
      _result.kraljUltimoKontra = kraljUltimoKontra;
    }
    if (pagatUltimoKontra != null) {
      _result.pagatUltimoKontra = pagatUltimoKontra;
    }
    if (igraKontra != null) {
      _result.igraKontra = igraKontra;
    }
    if (valatKontra != null) {
      _result.valatKontra = valatKontra;
    }
    if (barvniValatKontra != null) {
      _result.barvniValatKontra = barvniValatKontra;
    }
    if (pagatUltimo != null) {
      _result.pagatUltimo = pagatUltimo;
    }
    if (trula != null) {
      _result.trula = trula;
    }
    if (kralji != null) {
      _result.kralji = kralji;
    }
    if (kraljUltimo != null) {
      _result.kraljUltimo = kraljUltimo;
    }
    if (valat != null) {
      _result.valat = valat;
    }
    if (barvniValat != null) {
      _result.barvniValat = barvniValat;
    }
    return _result;
  }
  factory StartPredictions.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StartPredictions.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StartPredictions clone() => StartPredictions()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StartPredictions copyWith(void Function(StartPredictions) updates) => super.copyWith((message) => updates(message as StartPredictions)) as StartPredictions; // ignore: deprecated_member_use
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
}

class Predictions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Predictions', createEmptyInstance: create)
    ..aOM<User>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'kraljUltimo', subBuilder: User.create)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'kraljUltimoKontra', $pb.PbFieldType.O3)
    ..aOM<User>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'kraljUltimoKontraDal', subBuilder: User.create)
    ..aOM<User>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'trula', subBuilder: User.create)
    ..aOM<User>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'kralji', subBuilder: User.create)
    ..aOM<User>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagatUltimo', subBuilder: User.create)
    ..a<$core.int>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagatUltimoKontra', $pb.PbFieldType.O3)
    ..aOM<User>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagatUltimoKontraDal', subBuilder: User.create)
    ..aOM<User>(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'igra', subBuilder: User.create)
    ..a<$core.int>(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'igraKontra', $pb.PbFieldType.O3)
    ..aOM<User>(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'igraKontraDal', subBuilder: User.create)
    ..aOM<User>(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'valat', subBuilder: User.create)
    ..a<$core.int>(17, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'valatKontra', $pb.PbFieldType.O3)
    ..aOM<User>(18, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'valatKontraDal', subBuilder: User.create)
    ..aOM<User>(19, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'barvniValat', subBuilder: User.create)
    ..a<$core.int>(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'barvniValatKontra', $pb.PbFieldType.O3)
    ..aOM<User>(21, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'barvniValatKontraDal', subBuilder: User.create)
    ..a<$core.int>(22, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gamemode', $pb.PbFieldType.O3)
    ..aOB(23, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'changed')
    ..hasRequiredFields = false
  ;

  Predictions._() : super();
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
    $core.int? valatKontra,
    User? valatKontraDal,
    User? barvniValat,
    $core.int? barvniValatKontra,
    User? barvniValatKontraDal,
    $core.int? gamemode,
    $core.bool? changed,
  }) {
    final _result = create();
    if (kraljUltimo != null) {
      _result.kraljUltimo = kraljUltimo;
    }
    if (kraljUltimoKontra != null) {
      _result.kraljUltimoKontra = kraljUltimoKontra;
    }
    if (kraljUltimoKontraDal != null) {
      _result.kraljUltimoKontraDal = kraljUltimoKontraDal;
    }
    if (trula != null) {
      _result.trula = trula;
    }
    if (kralji != null) {
      _result.kralji = kralji;
    }
    if (pagatUltimo != null) {
      _result.pagatUltimo = pagatUltimo;
    }
    if (pagatUltimoKontra != null) {
      _result.pagatUltimoKontra = pagatUltimoKontra;
    }
    if (pagatUltimoKontraDal != null) {
      _result.pagatUltimoKontraDal = pagatUltimoKontraDal;
    }
    if (igra != null) {
      _result.igra = igra;
    }
    if (igraKontra != null) {
      _result.igraKontra = igraKontra;
    }
    if (igraKontraDal != null) {
      _result.igraKontraDal = igraKontraDal;
    }
    if (valat != null) {
      _result.valat = valat;
    }
    if (valatKontra != null) {
      _result.valatKontra = valatKontra;
    }
    if (valatKontraDal != null) {
      _result.valatKontraDal = valatKontraDal;
    }
    if (barvniValat != null) {
      _result.barvniValat = barvniValat;
    }
    if (barvniValatKontra != null) {
      _result.barvniValatKontra = barvniValatKontra;
    }
    if (barvniValatKontraDal != null) {
      _result.barvniValatKontraDal = barvniValatKontraDal;
    }
    if (gamemode != null) {
      _result.gamemode = gamemode;
    }
    if (changed != null) {
      _result.changed = changed;
    }
    return _result;
  }
  factory Predictions.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Predictions.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Predictions clone() => Predictions()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Predictions copyWith(void Function(Predictions) updates) => super.copyWith((message) => updates(message as Predictions)) as Predictions; // ignore: deprecated_member_use
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
  $core.int get valatKontra => $_getIZ(12);
  @$pb.TagNumber(17)
  set valatKontra($core.int v) { $_setSignedInt32(12, v); }
  @$pb.TagNumber(17)
  $core.bool hasValatKontra() => $_has(12);
  @$pb.TagNumber(17)
  void clearValatKontra() => clearField(17);

  @$pb.TagNumber(18)
  User get valatKontraDal => $_getN(13);
  @$pb.TagNumber(18)
  set valatKontraDal(User v) { setField(18, v); }
  @$pb.TagNumber(18)
  $core.bool hasValatKontraDal() => $_has(13);
  @$pb.TagNumber(18)
  void clearValatKontraDal() => clearField(18);
  @$pb.TagNumber(18)
  User ensureValatKontraDal() => $_ensure(13);

  @$pb.TagNumber(19)
  User get barvniValat => $_getN(14);
  @$pb.TagNumber(19)
  set barvniValat(User v) { setField(19, v); }
  @$pb.TagNumber(19)
  $core.bool hasBarvniValat() => $_has(14);
  @$pb.TagNumber(19)
  void clearBarvniValat() => clearField(19);
  @$pb.TagNumber(19)
  User ensureBarvniValat() => $_ensure(14);

  @$pb.TagNumber(20)
  $core.int get barvniValatKontra => $_getIZ(15);
  @$pb.TagNumber(20)
  set barvniValatKontra($core.int v) { $_setSignedInt32(15, v); }
  @$pb.TagNumber(20)
  $core.bool hasBarvniValatKontra() => $_has(15);
  @$pb.TagNumber(20)
  void clearBarvniValatKontra() => clearField(20);

  @$pb.TagNumber(21)
  User get barvniValatKontraDal => $_getN(16);
  @$pb.TagNumber(21)
  set barvniValatKontraDal(User v) { setField(21, v); }
  @$pb.TagNumber(21)
  $core.bool hasBarvniValatKontraDal() => $_has(16);
  @$pb.TagNumber(21)
  void clearBarvniValatKontraDal() => clearField(21);
  @$pb.TagNumber(21)
  User ensureBarvniValatKontraDal() => $_ensure(16);

  @$pb.TagNumber(22)
  $core.int get gamemode => $_getIZ(17);
  @$pb.TagNumber(22)
  set gamemode($core.int v) { $_setSignedInt32(17, v); }
  @$pb.TagNumber(22)
  $core.bool hasGamemode() => $_has(17);
  @$pb.TagNumber(22)
  void clearGamemode() => clearField(22);

  @$pb.TagNumber(23)
  $core.bool get changed => $_getBF(18);
  @$pb.TagNumber(23)
  set changed($core.bool v) { $_setBool(18, v); }
  @$pb.TagNumber(23)
  $core.bool hasChanged() => $_has(18);
  @$pb.TagNumber(23)
  void clearChanged() => clearField(23);
}

class TalonReveal extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TalonReveal', createEmptyInstance: create)
    ..pc<Stih>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'stih', $pb.PbFieldType.PM, subBuilder: Stih.create)
    ..hasRequiredFields = false
  ;

  TalonReveal._() : super();
  factory TalonReveal({
    $core.Iterable<Stih>? stih,
  }) {
    final _result = create();
    if (stih != null) {
      _result.stih.addAll(stih);
    }
    return _result;
  }
  factory TalonReveal.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TalonReveal.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TalonReveal clone() => TalonReveal()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TalonReveal copyWith(void Function(TalonReveal) updates) => super.copyWith((message) => updates(message as TalonReveal)) as TalonReveal; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PlayingReveal', createEmptyInstance: create)
    ..aOM<User>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playing', subBuilder: User.create)
    ..hasRequiredFields = false
  ;

  PlayingReveal._() : super();
  factory PlayingReveal({
    User? playing,
  }) {
    final _result = create();
    if (playing != null) {
      _result.playing = playing;
    }
    return _result;
  }
  factory PlayingReveal.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PlayingReveal.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PlayingReveal clone() => PlayingReveal()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PlayingReveal copyWith(void Function(PlayingReveal) updates) => super.copyWith((message) => updates(message as PlayingReveal)) as PlayingReveal; // ignore: deprecated_member_use
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

class LoginRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LoginRequest', createEmptyInstance: create)
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LoginInfo', createEmptyInstance: create)
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LoginResponse.OK', createEmptyInstance: create)
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LoginResponse.Fail', createEmptyInstance: create)
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LoginResponse', createEmptyInstance: create)
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

class InvitePlayer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'InvitePlayer', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  InvitePlayer._() : super();
  factory InvitePlayer() => create();
  factory InvitePlayer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory InvitePlayer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  InvitePlayer clone() => InvitePlayer()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  InvitePlayer copyWith(void Function(InvitePlayer) updates) => super.copyWith((message) => updates(message as InvitePlayer)) as InvitePlayer; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static InvitePlayer create() => InvitePlayer._();
  InvitePlayer createEmptyInstance() => create();
  static $pb.PbList<InvitePlayer> createRepeated() => $pb.PbList<InvitePlayer>();
  @$core.pragma('dart2js:noInline')
  static InvitePlayer getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InvitePlayer>(create);
  static InvitePlayer? _defaultInstance;
}

class Time extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Time', createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'currentTime', $pb.PbFieldType.OF, protoName: 'currentTime')
    ..hasRequiredFields = false
  ;

  Time._() : super();
  factory Time({
    $core.double? currentTime,
  }) {
    final _result = create();
    if (currentTime != null) {
      _result.currentTime = currentTime;
    }
    return _result;
  }
  factory Time.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Time.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Time clone() => Time()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Time copyWith(void Function(Time) updates) => super.copyWith((message) => updates(message as Time)) as Time; // ignore: deprecated_member_use
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
}

class ChatMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ChatMessage', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'message')
    ..hasRequiredFields = false
  ;

  ChatMessage._() : super();
  factory ChatMessage({
    $core.String? userId,
    $core.String? message,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (message != null) {
      _result.message = message;
    }
    return _result;
  }
  factory ChatMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChatMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChatMessage clone() => ChatMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChatMessage copyWith(void Function(ChatMessage) updates) => super.copyWith((message) => updates(message as ChatMessage)) as ChatMessage; // ignore: deprecated_member_use
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
  notSet
}

class Message extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, Message_Data> _Message_DataByTag = {
    4 : Message_Data.connection,
    5 : Message_Data.licitiranje,
    6 : Message_Data.card,
    7 : Message_Data.licitiranjeStart,
    8 : Message_Data.gameStart,
    9 : Message_Data.loginRequest,
    10 : Message_Data.loginInfo,
    11 : Message_Data.loginResponse,
    12 : Message_Data.clearDesk,
    13 : Message_Data.results,
    14 : Message_Data.userList,
    15 : Message_Data.kingSelection,
    16 : Message_Data.startPredictions,
    17 : Message_Data.predictions,
    18 : Message_Data.talonReveal,
    19 : Message_Data.playingReveal,
    20 : Message_Data.talonSelection,
    21 : Message_Data.stash,
    22 : Message_Data.gameEnd,
    23 : Message_Data.gameStartCountdown,
    24 : Message_Data.predictionsResend,
    25 : Message_Data.radelci,
    26 : Message_Data.time,
    27 : Message_Data.chatMessage,
    28 : Message_Data.invitePlayer,
    0 : Message_Data.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Message', createEmptyInstance: create)
    ..oo(0, [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28])
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'username')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playerId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gameId')
    ..aOM<Connection>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'connection', subBuilder: Connection.create)
    ..aOM<Licitiranje>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'licitiranje', subBuilder: Licitiranje.create)
    ..aOM<Card>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'card', subBuilder: Card.create)
    ..aOM<LicitiranjeStart>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'licitiranjeStart', subBuilder: LicitiranjeStart.create)
    ..aOM<GameStart>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gameStart', subBuilder: GameStart.create)
    ..aOM<LoginRequest>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'loginRequest', subBuilder: LoginRequest.create)
    ..aOM<LoginInfo>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'loginInfo', subBuilder: LoginInfo.create)
    ..aOM<LoginResponse>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'loginResponse', subBuilder: LoginResponse.create)
    ..aOM<ClearDesk>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'clearDesk', subBuilder: ClearDesk.create)
    ..aOM<Results>(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'results', subBuilder: Results.create)
    ..aOM<UserList>(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userList', subBuilder: UserList.create)
    ..aOM<KingSelection>(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'kingSelection', subBuilder: KingSelection.create)
    ..aOM<StartPredictions>(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'startPredictions', subBuilder: StartPredictions.create)
    ..aOM<Predictions>(17, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'predictions', subBuilder: Predictions.create)
    ..aOM<TalonReveal>(18, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'talonReveal', subBuilder: TalonReveal.create)
    ..aOM<PlayingReveal>(19, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playingReveal', subBuilder: PlayingReveal.create)
    ..aOM<TalonSelection>(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'talonSelection', subBuilder: TalonSelection.create)
    ..aOM<Stash>(21, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'stash', subBuilder: Stash.create)
    ..aOM<GameEnd>(22, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gameEnd', subBuilder: GameEnd.create)
    ..aOM<GameStartCountdown>(23, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gameStartCountdown', subBuilder: GameStartCountdown.create)
    ..aOM<Predictions>(24, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'predictionsResend', subBuilder: Predictions.create)
    ..aOM<Radelci>(25, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'radelci', subBuilder: Radelci.create)
    ..aOM<Time>(26, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'time', subBuilder: Time.create)
    ..aOM<ChatMessage>(27, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'chatMessage', subBuilder: ChatMessage.create)
    ..aOM<InvitePlayer>(28, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'invitePlayer', subBuilder: InvitePlayer.create)
    ..hasRequiredFields = false
  ;

  Message._() : super();
  factory Message({
    $core.String? username,
    $core.String? playerId,
    $core.String? gameId,
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
  }) {
    final _result = create();
    if (username != null) {
      _result.username = username;
    }
    if (playerId != null) {
      _result.playerId = playerId;
    }
    if (gameId != null) {
      _result.gameId = gameId;
    }
    if (connection != null) {
      _result.connection = connection;
    }
    if (licitiranje != null) {
      _result.licitiranje = licitiranje;
    }
    if (card != null) {
      _result.card = card;
    }
    if (licitiranjeStart != null) {
      _result.licitiranjeStart = licitiranjeStart;
    }
    if (gameStart != null) {
      _result.gameStart = gameStart;
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
    if (clearDesk != null) {
      _result.clearDesk = clearDesk;
    }
    if (results != null) {
      _result.results = results;
    }
    if (userList != null) {
      _result.userList = userList;
    }
    if (kingSelection != null) {
      _result.kingSelection = kingSelection;
    }
    if (startPredictions != null) {
      _result.startPredictions = startPredictions;
    }
    if (predictions != null) {
      _result.predictions = predictions;
    }
    if (talonReveal != null) {
      _result.talonReveal = talonReveal;
    }
    if (playingReveal != null) {
      _result.playingReveal = playingReveal;
    }
    if (talonSelection != null) {
      _result.talonSelection = talonSelection;
    }
    if (stash != null) {
      _result.stash = stash;
    }
    if (gameEnd != null) {
      _result.gameEnd = gameEnd;
    }
    if (gameStartCountdown != null) {
      _result.gameStartCountdown = gameStartCountdown;
    }
    if (predictionsResend != null) {
      _result.predictionsResend = predictionsResend;
    }
    if (radelci != null) {
      _result.radelci = radelci;
    }
    if (time != null) {
      _result.time = time;
    }
    if (chatMessage != null) {
      _result.chatMessage = chatMessage;
    }
    if (invitePlayer != null) {
      _result.invitePlayer = invitePlayer;
    }
    return _result;
  }
  factory Message.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Message.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Message clone() => Message()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Message copyWith(void Function(Message) updates) => super.copyWith((message) => updates(message as Message)) as Message; // ignore: deprecated_member_use
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

  @$pb.TagNumber(3)
  $core.String get gameId => $_getSZ(2);
  @$pb.TagNumber(3)
  set gameId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasGameId() => $_has(2);
  @$pb.TagNumber(3)
  void clearGameId() => clearField(3);

  @$pb.TagNumber(4)
  Connection get connection => $_getN(3);
  @$pb.TagNumber(4)
  set connection(Connection v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasConnection() => $_has(3);
  @$pb.TagNumber(4)
  void clearConnection() => clearField(4);
  @$pb.TagNumber(4)
  Connection ensureConnection() => $_ensure(3);

  @$pb.TagNumber(5)
  Licitiranje get licitiranje => $_getN(4);
  @$pb.TagNumber(5)
  set licitiranje(Licitiranje v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasLicitiranje() => $_has(4);
  @$pb.TagNumber(5)
  void clearLicitiranje() => clearField(5);
  @$pb.TagNumber(5)
  Licitiranje ensureLicitiranje() => $_ensure(4);

  @$pb.TagNumber(6)
  Card get card => $_getN(5);
  @$pb.TagNumber(6)
  set card(Card v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasCard() => $_has(5);
  @$pb.TagNumber(6)
  void clearCard() => clearField(6);
  @$pb.TagNumber(6)
  Card ensureCard() => $_ensure(5);

  @$pb.TagNumber(7)
  LicitiranjeStart get licitiranjeStart => $_getN(6);
  @$pb.TagNumber(7)
  set licitiranjeStart(LicitiranjeStart v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasLicitiranjeStart() => $_has(6);
  @$pb.TagNumber(7)
  void clearLicitiranjeStart() => clearField(7);
  @$pb.TagNumber(7)
  LicitiranjeStart ensureLicitiranjeStart() => $_ensure(6);

  @$pb.TagNumber(8)
  GameStart get gameStart => $_getN(7);
  @$pb.TagNumber(8)
  set gameStart(GameStart v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasGameStart() => $_has(7);
  @$pb.TagNumber(8)
  void clearGameStart() => clearField(8);
  @$pb.TagNumber(8)
  GameStart ensureGameStart() => $_ensure(7);

  @$pb.TagNumber(9)
  LoginRequest get loginRequest => $_getN(8);
  @$pb.TagNumber(9)
  set loginRequest(LoginRequest v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasLoginRequest() => $_has(8);
  @$pb.TagNumber(9)
  void clearLoginRequest() => clearField(9);
  @$pb.TagNumber(9)
  LoginRequest ensureLoginRequest() => $_ensure(8);

  @$pb.TagNumber(10)
  LoginInfo get loginInfo => $_getN(9);
  @$pb.TagNumber(10)
  set loginInfo(LoginInfo v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasLoginInfo() => $_has(9);
  @$pb.TagNumber(10)
  void clearLoginInfo() => clearField(10);
  @$pb.TagNumber(10)
  LoginInfo ensureLoginInfo() => $_ensure(9);

  @$pb.TagNumber(11)
  LoginResponse get loginResponse => $_getN(10);
  @$pb.TagNumber(11)
  set loginResponse(LoginResponse v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasLoginResponse() => $_has(10);
  @$pb.TagNumber(11)
  void clearLoginResponse() => clearField(11);
  @$pb.TagNumber(11)
  LoginResponse ensureLoginResponse() => $_ensure(10);

  @$pb.TagNumber(12)
  ClearDesk get clearDesk => $_getN(11);
  @$pb.TagNumber(12)
  set clearDesk(ClearDesk v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasClearDesk() => $_has(11);
  @$pb.TagNumber(12)
  void clearClearDesk() => clearField(12);
  @$pb.TagNumber(12)
  ClearDesk ensureClearDesk() => $_ensure(11);

  @$pb.TagNumber(13)
  Results get results => $_getN(12);
  @$pb.TagNumber(13)
  set results(Results v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasResults() => $_has(12);
  @$pb.TagNumber(13)
  void clearResults() => clearField(13);
  @$pb.TagNumber(13)
  Results ensureResults() => $_ensure(12);

  @$pb.TagNumber(14)
  UserList get userList => $_getN(13);
  @$pb.TagNumber(14)
  set userList(UserList v) { setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasUserList() => $_has(13);
  @$pb.TagNumber(14)
  void clearUserList() => clearField(14);
  @$pb.TagNumber(14)
  UserList ensureUserList() => $_ensure(13);

  @$pb.TagNumber(15)
  KingSelection get kingSelection => $_getN(14);
  @$pb.TagNumber(15)
  set kingSelection(KingSelection v) { setField(15, v); }
  @$pb.TagNumber(15)
  $core.bool hasKingSelection() => $_has(14);
  @$pb.TagNumber(15)
  void clearKingSelection() => clearField(15);
  @$pb.TagNumber(15)
  KingSelection ensureKingSelection() => $_ensure(14);

  @$pb.TagNumber(16)
  StartPredictions get startPredictions => $_getN(15);
  @$pb.TagNumber(16)
  set startPredictions(StartPredictions v) { setField(16, v); }
  @$pb.TagNumber(16)
  $core.bool hasStartPredictions() => $_has(15);
  @$pb.TagNumber(16)
  void clearStartPredictions() => clearField(16);
  @$pb.TagNumber(16)
  StartPredictions ensureStartPredictions() => $_ensure(15);

  @$pb.TagNumber(17)
  Predictions get predictions => $_getN(16);
  @$pb.TagNumber(17)
  set predictions(Predictions v) { setField(17, v); }
  @$pb.TagNumber(17)
  $core.bool hasPredictions() => $_has(16);
  @$pb.TagNumber(17)
  void clearPredictions() => clearField(17);
  @$pb.TagNumber(17)
  Predictions ensurePredictions() => $_ensure(16);

  @$pb.TagNumber(18)
  TalonReveal get talonReveal => $_getN(17);
  @$pb.TagNumber(18)
  set talonReveal(TalonReveal v) { setField(18, v); }
  @$pb.TagNumber(18)
  $core.bool hasTalonReveal() => $_has(17);
  @$pb.TagNumber(18)
  void clearTalonReveal() => clearField(18);
  @$pb.TagNumber(18)
  TalonReveal ensureTalonReveal() => $_ensure(17);

  @$pb.TagNumber(19)
  PlayingReveal get playingReveal => $_getN(18);
  @$pb.TagNumber(19)
  set playingReveal(PlayingReveal v) { setField(19, v); }
  @$pb.TagNumber(19)
  $core.bool hasPlayingReveal() => $_has(18);
  @$pb.TagNumber(19)
  void clearPlayingReveal() => clearField(19);
  @$pb.TagNumber(19)
  PlayingReveal ensurePlayingReveal() => $_ensure(18);

  @$pb.TagNumber(20)
  TalonSelection get talonSelection => $_getN(19);
  @$pb.TagNumber(20)
  set talonSelection(TalonSelection v) { setField(20, v); }
  @$pb.TagNumber(20)
  $core.bool hasTalonSelection() => $_has(19);
  @$pb.TagNumber(20)
  void clearTalonSelection() => clearField(20);
  @$pb.TagNumber(20)
  TalonSelection ensureTalonSelection() => $_ensure(19);

  @$pb.TagNumber(21)
  Stash get stash => $_getN(20);
  @$pb.TagNumber(21)
  set stash(Stash v) { setField(21, v); }
  @$pb.TagNumber(21)
  $core.bool hasStash() => $_has(20);
  @$pb.TagNumber(21)
  void clearStash() => clearField(21);
  @$pb.TagNumber(21)
  Stash ensureStash() => $_ensure(20);

  @$pb.TagNumber(22)
  GameEnd get gameEnd => $_getN(21);
  @$pb.TagNumber(22)
  set gameEnd(GameEnd v) { setField(22, v); }
  @$pb.TagNumber(22)
  $core.bool hasGameEnd() => $_has(21);
  @$pb.TagNumber(22)
  void clearGameEnd() => clearField(22);
  @$pb.TagNumber(22)
  GameEnd ensureGameEnd() => $_ensure(21);

  @$pb.TagNumber(23)
  GameStartCountdown get gameStartCountdown => $_getN(22);
  @$pb.TagNumber(23)
  set gameStartCountdown(GameStartCountdown v) { setField(23, v); }
  @$pb.TagNumber(23)
  $core.bool hasGameStartCountdown() => $_has(22);
  @$pb.TagNumber(23)
  void clearGameStartCountdown() => clearField(23);
  @$pb.TagNumber(23)
  GameStartCountdown ensureGameStartCountdown() => $_ensure(22);

  @$pb.TagNumber(24)
  Predictions get predictionsResend => $_getN(23);
  @$pb.TagNumber(24)
  set predictionsResend(Predictions v) { setField(24, v); }
  @$pb.TagNumber(24)
  $core.bool hasPredictionsResend() => $_has(23);
  @$pb.TagNumber(24)
  void clearPredictionsResend() => clearField(24);
  @$pb.TagNumber(24)
  Predictions ensurePredictionsResend() => $_ensure(23);

  @$pb.TagNumber(25)
  Radelci get radelci => $_getN(24);
  @$pb.TagNumber(25)
  set radelci(Radelci v) { setField(25, v); }
  @$pb.TagNumber(25)
  $core.bool hasRadelci() => $_has(24);
  @$pb.TagNumber(25)
  void clearRadelci() => clearField(25);
  @$pb.TagNumber(25)
  Radelci ensureRadelci() => $_ensure(24);

  @$pb.TagNumber(26)
  Time get time => $_getN(25);
  @$pb.TagNumber(26)
  set time(Time v) { setField(26, v); }
  @$pb.TagNumber(26)
  $core.bool hasTime() => $_has(25);
  @$pb.TagNumber(26)
  void clearTime() => clearField(26);
  @$pb.TagNumber(26)
  Time ensureTime() => $_ensure(25);

  @$pb.TagNumber(27)
  ChatMessage get chatMessage => $_getN(26);
  @$pb.TagNumber(27)
  set chatMessage(ChatMessage v) { setField(27, v); }
  @$pb.TagNumber(27)
  $core.bool hasChatMessage() => $_has(26);
  @$pb.TagNumber(27)
  void clearChatMessage() => clearField(27);
  @$pb.TagNumber(27)
  ChatMessage ensureChatMessage() => $_ensure(26);

  @$pb.TagNumber(28)
  InvitePlayer get invitePlayer => $_getN(27);
  @$pb.TagNumber(28)
  set invitePlayer(InvitePlayer v) { setField(28, v); }
  @$pb.TagNumber(28)
  $core.bool hasInvitePlayer() => $_has(27);
  @$pb.TagNumber(28)
  void clearInvitePlayer() => clearField(28);
  @$pb.TagNumber(28)
  InvitePlayer ensureInvitePlayer() => $_ensure(27);
}

