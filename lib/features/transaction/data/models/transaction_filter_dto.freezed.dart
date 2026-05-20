// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_filter_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionFilterDto {

@JsonKey(name: 'categoryId') int? get categoryId;@JsonKey(name: 'walletId') int? get walletId;@JsonKey(name: 'startDate') String? get startDate;@JsonKey(name: 'endDate') String? get endDate;@JsonKey(name: 'limit') int? get limit;@JsonKey(name: 'includeTransfer') String? get includeTransfer;
/// Create a copy of TransactionFilterDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionFilterDtoCopyWith<TransactionFilterDto> get copyWith => _$TransactionFilterDtoCopyWithImpl<TransactionFilterDto>(this as TransactionFilterDto, _$identity);

  /// Serializes this TransactionFilterDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionFilterDto&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.includeTransfer, includeTransfer) || other.includeTransfer == includeTransfer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,walletId,startDate,endDate,limit,includeTransfer);

@override
String toString() {
  return 'TransactionFilterDto(categoryId: $categoryId, walletId: $walletId, startDate: $startDate, endDate: $endDate, limit: $limit, includeTransfer: $includeTransfer)';
}


}

/// @nodoc
abstract mixin class $TransactionFilterDtoCopyWith<$Res>  {
  factory $TransactionFilterDtoCopyWith(TransactionFilterDto value, $Res Function(TransactionFilterDto) _then) = _$TransactionFilterDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'categoryId') int? categoryId,@JsonKey(name: 'walletId') int? walletId,@JsonKey(name: 'startDate') String? startDate,@JsonKey(name: 'endDate') String? endDate,@JsonKey(name: 'limit') int? limit,@JsonKey(name: 'includeTransfer') String? includeTransfer
});




}
/// @nodoc
class _$TransactionFilterDtoCopyWithImpl<$Res>
    implements $TransactionFilterDtoCopyWith<$Res> {
  _$TransactionFilterDtoCopyWithImpl(this._self, this._then);

  final TransactionFilterDto _self;
  final $Res Function(TransactionFilterDto) _then;

/// Create a copy of TransactionFilterDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = freezed,Object? walletId = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? limit = freezed,Object? includeTransfer = freezed,}) {
  return _then(_self.copyWith(
categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,walletId: freezed == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as int?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,includeTransfer: freezed == includeTransfer ? _self.includeTransfer : includeTransfer // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionFilterDto].
extension TransactionFilterDtoPatterns on TransactionFilterDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionFilterDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionFilterDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionFilterDto value)  $default,){
final _that = this;
switch (_that) {
case _TransactionFilterDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionFilterDto value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionFilterDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'categoryId')  int? categoryId, @JsonKey(name: 'walletId')  int? walletId, @JsonKey(name: 'startDate')  String? startDate, @JsonKey(name: 'endDate')  String? endDate, @JsonKey(name: 'limit')  int? limit, @JsonKey(name: 'includeTransfer')  String? includeTransfer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionFilterDto() when $default != null:
return $default(_that.categoryId,_that.walletId,_that.startDate,_that.endDate,_that.limit,_that.includeTransfer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'categoryId')  int? categoryId, @JsonKey(name: 'walletId')  int? walletId, @JsonKey(name: 'startDate')  String? startDate, @JsonKey(name: 'endDate')  String? endDate, @JsonKey(name: 'limit')  int? limit, @JsonKey(name: 'includeTransfer')  String? includeTransfer)  $default,) {final _that = this;
switch (_that) {
case _TransactionFilterDto():
return $default(_that.categoryId,_that.walletId,_that.startDate,_that.endDate,_that.limit,_that.includeTransfer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'categoryId')  int? categoryId, @JsonKey(name: 'walletId')  int? walletId, @JsonKey(name: 'startDate')  String? startDate, @JsonKey(name: 'endDate')  String? endDate, @JsonKey(name: 'limit')  int? limit, @JsonKey(name: 'includeTransfer')  String? includeTransfer)?  $default,) {final _that = this;
switch (_that) {
case _TransactionFilterDto() when $default != null:
return $default(_that.categoryId,_that.walletId,_that.startDate,_that.endDate,_that.limit,_that.includeTransfer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionFilterDto extends TransactionFilterDto {
  const _TransactionFilterDto({@JsonKey(name: 'categoryId') this.categoryId, @JsonKey(name: 'walletId') this.walletId, @JsonKey(name: 'startDate') this.startDate, @JsonKey(name: 'endDate') this.endDate, @JsonKey(name: 'limit') this.limit, @JsonKey(name: 'includeTransfer') this.includeTransfer}): super._();
  factory _TransactionFilterDto.fromJson(Map<String, dynamic> json) => _$TransactionFilterDtoFromJson(json);

@override@JsonKey(name: 'categoryId') final  int? categoryId;
@override@JsonKey(name: 'walletId') final  int? walletId;
@override@JsonKey(name: 'startDate') final  String? startDate;
@override@JsonKey(name: 'endDate') final  String? endDate;
@override@JsonKey(name: 'limit') final  int? limit;
@override@JsonKey(name: 'includeTransfer') final  String? includeTransfer;

/// Create a copy of TransactionFilterDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionFilterDtoCopyWith<_TransactionFilterDto> get copyWith => __$TransactionFilterDtoCopyWithImpl<_TransactionFilterDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionFilterDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionFilterDto&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.includeTransfer, includeTransfer) || other.includeTransfer == includeTransfer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,walletId,startDate,endDate,limit,includeTransfer);

@override
String toString() {
  return 'TransactionFilterDto(categoryId: $categoryId, walletId: $walletId, startDate: $startDate, endDate: $endDate, limit: $limit, includeTransfer: $includeTransfer)';
}


}

/// @nodoc
abstract mixin class _$TransactionFilterDtoCopyWith<$Res> implements $TransactionFilterDtoCopyWith<$Res> {
  factory _$TransactionFilterDtoCopyWith(_TransactionFilterDto value, $Res Function(_TransactionFilterDto) _then) = __$TransactionFilterDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'categoryId') int? categoryId,@JsonKey(name: 'walletId') int? walletId,@JsonKey(name: 'startDate') String? startDate,@JsonKey(name: 'endDate') String? endDate,@JsonKey(name: 'limit') int? limit,@JsonKey(name: 'includeTransfer') String? includeTransfer
});




}
/// @nodoc
class __$TransactionFilterDtoCopyWithImpl<$Res>
    implements _$TransactionFilterDtoCopyWith<$Res> {
  __$TransactionFilterDtoCopyWithImpl(this._self, this._then);

  final _TransactionFilterDto _self;
  final $Res Function(_TransactionFilterDto) _then;

/// Create a copy of TransactionFilterDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = freezed,Object? walletId = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? limit = freezed,Object? includeTransfer = freezed,}) {
  return _then(_TransactionFilterDto(
categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,walletId: freezed == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as int?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,includeTransfer: freezed == includeTransfer ? _self.includeTransfer : includeTransfer // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
