// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'finance_mode_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FinanceModeModel {

 int get userId;@JsonKey(toJson: _modeToJson) String get mode; DateTime get updatedAt; DateTime? get suggestionCooldownUntil;
/// Create a copy of FinanceModeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinanceModeModelCopyWith<FinanceModeModel> get copyWith => _$FinanceModeModelCopyWithImpl<FinanceModeModel>(this as FinanceModeModel, _$identity);

  /// Serializes this FinanceModeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinanceModeModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.suggestionCooldownUntil, suggestionCooldownUntil) || other.suggestionCooldownUntil == suggestionCooldownUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,mode,updatedAt,suggestionCooldownUntil);

@override
String toString() {
  return 'FinanceModeModel(userId: $userId, mode: $mode, updatedAt: $updatedAt, suggestionCooldownUntil: $suggestionCooldownUntil)';
}


}

/// @nodoc
abstract mixin class $FinanceModeModelCopyWith<$Res>  {
  factory $FinanceModeModelCopyWith(FinanceModeModel value, $Res Function(FinanceModeModel) _then) = _$FinanceModeModelCopyWithImpl;
@useResult
$Res call({
 int userId,@JsonKey(toJson: _modeToJson) String mode, DateTime updatedAt, DateTime? suggestionCooldownUntil
});




}
/// @nodoc
class _$FinanceModeModelCopyWithImpl<$Res>
    implements $FinanceModeModelCopyWith<$Res> {
  _$FinanceModeModelCopyWithImpl(this._self, this._then);

  final FinanceModeModel _self;
  final $Res Function(FinanceModeModel) _then;

/// Create a copy of FinanceModeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? mode = null,Object? updatedAt = null,Object? suggestionCooldownUntil = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,suggestionCooldownUntil: freezed == suggestionCooldownUntil ? _self.suggestionCooldownUntil : suggestionCooldownUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FinanceModeModel].
extension FinanceModeModelPatterns on FinanceModeModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinanceModeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinanceModeModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinanceModeModel value)  $default,){
final _that = this;
switch (_that) {
case _FinanceModeModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinanceModeModel value)?  $default,){
final _that = this;
switch (_that) {
case _FinanceModeModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int userId, @JsonKey(toJson: _modeToJson)  String mode,  DateTime updatedAt,  DateTime? suggestionCooldownUntil)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinanceModeModel() when $default != null:
return $default(_that.userId,_that.mode,_that.updatedAt,_that.suggestionCooldownUntil);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int userId, @JsonKey(toJson: _modeToJson)  String mode,  DateTime updatedAt,  DateTime? suggestionCooldownUntil)  $default,) {final _that = this;
switch (_that) {
case _FinanceModeModel():
return $default(_that.userId,_that.mode,_that.updatedAt,_that.suggestionCooldownUntil);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int userId, @JsonKey(toJson: _modeToJson)  String mode,  DateTime updatedAt,  DateTime? suggestionCooldownUntil)?  $default,) {final _that = this;
switch (_that) {
case _FinanceModeModel() when $default != null:
return $default(_that.userId,_that.mode,_that.updatedAt,_that.suggestionCooldownUntil);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinanceModeModel extends FinanceModeModel {
  const _FinanceModeModel({required this.userId, @JsonKey(toJson: _modeToJson) required this.mode, required this.updatedAt, this.suggestionCooldownUntil}): super._();
  factory _FinanceModeModel.fromJson(Map<String, dynamic> json) => _$FinanceModeModelFromJson(json);

@override final  int userId;
@override@JsonKey(toJson: _modeToJson) final  String mode;
@override final  DateTime updatedAt;
@override final  DateTime? suggestionCooldownUntil;

/// Create a copy of FinanceModeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinanceModeModelCopyWith<_FinanceModeModel> get copyWith => __$FinanceModeModelCopyWithImpl<_FinanceModeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinanceModeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinanceModeModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.suggestionCooldownUntil, suggestionCooldownUntil) || other.suggestionCooldownUntil == suggestionCooldownUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,mode,updatedAt,suggestionCooldownUntil);

@override
String toString() {
  return 'FinanceModeModel(userId: $userId, mode: $mode, updatedAt: $updatedAt, suggestionCooldownUntil: $suggestionCooldownUntil)';
}


}

/// @nodoc
abstract mixin class _$FinanceModeModelCopyWith<$Res> implements $FinanceModeModelCopyWith<$Res> {
  factory _$FinanceModeModelCopyWith(_FinanceModeModel value, $Res Function(_FinanceModeModel) _then) = __$FinanceModeModelCopyWithImpl;
@override @useResult
$Res call({
 int userId,@JsonKey(toJson: _modeToJson) String mode, DateTime updatedAt, DateTime? suggestionCooldownUntil
});




}
/// @nodoc
class __$FinanceModeModelCopyWithImpl<$Res>
    implements _$FinanceModeModelCopyWith<$Res> {
  __$FinanceModeModelCopyWithImpl(this._self, this._then);

  final _FinanceModeModel _self;
  final $Res Function(_FinanceModeModel) _then;

/// Create a copy of FinanceModeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? mode = null,Object? updatedAt = null,Object? suggestionCooldownUntil = freezed,}) {
  return _then(_FinanceModeModel(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,suggestionCooldownUntil: freezed == suggestionCooldownUntil ? _self.suggestionCooldownUntil : suggestionCooldownUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
