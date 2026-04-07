// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'total_by_type_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TotalByTypeModel _$TotalByTypeModelFromJson(Map<String, dynamic> json) {
  return _TotalByTypeModel.fromJson(json);
}

/// @nodoc
mixin _$TotalByTypeModel {
  @JsonKey(name: 'income_total')
  int get income => throw _privateConstructorUsedError;
  @JsonKey(name: 'expense_total')
  int get expense => throw _privateConstructorUsedError;
  int get currentSaving => throw _privateConstructorUsedError;
  int get targetSaving => throw _privateConstructorUsedError;

  /// Serializes this TotalByTypeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TotalByTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TotalByTypeModelCopyWith<TotalByTypeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TotalByTypeModelCopyWith<$Res> {
  factory $TotalByTypeModelCopyWith(
    TotalByTypeModel value,
    $Res Function(TotalByTypeModel) then,
  ) = _$TotalByTypeModelCopyWithImpl<$Res, TotalByTypeModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'income_total') int income,
    @JsonKey(name: 'expense_total') int expense,
    int currentSaving,
    int targetSaving,
  });
}

/// @nodoc
class _$TotalByTypeModelCopyWithImpl<$Res, $Val extends TotalByTypeModel>
    implements $TotalByTypeModelCopyWith<$Res> {
  _$TotalByTypeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TotalByTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? income = null,
    Object? expense = null,
    Object? currentSaving = null,
    Object? targetSaving = null,
  }) {
    return _then(
      _value.copyWith(
            income:
                null == income
                    ? _value.income
                    : income // ignore: cast_nullable_to_non_nullable
                        as int,
            expense:
                null == expense
                    ? _value.expense
                    : expense // ignore: cast_nullable_to_non_nullable
                        as int,
            currentSaving:
                null == currentSaving
                    ? _value.currentSaving
                    : currentSaving // ignore: cast_nullable_to_non_nullable
                        as int,
            targetSaving:
                null == targetSaving
                    ? _value.targetSaving
                    : targetSaving // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TotalByTypeModelImplCopyWith<$Res>
    implements $TotalByTypeModelCopyWith<$Res> {
  factory _$$TotalByTypeModelImplCopyWith(
    _$TotalByTypeModelImpl value,
    $Res Function(_$TotalByTypeModelImpl) then,
  ) = __$$TotalByTypeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'income_total') int income,
    @JsonKey(name: 'expense_total') int expense,
    int currentSaving,
    int targetSaving,
  });
}

/// @nodoc
class __$$TotalByTypeModelImplCopyWithImpl<$Res>
    extends _$TotalByTypeModelCopyWithImpl<$Res, _$TotalByTypeModelImpl>
    implements _$$TotalByTypeModelImplCopyWith<$Res> {
  __$$TotalByTypeModelImplCopyWithImpl(
    _$TotalByTypeModelImpl _value,
    $Res Function(_$TotalByTypeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TotalByTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? income = null,
    Object? expense = null,
    Object? currentSaving = null,
    Object? targetSaving = null,
  }) {
    return _then(
      _$TotalByTypeModelImpl(
        income:
            null == income
                ? _value.income
                : income // ignore: cast_nullable_to_non_nullable
                    as int,
        expense:
            null == expense
                ? _value.expense
                : expense // ignore: cast_nullable_to_non_nullable
                    as int,
        currentSaving:
            null == currentSaving
                ? _value.currentSaving
                : currentSaving // ignore: cast_nullable_to_non_nullable
                    as int,
        targetSaving:
            null == targetSaving
                ? _value.targetSaving
                : targetSaving // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$TotalByTypeModelImpl extends _TotalByTypeModel {
  const _$TotalByTypeModelImpl({
    @JsonKey(name: 'income_total') required this.income,
    @JsonKey(name: 'expense_total') required this.expense,
    required this.currentSaving,
    required this.targetSaving,
  }) : super._();

  factory _$TotalByTypeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TotalByTypeModelImplFromJson(json);

  @override
  @JsonKey(name: 'income_total')
  final int income;
  @override
  @JsonKey(name: 'expense_total')
  final int expense;
  @override
  final int currentSaving;
  @override
  final int targetSaving;

  @override
  String toString() {
    return 'TotalByTypeModel(income: $income, expense: $expense, currentSaving: $currentSaving, targetSaving: $targetSaving)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TotalByTypeModelImpl &&
            (identical(other.income, income) || other.income == income) &&
            (identical(other.expense, expense) || other.expense == expense) &&
            (identical(other.currentSaving, currentSaving) ||
                other.currentSaving == currentSaving) &&
            (identical(other.targetSaving, targetSaving) ||
                other.targetSaving == targetSaving));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, income, expense, currentSaving, targetSaving);

  /// Create a copy of TotalByTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TotalByTypeModelImplCopyWith<_$TotalByTypeModelImpl> get copyWith =>
      __$$TotalByTypeModelImplCopyWithImpl<_$TotalByTypeModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TotalByTypeModelImplToJson(this);
  }
}

abstract class _TotalByTypeModel extends TotalByTypeModel {
  const factory _TotalByTypeModel({
    @JsonKey(name: 'income_total') required final int income,
    @JsonKey(name: 'expense_total') required final int expense,
    required final int currentSaving,
    required final int targetSaving,
  }) = _$TotalByTypeModelImpl;
  const _TotalByTypeModel._() : super._();

  factory _TotalByTypeModel.fromJson(Map<String, dynamic> json) =
      _$TotalByTypeModelImpl.fromJson;

  @override
  @JsonKey(name: 'income_total')
  int get income;
  @override
  @JsonKey(name: 'expense_total')
  int get expense;
  @override
  int get currentSaving;
  @override
  int get targetSaving;

  /// Create a copy of TotalByTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TotalByTypeModelImplCopyWith<_$TotalByTypeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
