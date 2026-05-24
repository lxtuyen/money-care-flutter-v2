// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransferDto {

 int get fromWalletId; int get toWalletId; double get amount; String? get note; int? get categoryId;
/// Create a copy of TransferDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferDtoCopyWith<TransferDto> get copyWith => _$TransferDtoCopyWithImpl<TransferDto>(this as TransferDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferDto&&(identical(other.fromWalletId, fromWalletId) || other.fromWalletId == fromWalletId)&&(identical(other.toWalletId, toWalletId) || other.toWalletId == toWalletId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.note, note) || other.note == note)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}


@override
int get hashCode => Object.hash(runtimeType,fromWalletId,toWalletId,amount,note,categoryId);

@override
String toString() {
  return 'TransferDto(fromWalletId: $fromWalletId, toWalletId: $toWalletId, amount: $amount, note: $note, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class $TransferDtoCopyWith<$Res>  {
  factory $TransferDtoCopyWith(TransferDto value, $Res Function(TransferDto) _then) = _$TransferDtoCopyWithImpl;
@useResult
$Res call({
 int fromWalletId, int toWalletId, double amount, String? note, int? categoryId
});




}
/// @nodoc
class _$TransferDtoCopyWithImpl<$Res>
    implements $TransferDtoCopyWith<$Res> {
  _$TransferDtoCopyWithImpl(this._self, this._then);

  final TransferDto _self;
  final $Res Function(TransferDto) _then;

/// Create a copy of TransferDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fromWalletId = null,Object? toWalletId = null,Object? amount = null,Object? note = freezed,Object? categoryId = freezed,}) {
  return _then(_self.copyWith(
fromWalletId: null == fromWalletId ? _self.fromWalletId : fromWalletId // ignore: cast_nullable_to_non_nullable
as int,toWalletId: null == toWalletId ? _self.toWalletId : toWalletId // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransferDto].
extension TransferDtoPatterns on TransferDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransferDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransferDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransferDto value)  $default,){
final _that = this;
switch (_that) {
case _TransferDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransferDto value)?  $default,){
final _that = this;
switch (_that) {
case _TransferDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int fromWalletId,  int toWalletId,  double amount,  String? note,  int? categoryId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransferDto() when $default != null:
return $default(_that.fromWalletId,_that.toWalletId,_that.amount,_that.note,_that.categoryId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int fromWalletId,  int toWalletId,  double amount,  String? note,  int? categoryId)  $default,) {final _that = this;
switch (_that) {
case _TransferDto():
return $default(_that.fromWalletId,_that.toWalletId,_that.amount,_that.note,_that.categoryId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int fromWalletId,  int toWalletId,  double amount,  String? note,  int? categoryId)?  $default,) {final _that = this;
switch (_that) {
case _TransferDto() when $default != null:
return $default(_that.fromWalletId,_that.toWalletId,_that.amount,_that.note,_that.categoryId);case _:
  return null;

}
}

}

/// @nodoc


class _TransferDto extends TransferDto {
  const _TransferDto({required this.fromWalletId, required this.toWalletId, required this.amount, this.note, this.categoryId}): super._();
  

@override final  int fromWalletId;
@override final  int toWalletId;
@override final  double amount;
@override final  String? note;
@override final  int? categoryId;

/// Create a copy of TransferDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferDtoCopyWith<_TransferDto> get copyWith => __$TransferDtoCopyWithImpl<_TransferDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferDto&&(identical(other.fromWalletId, fromWalletId) || other.fromWalletId == fromWalletId)&&(identical(other.toWalletId, toWalletId) || other.toWalletId == toWalletId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.note, note) || other.note == note)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}


@override
int get hashCode => Object.hash(runtimeType,fromWalletId,toWalletId,amount,note,categoryId);

@override
String toString() {
  return 'TransferDto(fromWalletId: $fromWalletId, toWalletId: $toWalletId, amount: $amount, note: $note, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$TransferDtoCopyWith<$Res> implements $TransferDtoCopyWith<$Res> {
  factory _$TransferDtoCopyWith(_TransferDto value, $Res Function(_TransferDto) _then) = __$TransferDtoCopyWithImpl;
@override @useResult
$Res call({
 int fromWalletId, int toWalletId, double amount, String? note, int? categoryId
});




}
/// @nodoc
class __$TransferDtoCopyWithImpl<$Res>
    implements _$TransferDtoCopyWith<$Res> {
  __$TransferDtoCopyWithImpl(this._self, this._then);

  final _TransferDto _self;
  final $Res Function(_TransferDto) _then;

/// Create a copy of TransferDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fromWalletId = null,Object? toWalletId = null,Object? amount = null,Object? note = freezed,Object? categoryId = freezed,}) {
  return _then(_TransferDto(
fromWalletId: null == fromWalletId ? _self.fromWalletId : fromWalletId // ignore: cast_nullable_to_non_nullable
as int,toWalletId: null == toWalletId ? _self.toWalletId : toWalletId // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
