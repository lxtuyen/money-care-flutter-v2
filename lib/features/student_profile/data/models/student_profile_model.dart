import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_care/features/student_profile/domain/entities/student_profile_entity.dart';

part 'student_profile_model.freezed.dart';
part 'student_profile_model.g.dart';

@freezed
class ExamPeriodModel with _$ExamPeriodModel {
  const factory ExamPeriodModel({
    required DateTime startDate,
    required DateTime endDate,
  }) = _ExamPeriodModel;

  const ExamPeriodModel._();

  factory ExamPeriodModel.fromJson(Map<String, dynamic> json) =>
      _$ExamPeriodModelFromJson(json);

  factory ExamPeriodModel.fromEntity(ExamPeriod entity) {
    return ExamPeriodModel(
      startDate: entity.startDate,
      endDate: entity.endDate,
    );
  }

  ExamPeriod toEntity() => ExamPeriod(
        startDate: startDate,
        endDate: endDate,
      );
}

@freezed
class StudentProfileModel with _$StudentProfileModel {
  const factory StudentProfileModel({
    required int userId,
    String? university,
    String? faculty,
    int? studyYear,
    int? monthlyIncome,
    DateTime? incomeDate,
    @Default([]) List<ExamPeriodModel> examPeriods,
  }) = _StudentProfileModel;

  const StudentProfileModel._();

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) =>
      _$StudentProfileModelFromJson(json);

  factory StudentProfileModel.fromEntity(StudentProfileEntity entity) {
    return StudentProfileModel(
      userId: entity.userId,
      university: entity.university,
      faculty: entity.faculty,
      studyYear: entity.studyYear,
      monthlyIncome: entity.monthlyIncome,
      incomeDate: entity.incomeDate,
      examPeriods: entity.examPeriods
          .map((e) => ExamPeriodModel.fromEntity(e))
          .toList(),
    );
  }

  StudentProfileEntity toEntity() => StudentProfileEntity(
        userId: userId,
        university: university,
        faculty: faculty,
        studyYear: studyYear,
        monthlyIncome: monthlyIncome,
        incomeDate: incomeDate,
        examPeriods: examPeriods.map((e) => e.toEntity()).toList(),
      );
}
