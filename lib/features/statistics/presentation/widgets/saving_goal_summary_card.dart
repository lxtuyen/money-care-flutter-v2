import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';

import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';
import 'package:money_care/features/saving_goal/data/models/saving_goal_report_model.dart';
import 'package:money_care/features/saving_goal/data/models/goal_achievement_prediction_model.dart';
import 'package:money_care/features/saving_goal/domain/entities/saving_goal_entity.dart';
import 'package:money_care/features/saving_goal/presentation/widgets/milestone_map.dart';
import 'package:money_care/features/saving_goal/presentation/widgets/goal_achievement_prediction_block.dart';
import 'package:money_care/features/statistics/presentation/models/goal_plan_impact.dart';
import 'package:money_care/app/widgets/dialog/selection_dialog.dart';
import 'package:money_care/features/wallet/presentation/controllers/wallet_controller.dart';

class SavingGoalSummaryCard extends StatelessWidget {
  final SavingGoalEntity fund;
  final SavingGoalReportModel? report;
  final bool isLoading;
  final GoalPlanImpact? planImpact;
  final GoalAchievementPredictionModel? prediction;

  const SavingGoalSummaryCard({
    super.key,
    required this.fund,
    this.report,
    this.isLoading = false,
    this.planImpact,
    this.prediction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppThemeColors.of(context).cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.text5,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.toNamed(RoutePath.savingGoalDetail, arguments: fund),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                decoration: BoxDecoration(
                  gradient: AppColors.linearGradient,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        fund.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Xem chi tiết',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 10,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (isLoading)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (report == null)
                _buildFromFundOnly(context)
              else
                _buildFromReport(context, report!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFromFundOnly(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (fund.savedAmount > 0)
            _BudgetRow(
              label: 'Đã tiết kiệm',
              value: AppHelperFunction.formatAmount(
                fund.savedAmount,
                currency: 'VND',
              ),
              progress: fund.target != null && fund.target! > 0
                  ? (fund.savedAmount / fund.target!).clamp(0, 1)
                  : 0,
              color: AppColors.primary,
            ),
          if (fund.target != null && fund.target! > 0) ...[
            const SizedBox(height: 12),
            _BudgetRow(
              label: 'Mục tiêu',
              value: AppHelperFunction.formatAmount(
                fund.target!,
                currency: 'VND',
              ),
              progress: 0,
              color: AppColors.success,
            ),
          ],
          if (planImpact != null) ...[
            const SizedBox(height: 12),
            _PlanImpactLine(impact: planImpact!),
          ],
          if (_matchingPrediction != null) ...[
            const SizedBox(height: 12),
            GoalAchievementPredictionBlock(
              prediction: _matchingPrediction!,
              goalId: fund.id,
              goalEndDate: fund.endDate,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFromReport(BuildContext context, SavingGoalReportModel r) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _CircleMetric(
                  label: 'Mục tiêu',
                  percent: (r.targetCompletionPercentage / 100).clamp(0.0, 1.0),
                  centerText:
                      '${r.targetCompletionPercentage > 100 ? 100 : r.targetCompletionPercentage}%',
                  color: r.isTargetAchieved
                      ? AppColors.income
                      : AppColors.secondaryOrange,
                  subtitle: AppHelperFunction.formatAmount(
                    r.target,
                    currency: 'VND',
                  ),
                ),
              ),
            ],
          ),

          if (_matchingPrediction != null) ...[
            const SizedBox(height: 12),
            GoalAchievementPredictionBlock(
              prediction: _matchingPrediction!,
              goalId: fund.id,
              goalEndDate: fund.endDate ?? r.endDate,
              milestones: r.milestones,
            ),
          ],
          const SizedBox(height: 16),
         /* const Divider(height: 1),
          const SizedBox(height: 12),*/
          // TODO: tạm ẩn card thông tin ví
          /*if (false) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _QuickStat(
                    icon: Icons.receipt_long_rounded,
                    label: 'Giao dịch',
                    value: '${r.totalTransactions}',
                  ),
                ),
                Expanded(
                  child: _QuickStat(
                    icon: Icons.today_rounded,
                    label: 'TB/ngày',
                    value: AppHelperFunction.formatAmount(
                      r.dailyAverageSpending,
                      currency: 'VND',
                    ),
                  ),
                ),
                Expanded(
                  child: _QuickStat(
                    icon: Icons.calendar_month_rounded,
                    label: 'Hiện tại',
                    value: AppHelperFunction.formatAmount(
                      r.remainingBudget,
                      currency: 'VND',
                    ),
                    valueColor: r.remainingBudget < 0
                        ? AppColors.expense
                        : AppColors.income,
                  ),
                ),
              ],
            ),
          ],*/

          if (r.milestones.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Divider(height: 1),
            const SizedBox(height: 16),
            MilestoneMap(milestones: r.milestones),
          ],

          if (!r.isCompleted && r.isTargetAchieved) ...[
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withValues(alpha: 0.2),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: PrimaryButton(
                  label: 'Hoàn thành mục tiêu',
                  onPressed: () {
                    final walletController = Get.find<WalletController>();
                    final options = walletController.wallets
                        .where((w) => w.id != fund.wallet?.id)
                        .map(
                          (w) => SelectionOption(
                            id: w.id.toString(),
                            label: w.name,
                          ),
                        )
                        .toList();

                    if (options.isEmpty || fund.wallet == null) {
                      final controller = Get.find<SavingGoalController>();
                      controller.completeGoalEarly(r.id);
                      return;
                    }

                    showDialog(
                      context: context,
                      builder: (context) => SelectionDialog(
                        title: 'Chọn ví nhận tiền',
                        description:
                            'Bạn đã hoàn thành mục tiêu! Chọn một ví chính để chuyển ${AppHelperFunction.formatAmount(r.walletBalance, currency: 'VND')} về nhé.',
                        clearButtonText: 'common.delete',
                        options: options,
                        onSelect: (id, label) {
                          if (id != null) {
                            final destId = int.parse(id);
                            final controller = Get.find<SavingGoalController>();
                            controller.completeGoalWithTransfer(
                              goalId: r.id,
                              sourceWalletId: fund.wallet!.id,
                              destinationWalletId: destId,
                              amount: r.walletBalance,
                            );
                          }
                        },
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 20,
                  ),
                  backgroundColor: AppColors.income,
                  height: 48,
                  borderRadius: 12,
                  fontSize: 13,
                  elevation: 0,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  GoalAchievementPredictionModel? get _matchingPrediction {
    final value = prediction;
    if (value == null || value.goalId != fund.id) return null;
    return value;
  }
}



class _PlanImpactLine extends StatelessWidget {
  final GoalPlanImpact impact;

  const _PlanImpactLine({required this.impact});

  @override
  Widget build(BuildContext context) {
    final color = switch (impact.status) {
      GoalPlanImpactStatus.delayed => AppColors.expense,
      GoalPlanImpactStatus.onTrack => AppColors.primary,
    };
    final themeColors = AppThemeColors.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_awesome_rounded, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Theo kế hoạch tháng này',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: themeColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: themeColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String get _description {
    if (impact.status == GoalPlanImpactStatus.delayed) {
      final amount = AppHelperFunction.formatAmount(impact.overAmount);
      return 'Chậm tiến độ vì chi tiêu đã vượt phần kế hoạch lũy tiến $amount.';
    }
    return 'Đúng tiến độ vì chi tiêu vẫn nằm trong phần kế hoạch lũy tiến.';
  }
}

class _CircleMetric extends StatelessWidget {
  final String label;
  final double percent;
  final String centerText;
  final Color color;
  final String subtitle;

  const _CircleMetric({
    required this.label,
    required this.percent,
    required this.centerText,
    required this.color,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppThemeColors.of(context).surfaceBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppThemeColors.of(context).textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 72,
            height: 72,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    startDegreeOffset: -90,
                    centerSpaceRadius: 26,
                    sectionsSpace: 0,
                    sections: [
                      PieChartSectionData(
                        color: color,
                        value: percent,
                        title: '',
                        radius: 10,
                      ),
                      PieChartSectionData(
                        color: color.withValues(alpha: 0.12),
                        value: 1 - percent,
                        title: '',
                        radius: 10,
                      ),
                    ],
                  ),
                ),
                Text(
                  centerText,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppThemeColors.of(context).textPrimary,
            ),

            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/*class _QuickStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _QuickStat({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppThemeColors.of(context).textPrimary,
          ),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppThemeColors.of(context).textSecondary,
          ),
        ),
      ],
    );
  }
}*/

class _BudgetRow extends StatelessWidget {
  final String label;
  final String value;
  final double progress;
  final Color color;

  const _BudgetRow({
    required this.label,
    required this.value,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: AppThemeColors.of(context).textSecondary,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppThemeColors.of(context).textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: AppColors.borderSecondary,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
