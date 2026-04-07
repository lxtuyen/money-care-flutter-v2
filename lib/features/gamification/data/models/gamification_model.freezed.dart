// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gamification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GamificationModel _$GamificationModelFromJson(Map<String, dynamic> json) {
  return _GamificationModel.fromJson(json);
}

/// @nodoc
mixin _$GamificationModel {
  int get userId => throw _privateConstructorUsedError;
  int get currentStreak => throw _privateConstructorUsedError;
  DateTime? get lastTransactionDate => throw _privateConstructorUsedError;
  List<BadgeModel> get badges => throw _privateConstructorUsedError;

  /// Serializes this GamificationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GamificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GamificationModelCopyWith<GamificationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GamificationModelCopyWith<$Res> {
  factory $GamificationModelCopyWith(
    GamificationModel value,
    $Res Function(GamificationModel) then,
  ) = _$GamificationModelCopyWithImpl<$Res, GamificationModel>;
  @useResult
  $Res call({
    int userId,
    int currentStreak,
    DateTime? lastTransactionDate,
    List<BadgeModel> badges,
  });
}

/// @nodoc
class _$GamificationModelCopyWithImpl<$Res, $Val extends GamificationModel>
    implements $GamificationModelCopyWith<$Res> {
  _$GamificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GamificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? currentStreak = null,
    Object? lastTransactionDate = freezed,
    Object? badges = null,
  }) {
    return _then(
      _value.copyWith(
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as int,
            currentStreak:
                null == currentStreak
                    ? _value.currentStreak
                    : currentStreak // ignore: cast_nullable_to_non_nullable
                        as int,
            lastTransactionDate:
                freezed == lastTransactionDate
                    ? _value.lastTransactionDate
                    : lastTransactionDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            badges:
                null == badges
                    ? _value.badges
                    : badges // ignore: cast_nullable_to_non_nullable
                        as List<BadgeModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GamificationModelImplCopyWith<$Res>
    implements $GamificationModelCopyWith<$Res> {
  factory _$$GamificationModelImplCopyWith(
    _$GamificationModelImpl value,
    $Res Function(_$GamificationModelImpl) then,
  ) = __$$GamificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int userId,
    int currentStreak,
    DateTime? lastTransactionDate,
    List<BadgeModel> badges,
  });
}

/// @nodoc
class __$$GamificationModelImplCopyWithImpl<$Res>
    extends _$GamificationModelCopyWithImpl<$Res, _$GamificationModelImpl>
    implements _$$GamificationModelImplCopyWith<$Res> {
  __$$GamificationModelImplCopyWithImpl(
    _$GamificationModelImpl _value,
    $Res Function(_$GamificationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GamificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? currentStreak = null,
    Object? lastTransactionDate = freezed,
    Object? badges = null,
  }) {
    return _then(
      _$GamificationModelImpl(
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as int,
        currentStreak:
            null == currentStreak
                ? _value.currentStreak
                : currentStreak // ignore: cast_nullable_to_non_nullable
                    as int,
        lastTransactionDate:
            freezed == lastTransactionDate
                ? _value.lastTransactionDate
                : lastTransactionDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        badges:
            null == badges
                ? _value._badges
                : badges // ignore: cast_nullable_to_non_nullable
                    as List<BadgeModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GamificationModelImpl extends _GamificationModel {
  const _$GamificationModelImpl({
    required this.userId,
    this.currentStreak = 0,
    this.lastTransactionDate,
    final List<BadgeModel> badges = const [],
  }) : _badges = badges,
       super._();

  factory _$GamificationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GamificationModelImplFromJson(json);

  @override
  final int userId;
  @override
  @JsonKey()
  final int currentStreak;
  @override
  final DateTime? lastTransactionDate;
  final List<BadgeModel> _badges;
  @override
  @JsonKey()
  List<BadgeModel> get badges {
    if (_badges is EqualUnmodifiableListView) return _badges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_badges);
  }

  @override
  String toString() {
    return 'GamificationModel(userId: $userId, currentStreak: $currentStreak, lastTransactionDate: $lastTransactionDate, badges: $badges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GamificationModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.lastTransactionDate, lastTransactionDate) ||
                other.lastTransactionDate == lastTransactionDate) &&
            const DeepCollectionEquality().equals(other._badges, _badges));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    currentStreak,
    lastTransactionDate,
    const DeepCollectionEquality().hash(_badges),
  );

  /// Create a copy of GamificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GamificationModelImplCopyWith<_$GamificationModelImpl> get copyWith =>
      __$$GamificationModelImplCopyWithImpl<_$GamificationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GamificationModelImplToJson(this);
  }
}

abstract class _GamificationModel extends GamificationModel {
  const factory _GamificationModel({
    required final int userId,
    final int currentStreak,
    final DateTime? lastTransactionDate,
    final List<BadgeModel> badges,
  }) = _$GamificationModelImpl;
  const _GamificationModel._() : super._();

  factory _GamificationModel.fromJson(Map<String, dynamic> json) =
      _$GamificationModelImpl.fromJson;

  @override
  int get userId;
  @override
  int get currentStreak;
  @override
  DateTime? get lastTransactionDate;
  @override
  List<BadgeModel> get badges;

  /// Create a copy of GamificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GamificationModelImplCopyWith<_$GamificationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
