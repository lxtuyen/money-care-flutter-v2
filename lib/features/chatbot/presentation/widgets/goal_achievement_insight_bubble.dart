import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/chatbot/presentation/widgets/budget_recommendation_bubble.dart';
import 'package:money_care/features/saving_goal/data/models/goal_achievement_prediction_model.dart';

class GoalAchievementInsightBubble extends StatelessWidget {
  final Map<String, dynamic> metadata;

  const GoalAchievementInsightBubble({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final summary = metadata['summary']?.toString() ?? '';
    final predictionMap = metadata['prediction'];
    final prediction = predictionMap is Map<String, dynamic>
        ? GoalAchievementPredictionModel.fromJson(predictionMap)
        : null;
    final budgetRecommendations =
        metadata['budgetRecommendations'] as List<dynamic>? ?? [];

    if (prediction == null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.borderSecondary),
          ),
          child: Text(
            summary.isNotEmpty ? summary : 'Chưa có dữ liệu dự báo mục tiêu.',
            style: TextStyle(color: colors.textPrimary, fontSize: 14),
          ),
        ),
      );
    }

    final statusColor = _riskColor(prediction.riskLevel);
    final completionText = prediction.predictedCompletionDate != null
        ? _formatIsoDate(prediction.predictedCompletionDate!)
        : 'Chưa đủ dữ liệu';

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.88,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.cardBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colors.borderSecondary, width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _statusIcon(prediction.status),
                        color: statusColor,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          prediction.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _riskText(prediction.riskLevel),
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (summary.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      summary,
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.4,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  _metric(
                    label: 'Tiến độ',
                    value: '${prediction.progressPct.toStringAsFixed(0)}%',
                    colors: colors,
                  ),
                  _metric(
                    label: 'Dự kiến hoàn thành',
                    value: completionText,
                    colors: colors,
                  ),
                  _metric(
                    label: 'Lệch hạn',
                    value: _differenceText(prediction),
                    colors: colors,
                  ),
                  _metric(
                    label: 'Cần tiết kiệm mỗi ngày',
                    value: AppHelperFunction.formatAmount(
                      prediction.requiredDailySavingRate,
                    ),
                    colors: colors,
                  ),
                  _metric(
                    label: _velocityLabel(
                      prediction.supportingData['savingVelocitySource']
                          ?.toString(),
                    ),
                    value: AppHelperFunction.formatAmount(
                      prediction.currentMonthlySavingRate,
                    ),
                    colors: colors,
                  ),
                  if (prediction.recommendedActions.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      'Gợi ý hành động',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...prediction.recommendedActions.take(3).map(
                      (action) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(fontSize: 13)),
                            Expanded(
                              child: Text(
                                action.message,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  height: 1.35,
                                  color: colors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (budgetRecommendations.isNotEmpty) ...[
              const SizedBox(height: 8),
              BudgetRecommendationBubble(
                metadata: {
                  '__type': 'budget_recommendation',
                  'summary':
                      'Điều chỉnh ngân sách để tăng khả năng đạt mục tiêu',
                  'planId': metadata['planId'],
                  'recommendedTotalBudget':
                      metadata['recommendedTotalBudget'] ?? 0,
                  'expectedSavingsAmount':
                      metadata['expectedSavingsAmount'] ?? 0,
                  'confidence': metadata['confidence'] ?? prediction.confidence,
                  'items': budgetRecommendations,
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _metric({
    required String label,
    required String value,
    required AppThemeColors colors,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: colors.textMuted),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _velocityLabel(String? source) {
  return switch (source) {
    'forecasted_monthly_savings' => 'Tiết kiệm dự kiến tháng này',
    'spending_plan_capacity' => 'Tiết kiệm theo kế hoạch',
    'profile_average_savings' => 'Tiết kiệm TB hàng tháng',
    'net_balance_fallback' => 'Tiết kiệm ước tính',
    _ => 'Tiết kiệm dự kiến tháng này',
  };
}

Color _riskColor(String riskLevel) {
  return switch (riskLevel) {
    'high' => AppColors.error,
    'medium' => AppColors.warning,
    _ => AppColors.success,
  };
}

IconData _statusIcon(String status) {
  return switch (status) {
    'completed' || 'on_track' => Icons.check_circle_outline_rounded,
    'slightly_at_risk' || 'at_risk' => Icons.warning_amber_rounded,
    _ => Icons.error_outline_rounded,
  };
}

String _riskText(String riskLevel) {
  return switch (riskLevel) {
    'high' => 'Rủi ro cao',
    'medium' => 'Rủi ro trung bình',
    _ => 'Ổn định',
  };
}

String _differenceText(GoalAchievementPredictionModel prediction) {
  final days = prediction.daysDifference;
  if (prediction.status == 'completed') return 'Đã hoàn thành';
  if (prediction.status == 'unlikely') return 'Chưa thể dự báo';
  if (days == null) return 'Không có hạn';
  if (days < 0) return 'Sớm ${days.abs()} ngày';
  if (days == 0) return 'Đúng hạn';
  return 'Trễ $days ngày';
}

String _formatIsoDate(String iso) {
  final date = DateTime.tryParse(iso);
  if (date == null) return iso;
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}
