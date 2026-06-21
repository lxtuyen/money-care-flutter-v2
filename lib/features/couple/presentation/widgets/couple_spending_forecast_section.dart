import 'package:flutter/material.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/couple/domain/entities/couple_report_entity.dart';

/// Hiển thị dự báo chi tiêu chung của couple.
class CoupleSpendingForecastSection extends StatelessWidget {
  final CoupleForecastEntity forecast;

  const CoupleSpendingForecastSection({
    super.key,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOverspend =
        forecast.totalProjectedExpense > forecast.totalProjectedIncome &&
            forecast.totalProjectedIncome > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(theme),
        const SizedBox(height: 12),
        _buildSummaryRow(theme, isOverspend),
        if (isOverspend) ...[
          const SizedBox(height: 8),
          _buildOverspendWarning(theme),
        ],
        if (forecast.categoryForecasts.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildCategoryList(theme),
        ],
      ],
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.trending_up_rounded,
              color: Colors.blue, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Du bao chi tieu chung',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'AI du bao dua tren lich su giao dich',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[500],
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        _buildConfidenceBadge(theme),
      ],
    );
  }

  Widget _buildConfidenceBadge(ThemeData theme) {
    final pct = (forecast.confidence * 100).round();
    final color =
        pct >= 60 ? Colors.green : (pct >= 40 ? Colors.orange : Colors.grey);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$pct%',
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSummaryRow(ThemeData theme, bool isOverspend) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            theme,
            label: 'Du bao chi',
            amount: forecast.totalProjectedExpense,
            color: isOverspend ? Colors.red : Colors.orange,
            icon: Icons.arrow_upward_rounded,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSummaryCard(
            theme,
            label: 'Du bao thu',
            amount: forecast.totalProjectedIncome,
            color: Colors.green,
            icon: Icons.arrow_downward_rounded,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSummaryCard(
            theme,
            label: 'Tiet kiem',
            amount: forecast.projectedSavings,
            color: forecast.projectedSavings >= 0
                ? Colors.blue
                : Colors.red,
            icon: Icons.savings_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    ThemeData theme, {
    required String label,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(color: color, fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            AppHelperFunction.formatAmount(amount, currency: ''),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildOverspendWarning(ThemeData theme) {
    final overspend =
        forecast.totalProjectedExpense - forecast.totalProjectedIncome;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: Colors.red, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Du bao chi vuot thu ${AppHelperFunction.formatAmount(overspend, currency: '')} d',
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(ThemeData theme) {
    final topCats = forecast.categoryForecasts.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Du bao theo danh muc',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        ...topCats.map((cat) => _buildCategoryRow(theme, cat)),
      ],
    );
  }

  Widget _buildCategoryRow(
    ThemeData theme,
    CoupleCategoryForecastEntity cat,
  ) {
    final progress = cat.predictedAmount > 0
        ? (cat.actualAmount / cat.predictedAmount).clamp(0.0, 1.0)
        : 0.0;

    final trendIcon = cat.trend == 'increasing'
        ? Icons.trending_up_rounded
        : cat.trend == 'decreasing'
            ? Icons.trending_down_rounded
            : Icons.trending_flat_rounded;

    final trendColor = cat.trend == 'increasing'
        ? Colors.red
        : cat.trend == 'decreasing'
            ? Colors.green
            : Colors.grey;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(trendIcon, color: trendColor, size: 16),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              cat.categoryName,
              style: theme.textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress >= 0.85
                      ? Colors.red
                      : progress >= 0.6
                          ? Colors.orange
                          : Colors.blue,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            AppHelperFunction.formatAmount(
              cat.predictedAmount,
              currency: '',
            ),
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
