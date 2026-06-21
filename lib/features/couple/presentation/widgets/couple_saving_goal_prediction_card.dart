import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/couple/domain/entities/couple_report_entity.dart';

/// Hiển thị dự đoán tiến độ tiết kiệm chung.
class CoupleSavingGoalPredictionCard extends StatelessWidget {
  final CoupleSavingGoalPredictionEntity prediction;
  final String goalName;

  const CoupleSavingGoalPredictionCard({
    super.key,
    required this.prediction,
    required this.goalName,
  });

  @override
  Widget build(BuildContext context) {
    if (prediction.status == 'completed') {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final statusColor = _statusColor;
    final statusIcon = _statusIcon;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusRow(theme, statusColor, statusIcon),
          const SizedBox(height: 10),
          _buildMetricsRow(theme),
          if (prediction.recommendedAction != null) ...[
            const SizedBox(height: 10),
            _buildRecommendation(theme),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusRow(
    ThemeData theme,
    Color color,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            _statusLabel,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
        if (prediction.predictedCompletionDate != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _formattedPredictedDate,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMetricsRow(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildMetric(
            theme,
            icon: Icons.speed_rounded,
            label: 'Toc do gop',
            value:
                '${AppHelperFunction.formatAmount(prediction.monthlyContributionRate, currency: '')} d/th',
          ),
        ),
        if (prediction.requiredMonthlyRate > 0) ...[
          const SizedBox(width: 8),
          Expanded(
            child: _buildMetric(
              theme,
              icon: Icons.flag_rounded,
              label: 'Can gop',
              value:
                  '${AppHelperFunction.formatAmount(prediction.requiredMonthlyRate, currency: '')} d/th',
              highlight: prediction.monthlyContributionRate <
                  prediction.requiredMonthlyRate,
            ),
          ),
        ],
        if (prediction.daysRemaining != null) ...[
          const SizedBox(width: 8),
          Expanded(
            child: _buildMetric(
              theme,
              icon: Icons.timer_outlined,
              label: 'Con lai',
              value: '${prediction.daysRemaining} ngay',
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMetric(
    ThemeData theme, {
    required IconData icon,
    required String label,
    required String value,
    bool highlight = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: Colors.grey[500]),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: Colors.grey[500]),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: highlight ? Colors.red : theme.textTheme.bodySmall?.color,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildRecommendation(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline_rounded,
              color: Colors.amber, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              prediction.recommendedAction!,
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  String get _formattedPredictedDate {
    if (prediction.predictedCompletionDate == null) return '';
    final date = DateTime.tryParse(prediction.predictedCompletionDate!);
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Color get _statusColor {
    switch (prediction.status) {
      case 'on_track':
        return Colors.green;
      case 'slightly_at_risk':
        return Colors.orange;
      case 'at_risk':
      case 'off_track':
      case 'overdue':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  IconData get _statusIcon {
    switch (prediction.status) {
      case 'on_track':
        return Icons.check_circle_outline_rounded;
      case 'slightly_at_risk':
        return Icons.warning_amber_rounded;
      case 'at_risk':
      case 'off_track':
        return Icons.error_outline_rounded;
      case 'overdue':
        return Icons.schedule_rounded;
      default:
        return Icons.timeline_rounded;
    }
  }

  String get _statusLabel {
    switch (prediction.status) {
      case 'on_track':
        return 'Dung tien do';
      case 'slightly_at_risk':
        return 'Co the tre 1 chut';
      case 'at_risk':
        return 'Co nguy co tre han';
      case 'off_track':
        return 'Cham tien do';
      case 'overdue':
        return 'Da qua han';
      default:
        return 'Dang theo doi';
    }
  }
}
