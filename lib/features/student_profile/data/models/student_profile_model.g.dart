// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExamPeriodModelImpl _$$ExamPeriodModelImplFromJson(
  Map<String, dynamic> json,
) => _$ExamPeriodModelImpl(
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
);

Map<String, dynamic> _$$ExamPeriodModelImplToJson(
  _$ExamPeriodModelImpl instance,
) => <String, dynamic>{
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate.toIso8601String(),
};

_$StudentProfileModelImpl _$$StudentProfileModelImplFromJson(
  Map<String, dynamic> json,
) => _$StudentProfileModelImpl(
  userId: (json['userId'] as num).toInt(),
  university: json['university'] as String?,
  faculty: json['faculty'] as String?,
  studyYear: (json['studyYear'] as num?)?.toInt(),
  monthlyIncome: (json['monthlyIncome'] as num?)?.toInt(),
  incomeDate:
      json['incomeDate'] == null
          ? null
          : DateTime.parse(json['incomeDate'] as String),
  examPeriods:
      (json['examPeriods'] as List<dynamic>?)
          ?.map((e) => ExamPeriodModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$StudentProfileModelImplToJson(
  _$StudentProfileModelImpl instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'university': instance.university,
  'faculty': instance.faculty,
  'studyYear': instance.studyYear,
  'monthlyIncome': instance.monthlyIncome,
  'incomeDate': instance.incomeDate?.toIso8601String(),
  'examPeriods': instance.examPeriods,
};
