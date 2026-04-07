// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ExamPeriodModel _$ExamPeriodModelFromJson(Map<String, dynamic> json) {
  return _ExamPeriodModel.fromJson(json);
}

/// @nodoc
mixin _$ExamPeriodModel {
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;

  /// Serializes this ExamPeriodModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExamPeriodModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExamPeriodModelCopyWith<ExamPeriodModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExamPeriodModelCopyWith<$Res> {
  factory $ExamPeriodModelCopyWith(
    ExamPeriodModel value,
    $Res Function(ExamPeriodModel) then,
  ) = _$ExamPeriodModelCopyWithImpl<$Res, ExamPeriodModel>;
  @useResult
  $Res call({DateTime startDate, DateTime endDate});
}

/// @nodoc
class _$ExamPeriodModelCopyWithImpl<$Res, $Val extends ExamPeriodModel>
    implements $ExamPeriodModelCopyWith<$Res> {
  _$ExamPeriodModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExamPeriodModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? startDate = null, Object? endDate = null}) {
    return _then(
      _value.copyWith(
            startDate:
                null == startDate
                    ? _value.startDate
                    : startDate // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            endDate:
                null == endDate
                    ? _value.endDate
                    : endDate // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExamPeriodModelImplCopyWith<$Res>
    implements $ExamPeriodModelCopyWith<$Res> {
  factory _$$ExamPeriodModelImplCopyWith(
    _$ExamPeriodModelImpl value,
    $Res Function(_$ExamPeriodModelImpl) then,
  ) = __$$ExamPeriodModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime startDate, DateTime endDate});
}

/// @nodoc
class __$$ExamPeriodModelImplCopyWithImpl<$Res>
    extends _$ExamPeriodModelCopyWithImpl<$Res, _$ExamPeriodModelImpl>
    implements _$$ExamPeriodModelImplCopyWith<$Res> {
  __$$ExamPeriodModelImplCopyWithImpl(
    _$ExamPeriodModelImpl _value,
    $Res Function(_$ExamPeriodModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExamPeriodModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? startDate = null, Object? endDate = null}) {
    return _then(
      _$ExamPeriodModelImpl(
        startDate:
            null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        endDate:
            null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExamPeriodModelImpl extends _ExamPeriodModel {
  const _$ExamPeriodModelImpl({required this.startDate, required this.endDate})
    : super._();

  factory _$ExamPeriodModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExamPeriodModelImplFromJson(json);

  @override
  final DateTime startDate;
  @override
  final DateTime endDate;

  @override
  String toString() {
    return 'ExamPeriodModel(startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExamPeriodModelImpl &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, startDate, endDate);

  /// Create a copy of ExamPeriodModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExamPeriodModelImplCopyWith<_$ExamPeriodModelImpl> get copyWith =>
      __$$ExamPeriodModelImplCopyWithImpl<_$ExamPeriodModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExamPeriodModelImplToJson(this);
  }
}

abstract class _ExamPeriodModel extends ExamPeriodModel {
  const factory _ExamPeriodModel({
    required final DateTime startDate,
    required final DateTime endDate,
  }) = _$ExamPeriodModelImpl;
  const _ExamPeriodModel._() : super._();

  factory _ExamPeriodModel.fromJson(Map<String, dynamic> json) =
      _$ExamPeriodModelImpl.fromJson;

  @override
  DateTime get startDate;
  @override
  DateTime get endDate;

  /// Create a copy of ExamPeriodModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExamPeriodModelImplCopyWith<_$ExamPeriodModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StudentProfileModel _$StudentProfileModelFromJson(Map<String, dynamic> json) {
  return _StudentProfileModel.fromJson(json);
}

/// @nodoc
mixin _$StudentProfileModel {
  int get userId => throw _privateConstructorUsedError;
  String? get university => throw _privateConstructorUsedError;
  String? get faculty => throw _privateConstructorUsedError;
  int? get studyYear => throw _privateConstructorUsedError;
  int? get monthlyIncome => throw _privateConstructorUsedError;
  DateTime? get incomeDate => throw _privateConstructorUsedError;
  List<ExamPeriodModel> get examPeriods => throw _privateConstructorUsedError;

  /// Serializes this StudentProfileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StudentProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudentProfileModelCopyWith<StudentProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentProfileModelCopyWith<$Res> {
  factory $StudentProfileModelCopyWith(
    StudentProfileModel value,
    $Res Function(StudentProfileModel) then,
  ) = _$StudentProfileModelCopyWithImpl<$Res, StudentProfileModel>;
  @useResult
  $Res call({
    int userId,
    String? university,
    String? faculty,
    int? studyYear,
    int? monthlyIncome,
    DateTime? incomeDate,
    List<ExamPeriodModel> examPeriods,
  });
}

/// @nodoc
class _$StudentProfileModelCopyWithImpl<$Res, $Val extends StudentProfileModel>
    implements $StudentProfileModelCopyWith<$Res> {
  _$StudentProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudentProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? university = freezed,
    Object? faculty = freezed,
    Object? studyYear = freezed,
    Object? monthlyIncome = freezed,
    Object? incomeDate = freezed,
    Object? examPeriods = null,
  }) {
    return _then(
      _value.copyWith(
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as int,
            university:
                freezed == university
                    ? _value.university
                    : university // ignore: cast_nullable_to_non_nullable
                        as String?,
            faculty:
                freezed == faculty
                    ? _value.faculty
                    : faculty // ignore: cast_nullable_to_non_nullable
                        as String?,
            studyYear:
                freezed == studyYear
                    ? _value.studyYear
                    : studyYear // ignore: cast_nullable_to_non_nullable
                        as int?,
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
            examPeriods:
                null == examPeriods
                    ? _value.examPeriods
                    : examPeriods // ignore: cast_nullable_to_non_nullable
                        as List<ExamPeriodModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StudentProfileModelImplCopyWith<$Res>
    implements $StudentProfileModelCopyWith<$Res> {
  factory _$$StudentProfileModelImplCopyWith(
    _$StudentProfileModelImpl value,
    $Res Function(_$StudentProfileModelImpl) then,
  ) = __$$StudentProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int userId,
    String? university,
    String? faculty,
    int? studyYear,
    int? monthlyIncome,
    DateTime? incomeDate,
    List<ExamPeriodModel> examPeriods,
  });
}

/// @nodoc
class __$$StudentProfileModelImplCopyWithImpl<$Res>
    extends _$StudentProfileModelCopyWithImpl<$Res, _$StudentProfileModelImpl>
    implements _$$StudentProfileModelImplCopyWith<$Res> {
  __$$StudentProfileModelImplCopyWithImpl(
    _$StudentProfileModelImpl _value,
    $Res Function(_$StudentProfileModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StudentProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? university = freezed,
    Object? faculty = freezed,
    Object? studyYear = freezed,
    Object? monthlyIncome = freezed,
    Object? incomeDate = freezed,
    Object? examPeriods = null,
  }) {
    return _then(
      _$StudentProfileModelImpl(
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as int,
        university:
            freezed == university
                ? _value.university
                : university // ignore: cast_nullable_to_non_nullable
                    as String?,
        faculty:
            freezed == faculty
                ? _value.faculty
                : faculty // ignore: cast_nullable_to_non_nullable
                    as String?,
        studyYear:
            freezed == studyYear
                ? _value.studyYear
                : studyYear // ignore: cast_nullable_to_non_nullable
                    as int?,
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
        examPeriods:
            null == examPeriods
                ? _value._examPeriods
                : examPeriods // ignore: cast_nullable_to_non_nullable
                    as List<ExamPeriodModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StudentProfileModelImpl extends _StudentProfileModel {
  const _$StudentProfileModelImpl({
    required this.userId,
    this.university,
    this.faculty,
    this.studyYear,
    this.monthlyIncome,
    this.incomeDate,
    final List<ExamPeriodModel> examPeriods = const [],
  }) : _examPeriods = examPeriods,
       super._();

  factory _$StudentProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudentProfileModelImplFromJson(json);

  @override
  final int userId;
  @override
  final String? university;
  @override
  final String? faculty;
  @override
  final int? studyYear;
  @override
  final int? monthlyIncome;
  @override
  final DateTime? incomeDate;
  final List<ExamPeriodModel> _examPeriods;
  @override
  @JsonKey()
  List<ExamPeriodModel> get examPeriods {
    if (_examPeriods is EqualUnmodifiableListView) return _examPeriods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_examPeriods);
  }

  @override
  String toString() {
    return 'StudentProfileModel(userId: $userId, university: $university, faculty: $faculty, studyYear: $studyYear, monthlyIncome: $monthlyIncome, incomeDate: $incomeDate, examPeriods: $examPeriods)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentProfileModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.university, university) ||
                other.university == university) &&
            (identical(other.faculty, faculty) || other.faculty == faculty) &&
            (identical(other.studyYear, studyYear) ||
                other.studyYear == studyYear) &&
            (identical(other.monthlyIncome, monthlyIncome) ||
                other.monthlyIncome == monthlyIncome) &&
            (identical(other.incomeDate, incomeDate) ||
                other.incomeDate == incomeDate) &&
            const DeepCollectionEquality().equals(
              other._examPeriods,
              _examPeriods,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    university,
    faculty,
    studyYear,
    monthlyIncome,
    incomeDate,
    const DeepCollectionEquality().hash(_examPeriods),
  );

  /// Create a copy of StudentProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentProfileModelImplCopyWith<_$StudentProfileModelImpl> get copyWith =>
      __$$StudentProfileModelImplCopyWithImpl<_$StudentProfileModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StudentProfileModelImplToJson(this);
  }
}

abstract class _StudentProfileModel extends StudentProfileModel {
  const factory _StudentProfileModel({
    required final int userId,
    final String? university,
    final String? faculty,
    final int? studyYear,
    final int? monthlyIncome,
    final DateTime? incomeDate,
    final List<ExamPeriodModel> examPeriods,
  }) = _$StudentProfileModelImpl;
  const _StudentProfileModel._() : super._();

  factory _StudentProfileModel.fromJson(Map<String, dynamic> json) =
      _$StudentProfileModelImpl.fromJson;

  @override
  int get userId;
  @override
  String? get university;
  @override
  String? get faculty;
  @override
  int? get studyYear;
  @override
  int? get monthlyIncome;
  @override
  DateTime? get incomeDate;
  @override
  List<ExamPeriodModel> get examPeriods;

  /// Create a copy of StudentProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudentProfileModelImplCopyWith<_$StudentProfileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
