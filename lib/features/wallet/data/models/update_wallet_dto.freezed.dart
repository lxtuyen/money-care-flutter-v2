// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_wallet_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UpdateWalletDto {

 String? get name;@JsonKey(name: 'is_active') bool? get isActive;
/// Create a copy of UpdateWalletDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateWalletDtoCopyWith<UpdateWalletDto> get copyWith => _$UpdateWalletDtoCopyWithImpl<UpdateWalletDto>(this as UpdateWalletDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateWalletDto&&(identical(other.name, name) || other.name == name)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,name,isActive);

@override
String toString() {
  return 'UpdateWalletDto(name: $name, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $UpdateWalletDtoCopyWith<$Res>  {
  factory $UpdateWalletDtoCopyWith(UpdateWalletDto value, $Res Function(UpdateWalletDto) _then) = _$UpdateWalletDtoCopyWithImpl;
@useResult
$Res call({
 String? name,@JsonKey(name: 'is_active') bool? isActive
});




}
/// @nodoc
class _$UpdateWalletDtoCopyWithImpl<$Res>
    implements $UpdateWalletDtoCopyWith<$Res> {
  _$UpdateWalletDtoCopyWithImpl(this._self, this._then);

  final UpdateWalletDto _self;
  final $Res Function(UpdateWalletDto) _then;

/// Create a copy of UpdateWalletDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? isActive = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateWalletDto].
extension UpdateWalletDtoPatterns on UpdateWalletDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateWalletDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateWalletDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateWalletDto value)  $default,){
final _that = this;
switch (_that) {
case _UpdateWalletDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateWalletDto value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateWalletDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name, @JsonKey(name: 'is_active')  bool? isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateWalletDto() when $default != null:
return $default(_that.name,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name, @JsonKey(name: 'is_active')  bool? isActive)  $default,) {final _that = this;
switch (_that) {
case _UpdateWalletDto():
return $default(_that.name,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name, @JsonKey(name: 'is_active')  bool? isActive)?  $default,) {final _that = this;
switch (_that) {
case _UpdateWalletDto() when $default != null:
return $default(_that.name,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc


class _UpdateWalletDto extends UpdateWalletDto {
  const _UpdateWalletDto({this.name, @JsonKey(name: 'is_active') this.isActive}): super._();
  

@override final  String? name;
@override@JsonKey(name: 'is_active') final  bool? isActive;

/// Create a copy of UpdateWalletDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateWalletDtoCopyWith<_UpdateWalletDto> get copyWith => __$UpdateWalletDtoCopyWithImpl<_UpdateWalletDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateWalletDto&&(identical(other.name, name) || other.name == name)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,name,isActive);

@override
String toString() {
  return 'UpdateWalletDto(name: $name, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$UpdateWalletDtoCopyWith<$Res> implements $UpdateWalletDtoCopyWith<$Res> {
  factory _$UpdateWalletDtoCopyWith(_UpdateWalletDto value, $Res Function(_UpdateWalletDto) _then) = __$UpdateWalletDtoCopyWithImpl;
@override @useResult
$Res call({
 String? name,@JsonKey(name: 'is_active') bool? isActive
});




}
/// @nodoc
class __$UpdateWalletDtoCopyWithImpl<$Res>
    implements _$UpdateWalletDtoCopyWith<$Res> {
  __$UpdateWalletDtoCopyWithImpl(this._self, this._then);

  final _UpdateWalletDto _self;
  final $Res Function(_UpdateWalletDto) _then;

/// Create a copy of UpdateWalletDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? isActive = freezed,}) {
  return _then(_UpdateWalletDto(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
