// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saving_goal_report_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MilestoneModel {

 String get label;@JsonKey(name: 'start_date') DateTime get startDate;@JsonKey(name: 'end_date') DateTime get endDate;@JsonKey(fromJson: NumParser.parseDouble) double get target;@JsonKey(fromJson: NumParser.parseDouble) double get actual;@JsonKey(name: 'is_completed') bool get isCompleted;
/// Create a copy of MilestoneModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MilestoneModelCopyWith<MilestoneModel> get copyWith => _$MilestoneModelCopyWithImpl<MilestoneModel>(this as MilestoneModel, _$identity);

  /// Serializes this MilestoneModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MilestoneModel&&(identical(other.label, label) || other.label == label)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.target, target) || other.target == target)&&(identical(other.actual, actual) || other.actual == actual)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,startDate,endDate,target,actual,isCompleted);

@override
String toString() {
  return 'MilestoneModel(label: $label, startDate: $startDate, endDate: $endDate, target: $target, actual: $actual, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class $MilestoneModelCopyWith<$Res>  {
  factory $MilestoneModelCopyWith(MilestoneModel value, $Res Function(MilestoneModel) _then) = _$MilestoneModelCopyWithImpl;
@useResult
$Res call({
 String label,@JsonKey(name: 'start_date') DateTime startDate,@JsonKey(name: 'end_date') DateTime endDate,@JsonKey(fromJson: NumParser.parseDouble) double target,@JsonKey(fromJson: NumParser.parseDouble) double actual,@JsonKey(name: 'is_completed') bool isCompleted
});




}
/// @nodoc
class _$MilestoneModelCopyWithImpl<$Res>
    implements $MilestoneModelCopyWith<$Res> {
  _$MilestoneModelCopyWithImpl(this._self, this._then);

  final MilestoneModel _self;
  final $Res Function(MilestoneModel) _then;

/// Create a copy of MilestoneModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? startDate = null,Object? endDate = null,Object? target = null,Object? actual = null,Object? isCompleted = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as double,actual: null == actual ? _self.actual : actual // ignore: cast_nullable_to_non_nullable
as double,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MilestoneModel].
extension MilestoneModelPatterns on MilestoneModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MilestoneModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MilestoneModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MilestoneModel value)  $default,){
final _that = this;
switch (_that) {
case _MilestoneModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MilestoneModel value)?  $default,){
final _that = this;
switch (_that) {
case _MilestoneModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label, @JsonKey(name: 'start_date')  DateTime startDate, @JsonKey(name: 'end_date')  DateTime endDate, @JsonKey(fromJson: NumParser.parseDouble)  double target, @JsonKey(fromJson: NumParser.parseDouble)  double actual, @JsonKey(name: 'is_completed')  bool isCompleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MilestoneModel() when $default != null:
return $default(_that.label,_that.startDate,_that.endDate,_that.target,_that.actual,_that.isCompleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label, @JsonKey(name: 'start_date')  DateTime startDate, @JsonKey(name: 'end_date')  DateTime endDate, @JsonKey(fromJson: NumParser.parseDouble)  double target, @JsonKey(fromJson: NumParser.parseDouble)  double actual, @JsonKey(name: 'is_completed')  bool isCompleted)  $default,) {final _that = this;
switch (_that) {
case _MilestoneModel():
return $default(_that.label,_that.startDate,_that.endDate,_that.target,_that.actual,_that.isCompleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label, @JsonKey(name: 'start_date')  DateTime startDate, @JsonKey(name: 'end_date')  DateTime endDate, @JsonKey(fromJson: NumParser.parseDouble)  double target, @JsonKey(fromJson: NumParser.parseDouble)  double actual, @JsonKey(name: 'is_completed')  bool isCompleted)?  $default,) {final _that = this;
switch (_that) {
case _MilestoneModel() when $default != null:
return $default(_that.label,_that.startDate,_that.endDate,_that.target,_that.actual,_that.isCompleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MilestoneModel implements MilestoneModel {
  const _MilestoneModel({required this.label, @JsonKey(name: 'start_date') required this.startDate, @JsonKey(name: 'end_date') required this.endDate, @JsonKey(fromJson: NumParser.parseDouble) this.target = 0, @JsonKey(fromJson: NumParser.parseDouble) this.actual = 0, @JsonKey(name: 'is_completed') this.isCompleted = false});
  factory _MilestoneModel.fromJson(Map<String, dynamic> json) => _$MilestoneModelFromJson(json);

@override final  String label;
@override@JsonKey(name: 'start_date') final  DateTime startDate;
@override@JsonKey(name: 'end_date') final  DateTime endDate;
@override@JsonKey(fromJson: NumParser.parseDouble) final  double target;
@override@JsonKey(fromJson: NumParser.parseDouble) final  double actual;
@override@JsonKey(name: 'is_completed') final  bool isCompleted;

/// Create a copy of MilestoneModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MilestoneModelCopyWith<_MilestoneModel> get copyWith => __$MilestoneModelCopyWithImpl<_MilestoneModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MilestoneModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MilestoneModel&&(identical(other.label, label) || other.label == label)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.target, target) || other.target == target)&&(identical(other.actual, actual) || other.actual == actual)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,startDate,endDate,target,actual,isCompleted);

@override
String toString() {
  return 'MilestoneModel(label: $label, startDate: $startDate, endDate: $endDate, target: $target, actual: $actual, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class _$MilestoneModelCopyWith<$Res> implements $MilestoneModelCopyWith<$Res> {
  factory _$MilestoneModelCopyWith(_MilestoneModel value, $Res Function(_MilestoneModel) _then) = __$MilestoneModelCopyWithImpl;
@override @useResult
$Res call({
 String label,@JsonKey(name: 'start_date') DateTime startDate,@JsonKey(name: 'end_date') DateTime endDate,@JsonKey(fromJson: NumParser.parseDouble) double target,@JsonKey(fromJson: NumParser.parseDouble) double actual,@JsonKey(name: 'is_completed') bool isCompleted
});




}
/// @nodoc
class __$MilestoneModelCopyWithImpl<$Res>
    implements _$MilestoneModelCopyWith<$Res> {
  __$MilestoneModelCopyWithImpl(this._self, this._then);

  final _MilestoneModel _self;
  final $Res Function(_MilestoneModel) _then;

/// Create a copy of MilestoneModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? startDate = null,Object? endDate = null,Object? target = null,Object? actual = null,Object? isCompleted = null,}) {
  return _then(_MilestoneModel(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as double,actual: null == actual ? _self.actual : actual // ignore: cast_nullable_to_non_nullable
as double,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$CategorySpendingModel {

@JsonKey(name: 'category_name') String get categoryName; int get percentage; double get total;
/// Create a copy of CategorySpendingModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategorySpendingModelCopyWith<CategorySpendingModel> get copyWith => _$CategorySpendingModelCopyWithImpl<CategorySpendingModel>(this as CategorySpendingModel, _$identity);

  /// Serializes this CategorySpendingModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategorySpendingModel&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryName,percentage,total);

@override
String toString() {
  return 'CategorySpendingModel(categoryName: $categoryName, percentage: $percentage, total: $total)';
}


}

/// @nodoc
abstract mixin class $CategorySpendingModelCopyWith<$Res>  {
  factory $CategorySpendingModelCopyWith(CategorySpendingModel value, $Res Function(CategorySpendingModel) _then) = _$CategorySpendingModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'category_name') String categoryName, int percentage, double total
});




}
/// @nodoc
class _$CategorySpendingModelCopyWithImpl<$Res>
    implements $CategorySpendingModelCopyWith<$Res> {
  _$CategorySpendingModelCopyWithImpl(this._self, this._then);

  final CategorySpendingModel _self;
  final $Res Function(CategorySpendingModel) _then;

/// Create a copy of CategorySpendingModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryName = null,Object? percentage = null,Object? total = null,}) {
  return _then(_self.copyWith(
categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [CategorySpendingModel].
extension CategorySpendingModelPatterns on CategorySpendingModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategorySpendingModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategorySpendingModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategorySpendingModel value)  $default,){
final _that = this;
switch (_that) {
case _CategorySpendingModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategorySpendingModel value)?  $default,){
final _that = this;
switch (_that) {
case _CategorySpendingModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'category_name')  String categoryName,  int percentage,  double total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategorySpendingModel() when $default != null:
return $default(_that.categoryName,_that.percentage,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'category_name')  String categoryName,  int percentage,  double total)  $default,) {final _that = this;
switch (_that) {
case _CategorySpendingModel():
return $default(_that.categoryName,_that.percentage,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'category_name')  String categoryName,  int percentage,  double total)?  $default,) {final _that = this;
switch (_that) {
case _CategorySpendingModel() when $default != null:
return $default(_that.categoryName,_that.percentage,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategorySpendingModel implements CategorySpendingModel {
  const _CategorySpendingModel({@JsonKey(name: 'category_name') required this.categoryName, this.percentage = 0, this.total = 0});
  factory _CategorySpendingModel.fromJson(Map<String, dynamic> json) => _$CategorySpendingModelFromJson(json);

@override@JsonKey(name: 'category_name') final  String categoryName;
@override@JsonKey() final  int percentage;
@override@JsonKey() final  double total;

/// Create a copy of CategorySpendingModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategorySpendingModelCopyWith<_CategorySpendingModel> get copyWith => __$CategorySpendingModelCopyWithImpl<_CategorySpendingModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategorySpendingModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategorySpendingModel&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryName,percentage,total);

@override
String toString() {
  return 'CategorySpendingModel(categoryName: $categoryName, percentage: $percentage, total: $total)';
}


}

/// @nodoc
abstract mixin class _$CategorySpendingModelCopyWith<$Res> implements $CategorySpendingModelCopyWith<$Res> {
  factory _$CategorySpendingModelCopyWith(_CategorySpendingModel value, $Res Function(_CategorySpendingModel) _then) = __$CategorySpendingModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'category_name') String categoryName, int percentage, double total
});




}
/// @nodoc
class __$CategorySpendingModelCopyWithImpl<$Res>
    implements _$CategorySpendingModelCopyWith<$Res> {
  __$CategorySpendingModelCopyWithImpl(this._self, this._then);

  final _CategorySpendingModel _self;
  final $Res Function(_CategorySpendingModel) _then;

/// Create a copy of CategorySpendingModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryName = null,Object? percentage = null,Object? total = null,}) {
  return _then(_CategorySpendingModel(
categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$SavingGoalReportModel {

@JsonKey(fromJson: NumParser.parseInt) int get id; String get name;@JsonKey(name: 'start_date') DateTime? get startDate;@JsonKey(name: 'end_date') DateTime? get endDate;@JsonKey(fromJson: NumParser.parseDouble) double get target;@JsonKey(name: 'current_balance', fromJson: NumParser.parseDouble) double get currentBalance;@JsonKey(name: 'progress_percent', fromJson: NumParser.parseInt) int get progressPercent;@JsonKey(name: 'is_completed') bool get isCompleted;@JsonKey(name: 'completion_notified') bool get completionNotified;@JsonKey(name: 'current_milestone_index', fromJson: NumParser.parseInt) int get currentMilestoneIndex; List<MilestoneModel> get milestones; int get balanceUsagePercentage; double get totalSpent; bool get isOverBudget; int get targetCompletionPercentage; bool get isTargetAchieved; List<CategorySpendingModel> get categoryBreakdown; int get totalTransactions; double get dailyAverageSpending; double get remainingBudget;
/// Create a copy of SavingGoalReportModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavingGoalReportModelCopyWith<SavingGoalReportModel> get copyWith => _$SavingGoalReportModelCopyWithImpl<SavingGoalReportModel>(this as SavingGoalReportModel, _$identity);

  /// Serializes this SavingGoalReportModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavingGoalReportModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.target, target) || other.target == target)&&(identical(other.currentBalance, currentBalance) || other.currentBalance == currentBalance)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.completionNotified, completionNotified) || other.completionNotified == completionNotified)&&(identical(other.currentMilestoneIndex, currentMilestoneIndex) || other.currentMilestoneIndex == currentMilestoneIndex)&&const DeepCollectionEquality().equals(other.milestones, milestones)&&(identical(other.balanceUsagePercentage, balanceUsagePercentage) || other.balanceUsagePercentage == balanceUsagePercentage)&&(identical(other.totalSpent, totalSpent) || other.totalSpent == totalSpent)&&(identical(other.isOverBudget, isOverBudget) || other.isOverBudget == isOverBudget)&&(identical(other.targetCompletionPercentage, targetCompletionPercentage) || other.targetCompletionPercentage == targetCompletionPercentage)&&(identical(other.isTargetAchieved, isTargetAchieved) || other.isTargetAchieved == isTargetAchieved)&&const DeepCollectionEquality().equals(other.categoryBreakdown, categoryBreakdown)&&(identical(other.totalTransactions, totalTransactions) || other.totalTransactions == totalTransactions)&&(identical(other.dailyAverageSpending, dailyAverageSpending) || other.dailyAverageSpending == dailyAverageSpending)&&(identical(other.remainingBudget, remainingBudget) || other.remainingBudget == remainingBudget));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,startDate,endDate,target,currentBalance,progressPercent,isCompleted,completionNotified,currentMilestoneIndex,const DeepCollectionEquality().hash(milestones),balanceUsagePercentage,totalSpent,isOverBudget,targetCompletionPercentage,isTargetAchieved,const DeepCollectionEquality().hash(categoryBreakdown),totalTransactions,dailyAverageSpending,remainingBudget]);

@override
String toString() {
  return 'SavingGoalReportModel(id: $id, name: $name, startDate: $startDate, endDate: $endDate, target: $target, currentBalance: $currentBalance, progressPercent: $progressPercent, isCompleted: $isCompleted, completionNotified: $completionNotified, currentMilestoneIndex: $currentMilestoneIndex, milestones: $milestones, balanceUsagePercentage: $balanceUsagePercentage, totalSpent: $totalSpent, isOverBudget: $isOverBudget, targetCompletionPercentage: $targetCompletionPercentage, isTargetAchieved: $isTargetAchieved, categoryBreakdown: $categoryBreakdown, totalTransactions: $totalTransactions, dailyAverageSpending: $dailyAverageSpending, remainingBudget: $remainingBudget)';
}


}

/// @nodoc
abstract mixin class $SavingGoalReportModelCopyWith<$Res>  {
  factory $SavingGoalReportModelCopyWith(SavingGoalReportModel value, $Res Function(SavingGoalReportModel) _then) = _$SavingGoalReportModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: NumParser.parseInt) int id, String name,@JsonKey(name: 'start_date') DateTime? startDate,@JsonKey(name: 'end_date') DateTime? endDate,@JsonKey(fromJson: NumParser.parseDouble) double target,@JsonKey(name: 'current_balance', fromJson: NumParser.parseDouble) double currentBalance,@JsonKey(name: 'progress_percent', fromJson: NumParser.parseInt) int progressPercent,@JsonKey(name: 'is_completed') bool isCompleted,@JsonKey(name: 'completion_notified') bool completionNotified,@JsonKey(name: 'current_milestone_index', fromJson: NumParser.parseInt) int currentMilestoneIndex, List<MilestoneModel> milestones, int balanceUsagePercentage, double totalSpent, bool isOverBudget, int targetCompletionPercentage, bool isTargetAchieved, List<CategorySpendingModel> categoryBreakdown, int totalTransactions, double dailyAverageSpending, double remainingBudget
});




}
/// @nodoc
class _$SavingGoalReportModelCopyWithImpl<$Res>
    implements $SavingGoalReportModelCopyWith<$Res> {
  _$SavingGoalReportModelCopyWithImpl(this._self, this._then);

  final SavingGoalReportModel _self;
  final $Res Function(SavingGoalReportModel) _then;

/// Create a copy of SavingGoalReportModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? startDate = freezed,Object? endDate = freezed,Object? target = null,Object? currentBalance = null,Object? progressPercent = null,Object? isCompleted = null,Object? completionNotified = null,Object? currentMilestoneIndex = null,Object? milestones = null,Object? balanceUsagePercentage = null,Object? totalSpent = null,Object? isOverBudget = null,Object? targetCompletionPercentage = null,Object? isTargetAchieved = null,Object? categoryBreakdown = null,Object? totalTransactions = null,Object? dailyAverageSpending = null,Object? remainingBudget = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as double,currentBalance: null == currentBalance ? _self.currentBalance : currentBalance // ignore: cast_nullable_to_non_nullable
as double,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,completionNotified: null == completionNotified ? _self.completionNotified : completionNotified // ignore: cast_nullable_to_non_nullable
as bool,currentMilestoneIndex: null == currentMilestoneIndex ? _self.currentMilestoneIndex : currentMilestoneIndex // ignore: cast_nullable_to_non_nullable
as int,milestones: null == milestones ? _self.milestones : milestones // ignore: cast_nullable_to_non_nullable
as List<MilestoneModel>,balanceUsagePercentage: null == balanceUsagePercentage ? _self.balanceUsagePercentage : balanceUsagePercentage // ignore: cast_nullable_to_non_nullable
as int,totalSpent: null == totalSpent ? _self.totalSpent : totalSpent // ignore: cast_nullable_to_non_nullable
as double,isOverBudget: null == isOverBudget ? _self.isOverBudget : isOverBudget // ignore: cast_nullable_to_non_nullable
as bool,targetCompletionPercentage: null == targetCompletionPercentage ? _self.targetCompletionPercentage : targetCompletionPercentage // ignore: cast_nullable_to_non_nullable
as int,isTargetAchieved: null == isTargetAchieved ? _self.isTargetAchieved : isTargetAchieved // ignore: cast_nullable_to_non_nullable
as bool,categoryBreakdown: null == categoryBreakdown ? _self.categoryBreakdown : categoryBreakdown // ignore: cast_nullable_to_non_nullable
as List<CategorySpendingModel>,totalTransactions: null == totalTransactions ? _self.totalTransactions : totalTransactions // ignore: cast_nullable_to_non_nullable
as int,dailyAverageSpending: null == dailyAverageSpending ? _self.dailyAverageSpending : dailyAverageSpending // ignore: cast_nullable_to_non_nullable
as double,remainingBudget: null == remainingBudget ? _self.remainingBudget : remainingBudget // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [SavingGoalReportModel].
extension SavingGoalReportModelPatterns on SavingGoalReportModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavingGoalReportModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavingGoalReportModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavingGoalReportModel value)  $default,){
final _that = this;
switch (_that) {
case _SavingGoalReportModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavingGoalReportModel value)?  $default,){
final _that = this;
switch (_that) {
case _SavingGoalReportModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NumParser.parseInt)  int id,  String name, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate, @JsonKey(fromJson: NumParser.parseDouble)  double target, @JsonKey(name: 'current_balance', fromJson: NumParser.parseDouble)  double currentBalance, @JsonKey(name: 'progress_percent', fromJson: NumParser.parseInt)  int progressPercent, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'completion_notified')  bool completionNotified, @JsonKey(name: 'current_milestone_index', fromJson: NumParser.parseInt)  int currentMilestoneIndex,  List<MilestoneModel> milestones,  int balanceUsagePercentage,  double totalSpent,  bool isOverBudget,  int targetCompletionPercentage,  bool isTargetAchieved,  List<CategorySpendingModel> categoryBreakdown,  int totalTransactions,  double dailyAverageSpending,  double remainingBudget)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavingGoalReportModel() when $default != null:
return $default(_that.id,_that.name,_that.startDate,_that.endDate,_that.target,_that.currentBalance,_that.progressPercent,_that.isCompleted,_that.completionNotified,_that.currentMilestoneIndex,_that.milestones,_that.balanceUsagePercentage,_that.totalSpent,_that.isOverBudget,_that.targetCompletionPercentage,_that.isTargetAchieved,_that.categoryBreakdown,_that.totalTransactions,_that.dailyAverageSpending,_that.remainingBudget);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NumParser.parseInt)  int id,  String name, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate, @JsonKey(fromJson: NumParser.parseDouble)  double target, @JsonKey(name: 'current_balance', fromJson: NumParser.parseDouble)  double currentBalance, @JsonKey(name: 'progress_percent', fromJson: NumParser.parseInt)  int progressPercent, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'completion_notified')  bool completionNotified, @JsonKey(name: 'current_milestone_index', fromJson: NumParser.parseInt)  int currentMilestoneIndex,  List<MilestoneModel> milestones,  int balanceUsagePercentage,  double totalSpent,  bool isOverBudget,  int targetCompletionPercentage,  bool isTargetAchieved,  List<CategorySpendingModel> categoryBreakdown,  int totalTransactions,  double dailyAverageSpending,  double remainingBudget)  $default,) {final _that = this;
switch (_that) {
case _SavingGoalReportModel():
return $default(_that.id,_that.name,_that.startDate,_that.endDate,_that.target,_that.currentBalance,_that.progressPercent,_that.isCompleted,_that.completionNotified,_that.currentMilestoneIndex,_that.milestones,_that.balanceUsagePercentage,_that.totalSpent,_that.isOverBudget,_that.targetCompletionPercentage,_that.isTargetAchieved,_that.categoryBreakdown,_that.totalTransactions,_that.dailyAverageSpending,_that.remainingBudget);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: NumParser.parseInt)  int id,  String name, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate, @JsonKey(fromJson: NumParser.parseDouble)  double target, @JsonKey(name: 'current_balance', fromJson: NumParser.parseDouble)  double currentBalance, @JsonKey(name: 'progress_percent', fromJson: NumParser.parseInt)  int progressPercent, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'completion_notified')  bool completionNotified, @JsonKey(name: 'current_milestone_index', fromJson: NumParser.parseInt)  int currentMilestoneIndex,  List<MilestoneModel> milestones,  int balanceUsagePercentage,  double totalSpent,  bool isOverBudget,  int targetCompletionPercentage,  bool isTargetAchieved,  List<CategorySpendingModel> categoryBreakdown,  int totalTransactions,  double dailyAverageSpending,  double remainingBudget)?  $default,) {final _that = this;
switch (_that) {
case _SavingGoalReportModel() when $default != null:
return $default(_that.id,_that.name,_that.startDate,_that.endDate,_that.target,_that.currentBalance,_that.progressPercent,_that.isCompleted,_that.completionNotified,_that.currentMilestoneIndex,_that.milestones,_that.balanceUsagePercentage,_that.totalSpent,_that.isOverBudget,_that.targetCompletionPercentage,_that.isTargetAchieved,_that.categoryBreakdown,_that.totalTransactions,_that.dailyAverageSpending,_that.remainingBudget);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SavingGoalReportModel implements SavingGoalReportModel {
  const _SavingGoalReportModel({@JsonKey(fromJson: NumParser.parseInt) required this.id, required this.name, @JsonKey(name: 'start_date') this.startDate, @JsonKey(name: 'end_date') this.endDate, @JsonKey(fromJson: NumParser.parseDouble) this.target = 0, @JsonKey(name: 'current_balance', fromJson: NumParser.parseDouble) this.currentBalance = 0, @JsonKey(name: 'progress_percent', fromJson: NumParser.parseInt) this.progressPercent = 0, @JsonKey(name: 'is_completed') this.isCompleted = false, @JsonKey(name: 'completion_notified') this.completionNotified = false, @JsonKey(name: 'current_milestone_index', fromJson: NumParser.parseInt) this.currentMilestoneIndex = -1, final  List<MilestoneModel> milestones = const [], this.balanceUsagePercentage = 0, this.totalSpent = 0, this.isOverBudget = false, this.targetCompletionPercentage = 0, this.isTargetAchieved = false, final  List<CategorySpendingModel> categoryBreakdown = const [], this.totalTransactions = 0, this.dailyAverageSpending = 0, this.remainingBudget = 0}): _milestones = milestones,_categoryBreakdown = categoryBreakdown;
  factory _SavingGoalReportModel.fromJson(Map<String, dynamic> json) => _$SavingGoalReportModelFromJson(json);

@override@JsonKey(fromJson: NumParser.parseInt) final  int id;
@override final  String name;
@override@JsonKey(name: 'start_date') final  DateTime? startDate;
@override@JsonKey(name: 'end_date') final  DateTime? endDate;
@override@JsonKey(fromJson: NumParser.parseDouble) final  double target;
@override@JsonKey(name: 'current_balance', fromJson: NumParser.parseDouble) final  double currentBalance;
@override@JsonKey(name: 'progress_percent', fromJson: NumParser.parseInt) final  int progressPercent;
@override@JsonKey(name: 'is_completed') final  bool isCompleted;
@override@JsonKey(name: 'completion_notified') final  bool completionNotified;
@override@JsonKey(name: 'current_milestone_index', fromJson: NumParser.parseInt) final  int currentMilestoneIndex;
 final  List<MilestoneModel> _milestones;
@override@JsonKey() List<MilestoneModel> get milestones {
  if (_milestones is EqualUnmodifiableListView) return _milestones;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_milestones);
}

@override@JsonKey() final  int balanceUsagePercentage;
@override@JsonKey() final  double totalSpent;
@override@JsonKey() final  bool isOverBudget;
@override@JsonKey() final  int targetCompletionPercentage;
@override@JsonKey() final  bool isTargetAchieved;
 final  List<CategorySpendingModel> _categoryBreakdown;
@override@JsonKey() List<CategorySpendingModel> get categoryBreakdown {
  if (_categoryBreakdown is EqualUnmodifiableListView) return _categoryBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categoryBreakdown);
}

@override@JsonKey() final  int totalTransactions;
@override@JsonKey() final  double dailyAverageSpending;
@override@JsonKey() final  double remainingBudget;

/// Create a copy of SavingGoalReportModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavingGoalReportModelCopyWith<_SavingGoalReportModel> get copyWith => __$SavingGoalReportModelCopyWithImpl<_SavingGoalReportModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SavingGoalReportModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavingGoalReportModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.target, target) || other.target == target)&&(identical(other.currentBalance, currentBalance) || other.currentBalance == currentBalance)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.completionNotified, completionNotified) || other.completionNotified == completionNotified)&&(identical(other.currentMilestoneIndex, currentMilestoneIndex) || other.currentMilestoneIndex == currentMilestoneIndex)&&const DeepCollectionEquality().equals(other._milestones, _milestones)&&(identical(other.balanceUsagePercentage, balanceUsagePercentage) || other.balanceUsagePercentage == balanceUsagePercentage)&&(identical(other.totalSpent, totalSpent) || other.totalSpent == totalSpent)&&(identical(other.isOverBudget, isOverBudget) || other.isOverBudget == isOverBudget)&&(identical(other.targetCompletionPercentage, targetCompletionPercentage) || other.targetCompletionPercentage == targetCompletionPercentage)&&(identical(other.isTargetAchieved, isTargetAchieved) || other.isTargetAchieved == isTargetAchieved)&&const DeepCollectionEquality().equals(other._categoryBreakdown, _categoryBreakdown)&&(identical(other.totalTransactions, totalTransactions) || other.totalTransactions == totalTransactions)&&(identical(other.dailyAverageSpending, dailyAverageSpending) || other.dailyAverageSpending == dailyAverageSpending)&&(identical(other.remainingBudget, remainingBudget) || other.remainingBudget == remainingBudget));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,startDate,endDate,target,currentBalance,progressPercent,isCompleted,completionNotified,currentMilestoneIndex,const DeepCollectionEquality().hash(_milestones),balanceUsagePercentage,totalSpent,isOverBudget,targetCompletionPercentage,isTargetAchieved,const DeepCollectionEquality().hash(_categoryBreakdown),totalTransactions,dailyAverageSpending,remainingBudget]);

@override
String toString() {
  return 'SavingGoalReportModel(id: $id, name: $name, startDate: $startDate, endDate: $endDate, target: $target, currentBalance: $currentBalance, progressPercent: $progressPercent, isCompleted: $isCompleted, completionNotified: $completionNotified, currentMilestoneIndex: $currentMilestoneIndex, milestones: $milestones, balanceUsagePercentage: $balanceUsagePercentage, totalSpent: $totalSpent, isOverBudget: $isOverBudget, targetCompletionPercentage: $targetCompletionPercentage, isTargetAchieved: $isTargetAchieved, categoryBreakdown: $categoryBreakdown, totalTransactions: $totalTransactions, dailyAverageSpending: $dailyAverageSpending, remainingBudget: $remainingBudget)';
}


}

/// @nodoc
abstract mixin class _$SavingGoalReportModelCopyWith<$Res> implements $SavingGoalReportModelCopyWith<$Res> {
  factory _$SavingGoalReportModelCopyWith(_SavingGoalReportModel value, $Res Function(_SavingGoalReportModel) _then) = __$SavingGoalReportModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: NumParser.parseInt) int id, String name,@JsonKey(name: 'start_date') DateTime? startDate,@JsonKey(name: 'end_date') DateTime? endDate,@JsonKey(fromJson: NumParser.parseDouble) double target,@JsonKey(name: 'current_balance', fromJson: NumParser.parseDouble) double currentBalance,@JsonKey(name: 'progress_percent', fromJson: NumParser.parseInt) int progressPercent,@JsonKey(name: 'is_completed') bool isCompleted,@JsonKey(name: 'completion_notified') bool completionNotified,@JsonKey(name: 'current_milestone_index', fromJson: NumParser.parseInt) int currentMilestoneIndex, List<MilestoneModel> milestones, int balanceUsagePercentage, double totalSpent, bool isOverBudget, int targetCompletionPercentage, bool isTargetAchieved, List<CategorySpendingModel> categoryBreakdown, int totalTransactions, double dailyAverageSpending, double remainingBudget
});




}
/// @nodoc
class __$SavingGoalReportModelCopyWithImpl<$Res>
    implements _$SavingGoalReportModelCopyWith<$Res> {
  __$SavingGoalReportModelCopyWithImpl(this._self, this._then);

  final _SavingGoalReportModel _self;
  final $Res Function(_SavingGoalReportModel) _then;

/// Create a copy of SavingGoalReportModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? startDate = freezed,Object? endDate = freezed,Object? target = null,Object? currentBalance = null,Object? progressPercent = null,Object? isCompleted = null,Object? completionNotified = null,Object? currentMilestoneIndex = null,Object? milestones = null,Object? balanceUsagePercentage = null,Object? totalSpent = null,Object? isOverBudget = null,Object? targetCompletionPercentage = null,Object? isTargetAchieved = null,Object? categoryBreakdown = null,Object? totalTransactions = null,Object? dailyAverageSpending = null,Object? remainingBudget = null,}) {
  return _then(_SavingGoalReportModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as double,currentBalance: null == currentBalance ? _self.currentBalance : currentBalance // ignore: cast_nullable_to_non_nullable
as double,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,completionNotified: null == completionNotified ? _self.completionNotified : completionNotified // ignore: cast_nullable_to_non_nullable
as bool,currentMilestoneIndex: null == currentMilestoneIndex ? _self.currentMilestoneIndex : currentMilestoneIndex // ignore: cast_nullable_to_non_nullable
as int,milestones: null == milestones ? _self._milestones : milestones // ignore: cast_nullable_to_non_nullable
as List<MilestoneModel>,balanceUsagePercentage: null == balanceUsagePercentage ? _self.balanceUsagePercentage : balanceUsagePercentage // ignore: cast_nullable_to_non_nullable
as int,totalSpent: null == totalSpent ? _self.totalSpent : totalSpent // ignore: cast_nullable_to_non_nullable
as double,isOverBudget: null == isOverBudget ? _self.isOverBudget : isOverBudget // ignore: cast_nullable_to_non_nullable
as bool,targetCompletionPercentage: null == targetCompletionPercentage ? _self.targetCompletionPercentage : targetCompletionPercentage // ignore: cast_nullable_to_non_nullable
as int,isTargetAchieved: null == isTargetAchieved ? _self.isTargetAchieved : isTargetAchieved // ignore: cast_nullable_to_non_nullable
as bool,categoryBreakdown: null == categoryBreakdown ? _self._categoryBreakdown : categoryBreakdown // ignore: cast_nullable_to_non_nullable
as List<CategorySpendingModel>,totalTransactions: null == totalTransactions ? _self.totalTransactions : totalTransactions // ignore: cast_nullable_to_non_nullable
as int,dailyAverageSpending: null == dailyAverageSpending ? _self.dailyAverageSpending : dailyAverageSpending // ignore: cast_nullable_to_non_nullable
as double,remainingBudget: null == remainingBudget ? _self.remainingBudget : remainingBudget // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
