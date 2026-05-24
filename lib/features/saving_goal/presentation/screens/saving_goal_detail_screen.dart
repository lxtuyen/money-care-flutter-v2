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
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final tx = transactions[index];
                            return TransactionItem(item: tx, onTap: () {});
                          },
                          childCount: transactions.length,
                        ),
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
