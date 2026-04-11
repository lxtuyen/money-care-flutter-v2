// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'totals_by_date_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TotalsByDateEntityModel {

 List<TotalByDateEntityModel> get income; List<TotalByDateEntityModel> get expense;
/// Create a copy of TotalsByDateEntityModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TotalsByDateEntityModelCopyWith<TotalsByDateEntityModel> get copyWith => _$TotalsByDateEntityModelCopyWithImpl<TotalsByDateEntityModel>(this as TotalsByDateEntityModel, _$identity);

  /// Serializes this TotalsByDateEntityModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TotalsByDateEntityModel&&const DeepCollectionEquality().equals(other.income, income)&&const DeepCollectionEquality().equals(other.expense, expense));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(income),const DeepCollectionEquality().hash(expense));

@override
String toString() {
  return 'TotalsByDateEntityModel(income: $income, expense: $expense)';
}


}

/// @nodoc
abstract mixin class $TotalsByDateEntityModelCopyWith<$Res>  {
  factory $TotalsByDateEntityModelCopyWith(TotalsByDateEntityModel value, $Res Function(TotalsByDateEntityModel) _then) = _$TotalsByDateEntityModelCopyWithImpl;
@useResult
$Res call({
 List<TotalByDateEntityModel> income, List<TotalByDateEntityModel> expense
});




}
/// @nodoc
class _$TotalsByDateEntityModelCopyWithImpl<$Res>
    implements $TotalsByDateEntityModelCopyWith<$Res> {
  _$TotalsByDateEntityModelCopyWithImpl(this._self, this._then);

  final TotalsByDateEntityModel _self;
  final $Res Function(TotalsByDateEntityModel) _then;

/// Create a copy of TotalsByDateEntityModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? income = null,Object? expense = null,}) {
  return _then(_self.copyWith(
income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as List<TotalByDateEntityModel>,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as List<TotalByDateEntityModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [TotalsByDateEntityModel].
extension TotalsByDateEntityModelPatterns on TotalsByDateEntityModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TotalsByDateEntityModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TotalsByDateEntityModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TotalsByDateEntityModel value)  $default,){
final _that = this;
switch (_that) {
case _TotalsByDateEntityModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TotalsByDateEntityModel value)?  $default,){
final _that = this;
switch (_that) {
case _TotalsByDateEntityModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TotalByDateEntityModel> income,  List<TotalByDateEntityModel> expense)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TotalsByDateEntityModel() when $default != null:
return $default(_that.income,_that.expense);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TotalByDateEntityModel> income,  List<TotalByDateEntityModel> expense)  $default,) {final _that = this;
switch (_that) {
case _TotalsByDateEntityModel():
return $default(_that.income,_that.expense);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TotalByDateEntityModel> income,  List<TotalByDateEntityModel> expense)?  $default,) {final _that = this;
switch (_that) {
case _TotalsByDateEntityModel() when $default != null:
return $default(_that.income,_that.expense);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TotalsByDateEntityModel extends TotalsByDateEntityModel {
  const _TotalsByDateEntityModel({final  List<TotalByDateEntityModel> income = const [], final  List<TotalByDateEntityModel> expense = const []}): _income = income,_expense = expense,super._();
  factory _TotalsByDateEntityModel.fromJson(Map<String, dynamic> json) => _$TotalsByDateEntityModelFromJson(json);

 final  List<TotalByDateEntityModel> _income;
@override@JsonKey() List<TotalByDateEntityModel> get income {
  if (_income is EqualUnmodifiableListView) return _income;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_income);
}

 final  List<TotalByDateEntityModel> _expense;
@override@JsonKey() List<TotalByDateEntityModel> get expense {
  if (_expense is EqualUnmodifiableListView) return _expense;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_expense);
}


/// Create a copy of TotalsByDateEntityModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TotalsByDateEntityModelCopyWith<_TotalsByDateEntityModel> get copyWith => __$TotalsByDateEntityModelCopyWithImpl<_TotalsByDateEntityModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TotalsByDateEntityModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TotalsByDateEntityModel&&const DeepCollectionEquality().equals(other._income, _income)&&const DeepCollectionEquality().equals(other._expense, _expense));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_income),const DeepCollectionEquality().hash(_expense));

@override
String toString() {
  return 'TotalsByDateEntityModel(income: $income, expense: $expense)';
}


}

/// @nodoc
abstract mixin class _$TotalsByDateEntityModelCopyWith<$Res> implements $TotalsByDateEntityModelCopyWith<$Res> {
  factory _$TotalsByDateEntityModelCopyWith(_TotalsByDateEntityModel value, $Res Function(_TotalsByDateEntityModel) _then) = __$TotalsByDateEntityModelCopyWithImpl;
@override @useResult
$Res call({
 List<TotalByDateEntityModel> income, List<TotalByDateEntityModel> expense
});




}
/// @nodoc
class __$TotalsByDateEntityModelCopyWithImpl<$Res>
    implements _$TotalsByDateEntityModelCopyWith<$Res> {
  __$TotalsByDateEntityModelCopyWithImpl(this._self, this._then);

  final _TotalsByDateEntityModel _self;
  final $Res Function(_TotalsByDateEntityModel) _then;

/// Create a copy of TotalsByDateEntityModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? income = null,Object? expense = null,}) {
  return _then(_TotalsByDateEntityModel(
income: null == income ? _self._income : income // ignore: cast_nullable_to_non_nullable
as List<TotalByDateEntityModel>,expense: null == expense ? _self._expense : expense // ignore: cast_nullable_to_non_nullable
as List<TotalByDateEntityModel>,
  ));
}


}

// dart format on
