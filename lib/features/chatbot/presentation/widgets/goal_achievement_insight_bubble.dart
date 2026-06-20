import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/saving_goal/data/models/goal_achievement_prediction_model.dart';
import 'package:money_care/features/saving_goal/data/models/saving_goal_report_model.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/home/presentation/widgets/transaction/transaction_item.dart';

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

    // Parse milestones
    final milestonesList = metadata['milestones'] as List<dynamic>? ?? [];
    final milestones = milestonesList
        .map((m) => MilestoneModel.fromJson(m as Map<String, dynamic>))
        .toList();

    // Tính toán milestone hiện tại (active)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final activeMilestones = milestones.where(
      (m) => !m.startDate.isAfter(now) && !m.endDate.isBefore(today),
    );

    // Lấy các giá trị truyền từ backend
    final double expectedSavingsAmount = (metadata['expectedSavingsAmount'] as num?)?.toDouble() ?? 0.0;
    final double currentMilestoneRemaining = (metadata['currentMilestoneRemaining'] as num?)?.toDouble() ?? 
        (activeMilestones.isNotEmpty 
            ? (activeMilestones.first.target - activeMilestones.first.actual).clamp(0.0, double.infinity)
            : prediction.remainingAmount);
    final double shortfall = (metadata['shortfall'] as num?)?.toDouble() ?? 0.0;
    final int daysDelayed = (metadata['daysDelayed'] as num?)?.toInt() ?? 0;
    final int daysSaved = (metadata['daysSaved'] as num?)?.toInt() ?? 0;
    final double remainingSavingCapacity = (metadata['remainingSavingCapacity'] as num?)?.toDouble() ?? 0.0;
    final double otherGoalsRequiredRate = (metadata['otherGoalsRequiredRate'] as num?)?.toDouble() ?? 0.0;
    final List<dynamic> contributionHistory = metadata['contributionHistory'] as List<dynamic>? ?? [];

    final statusColor = _riskColor(prediction.riskLevel);

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.88,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.borderSecondary, width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Tên mục tiêu
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tên mục tiêu: ${prediction.name}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              if (prediction.daysRemainingToDeadline != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.schedule_rounded, size: 14, color: colors.textSecondary),
                    const SizedBox(width: 6),
                    Text(
                      'Còn ${prediction.daysRemainingToDeadline} ngày để hoàn thành',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),

              _savingsBreakdownCard(
                expectedSavingsAmount: expectedSavingsAmount,
                otherGoalsRequiredRate: otherGoalsRequiredRate,
                remainingSavingCapacity: remainingSavingCapacity,
                currentMilestoneRemaining: currentMilestoneRemaining,
                colors: colors,
              ),
              const SizedBox(height: 12),

              // Days Saved / Shortfall Highlight
              if (shortfall > 0) ...[
                Builder(builder: (context) {
                  // Tính số tiền cần tháng sau = shortfall + target milestone tiếp theo
                  double? nextMonthRequired;
                  if (milestones.length > 1) {
                    final activeIdx = milestones.indexWhere(
                      (m) => !m.startDate.isAfter(now) && !m.endDate.isBefore(today),
                    );
                    if (activeIdx >= 0 && activeIdx + 1 < milestones.length) {
                      final nextTarget = milestones[activeIdx + 1].target;
                      nextMonthRequired = shortfall + nextTarget;
                    }
                  }

                  final shortfallText = otherGoalsRequiredRate > 0
                      ? 'Số dư sau khi trừ mục tiêu khác không đủ cho giai đoạn này. Nếu không điều chỉnh, tiến độ có thể chậm khoảng $daysDelayed ngày so với kế hoạch.'
                      : 'Số tiết kiệm dự kiến tháng này chưa đủ cho giai đoạn hiện tại. Nếu giữ nguyên mức chi tiêu, tiến độ có thể chậm khoảng $daysDelayed ngày.';

                  final nextMonthText = nextMonthRequired != null
                      ? '\nTháng sau sẽ cần ${AppHelperFunction.formatAmount(nextMonthRequired, currency: '')} ₫ để hoàn thành đúng tiến độ.'
                      : '';

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.expense.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.expense.withValues(alpha: 0.18)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(Icons.warning_amber_rounded, color: AppColors.expense, size: 18),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '$shortfallText$nextMonthText',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.expense,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (otherGoalsRequiredRate > 0)
                      _actionChip(
                        icon: Icons.pause_circle_outline,
                        label: 'Tạm dừng mục tiêu khác',
                        color: AppColors.warning,
                        onTap: () => Get.toNamed(RoutePath.savingGoalManagement),
                      ),
                    _actionChip(
                      icon: Icons.calendar_month_outlined,
                      label: 'Gia hạn mục tiêu',
                      color: AppColors.info,
                      onTap: () => Get.toNamed(
                        RoutePath.createSavingGoal,
                        arguments: prediction.goalId,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ] else if (daysSaved > 0) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: AppColors.primary, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _buildDaysSavedText(daysSaved, prediction.daysRemainingToDeadline, otherGoalsRequiredRate),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ] else if (currentMilestoneRemaining <= 0) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.income.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.income.withValues(alpha: 0.18)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline, color: AppColors.income, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Bạn đã đóng đủ cho giai đoạn này. Tiếp tục giữ vững nhịp tiết kiệm nhé! 🎉',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.income,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Tiến độ các giai đoạn
              if (milestones.isNotEmpty) ...[
                Text(
                  'Tiến độ các giai đoạn',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                ...milestones.map((m) => _milestoneProgressItem(m, colors)),
                const SizedBox(height: 16),
              ],

              // Lịch sử đóng quỹ
              Text(
                'Lịch sử đóng quỹ',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              if (contributionHistory.isEmpty)
                Text(
                  'Chưa có giao dịch đóng quỹ nào.',
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: contributionHistory.length,
                  itemBuilder: (context, index) {
                    final tx = contributionHistory[index];
                    final isLast = index == contributionHistory.length - 1;
                    final entity = TransactionEntity(
                      id: (tx['id'] as num?)?.toInt(),
                      amount: (tx['amount'] as num?)?.toInt() ?? 0,
                      type: tx['type']?.toString() ?? 'income',
                      note: tx['note']?.toString() ?? 'Nạp tiền tiết kiệm',
                      transactionDate: tx['transactionDate'] != null
                          ? DateTime.tryParse(tx['transactionDate'].toString())
                          : null,
                      category: const CategoryEntity(
                        name: 'Tiết kiệm',
                        icon: '🐷',
                        type: 'income',
                      ),
                    );
                    return TransactionItem(
                      item: entity,
                      onTap: () {},
                      isShowDivider: !isLast,
                      color: AppColors.income,
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String value,
    required Color color,
    required AppThemeColors colors,
    bool isFullWidth = false,
  }) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _savingsBreakdownCard({
    required double expectedSavingsAmount,
    required double otherGoalsRequiredRate,
    required double remainingSavingCapacity,
    required double currentMilestoneRemaining,
    required AppThemeColors colors,
  }) {
    final hasOtherGoals = otherGoalsRequiredRate > 0;
    final capacityColor = hasOtherGoals
        ? (remainingSavingCapacity >= currentMilestoneRemaining
            ? AppColors.income
            : AppColors.warning)
        : AppColors.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.borderSecondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _breakdownRow(
            label: 'Tiết kiệm dự kiến tháng này',
            value: '${AppHelperFunction.formatAmount(expectedSavingsAmount, currency: '')} ₫',
            color: AppColors.primary,
            colors: colors,
          ),
          if (hasOtherGoals) ...[
            const SizedBox(height: 6),
            _breakdownRow(
              label: 'Trừ mục tiêu hoạt động khác',
              value: '- ${AppHelperFunction.formatAmount(otherGoalsRequiredRate, currency: '')} ₫',
              color: AppColors.expense,
              colors: colors,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Divider(height: 1, color: colors.borderSecondary),
            ),
            _breakdownRow(
              label: 'Còn lại cho mục tiêu này',
              value: '${AppHelperFunction.formatAmount(remainingSavingCapacity, currency: '')} ₫',
              color: capacityColor,
              colors: colors,
              isBold: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _breakdownRow({
    required String label,
    required String value,
    required Color color,
    required AppThemeColors colors,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: colors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  String _buildDaysSavedText(int daysSaved, int? daysRemaining, double otherGoalsRate) {
    final bool canFinishThisMonth = daysRemaining != null && daysSaved >= daysRemaining;
    final String subjectPrefix = otherGoalsRate > 0
        ? 'Nếu bạn sử dụng số dư sau khi trừ mục tiêu khác'
        : 'Nếu bạn sử dụng số tiết kiệm dự kiến tháng này';

    if (canFinishThisMonth) {
      final now = DateTime.now();
      final endOfMonth = DateTime(now.year, now.month + 1, 0);
      final daysLeftInMonth = endOfMonth.day - now.day;
      final daysEarly = (daysRemaining! - daysLeftInMonth).clamp(0, daysRemaining);
      return '$subjectPrefix, bạn có thể hoàn thành mục tiêu ngay trong tháng này — sớm hơn kế hoạch $daysEarly ngày!';
    }
    return '$subjectPrefix, bạn có thể rút ngắn thời gian hoàn thành khoảng $daysSaved ngày so với kế hoạch.';
  }

  Widget _actionChip({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _milestoneProgressItem(MilestoneModel m, AppThemeColors colors) {
    final progress = m.target > 0 ? (m.actual / m.target).clamp(0.0, 1.0) : 0.0;
    final now = DateTime.now();
    final bool isActive = !m.startDate.isAfter(now) && !m.endDate.isBefore(DateTime(now.year, now.month, now.day));
    final bool isFailed = !m.isCompleted && m.endDate.isBefore(now);
    final color = m.isCompleted
        ? AppColors.income
        : (isFailed ? AppColors.expense : AppColors.primary);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                m.isCompleted
                    ? Icons.check_circle_rounded
                    : (isFailed ? Icons.cancel_rounded : (isActive ? Icons.radio_button_checked : Icons.radio_button_unchecked)),
                size: 14,
                color: color,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  m.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive ? colors.textPrimary : colors.textSecondary,
                  ),
                ),
              ),
              Text(
                '${AppHelperFunction.formatAmount(m.actual, currency: '')} / ${AppHelperFunction.formatAmount(m.target, currency: '')} ₫',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: colors.borderSecondary,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helpers ─────────────────────────────────────────────────────────────────

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

String _formatIsoDate(String iso) {
  final date = DateTime.tryParse(iso);
  if (date == null) return iso;
  return AppHelperFunction.getFormattedDate(date);
}
