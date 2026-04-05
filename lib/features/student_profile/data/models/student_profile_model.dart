import 'package:money_care/features/student_profile/domain/entities/student_profile_entity.dart';

class ExamPeriodModel {
  final DateTime startDate;
  final DateTime endDate;

  const ExamPeriodModel({
    required this.startDate,
    required this.endDate,
  });

  factory ExamPeriodModel.fromJson(Map<String, dynamic> json) {
    return ExamPeriodModel(
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      };

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

class StudentProfileModel {
  final int userId;
  final String? university;
  final String? faculty;
  final int? studyYear;
  final int? monthlyIncome;
  final DateTime? incomeDate;
  final List<ExamPeriodModel> examPeriods;

  const StudentProfileModel({
    required this.userId,
    this.university,
    this.faculty,
    this.studyYear,
    this.monthlyIncome,
    this.incomeDate,
    this.examPeriods = const [],
  });

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    return StudentProfileModel(
      userId: json['userId'] as int,
      university: json['university'] as String?,
      faculty: json['faculty'] as String?,
      studyYear: json['studyYear'] as int?,
      monthlyIncome: json['monthlyIncome'] as int?,
      incomeDate: json['incomeDate'] != null
          ? DateTime.parse(json['incomeDate'] as String)
          : null,
      examPeriods: json['examPeriods'] != null
          ? (json['examPeriods'] as List<dynamic>)
              .map((e) => ExamPeriodModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'university': university,
        'faculty': faculty,
        'studyYear': studyYear,
        'monthlyIncome': monthlyIncome,
        'incomeDate': incomeDate?.toIso8601String(),
        'examPeriods': examPeriods.map((e) => e.toJson()).toList(),
      };

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
