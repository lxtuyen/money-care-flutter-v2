import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/features/saving_goal/data/models/saving_goal_report_model.dart';
import 'package:money_care/features/saving_goal/domain/entities/saving_goal_entity.dart';
import 'package:money_care/features/saving_goal/presentation/widgets/milestone_map.dart';
import 'package:money_care/features/statistics/presentation/models/goal_plan_impact.dart';
import 'package:money_care/features/statistics/data/models/goal_plan_insight_model.dart';
import 'package:money_care/app/widgets/dialog/selection_dialog.dart';
import 'package:money_care/features/wallet/presentation/controllers/wallet_controller.dart';

class SavingGoalSummaryCard extends StatelessWidget {
  final SavingGoalEntity fund;
  final SavingGoalReportModel? report;
  final bool isLoading;
  final GoalPlanImpact? planImpact;
  final GoalPlanInsightSnapshot? insightSnapshot;

  const SavingGoalSummaryCard({
    super.key,
    required this.fund,
    this.report,
    this.isLoading = false,
    this.planImpact,
    this.insightSnapshot,
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
          if (insightSnapshot != null) ...[
            const SizedBox(height: 12),
            _GoalPlanAiInsight(snapshot: insightSnapshot!),
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

          if (insightSnapshot != null) ...[
            const SizedBox(height: 12),
            _GoalPlanAiInsight(snapshot: insightSnapshot!),
          ],
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
                    AppColors.primary.withValues(alpha: 0.08),
                    AppColors.primary.withValues(alpha: 0.02),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.15),
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
                          color: AppColors.primary.withValues(alpha: 0.1),
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
                        AppHelperFunction.formatAmount(
                          r.walletBalance,
                          currency: 'VND',
                        ),
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
                          color: AppThemeColors.of(
                            context,
                          ).textMuted.withValues(alpha: 0.2),
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
                      color: AppColors.success.withValues(alpha: 0.2),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
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

class _GoalPlanAiInsight extends StatefulWidget {
  final GoalPlanInsightSnapshot snapshot;

  const _GoalPlanAiInsight({required this.snapshot});

  @override
  State<_GoalPlanAiInsight> createState() => _GoalPlanAiInsightState();
}

class _GoalPlanAiInsightState extends State<_GoalPlanAiInsight> {
  late final StatisticsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<StatisticsController>();
  }

  Widget _buildPremiumBadge(
    BuildContext context,
    GoalPlanInsightModel insight,
  ) {
    final status = insight.projectionStatus;
    final diff = insight.projectedDaysDiff ?? 0;

    Color badgeBgColor;
    Color borderColor;
    Color textColor;
    IconData icon;
    String label;

    if (status == 'early') {
      badgeBgColor = AppColors.income.withValues(alpha: 0.08);
      borderColor = AppColors.income.withValues(alpha: 0.16);
      textColor = AppColors.income;
      icon = Icons.trending_up_rounded;
      label = 'Dự kiến sớm ${diff.abs()} ngày';
    } else if (status == 'delayed') {
      badgeBgColor = AppColors.expense.withValues(alpha: 0.08);
      borderColor = AppColors.expense.withValues(alpha: 0.16);
      textColor = AppColors.expense;
      icon = diff == 999
          ? Icons.warning_amber_rounded
          : Icons.trending_down_rounded;
      label = diff == 999
          ? 'Không thể hoàn thành chặng (tiêu lạm vốn)'
          : 'Dự kiến trễ $diff ngày';
    } else {
      badgeBgColor = AppColors.primary.withValues(alpha: 0.08);
      borderColor = AppColors.primary.withValues(alpha: 0.16);
      textColor = AppColors.primary;
      icon = Icons.check_circle_outline_rounded;
      label = 'Đúng tiến độ chặng';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: badgeBgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    GoalPlanInsightModel? insight,
    bool isLoading,
    bool hasError,
    AppThemeColors themeColors,
  ) {
    if (isLoading) {
      return Text(
        'AI đang phân tích...',
        key: const ValueKey('loading'),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: themeColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    if (insight == null) {
      return Column(
        key: const ValueKey('no_insight'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AI phân tích',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: themeColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (hasError)
                Text(
                  'Lỗi phân tích',
                  style: TextStyle(
                    color: AppColors.expense,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          InkWell(
            onTap: () {
              _controller.loadGoalPlanInsight(widget.snapshot);
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.play_arrow_rounded,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Phân tích ngay',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      key: const ValueKey('loaded'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'AI phân tích',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: themeColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        _buildPremiumBadge(context, insight),
        const SizedBox(height: 4),
        Text(
          insight.summary,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: themeColors.textSecondary,
            fontWeight: FontWeight.w700,
            height: 1.35,
          ),
        ),
        if (insight.reason.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            insight.reason,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: themeColors.textSecondary,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
        ],
        if (insight.suggestion.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            insight.suggestion,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = AppThemeColors.of(context);

    return Obx(() {
      final insight = _controller.goalPlanInsight.value;
      final isLoading = _controller.isLoadingGoalPlanInsight.value;
      final hasError = _controller.goalPlanInsightError.value.isNotEmpty;

      return AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.12),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  switchInCurve: Curves.easeOutBack,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.0, 0.1),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                  child: _buildContent(
                    context,
                    insight,
                    isLoading,
                    hasError,
                    themeColors,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
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
          style: TextStyle(
            fontSize: 10,
            color: AppThemeColors.of(context).textSecondary,
          ),
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

class _SmallStat extends StatelessWidget {
  final String label;
  final String value;
  final BuildContext context;

  const _SmallStat({
    required this.label,
    required this.value,
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
                color: AppThemeColors.of(context).textPrimary,
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
