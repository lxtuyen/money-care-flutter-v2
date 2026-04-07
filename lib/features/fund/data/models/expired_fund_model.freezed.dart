// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expired_fund_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ExpiredFundInfoModel _$ExpiredFundInfoModelFromJson(Map<String, dynamic> json) {
  return _ExpiredFundInfoModel.fromJson(json);
}

/// @nodoc
mixin _$ExpiredFundInfoModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date')
  DateTime? get endDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'completion_percentage')
  int get completionPercentage => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_spent')
  double get totalSpent => throw _privateConstructorUsedError;
  double get target => throw _privateConstructorUsedError;
  double get balance => throw _privateConstructorUsedError;

  /// Serializes this ExpiredFundInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExpiredFundInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpiredFundInfoModelCopyWith<ExpiredFundInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpiredFundInfoModelCopyWith<$Res> {
  factory $ExpiredFundInfoModelCopyWith(
    ExpiredFundInfoModel value,
    $Res Function(ExpiredFundInfoModel) then,
  ) = _$ExpiredFundInfoModelCopyWithImpl<$Res, ExpiredFundInfoModel>;
  @useResult
  $Res call({
    int id,
    String name,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'completion_percentage') int completionPercentage,
    @JsonKey(name: 'total_spent') double totalSpent,
    double target,
    double balance,
  });
}

/// @nodoc
class _$ExpiredFundInfoModelCopyWithImpl<
  $Res,
  $Val extends ExpiredFundInfoModel
>
    implements $ExpiredFundInfoModelCopyWith<$Res> {
  _$ExpiredFundInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpiredFundInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? endDate = freezed,
    Object? completionPercentage = null,
    Object? totalSpent = null,
    Object? target = null,
    Object? balance = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as int,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            endDate:
                freezed == endDate
                    ? _value.endDate
                    : endDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            completionPercentage:
                null == completionPercentage
                    ? _value.completionPercentage
                    : completionPercentage // ignore: cast_nullable_to_non_nullable
                        as int,
            totalSpent:
                null == totalSpent
                    ? _value.totalSpent
                    : totalSpent // ignore: cast_nullable_to_non_nullable
                        as double,
            target:
                null == target
                    ? _value.target
                    : target // ignore: cast_nullable_to_non_nullable
                        as double,
            balance:
                null == balance
                    ? _value.balance
                    : balance // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExpiredFundInfoModelImplCopyWith<$Res>
    implements $ExpiredFundInfoModelCopyWith<$Res> {
  factory _$$ExpiredFundInfoModelImplCopyWith(
    _$ExpiredFundInfoModelImpl value,
    $Res Function(_$ExpiredFundInfoModelImpl) then,
  ) = __$$ExpiredFundInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'completion_percentage') int completionPercentage,
    @JsonKey(name: 'total_spent') double totalSpent,
    double target,
    double balance,
  });
}

/// @nodoc
class __$$ExpiredFundInfoModelImplCopyWithImpl<$Res>
    extends _$ExpiredFundInfoModelCopyWithImpl<$Res, _$ExpiredFundInfoModelImpl>
    implements _$$ExpiredFundInfoModelImplCopyWith<$Res> {
  __$$ExpiredFundInfoModelImplCopyWithImpl(
    _$ExpiredFundInfoModelImpl _value,
    $Res Function(_$ExpiredFundInfoModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExpiredFundInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? endDate = freezed,
    Object? completionPercentage = null,
    Object? totalSpent = null,
    Object? target = null,
    Object? balance = null,
  }) {
    return _then(
      _$ExpiredFundInfoModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as int,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        endDate:
            freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        completionPercentage:
            null == completionPercentage
                ? _value.completionPercentage
                : completionPercentage // ignore: cast_nullable_to_non_nullable
                    as int,
        totalSpent:
            null == totalSpent
                ? _value.totalSpent
                : totalSpent // ignore: cast_nullable_to_non_nullable
                    as double,
        target:
            null == target
                ? _value.target
                : target // ignore: cast_nullable_to_non_nullable
                    as double,
        balance:
            null == balance
                ? _value.balance
                : balance // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpiredFundInfoModelImpl implements _ExpiredFundInfoModel {
  const _$ExpiredFundInfoModelImpl({
    required this.id,
    required this.name,
    @JsonKey(name: 'end_date') this.endDate,
    @JsonKey(name: 'completion_percentage') this.completionPercentage = 0,
    @JsonKey(name: 'total_spent') this.totalSpent = 0,
    this.target = 0,
    this.balance = 0,
  });

  factory _$ExpiredFundInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpiredFundInfoModelImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  @JsonKey(name: 'end_date')
  final DateTime? endDate;
  @override
  @JsonKey(name: 'completion_percentage')
  final int completionPercentage;
  @override
  @JsonKey(name: 'total_spent')
  final double totalSpent;
  @override
  @JsonKey()
  final double target;
  @override
  @JsonKey()
  final double balance;

  @override
  String toString() {
    return 'ExpiredFundInfoModel(id: $id, name: $name, endDate: $endDate, completionPercentage: $completionPercentage, totalSpent: $totalSpent, target: $target, balance: $balance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpiredFundInfoModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.completionPercentage, completionPercentage) ||
                other.completionPercentage == completionPercentage) &&
            (identical(other.totalSpent, totalSpent) ||
                other.totalSpent == totalSpent) &&
            (identical(other.target, target) || other.target == target) &&
            (identical(other.balance, balance) || other.balance == balance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    endDate,
    completionPercentage,
    totalSpent,
    target,
    balance,
  );

  /// Create a copy of ExpiredFundInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpiredFundInfoModelImplCopyWith<_$ExpiredFundInfoModelImpl>
  get copyWith =>
      __$$ExpiredFundInfoModelImplCopyWithImpl<_$ExpiredFundInfoModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpiredFundInfoModelImplToJson(this);
  }
}

abstract class _ExpiredFundInfoModel implements ExpiredFundInfoModel {
  const factory _ExpiredFundInfoModel({
    required final int id,
    required final String name,
    @JsonKey(name: 'end_date') final DateTime? endDate,
    @JsonKey(name: 'completion_percentage') final int completionPercentage,
    @JsonKey(name: 'total_spent') final double totalSpent,
    final double target,
    final double balance,
  }) = _$ExpiredFundInfoModelImpl;

  factory _ExpiredFundInfoModel.fromJson(Map<String, dynamic> json) =
      _$ExpiredFundInfoModelImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'end_date')
  DateTime? get endDate;
  @override
  @JsonKey(name: 'completion_percentage')
  int get completionPercentage;
  @override
  @JsonKey(name: 'total_spent')
  double get totalSpent;
  @override
  double get target;
  @override
  double get balance;

  /// Create a copy of ExpiredFundInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpiredFundInfoModelImplCopyWith<_$ExpiredFundInfoModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

ExpiredFundCheckModel _$ExpiredFundCheckModelFromJson(
  Map<String, dynamic> json,
) {
  return _ExpiredFundCheckModel.fromJson(json);
}

/// @nodoc
mixin _$ExpiredFundCheckModel {
  @JsonKey(name: 'has_expired_fund')
  bool get hasExpiredFund => throw _privateConstructorUsedError;
  @JsonKey(name: 'expired_fund')
  ExpiredFundInfoModel? get expiredFund => throw _privateConstructorUsedError;

  /// Serializes this ExpiredFundCheckModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExpiredFundCheckModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpiredFundCheckModelCopyWith<ExpiredFundCheckModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpiredFundCheckModelCopyWith<$Res> {
  factory $ExpiredFundCheckModelCopyWith(
    ExpiredFundCheckModel value,
    $Res Function(ExpiredFundCheckModel) then,
  ) = _$ExpiredFundCheckModelCopyWithImpl<$Res, ExpiredFundCheckModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'has_expired_fund') bool hasExpiredFund,
    @JsonKey(name: 'expired_fund') ExpiredFundInfoModel? expiredFund,
  });

  $ExpiredFundInfoModelCopyWith<$Res>? get expiredFund;
}

/// @nodoc
class _$ExpiredFundCheckModelCopyWithImpl<
  $Res,
  $Val extends ExpiredFundCheckModel
>
    implements $ExpiredFundCheckModelCopyWith<$Res> {
  _$ExpiredFundCheckModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpiredFundCheckModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? hasExpiredFund = null, Object? expiredFund = freezed}) {
    return _then(
      _value.copyWith(
            hasExpiredFund:
                null == hasExpiredFund
                    ? _value.hasExpiredFund
                    : hasExpiredFund // ignore: cast_nullable_to_non_nullable
                        as bool,
            expiredFund:
                freezed == expiredFund
                    ? _value.expiredFund
                    : expiredFund // ignore: cast_nullable_to_non_nullable
                        as ExpiredFundInfoModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of ExpiredFundCheckModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExpiredFundInfoModelCopyWith<$Res>? get expiredFund {
    if (_value.expiredFund == null) {
      return null;
    }

    return $ExpiredFundInfoModelCopyWith<$Res>(_value.expiredFund!, (value) {
      return _then(_value.copyWith(expiredFund: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ExpiredFundCheckModelImplCopyWith<$Res>
    implements $ExpiredFundCheckModelCopyWith<$Res> {
  factory _$$ExpiredFundCheckModelImplCopyWith(
    _$ExpiredFundCheckModelImpl value,
    $Res Function(_$ExpiredFundCheckModelImpl) then,
  ) = __$$ExpiredFundCheckModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'has_expired_fund') bool hasExpiredFund,
    @JsonKey(name: 'expired_fund') ExpiredFundInfoModel? expiredFund,
  });

  @override
  $ExpiredFundInfoModelCopyWith<$Res>? get expiredFund;
}

/// @nodoc
class __$$ExpiredFundCheckModelImplCopyWithImpl<$Res>
    extends
        _$ExpiredFundCheckModelCopyWithImpl<$Res, _$ExpiredFundCheckModelImpl>
    implements _$$ExpiredFundCheckModelImplCopyWith<$Res> {
  __$$ExpiredFundCheckModelImplCopyWithImpl(
    _$ExpiredFundCheckModelImpl _value,
    $Res Function(_$ExpiredFundCheckModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExpiredFundCheckModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? hasExpiredFund = null, Object? expiredFund = freezed}) {
    return _then(
      _$ExpiredFundCheckModelImpl(
        hasExpiredFund:
            null == hasExpiredFund
                ? _value.hasExpiredFund
                : hasExpiredFund // ignore: cast_nullable_to_non_nullable
                    as bool,
        expiredFund:
            freezed == expiredFund
                ? _value.expiredFund
                : expiredFund // ignore: cast_nullable_to_non_nullable
                    as ExpiredFundInfoModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpiredFundCheckModelImpl implements _ExpiredFundCheckModel {
  const _$ExpiredFundCheckModelImpl({
    @JsonKey(name: 'has_expired_fund') this.hasExpiredFund = false,
    @JsonKey(name: 'expired_fund') this.expiredFund,
  });

  factory _$ExpiredFundCheckModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpiredFundCheckModelImplFromJson(json);

  @override
  @JsonKey(name: 'has_expired_fund')
  final bool hasExpiredFund;
  @override
  @JsonKey(name: 'expired_fund')
  final ExpiredFundInfoModel? expiredFund;

  @override
  String toString() {
    return 'ExpiredFundCheckModel(hasExpiredFund: $hasExpiredFund, expiredFund: $expiredFund)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpiredFundCheckModelImpl &&
            (identical(other.hasExpiredFund, hasExpiredFund) ||
                other.hasExpiredFund == hasExpiredFund) &&
            (identical(other.expiredFund, expiredFund) ||
                other.expiredFund == expiredFund));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, hasExpiredFund, expiredFund);

  /// Create a copy of ExpiredFundCheckModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpiredFundCheckModelImplCopyWith<_$ExpiredFundCheckModelImpl>
  get copyWith =>
      __$$ExpiredFundCheckModelImplCopyWithImpl<_$ExpiredFundCheckModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpiredFundCheckModelImplToJson(this);
  }
}

abstract class _ExpiredFundCheckModel implements ExpiredFundCheckModel {
  const factory _ExpiredFundCheckModel({
    @JsonKey(name: 'has_expired_fund') final bool hasExpiredFund,
    @JsonKey(name: 'expired_fund') final ExpiredFundInfoModel? expiredFund,
  }) = _$ExpiredFundCheckModelImpl;

  factory _ExpiredFundCheckModel.fromJson(Map<String, dynamic> json) =
      _$ExpiredFundCheckModelImpl.fromJson;

  @override
  @JsonKey(name: 'has_expired_fund')
  bool get hasExpiredFund;
  @override
  @JsonKey(name: 'expired_fund')
  ExpiredFundInfoModel? get expiredFund;

  /// Create a copy of ExpiredFundCheckModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpiredFundCheckModelImplCopyWith<_$ExpiredFundCheckModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
