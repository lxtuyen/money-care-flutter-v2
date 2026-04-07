// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'finance_mode_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FinanceModeModel _$FinanceModeModelFromJson(Map<String, dynamic> json) {
  return _FinanceModeModel.fromJson(json);
}

/// @nodoc
mixin _$FinanceModeModel {
  int get userId => throw _privateConstructorUsedError;
  @JsonKey(toJson: _modeToJson)
  String get mode => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get suggestionCooldownUntil => throw _privateConstructorUsedError;

  /// Serializes this FinanceModeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FinanceModeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FinanceModeModelCopyWith<FinanceModeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinanceModeModelCopyWith<$Res> {
  factory $FinanceModeModelCopyWith(
    FinanceModeModel value,
    $Res Function(FinanceModeModel) then,
  ) = _$FinanceModeModelCopyWithImpl<$Res, FinanceModeModel>;
  @useResult
  $Res call({
    int userId,
    @JsonKey(toJson: _modeToJson) String mode,
    DateTime updatedAt,
    DateTime? suggestionCooldownUntil,
  });
}

/// @nodoc
class _$FinanceModeModelCopyWithImpl<$Res, $Val extends FinanceModeModel>
    implements $FinanceModeModelCopyWith<$Res> {
  _$FinanceModeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FinanceModeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? mode = null,
    Object? updatedAt = null,
    Object? suggestionCooldownUntil = freezed,
  }) {
    return _then(
      _value.copyWith(
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as int,
            mode:
                null == mode
                    ? _value.mode
                    : mode // ignore: cast_nullable_to_non_nullable
                        as String,
            updatedAt:
                null == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            suggestionCooldownUntil:
                freezed == suggestionCooldownUntil
                    ? _value.suggestionCooldownUntil
                    : suggestionCooldownUntil // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FinanceModeModelImplCopyWith<$Res>
    implements $FinanceModeModelCopyWith<$Res> {
  factory _$$FinanceModeModelImplCopyWith(
    _$FinanceModeModelImpl value,
    $Res Function(_$FinanceModeModelImpl) then,
  ) = __$$FinanceModeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int userId,
    @JsonKey(toJson: _modeToJson) String mode,
    DateTime updatedAt,
    DateTime? suggestionCooldownUntil,
  });
}

/// @nodoc
class __$$FinanceModeModelImplCopyWithImpl<$Res>
    extends _$FinanceModeModelCopyWithImpl<$Res, _$FinanceModeModelImpl>
    implements _$$FinanceModeModelImplCopyWith<$Res> {
  __$$FinanceModeModelImplCopyWithImpl(
    _$FinanceModeModelImpl _value,
    $Res Function(_$FinanceModeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FinanceModeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? mode = null,
    Object? updatedAt = null,
    Object? suggestionCooldownUntil = freezed,
  }) {
    return _then(
      _$FinanceModeModelImpl(
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as int,
        mode:
            null == mode
                ? _value.mode
                : mode // ignore: cast_nullable_to_non_nullable
                    as String,
        updatedAt:
            null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        suggestionCooldownUntil:
            freezed == suggestionCooldownUntil
                ? _value.suggestionCooldownUntil
                : suggestionCooldownUntil // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FinanceModeModelImpl extends _FinanceModeModel {
  const _$FinanceModeModelImpl({
    required this.userId,
    @JsonKey(toJson: _modeToJson) required this.mode,
    required this.updatedAt,
    this.suggestionCooldownUntil,
  }) : super._();

  factory _$FinanceModeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinanceModeModelImplFromJson(json);

  @override
  final int userId;
  @override
  @JsonKey(toJson: _modeToJson)
  final String mode;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? suggestionCooldownUntil;

  @override
  String toString() {
    return 'FinanceModeModel(userId: $userId, mode: $mode, updatedAt: $updatedAt, suggestionCooldownUntil: $suggestionCooldownUntil)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinanceModeModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(
                  other.suggestionCooldownUntil,
                  suggestionCooldownUntil,
                ) ||
                other.suggestionCooldownUntil == suggestionCooldownUntil));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    mode,
    updatedAt,
    suggestionCooldownUntil,
  );

  /// Create a copy of FinanceModeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinanceModeModelImplCopyWith<_$FinanceModeModelImpl> get copyWith =>
      __$$FinanceModeModelImplCopyWithImpl<_$FinanceModeModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FinanceModeModelImplToJson(this);
  }
}

abstract class _FinanceModeModel extends FinanceModeModel {
  const factory _FinanceModeModel({
    required final int userId,
    @JsonKey(toJson: _modeToJson) required final String mode,
    required final DateTime updatedAt,
    final DateTime? suggestionCooldownUntil,
  }) = _$FinanceModeModelImpl;
  const _FinanceModeModel._() : super._();

  factory _FinanceModeModel.fromJson(Map<String, dynamic> json) =
      _$FinanceModeModelImpl.fromJson;

  @override
  int get userId;
  @override
  @JsonKey(toJson: _modeToJson)
  String get mode;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get suggestionCooldownUntil;

  /// Create a copy of FinanceModeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinanceModeModelImplCopyWith<_$FinanceModeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
