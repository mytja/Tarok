// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'constants.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LocalCardCWProxy {
  LocalCard asset(String asset);

  LocalCard worth(int worth);

  LocalCard worthOver(int worthOver);

  LocalCard alt(String alt);

  LocalCard showZoom(bool showZoom);

  LocalCard valid(bool valid);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LocalCard(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LocalCard(...).copyWith(id: 12, name: "My name")
  /// ````
  LocalCard call({
    String? asset,
    int? worth,
    int? worthOver,
    String? alt,
    bool? showZoom,
    bool? valid,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLocalCard.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLocalCard.copyWith.fieldName(...)`
class _$LocalCardCWProxyImpl implements _$LocalCardCWProxy {
  const _$LocalCardCWProxyImpl(this._value);

  final LocalCard _value;

  @override
  LocalCard asset(String asset) => this(asset: asset);

  @override
  LocalCard worth(int worth) => this(worth: worth);

  @override
  LocalCard worthOver(int worthOver) => this(worthOver: worthOver);

  @override
  LocalCard alt(String alt) => this(alt: alt);

  @override
  LocalCard showZoom(bool showZoom) => this(showZoom: showZoom);

  @override
  LocalCard valid(bool valid) => this(valid: valid);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LocalCard(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LocalCard(...).copyWith(id: 12, name: "My name")
  /// ````
  LocalCard call({
    Object? asset = const $CopyWithPlaceholder(),
    Object? worth = const $CopyWithPlaceholder(),
    Object? worthOver = const $CopyWithPlaceholder(),
    Object? alt = const $CopyWithPlaceholder(),
    Object? showZoom = const $CopyWithPlaceholder(),
    Object? valid = const $CopyWithPlaceholder(),
  }) {
    return LocalCard(
      asset: asset == const $CopyWithPlaceholder() || asset == null
          // ignore: unnecessary_non_null_assertion
          ? _value.asset!
          // ignore: cast_nullable_to_non_nullable
          : asset as String,
      worth: worth == const $CopyWithPlaceholder() || worth == null
          // ignore: unnecessary_non_null_assertion
          ? _value.worth!
          // ignore: cast_nullable_to_non_nullable
          : worth as int,
      worthOver: worthOver == const $CopyWithPlaceholder() || worthOver == null
          // ignore: unnecessary_non_null_assertion
          ? _value.worthOver!
          // ignore: cast_nullable_to_non_nullable
          : worthOver as int,
      alt: alt == const $CopyWithPlaceholder() || alt == null
          // ignore: unnecessary_non_null_assertion
          ? _value.alt!
          // ignore: cast_nullable_to_non_nullable
          : alt as String,
      showZoom: showZoom == const $CopyWithPlaceholder() || showZoom == null
          // ignore: unnecessary_non_null_assertion
          ? _value.showZoom!
          // ignore: cast_nullable_to_non_nullable
          : showZoom as bool,
      valid: valid == const $CopyWithPlaceholder() || valid == null
          // ignore: unnecessary_non_null_assertion
          ? _value.valid!
          // ignore: cast_nullable_to_non_nullable
          : valid as bool,
    );
  }
}

extension $LocalCardCopyWith on LocalCard {
  /// Returns a callable class that can be used as follows: `instanceOfLocalCard.copyWith(...)` or like so:`instanceOfLocalCard.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LocalCardCWProxy get copyWith => _$LocalCardCWProxyImpl(this);
}

abstract class _$UserCWProxy {
  User id(String id);

  User name(String name);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `User(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// User(...).copyWith(id: 12, name: "My name")
  /// ````
  User call({
    String? id,
    String? name,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUser.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUser.copyWith.fieldName(...)`
class _$UserCWProxyImpl implements _$UserCWProxy {
  const _$UserCWProxyImpl(this._value);

  final User _value;

  @override
  User id(String id) => this(id: id);

  @override
  User name(String name) => this(name: name);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `User(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// User(...).copyWith(id: 12, name: "My name")
  /// ````
  User call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return User(
      id: id == const $CopyWithPlaceholder() || id == null
          // ignore: unnecessary_non_null_assertion
          ? _value.id!
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      name: name == const $CopyWithPlaceholder() || name == null
          // ignore: unnecessary_non_null_assertion
          ? _value.name!
          // ignore: cast_nullable_to_non_nullable
          : name as String,
    );
  }
}

extension $UserCopyWith on User {
  /// Returns a callable class that can be used as follows: `instanceOfUser.copyWith(...)` or like so:`instanceOfUser.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserCWProxy get copyWith => _$UserCWProxyImpl(this);
}

abstract class _$LocalGameCWProxy {
  LocalGame id(int id);

  LocalGame name(String name);

  LocalGame playsThree(bool playsThree);

  LocalGame worth(int worth);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LocalGame(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LocalGame(...).copyWith(id: 12, name: "My name")
  /// ````
  LocalGame call({
    int? id,
    String? name,
    bool? playsThree,
    int? worth,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLocalGame.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLocalGame.copyWith.fieldName(...)`
class _$LocalGameCWProxyImpl implements _$LocalGameCWProxy {
  const _$LocalGameCWProxyImpl(this._value);

  final LocalGame _value;

  @override
  LocalGame id(int id) => this(id: id);

  @override
  LocalGame name(String name) => this(name: name);

  @override
  LocalGame playsThree(bool playsThree) => this(playsThree: playsThree);

  @override
  LocalGame worth(int worth) => this(worth: worth);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LocalGame(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LocalGame(...).copyWith(id: 12, name: "My name")
  /// ````
  LocalGame call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? playsThree = const $CopyWithPlaceholder(),
    Object? worth = const $CopyWithPlaceholder(),
  }) {
    return LocalGame(
      id: id == const $CopyWithPlaceholder() || id == null
          // ignore: unnecessary_non_null_assertion
          ? _value.id!
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      name: name == const $CopyWithPlaceholder() || name == null
          // ignore: unnecessary_non_null_assertion
          ? _value.name!
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      playsThree:
          playsThree == const $CopyWithPlaceholder() || playsThree == null
              // ignore: unnecessary_non_null_assertion
              ? _value.playsThree!
              // ignore: cast_nullable_to_non_nullable
              : playsThree as bool,
      worth: worth == const $CopyWithPlaceholder() || worth == null
          // ignore: unnecessary_non_null_assertion
          ? _value.worth!
          // ignore: cast_nullable_to_non_nullable
          : worth as int,
    );
  }
}

extension $LocalGameCopyWith on LocalGame {
  /// Returns a callable class that can be used as follows: `instanceOfLocalGame.copyWith(...)` or like so:`instanceOfLocalGame.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LocalGameCWProxy get copyWith => _$LocalGameCWProxyImpl(this);
}
