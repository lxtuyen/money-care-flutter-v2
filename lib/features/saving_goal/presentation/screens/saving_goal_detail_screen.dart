import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/saving_goal/domain/entities/saving_goal_entity.dart';
import 'package:money_care/features/home/presentation/widgets/transaction/transaction_item.dart';
import 'package:money_care/app/widgets/button/app_action_button.dart';
import 'package:money_care/app/widgets/dialog/app_confirm_dialog.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';
import 'package:money_care/features/saving_goal/data/models/models.dart';
import 'package:money_care/features/scenario_planning/presentation/widgets/scenario_entry_panel.dart';

class SavingGoalDetailScreen extends StatefulWidget {
  const SavingGoalDetailScreen({super.key});

  @override
  State<SavingGoalDetailScreen> createState() => _SavingGoalDetailScreenState();
}

class _SavingGoalDetailScreenState extends State<SavingGoalDetailScreen> {
  final savingGoalController = Get.find<SavingGoalController>();
  final transactionController = Get.find<TransactionController>();

  late SavingGoalEntity goal;
  @override
  void initState() {
    super.initState();
    goal = Get.arguments as SavingGoalEntity;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      savingGoalController.loadGoalReport(goal.id);
      savingGoalController.loadGoalPrediction(goal.id);
    });
  }

  void _confirmDelete() {
    AppConfirmDialog.show(
      title: "Xóa mục tiêu?",
      message:
          "Bạn có chắc chắn muốn xóa mục tiêu \"${goal.name}\"? Dữ liệu này sẽ không thể khôi phục.",
      confirmText: "Xóa",
      cancelText: "Hủy",
      onConfirm: () async {
        final success = await savingGoalController.deleteGoal(goal.id);
        if (success) {
          Get.back();
        }
      },
    );
  }

  void _showEditDialog() {
    Get.toNamed(RoutePath.createSavingGoal, arguments: goal);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return Scaffold(
      backgroundColor: colors.surfaceBackground,
      body: Column(
        children: [
          AppHeader(
            title: goal.name,
            showBackButton: true,
            height: 220,
            child: Obx(() {
              final report = savingGoalController.goalReport.value;
              final percent =
                  report?.progressPercent.toDouble() ?? goal.progressPercent;
              final displayAmount = report?.currentBalance ?? goal.savedAmount;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: percent / 100,
                          strokeWidth: 8,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Text(
                        "${percent.toInt()}%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Đã tiết kiệm: ${AppHelperFunction.formatAmount(displayAmount)}",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: AppActionButton(
                    onTap: _showEditDialog,
                    icon: Icons.edit_outlined,
                    label: "Chỉnh sửa",
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppActionButton(
                    onTap: _confirmDelete,
                    icon: Icons.delete_outline_rounded,
                    label: "Xóa mục tiêu",
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: ScenarioEntryPanel(goalId: goal.id),
          ),
          Obx(() => _buildPredictionCard(colors)),
          Expanded(
            child: Obx(() {
              if (savingGoalController.isLoadingReport.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final report = savingGoalController.goalReport.value;
              final transactions =
                  report?.transactions.map((m) => m.toEntity()).toList() ?? [];

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                      child: Text(
                        "Chi tiết tài chính",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: _buildDetailCard(colors)),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                      child: Text(
                        "Giao dịch liên quan",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                  ),

                  if (transactions.isEmpty)
                    const SliverFillRemaining(
                      child: AppEmptyState(
                        message: "Chưa có giao dịch nào cho mục tiêu này",
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final tx = transactions[index];
                          return TransactionItem(item: tx, onTap: () {});
                        }, childCount: transactions.length),
                      ),
                    ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(AppThemeColors colors) {
    final report = savingGoalController.goalReport.value;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow(
            "Mục tiêu",
            AppHelperFunction.formatAmount(report?.target ?? goal.target ?? 0),
            Icons.flag_rounded,
            AppColors.primary,
            colors,
          ),
          const Divider(height: 32),
          _buildDetailRow(
            "Ngày bắt đầu",
            (report?.startDate ?? goal.startDate) != null
                ? DateFormat(
                    'dd/MM/yyyy',
                  ).format(report?.startDate ?? goal.startDate!)
                : "Chưa đặt",
            Icons.calendar_today_rounded,
            Colors.blue,
            colors,
          ),
          const Divider(height: 32),
          _buildDetailRow(
            "Ngày kết thúc",
            (report?.endDate ?? goal.endDate) != null
                ? DateFormat(
                    'dd/MM/yyyy',
                  ).format(report?.endDate ?? goal.endDate!)
                : "Chưa đặt",
            Icons.event_rounded,
            Colors.blue,
            colors,
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionCard(AppThemeColors colors) {
    if (savingGoalController.isLoadingPrediction.value &&
        savingGoalController.goalPrediction.value == null) {
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text(
              'Đang tải dự báo mục tiêu...',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    final prediction = savingGoalController.goalPrediction.value;
    if (prediction == null) {
      return const SizedBox.shrink();
    }

    final statusColor = _predictionRiskColor(prediction.riskLevel);
    final completionText = prediction.predictedCompletionDate != null
        ? _formatIsoDate(prediction.predictedCompletionDate!)
        : 'Chưa đủ dữ liệu';
    final differenceText = _predictionDifferenceText(prediction);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _predictionStatusIcon(prediction.status),
                color: statusColor,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Dự báo mục tiêu',
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _riskText(prediction.riskLevel),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _predictionMetric(
            label: 'Dự kiến hoàn thành',
            value: completionText,
            colors: colors,
          ),
          _predictionMetric(
            label: 'Lệch hạn',
            value: differenceText,
            colors: colors,
            valueColor: statusColor,
          ),
          _predictionMetric(
            label: 'Cần tiết kiệm mỗi ngày',
            value: AppHelperFunction.formatAmount(
              prediction.requiredDailySavingRate,
            ),
            colors: colors,
          ),
          _predictionMetric(
            label: 'Tốc độ hiện tại mỗi tháng',
            value: AppHelperFunction.formatAmount(
              prediction.currentMonthlySavingRate,
            ),
            colors: colors,
          ),
          if (prediction.recommendedActions.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...prediction.recommendedActions
                .take(2)
                .map(
                  (action) => Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          color: statusColor,
                          size: 15,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            action.message,
                            style: TextStyle(
                              color: colors.textSecondary,
                              fontSize: 11,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ],
      ),
    );
  }

  Widget _predictionMetric({
    required String label,
    required String value,
    required AppThemeColors colors,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: colors.textSecondary, fontSize: 12),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: valueColor ?? colors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon,
    Color iconColor,
    AppThemeColors colors, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Text(
          label,
          style: TextStyle(color: colors.textSecondary, fontSize: 14),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? colors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

Color _predictionRiskColor(String riskLevel) {
  return switch (riskLevel) {
    'high' => AppColors.error,
    'medium' => AppColors.warning,
    _ => AppColors.success,
  };
}

IconData _predictionStatusIcon(String status) {
  return switch (status) {
    'completed' || 'on_track' => Icons.check_circle_outline_rounded,
    'slightly_at_risk' || 'at_risk' => Icons.warning_amber_rounded,
    'off_track' || 'overdue' || 'unlikely' => Icons.error_outline_rounded,
    _ => Icons.timeline_rounded,
  };
}

String _riskText(String riskLevel) {
  return switch (riskLevel) {
    'high' => 'Rủi ro cao',
    'medium' => 'Rủi ro TB',
    _ => 'Rủi ro thấp',
  };
}

String _predictionDifferenceText(GoalAchievementPredictionModel prediction) {
  final days = prediction.daysDifference;
  if (prediction.status == 'completed') return 'Đã hoàn thành';
  if (prediction.status == 'unlikely') return 'Chưa thể dự báo';
  if (days == null) return 'Không có hạn';
  if (days < 0) return 'Sớm ${days.abs()} ngày';
  if (days == 0) return 'Đúng hạn';
  return 'Trễ $days ngày';
}

String _formatIsoDate(String value) {
  final parsed = DateTime.tryParse(value);
  if (parsed == null) return value;
  return DateFormat('dd/MM/yyyy').format(parsed);
}
