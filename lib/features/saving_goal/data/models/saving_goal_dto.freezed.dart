// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saving_goal_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SavingGoalDto {

 String? get name; int? get id; int? get userId; double? get target;@JsonKey(name: 'saved_amount') double? get savedAmount;@JsonKey(name: 'start_date') DateTime? get startDate;@JsonKey(name: 'end_date') DateTime? get endDate; List<int>? get categoryIds;
/// Create a copy of SavingGoalDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavingGoalDtoCopyWith<SavingGoalDto> get copyWith => _$SavingGoalDtoCopyWithImpl<SavingGoalDto>(this as SavingGoalDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavingGoalDto&&(identical(other.name, name) || other.name == name)&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.target, target) || other.target == target)&&(identical(other.savedAmount, savedAmount) || other.savedAmount == savedAmount)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&const DeepCollectionEquality().equals(other.categoryIds, categoryIds));
}


@override
int get hashCode => Object.hash(runtimeType,name,id,userId,target,savedAmount,startDate,endDate,const DeepCollectionEquality().hash(categoryIds));

@override
String toString() {
  return 'SavingGoalDto(name: $name, id: $id, userId: $userId, target: $target, savedAmount: $savedAmount, startDate: $startDate, endDate: $endDate, categoryIds: $categoryIds)';
}


}

/// @nodoc
abstract mixin class $SavingGoalDtoCopyWith<$Res>  {
  factory $SavingGoalDtoCopyWith(SavingGoalDto value, $Res Function(SavingGoalDto) _then) = _$SavingGoalDtoCopyWithImpl;
@useResult
$Res call({
 String? name, int? id, int? userId, double? target,@JsonKey(name: 'saved_amount') double? savedAmount,@JsonKey(name: 'start_date') DateTime? startDate,@JsonKey(name: 'end_date') DateTime? endDate, List<int>? categoryIds
});




}
/// @nodoc
class _$SavingGoalDtoCopyWithImpl<$Res>
    implements $SavingGoalDtoCopyWith<$Res> {
  _$SavingGoalDtoCopyWithImpl(this._self, this._then);

  final SavingGoalDto _self;
  final $Res Function(SavingGoalDto) _then;

/// Create a copy of SavingGoalDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? id = freezed,Object? userId = freezed,Object? target = freezed,Object? savedAmount = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? categoryIds = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,target: freezed == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as double?,savedAmount: freezed == savedAmount ? _self.savedAmount : savedAmount // ignore: cast_nullable_to_non_nullable
as double?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,categoryIds: freezed == categoryIds ? _self.categoryIds : categoryIds // ignore: cast_nullable_to_non_nullable
as List<int>?,
  ));
}

}


/// Adds pattern-matching-related methods to [SavingGoalDto].
extension SavingGoalDtoPatterns on SavingGoalDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavingGoalDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavingGoalDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavingGoalDto value)  $default,){
final _that = this;
switch (_that) {
case _SavingGoalDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavingGoalDto value)?  $default,){
final _that = this;
switch (_that) {
case _SavingGoalDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  int? id,  int? userId,  double? target, @JsonKey(name: 'saved_amount')  double? savedAmount, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate,  List<int>? categoryIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavingGoalDto() when $default != null:
return $default(_that.name,_that.id,_that.userId,_that.target,_that.savedAmount,_that.startDate,_that.endDate,_that.categoryIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  int? id,  int? userId,  double? target, @JsonKey(name: 'saved_amount')  double? savedAmount, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate,  List<int>? categoryIds)  $default,) {final _that = this;
switch (_that) {
case _SavingGoalDto():
return $default(_that.name,_that.id,_that.userId,_that.target,_that.savedAmount,_that.startDate,_that.endDate,_that.categoryIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  int? id,  int? userId,  double? target, @JsonKey(name: 'saved_amount')  double? savedAmount, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate,  List<int>? categoryIds)?  $default,) {final _that = this;
switch (_that) {
case _SavingGoalDto() when $default != null:
return $default(_that.name,_that.id,_that.userId,_that.target,_that.savedAmount,_that.startDate,_that.endDate,_that.categoryIds);case _:
  return null;

}
}

}

/// @nodoc


class _SavingGoalDto extends SavingGoalDto {
  const _SavingGoalDto({this.name, this.id, this.userId, this.target, @JsonKey(name: 'saved_amount') this.savedAmount, @JsonKey(name: 'start_date') this.startDate, @JsonKey(name: 'end_date') this.endDate, final  List<int>? categoryIds}): _categoryIds = categoryIds,super._();
  

@override final  String? name;
@override final  int? id;
@override final  int? userId;
@override final  double? target;
@override@JsonKey(name: 'saved_amount') final  double? savedAmount;
@override@JsonKey(name: 'start_date') final  DateTime? startDate;
@override@JsonKey(name: 'end_date') final  DateTime? endDate;
 final  List<int>? _categoryIds;
@override List<int>? get categoryIds {
  final value = _categoryIds;
  if (value == null) return null;
  if (_categoryIds is EqualUnmodifiableListView) return _categoryIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of SavingGoalDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavingGoalDtoCopyWith<_SavingGoalDto> get copyWith => __$SavingGoalDtoCopyWithImpl<_SavingGoalDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavingGoalDto&&(identical(other.name, name) || other.name == name)&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.target, target) || other.target == target)&&(identical(other.savedAmount, savedAmount) || other.savedAmount == savedAmount)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&const DeepCollectionEquality().equals(other._categoryIds, _categoryIds));
}


@override
int get hashCode => Object.hash(runtimeType,name,id,userId,target,savedAmount,startDate,endDate,const DeepCollectionEquality().hash(_categoryIds));

@override
String toString() {
  return 'SavingGoalDto(name: $name, id: $id, userId: $userId, target: $target, savedAmount: $savedAmount, startDate: $startDate, endDate: $endDate, categoryIds: $categoryIds)';
}


}

/// @nodoc
abstract mixin class _$SavingGoalDtoCopyWith<$Res> implements $SavingGoalDtoCopyWith<$Res> {
  factory _$SavingGoalDtoCopyWith(_SavingGoalDto value, $Res Function(_SavingGoalDto) _then) = __$SavingGoalDtoCopyWithImpl;
@override @useResult
$Res call({
 String? name, int? id, int? userId, double? target,@JsonKey(name: 'saved_amount') double? savedAmount,@JsonKey(name: 'start_date') DateTime? startDate,@JsonKey(name: 'end_date') DateTime? endDate, List<int>? categoryIds
});




}
/// @nodoc
class __$SavingGoalDtoCopyWithImpl<$Res>
    implements _$SavingGoalDtoCopyWith<$Res> {
  __$SavingGoalDtoCopyWithImpl(this._self, this._then);

  final _SavingGoalDto _self;
  final $Res Function(_SavingGoalDto) _then;

/// Create a copy of SavingGoalDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? id = freezed,Object? userId = freezed,Object? target = freezed,Object? savedAmount = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? categoryIds = freezed,}) {
  return _then(_SavingGoalDto(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,target: freezed == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as double?,savedAmount: freezed == savedAmount ? _self.savedAmount : savedAmount // ignore: cast_nullable_to_non_nullable
as double?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,categoryIds: freezed == categoryIds ? _self._categoryIds : categoryIds // ignore: cast_nullable_to_non_nullable
as List<int>?,
  ));
}


}

// dart format on
