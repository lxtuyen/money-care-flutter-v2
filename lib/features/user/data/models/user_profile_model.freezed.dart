// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProfileUpdateDto _$ProfileUpdateDtoFromJson(Map<String, dynamic> json) {
  return _ProfileUpdateDto.fromJson(json);
}

/// @nodoc
mixin _$ProfileUpdateDto {
  String? get firstName => throw _privateConstructorUsedError;
  String? get lastName => throw _privateConstructorUsedError;
  int? get monthlyIncome => throw _privateConstructorUsedError;
  DateTime? get incomeDate => throw _privateConstructorUsedError;

  /// Serializes this ProfileUpdateDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProfileUpdateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileUpdateDtoCopyWith<ProfileUpdateDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileUpdateDtoCopyWith<$Res> {
  factory $ProfileUpdateDtoCopyWith(
    ProfileUpdateDto value,
    $Res Function(ProfileUpdateDto) then,
  ) = _$ProfileUpdateDtoCopyWithImpl<$Res, ProfileUpdateDto>;
  @useResult
  $Res call({
    String? firstName,
    String? lastName,
    int? monthlyIncome,
    DateTime? incomeDate,
  });
}

/// @nodoc
class _$ProfileUpdateDtoCopyWithImpl<$Res, $Val extends ProfileUpdateDto>
    implements $ProfileUpdateDtoCopyWith<$Res> {
  _$ProfileUpdateDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileUpdateDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? monthlyIncome = freezed,
    Object? incomeDate = freezed,
  }) {
    return _then(
      _value.copyWith(
            firstName:
                freezed == firstName
                    ? _value.firstName
                    : firstName // ignore: cast_nullable_to_non_nullable
                        as String?,
            lastName:
                freezed == lastName
                    ? _value.lastName
                    : lastName // ignore: cast_nullable_to_non_nullable
                        as String?,
            monthlyIncome:
                freezed == monthlyIncome
                    ? _value.monthlyIncome
                    : monthlyIncome // ignore: cast_nullable_to_non_nullable
                        as int?,
            incomeDate:
                freezed == incomeDate
                    ? _value.incomeDate
                    : incomeDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProfileUpdateDtoImplCopyWith<$Res>
    implements $ProfileUpdateDtoCopyWith<$Res> {
  factory _$$ProfileUpdateDtoImplCopyWith(
    _$ProfileUpdateDtoImpl value,
    $Res Function(_$ProfileUpdateDtoImpl) then,
  ) = __$$ProfileUpdateDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? firstName,
    String? lastName,
    int? monthlyIncome,
    DateTime? incomeDate,
  });
}

/// @nodoc
class __$$ProfileUpdateDtoImplCopyWithImpl<$Res>
    extends _$ProfileUpdateDtoCopyWithImpl<$Res, _$ProfileUpdateDtoImpl>
    implements _$$ProfileUpdateDtoImplCopyWith<$Res> {
  __$$ProfileUpdateDtoImplCopyWithImpl(
    _$ProfileUpdateDtoImpl _value,
    $Res Function(_$ProfileUpdateDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProfileUpdateDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? monthlyIncome = freezed,
    Object? incomeDate = freezed,
  }) {
    return _then(
      _$ProfileUpdateDtoImpl(
        firstName:
            freezed == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                    as String?,
        lastName:
            freezed == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                    as String?,
        monthlyIncome:
            freezed == monthlyIncome
                ? _value.monthlyIncome
                : monthlyIncome // ignore: cast_nullable_to_non_nullable
                    as int?,
        incomeDate:
            freezed == incomeDate
                ? _value.incomeDate
                : incomeDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class _$ProfileUpdateDtoImpl implements _ProfileUpdateDto {
  const _$ProfileUpdateDtoImpl({
    this.firstName,
    this.lastName,
    this.monthlyIncome,
    this.incomeDate,
  });

  factory _$ProfileUpdateDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileUpdateDtoImplFromJson(json);

  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final int? monthlyIncome;
  @override
  final DateTime? incomeDate;

  @override
  String toString() {
    return 'ProfileUpdateDto(firstName: $firstName, lastName: $lastName, monthlyIncome: $monthlyIncome, incomeDate: $incomeDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileUpdateDtoImpl &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.monthlyIncome, monthlyIncome) ||
                other.monthlyIncome == monthlyIncome) &&
            (identical(other.incomeDate, incomeDate) ||
                other.incomeDate == incomeDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, firstName, lastName, monthlyIncome, incomeDate);

  /// Create a copy of ProfileUpdateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileUpdateDtoImplCopyWith<_$ProfileUpdateDtoImpl> get copyWith =>
      __$$ProfileUpdateDtoImplCopyWithImpl<_$ProfileUpdateDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileUpdateDtoImplToJson(this);
  }
}

abstract class _ProfileUpdateDto implements ProfileUpdateDto {
  const factory _ProfileUpdateDto({
    final String? firstName,
    final String? lastName,
    final int? monthlyIncome,
    final DateTime? incomeDate,
  }) = _$ProfileUpdateDtoImpl;

  factory _ProfileUpdateDto.fromJson(Map<String, dynamic> json) =
      _$ProfileUpdateDtoImpl.fromJson;

  @override
  String? get firstName;
  @override
  String? get lastName;
  @override
  int? get monthlyIncome;
  @override
  DateTime? get incomeDate;

  /// Create a copy of ProfileUpdateDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileUpdateDtoImplCopyWith<_$ProfileUpdateDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserUpdateDto _$UserUpdateDtoFromJson(Map<String, dynamic> json) {
  return _UserUpdateDto.fromJson(json);
}

/// @nodoc
mixin _$UserUpdateDto {
  String? get role => throw _privateConstructorUsedError;
  bool? get isVip => throw _privateConstructorUsedError;

  /// Serializes this UserUpdateDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserUpdateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserUpdateDtoCopyWith<UserUpdateDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserUpdateDtoCopyWith<$Res> {
  factory $UserUpdateDtoCopyWith(
    UserUpdateDto value,
    $Res Function(UserUpdateDto) then,
  ) = _$UserUpdateDtoCopyWithImpl<$Res, UserUpdateDto>;
  @useResult
  $Res call({String? role, bool? isVip});
}

/// @nodoc
class _$UserUpdateDtoCopyWithImpl<$Res, $Val extends UserUpdateDto>
    implements $UserUpdateDtoCopyWith<$Res> {
  _$UserUpdateDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserUpdateDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? role = freezed, Object? isVip = freezed}) {
    return _then(
      _value.copyWith(
            role:
                freezed == role
                    ? _value.role
                    : role // ignore: cast_nullable_to_non_nullable
                        as String?,
            isVip:
                freezed == isVip
                    ? _value.isVip
                    : isVip // ignore: cast_nullable_to_non_nullable
                        as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserUpdateDtoImplCopyWith<$Res>
    implements $UserUpdateDtoCopyWith<$Res> {
  factory _$$UserUpdateDtoImplCopyWith(
    _$UserUpdateDtoImpl value,
    $Res Function(_$UserUpdateDtoImpl) then,
  ) = __$$UserUpdateDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? role, bool? isVip});
}

/// @nodoc
class __$$UserUpdateDtoImplCopyWithImpl<$Res>
    extends _$UserUpdateDtoCopyWithImpl<$Res, _$UserUpdateDtoImpl>
    implements _$$UserUpdateDtoImplCopyWith<$Res> {
  __$$UserUpdateDtoImplCopyWithImpl(
    _$UserUpdateDtoImpl _value,
    $Res Function(_$UserUpdateDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserUpdateDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? role = freezed, Object? isVip = freezed}) {
    return _then(
      _$UserUpdateDtoImpl(
        role:
            freezed == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                    as String?,
        isVip:
            freezed == isVip
                ? _value.isVip
                : isVip // ignore: cast_nullable_to_non_nullable
                    as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserUpdateDtoImpl implements _UserUpdateDto {
  const _$UserUpdateDtoImpl({this.role, this.isVip});

  factory _$UserUpdateDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserUpdateDtoImplFromJson(json);

  @override
  final String? role;
  @override
  final bool? isVip;

  @override
  String toString() {
    return 'UserUpdateDto(role: $role, isVip: $isVip)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserUpdateDtoImpl &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.isVip, isVip) || other.isVip == isVip));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, role, isVip);

  /// Create a copy of UserUpdateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserUpdateDtoImplCopyWith<_$UserUpdateDtoImpl> get copyWith =>
      __$$UserUpdateDtoImplCopyWithImpl<_$UserUpdateDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserUpdateDtoImplToJson(this);
  }
}

abstract class _UserUpdateDto implements UserUpdateDto {
  const factory _UserUpdateDto({final String? role, final bool? isVip}) =
      _$UserUpdateDtoImpl;

  factory _UserUpdateDto.fromJson(Map<String, dynamic> json) =
      _$UserUpdateDtoImpl.fromJson;

  @override
  String? get role;
  @override
  bool? get isVip;

  /// Create a copy of UserUpdateDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserUpdateDtoImplCopyWith<_$UserUpdateDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) {
  return _UserProfileModel.fromJson(json);
}

/// @nodoc
mixin _$UserProfileModel {
  int? get id => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  int? get monthlyIncome => throw _privateConstructorUsedError;
  DateTime? get incomeDate => throw _privateConstructorUsedError;

  /// Serializes this UserProfileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileModelCopyWith<UserProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileModelCopyWith<$Res> {
  factory $UserProfileModelCopyWith(
    UserProfileModel value,
    $Res Function(UserProfileModel) then,
  ) = _$UserProfileModelCopyWithImpl<$Res, UserProfileModel>;
  @useResult
  $Res call({
    int? id,
    String firstName,
    String lastName,
    int? monthlyIncome,
    DateTime? incomeDate,
  });
}

/// @nodoc
class _$UserProfileModelCopyWithImpl<$Res, $Val extends UserProfileModel>
    implements $UserProfileModelCopyWith<$Res> {
  _$UserProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? firstName = null,
    Object? lastName = null,
    Object? monthlyIncome = freezed,
    Object? incomeDate = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as int?,
            firstName:
                null == firstName
                    ? _value.firstName
                    : firstName // ignore: cast_nullable_to_non_nullable
                        as String,
            lastName:
                null == lastName
                    ? _value.lastName
                    : lastName // ignore: cast_nullable_to_non_nullable
                        as String,
            monthlyIncome:
                freezed == monthlyIncome
                    ? _value.monthlyIncome
                    : monthlyIncome // ignore: cast_nullable_to_non_nullable
                        as int?,
            incomeDate:
                freezed == incomeDate
                    ? _value.incomeDate
                    : incomeDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserProfileModelImplCopyWith<$Res>
    implements $UserProfileModelCopyWith<$Res> {
  factory _$$UserProfileModelImplCopyWith(
    _$UserProfileModelImpl value,
    $Res Function(_$UserProfileModelImpl) then,
  ) = __$$UserProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    String firstName,
    String lastName,
    int? monthlyIncome,
    DateTime? incomeDate,
  });
}

/// @nodoc
class __$$UserProfileModelImplCopyWithImpl<$Res>
    extends _$UserProfileModelCopyWithImpl<$Res, _$UserProfileModelImpl>
    implements _$$UserProfileModelImplCopyWith<$Res> {
  __$$UserProfileModelImplCopyWithImpl(
    _$UserProfileModelImpl _value,
    $Res Function(_$UserProfileModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? firstName = null,
    Object? lastName = null,
    Object? monthlyIncome = freezed,
    Object? incomeDate = freezed,
  }) {
    return _then(
      _$UserProfileModelImpl(
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as int?,
        firstName:
            null == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                    as String,
        lastName:
            null == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                    as String,
        monthlyIncome:
            freezed == monthlyIncome
                ? _value.monthlyIncome
                : monthlyIncome // ignore: cast_nullable_to_non_nullable
                    as int?,
        incomeDate:
            freezed == incomeDate
                ? _value.incomeDate
                : incomeDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$UserProfileModelImpl extends _UserProfileModel {
  const _$UserProfileModelImpl({
    this.id,
    required this.firstName,
    required this.lastName,
    this.monthlyIncome,
    this.incomeDate,
  }) : super._();

  factory _$UserProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileModelImplFromJson(json);

  @override
  final int? id;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final int? monthlyIncome;
  @override
  final DateTime? incomeDate;

  @override
  String toString() {
    return 'UserProfileModel(id: $id, firstName: $firstName, lastName: $lastName, monthlyIncome: $monthlyIncome, incomeDate: $incomeDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.monthlyIncome, monthlyIncome) ||
                other.monthlyIncome == monthlyIncome) &&
            (identical(other.incomeDate, incomeDate) ||
                other.incomeDate == incomeDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    firstName,
    lastName,
    monthlyIncome,
    incomeDate,
  );

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileModelImplCopyWith<_$UserProfileModelImpl> get copyWith =>
      __$$UserProfileModelImplCopyWithImpl<_$UserProfileModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileModelImplToJson(this);
  }
}

abstract class _UserProfileModel extends UserProfileModel {
  const factory _UserProfileModel({
    final int? id,
    required final String firstName,
    required final String lastName,
    final int? monthlyIncome,
    final DateTime? incomeDate,
  }) = _$UserProfileModelImpl;
  const _UserProfileModel._() : super._();

  factory _UserProfileModel.fromJson(Map<String, dynamic> json) =
      _$UserProfileModelImpl.fromJson;

  @override
  int? get id;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  int? get monthlyIncome;
  @override
  DateTime? get incomeDate;

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileModelImplCopyWith<_$UserProfileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
