import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';

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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: AppColors.text5, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              gradient: AppColors.linearGradient,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                const Icon(Icons.savings_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 8),
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
            _buildFromReport(report!),
        ],
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
              value: AppHelperFunction.formatAmount(fund.savedAmount, 'VND'),
              progress: fund.target != null && fund.target! > 0 ? (fund.savedAmount / fund.target!).clamp(0, 1) : 0,
              color: AppColors.primary,
            ),
          if (fund.target != null && fund.target! > 0) ...[
            const SizedBox(height: 12),
            _BudgetRow(
              label: 'Mục tiêu',
              value: AppHelperFunction.formatAmount(fund.target!, 'VND'),
              progress: 0,
              color: AppColors.success,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFromReport(SavingGoalReportModel r) {
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
                  centerText: '${r.targetCompletionPercentage}%',
                  color: r.isTargetAchieved ? AppColors.success : AppColors.secondaryOrange,
                  subtitle: AppHelperFunction.formatAmount(r.target, 'VND'),
                  subtitleLabel: 'mục tiêu',
                ),
              ),
            ],
          ),
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
                  value: AppHelperFunction.formatAmount(r.dailyAverageSpending, 'VND'),
                ),
              ),
              Expanded(
                child: _QuickStat(
                  icon: Icons.calendar_month_rounded,
                  label: 'Còn lại',
                  value: AppHelperFunction.formatAmount(r.remainingBudget, 'VND'),
                  valueColor: r.remainingBudget < 0 ? AppColors.error : AppColors.success,
                ),
              ),
            ],
          ),

          if (r.milestones.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Divider(height: 1),
            const SizedBox(height: 16),
            MilestoneMap(milestones: r.milestones),
          ],

          if (!r.isCompleted && r.currentBalance >= r.target && r.currentMilestoneIndex >= 0 && r.currentMilestoneIndex < r.milestones.length - 1) ...[
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
                  icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
                  label: const Text(
                    'Hoàn thành sớm mục tiêu',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
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
  final String subtitleLabel;

  const _CircleMetric({
    required this.label,
    required this.percent,
    required this.centerText,
    required this.color,
    required this.subtitle,
    required this.subtitleLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.text3, fontWeight: FontWeight.w500)),
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
                      PieChartSectionData(color: color, value: percent, title: '', radius: 10),
                      PieChartSectionData(color: color.withOpacity(0.12), value: 1 - percent, title: '', radius: 10),
                    ],
                  ),
                ),
                Text(centerText, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.text1),
            overflow: TextOverflow.ellipsis,
          ),
          Text(subtitleLabel, style: const TextStyle(fontSize: 11, color: AppColors.text4)),
        ],
      ),
    );
  }
}

class _CategoryPieRow extends StatelessWidget {
  final List<CategorySpendingModel> categories;

  const _CategoryPieRow({required this.categories});

  static const _colors = [
    AppColors.primary,
    AppColors.secondaryOrange,
    AppColors.success,
    AppColors.warning,
    AppColors.secondaryNavyBlue,
    AppColors.info,
  ];

  @override
  Widget build(BuildContext context) {
    final top = categories.take(5).toList();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: PieChart(
            PieChartData(
              startDegreeOffset: -90,
              centerSpaceRadius: 22,
              sectionsSpace: 2,
              sections: top.asMap().entries.map((e) {
                return PieChartSectionData(
                  color: _colors[e.key % _colors.length],
                  value: e.value.percentage.toDouble(),
                  title: '',
                  radius: 18,
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: top.asMap().entries.map((e) {
              final cat = e.value;
              final color = _colors[e.key % _colors.length];
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        cat.categoryName,
                        style: const TextStyle(fontSize: 12, color: AppColors.text2),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${cat.percentage}%',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.text1),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _QuickStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _QuickStat({required this.icon, required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: valueColor ?? AppColors.text1),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.text4)),
      ],
    );
  }
}

class _BudgetRow extends StatelessWidget {
  final String label;
  final String value;
  final double progress;
  final Color color;

  const _BudgetRow({required this.label, required this.value, required this.progress, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, color: AppColors.text3)),
            Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.text1)),
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
