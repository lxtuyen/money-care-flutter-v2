// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'total_by_date_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TotalByDateEntityModel {

 DateTime get date; int get total;
/// Create a copy of TotalByDateEntityModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TotalByDateEntityModelCopyWith<TotalByDateEntityModel> get copyWith => _$TotalByDateEntityModelCopyWithImpl<TotalByDateEntityModel>(this as TotalByDateEntityModel, _$identity);

  /// Serializes this TotalByDateEntityModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TotalByDateEntityModel&&(identical(other.date, date) || other.date == date)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,total);

@override
String toString() {
  return 'TotalByDateEntityModel(date: $date, total: $total)';
}


}

/// @nodoc
abstract mixin class $TotalByDateEntityModelCopyWith<$Res>  {
  factory $TotalByDateEntityModelCopyWith(TotalByDateEntityModel value, $Res Function(TotalByDateEntityModel) _then) = _$TotalByDateEntityModelCopyWithImpl;
@useResult
$Res call({
 DateTime date, int total
});




}
/// @nodoc
class _$TotalByDateEntityModelCopyWithImpl<$Res>
    implements $TotalByDateEntityModelCopyWith<$Res> {
  _$TotalByDateEntityModelCopyWithImpl(this._self, this._then);

  final TotalByDateEntityModel _self;
  final $Res Function(TotalByDateEntityModel) _then;

/// Create a copy of TotalByDateEntityModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? total = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TotalByDateEntityModel].
extension TotalByDateEntityModelPatterns on TotalByDateEntityModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TotalByDateEntityModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TotalByDateEntityModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TotalByDateEntityModel value)  $default,){
final _that = this;
switch (_that) {
case _TotalByDateEntityModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TotalByDateEntityModel value)?  $default,){
final _that = this;
switch (_that) {
case _TotalByDateEntityModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TotalByDateEntityModel() when $default != null:
return $default(_that.date,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  int total)  $default,) {final _that = this;
switch (_that) {
case _TotalByDateEntityModel():
return $default(_that.date,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  int total)?  $default,) {final _that = this;
switch (_that) {
case _TotalByDateEntityModel() when $default != null:
return $default(_that.date,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TotalByDateEntityModel extends TotalByDateEntityModel {
  const _TotalByDateEntityModel({required this.date, this.total = 0}): super._();
  factory _TotalByDateEntityModel.fromJson(Map<String, dynamic> json) => _$TotalByDateEntityModelFromJson(json);

@override final  DateTime date;
@override@JsonKey() final  int total;

/// Create a copy of TotalByDateEntityModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TotalByDateEntityModelCopyWith<_TotalByDateEntityModel> get copyWith => __$TotalByDateEntityModelCopyWithImpl<_TotalByDateEntityModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TotalByDateEntityModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TotalByDateEntityModel&&(identical(other.date, date) || other.date == date)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,total);

@override
String toString() {
  return 'TotalByDateEntityModel(date: $date, total: $total)';
}


}

/// @nodoc
abstract mixin class _$TotalByDateEntityModelCopyWith<$Res> implements $TotalByDateEntityModelCopyWith<$Res> {
  factory _$TotalByDateEntityModelCopyWith(_TotalByDateEntityModel value, $Res Function(_TotalByDateEntityModel) _then) = __$TotalByDateEntityModelCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, int total
});




}
/// @nodoc
class __$TotalByDateEntityModelCopyWithImpl<$Res>
    implements _$TotalByDateEntityModelCopyWith<$Res> {
  __$TotalByDateEntityModelCopyWithImpl(this._self, this._then);

  final _TotalByDateEntityModel _self;
  final $Res Function(_TotalByDateEntityModel) _then;

/// Create a copy of TotalByDateEntityModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? total = null,}) {
  return _then(_TotalByDateEntityModel(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
