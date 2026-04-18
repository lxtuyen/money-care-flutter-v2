// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_totals_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionTotalsDto {

@JsonKey(name: 'savingGoalId') int? get goalId;@JsonKey(name: 'start_date') String? get startDate;@JsonKey(name: 'end_date') String? get endDate; String? get type;
/// Create a copy of TransactionTotalsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionTotalsDtoCopyWith<TransactionTotalsDto> get copyWith => _$TransactionTotalsDtoCopyWithImpl<TransactionTotalsDto>(this as TransactionTotalsDto, _$identity);

  /// Serializes this TransactionTotalsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionTotalsDto&&(identical(other.goalId, goalId) || other.goalId == goalId)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,goalId,startDate,endDate,type);

@override
String toString() {
  return 'TransactionTotalsDto(goalId: $goalId, startDate: $startDate, endDate: $endDate, type: $type)';
}


}

/// @nodoc
abstract mixin class $TransactionTotalsDtoCopyWith<$Res>  {
  factory $TransactionTotalsDtoCopyWith(TransactionTotalsDto value, $Res Function(TransactionTotalsDto) _then) = _$TransactionTotalsDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'savingGoalId') int? goalId,@JsonKey(name: 'start_date') String? startDate,@JsonKey(name: 'end_date') String? endDate, String? type
});




}
/// @nodoc
class _$TransactionTotalsDtoCopyWithImpl<$Res>
    implements $TransactionTotalsDtoCopyWith<$Res> {
  _$TransactionTotalsDtoCopyWithImpl(this._self, this._then);

  final TransactionTotalsDto _self;
  final $Res Function(TransactionTotalsDto) _then;

/// Create a copy of TransactionTotalsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? goalId = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? type = freezed,}) {
  return _then(_self.copyWith(
goalId: freezed == goalId ? _self.goalId : goalId // ignore: cast_nullable_to_non_nullable
as int?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionTotalsDto].
extension TransactionTotalsDtoPatterns on TransactionTotalsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionTotalsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionTotalsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionTotalsDto value)  $default,){
final _that = this;
switch (_that) {
case _TransactionTotalsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionTotalsDto value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionTotalsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'savingGoalId')  int? goalId, @JsonKey(name: 'start_date')  String? startDate, @JsonKey(name: 'end_date')  String? endDate,  String? type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionTotalsDto() when $default != null:
return $default(_that.goalId,_that.startDate,_that.endDate,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'savingGoalId')  int? goalId, @JsonKey(name: 'start_date')  String? startDate, @JsonKey(name: 'end_date')  String? endDate,  String? type)  $default,) {final _that = this;
switch (_that) {
case _TransactionTotalsDto():
return $default(_that.goalId,_that.startDate,_that.endDate,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'savingGoalId')  int? goalId, @JsonKey(name: 'start_date')  String? startDate, @JsonKey(name: 'end_date')  String? endDate,  String? type)?  $default,) {final _that = this;
switch (_that) {
case _TransactionTotalsDto() when $default != null:
return $default(_that.goalId,_that.startDate,_that.endDate,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionTotalsDto implements TransactionTotalsDto {
  const _TransactionTotalsDto({@JsonKey(name: 'savingGoalId') this.goalId, @JsonKey(name: 'start_date') this.startDate, @JsonKey(name: 'end_date') this.endDate, this.type});
  factory _TransactionTotalsDto.fromJson(Map<String, dynamic> json) => _$TransactionTotalsDtoFromJson(json);

@override@JsonKey(name: 'savingGoalId') final  int? goalId;
@override@JsonKey(name: 'start_date') final  String? startDate;
@override@JsonKey(name: 'end_date') final  String? endDate;
@override final  String? type;

/// Create a copy of TransactionTotalsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionTotalsDtoCopyWith<_TransactionTotalsDto> get copyWith => __$TransactionTotalsDtoCopyWithImpl<_TransactionTotalsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionTotalsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionTotalsDto&&(identical(other.goalId, goalId) || other.goalId == goalId)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,goalId,startDate,endDate,type);

@override
String toString() {
  return 'TransactionTotalsDto(goalId: $goalId, startDate: $startDate, endDate: $endDate, type: $type)';
}


}

/// @nodoc
abstract mixin class _$TransactionTotalsDtoCopyWith<$Res> implements $TransactionTotalsDtoCopyWith<$Res> {
  factory _$TransactionTotalsDtoCopyWith(_TransactionTotalsDto value, $Res Function(_TransactionTotalsDto) _then) = __$TransactionTotalsDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'savingGoalId') int? goalId,@JsonKey(name: 'start_date') String? startDate,@JsonKey(name: 'end_date') String? endDate, String? type
});




}
/// @nodoc
class __$TransactionTotalsDtoCopyWithImpl<$Res>
    implements _$TransactionTotalsDtoCopyWith<$Res> {
  __$TransactionTotalsDtoCopyWithImpl(this._self, this._then);

  final _TransactionTotalsDto _self;
  final $Res Function(_TransactionTotalsDto) _then;

/// Create a copy of TransactionTotalsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? goalId = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? type = freezed,}) {
  return _then(_TransactionTotalsDto(
goalId: freezed == goalId ? _self.goalId : goalId // ignore: cast_nullable_to_non_nullable
as int?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
