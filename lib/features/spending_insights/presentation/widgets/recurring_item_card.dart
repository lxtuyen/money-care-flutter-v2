import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/spending_insights/domain/entities/recurring_transaction_entity.dart';

/// Card hiển thị 1 recurring item trong detail screen.
class RecurringItemCard extends StatelessWidget {
  final RecurringTransactionEntity item;
  final bool isConfirmed;
  final VoidCallback? onTap;

  const RecurringItemCard({
    super.key,
    required this.item,
    this.isConfirmed = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopRow(),
              if (item.expectedDay != null) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    const SizedBox(width: 52), // align with text after icon
                    Icon(Icons.calendar_today_rounded,
                        size: 13, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      'Ngày ${item.expectedDay} ${item.frequencyLabel.toLowerCase()}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
              if (!isConfirmed) ...[
                const SizedBox(height: 10),
                _buildBottomRow(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopRow() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              item.categoryIcon.isNotEmpty ? item.categoryIcon : '📦',
              style: const TextStyle(fontSize: 22),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.description,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text1,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                item.categoryName,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.text4,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              AppHelperFunction.formatAmount(item.averageAmount),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.text1,
              ),
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _frequencyColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                item.frequencyLabel,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _frequencyColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomRow() {
    final nextDate = DateTime.tryParse(item.nextExpectedDate);
    final nextDateStr = nextDate != null
        ? AppHelperFunction.getFormattedDate(nextDate)
        : item.nextExpectedDate;

    return Row(
      children: [
        _buildInfoChip(
          Icons.verified_rounded,
          '${(item.confidence * 100).round()}%',
          _confidenceColor,
        ),
        const SizedBox(width: 8),
        _buildInfoChip(
          Icons.calendar_today_rounded,
          nextDateStr,
          AppColors.primary,
        ),
        const SizedBox(width: 8),
        _buildInfoChip(
          _trendIcon,
          item.trendLabel,
          _trendColor,
        ),
        const Spacer(),
        Text(
          '${item.occurrenceCount} lần',
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.text5,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color get _frequencyColor {
    switch (item.frequency) {
      case 'weekly':
        return const Color(0xFF2D9CDB);
      case 'bi_weekly':
        return const Color(0xFF9B51E0);
      default:
        return AppColors.primary;
    }
  }

  Color get _confidenceColor {
    if (item.confidence >= 0.8) return AppColors.success;
    if (item.confidence >= 0.6) return AppColors.warning;
    return AppColors.text4;
  }

  IconData get _trendIcon {
    switch (item.amountTrend) {
      case 'increasing':
        return Icons.trending_up_rounded;
      case 'decreasing':
        return Icons.trending_down_rounded;
      default:
        return Icons.trending_flat_rounded;
    }
  }

  Color get _trendColor {
    switch (item.amountTrend) {
      case 'increasing':
        return AppColors.expense;
      case 'decreasing':
        return AppColors.success;
      default:
        return AppColors.text4;
    }
  }
}
