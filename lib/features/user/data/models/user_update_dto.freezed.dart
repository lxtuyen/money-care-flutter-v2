// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_update_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserUpdateDto {

 String? get role; bool? get isVip;
/// Create a copy of UserUpdateDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserUpdateDtoCopyWith<UserUpdateDto> get copyWith => _$UserUpdateDtoCopyWithImpl<UserUpdateDto>(this as UserUpdateDto, _$identity);

  /// Serializes this UserUpdateDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserUpdateDto&&(identical(other.role, role) || other.role == role)&&(identical(other.isVip, isVip) || other.isVip == isVip));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,isVip);

@override
String toString() {
  return 'UserUpdateDto(role: $role, isVip: $isVip)';
}


}

/// @nodoc
abstract mixin class $UserUpdateDtoCopyWith<$Res>  {
  factory $UserUpdateDtoCopyWith(UserUpdateDto value, $Res Function(UserUpdateDto) _then) = _$UserUpdateDtoCopyWithImpl;
@useResult
$Res call({
 String? role, bool? isVip
});




}
/// @nodoc
class _$UserUpdateDtoCopyWithImpl<$Res>
    implements $UserUpdateDtoCopyWith<$Res> {
  _$UserUpdateDtoCopyWithImpl(this._self, this._then);

  final UserUpdateDto _self;
  final $Res Function(UserUpdateDto) _then;

/// Create a copy of UserUpdateDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = freezed,Object? isVip = freezed,}) {
  return _then(_self.copyWith(
role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,isVip: freezed == isVip ? _self.isVip : isVip // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserUpdateDto].
extension UserUpdateDtoPatterns on UserUpdateDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserUpdateDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserUpdateDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserUpdateDto value)  $default,){
final _that = this;
switch (_that) {
case _UserUpdateDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserUpdateDto value)?  $default,){
final _that = this;
switch (_that) {
case _UserUpdateDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? role,  bool? isVip)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserUpdateDto() when $default != null:
return $default(_that.role,_that.isVip);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? role,  bool? isVip)  $default,) {final _that = this;
switch (_that) {
case _UserUpdateDto():
return $default(_that.role,_that.isVip);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? role,  bool? isVip)?  $default,) {final _that = this;
switch (_that) {
case _UserUpdateDto() when $default != null:
return $default(_that.role,_that.isVip);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserUpdateDto implements UserUpdateDto {
  const _UserUpdateDto({this.role, this.isVip});
  factory _UserUpdateDto.fromJson(Map<String, dynamic> json) => _$UserUpdateDtoFromJson(json);

@override final  String? role;
@override final  bool? isVip;

/// Create a copy of UserUpdateDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserUpdateDtoCopyWith<_UserUpdateDto> get copyWith => __$UserUpdateDtoCopyWithImpl<_UserUpdateDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserUpdateDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserUpdateDto&&(identical(other.role, role) || other.role == role)&&(identical(other.isVip, isVip) || other.isVip == isVip));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,isVip);

@override
String toString() {
  return 'UserUpdateDto(role: $role, isVip: $isVip)';
}


}

/// @nodoc
abstract mixin class _$UserUpdateDtoCopyWith<$Res> implements $UserUpdateDtoCopyWith<$Res> {
  factory _$UserUpdateDtoCopyWith(_UserUpdateDto value, $Res Function(_UserUpdateDto) _then) = __$UserUpdateDtoCopyWithImpl;
@override @useResult
$Res call({
 String? role, bool? isVip
});




}
/// @nodoc
class __$UserUpdateDtoCopyWithImpl<$Res>
    implements _$UserUpdateDtoCopyWith<$Res> {
  __$UserUpdateDtoCopyWithImpl(this._self, this._then);

  final _UserUpdateDto _self;
  final $Res Function(_UserUpdateDto) _then;

/// Create a copy of UserUpdateDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = freezed,Object? isVip = freezed,}) {
  return _then(_UserUpdateDto(
role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,isVip: freezed == isVip ? _self.isVip : isVip // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
