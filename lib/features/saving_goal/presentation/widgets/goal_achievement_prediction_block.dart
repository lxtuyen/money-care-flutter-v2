import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/saving_goal/data/models/goal_achievement_prediction_model.dart';
import 'package:money_care/features/saving_goal/data/models/saving_goal_report_model.dart';
import 'package:money_care/features/saving_goal/presentation/widgets/goal_prediction_action_buttons.dart';

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

  /// Còn thiếu của giai đoạn hiện tại (milestone đang chạy).
  /// Nếu không có milestone active thì fallback về remainingAmount tổng.
  double get _currentMilestoneRemaining {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final active = milestones.where(
      (m) => !m.startDate.isAfter(now) && !m.endDate.isBefore(today),
    );
    if (active.isNotEmpty) {
      final m = active.first;
      return (m.target - m.actual).clamp(0, double.infinity);
    }
    return prediction.remainingAmount;
  }

  /// Ngày kết thúc của milestone hiện tại
  DateTime? get _currentMilestoneEndDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final active = milestones.where(
      (m) => !m.startDate.isAfter(now) && !m.endDate.isBefore(today),
    );
    if (active.isNotEmpty) {
      return active.first.endDate;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final color = _predictionRiskColor(prediction.riskLevel);
    final themeColors = AppThemeColors.of(context);
    final milestoneEndDate = _currentMilestoneEndDate;
    final nextPred = prediction.nextMonthPrediction;

    // Nếu đã có dự báo tháng sau (tức là tháng hiện tại đã hoàn thành),
    // chúng ta ẩn khối dự báo tháng hiện tại đi và chỉ hiển thị dự báo tháng sau.
    if (nextPred != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _predictionRiskColor(nextPred.riskLevel).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _predictionRiskColor(nextPred.riskLevel).withValues(alpha: 0.18)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.next_plan_outlined, size: 18, color: _predictionRiskColor(nextPred.riskLevel)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Dự báo giai đoạn tháng sau',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: themeColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  _predictionStatusText(nextPred.status),
                  style: TextStyle(
                    color: _predictionRiskColor(nextPred.riskLevel),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _PredictionInfoRow(
              label: 'Đã tích lũy sẵn',
              value: AppHelperFunction.formatAmount(
                nextPred.savedAmount,
                currency: 'VND',
              ),
              valueColor: AppColors.income,
            ),
            _PredictionInfoRow(
              label: 'Hạn giai đoạn',
              value: _formatPredictionDate(nextPred.deadline),
              valueColor: themeColors.textSecondary,
            ),
            _PredictionInfoRow(
              label: 'Dự kiến hoàn thành',
              value: prediction.currentMonthlySavingRate <= 0
                  ? 'Không thể hoàn thành'
                  : nextPred.predictedCompletionDate != null
                      ? _formatPredictionDate(nextPred.predictedCompletionDate!)
                      : 'Chưa đủ dữ liệu',
              valueColor: prediction.currentMonthlySavingRate <= 0
                  ? AppColors.expense
                  : _predictionRiskColor(nextPred.riskLevel),
            ),
            _PredictionInfoRow(
              label: 'Còn thiếu tháng sau',
              value: AppHelperFunction.formatAmount(
                nextPred.remainingAmount,
                currency: 'VND',
              ),
            ),
            _PredictionInfoRow(
              label: 'Lệch hạn',
              value: _nextPredictionDifferenceText(nextPred),
              valueColor: _predictionRiskColor(nextPred.riskLevel),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flag_circle_outlined, size: 18, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Dự báo giai đoạn tháng hiện tại',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: themeColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                _predictionStatusText(prediction.status),
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _PredictionInfoRow(
            label: 'Đã tiết kiệm',
            value: AppHelperFunction.formatAmount(
              prediction.savedAmount,
              currency: 'VND',
            ),
            valueColor: AppColors.income,
          ),
          if (milestoneEndDate != null)
            _PredictionInfoRow(
              label: 'Hạn giai đoạn',
              value: _formatPredictionDate(milestoneEndDate.toIso8601String()),
              valueColor: themeColors.textSecondary,
            ),
          _PredictionInfoRow(
            label: 'Dự kiến hoàn thành',
            value: prediction.currentMonthlySavingRate <= 0
                ? 'Không thể hoàn thành'
                : prediction.predictedCompletionDate != null
                    ? _formatPredictionDate(prediction.predictedCompletionDate!)
                    : 'Chưa đủ dữ liệu',
            valueColor: prediction.currentMonthlySavingRate <= 0
                ? AppColors.expense
                : color,
          ),
          _PredictionInfoRow(
            label: 'Còn thiếu giai đoạn này',
            value: AppHelperFunction.formatAmount(
              _currentMilestoneRemaining,
              currency: 'VND',
            ),
          ),
          _PredictionInfoRow(
            label: _predictionVelocityLabel(
              prediction.supportingData['savingVelocitySource']?.toString(),
            ),
            value: AppHelperFunction.formatAmount(
              prediction.currentMonthlySavingRate,
              currency: 'VND',
            ),
            valueColor: prediction.currentMonthlySavingRate < 0
                ? AppColors.expense
                : null,
          ),
          _PredictionInfoRow(
            label: 'Lệch hạn',
            value: _predictionDifferenceText(prediction),
            valueColor: color,
          ),

          GoalPredictionActionButtons(
            prediction: prediction,
            goalId: goalId,
            currentEndDate: goalEndDate,
          ),
        ],
      ),
    );
  }
}

class _PredictionInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _PredictionInfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = AppThemeColors.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: themeColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: valueColor ?? themeColors.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color _predictionRiskColor(String riskLevel) {
  return switch (riskLevel) {
    'high' => AppColors.expense,
    'medium' => AppColors.secondaryOrange,
    _ => AppColors.income,
  };
}

String _predictionStatusText(String status) {
  return switch (status) {
    'completed' => 'Hoàn thành',
    'on_track' => 'Đúng hạn',
    'slightly_at_risk' || 'at_risk' => 'Rủi ro',
    'off_track' || 'overdue' || 'unlikely' => 'Lệch tiến độ',
    _ => 'Theo dõi',
  };
}

String _predictionDifferenceText(GoalAchievementPredictionModel prediction) {
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

String _nextPredictionDifferenceText(GoalAchievementNextMonthPredictionModel nextPred) {
  final days = nextPred.daysDifference;
  if (nextPred.status == 'completed') return 'Đã hoàn thành';
  if (nextPred.status == 'unlikely') return 'Chưa thể dự báo';
  if (days == null) return 'Không có hạn';
  if (days < 0) return 'Sớm ${days.abs()} ngày';
  if (days == 0) return 'Đúng hạn';
  return 'Trễ $days ngày';
}

String _predictionVelocityLabel(String? source) {
  return switch (source) {
    'forecasted_monthly_savings' => 'TK dự kiến tháng này',
    'spending_plan_capacity' => 'TK theo kế hoạch',
    'profile_average_savings' => 'TK TB hàng tháng',
    'net_balance_fallback' => 'TK ước tính',
    _ => 'TK dự kiến tháng này',
  };
}

String _formatPredictionDate(String value) {
  final parsed = DateTime.tryParse(value);
  if (parsed == null) return value;
  final day = parsed.day.toString().padLeft(2, '0');
  final month = parsed.month.toString().padLeft(2, '0');
  return '$day/$month/${parsed.year}';
}
