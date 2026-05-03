import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';
import 'package:money_care/features/saving_goal/data/models/saving_goal_report_model.dart';
import 'package:money_care/features/saving_goal/domain/entities/saving_goal_entity.dart';
import 'package:money_care/features/saving_goal/presentation/widgets/milestone_map.dart';

class SavingGoalSummaryCard extends StatelessWidget {
  final SavingGoalEntity fund;
  final SavingGoalReportModel? report;
  final bool isLoading;

  const SavingGoalSummaryCard({
    super.key,
    required this.fund,
    this.report,
    this.isLoading = false,
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
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 10,
                          color: Colors.white.withOpacity(0.9),
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
                _buildFromFundOnly()
              else
                _buildFromReport(context, report!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFromFundOnly() {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (fund.savedAmount > 0)
              _BudgetRow(
                label: 'Đã tiết kiệm',
                value: AppHelperFunction.formatAmount(fund.savedAmount, currency: 'VND'),
                progress: fund.target != null && fund.target! > 0
                    ? (fund.savedAmount / fund.target!).clamp(0, 1)
                    : 0,
                color: AppColors.primary,
              ),
            if (fund.target != null && fund.target! > 0) ...[
              const SizedBox(height: 12),
              _BudgetRow(
                label: 'Mục tiêu',
                value: AppHelperFunction.formatAmount(fund.target!, currency: 'VND'),
                progress: 0,
                color: AppColors.success,
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
                    percent:
                        (r.targetCompletionPercentage / 100).clamp(0.0, 1.0),
                    centerText: '${r.targetCompletionPercentage > 100 ? 100 : r.targetCompletionPercentage}%',
                    color: r.isTargetAchieved
                        ? AppColors.income
                        : AppColors.secondaryOrange,
                    subtitle: AppHelperFunction.formatAmount(r.target, currency: 'VND'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            if (r.walletName != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withOpacity(0.08),
                      AppColors.primary.withOpacity(0.02),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.15),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet_rounded,
                            size: 22,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    r.walletName!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(height: 1, thickness: 0.5),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Số dư hiện khả dụng',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppThemeColors.of(context).textSecondary,
                          ),
                        ),
                        Text(
                          AppHelperFunction.formatAmount(r.walletBalance, currency: 'VND'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: _SmallStat(
                              label: 'Giao dịch',
                              value: '${r.totalTransactions}',
                              context: context,
                            ),
                          ),
                          VerticalDivider(
                            width: 1,
                            thickness: 0.5,
                            color: AppThemeColors.of(context).textMuted.withOpacity(0.2),
                          ),
                          Expanded(
                            child: _SmallStat(
                              label: 'TB Chi tiêu',
                              value: AppHelperFunction.formatAmount(
                                r.dailyAverageSpending,
                                currency: 'VND',
                              ),
                              context: context,
                            ),
                          ),
                          VerticalDivider(
                            width: 1,
                            thickness: 0.5,
                            color: AppThemeColors.of(context).textMuted.withOpacity(0.2),
                          ),
                          Expanded(
                            child: _SmallStat(
                              label: 'Hiện tại',
                              value: AppHelperFunction.formatAmount(
                                r.remainingBudget,
                                currency: 'VND',
                              ),
                              valueColor: r.remainingBudget < 0
                                  ? AppColors.expense
                                  : AppColors.income,
                              context: context,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),
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
            ],

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
                      color: AppColors.success.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    final controller = Get.find<SavingGoalController>();
                    controller.completeGoalEarly(r.id);
                  },
                  icon: const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 20,
                  ),
                  label: const Text(
                    'Hoàn thành mục tiêu',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.income,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
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
                        color: color.withOpacity(0.12),
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

class _QuickStat extends StatelessWidget {
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
          style: TextStyle(fontSize: 10, color: AppThemeColors.of(context).textSecondary),
        ),
      ],
    );
  }
}

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
              style: TextStyle(fontSize: 13, color: AppThemeColors.of(context).textSecondary),
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

class _SmallStat extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final BuildContext context;

  const _SmallStat({
    required this.label,
    required this.value,
    this.valueColor,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: valueColor ?? AppThemeColors.of(context).textPrimary,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                color: AppThemeColors.of(context).textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
