import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/chatbot/presentation/widgets/budget_recommendation_bubble.dart';
import 'package:money_care/features/saving_goal/data/models/goal_achievement_prediction_model.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';

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
    final completionText = prediction.currentMonthlySavingRate <= 0
        ? 'Không thể hoàn thành'
        : prediction.predictedCompletionDate != null
            ? _formatIsoDate(prediction.predictedCompletionDate!)
            : 'Chưa đủ dữ liệu';

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
                    label: 'Còn thiếu',
                    value: AppHelperFunction.formatAmount(
                      prediction.remainingAmount,
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
                  // Tạm ẩn khi mục tiêu trễ hạn
                  if (transferAction != null &&
                      !(prediction.daysDifference != null &&
                          prediction.daysDifference! > 0)) ...[
                    const SizedBox(height: 12),
                    _WalletTransferHint(
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

// ── Wallet Transfer Hint widget ─────────────────────────────────────────────

class _WalletTransferHint extends StatelessWidget {
  final GoalRecommendedActionModel action;
  final int? goalWalletId;
  final AppThemeColors colors;

  const _WalletTransferHint({
    required this.action,
    required this.goalWalletId,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final amount = action.amount ?? 0;
    final fromWalletId = action.walletId;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_rounded,
                color: AppColors.primary,
                size: 16,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Ví có thể bù vào',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            action.message,
            style: TextStyle(
              fontSize: 12.5,
              height: 1.4,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          PrimaryButton(
            label: 'Chuyển ${AppHelperFunction.formatAmount(amount)} vào ví tiết kiệm',
            onPressed: () => _openTransfer(
              fromWalletId: fromWalletId,
              toWalletId: goalWalletId,
              amount: amount,
            ),
            icon: const Icon(Icons.swap_horiz_rounded, size: 16),
            height: 40,
            fontSize: 12.5,
            borderRadius: 10,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
        ],
      ),
    );
  }

  void _openTransfer({
    required int? fromWalletId,
    required int? toWalletId,
    required double amount,
  }) {
    Get.toNamed(
      RoutePath.walletTransfer,
      arguments: {
        'fromWalletId': ?fromWalletId,
        'toWalletId': ?toWalletId,
        if (amount > 0) 'amount': amount,
      },
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

String _formatIsoDate(String iso) {
  final date = DateTime.tryParse(iso);
  if (date == null) return iso;
  return AppHelperFunction.getFormattedDate(date);
}
