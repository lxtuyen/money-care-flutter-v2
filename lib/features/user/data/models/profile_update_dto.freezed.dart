// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_update_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileUpdateDto {

@JsonKey(name: 'first_name') String? get firstName;@JsonKey(name: 'last_name') String? get lastName;@JsonKey(name: 'monthlyIncome') int? get monthlyIncome;@JsonKey(name: 'incomeDate') DateTime? get incomeDate;@JsonKey(name: 'avatar') String? get avatar;
/// Create a copy of ProfileUpdateDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileUpdateDtoCopyWith<ProfileUpdateDto> get copyWith => _$ProfileUpdateDtoCopyWithImpl<ProfileUpdateDto>(this as ProfileUpdateDto, _$identity);

  /// Serializes this ProfileUpdateDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileUpdateDto&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.monthlyIncome, monthlyIncome) || other.monthlyIncome == monthlyIncome)&&(identical(other.incomeDate, incomeDate) || other.incomeDate == incomeDate)&&(identical(other.avatar, avatar) || other.avatar == avatar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,monthlyIncome,incomeDate,avatar);

@override
String toString() {
  return 'ProfileUpdateDto(firstName: $firstName, lastName: $lastName, monthlyIncome: $monthlyIncome, incomeDate: $incomeDate, avatar: $avatar)';
}


}

/// @nodoc
abstract mixin class $ProfileUpdateDtoCopyWith<$Res>  {
  factory $ProfileUpdateDtoCopyWith(ProfileUpdateDto value, $Res Function(ProfileUpdateDto) _then) = _$ProfileUpdateDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'first_name') String? firstName,@JsonKey(name: 'last_name') String? lastName,@JsonKey(name: 'monthlyIncome') int? monthlyIncome,@JsonKey(name: 'incomeDate') DateTime? incomeDate,@JsonKey(name: 'avatar') String? avatar
});




}
/// @nodoc
class _$ProfileUpdateDtoCopyWithImpl<$Res>
    implements $ProfileUpdateDtoCopyWith<$Res> {
  _$ProfileUpdateDtoCopyWithImpl(this._self, this._then);

  final ProfileUpdateDto _self;
  final $Res Function(ProfileUpdateDto) _then;

/// Create a copy of ProfileUpdateDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? firstName = freezed,Object? lastName = freezed,Object? monthlyIncome = freezed,Object? incomeDate = freezed,Object? avatar = freezed,}) {
  return _then(_self.copyWith(
firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,monthlyIncome: freezed == monthlyIncome ? _self.monthlyIncome : monthlyIncome // ignore: cast_nullable_to_non_nullable
as int?,incomeDate: freezed == incomeDate ? _self.incomeDate : incomeDate // ignore: cast_nullable_to_non_nullable
as DateTime?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileUpdateDto].
extension ProfileUpdateDtoPatterns on ProfileUpdateDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileUpdateDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileUpdateDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileUpdateDto value)  $default,){
final _that = this;
switch (_that) {
case _ProfileUpdateDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileUpdateDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileUpdateDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName, @JsonKey(name: 'monthlyIncome')  int? monthlyIncome, @JsonKey(name: 'incomeDate')  DateTime? incomeDate, @JsonKey(name: 'avatar')  String? avatar)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileUpdateDto() when $default != null:
return $default(_that.firstName,_that.lastName,_that.monthlyIncome,_that.incomeDate,_that.avatar);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName, @JsonKey(name: 'monthlyIncome')  int? monthlyIncome, @JsonKey(name: 'incomeDate')  DateTime? incomeDate, @JsonKey(name: 'avatar')  String? avatar)  $default,) {final _that = this;
switch (_that) {
case _ProfileUpdateDto():
return $default(_that.firstName,_that.lastName,_that.monthlyIncome,_that.incomeDate,_that.avatar);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName, @JsonKey(name: 'monthlyIncome')  int? monthlyIncome, @JsonKey(name: 'incomeDate')  DateTime? incomeDate, @JsonKey(name: 'avatar')  String? avatar)?  $default,) {final _that = this;
switch (_that) {
case _ProfileUpdateDto() when $default != null:
return $default(_that.firstName,_that.lastName,_that.monthlyIncome,_that.incomeDate,_that.avatar);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileUpdateDto implements ProfileUpdateDto {
  const _ProfileUpdateDto({@JsonKey(name: 'first_name') this.firstName, @JsonKey(name: 'last_name') this.lastName, @JsonKey(name: 'monthlyIncome') this.monthlyIncome, @JsonKey(name: 'incomeDate') this.incomeDate, @JsonKey(name: 'avatar') this.avatar});
  factory _ProfileUpdateDto.fromJson(Map<String, dynamic> json) => _$ProfileUpdateDtoFromJson(json);

@override@JsonKey(name: 'first_name') final  String? firstName;
@override@JsonKey(name: 'last_name') final  String? lastName;
@override@JsonKey(name: 'monthlyIncome') final  int? monthlyIncome;
@override@JsonKey(name: 'incomeDate') final  DateTime? incomeDate;
@override@JsonKey(name: 'avatar') final  String? avatar;

/// Create a copy of ProfileUpdateDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileUpdateDtoCopyWith<_ProfileUpdateDto> get copyWith => __$ProfileUpdateDtoCopyWithImpl<_ProfileUpdateDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileUpdateDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileUpdateDto&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.monthlyIncome, monthlyIncome) || other.monthlyIncome == monthlyIncome)&&(identical(other.incomeDate, incomeDate) || other.incomeDate == incomeDate)&&(identical(other.avatar, avatar) || other.avatar == avatar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,monthlyIncome,incomeDate,avatar);

@override
String toString() {
  return 'ProfileUpdateDto(firstName: $firstName, lastName: $lastName, monthlyIncome: $monthlyIncome, incomeDate: $incomeDate, avatar: $avatar)';
}


}

/// @nodoc
abstract mixin class _$ProfileUpdateDtoCopyWith<$Res> implements $ProfileUpdateDtoCopyWith<$Res> {
  factory _$ProfileUpdateDtoCopyWith(_ProfileUpdateDto value, $Res Function(_ProfileUpdateDto) _then) = __$ProfileUpdateDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'first_name') String? firstName,@JsonKey(name: 'last_name') String? lastName,@JsonKey(name: 'monthlyIncome') int? monthlyIncome,@JsonKey(name: 'incomeDate') DateTime? incomeDate,@JsonKey(name: 'avatar') String? avatar
});




}
/// @nodoc
class __$ProfileUpdateDtoCopyWithImpl<$Res>
    implements _$ProfileUpdateDtoCopyWith<$Res> {
  __$ProfileUpdateDtoCopyWithImpl(this._self, this._then);

  final _ProfileUpdateDto _self;
  final $Res Function(_ProfileUpdateDto) _then;

/// Create a copy of ProfileUpdateDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? firstName = freezed,Object? lastName = freezed,Object? monthlyIncome = freezed,Object? incomeDate = freezed,Object? avatar = freezed,}) {
  return _then(_ProfileUpdateDto(
firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,monthlyIncome: freezed == monthlyIncome ? _self.monthlyIncome : monthlyIncome // ignore: cast_nullable_to_non_nullable
as int?,incomeDate: freezed == incomeDate ? _self.incomeDate : incomeDate // ignore: cast_nullable_to_non_nullable
as DateTime?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
