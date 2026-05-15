import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/transaction/domain/entities/total_by_category_entity.dart';

class MonthlyBudgetCard extends StatelessWidget {
  final double totalBudget;
  final double totalSpent;
  final int daysRemaining;
  final int totalDays;
  final List<TotalByCategoryEntity> categories;

  const MonthlyBudgetCard({
    super.key,
    required this.totalBudget,
    required this.totalSpent,
    required this.daysRemaining,
    required this.totalDays,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = AppThemeColors.of(context);

    return Obx(() {
      final remaining = totalBudget - totalSpent;
      final dailyAllowance =
          daysRemaining > 0 ? remaining / daysRemaining : 0.0;
      final utilization =
          totalBudget > 0 ? (totalSpent / totalBudget).clamp(0.0, 1.5) : 0.0;
      final isOverBudget = totalSpent > totalBudget;
      final isNearLimit = utilization >= 0.8 && !isOverBudget;

      final Color progressColor = isOverBudget
          ? const Color(0xFFE53935)
          : isNearLimit
              ? const Color(0xFFFFA726)
              : const Color(0xFF43A047);

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          decoration: BoxDecoration(
            color: themeColors.cardBackground,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      progressColor.withValues(alpha: 0.08),
                      progressColor.withValues(alpha: 0.03),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: progressColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.account_balance_wallet_rounded,
                        color: progressColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'budget.monthlyTitle'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: themeColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: progressColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isOverBudget
                            ? 'budget.exceeded'.tr
                            : isNearLimit
                                ? 'budget.nearLimit'.tr
                                : 'budget.onTrack'.tr,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: progressColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: CustomPaint(
                            painter: _BudgetRingPainter(
                              progress: utilization.clamp(0.0, 1.0),
                              color: progressColor,
                              trackColor:
                                  themeColors.borderSecondary,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${(utilization * 100).clamp(0, 999).toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: progressColor,
                                      height: 1,
                                    ),
                                  ),
                                  Text(
                                    'budget.used'.tr,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: themeColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 20),

                        // Budget info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow(
                                label: 'budget.totalBudget'.tr,
                                value: AppHelperFunction.formatAmount(totalBudget),
                                color: themeColors.textPrimary,
                                isBold: true,
                                themeColors: themeColors,
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                label: 'budget.spent'.tr,
                                value: AppHelperFunction.formatAmount(totalSpent),
                                color: const Color(0xFFE53935),
                                themeColors: themeColors,
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                label: 'budget.remaining'.tr,
                                value: AppHelperFunction.formatAmount(remaining.clamp(0, double.infinity)),
                                color: isOverBudget
                                    ? const Color(0xFFE53935)
                                    : const Color(0xFF43A047),
                                isBold: true,
                                themeColors: themeColors,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Daily allowance strip
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: themeColors.surfaceBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'budget.dailyAllowance'.tr,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: themeColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            AppHelperFunction.formatAmount(
                                    dailyAllowance.clamp(0, double.infinity)),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '/ ${'budget.day'.tr}',
                            style: TextStyle(
                              fontSize: 11,
                              color: themeColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Days remaining
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: themeColors.surfaceBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.hourglass_bottom_rounded,
                            size: 16,
                            color: themeColors.textMuted,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'budget.daysLeft'.tr,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: themeColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '$daysRemaining',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: themeColors.textPrimary,
                            ),
                          ),
                          Text(
                            ' / $totalDays ${'budget.days'.tr}',
                            style: TextStyle(
                              fontSize: 11,
                              color: themeColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required Color color,
    required AppThemeColors themeColors,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: themeColors.textMuted,
          ),
        ),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom painter for a circular progress ring.
class _BudgetRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;

  _BudgetRingPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) / 2) - 6;
    const strokeWidth = 10.0;
    const startAngle = -math.pi / 2;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _BudgetRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.trackColor != trackColor;
  }
}
