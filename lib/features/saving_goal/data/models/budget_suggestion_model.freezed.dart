// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_suggestion_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BudgetSuggestionGoalModel {

@JsonKey(fromJson: NumParser.parseInt) int get id; String get name;@JsonKey(name: 'monthlyBudget', fromJson: NumParser.parseDouble) double get monthlyBudget;
/// Create a copy of BudgetSuggestionGoalModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetSuggestionGoalModelCopyWith<BudgetSuggestionGoalModel> get copyWith => _$BudgetSuggestionGoalModelCopyWithImpl<BudgetSuggestionGoalModel>(this as BudgetSuggestionGoalModel, _$identity);

  /// Serializes this BudgetSuggestionGoalModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetSuggestionGoalModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.monthlyBudget, monthlyBudget) || other.monthlyBudget == monthlyBudget));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,monthlyBudget);

@override
String toString() {
  return 'BudgetSuggestionGoalModel(id: $id, name: $name, monthlyBudget: $monthlyBudget)';
}


}

/// @nodoc
abstract mixin class $BudgetSuggestionGoalModelCopyWith<$Res>  {
  factory $BudgetSuggestionGoalModelCopyWith(BudgetSuggestionGoalModel value, $Res Function(BudgetSuggestionGoalModel) _then) = _$BudgetSuggestionGoalModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: NumParser.parseInt) int id, String name,@JsonKey(name: 'monthlyBudget', fromJson: NumParser.parseDouble) double monthlyBudget
});




}
/// @nodoc
class _$BudgetSuggestionGoalModelCopyWithImpl<$Res>
    implements $BudgetSuggestionGoalModelCopyWith<$Res> {
  _$BudgetSuggestionGoalModelCopyWithImpl(this._self, this._then);

  final BudgetSuggestionGoalModel _self;
  final $Res Function(BudgetSuggestionGoalModel) _then;

/// Create a copy of BudgetSuggestionGoalModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? monthlyBudget = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,monthlyBudget: null == monthlyBudget ? _self.monthlyBudget : monthlyBudget // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [BudgetSuggestionGoalModel].
extension BudgetSuggestionGoalModelPatterns on BudgetSuggestionGoalModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetSuggestionGoalModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetSuggestionGoalModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetSuggestionGoalModel value)  $default,){
final _that = this;
switch (_that) {
case _BudgetSuggestionGoalModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetSuggestionGoalModel value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetSuggestionGoalModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NumParser.parseInt)  int id,  String name, @JsonKey(name: 'monthlyBudget', fromJson: NumParser.parseDouble)  double monthlyBudget)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetSuggestionGoalModel() when $default != null:
return $default(_that.id,_that.name,_that.monthlyBudget);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NumParser.parseInt)  int id,  String name, @JsonKey(name: 'monthlyBudget', fromJson: NumParser.parseDouble)  double monthlyBudget)  $default,) {final _that = this;
switch (_that) {
case _BudgetSuggestionGoalModel():
return $default(_that.id,_that.name,_that.monthlyBudget);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: NumParser.parseInt)  int id,  String name, @JsonKey(name: 'monthlyBudget', fromJson: NumParser.parseDouble)  double monthlyBudget)?  $default,) {final _that = this;
switch (_that) {
case _BudgetSuggestionGoalModel() when $default != null:
return $default(_that.id,_that.name,_that.monthlyBudget);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BudgetSuggestionGoalModel implements BudgetSuggestionGoalModel {
  const _BudgetSuggestionGoalModel({@JsonKey(fromJson: NumParser.parseInt) required this.id, this.name = '', @JsonKey(name: 'monthlyBudget', fromJson: NumParser.parseDouble) required this.monthlyBudget});
  factory _BudgetSuggestionGoalModel.fromJson(Map<String, dynamic> json) => _$BudgetSuggestionGoalModelFromJson(json);

@override@JsonKey(fromJson: NumParser.parseInt) final  int id;
@override@JsonKey() final  String name;
@override@JsonKey(name: 'monthlyBudget', fromJson: NumParser.parseDouble) final  double monthlyBudget;

/// Create a copy of BudgetSuggestionGoalModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetSuggestionGoalModelCopyWith<_BudgetSuggestionGoalModel> get copyWith => __$BudgetSuggestionGoalModelCopyWithImpl<_BudgetSuggestionGoalModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BudgetSuggestionGoalModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetSuggestionGoalModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.monthlyBudget, monthlyBudget) || other.monthlyBudget == monthlyBudget));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,monthlyBudget);

@override
String toString() {
  return 'BudgetSuggestionGoalModel(id: $id, name: $name, monthlyBudget: $monthlyBudget)';
}


}

/// @nodoc
abstract mixin class _$BudgetSuggestionGoalModelCopyWith<$Res> implements $BudgetSuggestionGoalModelCopyWith<$Res> {
  factory _$BudgetSuggestionGoalModelCopyWith(_BudgetSuggestionGoalModel value, $Res Function(_BudgetSuggestionGoalModel) _then) = __$BudgetSuggestionGoalModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: NumParser.parseInt) int id, String name,@JsonKey(name: 'monthlyBudget', fromJson: NumParser.parseDouble) double monthlyBudget
});




}
/// @nodoc
class __$BudgetSuggestionGoalModelCopyWithImpl<$Res>
    implements _$BudgetSuggestionGoalModelCopyWith<$Res> {
  __$BudgetSuggestionGoalModelCopyWithImpl(this._self, this._then);

  final _BudgetSuggestionGoalModel _self;
  final $Res Function(_BudgetSuggestionGoalModel) _then;

/// Create a copy of BudgetSuggestionGoalModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? monthlyBudget = null,}) {
  return _then(_BudgetSuggestionGoalModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,monthlyBudget: null == monthlyBudget ? _self.monthlyBudget : monthlyBudget // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$BudgetSuggestionModel {

@JsonKey(name: 'averageMonthlySavings', fromJson: NumParser.parseDouble) double get averageMonthlySavings;@JsonKey(name: 'totalExistingBudget', fromJson: NumParser.parseDouble) double get totalExistingBudget;@JsonKey(name: 'availableSavings', fromJson: NumParser.parseDouble) double get availableSavings;@JsonKey(name: 'requiredMonthly', fromJson: NumParser.parseDouble) double get requiredMonthly;@JsonKey(name: 'isSufficient') bool get isSufficient;@JsonKey(name: 'deficit', fromJson: NumParser.parseDouble) double get deficit;@JsonKey(name: 'existingGoals') List<BudgetSuggestionGoalModel> get existingGoals;@JsonKey(name: 'confidenceScore', fromJson: NumParser.parseDouble) double get confidenceScore;
/// Create a copy of BudgetSuggestionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetSuggestionModelCopyWith<BudgetSuggestionModel> get copyWith => _$BudgetSuggestionModelCopyWithImpl<BudgetSuggestionModel>(this as BudgetSuggestionModel, _$identity);

  /// Serializes this BudgetSuggestionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetSuggestionModel&&(identical(other.averageMonthlySavings, averageMonthlySavings) || other.averageMonthlySavings == averageMonthlySavings)&&(identical(other.totalExistingBudget, totalExistingBudget) || other.totalExistingBudget == totalExistingBudget)&&(identical(other.availableSavings, availableSavings) || other.availableSavings == availableSavings)&&(identical(other.requiredMonthly, requiredMonthly) || other.requiredMonthly == requiredMonthly)&&(identical(other.isSufficient, isSufficient) || other.isSufficient == isSufficient)&&(identical(other.deficit, deficit) || other.deficit == deficit)&&const DeepCollectionEquality().equals(other.existingGoals, existingGoals)&&(identical(other.confidenceScore, confidenceScore) || other.confidenceScore == confidenceScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,averageMonthlySavings,totalExistingBudget,availableSavings,requiredMonthly,isSufficient,deficit,const DeepCollectionEquality().hash(existingGoals),confidenceScore);

@override
String toString() {
  return 'BudgetSuggestionModel(averageMonthlySavings: $averageMonthlySavings, totalExistingBudget: $totalExistingBudget, availableSavings: $availableSavings, requiredMonthly: $requiredMonthly, isSufficient: $isSufficient, deficit: $deficit, existingGoals: $existingGoals, confidenceScore: $confidenceScore)';
}


}

/// @nodoc
abstract mixin class $BudgetSuggestionModelCopyWith<$Res>  {
  factory $BudgetSuggestionModelCopyWith(BudgetSuggestionModel value, $Res Function(BudgetSuggestionModel) _then) = _$BudgetSuggestionModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'averageMonthlySavings', fromJson: NumParser.parseDouble) double averageMonthlySavings,@JsonKey(name: 'totalExistingBudget', fromJson: NumParser.parseDouble) double totalExistingBudget,@JsonKey(name: 'availableSavings', fromJson: NumParser.parseDouble) double availableSavings,@JsonKey(name: 'requiredMonthly', fromJson: NumParser.parseDouble) double requiredMonthly,@JsonKey(name: 'isSufficient') bool isSufficient,@JsonKey(name: 'deficit', fromJson: NumParser.parseDouble) double deficit,@JsonKey(name: 'existingGoals') List<BudgetSuggestionGoalModel> existingGoals,@JsonKey(name: 'confidenceScore', fromJson: NumParser.parseDouble) double confidenceScore
});




}
/// @nodoc
class _$BudgetSuggestionModelCopyWithImpl<$Res>
    implements $BudgetSuggestionModelCopyWith<$Res> {
  _$BudgetSuggestionModelCopyWithImpl(this._self, this._then);

  final BudgetSuggestionModel _self;
  final $Res Function(BudgetSuggestionModel) _then;

/// Create a copy of BudgetSuggestionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? averageMonthlySavings = null,Object? totalExistingBudget = null,Object? availableSavings = null,Object? requiredMonthly = null,Object? isSufficient = null,Object? deficit = null,Object? existingGoals = null,Object? confidenceScore = null,}) {
  return _then(_self.copyWith(
averageMonthlySavings: null == averageMonthlySavings ? _self.averageMonthlySavings : averageMonthlySavings // ignore: cast_nullable_to_non_nullable
as double,totalExistingBudget: null == totalExistingBudget ? _self.totalExistingBudget : totalExistingBudget // ignore: cast_nullable_to_non_nullable
as double,availableSavings: null == availableSavings ? _self.availableSavings : availableSavings // ignore: cast_nullable_to_non_nullable
as double,requiredMonthly: null == requiredMonthly ? _self.requiredMonthly : requiredMonthly // ignore: cast_nullable_to_non_nullable
as double,isSufficient: null == isSufficient ? _self.isSufficient : isSufficient // ignore: cast_nullable_to_non_nullable
as bool,deficit: null == deficit ? _self.deficit : deficit // ignore: cast_nullable_to_non_nullable
as double,existingGoals: null == existingGoals ? _self.existingGoals : existingGoals // ignore: cast_nullable_to_non_nullable
as List<BudgetSuggestionGoalModel>,confidenceScore: null == confidenceScore ? _self.confidenceScore : confidenceScore // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [BudgetSuggestionModel].
extension BudgetSuggestionModelPatterns on BudgetSuggestionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetSuggestionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetSuggestionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetSuggestionModel value)  $default,){
final _that = this;
switch (_that) {
case _BudgetSuggestionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetSuggestionModel value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetSuggestionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'averageMonthlySavings', fromJson: NumParser.parseDouble)  double averageMonthlySavings, @JsonKey(name: 'totalExistingBudget', fromJson: NumParser.parseDouble)  double totalExistingBudget, @JsonKey(name: 'availableSavings', fromJson: NumParser.parseDouble)  double availableSavings, @JsonKey(name: 'requiredMonthly', fromJson: NumParser.parseDouble)  double requiredMonthly, @JsonKey(name: 'isSufficient')  bool isSufficient, @JsonKey(name: 'deficit', fromJson: NumParser.parseDouble)  double deficit, @JsonKey(name: 'existingGoals')  List<BudgetSuggestionGoalModel> existingGoals, @JsonKey(name: 'confidenceScore', fromJson: NumParser.parseDouble)  double confidenceScore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetSuggestionModel() when $default != null:
return $default(_that.averageMonthlySavings,_that.totalExistingBudget,_that.availableSavings,_that.requiredMonthly,_that.isSufficient,_that.deficit,_that.existingGoals,_that.confidenceScore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'averageMonthlySavings', fromJson: NumParser.parseDouble)  double averageMonthlySavings, @JsonKey(name: 'totalExistingBudget', fromJson: NumParser.parseDouble)  double totalExistingBudget, @JsonKey(name: 'availableSavings', fromJson: NumParser.parseDouble)  double availableSavings, @JsonKey(name: 'requiredMonthly', fromJson: NumParser.parseDouble)  double requiredMonthly, @JsonKey(name: 'isSufficient')  bool isSufficient, @JsonKey(name: 'deficit', fromJson: NumParser.parseDouble)  double deficit, @JsonKey(name: 'existingGoals')  List<BudgetSuggestionGoalModel> existingGoals, @JsonKey(name: 'confidenceScore', fromJson: NumParser.parseDouble)  double confidenceScore)  $default,) {final _that = this;
switch (_that) {
case _BudgetSuggestionModel():
return $default(_that.averageMonthlySavings,_that.totalExistingBudget,_that.availableSavings,_that.requiredMonthly,_that.isSufficient,_that.deficit,_that.existingGoals,_that.confidenceScore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'averageMonthlySavings', fromJson: NumParser.parseDouble)  double averageMonthlySavings, @JsonKey(name: 'totalExistingBudget', fromJson: NumParser.parseDouble)  double totalExistingBudget, @JsonKey(name: 'availableSavings', fromJson: NumParser.parseDouble)  double availableSavings, @JsonKey(name: 'requiredMonthly', fromJson: NumParser.parseDouble)  double requiredMonthly, @JsonKey(name: 'isSufficient')  bool isSufficient, @JsonKey(name: 'deficit', fromJson: NumParser.parseDouble)  double deficit, @JsonKey(name: 'existingGoals')  List<BudgetSuggestionGoalModel> existingGoals, @JsonKey(name: 'confidenceScore', fromJson: NumParser.parseDouble)  double confidenceScore)?  $default,) {final _that = this;
switch (_that) {
case _BudgetSuggestionModel() when $default != null:
return $default(_that.averageMonthlySavings,_that.totalExistingBudget,_that.availableSavings,_that.requiredMonthly,_that.isSufficient,_that.deficit,_that.existingGoals,_that.confidenceScore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BudgetSuggestionModel implements BudgetSuggestionModel {
  const _BudgetSuggestionModel({@JsonKey(name: 'averageMonthlySavings', fromJson: NumParser.parseDouble) required this.averageMonthlySavings, @JsonKey(name: 'totalExistingBudget', fromJson: NumParser.parseDouble) required this.totalExistingBudget, @JsonKey(name: 'availableSavings', fromJson: NumParser.parseDouble) required this.availableSavings, @JsonKey(name: 'requiredMonthly', fromJson: NumParser.parseDouble) required this.requiredMonthly, @JsonKey(name: 'isSufficient') required this.isSufficient, @JsonKey(name: 'deficit', fromJson: NumParser.parseDouble) required this.deficit, @JsonKey(name: 'existingGoals') required final  List<BudgetSuggestionGoalModel> existingGoals, @JsonKey(name: 'confidenceScore', fromJson: NumParser.parseDouble) required this.confidenceScore}): _existingGoals = existingGoals;
  factory _BudgetSuggestionModel.fromJson(Map<String, dynamic> json) => _$BudgetSuggestionModelFromJson(json);

@override@JsonKey(name: 'averageMonthlySavings', fromJson: NumParser.parseDouble) final  double averageMonthlySavings;
@override@JsonKey(name: 'totalExistingBudget', fromJson: NumParser.parseDouble) final  double totalExistingBudget;
@override@JsonKey(name: 'availableSavings', fromJson: NumParser.parseDouble) final  double availableSavings;
@override@JsonKey(name: 'requiredMonthly', fromJson: NumParser.parseDouble) final  double requiredMonthly;
@override@JsonKey(name: 'isSufficient') final  bool isSufficient;
@override@JsonKey(name: 'deficit', fromJson: NumParser.parseDouble) final  double deficit;
 final  List<BudgetSuggestionGoalModel> _existingGoals;
@override@JsonKey(name: 'existingGoals') List<BudgetSuggestionGoalModel> get existingGoals {
  if (_existingGoals is EqualUnmodifiableListView) return _existingGoals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_existingGoals);
}

@override@JsonKey(name: 'confidenceScore', fromJson: NumParser.parseDouble) final  double confidenceScore;

/// Create a copy of BudgetSuggestionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetSuggestionModelCopyWith<_BudgetSuggestionModel> get copyWith => __$BudgetSuggestionModelCopyWithImpl<_BudgetSuggestionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BudgetSuggestionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetSuggestionModel&&(identical(other.averageMonthlySavings, averageMonthlySavings) || other.averageMonthlySavings == averageMonthlySavings)&&(identical(other.totalExistingBudget, totalExistingBudget) || other.totalExistingBudget == totalExistingBudget)&&(identical(other.availableSavings, availableSavings) || other.availableSavings == availableSavings)&&(identical(other.requiredMonthly, requiredMonthly) || other.requiredMonthly == requiredMonthly)&&(identical(other.isSufficient, isSufficient) || other.isSufficient == isSufficient)&&(identical(other.deficit, deficit) || other.deficit == deficit)&&const DeepCollectionEquality().equals(other._existingGoals, _existingGoals)&&(identical(other.confidenceScore, confidenceScore) || other.confidenceScore == confidenceScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,averageMonthlySavings,totalExistingBudget,availableSavings,requiredMonthly,isSufficient,deficit,const DeepCollectionEquality().hash(_existingGoals),confidenceScore);

@override
String toString() {
  return 'BudgetSuggestionModel(averageMonthlySavings: $averageMonthlySavings, totalExistingBudget: $totalExistingBudget, availableSavings: $availableSavings, requiredMonthly: $requiredMonthly, isSufficient: $isSufficient, deficit: $deficit, existingGoals: $existingGoals, confidenceScore: $confidenceScore)';
}


}

/// @nodoc
abstract mixin class _$BudgetSuggestionModelCopyWith<$Res> implements $BudgetSuggestionModelCopyWith<$Res> {
  factory _$BudgetSuggestionModelCopyWith(_BudgetSuggestionModel value, $Res Function(_BudgetSuggestionModel) _then) = __$BudgetSuggestionModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'averageMonthlySavings', fromJson: NumParser.parseDouble) double averageMonthlySavings,@JsonKey(name: 'totalExistingBudget', fromJson: NumParser.parseDouble) double totalExistingBudget,@JsonKey(name: 'availableSavings', fromJson: NumParser.parseDouble) double availableSavings,@JsonKey(name: 'requiredMonthly', fromJson: NumParser.parseDouble) double requiredMonthly,@JsonKey(name: 'isSufficient') bool isSufficient,@JsonKey(name: 'deficit', fromJson: NumParser.parseDouble) double deficit,@JsonKey(name: 'existingGoals') List<BudgetSuggestionGoalModel> existingGoals,@JsonKey(name: 'confidenceScore', fromJson: NumParser.parseDouble) double confidenceScore
});




}
/// @nodoc
class __$BudgetSuggestionModelCopyWithImpl<$Res>
    implements _$BudgetSuggestionModelCopyWith<$Res> {
  __$BudgetSuggestionModelCopyWithImpl(this._self, this._then);

  final _BudgetSuggestionModel _self;
  final $Res Function(_BudgetSuggestionModel) _then;

/// Create a copy of BudgetSuggestionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? averageMonthlySavings = null,Object? totalExistingBudget = null,Object? availableSavings = null,Object? requiredMonthly = null,Object? isSufficient = null,Object? deficit = null,Object? existingGoals = null,Object? confidenceScore = null,}) {
  return _then(_BudgetSuggestionModel(
averageMonthlySavings: null == averageMonthlySavings ? _self.averageMonthlySavings : averageMonthlySavings // ignore: cast_nullable_to_non_nullable
as double,totalExistingBudget: null == totalExistingBudget ? _self.totalExistingBudget : totalExistingBudget // ignore: cast_nullable_to_non_nullable
as double,availableSavings: null == availableSavings ? _self.availableSavings : availableSavings // ignore: cast_nullable_to_non_nullable
as double,requiredMonthly: null == requiredMonthly ? _self.requiredMonthly : requiredMonthly // ignore: cast_nullable_to_non_nullable
as double,isSufficient: null == isSufficient ? _self.isSufficient : isSufficient // ignore: cast_nullable_to_non_nullable
as bool,deficit: null == deficit ? _self.deficit : deficit // ignore: cast_nullable_to_non_nullable
as double,existingGoals: null == existingGoals ? _self._existingGoals : existingGoals // ignore: cast_nullable_to_non_nullable
as List<BudgetSuggestionGoalModel>,confidenceScore: null == confidenceScore ? _self.confidenceScore : confidenceScore // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
