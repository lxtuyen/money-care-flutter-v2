// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fund_report_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategorySpendingModel {

@JsonKey(name: 'category_id') int get categoryId;@JsonKey(name: 'category_name') String get categoryName;@JsonKey(name: 'total_spent') double get totalSpent;@JsonKey(name: 'transaction_count') int get transactionCount; int get percentage;
/// Create a copy of CategorySpendingModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategorySpendingModelCopyWith<CategorySpendingModel> get copyWith => _$CategorySpendingModelCopyWithImpl<CategorySpendingModel>(this as CategorySpendingModel, _$identity);

  /// Serializes this CategorySpendingModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategorySpendingModel&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.totalSpent, totalSpent) || other.totalSpent == totalSpent)&&(identical(other.transactionCount, transactionCount) || other.transactionCount == transactionCount)&&(identical(other.percentage, percentage) || other.percentage == percentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,categoryName,totalSpent,transactionCount,percentage);

@override
String toString() {
  return 'CategorySpendingModel(categoryId: $categoryId, categoryName: $categoryName, totalSpent: $totalSpent, transactionCount: $transactionCount, percentage: $percentage)';
}


}

/// @nodoc
abstract mixin class $CategorySpendingModelCopyWith<$Res>  {
  factory $CategorySpendingModelCopyWith(CategorySpendingModel value, $Res Function(CategorySpendingModel) _then) = _$CategorySpendingModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'category_id') int categoryId,@JsonKey(name: 'category_name') String categoryName,@JsonKey(name: 'total_spent') double totalSpent,@JsonKey(name: 'transaction_count') int transactionCount, int percentage
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
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? categoryName = null,Object? totalSpent = null,Object? transactionCount = null,Object? percentage = null,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,totalSpent: null == totalSpent ? _self.totalSpent : totalSpent // ignore: cast_nullable_to_non_nullable
as double,transactionCount: null == transactionCount ? _self.transactionCount : transactionCount // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as int,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'category_name')  String categoryName, @JsonKey(name: 'total_spent')  double totalSpent, @JsonKey(name: 'transaction_count')  int transactionCount,  int percentage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategorySpendingModel() when $default != null:
return $default(_that.categoryId,_that.categoryName,_that.totalSpent,_that.transactionCount,_that.percentage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'category_name')  String categoryName, @JsonKey(name: 'total_spent')  double totalSpent, @JsonKey(name: 'transaction_count')  int transactionCount,  int percentage)  $default,) {final _that = this;
switch (_that) {
case _CategorySpendingModel():
return $default(_that.categoryId,_that.categoryName,_that.totalSpent,_that.transactionCount,_that.percentage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'category_name')  String categoryName, @JsonKey(name: 'total_spent')  double totalSpent, @JsonKey(name: 'transaction_count')  int transactionCount,  int percentage)?  $default,) {final _that = this;
switch (_that) {
case _CategorySpendingModel() when $default != null:
return $default(_that.categoryId,_that.categoryName,_that.totalSpent,_that.transactionCount,_that.percentage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategorySpendingModel implements CategorySpendingModel {
  const _CategorySpendingModel({@JsonKey(name: 'category_id') required this.categoryId, @JsonKey(name: 'category_name') required this.categoryName, @JsonKey(name: 'total_spent') this.totalSpent = 0, @JsonKey(name: 'transaction_count') this.transactionCount = 0, this.percentage = 0});
  factory _CategorySpendingModel.fromJson(Map<String, dynamic> json) => _$CategorySpendingModelFromJson(json);

@override@JsonKey(name: 'category_id') final  int categoryId;
@override@JsonKey(name: 'category_name') final  String categoryName;
@override@JsonKey(name: 'total_spent') final  double totalSpent;
@override@JsonKey(name: 'transaction_count') final  int transactionCount;
@override@JsonKey() final  int percentage;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategorySpendingModel&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.totalSpent, totalSpent) || other.totalSpent == totalSpent)&&(identical(other.transactionCount, transactionCount) || other.transactionCount == transactionCount)&&(identical(other.percentage, percentage) || other.percentage == percentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,categoryName,totalSpent,transactionCount,percentage);

@override
String toString() {
  return 'CategorySpendingModel(categoryId: $categoryId, categoryName: $categoryName, totalSpent: $totalSpent, transactionCount: $transactionCount, percentage: $percentage)';
}


}

/// @nodoc
abstract mixin class _$CategorySpendingModelCopyWith<$Res> implements $CategorySpendingModelCopyWith<$Res> {
  factory _$CategorySpendingModelCopyWith(_CategorySpendingModel value, $Res Function(_CategorySpendingModel) _then) = __$CategorySpendingModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'category_id') int categoryId,@JsonKey(name: 'category_name') String categoryName,@JsonKey(name: 'total_spent') double totalSpent,@JsonKey(name: 'transaction_count') int transactionCount, int percentage
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
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? categoryName = null,Object? totalSpent = null,Object? transactionCount = null,Object? percentage = null,}) {
  return _then(_CategorySpendingModel(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,totalSpent: null == totalSpent ? _self.totalSpent : totalSpent // ignore: cast_nullable_to_non_nullable
as double,transactionCount: null == transactionCount ? _self.transactionCount : transactionCount // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$FundReportModel {

@JsonKey(name: 'fund_id') int get fundId;@JsonKey(name: 'fund_name') String get fundName;@JsonKey(name: 'start_date') DateTime? get startDate;@JsonKey(name: 'end_date') DateTime? get endDate; String get status; double get balance; double get target;@JsonKey(name: 'total_spent') double get totalSpent;@JsonKey(name: 'remaining_balance') double get remainingBudget;@JsonKey(name: 'balance_usage_percentage') int get balanceUsagePercentage;@JsonKey(name: 'target_completion_percentage') int get targetCompletionPercentage;@JsonKey(name: 'is_over_balance') bool get isOverBudget;@JsonKey(name: 'is_target_achieved') bool get isTargetAchieved;@JsonKey(name: 'category_breakdown') List<CategorySpendingModel> get categoryBreakdown;@JsonKey(name: 'total_transactions') int get totalTransactions;@JsonKey(name: 'average_transaction_amount') double get averageTransactionAmount;@JsonKey(name: 'duration_days') int get durationDays;@JsonKey(name: 'daily_average_spending') double get dailyAverageSpending;
/// Create a copy of FundReportModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FundReportModelCopyWith<FundReportModel> get copyWith => _$FundReportModelCopyWithImpl<FundReportModel>(this as FundReportModel, _$identity);

  /// Serializes this FundReportModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FundReportModel&&(identical(other.fundId, fundId) || other.fundId == fundId)&&(identical(other.fundName, fundName) || other.fundName == fundName)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.target, target) || other.target == target)&&(identical(other.totalSpent, totalSpent) || other.totalSpent == totalSpent)&&(identical(other.remainingBudget, remainingBudget) || other.remainingBudget == remainingBudget)&&(identical(other.balanceUsagePercentage, balanceUsagePercentage) || other.balanceUsagePercentage == balanceUsagePercentage)&&(identical(other.targetCompletionPercentage, targetCompletionPercentage) || other.targetCompletionPercentage == targetCompletionPercentage)&&(identical(other.isOverBudget, isOverBudget) || other.isOverBudget == isOverBudget)&&(identical(other.isTargetAchieved, isTargetAchieved) || other.isTargetAchieved == isTargetAchieved)&&const DeepCollectionEquality().equals(other.categoryBreakdown, categoryBreakdown)&&(identical(other.totalTransactions, totalTransactions) || other.totalTransactions == totalTransactions)&&(identical(other.averageTransactionAmount, averageTransactionAmount) || other.averageTransactionAmount == averageTransactionAmount)&&(identical(other.durationDays, durationDays) || other.durationDays == durationDays)&&(identical(other.dailyAverageSpending, dailyAverageSpending) || other.dailyAverageSpending == dailyAverageSpending));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fundId,fundName,startDate,endDate,status,balance,target,totalSpent,remainingBudget,balanceUsagePercentage,targetCompletionPercentage,isOverBudget,isTargetAchieved,const DeepCollectionEquality().hash(categoryBreakdown),totalTransactions,averageTransactionAmount,durationDays,dailyAverageSpending);

@override
String toString() {
  return 'FundReportModel(fundId: $fundId, fundName: $fundName, startDate: $startDate, endDate: $endDate, status: $status, balance: $balance, target: $target, totalSpent: $totalSpent, remainingBudget: $remainingBudget, balanceUsagePercentage: $balanceUsagePercentage, targetCompletionPercentage: $targetCompletionPercentage, isOverBudget: $isOverBudget, isTargetAchieved: $isTargetAchieved, categoryBreakdown: $categoryBreakdown, totalTransactions: $totalTransactions, averageTransactionAmount: $averageTransactionAmount, durationDays: $durationDays, dailyAverageSpending: $dailyAverageSpending)';
}


}

/// @nodoc
abstract mixin class $FundReportModelCopyWith<$Res>  {
  factory $FundReportModelCopyWith(FundReportModel value, $Res Function(FundReportModel) _then) = _$FundReportModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'fund_id') int fundId,@JsonKey(name: 'fund_name') String fundName,@JsonKey(name: 'start_date') DateTime? startDate,@JsonKey(name: 'end_date') DateTime? endDate, String status, double balance, double target,@JsonKey(name: 'total_spent') double totalSpent,@JsonKey(name: 'remaining_balance') double remainingBudget,@JsonKey(name: 'balance_usage_percentage') int balanceUsagePercentage,@JsonKey(name: 'target_completion_percentage') int targetCompletionPercentage,@JsonKey(name: 'is_over_balance') bool isOverBudget,@JsonKey(name: 'is_target_achieved') bool isTargetAchieved,@JsonKey(name: 'category_breakdown') List<CategorySpendingModel> categoryBreakdown,@JsonKey(name: 'total_transactions') int totalTransactions,@JsonKey(name: 'average_transaction_amount') double averageTransactionAmount,@JsonKey(name: 'duration_days') int durationDays,@JsonKey(name: 'daily_average_spending') double dailyAverageSpending
});




}
/// @nodoc
class _$FundReportModelCopyWithImpl<$Res>
    implements $FundReportModelCopyWith<$Res> {
  _$FundReportModelCopyWithImpl(this._self, this._then);

  final FundReportModel _self;
  final $Res Function(FundReportModel) _then;

/// Create a copy of FundReportModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fundId = null,Object? fundName = null,Object? startDate = freezed,Object? endDate = freezed,Object? status = null,Object? balance = null,Object? target = null,Object? totalSpent = null,Object? remainingBudget = null,Object? balanceUsagePercentage = null,Object? targetCompletionPercentage = null,Object? isOverBudget = null,Object? isTargetAchieved = null,Object? categoryBreakdown = null,Object? totalTransactions = null,Object? averageTransactionAmount = null,Object? durationDays = null,Object? dailyAverageSpending = null,}) {
  return _then(_self.copyWith(
fundId: null == fundId ? _self.fundId : fundId // ignore: cast_nullable_to_non_nullable
as int,fundName: null == fundName ? _self.fundName : fundName // ignore: cast_nullable_to_non_nullable
as String,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as double,totalSpent: null == totalSpent ? _self.totalSpent : totalSpent // ignore: cast_nullable_to_non_nullable
as double,remainingBudget: null == remainingBudget ? _self.remainingBudget : remainingBudget // ignore: cast_nullable_to_non_nullable
as double,balanceUsagePercentage: null == balanceUsagePercentage ? _self.balanceUsagePercentage : balanceUsagePercentage // ignore: cast_nullable_to_non_nullable
as int,targetCompletionPercentage: null == targetCompletionPercentage ? _self.targetCompletionPercentage : targetCompletionPercentage // ignore: cast_nullable_to_non_nullable
as int,isOverBudget: null == isOverBudget ? _self.isOverBudget : isOverBudget // ignore: cast_nullable_to_non_nullable
as bool,isTargetAchieved: null == isTargetAchieved ? _self.isTargetAchieved : isTargetAchieved // ignore: cast_nullable_to_non_nullable
as bool,categoryBreakdown: null == categoryBreakdown ? _self.categoryBreakdown : categoryBreakdown // ignore: cast_nullable_to_non_nullable
as List<CategorySpendingModel>,totalTransactions: null == totalTransactions ? _self.totalTransactions : totalTransactions // ignore: cast_nullable_to_non_nullable
as int,averageTransactionAmount: null == averageTransactionAmount ? _self.averageTransactionAmount : averageTransactionAmount // ignore: cast_nullable_to_non_nullable
as double,durationDays: null == durationDays ? _self.durationDays : durationDays // ignore: cast_nullable_to_non_nullable
as int,dailyAverageSpending: null == dailyAverageSpending ? _self.dailyAverageSpending : dailyAverageSpending // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [FundReportModel].
extension FundReportModelPatterns on FundReportModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FundReportModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FundReportModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FundReportModel value)  $default,){
final _that = this;
switch (_that) {
case _FundReportModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FundReportModel value)?  $default,){
final _that = this;
switch (_that) {
case _FundReportModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'fund_id')  int fundId, @JsonKey(name: 'fund_name')  String fundName, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate,  String status,  double balance,  double target, @JsonKey(name: 'total_spent')  double totalSpent, @JsonKey(name: 'remaining_balance')  double remainingBudget, @JsonKey(name: 'balance_usage_percentage')  int balanceUsagePercentage, @JsonKey(name: 'target_completion_percentage')  int targetCompletionPercentage, @JsonKey(name: 'is_over_balance')  bool isOverBudget, @JsonKey(name: 'is_target_achieved')  bool isTargetAchieved, @JsonKey(name: 'category_breakdown')  List<CategorySpendingModel> categoryBreakdown, @JsonKey(name: 'total_transactions')  int totalTransactions, @JsonKey(name: 'average_transaction_amount')  double averageTransactionAmount, @JsonKey(name: 'duration_days')  int durationDays, @JsonKey(name: 'daily_average_spending')  double dailyAverageSpending)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FundReportModel() when $default != null:
return $default(_that.fundId,_that.fundName,_that.startDate,_that.endDate,_that.status,_that.balance,_that.target,_that.totalSpent,_that.remainingBudget,_that.balanceUsagePercentage,_that.targetCompletionPercentage,_that.isOverBudget,_that.isTargetAchieved,_that.categoryBreakdown,_that.totalTransactions,_that.averageTransactionAmount,_that.durationDays,_that.dailyAverageSpending);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'fund_id')  int fundId, @JsonKey(name: 'fund_name')  String fundName, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate,  String status,  double balance,  double target, @JsonKey(name: 'total_spent')  double totalSpent, @JsonKey(name: 'remaining_balance')  double remainingBudget, @JsonKey(name: 'balance_usage_percentage')  int balanceUsagePercentage, @JsonKey(name: 'target_completion_percentage')  int targetCompletionPercentage, @JsonKey(name: 'is_over_balance')  bool isOverBudget, @JsonKey(name: 'is_target_achieved')  bool isTargetAchieved, @JsonKey(name: 'category_breakdown')  List<CategorySpendingModel> categoryBreakdown, @JsonKey(name: 'total_transactions')  int totalTransactions, @JsonKey(name: 'average_transaction_amount')  double averageTransactionAmount, @JsonKey(name: 'duration_days')  int durationDays, @JsonKey(name: 'daily_average_spending')  double dailyAverageSpending)  $default,) {final _that = this;
switch (_that) {
case _FundReportModel():
return $default(_that.fundId,_that.fundName,_that.startDate,_that.endDate,_that.status,_that.balance,_that.target,_that.totalSpent,_that.remainingBudget,_that.balanceUsagePercentage,_that.targetCompletionPercentage,_that.isOverBudget,_that.isTargetAchieved,_that.categoryBreakdown,_that.totalTransactions,_that.averageTransactionAmount,_that.durationDays,_that.dailyAverageSpending);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'fund_id')  int fundId, @JsonKey(name: 'fund_name')  String fundName, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate,  String status,  double balance,  double target, @JsonKey(name: 'total_spent')  double totalSpent, @JsonKey(name: 'remaining_balance')  double remainingBudget, @JsonKey(name: 'balance_usage_percentage')  int balanceUsagePercentage, @JsonKey(name: 'target_completion_percentage')  int targetCompletionPercentage, @JsonKey(name: 'is_over_balance')  bool isOverBudget, @JsonKey(name: 'is_target_achieved')  bool isTargetAchieved, @JsonKey(name: 'category_breakdown')  List<CategorySpendingModel> categoryBreakdown, @JsonKey(name: 'total_transactions')  int totalTransactions, @JsonKey(name: 'average_transaction_amount')  double averageTransactionAmount, @JsonKey(name: 'duration_days')  int durationDays, @JsonKey(name: 'daily_average_spending')  double dailyAverageSpending)?  $default,) {final _that = this;
switch (_that) {
case _FundReportModel() when $default != null:
return $default(_that.fundId,_that.fundName,_that.startDate,_that.endDate,_that.status,_that.balance,_that.target,_that.totalSpent,_that.remainingBudget,_that.balanceUsagePercentage,_that.targetCompletionPercentage,_that.isOverBudget,_that.isTargetAchieved,_that.categoryBreakdown,_that.totalTransactions,_that.averageTransactionAmount,_that.durationDays,_that.dailyAverageSpending);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FundReportModel implements FundReportModel {
  const _FundReportModel({@JsonKey(name: 'fund_id') required this.fundId, @JsonKey(name: 'fund_name') required this.fundName, @JsonKey(name: 'start_date') this.startDate, @JsonKey(name: 'end_date') this.endDate, this.status = 'EXPIRED', this.balance = 0, this.target = 0, @JsonKey(name: 'total_spent') this.totalSpent = 0, @JsonKey(name: 'remaining_balance') this.remainingBudget = 0, @JsonKey(name: 'balance_usage_percentage') this.balanceUsagePercentage = 0, @JsonKey(name: 'target_completion_percentage') this.targetCompletionPercentage = 0, @JsonKey(name: 'is_over_balance') this.isOverBudget = false, @JsonKey(name: 'is_target_achieved') this.isTargetAchieved = false, @JsonKey(name: 'category_breakdown') final  List<CategorySpendingModel> categoryBreakdown = const [], @JsonKey(name: 'total_transactions') this.totalTransactions = 0, @JsonKey(name: 'average_transaction_amount') this.averageTransactionAmount = 0, @JsonKey(name: 'duration_days') this.durationDays = 0, @JsonKey(name: 'daily_average_spending') this.dailyAverageSpending = 0}): _categoryBreakdown = categoryBreakdown;
  factory _FundReportModel.fromJson(Map<String, dynamic> json) => _$FundReportModelFromJson(json);

@override@JsonKey(name: 'fund_id') final  int fundId;
@override@JsonKey(name: 'fund_name') final  String fundName;
@override@JsonKey(name: 'start_date') final  DateTime? startDate;
@override@JsonKey(name: 'end_date') final  DateTime? endDate;
@override@JsonKey() final  String status;
@override@JsonKey() final  double balance;
@override@JsonKey() final  double target;
@override@JsonKey(name: 'total_spent') final  double totalSpent;
@override@JsonKey(name: 'remaining_balance') final  double remainingBudget;
@override@JsonKey(name: 'balance_usage_percentage') final  int balanceUsagePercentage;
@override@JsonKey(name: 'target_completion_percentage') final  int targetCompletionPercentage;
@override@JsonKey(name: 'is_over_balance') final  bool isOverBudget;
@override@JsonKey(name: 'is_target_achieved') final  bool isTargetAchieved;
 final  List<CategorySpendingModel> _categoryBreakdown;
@override@JsonKey(name: 'category_breakdown') List<CategorySpendingModel> get categoryBreakdown {
  if (_categoryBreakdown is EqualUnmodifiableListView) return _categoryBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categoryBreakdown);
}

@override@JsonKey(name: 'total_transactions') final  int totalTransactions;
@override@JsonKey(name: 'average_transaction_amount') final  double averageTransactionAmount;
@override@JsonKey(name: 'duration_days') final  int durationDays;
@override@JsonKey(name: 'daily_average_spending') final  double dailyAverageSpending;

/// Create a copy of FundReportModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FundReportModelCopyWith<_FundReportModel> get copyWith => __$FundReportModelCopyWithImpl<_FundReportModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FundReportModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FundReportModel&&(identical(other.fundId, fundId) || other.fundId == fundId)&&(identical(other.fundName, fundName) || other.fundName == fundName)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.target, target) || other.target == target)&&(identical(other.totalSpent, totalSpent) || other.totalSpent == totalSpent)&&(identical(other.remainingBudget, remainingBudget) || other.remainingBudget == remainingBudget)&&(identical(other.balanceUsagePercentage, balanceUsagePercentage) || other.balanceUsagePercentage == balanceUsagePercentage)&&(identical(other.targetCompletionPercentage, targetCompletionPercentage) || other.targetCompletionPercentage == targetCompletionPercentage)&&(identical(other.isOverBudget, isOverBudget) || other.isOverBudget == isOverBudget)&&(identical(other.isTargetAchieved, isTargetAchieved) || other.isTargetAchieved == isTargetAchieved)&&const DeepCollectionEquality().equals(other._categoryBreakdown, _categoryBreakdown)&&(identical(other.totalTransactions, totalTransactions) || other.totalTransactions == totalTransactions)&&(identical(other.averageTransactionAmount, averageTransactionAmount) || other.averageTransactionAmount == averageTransactionAmount)&&(identical(other.durationDays, durationDays) || other.durationDays == durationDays)&&(identical(other.dailyAverageSpending, dailyAverageSpending) || other.dailyAverageSpending == dailyAverageSpending));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fundId,fundName,startDate,endDate,status,balance,target,totalSpent,remainingBudget,balanceUsagePercentage,targetCompletionPercentage,isOverBudget,isTargetAchieved,const DeepCollectionEquality().hash(_categoryBreakdown),totalTransactions,averageTransactionAmount,durationDays,dailyAverageSpending);

@override
String toString() {
  return 'FundReportModel(fundId: $fundId, fundName: $fundName, startDate: $startDate, endDate: $endDate, status: $status, balance: $balance, target: $target, totalSpent: $totalSpent, remainingBudget: $remainingBudget, balanceUsagePercentage: $balanceUsagePercentage, targetCompletionPercentage: $targetCompletionPercentage, isOverBudget: $isOverBudget, isTargetAchieved: $isTargetAchieved, categoryBreakdown: $categoryBreakdown, totalTransactions: $totalTransactions, averageTransactionAmount: $averageTransactionAmount, durationDays: $durationDays, dailyAverageSpending: $dailyAverageSpending)';
}


}

/// @nodoc
abstract mixin class _$FundReportModelCopyWith<$Res> implements $FundReportModelCopyWith<$Res> {
  factory _$FundReportModelCopyWith(_FundReportModel value, $Res Function(_FundReportModel) _then) = __$FundReportModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'fund_id') int fundId,@JsonKey(name: 'fund_name') String fundName,@JsonKey(name: 'start_date') DateTime? startDate,@JsonKey(name: 'end_date') DateTime? endDate, String status, double balance, double target,@JsonKey(name: 'total_spent') double totalSpent,@JsonKey(name: 'remaining_balance') double remainingBudget,@JsonKey(name: 'balance_usage_percentage') int balanceUsagePercentage,@JsonKey(name: 'target_completion_percentage') int targetCompletionPercentage,@JsonKey(name: 'is_over_balance') bool isOverBudget,@JsonKey(name: 'is_target_achieved') bool isTargetAchieved,@JsonKey(name: 'category_breakdown') List<CategorySpendingModel> categoryBreakdown,@JsonKey(name: 'total_transactions') int totalTransactions,@JsonKey(name: 'average_transaction_amount') double averageTransactionAmount,@JsonKey(name: 'duration_days') int durationDays,@JsonKey(name: 'daily_average_spending') double dailyAverageSpending
});




}
/// @nodoc
class __$FundReportModelCopyWithImpl<$Res>
    implements _$FundReportModelCopyWith<$Res> {
  __$FundReportModelCopyWithImpl(this._self, this._then);

  final _FundReportModel _self;
  final $Res Function(_FundReportModel) _then;

/// Create a copy of FundReportModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fundId = null,Object? fundName = null,Object? startDate = freezed,Object? endDate = freezed,Object? status = null,Object? balance = null,Object? target = null,Object? totalSpent = null,Object? remainingBudget = null,Object? balanceUsagePercentage = null,Object? targetCompletionPercentage = null,Object? isOverBudget = null,Object? isTargetAchieved = null,Object? categoryBreakdown = null,Object? totalTransactions = null,Object? averageTransactionAmount = null,Object? durationDays = null,Object? dailyAverageSpending = null,}) {
  return _then(_FundReportModel(
fundId: null == fundId ? _self.fundId : fundId // ignore: cast_nullable_to_non_nullable
as int,fundName: null == fundName ? _self.fundName : fundName // ignore: cast_nullable_to_non_nullable
as String,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as double,totalSpent: null == totalSpent ? _self.totalSpent : totalSpent // ignore: cast_nullable_to_non_nullable
as double,remainingBudget: null == remainingBudget ? _self.remainingBudget : remainingBudget // ignore: cast_nullable_to_non_nullable
as double,balanceUsagePercentage: null == balanceUsagePercentage ? _self.balanceUsagePercentage : balanceUsagePercentage // ignore: cast_nullable_to_non_nullable
as int,targetCompletionPercentage: null == targetCompletionPercentage ? _self.targetCompletionPercentage : targetCompletionPercentage // ignore: cast_nullable_to_non_nullable
as int,isOverBudget: null == isOverBudget ? _self.isOverBudget : isOverBudget // ignore: cast_nullable_to_non_nullable
as bool,isTargetAchieved: null == isTargetAchieved ? _self.isTargetAchieved : isTargetAchieved // ignore: cast_nullable_to_non_nullable
as bool,categoryBreakdown: null == categoryBreakdown ? _self._categoryBreakdown : categoryBreakdown // ignore: cast_nullable_to_non_nullable
as List<CategorySpendingModel>,totalTransactions: null == totalTransactions ? _self.totalTransactions : totalTransactions // ignore: cast_nullable_to_non_nullable
as int,averageTransactionAmount: null == averageTransactionAmount ? _self.averageTransactionAmount : averageTransactionAmount // ignore: cast_nullable_to_non_nullable
as double,durationDays: null == durationDays ? _self.durationDays : durationDays // ignore: cast_nullable_to_non_nullable
as int,dailyAverageSpending: null == dailyAverageSpending ? _self.dailyAverageSpending : dailyAverageSpending // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
