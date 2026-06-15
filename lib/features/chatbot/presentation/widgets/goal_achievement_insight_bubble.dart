import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/chatbot/presentation/widgets/budget_recommendation_bubble.dart';
import 'package:money_care/features/chatbot/presentation/widgets/wallet_transfer_hint.dart';
import 'package:money_care/features/saving_goal/data/models/goal_achievement_prediction_model.dart';
import 'package:money_care/features/saving_goal/data/models/saving_goal_report_model.dart';

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

    // Tách action chuyển tiền từ ví ra riêng để render nổi bật
    final transferAction = prediction.recommendedActions
        .where((a) => a.actionType == 'transfer_from_wallet')
        .firstOrNull;
    final otherActions = prediction.recommendedActions
        .where((a) => a.actionType != 'transfer_from_wallet')
        .take(2)
        .toList();

    // goalWalletId dùng làm toWalletId khi chuyển tiền
    final int? goalWalletId = () {
      final v = prediction.supportingData['goalWalletId'];
      if (v is num) return v.toInt();
      return int.tryParse(v?.toString() ?? '');
    }();

    // Parse milestones và nextMonthPrediction
    final milestonesList = metadata['milestones'] as List<dynamic>? ?? [];
    final milestones = milestonesList
        .map((m) => MilestoneModel.fromJson(m as Map<String, dynamic>))
        .toList();

    final nextPred = prediction.nextMonthPrediction;

    // Tính toán milestone hiện tại (active)
    DateTime? currentMilestoneEndDate;
    double currentMilestoneRemaining = prediction.remainingAmount;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final activeMilestones = milestones.where(
      (m) => !m.startDate.isAfter(now) && !m.endDate.isBefore(today),
    );
    if (activeMilestones.isNotEmpty) {
      final m = activeMilestones.first;
      currentMilestoneEndDate = m.endDate;
      currentMilestoneRemaining = (m.target - m.actual).clamp(0, double.infinity);
    }

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
            // ── Main prediction card ──────────────────────────────────────
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
                  // Header: tên mục tiêu + badge rủi ro
                  Row(
                    children: [
                      Icon(
                        _statusIcon(nextPred != null ? nextPred.status : prediction.status),
                        color: _riskColor(nextPred != null ? nextPred.riskLevel : prediction.riskLevel),
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
                          color: _riskColor(nextPred != null ? nextPred.riskLevel : prediction.riskLevel).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _riskText(nextPred != null ? nextPred.riskLevel : prediction.riskLevel),
                          style: TextStyle(
                            color: _riskColor(nextPred != null ? nextPred.riskLevel : prediction.riskLevel),
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

                  // Nếu đã hoàn thành milestone tháng hiện tại, hiển thị dự báo giai đoạn tháng sau
                  if (nextPred != null) ...[
                    const Text(
                      'Dự báo giai đoạn tháng sau',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _metric(
                      label: 'Tiến độ chung',
                      value: '${prediction.progressPct.toStringAsFixed(0)}%',
                      colors: colors,
                    ),
                    _metric(
                      label: 'Đã tích lũy sẵn',
                      value: AppHelperFunction.formatAmount(nextPred.savedAmount),
                      colors: colors,
                    ),
                    _metric(
                      label: 'Hạn giai đoạn',
                      value: _formatIsoDate(nextPred.deadline),
                      colors: colors,
                    ),
                    _metric(
                      label: 'Dự kiến hoàn thành',
                      value: prediction.currentMonthlySavingRate <= 0
                          ? 'Không thể hoàn thành'
                          : nextPred.predictedCompletionDate != null
                              ? _formatIsoDate(nextPred.predictedCompletionDate!)
                              : 'Chưa đủ dữ liệu',
                      colors: colors,
                    ),
                    _metric(
                      label: 'Còn thiếu tháng sau',
                      value: AppHelperFunction.formatAmount(nextPred.remainingAmount),
                      colors: colors,
                    ),
                    _metric(
                      label: 'Lệch hạn',
                      value: _nextDifferenceText(nextPred),
                      colors: colors,
                    ),
                  ] else ...[
                    // Hiển thị dự báo giai đoạn tháng hiện tại
                    _metric(
                      label: 'Tiến độ chung',
                      value: '${prediction.progressPct.toStringAsFixed(0)}%',
                      colors: colors,
                    ),
                    _metric(
                      label: 'Đã tiết kiệm',
                      value: AppHelperFunction.formatAmount(prediction.savedAmount),
                      colors: colors,
                    ),
                    if (currentMilestoneEndDate != null)
                      _metric(
                        label: 'Hạn giai đoạn',
                        value: AppHelperFunction.getFormattedDate(currentMilestoneEndDate),
                        colors: colors,
                      ),
                    _metric(
                      label: 'Dự kiến hoàn thành',
                      value: prediction.currentMonthlySavingRate <= 0
                          ? 'Không thể hoàn thành'
                          : prediction.predictedCompletionDate != null
                              ? _formatIsoDate(prediction.predictedCompletionDate!)
                              : 'Chưa đủ dữ liệu',
                      colors: colors,
                    ),
                    _metric(
                      label: 'Còn thiếu giai đoạn này',
                      value: AppHelperFunction.formatAmount(currentMilestoneRemaining),
                      colors: colors,
                    ),
                    _metric(
                      label: _velocityLabel(
                        prediction.supportingData['savingVelocitySource']?.toString(),
                      ),
                      value: AppHelperFunction.formatAmount(prediction.currentMonthlySavingRate),
                      colors: colors,
                    ),
                    _metric(
                      label: 'Lệch hạn',
                      value: _differenceText(prediction),
                      colors: colors,
                    ),
                  ],

                  // ── Gợi ý hành động thông thường (không phải transfer) ──
                  if (otherActions.isNotEmpty) ...[
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
                    ...otherActions.map(
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

                  // ── Transfer hint card ─────────────────────────────────
                  if (transferAction != null &&
                      !(prediction.daysDifference != null &&
                          prediction.daysDifference! > 0)) ...[
                    const SizedBox(height: 12),
                    WalletTransferHint(
                      action: transferAction,
                      goalWalletId: goalWalletId,
                      colors: colors,
                    ),
                  ],
                ],
              ),
            ),

            // ── Budget recommendation bubble ───────────────────────────
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

// ── Helpers ─────────────────────────────────────────────────────────────────

String _velocityLabel(String? source) {
  return switch (source) {
    'forecasted_monthly_savings' => 'TK dự kiến tháng này',
    'spending_plan_capacity' => 'TK theo kế hoạch',
    'profile_average_savings' => 'TK TB hàng tháng',
    'net_balance_fallback' => 'TK ước tính',
    _ => 'TK dự kiến tháng này',
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
  if (prediction.currentMonthlySavingRate <= 0) {
    return 'Chi vượt thu';
  }
  if (prediction.status == 'unlikely') return 'Chưa thể dự báo';
  if (days == null) return 'Không có hạn';
  if (days < 0) return 'Sớm ${days.abs()} ngày';
  if (days == 0) return 'Đúng hạn';
  return 'Trễ $days ngày';
}

String _nextDifferenceText(GoalAchievementNextMonthPredictionModel nextPred) {
  final days = nextPred.daysDifference;
  if (nextPred.status == 'completed') return 'Đã hoàn thành';
  if (nextPred.status == 'unlikely') return 'Chưa thể dự báo';
  if (days == null) return 'Không có hạn';
  if (days < 0) return 'Sớm ${days.abs()} ngày';
  if (days == 0) return 'Đúng hạn';
  return 'Trễ $days ngày';
}

String _formatIsoDate(String iso) {
  final date = DateTime.tryParse(iso);
  if (date == null) return iso;
  return AppHelperFunction.getFormattedDate(date);
}
