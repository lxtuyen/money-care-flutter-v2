import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class CoupleTransactionCalendar extends StatelessWidget {
  final DateTime focusedMonth;
  final List<TransactionEntity> transactions;
  final int selectedDay;
  final ValueChanged<int> onDaySelected;
  final bool isExpense;

  const CoupleTransactionCalendar({
    super.key,
    required this.focusedMonth,
    required this.transactions,
    required this.selectedDay,
    required this.onDaySelected,
    this.isExpense = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    // Compute first day and number of days in the month
    final firstDay = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final daysInMonth = DateTime(focusedMonth.year, focusedMonth.month + 1, 0).day;
    // Monday is 1, Sunday is 7. We want start offset to be firstDay.weekday - 1
    final startOffset = firstDay.weekday - 1;

    final totalCells = startOffset + daysInMonth;
    final rows = (totalCells / 7).ceil();

    // Group transactions by day
    final Map<int, List<TransactionEntity>> txsByDay = {};
    for (final tx in transactions) {
      final date = tx.transactionDate?.toLocal();
      if (date != null && date.year == focusedMonth.year && date.month == focusedMonth.month) {
        txsByDay.putIfAbsent(date.day, () => []).add(tx);
      }
    }

    return Column(
      children: [
        // 1. Weekday labels (T2, T3, T4, T5, T6, T7, CN)
        _buildWeekdayRow(context, colors),
        const SizedBox(height: 6),

        // 2. Calendar Grid Container
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.dialogBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colors.borderSecondary.withValues(alpha: 0.8)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 0.62,
                crossAxisSpacing: 8,
                mainAxisSpacing: 10,
              ),
              itemCount: rows * 7,
              itemBuilder: (context, index) {
                final dayNum = index - startOffset + 1;
                if (dayNum < 1 || dayNum > daysInMonth) {
                  return const SizedBox.shrink();
                }

                final dayTxs = txsByDay[dayNum] ?? [];
                final isSelected = selectedDay == dayNum;
                final isToday = _checkIsToday(dayNum);
                final dayTotal = dayTxs.fold<double>(
                  0.0, (sum, tx) => sum + tx.amount,
                );

                return CoupleTransactionDayCell(
                  day: dayNum,
                  dayTxs: dayTxs,
                  dayTotal: dayTotal,
                  isExpense: isExpense,
                  isSelected: isSelected,
                  isToday: isToday,
                  onTap: () => onDaySelected(dayNum),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  bool _checkIsToday(int day) {
    final now = DateTime.now();
    return now.year == focusedMonth.year && now.month == focusedMonth.month && now.day == day;
  }

  Widget _buildWeekdayRow(BuildContext context, AppThemeColors colors) {
    final labels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: labels
            .map(
              (label) => Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: colors.textSecondary.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class CoupleTransactionDayCell extends StatelessWidget {
  final int day;
  final List<TransactionEntity> dayTxs;
  final double dayTotal;
  final bool isExpense;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  const CoupleTransactionDayCell({
    super.key,
    required this.day,
    required this.dayTxs,
    required this.dayTotal,
    this.isExpense = true,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final theme = Theme.of(context);

    final hasTx = dayTxs.isNotEmpty;
    // Find transaction with photo
    final picTx = dayTxs.firstWhereOrNull(
      (tx) => tx.pictureUrl != null && tx.pictureUrl!.isNotEmpty,
    );

    // Get primary category representation
    final primaryCat = hasTx ? dayTxs.first.category : null;
    final catColor = _getCategoryColor(primaryCat);
    final catIcon = primaryCat?.icon ?? '❓';

    Widget cellGraphic;
    if (hasTx) {
      if (picTx != null) {
        // Image preview decoration
        cellGraphic = Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? theme.primaryColor : colors.borderSecondary,
              width: isSelected ? 2.0 : 1.0,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              picTx.pictureUrl!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: catColor.withValues(alpha: 0.15),
                  alignment: Alignment.center,
                  child: Text(catIcon, style: const TextStyle(fontSize: 15)),
                );
              },
            ),
          ),
        );
      } else {
        // Category representation
        cellGraphic = Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: catColor.withValues(alpha: 0.18),
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? theme.primaryColor : catColor.withValues(alpha: 0.45),
              width: isSelected ? 2.0 : 1.0,
            ),
          ),
          child: Text(
            catIcon,
            style: const TextStyle(fontSize: 15),
          ),
        );
      }
    } else {
      // Dotted/light circle for days without transactions
      cellGraphic = Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? theme.primaryColor
                : colors.borderSecondary.withValues(alpha: 0.25),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
      );
    }

    final badgeCount = dayTxs.length - 1;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          // Cell Graphic (Square)
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  cellGraphic,
                  if (badgeCount > 0)
                    Positioned(
                      top: -3,
                      right: -3,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: theme.primaryColor.withValues(alpha: 0.4), width: 0.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 1.5,
                              offset: Offset(0, 1),
                            )
                          ],
                        ),
                        child: Text(
                          '+$badgeCount',
                          style: TextStyle(
                            fontSize: 7.5,
                            fontWeight: FontWeight.w800,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),

          // Day Number
          Container(
            padding: const EdgeInsets.all(3.5),
            decoration: BoxDecoration(
              color: isToday
                  ? theme.primaryColor
                  : isSelected
                      ? theme.primaryColor.withValues(alpha: 0.15)
                      : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: isToday || isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isToday
                      ? Colors.white
                      : isSelected
                          ? theme.primaryColor
                          : colors.textPrimary,
                ),
              ),
            ),
          ),
          // Daily Total Amount
          SizedBox(
            height: 12,
            child: dayTotal > 0
                ? Text(
                    '${isExpense ? "-" : "+"}${AppHelperFunction.formatShortAmount(dayTotal)}',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      color: isExpense ? AppColors.expense : AppColors.income,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(CategoryEntity? category) {
    if (category?.color != null) return category!.color!;
    final name = category?.name ?? '';
    if (name.isEmpty) return Colors.grey;
    final hash = name.hashCode;
    final colors = [
      const Color(0xFF4CAF50), // Green
      const Color(0xFF2196F3), // Blue
      const Color(0xFFE91E63), // Pink
      const Color(0xFFFF9800), // Orange
      const Color(0xFF9C27B0), // Purple
      const Color(0xFF00BCD4), // Cyan
      const Color(0xFF009688), // Teal
    ];
    return colors[hash.abs() % colors.length];
  }
}
