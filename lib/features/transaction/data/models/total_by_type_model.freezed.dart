// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'total_by_type_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TotalByTypeModel {

@JsonKey(name: 'income_total') int get income;@JsonKey(name: 'expense_total') int get expense; int get currentSaving; int get targetSaving;
/// Create a copy of TotalByTypeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TotalByTypeModelCopyWith<TotalByTypeModel> get copyWith => _$TotalByTypeModelCopyWithImpl<TotalByTypeModel>(this as TotalByTypeModel, _$identity);

  /// Serializes this TotalByTypeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TotalByTypeModel&&(identical(other.income, income) || other.income == income)&&(identical(other.expense, expense) || other.expense == expense)&&(identical(other.currentSaving, currentSaving) || other.currentSaving == currentSaving)&&(identical(other.targetSaving, targetSaving) || other.targetSaving == targetSaving));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,income,expense,currentSaving,targetSaving);

@override
String toString() {
  return 'TotalByTypeModel(income: $income, expense: $expense, currentSaving: $currentSaving, targetSaving: $targetSaving)';
}


}

/// @nodoc
abstract mixin class $TotalByTypeModelCopyWith<$Res>  {
  factory $TotalByTypeModelCopyWith(TotalByTypeModel value, $Res Function(TotalByTypeModel) _then) = _$TotalByTypeModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'income_total') int income,@JsonKey(name: 'expense_total') int expense, int currentSaving, int targetSaving
});




}
/// @nodoc
class _$TotalByTypeModelCopyWithImpl<$Res>
    implements $TotalByTypeModelCopyWith<$Res> {
  _$TotalByTypeModelCopyWithImpl(this._self, this._then);

  final TotalByTypeModel _self;
  final $Res Function(TotalByTypeModel) _then;

/// Create a copy of TotalByTypeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? income = null,Object? expense = null,Object? currentSaving = null,Object? targetSaving = null,}) {
  return _then(_self.copyWith(
income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as int,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as int,currentSaving: null == currentSaving ? _self.currentSaving : currentSaving // ignore: cast_nullable_to_non_nullable
as int,targetSaving: null == targetSaving ? _self.targetSaving : targetSaving // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TotalByTypeModel].
extension TotalByTypeModelPatterns on TotalByTypeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TotalByTypeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TotalByTypeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TotalByTypeModel value)  $default,){
final _that = this;
switch (_that) {
case _TotalByTypeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TotalByTypeModel value)?  $default,){
final _that = this;
switch (_that) {
case _TotalByTypeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'income_total')  int income, @JsonKey(name: 'expense_total')  int expense,  int currentSaving,  int targetSaving)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TotalByTypeModel() when $default != null:
return $default(_that.income,_that.expense,_that.currentSaving,_that.targetSaving);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'income_total')  int income, @JsonKey(name: 'expense_total')  int expense,  int currentSaving,  int targetSaving)  $default,) {final _that = this;
switch (_that) {
case _TotalByTypeModel():
return $default(_that.income,_that.expense,_that.currentSaving,_that.targetSaving);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'income_total')  int income, @JsonKey(name: 'expense_total')  int expense,  int currentSaving,  int targetSaving)?  $default,) {final _that = this;
switch (_that) {
case _TotalByTypeModel() when $default != null:
return $default(_that.income,_that.expense,_that.currentSaving,_that.targetSaving);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _TotalByTypeModel extends TotalByTypeModel {
  const _TotalByTypeModel({@JsonKey(name: 'income_total') required this.income, @JsonKey(name: 'expense_total') required this.expense, required this.currentSaving, required this.targetSaving}): super._();
  factory _TotalByTypeModel.fromJson(Map<String, dynamic> json) => _$TotalByTypeModelFromJson(json);

@override@JsonKey(name: 'income_total') final  int income;
@override@JsonKey(name: 'expense_total') final  int expense;
@override final  int currentSaving;
@override final  int targetSaving;

/// Create a copy of TotalByTypeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TotalByTypeModelCopyWith<_TotalByTypeModel> get copyWith => __$TotalByTypeModelCopyWithImpl<_TotalByTypeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TotalByTypeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TotalByTypeModel&&(identical(other.income, income) || other.income == income)&&(identical(other.expense, expense) || other.expense == expense)&&(identical(other.currentSaving, currentSaving) || other.currentSaving == currentSaving)&&(identical(other.targetSaving, targetSaving) || other.targetSaving == targetSaving));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,income,expense,currentSaving,targetSaving);

@override
String toString() {
  return 'TotalByTypeModel(income: $income, expense: $expense, currentSaving: $currentSaving, targetSaving: $targetSaving)';
}


}

/// @nodoc
abstract mixin class _$TotalByTypeModelCopyWith<$Res> implements $TotalByTypeModelCopyWith<$Res> {
  factory _$TotalByTypeModelCopyWith(_TotalByTypeModel value, $Res Function(_TotalByTypeModel) _then) = __$TotalByTypeModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'income_total') int income,@JsonKey(name: 'expense_total') int expense, int currentSaving, int targetSaving
});




}
/// @nodoc
class __$TotalByTypeModelCopyWithImpl<$Res>
    implements _$TotalByTypeModelCopyWith<$Res> {
  __$TotalByTypeModelCopyWithImpl(this._self, this._then);

  final _TotalByTypeModel _self;
  final $Res Function(_TotalByTypeModel) _then;

/// Create a copy of TotalByTypeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? income = null,Object? expense = null,Object? currentSaving = null,Object? targetSaving = null,}) {
  return _then(_TotalByTypeModel(
income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as int,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as int,currentSaving: null == currentSaving ? _self.currentSaving : currentSaving // ignore: cast_nullable_to_non_nullable
as int,targetSaving: null == targetSaving ? _self.targetSaving : targetSaving // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
