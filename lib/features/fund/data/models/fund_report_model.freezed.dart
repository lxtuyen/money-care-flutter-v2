// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fund_report_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CategorySpendingModel _$CategorySpendingModelFromJson(
  Map<String, dynamic> json,
) {
  return _CategorySpendingModel.fromJson(json);
}

/// @nodoc
mixin _$CategorySpendingModel {
  @JsonKey(name: 'category_id')
  int get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_name')
  String get categoryName => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_spent')
  double get totalSpent => throw _privateConstructorUsedError;
  @JsonKey(name: 'transaction_count')
  int get transactionCount => throw _privateConstructorUsedError;
  int get percentage => throw _privateConstructorUsedError;

  /// Serializes this CategorySpendingModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategorySpendingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategorySpendingModelCopyWith<CategorySpendingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategorySpendingModelCopyWith<$Res> {
  factory $CategorySpendingModelCopyWith(
    CategorySpendingModel value,
    $Res Function(CategorySpendingModel) then,
  ) = _$CategorySpendingModelCopyWithImpl<$Res, CategorySpendingModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'category_id') int categoryId,
    @JsonKey(name: 'category_name') String categoryName,
    @JsonKey(name: 'total_spent') double totalSpent,
    @JsonKey(name: 'transaction_count') int transactionCount,
    int percentage,
  });
}

/// @nodoc
class _$CategorySpendingModelCopyWithImpl<
  $Res,
  $Val extends CategorySpendingModel
>
    implements $CategorySpendingModelCopyWith<$Res> {
  _$CategorySpendingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategorySpendingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryName = null,
    Object? totalSpent = null,
    Object? transactionCount = null,
    Object? percentage = null,
  }) {
    return _then(
      _value.copyWith(
            categoryId:
                null == categoryId
                    ? _value.categoryId
                    : categoryId // ignore: cast_nullable_to_non_nullable
                        as int,
            categoryName:
                null == categoryName
                    ? _value.categoryName
                    : categoryName // ignore: cast_nullable_to_non_nullable
                        as String,
            totalSpent:
                null == totalSpent
                    ? _value.totalSpent
                    : totalSpent // ignore: cast_nullable_to_non_nullable
                        as double,
            transactionCount:
                null == transactionCount
                    ? _value.transactionCount
                    : transactionCount // ignore: cast_nullable_to_non_nullable
                        as int,
            percentage:
                null == percentage
                    ? _value.percentage
                    : percentage // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CategorySpendingModelImplCopyWith<$Res>
    implements $CategorySpendingModelCopyWith<$Res> {
  factory _$$CategorySpendingModelImplCopyWith(
    _$CategorySpendingModelImpl value,
    $Res Function(_$CategorySpendingModelImpl) then,
  ) = __$$CategorySpendingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'category_id') int categoryId,
    @JsonKey(name: 'category_name') String categoryName,
    @JsonKey(name: 'total_spent') double totalSpent,
    @JsonKey(name: 'transaction_count') int transactionCount,
    int percentage,
  });
}

/// @nodoc
class __$$CategorySpendingModelImplCopyWithImpl<$Res>
    extends
        _$CategorySpendingModelCopyWithImpl<$Res, _$CategorySpendingModelImpl>
    implements _$$CategorySpendingModelImplCopyWith<$Res> {
  __$$CategorySpendingModelImplCopyWithImpl(
    _$CategorySpendingModelImpl _value,
    $Res Function(_$CategorySpendingModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategorySpendingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryName = null,
    Object? totalSpent = null,
    Object? transactionCount = null,
    Object? percentage = null,
  }) {
    return _then(
      _$CategorySpendingModelImpl(
        categoryId:
            null == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                    as int,
        categoryName:
            null == categoryName
                ? _value.categoryName
                : categoryName // ignore: cast_nullable_to_non_nullable
                    as String,
        totalSpent:
            null == totalSpent
                ? _value.totalSpent
                : totalSpent // ignore: cast_nullable_to_non_nullable
                    as double,
        transactionCount:
            null == transactionCount
                ? _value.transactionCount
                : transactionCount // ignore: cast_nullable_to_non_nullable
                    as int,
        percentage:
            null == percentage
                ? _value.percentage
                : percentage // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CategorySpendingModelImpl implements _CategorySpendingModel {
  const _$CategorySpendingModelImpl({
    @JsonKey(name: 'category_id') required this.categoryId,
    @JsonKey(name: 'category_name') required this.categoryName,
    @JsonKey(name: 'total_spent') this.totalSpent = 0,
    @JsonKey(name: 'transaction_count') this.transactionCount = 0,
    this.percentage = 0,
  });

  factory _$CategorySpendingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategorySpendingModelImplFromJson(json);

  @override
  @JsonKey(name: 'category_id')
  final int categoryId;
  @override
  @JsonKey(name: 'category_name')
  final String categoryName;
  @override
  @JsonKey(name: 'total_spent')
  final double totalSpent;
  @override
  @JsonKey(name: 'transaction_count')
  final int transactionCount;
  @override
  @JsonKey()
  final int percentage;

  @override
  String toString() {
    return 'CategorySpendingModel(categoryId: $categoryId, categoryName: $categoryName, totalSpent: $totalSpent, transactionCount: $transactionCount, percentage: $percentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategorySpendingModelImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.totalSpent, totalSpent) ||
                other.totalSpent == totalSpent) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    categoryId,
    categoryName,
    totalSpent,
    transactionCount,
    percentage,
  );

  /// Create a copy of CategorySpendingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategorySpendingModelImplCopyWith<_$CategorySpendingModelImpl>
  get copyWith =>
      __$$CategorySpendingModelImplCopyWithImpl<_$CategorySpendingModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CategorySpendingModelImplToJson(this);
  }
}

abstract class _CategorySpendingModel implements CategorySpendingModel {
  const factory _CategorySpendingModel({
    @JsonKey(name: 'category_id') required final int categoryId,
    @JsonKey(name: 'category_name') required final String categoryName,
    @JsonKey(name: 'total_spent') final double totalSpent,
    @JsonKey(name: 'transaction_count') final int transactionCount,
    final int percentage,
  }) = _$CategorySpendingModelImpl;

  factory _CategorySpendingModel.fromJson(Map<String, dynamic> json) =
      _$CategorySpendingModelImpl.fromJson;

  @override
  @JsonKey(name: 'category_id')
  int get categoryId;
  @override
  @JsonKey(name: 'category_name')
  String get categoryName;
  @override
  @JsonKey(name: 'total_spent')
  double get totalSpent;
  @override
  @JsonKey(name: 'transaction_count')
  int get transactionCount;
  @override
  int get percentage;

  /// Create a copy of CategorySpendingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategorySpendingModelImplCopyWith<_$CategorySpendingModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

FundReportModel _$FundReportModelFromJson(Map<String, dynamic> json) {
  return _FundReportModel.fromJson(json);
}

/// @nodoc
mixin _$FundReportModel {
  @JsonKey(name: 'fund_id')
  int get fundId => throw _privateConstructorUsedError;
  @JsonKey(name: 'fund_name')
  String get fundName => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_date')
  DateTime? get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date')
  DateTime? get endDate => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  double get balance => throw _privateConstructorUsedError;
  double get target => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_spent')
  double get totalSpent => throw _privateConstructorUsedError;
  @JsonKey(name: 'remaining_balance')
  double get remainingBudget => throw _privateConstructorUsedError;
  @JsonKey(name: 'balance_usage_percentage')
  int get balanceUsagePercentage => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_completion_percentage')
  int get targetCompletionPercentage => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_over_balance')
  bool get isOverBudget => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_target_achieved')
  bool get isTargetAchieved => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_breakdown')
  List<CategorySpendingModel> get categoryBreakdown =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'total_transactions')
  int get totalTransactions => throw _privateConstructorUsedError;
  @JsonKey(name: 'average_transaction_amount')
  double get averageTransactionAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_days')
  int get durationDays => throw _privateConstructorUsedError;
  @JsonKey(name: 'daily_average_spending')
  double get dailyAverageSpending => throw _privateConstructorUsedError;

  /// Serializes this FundReportModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FundReportModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FundReportModelCopyWith<FundReportModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FundReportModelCopyWith<$Res> {
  factory $FundReportModelCopyWith(
    FundReportModel value,
    $Res Function(FundReportModel) then,
  ) = _$FundReportModelCopyWithImpl<$Res, FundReportModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'fund_id') int fundId,
    @JsonKey(name: 'fund_name') String fundName,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    String status,
    double balance,
    double target,
    @JsonKey(name: 'total_spent') double totalSpent,
    @JsonKey(name: 'remaining_balance') double remainingBudget,
    @JsonKey(name: 'balance_usage_percentage') int balanceUsagePercentage,
    @JsonKey(name: 'target_completion_percentage')
    int targetCompletionPercentage,
    @JsonKey(name: 'is_over_balance') bool isOverBudget,
    @JsonKey(name: 'is_target_achieved') bool isTargetAchieved,
    @JsonKey(name: 'category_breakdown')
    List<CategorySpendingModel> categoryBreakdown,
    @JsonKey(name: 'total_transactions') int totalTransactions,
    @JsonKey(name: 'average_transaction_amount')
    double averageTransactionAmount,
    @JsonKey(name: 'duration_days') int durationDays,
    @JsonKey(name: 'daily_average_spending') double dailyAverageSpending,
  });
}

/// @nodoc
class _$FundReportModelCopyWithImpl<$Res, $Val extends FundReportModel>
    implements $FundReportModelCopyWith<$Res> {
  _$FundReportModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FundReportModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fundId = null,
    Object? fundName = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? status = null,
    Object? balance = null,
    Object? target = null,
    Object? totalSpent = null,
    Object? remainingBudget = null,
    Object? balanceUsagePercentage = null,
    Object? targetCompletionPercentage = null,
    Object? isOverBudget = null,
    Object? isTargetAchieved = null,
    Object? categoryBreakdown = null,
    Object? totalTransactions = null,
    Object? averageTransactionAmount = null,
    Object? durationDays = null,
    Object? dailyAverageSpending = null,
  }) {
    return _then(
      _value.copyWith(
            fundId:
                null == fundId
                    ? _value.fundId
                    : fundId // ignore: cast_nullable_to_non_nullable
                        as int,
            fundName:
                null == fundName
                    ? _value.fundName
                    : fundName // ignore: cast_nullable_to_non_nullable
                        as String,
            startDate:
                freezed == startDate
                    ? _value.startDate
                    : startDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            endDate:
                freezed == endDate
                    ? _value.endDate
                    : endDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as String,
            balance:
                null == balance
                    ? _value.balance
                    : balance // ignore: cast_nullable_to_non_nullable
                        as double,
            target:
                null == target
                    ? _value.target
                    : target // ignore: cast_nullable_to_non_nullable
                        as double,
            totalSpent:
                null == totalSpent
                    ? _value.totalSpent
                    : totalSpent // ignore: cast_nullable_to_non_nullable
                        as double,
            remainingBudget:
                null == remainingBudget
                    ? _value.remainingBudget
                    : remainingBudget // ignore: cast_nullable_to_non_nullable
                        as double,
            balanceUsagePercentage:
                null == balanceUsagePercentage
                    ? _value.balanceUsagePercentage
                    : balanceUsagePercentage // ignore: cast_nullable_to_non_nullable
                        as int,
            targetCompletionPercentage:
                null == targetCompletionPercentage
                    ? _value.targetCompletionPercentage
                    : targetCompletionPercentage // ignore: cast_nullable_to_non_nullable
                        as int,
            isOverBudget:
                null == isOverBudget
                    ? _value.isOverBudget
                    : isOverBudget // ignore: cast_nullable_to_non_nullable
                        as bool,
            isTargetAchieved:
                null == isTargetAchieved
                    ? _value.isTargetAchieved
                    : isTargetAchieved // ignore: cast_nullable_to_non_nullable
                        as bool,
            categoryBreakdown:
                null == categoryBreakdown
                    ? _value.categoryBreakdown
                    : categoryBreakdown // ignore: cast_nullable_to_non_nullable
                        as List<CategorySpendingModel>,
            totalTransactions:
                null == totalTransactions
                    ? _value.totalTransactions
                    : totalTransactions // ignore: cast_nullable_to_non_nullable
                        as int,
            averageTransactionAmount:
                null == averageTransactionAmount
                    ? _value.averageTransactionAmount
                    : averageTransactionAmount // ignore: cast_nullable_to_non_nullable
                        as double,
            durationDays:
                null == durationDays
                    ? _value.durationDays
                    : durationDays // ignore: cast_nullable_to_non_nullable
                        as int,
            dailyAverageSpending:
                null == dailyAverageSpending
                    ? _value.dailyAverageSpending
                    : dailyAverageSpending // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FundReportModelImplCopyWith<$Res>
    implements $FundReportModelCopyWith<$Res> {
  factory _$$FundReportModelImplCopyWith(
    _$FundReportModelImpl value,
    $Res Function(_$FundReportModelImpl) then,
  ) = __$$FundReportModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'fund_id') int fundId,
    @JsonKey(name: 'fund_name') String fundName,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    String status,
    double balance,
    double target,
    @JsonKey(name: 'total_spent') double totalSpent,
    @JsonKey(name: 'remaining_balance') double remainingBudget,
    @JsonKey(name: 'balance_usage_percentage') int balanceUsagePercentage,
    @JsonKey(name: 'target_completion_percentage')
    int targetCompletionPercentage,
    @JsonKey(name: 'is_over_balance') bool isOverBudget,
    @JsonKey(name: 'is_target_achieved') bool isTargetAchieved,
    @JsonKey(name: 'category_breakdown')
    List<CategorySpendingModel> categoryBreakdown,
    @JsonKey(name: 'total_transactions') int totalTransactions,
    @JsonKey(name: 'average_transaction_amount')
    double averageTransactionAmount,
    @JsonKey(name: 'duration_days') int durationDays,
    @JsonKey(name: 'daily_average_spending') double dailyAverageSpending,
  });
}

/// @nodoc
class __$$FundReportModelImplCopyWithImpl<$Res>
    extends _$FundReportModelCopyWithImpl<$Res, _$FundReportModelImpl>
    implements _$$FundReportModelImplCopyWith<$Res> {
  __$$FundReportModelImplCopyWithImpl(
    _$FundReportModelImpl _value,
    $Res Function(_$FundReportModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FundReportModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fundId = null,
    Object? fundName = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? status = null,
    Object? balance = null,
    Object? target = null,
    Object? totalSpent = null,
    Object? remainingBudget = null,
    Object? balanceUsagePercentage = null,
    Object? targetCompletionPercentage = null,
    Object? isOverBudget = null,
    Object? isTargetAchieved = null,
    Object? categoryBreakdown = null,
    Object? totalTransactions = null,
    Object? averageTransactionAmount = null,
    Object? durationDays = null,
    Object? dailyAverageSpending = null,
  }) {
    return _then(
      _$FundReportModelImpl(
        fundId:
            null == fundId
                ? _value.fundId
                : fundId // ignore: cast_nullable_to_non_nullable
                    as int,
        fundName:
            null == fundName
                ? _value.fundName
                : fundName // ignore: cast_nullable_to_non_nullable
                    as String,
        startDate:
            freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        endDate:
            freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as String,
        balance:
            null == balance
                ? _value.balance
                : balance // ignore: cast_nullable_to_non_nullable
                    as double,
        target:
            null == target
                ? _value.target
                : target // ignore: cast_nullable_to_non_nullable
                    as double,
        totalSpent:
            null == totalSpent
                ? _value.totalSpent
                : totalSpent // ignore: cast_nullable_to_non_nullable
                    as double,
        remainingBudget:
            null == remainingBudget
                ? _value.remainingBudget
                : remainingBudget // ignore: cast_nullable_to_non_nullable
                    as double,
        balanceUsagePercentage:
            null == balanceUsagePercentage
                ? _value.balanceUsagePercentage
                : balanceUsagePercentage // ignore: cast_nullable_to_non_nullable
                    as int,
        targetCompletionPercentage:
            null == targetCompletionPercentage
                ? _value.targetCompletionPercentage
                : targetCompletionPercentage // ignore: cast_nullable_to_non_nullable
                    as int,
        isOverBudget:
            null == isOverBudget
                ? _value.isOverBudget
                : isOverBudget // ignore: cast_nullable_to_non_nullable
                    as bool,
        isTargetAchieved:
            null == isTargetAchieved
                ? _value.isTargetAchieved
                : isTargetAchieved // ignore: cast_nullable_to_non_nullable
                    as bool,
        categoryBreakdown:
            null == categoryBreakdown
                ? _value._categoryBreakdown
                : categoryBreakdown // ignore: cast_nullable_to_non_nullable
                    as List<CategorySpendingModel>,
        totalTransactions:
            null == totalTransactions
                ? _value.totalTransactions
                : totalTransactions // ignore: cast_nullable_to_non_nullable
                    as int,
        averageTransactionAmount:
            null == averageTransactionAmount
                ? _value.averageTransactionAmount
                : averageTransactionAmount // ignore: cast_nullable_to_non_nullable
                    as double,
        durationDays:
            null == durationDays
                ? _value.durationDays
                : durationDays // ignore: cast_nullable_to_non_nullable
                    as int,
        dailyAverageSpending:
            null == dailyAverageSpending
                ? _value.dailyAverageSpending
                : dailyAverageSpending // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FundReportModelImpl implements _FundReportModel {
  const _$FundReportModelImpl({
    @JsonKey(name: 'fund_id') required this.fundId,
    @JsonKey(name: 'fund_name') required this.fundName,
    @JsonKey(name: 'start_date') this.startDate,
    @JsonKey(name: 'end_date') this.endDate,
    this.status = 'EXPIRED',
    this.balance = 0,
    this.target = 0,
    @JsonKey(name: 'total_spent') this.totalSpent = 0,
    @JsonKey(name: 'remaining_balance') this.remainingBudget = 0,
    @JsonKey(name: 'balance_usage_percentage') this.balanceUsagePercentage = 0,
    @JsonKey(name: 'target_completion_percentage')
    this.targetCompletionPercentage = 0,
    @JsonKey(name: 'is_over_balance') this.isOverBudget = false,
    @JsonKey(name: 'is_target_achieved') this.isTargetAchieved = false,
    @JsonKey(name: 'category_breakdown')
    final List<CategorySpendingModel> categoryBreakdown = const [],
    @JsonKey(name: 'total_transactions') this.totalTransactions = 0,
    @JsonKey(name: 'average_transaction_amount')
    this.averageTransactionAmount = 0,
    @JsonKey(name: 'duration_days') this.durationDays = 0,
    @JsonKey(name: 'daily_average_spending') this.dailyAverageSpending = 0,
  }) : _categoryBreakdown = categoryBreakdown;

  factory _$FundReportModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FundReportModelImplFromJson(json);

  @override
  @JsonKey(name: 'fund_id')
  final int fundId;
  @override
  @JsonKey(name: 'fund_name')
  final String fundName;
  @override
  @JsonKey(name: 'start_date')
  final DateTime? startDate;
  @override
  @JsonKey(name: 'end_date')
  final DateTime? endDate;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final double balance;
  @override
  @JsonKey()
  final double target;
  @override
  @JsonKey(name: 'total_spent')
  final double totalSpent;
  @override
  @JsonKey(name: 'remaining_balance')
  final double remainingBudget;
  @override
  @JsonKey(name: 'balance_usage_percentage')
  final int balanceUsagePercentage;
  @override
  @JsonKey(name: 'target_completion_percentage')
  final int targetCompletionPercentage;
  @override
  @JsonKey(name: 'is_over_balance')
  final bool isOverBudget;
  @override
  @JsonKey(name: 'is_target_achieved')
  final bool isTargetAchieved;
  final List<CategorySpendingModel> _categoryBreakdown;
  @override
  @JsonKey(name: 'category_breakdown')
  List<CategorySpendingModel> get categoryBreakdown {
    if (_categoryBreakdown is EqualUnmodifiableListView)
      return _categoryBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categoryBreakdown);
  }

  @override
  @JsonKey(name: 'total_transactions')
  final int totalTransactions;
  @override
  @JsonKey(name: 'average_transaction_amount')
  final double averageTransactionAmount;
  @override
  @JsonKey(name: 'duration_days')
  final int durationDays;
  @override
  @JsonKey(name: 'daily_average_spending')
  final double dailyAverageSpending;

  @override
  String toString() {
    return 'FundReportModel(fundId: $fundId, fundName: $fundName, startDate: $startDate, endDate: $endDate, status: $status, balance: $balance, target: $target, totalSpent: $totalSpent, remainingBudget: $remainingBudget, balanceUsagePercentage: $balanceUsagePercentage, targetCompletionPercentage: $targetCompletionPercentage, isOverBudget: $isOverBudget, isTargetAchieved: $isTargetAchieved, categoryBreakdown: $categoryBreakdown, totalTransactions: $totalTransactions, averageTransactionAmount: $averageTransactionAmount, durationDays: $durationDays, dailyAverageSpending: $dailyAverageSpending)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FundReportModelImpl &&
            (identical(other.fundId, fundId) || other.fundId == fundId) &&
            (identical(other.fundName, fundName) ||
                other.fundName == fundName) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.target, target) || other.target == target) &&
            (identical(other.totalSpent, totalSpent) ||
                other.totalSpent == totalSpent) &&
            (identical(other.remainingBudget, remainingBudget) ||
                other.remainingBudget == remainingBudget) &&
            (identical(other.balanceUsagePercentage, balanceUsagePercentage) ||
                other.balanceUsagePercentage == balanceUsagePercentage) &&
            (identical(
                  other.targetCompletionPercentage,
                  targetCompletionPercentage,
                ) ||
                other.targetCompletionPercentage ==
                    targetCompletionPercentage) &&
            (identical(other.isOverBudget, isOverBudget) ||
                other.isOverBudget == isOverBudget) &&
            (identical(other.isTargetAchieved, isTargetAchieved) ||
                other.isTargetAchieved == isTargetAchieved) &&
            const DeepCollectionEquality().equals(
              other._categoryBreakdown,
              _categoryBreakdown,
            ) &&
            (identical(other.totalTransactions, totalTransactions) ||
                other.totalTransactions == totalTransactions) &&
            (identical(
                  other.averageTransactionAmount,
                  averageTransactionAmount,
                ) ||
                other.averageTransactionAmount == averageTransactionAmount) &&
            (identical(other.durationDays, durationDays) ||
                other.durationDays == durationDays) &&
            (identical(other.dailyAverageSpending, dailyAverageSpending) ||
                other.dailyAverageSpending == dailyAverageSpending));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    fundId,
    fundName,
    startDate,
    endDate,
    status,
    balance,
    target,
    totalSpent,
    remainingBudget,
    balanceUsagePercentage,
    targetCompletionPercentage,
    isOverBudget,
    isTargetAchieved,
    const DeepCollectionEquality().hash(_categoryBreakdown),
    totalTransactions,
    averageTransactionAmount,
    durationDays,
    dailyAverageSpending,
  );

  /// Create a copy of FundReportModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FundReportModelImplCopyWith<_$FundReportModelImpl> get copyWith =>
      __$$FundReportModelImplCopyWithImpl<_$FundReportModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FundReportModelImplToJson(this);
  }
}

abstract class _FundReportModel implements FundReportModel {
  const factory _FundReportModel({
    @JsonKey(name: 'fund_id') required final int fundId,
    @JsonKey(name: 'fund_name') required final String fundName,
    @JsonKey(name: 'start_date') final DateTime? startDate,
    @JsonKey(name: 'end_date') final DateTime? endDate,
    final String status,
    final double balance,
    final double target,
    @JsonKey(name: 'total_spent') final double totalSpent,
    @JsonKey(name: 'remaining_balance') final double remainingBudget,
    @JsonKey(name: 'balance_usage_percentage') final int balanceUsagePercentage,
    @JsonKey(name: 'target_completion_percentage')
    final int targetCompletionPercentage,
    @JsonKey(name: 'is_over_balance') final bool isOverBudget,
    @JsonKey(name: 'is_target_achieved') final bool isTargetAchieved,
    @JsonKey(name: 'category_breakdown')
    final List<CategorySpendingModel> categoryBreakdown,
    @JsonKey(name: 'total_transactions') final int totalTransactions,
    @JsonKey(name: 'average_transaction_amount')
    final double averageTransactionAmount,
    @JsonKey(name: 'duration_days') final int durationDays,
    @JsonKey(name: 'daily_average_spending') final double dailyAverageSpending,
  }) = _$FundReportModelImpl;

  factory _FundReportModel.fromJson(Map<String, dynamic> json) =
      _$FundReportModelImpl.fromJson;

  @override
  @JsonKey(name: 'fund_id')
  int get fundId;
  @override
  @JsonKey(name: 'fund_name')
  String get fundName;
  @override
  @JsonKey(name: 'start_date')
  DateTime? get startDate;
  @override
  @JsonKey(name: 'end_date')
  DateTime? get endDate;
  @override
  String get status;
  @override
  double get balance;
  @override
  double get target;
  @override
  @JsonKey(name: 'total_spent')
  double get totalSpent;
  @override
  @JsonKey(name: 'remaining_balance')
  double get remainingBudget;
  @override
  @JsonKey(name: 'balance_usage_percentage')
  int get balanceUsagePercentage;
  @override
  @JsonKey(name: 'target_completion_percentage')
  int get targetCompletionPercentage;
  @override
  @JsonKey(name: 'is_over_balance')
  bool get isOverBudget;
  @override
  @JsonKey(name: 'is_target_achieved')
  bool get isTargetAchieved;
  @override
  @JsonKey(name: 'category_breakdown')
  List<CategorySpendingModel> get categoryBreakdown;
  @override
  @JsonKey(name: 'total_transactions')
  int get totalTransactions;
  @override
  @JsonKey(name: 'average_transaction_amount')
  double get averageTransactionAmount;
  @override
  @JsonKey(name: 'duration_days')
  int get durationDays;
  @override
  @JsonKey(name: 'daily_average_spending')
  double get dailyAverageSpending;

  /// Create a copy of FundReportModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FundReportModelImplCopyWith<_$FundReportModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
