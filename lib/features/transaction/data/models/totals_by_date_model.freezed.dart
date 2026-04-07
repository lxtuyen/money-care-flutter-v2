// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'totals_by_date_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TotalsByDateEntityModel _$TotalsByDateEntityModelFromJson(
  Map<String, dynamic> json,
) {
  return _TotalsByDateEntityModel.fromJson(json);
}

/// @nodoc
mixin _$TotalsByDateEntityModel {
  List<TotalByDateEntityModel> get income => throw _privateConstructorUsedError;
  List<TotalByDateEntityModel> get expense =>
      throw _privateConstructorUsedError;

  /// Serializes this TotalsByDateEntityModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TotalsByDateEntityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TotalsByDateEntityModelCopyWith<TotalsByDateEntityModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TotalsByDateEntityModelCopyWith<$Res> {
  factory $TotalsByDateEntityModelCopyWith(
    TotalsByDateEntityModel value,
    $Res Function(TotalsByDateEntityModel) then,
  ) = _$TotalsByDateEntityModelCopyWithImpl<$Res, TotalsByDateEntityModel>;
  @useResult
  $Res call({
    List<TotalByDateEntityModel> income,
    List<TotalByDateEntityModel> expense,
  });
}

/// @nodoc
class _$TotalsByDateEntityModelCopyWithImpl<
  $Res,
  $Val extends TotalsByDateEntityModel
>
    implements $TotalsByDateEntityModelCopyWith<$Res> {
  _$TotalsByDateEntityModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TotalsByDateEntityModel
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
                        as List<TotalByDateEntityModel>,
            expense:
                null == expense
                    ? _value.expense
                    : expense // ignore: cast_nullable_to_non_nullable
                        as List<TotalByDateEntityModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TotalsByDateEntityModelImplCopyWith<$Res>
    implements $TotalsByDateEntityModelCopyWith<$Res> {
  factory _$$TotalsByDateEntityModelImplCopyWith(
    _$TotalsByDateEntityModelImpl value,
    $Res Function(_$TotalsByDateEntityModelImpl) then,
  ) = __$$TotalsByDateEntityModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<TotalByDateEntityModel> income,
    List<TotalByDateEntityModel> expense,
  });
}

/// @nodoc
class __$$TotalsByDateEntityModelImplCopyWithImpl<$Res>
    extends
        _$TotalsByDateEntityModelCopyWithImpl<
          $Res,
          _$TotalsByDateEntityModelImpl
        >
    implements _$$TotalsByDateEntityModelImplCopyWith<$Res> {
  __$$TotalsByDateEntityModelImplCopyWithImpl(
    _$TotalsByDateEntityModelImpl _value,
    $Res Function(_$TotalsByDateEntityModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TotalsByDateEntityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? income = null, Object? expense = null}) {
    return _then(
      _$TotalsByDateEntityModelImpl(
        income:
            null == income
                ? _value._income
                : income // ignore: cast_nullable_to_non_nullable
                    as List<TotalByDateEntityModel>,
        expense:
            null == expense
                ? _value._expense
                : expense // ignore: cast_nullable_to_non_nullable
                    as List<TotalByDateEntityModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TotalsByDateEntityModelImpl extends _TotalsByDateEntityModel {
  const _$TotalsByDateEntityModelImpl({
    final List<TotalByDateEntityModel> income = const [],
    final List<TotalByDateEntityModel> expense = const [],
  }) : _income = income,
       _expense = expense,
       super._();

  factory _$TotalsByDateEntityModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TotalsByDateEntityModelImplFromJson(json);

  final List<TotalByDateEntityModel> _income;
  @override
  @JsonKey()
  List<TotalByDateEntityModel> get income {
    if (_income is EqualUnmodifiableListView) return _income;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_income);
  }

  final List<TotalByDateEntityModel> _expense;
  @override
  @JsonKey()
  List<TotalByDateEntityModel> get expense {
    if (_expense is EqualUnmodifiableListView) return _expense;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_expense);
  }

  @override
  String toString() {
    return 'TotalsByDateEntityModel(income: $income, expense: $expense)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TotalsByDateEntityModelImpl &&
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

  /// Create a copy of TotalsByDateEntityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TotalsByDateEntityModelImplCopyWith<_$TotalsByDateEntityModelImpl>
  get copyWith => __$$TotalsByDateEntityModelImplCopyWithImpl<
    _$TotalsByDateEntityModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TotalsByDateEntityModelImplToJson(this);
  }
}

abstract class _TotalsByDateEntityModel extends TotalsByDateEntityModel {
  const factory _TotalsByDateEntityModel({
    final List<TotalByDateEntityModel> income,
    final List<TotalByDateEntityModel> expense,
  }) = _$TotalsByDateEntityModelImpl;
  const _TotalsByDateEntityModel._() : super._();

  factory _TotalsByDateEntityModel.fromJson(Map<String, dynamic> json) =
      _$TotalsByDateEntityModelImpl.fromJson;

  @override
  List<TotalByDateEntityModel> get income;
  @override
  List<TotalByDateEntityModel> get expense;

  /// Create a copy of TotalsByDateEntityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TotalsByDateEntityModelImplCopyWith<_$TotalsByDateEntityModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
