import 'package:money_care/features/statistics/presentation/models/goal_plan_impact.dart';

class GoalPlanInsightModel {
  final GoalPlanImpactStatus status;
  final String summary;
  final String reason;
  final String suggestion;

  const GoalPlanInsightModel({
    required this.status,
    required this.summary,
    required this.reason,
    required this.suggestion,
  });

  factory GoalPlanInsightModel.fromJson(Map<String, dynamic> json) {
    return GoalPlanInsightModel(
      status: GoalPlanImpactStatusApi.fromApi(json['status']?.toString()),
      summary: json['summary']?.toString() ?? '',
      reason: json['reason']?.toString() ?? '',
      suggestion: json['suggestion']?.toString() ?? '',
    );
  }
}
