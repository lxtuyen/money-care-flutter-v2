// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fund_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FundDto {
  String? get name => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  List<CategoryEntity>? get categories => throw _privateConstructorUsedError;
  int? get id => throw _privateConstructorUsedError;
  double? get balance => throw _privateConstructorUsedError;
  double? get target => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_date')
  DateTime? get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date')
  DateTime? get endDate => throw _privateConstructorUsedError;

  /// Create a copy of FundDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FundDtoCopyWith<FundDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FundDtoCopyWith<$Res> {
  factory $FundDtoCopyWith(FundDto value, $Res Function(FundDto) then) =
      _$FundDtoCopyWithImpl<$Res, FundDto>;
  @useResult
  $Res call({
    String? name,
    String? type,
    List<CategoryEntity>? categories,
    int? id,
    double? balance,
    double? target,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
  });
}

/// @nodoc
class _$FundDtoCopyWithImpl<$Res, $Val extends FundDto>
    implements $FundDtoCopyWith<$Res> {
  _$FundDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FundDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? type = freezed,
    Object? categories = freezed,
    Object? id = freezed,
    Object? balance = freezed,
    Object? target = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
  }) {
    return _then(
      _value.copyWith(
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
            type:
                freezed == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as String?,
            categories:
                freezed == categories
                    ? _value.categories
                    : categories // ignore: cast_nullable_to_non_nullable
                        as List<CategoryEntity>?,
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as int?,
            balance:
                freezed == balance
                    ? _value.balance
                    : balance // ignore: cast_nullable_to_non_nullable
                        as double?,
            target:
                freezed == target
                    ? _value.target
                    : target // ignore: cast_nullable_to_non_nullable
                        as double?,
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FundDtoImplCopyWith<$Res> implements $FundDtoCopyWith<$Res> {
  factory _$$FundDtoImplCopyWith(
    _$FundDtoImpl value,
    $Res Function(_$FundDtoImpl) then,
  ) = __$$FundDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? name,
    String? type,
    List<CategoryEntity>? categories,
    int? id,
    double? balance,
    double? target,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
  });
}

/// @nodoc
class __$$FundDtoImplCopyWithImpl<$Res>
    extends _$FundDtoCopyWithImpl<$Res, _$FundDtoImpl>
    implements _$$FundDtoImplCopyWith<$Res> {
  __$$FundDtoImplCopyWithImpl(
    _$FundDtoImpl _value,
    $Res Function(_$FundDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FundDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? type = freezed,
    Object? categories = freezed,
    Object? id = freezed,
    Object? balance = freezed,
    Object? target = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
  }) {
    return _then(
      _$FundDtoImpl(
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        type:
            freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as String?,
        categories:
            freezed == categories
                ? _value._categories
                : categories // ignore: cast_nullable_to_non_nullable
                    as List<CategoryEntity>?,
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as int?,
        balance:
            freezed == balance
                ? _value.balance
                : balance // ignore: cast_nullable_to_non_nullable
                    as double?,
        target:
            freezed == target
                ? _value.target
                : target // ignore: cast_nullable_to_non_nullable
                    as double?,
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
      ),
    );
  }
}

/// @nodoc

class _$FundDtoImpl extends _FundDto {
  const _$FundDtoImpl({
    this.name,
    this.type,
    final List<CategoryEntity>? categories,
    this.id,
    this.balance,
    this.target,
    @JsonKey(name: 'start_date') this.startDate,
    @JsonKey(name: 'end_date') this.endDate,
  }) : _categories = categories,
       super._();

  @override
  final String? name;
  @override
  final String? type;
  final List<CategoryEntity>? _categories;
  @override
  List<CategoryEntity>? get categories {
    final value = _categories;
    if (value == null) return null;
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? id;
  @override
  final double? balance;
  @override
  final double? target;
  @override
  @JsonKey(name: 'start_date')
  final DateTime? startDate;
  @override
  @JsonKey(name: 'end_date')
  final DateTime? endDate;

  @override
  String toString() {
    return 'FundDto(name: $name, type: $type, categories: $categories, id: $id, balance: $balance, target: $target, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FundDtoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.target, target) || other.target == target) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    type,
    const DeepCollectionEquality().hash(_categories),
    id,
    balance,
    target,
    startDate,
    endDate,
  );

  /// Create a copy of FundDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FundDtoImplCopyWith<_$FundDtoImpl> get copyWith =>
      __$$FundDtoImplCopyWithImpl<_$FundDtoImpl>(this, _$identity);
}

abstract class _FundDto extends FundDto {
  const factory _FundDto({
    final String? name,
    final String? type,
    final List<CategoryEntity>? categories,
    final int? id,
    final double? balance,
    final double? target,
    @JsonKey(name: 'start_date') final DateTime? startDate,
    @JsonKey(name: 'end_date') final DateTime? endDate,
  }) = _$FundDtoImpl;
  const _FundDto._() : super._();

  @override
  String? get name;
  @override
  String? get type;
  @override
  List<CategoryEntity>? get categories;
  @override
  int? get id;
  @override
  double? get balance;
  @override
  double? get target;
  @override
  @JsonKey(name: 'start_date')
  DateTime? get startDate;
  @override
  @JsonKey(name: 'end_date')
  DateTime? get endDate;

  /// Create a copy of FundDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FundDtoImplCopyWith<_$FundDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
