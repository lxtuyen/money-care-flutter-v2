// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saving_goal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SavingGoalModel _$SavingGoalModelFromJson(Map<String, dynamic> json) =>
    _SavingGoalModel(
      id: NumParser.parseInt(json['id']),
      name: json['name'] as String,
      isSelected: json['is_selected'] as bool?,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      target: NumParser.parseDoubleNullable(json['target']),
      savedAmount: json['saved_amount'] == null
          ? 0
          : NumParser.parseDouble(json['saved_amount']),
      isCompleted: json['is_completed'] as bool? ?? false,
      templateKey: json['template_key'] as String?,
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$SavingGoalModelToJson(_SavingGoalModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'is_selected': instance.isSelected,
      'categories': instance.categories,
      'target': instance.target,
      'saved_amount': instance.savedAmount,
      'is_completed': instance.isCompleted,
      'template_key': instance.templateKey,
      'start_date': instance.startDate?.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'status': instance.status,
    };
