import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
import 'package:money_care/features/statistics/data/models/analytics_model.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';

class EstimatedExpenseBudgetGroupCard extends StatelessWidget {
  final String categoryName;
  final int daysInMonth;
  final List<EstimatedExpenseEntity> expenses;
  final void Function(EstimatedExpenseEntity)? onExpenseTap;
  final BudgetExceedPredictionModel? exceedPrediction;

  const EstimatedExpenseBudgetGroupCard({
    super.key,
    required this.categoryName,
    required this.daysInMonth,
    required this.expenses,
    this.onExpenseTap,
    this.exceedPrediction,
  });

  static Map<String, List<EstimatedExpenseEntity>> groupExpenses(
    List<EstimatedExpenseEntity> expenses,
  ) {
    final groups = <String, List<EstimatedExpenseEntity>>{};
    for (final expense in expenses) {
      final category = expense.category?.trim();
      final key = category != null && category.isNotEmpty
          ? category
          : expense.displayName;
      groups.putIfAbsent(key, () => []).add(expense);
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = AppThemeColors.of(context);
    final monthlyLimit = _totalMonthlyLimit;
    final spent = _totalSpent;
    final progress = monthlyLimit <= 0
        ? 0.0
        : (spent / monthlyLimit).clamp(0.0, 1.0);
    final progressPercent = progress * 100;
    final progressColor = spent > monthlyLimit
        ? AppColors.expense
        : progress >= 0.8
        ? const Color(0xFFF59E0B)
        : AppColors.primary;

    // Show month-end forecast for every category with an AI prediction.
    final double? forecastRatio =
        exceedPrediction != null && exceedPrediction!.actualRatio < 1.0
        ? exceedPrediction!.forecastRatio.clamp(0.0, 1.5)
        : null;

    // Show the today pace marker only for frequent categories.
    final double? expectedTodayRatio =
        exceedPrediction != null && exceedPrediction!.isFrequent
        ? exceedPrediction?.expectedTodayRatio
        : null;
    final double? expectedTodayAmount =
        exceedPrediction != null && exceedPrediction!.isFrequent
        ? exceedPrediction?.expectedTodayAmount
        : null;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: themeColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSecondary),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: progressColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  _categoryIcon(),
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoryName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: themeColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatMoney(monthlyLimit),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: themeColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '/ tháng',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: themeColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ForecastProgressBar(
            actualRatio: progress,
            forecastRatio: forecastRatio,
            expectedTodayRatio: expectedTodayRatio,
            actualColor: progressColor,
          ),
          const SizedBox(height: 10),
          // Row 1: spent / limit + % hiện tại
          Row(
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Hiện tại: ',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: themeColors.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: '${_formatMoney(spent)} / ${_formatMoney(monthlyLimit)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: themeColors.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                '${progressPercent.toStringAsFixed(progressPercent % 1 == 0 ? 0 : 1)}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: progressColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          // Row 2: pace hôm nay + dự báo cuối tháng (chỉ khi có dữ liệu)
          if (expectedTodayAmount != null || (forecastRatio != null && exceedPrediction != null)) ...[
            const SizedBox(height: 6),
            _PaceInfoRow(
              expectedTodayAmount: expectedTodayAmount,
              actualAmount: spent,
              forecastAmount: (forecastRatio != null && exceedPrediction != null)
                  ? exceedPrediction!.totalForecast
                  : null,
              formatMoney: _formatMoney,
            ),
          ],
          if (exceedPrediction != null) ...[
            const SizedBox(height: 10),
            _BudgetExceedBadge(prediction: exceedPrediction!),
          ],
        ],
      ),
    );
  }

  double get _totalMonthlyLimit {
    return expenses.fold(0.0, (total, expense) {
      return total + _monthlyLimitFor(expense);
    });
  }

  double get _totalSpent {
    return expenses.fold(0.0, (total, expense) {
      return total + expense.spentThisMonth;
    });
  }

  double _monthlyLimitFor(EstimatedExpenseEntity expense) {
    if (expense.monthlyLimit > 0) {
      return expense.monthlyLimit;
    }
    return _monthlyizedAmount(expense);
  }

  double _monthlyizedAmount(EstimatedExpenseEntity expense) {
    final frequencyValue = expense.frequencyValue <= 0
        ? 1
        : expense.frequencyValue;
    switch (expense.frequencyType.toLowerCase()) {
      case 'daily':
        return expense.amount * frequencyValue * daysInMonth;
      case 'weekly':
        return expense.amount * frequencyValue * (daysInMonth / 7);
      case 'monthly':
      case 'once':
      default:
        return expense.amount * frequencyValue;
    }
  }

  String _categoryIcon() {
    final catController = Get.find<UserCategoryController>();
    final category = catController.categories.firstWhereOrNull(
      (item) => item.name.toLowerCase() == categoryName.toLowerCase(),
    );
    return category?.icon ?? '';
  }

  String _formatMoney(double value) {
    return AppHelperFunction.formatAmount(value);
  }
}

/// Progress bar với 2 segment: actual (solid) + forecast (mờ) + marker line
class _ForecastProgressBar extends StatelessWidget {
  final double actualRatio;
  final double? forecastRatio;
  final double? expectedTodayRatio;
  final Color actualColor;

  const _ForecastProgressBar({
    required this.actualRatio,
    required this.forecastRatio,
    required this.actualColor,
    this.expectedTodayRatio,
  });

  @override
  Widget build(BuildContext context) {
    const height = 10.0;
    final hasForecast =
        forecastRatio != null && forecastRatio! > actualRatio + 0.01;

    // Có marker "hôm nay" khi expectedTodayRatio có giá trị và nằm trong [0,1]
    final hasTodayMarker =
        expectedTodayRatio != null &&
        expectedTodayRatio! > 0.0 &&
        expectedTodayRatio! <= 1.0;

    // Tổng chiều cao: bar + label forecast phía trên (nếu có)
    final totalHeight = height + (hasForecast ? 14 : 0);

    return SizedBox(
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Label % dự báo cuối tháng phía trên marker forecast
          if (hasForecast)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 14,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final markerX =
                      (forecastRatio!.clamp(0.0, 1.0) * constraints.maxWidth)
                          .clamp(20.0, constraints.maxWidth - 20.0);
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: markerX - 30,
                        width: 60,
                        top: 0,
                        child: Text(
                          '${(forecastRatio! * 100).toStringAsFixed(0)}%',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFF59E0B),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

          // Progress bar chính (CustomPaint)
          Positioned(
            top: hasForecast ? 14 : 0,
            left: 0,
            right: 0,
            height: height,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: CustomPaint(
                painter: _DualSegmentBarPainter(
                  actualRatio: actualRatio.clamp(0.0, 1.0),
                  forecastRatio: hasForecast
                      ? forecastRatio!.clamp(0.0, 1.0)
                      : null,
                  actualColor: actualColor,
                  forecastColor: const Color(0xFFF59E0B),
                  backgroundColor: Colors.grey.shade200,
                ),
              ),
            ),
          ),

          // Marker forecast (đường dọc cam tại vị trí dự báo cuối tháng)
          if (hasForecast)
            Positioned(
              top: 14,
              left: 0,
              right: 0,
              height: height,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final markerX =
                      forecastRatio!.clamp(0.0, 1.0) * constraints.maxWidth;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: markerX - 1.5,
                        top: 0,
                        bottom: 0,
                        width: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59E0B),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

          // Marker "hôm nay" — dot tròn thay cho đường dọc
          if (hasTodayMarker)
            Positioned(
              top: hasForecast ? 14 : 0,
              left: 0,
              right: 0,
              height: height,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final todayX =
                      expectedTodayRatio!.clamp(0.0, 1.0) *
                      constraints.maxWidth;
                  final isBehindPace = actualRatio < expectedTodayRatio! - 0.02;
                  final isAheadOfPace =
                      actualRatio > expectedTodayRatio! + 0.02;
                  final dotColor = isAheadOfPace
                      ? AppColors.expense
                      : isBehindPace
                      ? AppColors.primary
                      : Colors.white;
                  final borderColor = isAheadOfPace
                      ? AppColors.expense
                      : isBehindPace
                      ? AppColors.primary
                      : Colors.grey.shade400;
                  final dotSize = height + 4.0;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: todayX - dotSize / 2,
                        top: (height - dotSize) / 2,
                        width: dotSize,
                        height: dotSize,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: dotColor,
                            border: Border.all(color: borderColor, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: dotColor.withValues(alpha: 0.45),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// Row hiển thị pace hôm nay và dự báo cuối tháng
class _PaceInfoRow extends StatelessWidget {
  final double? expectedTodayAmount;
  final double actualAmount;
  final double? forecastAmount;
  final String Function(double) formatMoney;

  const _PaceInfoRow({
    required this.expectedTodayAmount,
    required this.actualAmount,
    required this.forecastAmount,
    required this.formatMoney,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = AppThemeColors.of(context);

    return Row(
      children: [
        // Dự kiến cuối hôm nay
        if (expectedTodayAmount != null) ...[
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Dự kiến hôm nay: ',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: themeColors.textMuted,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                  TextSpan(
                    text: formatMoney(expectedTodayAmount!),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: themeColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        if (expectedTodayAmount == null) const Spacer(),
        // Dự báo cuối tháng
        if (forecastAmount != null)
          Text(
            '→ ${formatMoney(forecastAmount!)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFFF59E0B),
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
      ],
    );
  }
}

class _DualSegmentBarPainter extends CustomPainter {  final double actualRatio;
  final double? forecastRatio;
  final Color actualColor;
  final Color forecastColor;
  final Color backgroundColor;

  const _DualSegmentBarPainter({
    required this.actualRatio,
    required this.forecastRatio,
    required this.actualColor,
    required this.forecastColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Radius.circular(size.height / 2);

    // Background
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        radius,
      ),
      Paint()..color = backgroundColor,
    );

    // Forecast segment (mờ, vẽ trước)
    if (forecastRatio != null && forecastRatio! > actualRatio) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, forecastRatio! * size.width, size.height),
          radius,
        ),
        Paint()..color = forecastColor.withValues(alpha: 0.25),
      );
    }

    // Actual segment (solid, đè lên forecast)
    if (actualRatio > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, actualRatio * size.width, size.height),
          radius,
        ),
        Paint()..color = actualColor,
      );
    }
  }

  @override
  bool shouldRepaint(_DualSegmentBarPainter old) =>
      old.actualRatio != actualRatio ||
      old.forecastRatio != forecastRatio ||
      old.actualColor != actualColor;
}

class _BudgetExceedBadge extends StatelessWidget {
  final BudgetExceedPredictionModel prediction;

  const _BudgetExceedBadge({required this.prediction});

  @override
  Widget build(BuildContext context) {
    final probabilityPct = (prediction.exceedProbability * 100).round();
    final alreadyExceeded = prediction.actualRatio >= 1.0;
    final forecastWillExceed = !alreadyExceeded && prediction.willExceed;
    final moderateRisk =
        !alreadyExceeded && !prediction.willExceed && probabilityPct >= 40;

    if (!alreadyExceeded && !forecastWillExceed && !moderateRisk) {
      return const SizedBox.shrink();
    }

    final Color badgeColor;
    final String icon;
    final String label;

    if (alreadyExceeded) {
      final overAmount = prediction.actualAmount - prediction.limitAmount;
      badgeColor = AppColors.expense;
      icon = '🔴';
      label =
          'Đã vượt ${AppHelperFunction.formatAmount(overAmount)} '
          '(${(prediction.actualRatio * 100).toStringAsFixed(0)}% ngân sách)';
    } else if (forecastWillExceed) {
      badgeColor = const Color(0xFFF59E0B);
      icon = '⚠️';
      label =
          'Dự kiến vượt ${AppHelperFunction.formatAmount(prediction.exceedAmount)} '
          'vào cuối tháng';
    } else {
      badgeColor = const Color(0xFF6366F1);
      icon = '📊';
      label = 'Có nguy cơ vượt ngân sách (~$probabilityPct%)';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: badgeColor.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: badgeColor,
                fontWeight: FontWeight.w700,
                fontSize: 11.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
