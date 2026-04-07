// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_totals_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TransactionTotalsDto _$TransactionTotalsDtoFromJson(Map<String, dynamic> json) {
  return _TransactionTotalsDto.fromJson(json);
}

/// @nodoc
mixin _$TransactionTotalsDto {
  @JsonKey(name: 'fundId')
  int? get fundId => throw _privateConstructorUsedError;
  String? get startDate => throw _privateConstructorUsedError;
  String? get endDate => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;

  /// Serializes this TransactionTotalsDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransactionTotalsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionTotalsDtoCopyWith<TransactionTotalsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionTotalsDtoCopyWith<$Res> {
  factory $TransactionTotalsDtoCopyWith(
    TransactionTotalsDto value,
    $Res Function(TransactionTotalsDto) then,
  ) = _$TransactionTotalsDtoCopyWithImpl<$Res, TransactionTotalsDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'fundId') int? fundId,
    String? startDate,
    String? endDate,
    String? type,
  });
}

/// @nodoc
class _$TransactionTotalsDtoCopyWithImpl<
  $Res,
  $Val extends TransactionTotalsDto
>
    implements $TransactionTotalsDtoCopyWith<$Res> {
  _$TransactionTotalsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionTotalsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fundId = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? type = freezed,
  }) {
    return _then(
      _value.copyWith(
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
            type:
                freezed == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransactionTotalsDtoImplCopyWith<$Res>
    implements $TransactionTotalsDtoCopyWith<$Res> {
  factory _$$TransactionTotalsDtoImplCopyWith(
    _$TransactionTotalsDtoImpl value,
    $Res Function(_$TransactionTotalsDtoImpl) then,
  ) = __$$TransactionTotalsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'fundId') int? fundId,
    String? startDate,
    String? endDate,
    String? type,
  });
}

/// @nodoc
class __$$TransactionTotalsDtoImplCopyWithImpl<$Res>
    extends _$TransactionTotalsDtoCopyWithImpl<$Res, _$TransactionTotalsDtoImpl>
    implements _$$TransactionTotalsDtoImplCopyWith<$Res> {
  __$$TransactionTotalsDtoImplCopyWithImpl(
    _$TransactionTotalsDtoImpl _value,
    $Res Function(_$TransactionTotalsDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionTotalsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fundId = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? type = freezed,
  }) {
    return _then(
      _$TransactionTotalsDtoImpl(
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
        type:
            freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class _$TransactionTotalsDtoImpl implements _TransactionTotalsDto {
  const _$TransactionTotalsDtoImpl({
    @JsonKey(name: 'fundId') this.fundId,
    this.startDate,
    this.endDate,
    this.type,
  });

  factory _$TransactionTotalsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionTotalsDtoImplFromJson(json);

  @override
  @JsonKey(name: 'fundId')
  final int? fundId;
  @override
  final String? startDate;
  @override
  final String? endDate;
  @override
  final String? type;

  @override
  String toString() {
    return 'TransactionTotalsDto(fundId: $fundId, startDate: $startDate, endDate: $endDate, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionTotalsDtoImpl &&
            (identical(other.fundId, fundId) || other.fundId == fundId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, fundId, startDate, endDate, type);

  /// Create a copy of TransactionTotalsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionTotalsDtoImplCopyWith<_$TransactionTotalsDtoImpl>
  get copyWith =>
      __$$TransactionTotalsDtoImplCopyWithImpl<_$TransactionTotalsDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionTotalsDtoImplToJson(this);
  }
}

abstract class _TransactionTotalsDto implements TransactionTotalsDto {
  const factory _TransactionTotalsDto({
    @JsonKey(name: 'fundId') final int? fundId,
    final String? startDate,
    final String? endDate,
    final String? type,
  }) = _$TransactionTotalsDtoImpl;

  factory _TransactionTotalsDto.fromJson(Map<String, dynamic> json) =
      _$TransactionTotalsDtoImpl.fromJson;

  @override
  @JsonKey(name: 'fundId')
  int? get fundId;
  @override
  String? get startDate;
  @override
  String? get endDate;
  @override
  String? get type;

  /// Create a copy of TransactionTotalsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionTotalsDtoImplCopyWith<_$TransactionTotalsDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
