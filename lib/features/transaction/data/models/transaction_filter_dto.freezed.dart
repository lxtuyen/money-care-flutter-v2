// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_filter_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TransactionFilterDto _$TransactionFilterDtoFromJson(Map<String, dynamic> json) {
  return _TransactionFilterDto.fromJson(json);
}

/// @nodoc
mixin _$TransactionFilterDto {
  @JsonKey(name: 'categoryId')
  int? get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'fundId')
  int? get fundId => throw _privateConstructorUsedError;
  String? get startDate => throw _privateConstructorUsedError;
  String? get endDate => throw _privateConstructorUsedError;

  /// Serializes this TransactionFilterDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransactionFilterDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionFilterDtoCopyWith<TransactionFilterDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionFilterDtoCopyWith<$Res> {
  factory $TransactionFilterDtoCopyWith(
    TransactionFilterDto value,
    $Res Function(TransactionFilterDto) then,
  ) = _$TransactionFilterDtoCopyWithImpl<$Res, TransactionFilterDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'categoryId') int? categoryId,
    @JsonKey(name: 'fundId') int? fundId,
    String? startDate,
    String? endDate,
  });
}

/// @nodoc
class _$TransactionFilterDtoCopyWithImpl<
  $Res,
  $Val extends TransactionFilterDto
>
    implements $TransactionFilterDtoCopyWith<$Res> {
  _$TransactionFilterDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionFilterDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = freezed,
    Object? fundId = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
  }) {
    return _then(
      _value.copyWith(
            categoryId:
                freezed == categoryId
                    ? _value.categoryId
                    : categoryId // ignore: cast_nullable_to_non_nullable
                        as int?,
            fundId:
                freezed == fundId
                    ? _value.fundId
                    : fundId // ignore: cast_nullable_to_non_nullable
                        as int?,
            startDate:
                freezed == startDate
                    ? _value.startDate
                    : startDate // ignore: cast_nullable_to_non_nullable
                        as String?,
            endDate:
                freezed == endDate
                    ? _value.endDate
                    : endDate // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransactionFilterDtoImplCopyWith<$Res>
    implements $TransactionFilterDtoCopyWith<$Res> {
  factory _$$TransactionFilterDtoImplCopyWith(
    _$TransactionFilterDtoImpl value,
    $Res Function(_$TransactionFilterDtoImpl) then,
  ) = __$$TransactionFilterDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'categoryId') int? categoryId,
    @JsonKey(name: 'fundId') int? fundId,
    String? startDate,
    String? endDate,
  });
}

/// @nodoc
class __$$TransactionFilterDtoImplCopyWithImpl<$Res>
    extends _$TransactionFilterDtoCopyWithImpl<$Res, _$TransactionFilterDtoImpl>
    implements _$$TransactionFilterDtoImplCopyWith<$Res> {
  __$$TransactionFilterDtoImplCopyWithImpl(
    _$TransactionFilterDtoImpl _value,
    $Res Function(_$TransactionFilterDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionFilterDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = freezed,
    Object? fundId = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
  }) {
    return _then(
      _$TransactionFilterDtoImpl(
        categoryId:
            freezed == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                    as int?,
        fundId:
            freezed == fundId
                ? _value.fundId
                : fundId // ignore: cast_nullable_to_non_nullable
                    as int?,
        startDate:
            freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                    as String?,
        endDate:
            freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class _$TransactionFilterDtoImpl extends _TransactionFilterDto {
  const _$TransactionFilterDtoImpl({
    @JsonKey(name: 'categoryId') this.categoryId,
    @JsonKey(name: 'fundId') this.fundId,
    this.startDate,
    this.endDate,
  }) : super._();

  factory _$TransactionFilterDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionFilterDtoImplFromJson(json);

  @override
  @JsonKey(name: 'categoryId')
  final int? categoryId;
  @override
  @JsonKey(name: 'fundId')
  final int? fundId;
  @override
  final String? startDate;
  @override
  final String? endDate;

  @override
  String toString() {
    return 'TransactionFilterDto(categoryId: $categoryId, fundId: $fundId, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionFilterDtoImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.fundId, fundId) || other.fundId == fundId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, categoryId, fundId, startDate, endDate);

  /// Create a copy of TransactionFilterDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionFilterDtoImplCopyWith<_$TransactionFilterDtoImpl>
  get copyWith =>
      __$$TransactionFilterDtoImplCopyWithImpl<_$TransactionFilterDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionFilterDtoImplToJson(this);
  }
}

abstract class _TransactionFilterDto extends TransactionFilterDto {
  const factory _TransactionFilterDto({
    @JsonKey(name: 'categoryId') final int? categoryId,
    @JsonKey(name: 'fundId') final int? fundId,
    final String? startDate,
    final String? endDate,
  }) = _$TransactionFilterDtoImpl;
  const _TransactionFilterDto._() : super._();

  factory _TransactionFilterDto.fromJson(Map<String, dynamic> json) =
      _$TransactionFilterDtoImpl.fromJson;

  @override
  @JsonKey(name: 'categoryId')
  int? get categoryId;
  @override
  @JsonKey(name: 'fundId')
  int? get fundId;
  @override
  String? get startDate;
  @override
  String? get endDate;

  /// Create a copy of TransactionFilterDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionFilterDtoImplCopyWith<_$TransactionFilterDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
