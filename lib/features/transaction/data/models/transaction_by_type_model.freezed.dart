// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_by_type_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionByTypeModel {

 List<TransactionModel> get income; List<TransactionModel> get expense;
/// Create a copy of TransactionByTypeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionByTypeModelCopyWith<TransactionByTypeModel> get copyWith => _$TransactionByTypeModelCopyWithImpl<TransactionByTypeModel>(this as TransactionByTypeModel, _$identity);

  /// Serializes this TransactionByTypeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionByTypeModel&&const DeepCollectionEquality().equals(other.income, income)&&const DeepCollectionEquality().equals(other.expense, expense));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(income),const DeepCollectionEquality().hash(expense));

@override
String toString() {
  return 'TransactionByTypeModel(income: $income, expense: $expense)';
}


}

/// @nodoc
abstract mixin class $TransactionByTypeModelCopyWith<$Res>  {
  factory $TransactionByTypeModelCopyWith(TransactionByTypeModel value, $Res Function(TransactionByTypeModel) _then) = _$TransactionByTypeModelCopyWithImpl;
@useResult
$Res call({
 List<TransactionModel> income, List<TransactionModel> expense
});




}
/// @nodoc
class _$TransactionByTypeModelCopyWithImpl<$Res>
    implements $TransactionByTypeModelCopyWith<$Res> {
  _$TransactionByTypeModelCopyWithImpl(this._self, this._then);

  final TransactionByTypeModel _self;
  final $Res Function(TransactionByTypeModel) _then;

/// Create a copy of TransactionByTypeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? income = null,Object? expense = null,}) {
  return _then(_self.copyWith(
income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as List<TransactionModel>,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as List<TransactionModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionByTypeModel].
extension TransactionByTypeModelPatterns on TransactionByTypeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionByTypeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionByTypeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionByTypeModel value)  $default,){
final _that = this;
switch (_that) {
case _TransactionByTypeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionByTypeModel value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionByTypeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TransactionModel> income,  List<TransactionModel> expense)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionByTypeModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TransactionModel> income,  List<TransactionModel> expense)  $default,) {final _that = this;
switch (_that) {
case _TransactionByTypeModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TransactionModel> income,  List<TransactionModel> expense)?  $default,) {final _that = this;
switch (_that) {
case _TransactionByTypeModel() when $default != null:
return $default(_that.income,_that.expense);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionByTypeModel extends TransactionByTypeModel {
  const _TransactionByTypeModel({final  List<TransactionModel> income = const [], final  List<TransactionModel> expense = const []}): _income = income,_expense = expense,super._();
  factory _TransactionByTypeModel.fromJson(Map<String, dynamic> json) => _$TransactionByTypeModelFromJson(json);

 final  List<TransactionModel> _income;
@override@JsonKey() List<TransactionModel> get income {
  if (_income is EqualUnmodifiableListView) return _income;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_income);
}

 final  List<TransactionModel> _expense;
@override@JsonKey() List<TransactionModel> get expense {
  if (_expense is EqualUnmodifiableListView) return _expense;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_expense);
}


/// Create a copy of TransactionByTypeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionByTypeModelCopyWith<_TransactionByTypeModel> get copyWith => __$TransactionByTypeModelCopyWithImpl<_TransactionByTypeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionByTypeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionByTypeModel&&const DeepCollectionEquality().equals(other._income, _income)&&const DeepCollectionEquality().equals(other._expense, _expense));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_income),const DeepCollectionEquality().hash(_expense));

@override
String toString() {
  return 'TransactionByTypeModel(income: $income, expense: $expense)';
}


}

/// @nodoc
abstract mixin class _$TransactionByTypeModelCopyWith<$Res> implements $TransactionByTypeModelCopyWith<$Res> {
  factory _$TransactionByTypeModelCopyWith(_TransactionByTypeModel value, $Res Function(_TransactionByTypeModel) _then) = __$TransactionByTypeModelCopyWithImpl;
@override @useResult
$Res call({
 List<TransactionModel> income, List<TransactionModel> expense
});




}
/// @nodoc
class __$TransactionByTypeModelCopyWithImpl<$Res>
    implements _$TransactionByTypeModelCopyWith<$Res> {
  __$TransactionByTypeModelCopyWithImpl(this._self, this._then);

  final _TransactionByTypeModel _self;
  final $Res Function(_TransactionByTypeModel) _then;

/// Create a copy of TransactionByTypeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? income = null,Object? expense = null,}) {
  return _then(_TransactionByTypeModel(
income: null == income ? _self._income : income // ignore: cast_nullable_to_non_nullable
as List<TransactionModel>,expense: null == expense ? _self._expense : expense // ignore: cast_nullable_to_non_nullable
as List<TransactionModel>,
  ));
}


}

// dart format on
