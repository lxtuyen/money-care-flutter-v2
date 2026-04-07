// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'statistics_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StatisticsSummaryModel _$StatisticsSummaryModelFromJson(
  Map<String, dynamic> json,
) {
  return _StatisticsSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$StatisticsSummaryModel {
  double get dailyAverage => throw _privateConstructorUsedError;
  double get dailyAverageChange => throw _privateConstructorUsedError;
  double get dailyIncomeChange => throw _privateConstructorUsedError;
  double get monthlyBalance => throw _privateConstructorUsedError;

  /// Serializes this StatisticsSummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StatisticsSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StatisticsSummaryModelCopyWith<StatisticsSummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatisticsSummaryModelCopyWith<$Res> {
  factory $StatisticsSummaryModelCopyWith(
    StatisticsSummaryModel value,
    $Res Function(StatisticsSummaryModel) then,
  ) = _$StatisticsSummaryModelCopyWithImpl<$Res, StatisticsSummaryModel>;
  @useResult
  $Res call({
    double dailyAverage,
    double dailyAverageChange,
    double dailyIncomeChange,
    double monthlyBalance,
  });
}

/// @nodoc
class _$StatisticsSummaryModelCopyWithImpl<
  $Res,
  $Val extends StatisticsSummaryModel
>
    implements $StatisticsSummaryModelCopyWith<$Res> {
  _$StatisticsSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StatisticsSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dailyAverage = null,
    Object? dailyAverageChange = null,
    Object? dailyIncomeChange = null,
    Object? monthlyBalance = null,
  }) {
    return _then(
      _value.copyWith(
            dailyAverage:
                null == dailyAverage
                    ? _value.dailyAverage
                    : dailyAverage // ignore: cast_nullable_to_non_nullable
                        as double,
            dailyAverageChange:
                null == dailyAverageChange
                    ? _value.dailyAverageChange
                    : dailyAverageChange // ignore: cast_nullable_to_non_nullable
                        as double,
            dailyIncomeChange:
                null == dailyIncomeChange
                    ? _value.dailyIncomeChange
                    : dailyIncomeChange // ignore: cast_nullable_to_non_nullable
                        as double,
            monthlyBalance:
                null == monthlyBalance
                    ? _value.monthlyBalance
                    : monthlyBalance // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StatisticsSummaryModelImplCopyWith<$Res>
    implements $StatisticsSummaryModelCopyWith<$Res> {
  factory _$$StatisticsSummaryModelImplCopyWith(
    _$StatisticsSummaryModelImpl value,
    $Res Function(_$StatisticsSummaryModelImpl) then,
  ) = __$$StatisticsSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double dailyAverage,
    double dailyAverageChange,
    double dailyIncomeChange,
    double monthlyBalance,
  });
}

/// @nodoc
class __$$StatisticsSummaryModelImplCopyWithImpl<$Res>
    extends
        _$StatisticsSummaryModelCopyWithImpl<$Res, _$StatisticsSummaryModelImpl>
    implements _$$StatisticsSummaryModelImplCopyWith<$Res> {
  __$$StatisticsSummaryModelImplCopyWithImpl(
    _$StatisticsSummaryModelImpl _value,
    $Res Function(_$StatisticsSummaryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StatisticsSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dailyAverage = null,
    Object? dailyAverageChange = null,
    Object? dailyIncomeChange = null,
    Object? monthlyBalance = null,
  }) {
    return _then(
      _$StatisticsSummaryModelImpl(
        dailyAverage:
            null == dailyAverage
                ? _value.dailyAverage
                : dailyAverage // ignore: cast_nullable_to_non_nullable
                    as double,
        dailyAverageChange:
            null == dailyAverageChange
                ? _value.dailyAverageChange
                : dailyAverageChange // ignore: cast_nullable_to_non_nullable
                    as double,
        dailyIncomeChange:
            null == dailyIncomeChange
                ? _value.dailyIncomeChange
                : dailyIncomeChange // ignore: cast_nullable_to_non_nullable
                    as double,
        monthlyBalance:
            null == monthlyBalance
                ? _value.monthlyBalance
                : monthlyBalance // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StatisticsSummaryModelImpl extends _StatisticsSummaryModel {
  const _$StatisticsSummaryModelImpl({
    required this.dailyAverage,
    required this.dailyAverageChange,
    required this.dailyIncomeChange,
    required this.monthlyBalance,
  }) : super._();

  factory _$StatisticsSummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StatisticsSummaryModelImplFromJson(json);

  @override
  final double dailyAverage;
  @override
  final double dailyAverageChange;
  @override
  final double dailyIncomeChange;
  @override
  final double monthlyBalance;

  @override
  String toString() {
    return 'StatisticsSummaryModel(dailyAverage: $dailyAverage, dailyAverageChange: $dailyAverageChange, dailyIncomeChange: $dailyIncomeChange, monthlyBalance: $monthlyBalance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatisticsSummaryModelImpl &&
            (identical(other.dailyAverage, dailyAverage) ||
                other.dailyAverage == dailyAverage) &&
            (identical(other.dailyAverageChange, dailyAverageChange) ||
                other.dailyAverageChange == dailyAverageChange) &&
            (identical(other.dailyIncomeChange, dailyIncomeChange) ||
                other.dailyIncomeChange == dailyIncomeChange) &&
            (identical(other.monthlyBalance, monthlyBalance) ||
                other.monthlyBalance == monthlyBalance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    dailyAverage,
    dailyAverageChange,
    dailyIncomeChange,
    monthlyBalance,
  );

  /// Create a copy of StatisticsSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StatisticsSummaryModelImplCopyWith<_$StatisticsSummaryModelImpl>
  get copyWith =>
      __$$StatisticsSummaryModelImplCopyWithImpl<_$StatisticsSummaryModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StatisticsSummaryModelImplToJson(this);
  }
}

abstract class _StatisticsSummaryModel extends StatisticsSummaryModel {
  const factory _StatisticsSummaryModel({
    required final double dailyAverage,
    required final double dailyAverageChange,
    required final double dailyIncomeChange,
    required final double monthlyBalance,
  }) = _$StatisticsSummaryModelImpl;
  const _StatisticsSummaryModel._() : super._();

  factory _StatisticsSummaryModel.fromJson(Map<String, dynamic> json) =
      _$StatisticsSummaryModelImpl.fromJson;

  @override
  double get dailyAverage;
  @override
  double get dailyAverageChange;
  @override
  double get dailyIncomeChange;
  @override
  double get monthlyBalance;

  /// Create a copy of StatisticsSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StatisticsSummaryModelImplCopyWith<_$StatisticsSummaryModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
