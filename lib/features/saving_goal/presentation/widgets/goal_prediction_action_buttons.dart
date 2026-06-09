import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/utils/helper/date_picker_helper.dart';
import 'package:money_care/features/chatbot/presentation/controllers/chat_controller.dart';
import 'package:money_care/features/saving_goal/data/models/goal_achievement_prediction_model.dart';

bool shouldShowGoalPredictionActions(
  GoalAchievementPredictionModel prediction,
) {
  if (prediction.status == 'completed') return false;

  const behindStatuses = {
    'overdue',
    'off_track',
    'at_risk',
    'slightly_at_risk',
    'unlikely',
  };
  if (behindStatuses.contains(prediction.status)) {
    return true;
  }

  final days = prediction.daysDifference;
  return days != null && days > 0;
}

DateTime _resolveSuggestedExtendDate(GoalAchievementPredictionModel prediction) {
  GoalRecommendedActionModel? extendAction;
  for (final action in prediction.recommendedActions) {
    if (action.actionType == 'extend_deadline' &&
        (action.suggestedDeadline?.isNotEmpty ?? false)) {
      extendAction = action;
      break;
    }
  }

  final suggestedDeadline = extendAction?.suggestedDeadline;
  if (suggestedDeadline != null) {
    final parsed = DateTime.tryParse(suggestedDeadline);
    if (parsed != null) return parsed;
  }

  final predicted = prediction.predictedCompletionDate;
  if (predicted != null) {
    final parsed = DateTime.tryParse(predicted);
    if (parsed != null) return parsed;
  }

  final deadline = prediction.deadline;
  if (deadline != null) {
    final parsed = DateTime.tryParse(deadline);
    if (parsed != null) {
      return parsed.add(const Duration(days: 30));
    }
  }

  return DateTime.now().add(const Duration(days: 30));
}

class GoalPredictionActionButtons extends StatelessWidget {
  final GoalAchievementPredictionModel prediction;
  final int goalId;
  final DateTime? currentEndDate;

  const GoalPredictionActionButtons({
    super.key,
    required this.prediction,
    required this.goalId,
    this.currentEndDate,
  });

  Future<void> _extendGoalDeadline(BuildContext context) async {
    final controller = Get.find<SavingGoalController>();
    final suggestedDate = _resolveSuggestedExtendDate(prediction);
    final baseDate = currentEndDate ?? DateTime.now();
    final firstDate = baseDate.isAfter(DateTime.now())
        ? baseDate.add(const Duration(days: 1))
        : DateTime.now().add(const Duration(days: 1));

    final newDate = await showStyledDatePicker(
      context: context,
      initialDate: suggestedDate.isAfter(firstDate) ? suggestedDate : firstDate,
      firstDate: firstDate,
    );
    if (newDate == null) return;

    final success = await controller.extendGoal(goalId, newDate);
    if (!success) return;

    await controller.loadGoalPrediction(goalId);
    await controller.loadGoalReport(goalId);

    if (Get.isRegistered<StatisticsController>()) {
      final appController = Get.find<AppController>();
      final userId = await appController.getCurrentUserId();
      if (userId != null) {
        await Get.find<StatisticsController>().refreshStatisticsData(userId);
      }
    }
  }

  Future<void> _openChatbotForBudgetAdjust() async {
    final appController = Get.find<AppController>();
    final userId = await appController.getCurrentUserId();
    if (userId == null) return;

    await Get.toNamed(RoutePath.chatbot);
    if (!Get.isRegistered<ChatController>()) return;

    await Get.find<ChatController>().sendTemplate(
      'chatbot.goalBudgetAdjustTemplate'.tr,
      userId,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!shouldShowGoalPredictionActions(prediction)) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Mục tiêu có nguy cơ trễ hạn. Bạn có thể:',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.text3,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: OutlinedButton.icon(
                  onPressed: () => _extendGoalDeadline(context),
                  icon: const Icon(Icons.event_outlined, size: 15),
                  label: const Text(
                    'Gia hạn',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(
                      color: AppColors.primary.withValues(alpha: 0.35),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 11,
                      horizontal: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: PrimaryButton(
                  label: 'Điều chỉnh ngân sách',
                  onPressed: _openChatbotForBudgetAdjust,
                  icon: const Icon(Icons.tune_rounded, size: 15),
                  height: 40,
                  borderRadius: 10,
                  fontSize: 12,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
