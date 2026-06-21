import 'package:flutter/material.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/couple/domain/entities/couple_report_entity.dart';

/// Hiển thị profile thói quen chi tiêu chung của couple.
class CoupleProfileInsightsCard extends StatelessWidget {
  final CoupleProfileEntity profile;

  const CoupleProfileInsightsCard({
    super.key,
    required this.profile,
  });

  static const _dayNames = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(theme),
        const SizedBox(height: 12),
        _buildAveragesRow(theme),
        const SizedBox(height: 12),
        _buildConsistencyAndPeakDays(theme),
        if (profile.memberContributionRatio.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildContributionBars(theme),
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
            color: Colors.purple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.insights_rounded,
              color: Colors.purple, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thoi quen chi tieu chung',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (profile.activeMonths > 0)
                Text(
                  'Phan tich tu ${profile.activeMonths} thang du lieu',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                    fontSize: 11,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAveragesRow(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildAverageChip(
            theme,
            icon: Icons.arrow_downward_rounded,
            label: 'Thu TB',
            amount: profile.averageMonthlyIncome,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildAverageChip(
            theme,
            icon: Icons.arrow_upward_rounded,
            label: 'Chi TB',
            amount: profile.averageMonthlyExpense,
            color: Colors.red,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildAverageChip(
            theme,
            icon: Icons.savings_rounded,
            label: 'Tiet kiem',
            amount: profile.averageMonthlySavings,
            color: profile.averageMonthlySavings >= 0
                ? Colors.blue
                : Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildAverageChip(
    ThemeData theme, {
    required IconData icon,
    required String label,
    required double amount,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            AppHelperFunction.formatAmount(amount, currency: ''),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildConsistencyAndPeakDays(ThemeData theme) {
    return Row(
      children: [
        // Consistency score
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 36,
                  height: 36,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: profile.spendingConsistencyScore / 100,
                        strokeWidth: 3,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _consistencyColor,
                        ),
                      ),
                      Text(
                        '${profile.spendingConsistencyScore.round()}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: _consistencyColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'On dinh',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        _consistencyLabel,
                        style: TextStyle(
                          fontSize: 10,
                          color: _consistencyColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Peak spending days
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ngay chi nhieu',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  children: profile.peakSpendingDays.isEmpty
                      ? [
                          Text(
                            'Chua du du lieu',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[400],
                            ),
                          ),
                        ]
                      : profile.peakSpendingDays.map((day) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              day < _dayNames.length ? _dayNames[day] : '?',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange,
                              ),
                            ),
                          );
                        }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContributionBars(ThemeData theme) {
    final entries = profile.memberContributionRatio.entries.toList();
    final colors = [Colors.blue, Colors.pink, Colors.teal, Colors.amber];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ty le dong gop',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        // Stacked bar
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 10,
            child: Row(
              children: entries.asMap().entries.map((e) {
                final idx = e.key;
                final ratio = e.value.value;
                final color = colors[idx % colors.length];
                return Expanded(
                  flex: (ratio * 100).round().clamp(1, 100),
                  child: Container(color: color),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 6),
        // Legend
        Row(
          children: entries.asMap().entries.map((e) {
            final idx = e.key;
            final memberId = e.value.key;
            final ratio = e.value.value;
            final color = colors[idx % colors.length];
            return Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      'TV $memberId: ${(ratio * 100).round()}%',
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color get _consistencyColor {
    if (profile.spendingConsistencyScore >= 70) return Colors.green;
    if (profile.spendingConsistencyScore >= 40) return Colors.orange;
    return Colors.red;
  }

  String get _consistencyLabel {
    if (profile.spendingConsistencyScore >= 70) return 'Rat on dinh';
    if (profile.spendingConsistencyScore >= 40) return 'Tuong doi';
    return 'Bien dong nhieu';
  }
}
