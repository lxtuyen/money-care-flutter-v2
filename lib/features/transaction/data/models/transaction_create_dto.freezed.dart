// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_create_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionCreateDto {

 int? get amount; String? get type; String? get note;@JsonKey(name: 'pictuteURL') String? get pictureUrl; DateTime? get transactionDate; int? get categoryId; int? get userId;
/// Create a copy of TransactionCreateDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionCreateDtoCopyWith<TransactionCreateDto> get copyWith => _$TransactionCreateDtoCopyWithImpl<TransactionCreateDto>(this as TransactionCreateDto, _$identity);

  /// Serializes this TransactionCreateDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionCreateDto&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.type, type) || other.type == type)&&(identical(other.note, note) || other.note == note)&&(identical(other.pictureUrl, pictureUrl) || other.pictureUrl == pictureUrl)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,type,note,pictureUrl,transactionDate,categoryId,userId);

@override
String toString() {
  return 'TransactionCreateDto(amount: $amount, type: $type, note: $note, pictureUrl: $pictureUrl, transactionDate: $transactionDate, categoryId: $categoryId, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $TransactionCreateDtoCopyWith<$Res>  {
  factory $TransactionCreateDtoCopyWith(TransactionCreateDto value, $Res Function(TransactionCreateDto) _then) = _$TransactionCreateDtoCopyWithImpl;
@useResult
$Res call({
 int? amount, String? type, String? note,@JsonKey(name: 'pictuteURL') String? pictureUrl, DateTime? transactionDate, int? categoryId, int? userId
});




}
/// @nodoc
class _$TransactionCreateDtoCopyWithImpl<$Res>
    implements $TransactionCreateDtoCopyWith<$Res> {
  _$TransactionCreateDtoCopyWithImpl(this._self, this._then);

  final TransactionCreateDto _self;
  final $Res Function(TransactionCreateDto) _then;

/// Create a copy of TransactionCreateDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? amount = freezed,Object? type = freezed,Object? note = freezed,Object? pictureUrl = freezed,Object? transactionDate = freezed,Object? categoryId = freezed,Object? userId = freezed,}) {
  return _then(_self.copyWith(
amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,pictureUrl: freezed == pictureUrl ? _self.pictureUrl : pictureUrl // ignore: cast_nullable_to_non_nullable
as String?,transactionDate: freezed == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as DateTime?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionCreateDto].
extension TransactionCreateDtoPatterns on TransactionCreateDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionCreateDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionCreateDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionCreateDto value)  $default,){
final _that = this;
switch (_that) {
case _TransactionCreateDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionCreateDto value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionCreateDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? amount,  String? type,  String? note, @JsonKey(name: 'pictuteURL')  String? pictureUrl,  DateTime? transactionDate,  int? categoryId,  int? userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionCreateDto() when $default != null:
return $default(_that.amount,_that.type,_that.note,_that.pictureUrl,_that.transactionDate,_that.categoryId,_that.userId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? amount,  String? type,  String? note, @JsonKey(name: 'pictuteURL')  String? pictureUrl,  DateTime? transactionDate,  int? categoryId,  int? userId)  $default,) {final _that = this;
switch (_that) {
case _TransactionCreateDto():
return $default(_that.amount,_that.type,_that.note,_that.pictureUrl,_that.transactionDate,_that.categoryId,_that.userId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? amount,  String? type,  String? note, @JsonKey(name: 'pictuteURL')  String? pictureUrl,  DateTime? transactionDate,  int? categoryId,  int? userId)?  $default,) {final _that = this;
switch (_that) {
case _TransactionCreateDto() when $default != null:
return $default(_that.amount,_that.type,_that.note,_that.pictureUrl,_that.transactionDate,_that.categoryId,_that.userId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionCreateDto implements TransactionCreateDto {
  const _TransactionCreateDto({this.amount, this.type, this.note, @JsonKey(name: 'pictuteURL') this.pictureUrl, this.transactionDate, this.categoryId, this.userId});
  factory _TransactionCreateDto.fromJson(Map<String, dynamic> json) => _$TransactionCreateDtoFromJson(json);

@override final  int? amount;
@override final  String? type;
@override final  String? note;
@override@JsonKey(name: 'pictuteURL') final  String? pictureUrl;
@override final  DateTime? transactionDate;
@override final  int? categoryId;
@override final  int? userId;

/// Create a copy of TransactionCreateDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionCreateDtoCopyWith<_TransactionCreateDto> get copyWith => __$TransactionCreateDtoCopyWithImpl<_TransactionCreateDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionCreateDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionCreateDto&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.type, type) || other.type == type)&&(identical(other.note, note) || other.note == note)&&(identical(other.pictureUrl, pictureUrl) || other.pictureUrl == pictureUrl)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,type,note,pictureUrl,transactionDate,categoryId,userId);

@override
String toString() {
  return 'TransactionCreateDto(amount: $amount, type: $type, note: $note, pictureUrl: $pictureUrl, transactionDate: $transactionDate, categoryId: $categoryId, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$TransactionCreateDtoCopyWith<$Res> implements $TransactionCreateDtoCopyWith<$Res> {
  factory _$TransactionCreateDtoCopyWith(_TransactionCreateDto value, $Res Function(_TransactionCreateDto) _then) = __$TransactionCreateDtoCopyWithImpl;
@override @useResult
$Res call({
 int? amount, String? type, String? note,@JsonKey(name: 'pictuteURL') String? pictureUrl, DateTime? transactionDate, int? categoryId, int? userId
});




}
/// @nodoc
class __$TransactionCreateDtoCopyWithImpl<$Res>
    implements _$TransactionCreateDtoCopyWith<$Res> {
  __$TransactionCreateDtoCopyWithImpl(this._self, this._then);

  final _TransactionCreateDto _self;
  final $Res Function(_TransactionCreateDto) _then;

/// Create a copy of TransactionCreateDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? amount = freezed,Object? type = freezed,Object? note = freezed,Object? pictureUrl = freezed,Object? transactionDate = freezed,Object? categoryId = freezed,Object? userId = freezed,}) {
  return _then(_TransactionCreateDto(
amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,pictureUrl: freezed == pictureUrl ? _self.pictureUrl : pictureUrl // ignore: cast_nullable_to_non_nullable
as String?,transactionDate: freezed == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as DateTime?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
