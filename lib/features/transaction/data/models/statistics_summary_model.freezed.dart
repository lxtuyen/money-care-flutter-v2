// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'statistics_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StatisticsSummaryModel {

 double get dailyAverage; double get dailyAverageChange; double get dailyIncomeChange; double get monthlyBalance;
/// Create a copy of StatisticsSummaryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatisticsSummaryModelCopyWith<StatisticsSummaryModel> get copyWith => _$StatisticsSummaryModelCopyWithImpl<StatisticsSummaryModel>(this as StatisticsSummaryModel, _$identity);

  /// Serializes this StatisticsSummaryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatisticsSummaryModel&&(identical(other.dailyAverage, dailyAverage) || other.dailyAverage == dailyAverage)&&(identical(other.dailyAverageChange, dailyAverageChange) || other.dailyAverageChange == dailyAverageChange)&&(identical(other.dailyIncomeChange, dailyIncomeChange) || other.dailyIncomeChange == dailyIncomeChange)&&(identical(other.monthlyBalance, monthlyBalance) || other.monthlyBalance == monthlyBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dailyAverage,dailyAverageChange,dailyIncomeChange,monthlyBalance);

@override
String toString() {
  return 'StatisticsSummaryModel(dailyAverage: $dailyAverage, dailyAverageChange: $dailyAverageChange, dailyIncomeChange: $dailyIncomeChange, monthlyBalance: $monthlyBalance)';
}


}

/// @nodoc
abstract mixin class $StatisticsSummaryModelCopyWith<$Res>  {
  factory $StatisticsSummaryModelCopyWith(StatisticsSummaryModel value, $Res Function(StatisticsSummaryModel) _then) = _$StatisticsSummaryModelCopyWithImpl;
@useResult
$Res call({
 double dailyAverage, double dailyAverageChange, double dailyIncomeChange, double monthlyBalance
});




}
/// @nodoc
class _$StatisticsSummaryModelCopyWithImpl<$Res>
    implements $StatisticsSummaryModelCopyWith<$Res> {
  _$StatisticsSummaryModelCopyWithImpl(this._self, this._then);

  final StatisticsSummaryModel _self;
  final $Res Function(StatisticsSummaryModel) _then;

/// Create a copy of StatisticsSummaryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dailyAverage = null,Object? dailyAverageChange = null,Object? dailyIncomeChange = null,Object? monthlyBalance = null,}) {
  return _then(_self.copyWith(
dailyAverage: null == dailyAverage ? _self.dailyAverage : dailyAverage // ignore: cast_nullable_to_non_nullable
as double,dailyAverageChange: null == dailyAverageChange ? _self.dailyAverageChange : dailyAverageChange // ignore: cast_nullable_to_non_nullable
as double,dailyIncomeChange: null == dailyIncomeChange ? _self.dailyIncomeChange : dailyIncomeChange // ignore: cast_nullable_to_non_nullable
as double,monthlyBalance: null == monthlyBalance ? _self.monthlyBalance : monthlyBalance // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [StatisticsSummaryModel].
extension StatisticsSummaryModelPatterns on StatisticsSummaryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatisticsSummaryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatisticsSummaryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatisticsSummaryModel value)  $default,){
final _that = this;
switch (_that) {
case _StatisticsSummaryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatisticsSummaryModel value)?  $default,){
final _that = this;
switch (_that) {
case _StatisticsSummaryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double dailyAverage,  double dailyAverageChange,  double dailyIncomeChange,  double monthlyBalance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatisticsSummaryModel() when $default != null:
return $default(_that.dailyAverage,_that.dailyAverageChange,_that.dailyIncomeChange,_that.monthlyBalance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double dailyAverage,  double dailyAverageChange,  double dailyIncomeChange,  double monthlyBalance)  $default,) {final _that = this;
switch (_that) {
case _StatisticsSummaryModel():
return $default(_that.dailyAverage,_that.dailyAverageChange,_that.dailyIncomeChange,_that.monthlyBalance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double dailyAverage,  double dailyAverageChange,  double dailyIncomeChange,  double monthlyBalance)?  $default,) {final _that = this;
switch (_that) {
case _StatisticsSummaryModel() when $default != null:
return $default(_that.dailyAverage,_that.dailyAverageChange,_that.dailyIncomeChange,_that.monthlyBalance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StatisticsSummaryModel extends StatisticsSummaryModel {
  const _StatisticsSummaryModel({required this.dailyAverage, required this.dailyAverageChange, required this.dailyIncomeChange, required this.monthlyBalance}): super._();
  factory _StatisticsSummaryModel.fromJson(Map<String, dynamic> json) => _$StatisticsSummaryModelFromJson(json);

@override final  double dailyAverage;
@override final  double dailyAverageChange;
@override final  double dailyIncomeChange;
@override final  double monthlyBalance;

/// Create a copy of StatisticsSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatisticsSummaryModelCopyWith<_StatisticsSummaryModel> get copyWith => __$StatisticsSummaryModelCopyWithImpl<_StatisticsSummaryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StatisticsSummaryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatisticsSummaryModel&&(identical(other.dailyAverage, dailyAverage) || other.dailyAverage == dailyAverage)&&(identical(other.dailyAverageChange, dailyAverageChange) || other.dailyAverageChange == dailyAverageChange)&&(identical(other.dailyIncomeChange, dailyIncomeChange) || other.dailyIncomeChange == dailyIncomeChange)&&(identical(other.monthlyBalance, monthlyBalance) || other.monthlyBalance == monthlyBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dailyAverage,dailyAverageChange,dailyIncomeChange,monthlyBalance);

@override
String toString() {
  return 'StatisticsSummaryModel(dailyAverage: $dailyAverage, dailyAverageChange: $dailyAverageChange, dailyIncomeChange: $dailyIncomeChange, monthlyBalance: $monthlyBalance)';
}


}

/// @nodoc
abstract mixin class _$StatisticsSummaryModelCopyWith<$Res> implements $StatisticsSummaryModelCopyWith<$Res> {
  factory _$StatisticsSummaryModelCopyWith(_StatisticsSummaryModel value, $Res Function(_StatisticsSummaryModel) _then) = __$StatisticsSummaryModelCopyWithImpl;
@override @useResult
$Res call({
 double dailyAverage, double dailyAverageChange, double dailyIncomeChange, double monthlyBalance
});




}
/// @nodoc
class __$StatisticsSummaryModelCopyWithImpl<$Res>
    implements _$StatisticsSummaryModelCopyWith<$Res> {
  __$StatisticsSummaryModelCopyWithImpl(this._self, this._then);

  final _StatisticsSummaryModel _self;
  final $Res Function(_StatisticsSummaryModel) _then;

/// Create a copy of StatisticsSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dailyAverage = null,Object? dailyAverageChange = null,Object? dailyIncomeChange = null,Object? monthlyBalance = null,}) {
  return _then(_StatisticsSummaryModel(
dailyAverage: null == dailyAverage ? _self.dailyAverage : dailyAverage // ignore: cast_nullable_to_non_nullable
as double,dailyAverageChange: null == dailyAverageChange ? _self.dailyAverageChange : dailyAverageChange // ignore: cast_nullable_to_non_nullable
as double,dailyIncomeChange: null == dailyIncomeChange ? _self.dailyIncomeChange : dailyIncomeChange // ignore: cast_nullable_to_non_nullable
as double,monthlyBalance: null == monthlyBalance ? _self.monthlyBalance : monthlyBalance // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
