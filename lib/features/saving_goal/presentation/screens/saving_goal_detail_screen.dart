import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/saving_goal/domain/entities/saving_goal_entity.dart';
import 'package:money_care/features/home/presentation/widgets/transaction/transaction_item.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
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
  final RxList<TransactionEntity> goalTransactions = <TransactionEntity>[].obs;
  final RxBool isLoadingTransactions = false.obs;

  @override
  void initState() {
    super.initState();
    goal = Get.arguments as SavingGoalEntity;
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    isLoadingTransactions.value = true;
    try {
      final allTransactions = transactionController.allTransactions;
      final categoryIds = goal.categories.map((c) => c.id).toSet();
      
      final filtered = allTransactions.where((tx) {
        return categoryIds.contains(tx.category?.id);
      }).toList();
      
      goalTransactions.assignAll(filtered);
    } finally {
      isLoadingTransactions.value = false;
    }
  }

  void _confirmDelete() {
    AppConfirmDialog.show(
      title: "Xóa mục tiêu?",
      message: "Bạn có chắc chắn muốn xóa mục tiêu \"${goal.name}\"? Dữ liệu này sẽ không thể khôi phục.",
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
    final percent = goal.progressPercent;
    
    return Scaffold(
      backgroundColor: colors.surfaceBackground,
      body: Column(
        children: [
          AppHeader(
            title: goal.name,
            showBackButton: true,
            height: 220,
            child: Column(
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
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
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
                  "Đã tiết kiệm: ${AppHelperFunction.formatAmount(goal.savedAmount)}",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    onTap: _showEditDialog,
                    icon: Icons.edit_outlined,
                    label: "Chỉnh sửa",
                    color: AppColors.primary,
                    context: context,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionButton(
                    onTap: _confirmDelete,
                    icon: Icons.delete_outline_rounded,
                    label: "Xóa mục tiêu",
                    color: Colors.redAccent,
                    context: context,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Obx(() {
              if (isLoadingTransactions.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
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
                  _buildDetailCard(colors),
                  
                  Padding(
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
                  
                  Expanded(
                    child: goalTransactions.isEmpty
                        ? const AppEmptyState(
                            message: "Chưa có giao dịch nào cho mục tiêu này",
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                            itemCount: goalTransactions.length,
                            itemBuilder: (context, index) {
                              final tx = goalTransactions[index];
                              return TransactionItem(
                                item: tx,
                                onTap: () {},
                              );
                            },
                          ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(AppThemeColors colors) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow(
            "Mục tiêu", 
            AppHelperFunction.formatAmount(goal.target ?? 0),
            Icons.flag_rounded,
            AppColors.primary,
            colors,
          ),
          const Divider(height: 32),
          _buildDetailRow(
            "Còn lại", 
            AppHelperFunction.formatAmount((goal.target ?? 0) - goal.savedAmount),
            Icons.account_balance_wallet_rounded,
            Colors.orange,
            colors,
          ),
          const Divider(height: 32),
          _buildDetailRow(
            "Ngày kết thúc", 
            goal.endDate != null ? DateFormat('dd/MM/yyyy').format(goal.endDate!) : "Chưa đặt",
            Icons.calendar_today_rounded,
            Colors.blue,
            colors,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon, Color iconColor, AppThemeColors colors) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Text(
          label,
          style: TextStyle(
            color: colors.textSecondary,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;
  final Color color;
  final BuildContext context;

  const _ActionButton({
    required this.onTap,
    required this.icon,
    required this.label,
    required this.color,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    
    return Material(
      color: colors.cardBackground,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
