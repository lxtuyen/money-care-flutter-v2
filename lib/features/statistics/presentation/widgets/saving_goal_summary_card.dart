import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';

import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';
import 'package:money_care/features/saving_goal/data/models/saving_goal_report_model.dart';
import 'package:money_care/features/saving_goal/data/models/goal_achievement_prediction_model.dart';
import 'package:money_care/features/saving_goal/domain/entities/saving_goal_entity.dart';
import 'package:money_care/features/saving_goal/presentation/widgets/milestone_map.dart';
import 'package:money_care/features/saving_goal/presentation/widgets/goal_achievement_prediction_block.dart';
import 'package:money_care/features/statistics/presentation/models/goal_plan_impact.dart';
import 'package:money_care/features/transaction/data/models/transaction_response_model.dart';

class SavingGoalSummaryCard extends StatefulWidget {
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
  State<SavingGoalSummaryCard> createState() => _SavingGoalSummaryCardState();
}

class _SavingGoalSummaryCardState extends State<SavingGoalSummaryCard> {
  bool _isExpanded = false;
  bool _showAllTransactions = false;

  GoalAchievementPredictionModel? get _matchingPrediction {
    final value = widget.prediction;
    if (value == null || value.goalId != widget.fund.id) return null;
    return value;
  }

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            if (_isExpanded) _buildExpandedBody(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final themeColors = AppThemeColors.of(context);
    final double target = widget.report?.target ?? widget.fund.target ?? 0;
    final double saved = widget.report?.currentBalance ?? widget.fund.savedAmount;
    final double progress = target > 0 ? (saved / target).clamp(0.0, 1.0) : 0.0;
    final int percent = (progress * 100).toInt();

    return InkWell(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.fund.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text1,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text3,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${AppHelperFunction.formatAmount(saved)} / ${AppHelperFunction.formatAmount(target)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: themeColors.textSecondary,
                  ),
                ),
                Text(
                  '$percent%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: AppColors.borderSecondary,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress >= 1.0 ? AppColors.income : AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedBody(BuildContext context) {
    if (widget.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (widget.report == null) {
      return _buildFromFundOnlyExpanded(context);
    }

    return _buildFromReportExpanded(context, widget.report!);
  }

  Widget _buildFromFundOnlyExpanded(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1),
          const SizedBox(height: 16),
          if (_matchingPrediction != null && Get.find<AppController>().isPremium.value) ...[
            GoalAchievementPredictionBlock(
              prediction: _matchingPrediction!,
              goalId: widget.fund.id,
              goalEndDate: widget.fund.endDate,
            ),
            const SizedBox(height: 16),
          ],
          _buildActionButtons(widget.fund.isCompleted, widget.fund.savedAmount >= (widget.fund.target ?? 0)),
        ],
      ),
    );
  }

  Widget _buildFromReportExpanded(BuildContext context, SavingGoalReportModel r) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1),
          const SizedBox(height: 16),

          if (_matchingPrediction != null && Get.find<AppController>().isPremium.value) ...[
            GoalAchievementPredictionBlock(
              prediction: _matchingPrediction!,
              goalId: widget.fund.id,
              goalEndDate: widget.fund.endDate ?? r.endDate,
              milestones: r.milestones,
            ),
            const SizedBox(height: 16),
          ],

          if (r.milestones.isNotEmpty) ...[
            MilestoneMap(milestones: r.milestones),
            const SizedBox(height: 16),
          ],

          _buildTransactionHistory(r.transactions),
          const SizedBox(height: 20),

          _buildActionButtons(r.isCompleted, r.isTargetAchieved),
        ],
      ),
    );
  }

  Widget _buildTransactionHistory(List<TransactionModel> transactions) {
    final themeColors = AppThemeColors.of(context);
    if (transactions.isEmpty) return const SizedBox.shrink();

    const maxVisible = 3;
    final showToggle = transactions.length > maxVisible;
    final visible = _showAllTransactions
        ? transactions
        : transactions.take(maxVisible).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lịch sử đóng góp',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.text1,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: themeColors.surfaceBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderSecondary),
          ),
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: visible.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
                itemBuilder: (context, index) {
                  final tx = visible[index];
                  final dateStr = tx.transactionDate != null
                      ? AppHelperFunction.getFormattedDate(tx.transactionDate!, format: 'dd/MM/yyyy')
                      : '';
                  final note = tx.note != null && tx.note!.isNotEmpty
                      ? tx.note!
                      : (tx.category?.name ?? 'Góp quỹ');
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.income.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.savings_rounded,
                            size: 16,
                            color: AppColors.income,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.text1,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (dateStr.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  dateStr,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.text3,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '+${AppHelperFunction.formatAmount(tx.amount.toDouble())}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.income,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (showToggle) ...[
                const Divider(height: 1, indent: 16, endIndent: 16),
                GestureDetector(
                  onTap: () => setState(() => _showAllTransactions = !_showAllTransactions),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _showAllTransactions
                              ? 'Thu gọn'
                              : 'Xem thêm (${transactions.length - maxVisible})',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          _showAllTransactions
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool isCompleted, bool isTargetAchieved) {
    if (isCompleted) {
      return const SizedBox.shrink();
    }

    if (isTargetAchieved) {
      return Center(
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
              if (widget.fund.wallet == null) {
                final controller = Get.find<SavingGoalController>();
                controller.completeGoalEarly(widget.fund.id);
                return;
              }

              Get.toNamed(
                RoutePath.createTransaction,
                arguments: {
                  'type': 'expense',
                  'amount': (widget.report?.walletBalance ?? widget.fund.wallet?.balance ?? 0).toInt(),
                  'walletId': widget.fund.wallet!.id,
                  'note': 'Chi tiêu cho: ${widget.fund.name}',
                  'completeGoalId': widget.fund.id,
                  'isWalletEditable': false,
                },
              );
            },
            backgroundColor: AppColors.income,
            height: 48,
            borderRadius: 12,
            fontSize: 13,
            elevation: 0,
          ),
        ),
      );
    }

    return Center(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.15),
              blurRadius: 12,
            ),
          ],
        ),
        child: PrimaryButton(
          label: 'Góp quỹ',
          onPressed: () {
            Get.toNamed(
              RoutePath.walletTransfer,
              arguments: {
                'toWalletId': widget.fund.wallet?.id,
                'lockToWallet': true,
              },
            );
          },
          backgroundColor: AppColors.primary,
          height: 48,
          borderRadius: 12,
          fontSize: 13,
          elevation: 0,
        ),
      ),
    );
  }
}
