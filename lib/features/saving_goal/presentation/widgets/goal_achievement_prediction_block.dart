import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/features/saving_goal/data/models/goal_achievement_prediction_model.dart';
import 'package:money_care/features/saving_goal/data/models/saving_goal_report_model.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/core/constants/route_path.dart';

class GoalAchievementPredictionBlock extends StatelessWidget {
  final GoalAchievementPredictionModel prediction;
  final int goalId;
  final DateTime? goalEndDate;
  final List<MilestoneModel> milestones;

  const GoalAchievementPredictionBlock({
    super.key,
    required this.prediction,
    required this.goalId,
    this.goalEndDate,
    this.milestones = const [],
  });

  Future<void> _analyzeGoalWithAi(BuildContext context) async {
    final appController = Get.find<AppController>();
    final userId = await appController.getCurrentUserId();
    if (userId == null) return;

    double? forecastedSaving;
    if (Get.isRegistered<StatisticsController>()) {
      forecastedSaving = Get.find<StatisticsController>().forecastedSaving;
    }

    final String displayMsg = 'Phân tích tiến độ mục tiêu ${prediction.name}';
    final String prompt = 'Phân tích tiến độ mục tiêu tiết kiệm ${prediction.name}';

    Get.toNamed(
      RoutePath.chatbot,
      arguments: {
        'displayMsg': displayMsg,
        'prompt': prompt,
        'userId': userId,
        'goalId': goalId,
        'forecastedSaving': forecastedSaving,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = AppThemeColors.of(context);
    final color = AppColors.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome_rounded, size: 20, color: color),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Phân tích tiến độ bằng AI',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: themeColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Nhận phân tích thông minh và lời khuyên điều chỉnh ngân sách từ AI dựa trên tình hình tiết kiệm thực tế của bạn.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: themeColors.textSecondary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => _analyzeGoalWithAi(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Phân tích tiến độ mục tiêu',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
