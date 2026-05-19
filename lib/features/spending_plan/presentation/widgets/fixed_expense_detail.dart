import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/dialog/app_confirm_dialog.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
import 'package:money_care/features/spending_plan/presentation/controllers/spending_plan_controller.dart';
import 'package:money_care/features/spending_plan/presentation/widgets/fixed_expense_edit_sheet.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';
import 'package:money_care/app/widgets/button/app_action_button.dart';

class FixedExpenseDetail extends StatelessWidget {
  final SpendingPlanEntity plan;
  final FixedExpenseEntity expense;

  const FixedExpenseDetail({
    super.key,
    required this.plan,
    required this.expense,
  });

  static Future<void> show(
    BuildContext context, {
    required SpendingPlanEntity plan,
    required FixedExpenseEntity expense,
  }) {
    return showDialog(
      context: context,
      builder: (context) => FixedExpenseDetail(plan: plan, expense: expense),
    );
  }

  @override
  Widget build(BuildContext context) {
    final SpendingPlanController controller =
        Get.find<SpendingPlanController>();
    final double screenWidth = MediaQuery.of(context).size.width;
    const Color themeColor = AppColors.expense;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: screenWidth,
        decoration: BoxDecoration(
          color: AppThemeColors.of(context).cardBackground,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        themeColor.withValues(alpha: 0.15),
                        themeColor.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Icon Badge
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppThemeColors.of(context).cardBackground,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: themeColor.withValues(alpha: 0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          _getCategoryIcon(),
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Amount
                      Text(
                        '- ${AppHelperFunction.formatAmount(expense.amount)}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: themeColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'CHI PHÍ CỐ ĐỊNH',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: themeColor,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        context,
                        icon: Icons.category_outlined,
                        label: 'Danh mục',
                        value: expense.category ?? 'Chưa phân loại',
                      ),
                      const Divider(height: 24),
                      _buildDetailRow(
                        context,
                        icon: Icons.repeat_rounded,
                        label: 'Tần suất',
                        value: _getFrequencyText(expense),
                      ),
                      if (expense.dueDay != null) ...[
                        const Divider(height: 24),
                        _buildDetailRow(
                          context,
                          icon: Icons.calendar_today_outlined,
                          label: 'Ngày thanh toán',
                          value: _getDueDayText(expense),
                        ),
                      ],
                      const Divider(height: 24),
                      _buildDetailRow(
                        context,
                        icon: Icons.check_circle_outline,
                        label: 'Trạng thái',
                        value: expense.isPaid
                            ? 'Đã thanh toán'
                            : 'Chưa thanh toán',
                        valueColor: expense.isPaid ? Colors.green : Colors.grey,
                      ),
                      const SizedBox(height: 32),

                      Row(
                        children: [
                          Expanded(
                            child: AppActionButton(
                              icon: Icons.edit_outlined,
                              label: 'Sửa',
                              onTap: () async {
                                Get.back();
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => FixedExpenseEditSheet(
                                    plan: plan,
                                    expense: expense,
                                  ),
                                );
                              },
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppActionButton(
                              icon: Icons.delete_outline_rounded,
                              label: 'Xóa',
                              onTap: () => _handleDelete(context, controller),
                              color: AppColors.expense,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool isMultiLine = false,
  }) {
    return Row(
      crossAxisAlignment: isMultiLine
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppThemeColors.of(context).textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  color: valueColor ?? AppThemeColors.of(context).textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: isMultiLine ? 3 : 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleDelete(BuildContext context, SpendingPlanController controller) {
    AppConfirmDialog.show(
      message: 'Bạn có chắc chắn muốn xóa chi phí "${expense.name}" không?',
      confirmText: 'Xóa',
      cancelText: 'Quay lại',
      onConfirm: () async {
        Get.back();
        await controller.deleteFixedExpense(plan.id, expense.id);
      },
    );
  }

  String _getFrequencyText(FixedExpenseEntity expense) {
    if (expense.frequencyType == 'once') return 'Một lần';
    final String unit = _getFrequencyLabel(expense.frequencyType);
    return '${expense.frequencyValue} lần / $unit';
  }

  String _getFrequencyLabel(String type) {
    switch (type) {
      case 'daily':
        return 'ngày';
      case 'weekly':
        return 'tuần';
      case 'monthly':
        return 'tháng';
      default:
        return '';
    }
  }

  String _getDueDayText(FixedExpenseEntity expense) {
    if (expense.dueDay == null) return '';
    if (expense.frequencyType == 'weekly') {
      return 'Thứ ${_translateWeekday(expense.dueDay)}';
    }
    return 'Ngày ${expense.dueDay}';
  }

  String _translateWeekday(int? day) {
    if (day == null) return '';
    if (day == 7) return 'Chủ Nhật';
    return (day + 1).toString();
  }

  String _getCategoryIcon() {
    final catController = Get.find<UserCategoryController>();
    final catName = expense.category ?? expense.name;
    final cat = catController.categories.firstWhereOrNull(
      (c) => c.name.toLowerCase() == catName.toLowerCase(),
    );
    return cat?.icon ?? '📁';
  }
}
