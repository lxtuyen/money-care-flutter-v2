// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_create_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TransactionCreateDto _$TransactionCreateDtoFromJson(Map<String, dynamic> json) {
  return _TransactionCreateDto.fromJson(json);
}

/// @nodoc
mixin _$TransactionCreateDto {
  int? get amount => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  @JsonKey(name: 'pictuteURL')
  String? get pictureUrl => throw _privateConstructorUsedError;
  DateTime? get transactionDate => throw _privateConstructorUsedError;
  int? get categoryId => throw _privateConstructorUsedError;
  int? get userId => throw _privateConstructorUsedError;
  int? get fundId => throw _privateConstructorUsedError;

  /// Serializes this TransactionCreateDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransactionCreateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionCreateDtoCopyWith<TransactionCreateDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionCreateDtoCopyWith<$Res> {
  factory $TransactionCreateDtoCopyWith(
    TransactionCreateDto value,
    $Res Function(TransactionCreateDto) then,
  ) = _$TransactionCreateDtoCopyWithImpl<$Res, TransactionCreateDto>;
  @useResult
  $Res call({
    int? amount,
    String? type,
    String? note,
    @JsonKey(name: 'pictuteURL') String? pictureUrl,
    DateTime? transactionDate,
    int? categoryId,
    int? userId,
    int? fundId,
  });
}

/// @nodoc
class _$TransactionCreateDtoCopyWithImpl<
  $Res,
  $Val extends TransactionCreateDto
>
    implements $TransactionCreateDtoCopyWith<$Res> {
  _$TransactionCreateDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionCreateDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = freezed,
    Object? type = freezed,
    Object? note = freezed,
    Object? pictureUrl = freezed,
    Object? transactionDate = freezed,
    Object? categoryId = freezed,
    Object? userId = freezed,
    Object? fundId = freezed,
  }) {
    return _then(
      _value.copyWith(
            amount:
                freezed == amount
                    ? _value.amount
                    : amount // ignore: cast_nullable_to_non_nullable
                        as int?,
            type:
                freezed == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as String?,
            note:
                freezed == note
                    ? _value.note
                    : note // ignore: cast_nullable_to_non_nullable
                        as String?,
            pictureUrl:
                freezed == pictureUrl
                    ? _value.pictureUrl
                    : pictureUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            transactionDate:
                freezed == transactionDate
                    ? _value.transactionDate
                    : transactionDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            categoryId:
                freezed == categoryId
                    ? _value.categoryId
                    : categoryId // ignore: cast_nullable_to_non_nullable
                        as int?,
            userId:
                freezed == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as int?,
            fundId:
                freezed == fundId
                    ? _value.fundId
                    : fundId // ignore: cast_nullable_to_non_nullable
                        as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransactionCreateDtoImplCopyWith<$Res>
    implements $TransactionCreateDtoCopyWith<$Res> {
  factory _$$TransactionCreateDtoImplCopyWith(
    _$TransactionCreateDtoImpl value,
    $Res Function(_$TransactionCreateDtoImpl) then,
  ) = __$$TransactionCreateDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? amount,
    String? type,
    String? note,
    @JsonKey(name: 'pictuteURL') String? pictureUrl,
    DateTime? transactionDate,
    int? categoryId,
    int? userId,
    int? fundId,
  });
}

/// @nodoc
class __$$TransactionCreateDtoImplCopyWithImpl<$Res>
    extends _$TransactionCreateDtoCopyWithImpl<$Res, _$TransactionCreateDtoImpl>
    implements _$$TransactionCreateDtoImplCopyWith<$Res> {
  __$$TransactionCreateDtoImplCopyWithImpl(
    _$TransactionCreateDtoImpl _value,
    $Res Function(_$TransactionCreateDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionCreateDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = freezed,
    Object? type = freezed,
    Object? note = freezed,
    Object? pictureUrl = freezed,
    Object? transactionDate = freezed,
    Object? categoryId = freezed,
    Object? userId = freezed,
    Object? fundId = freezed,
  }) {
    return _then(
      _$TransactionCreateDtoImpl(
        amount:
            freezed == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                    as int?,
        type:
            freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as String?,
        note:
            freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                    as String?,
        pictureUrl:
            freezed == pictureUrl
                ? _value.pictureUrl
                : pictureUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        transactionDate:
            freezed == transactionDate
                ? _value.transactionDate
                : transactionDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        categoryId:
            freezed == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                    as int?,
        userId:
            freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as int?,
        fundId:
            freezed == fundId
                ? _value.fundId
                : fundId // ignore: cast_nullable_to_non_nullable
                    as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionCreateDtoImpl implements _TransactionCreateDto {
  const _$TransactionCreateDtoImpl({
    this.amount,
    this.type,
    this.note,
    @JsonKey(name: 'pictuteURL') this.pictureUrl,
    this.transactionDate,
    this.categoryId,
    this.userId,
    this.fundId,
  });

  factory _$TransactionCreateDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionCreateDtoImplFromJson(json);

  @override
  final int? amount;
  @override
  final String? type;
  @override
  final String? note;
  @override
  @JsonKey(name: 'pictuteURL')
  final String? pictureUrl;
  @override
  final DateTime? transactionDate;
  @override
  final int? categoryId;
  @override
  final int? userId;
  @override
  final int? fundId;

  @override
  String toString() {
    return 'TransactionCreateDto(amount: $amount, type: $type, note: $note, pictureUrl: $pictureUrl, transactionDate: $transactionDate, categoryId: $categoryId, userId: $userId, fundId: $fundId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionCreateDtoImpl &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.pictureUrl, pictureUrl) ||
                other.pictureUrl == pictureUrl) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.fundId, fundId) || other.fundId == fundId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    amount,
    type,
    note,
    pictureUrl,
    transactionDate,
    categoryId,
    userId,
    fundId,
  );

  /// Create a copy of TransactionCreateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionCreateDtoImplCopyWith<_$TransactionCreateDtoImpl>
  get copyWith =>
      __$$TransactionCreateDtoImplCopyWithImpl<_$TransactionCreateDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionCreateDtoImplToJson(this);
  }
}

abstract class _TransactionCreateDto implements TransactionCreateDto {
  const factory _TransactionCreateDto({
    final int? amount,
    final String? type,
    final String? note,
    @JsonKey(name: 'pictuteURL') final String? pictureUrl,
    final DateTime? transactionDate,
    final int? categoryId,
    final int? userId,
    final int? fundId,
  }) = _$TransactionCreateDtoImpl;

  factory _TransactionCreateDto.fromJson(Map<String, dynamic> json) =
      _$TransactionCreateDtoImpl.fromJson;

  @override
  int? get amount;
  @override
  String? get type;
  @override
  String? get note;
  @override
  @JsonKey(name: 'pictuteURL')
  String? get pictureUrl;
  @override
  DateTime? get transactionDate;
  @override
  int? get categoryId;
  @override
  int? get userId;
  @override
  int? get fundId;

  /// Create a copy of TransactionCreateDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionCreateDtoImplCopyWith<_$TransactionCreateDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
