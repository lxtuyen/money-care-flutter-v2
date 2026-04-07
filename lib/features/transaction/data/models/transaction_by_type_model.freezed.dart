// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_by_type_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TransactionByTypeModel _$TransactionByTypeModelFromJson(
  Map<String, dynamic> json,
) {
  return _TransactionByTypeModel.fromJson(json);
}

/// @nodoc
mixin _$TransactionByTypeModel {
  List<TransactionModel> get income => throw _privateConstructorUsedError;
  List<TransactionModel> get expense => throw _privateConstructorUsedError;

  /// Serializes this TransactionByTypeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransactionByTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionByTypeModelCopyWith<TransactionByTypeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionByTypeModelCopyWith<$Res> {
  factory $TransactionByTypeModelCopyWith(
    TransactionByTypeModel value,
    $Res Function(TransactionByTypeModel) then,
  ) = _$TransactionByTypeModelCopyWithImpl<$Res, TransactionByTypeModel>;
  @useResult
  $Res call({List<TransactionModel> income, List<TransactionModel> expense});
}

/// @nodoc
class _$TransactionByTypeModelCopyWithImpl<
  $Res,
  $Val extends TransactionByTypeModel
>
    implements $TransactionByTypeModelCopyWith<$Res> {
  _$TransactionByTypeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionByTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? income = null, Object? expense = null}) {
    return _then(
      _value.copyWith(
            income:
                null == income
                    ? _value.income
                    : income // ignore: cast_nullable_to_non_nullable
                        as List<TransactionModel>,
            expense:
                null == expense
                    ? _value.expense
                    : expense // ignore: cast_nullable_to_non_nullable
                        as List<TransactionModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransactionByTypeModelImplCopyWith<$Res>
    implements $TransactionByTypeModelCopyWith<$Res> {
  factory _$$TransactionByTypeModelImplCopyWith(
    _$TransactionByTypeModelImpl value,
    $Res Function(_$TransactionByTypeModelImpl) then,
  ) = __$$TransactionByTypeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<TransactionModel> income, List<TransactionModel> expense});
}

/// @nodoc
class __$$TransactionByTypeModelImplCopyWithImpl<$Res>
    extends
        _$TransactionByTypeModelCopyWithImpl<$Res, _$TransactionByTypeModelImpl>
    implements _$$TransactionByTypeModelImplCopyWith<$Res> {
  __$$TransactionByTypeModelImplCopyWithImpl(
    _$TransactionByTypeModelImpl _value,
    $Res Function(_$TransactionByTypeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionByTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? income = null, Object? expense = null}) {
    return _then(
      _$TransactionByTypeModelImpl(
        income:
            null == income
                ? _value._income
                : income // ignore: cast_nullable_to_non_nullable
                    as List<TransactionModel>,
        expense:
            null == expense
                ? _value._expense
                : expense // ignore: cast_nullable_to_non_nullable
                    as List<TransactionModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionByTypeModelImpl extends _TransactionByTypeModel {
  const _$TransactionByTypeModelImpl({
    final List<TransactionModel> income = const [],
    final List<TransactionModel> expense = const [],
  }) : _income = income,
       _expense = expense,
       super._();

  factory _$TransactionByTypeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionByTypeModelImplFromJson(json);

  final List<TransactionModel> _income;
  @override
  @JsonKey()
  List<TransactionModel> get income {
    if (_income is EqualUnmodifiableListView) return _income;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_income);
  }

  final List<TransactionModel> _expense;
  @override
  @JsonKey()
  List<TransactionModel> get expense {
    if (_expense is EqualUnmodifiableListView) return _expense;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_expense);
  }

  @override
  String toString() {
    return 'TransactionByTypeModel(income: $income, expense: $expense)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionByTypeModelImpl &&
            const DeepCollectionEquality().equals(other._income, _income) &&
            const DeepCollectionEquality().equals(other._expense, _expense));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_income),
    const DeepCollectionEquality().hash(_expense),
  );

  /// Create a copy of TransactionByTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionByTypeModelImplCopyWith<_$TransactionByTypeModelImpl>
  get copyWith =>
      __$$TransactionByTypeModelImplCopyWithImpl<_$TransactionByTypeModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionByTypeModelImplToJson(this);
  }
}

abstract class _TransactionByTypeModel extends TransactionByTypeModel {
  const factory _TransactionByTypeModel({
    final List<TransactionModel> income,
    final List<TransactionModel> expense,
  }) = _$TransactionByTypeModelImpl;
  const _TransactionByTypeModel._() : super._();

  factory _TransactionByTypeModel.fromJson(Map<String, dynamic> json) =
      _$TransactionByTypeModelImpl.fromJson;

  @override
  List<TransactionModel> get income;
  @override
  List<TransactionModel> get expense;

  /// Create a copy of TransactionByTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionByTypeModelImplCopyWith<_$TransactionByTypeModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
