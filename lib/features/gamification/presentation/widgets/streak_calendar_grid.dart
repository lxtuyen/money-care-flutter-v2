import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/gamification/presentation/controllers/streak_calendar_controller.dart';

class StreakCalendarGrid extends StatelessWidget {
  final StreakCalendarController controller;

  const StreakCalendarGrid({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final focus = controller.focusedMonth.value;
    final firstDay = DateTime(focus.year, focus.month, 1);
    final daysInMonth = DateTime(focus.year, focus.month + 1, 0).day;
    final startOffset = firstDay.weekday - 1;

    final totalCells = startOffset + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppThemeColors.of(context).cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(12),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 0.68,
          ),
          itemCount: rows * 7,
          itemBuilder: (context, index) {
            final dayNum = index - startOffset + 1;
            if (dayNum < 1 || dayNum > daysInMonth) {
              return const SizedBox.shrink();
            }

            final hasTx = controller.daysWithTx.contains(dayNum);
            final net = controller.dailyNet[dayNum] ?? 0;
            final isToday = controller.isToday(dayNum);
            final isSelected = controller.selectedDay.value == dayNum;

            final txCountOnDay = controller.dailyTxCount[dayNum] ?? 0;
            final maxTxCount = controller.maxDailyTxCount.value;

            double intensityRatio = 0.0;
            if (txCountOnDay > 0) {
              if (maxTxCount <= 1) {
                intensityRatio = 0.2;
              } else {
                intensityRatio = 0.15 +
                    ((txCountOnDay - 1) / (maxTxCount - 1)) * 0.70;
              }
            }

            return _DayCell(
              day: dayNum,
              hasTx: hasTx,
              net: net,
              isToday: isToday,
              isSelected: isSelected,
              intensityRatio: intensityRatio,
              onTap: () => controller.selectDay(dayNum),
            );
          },
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final bool hasTx;
  final int net;
  final bool isToday;
  final bool isSelected;
  final double intensityRatio;
  final VoidCallback onTap;

  const _DayCell({
    required this.day,
    required this.hasTx,
    required this.net,
    required this.isToday,
    required this.isSelected,
    required this.intensityRatio,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formattedNet = AppHelperFunction.formatCompactNumber(net);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 18,
            child: hasTx
                ? const Icon(
                    Icons.local_fire_department,
                    size: 13,
                    color: AppColors.secondaryOrange,
                  )
                : null,
          ),
          const SizedBox(height: 1),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: isToday
                  ? AppColors.primary
                  : isSelected
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : hasTx
                  ? AppColors.secondaryOrange.withValues(alpha: intensityRatio)
                  : Colors.transparent,
              shape: BoxShape.circle,
              border: isToday
                  ? null
                  : isSelected
                  ? Border.all(color: AppColors.primary, width: 2)
                  : hasTx
                  ? Border.all(
                      color: AppColors.secondaryOrange.withValues(
                        alpha: intensityRatio.clamp(0.4, 1.0),
                      ),
                      width: 1.5,
                    )
                  : null,
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isToday || hasTx || isSelected
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: isToday
                      ? Colors.white
                      : isSelected
                      ? AppColors.primary
                      : hasTx
                      ? (intensityRatio > 0.55
                          ? Colors.white
                          : AppColors.secondaryOrange)
                      : AppThemeColors.of(context).textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          SizedBox(
            height: 13,
            child: hasTx
                ? Text(
                    net >= 0 ? '+$formattedNet' : formattedNet,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: net >= 0 ? AppColors.income : AppColors.expense,
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
}
