import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/app/widgets/dialog/warning_dialog.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/features/transaction/presentation/widgets/transaction_form.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';

class TransactionDetail extends StatelessWidget {
  final TransactionEntity item;
  final bool isExpense;
  final int userId;

  const TransactionDetail({
    super.key,
    required this.item,
    required this.isExpense,
    required this.userId,
  });

  static Future<void> show(
    BuildContext context, {
    required TransactionEntity item,
    required int userId,
    bool? isExpense,
  }) {
    return showDialog(
      context: context,
      builder: (context) => TransactionDetail(
        item: item,
        isExpense: isExpense ?? (item.type == 'expense' || item.type == 'chi'),
        userId: userId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TransactionController transactionController =
        Get.find<TransactionController>();

    final double screenWidth = MediaQuery.of(context).size.width;
    final Color themeColor = isExpense
        ? const Color(0xFFE53935) // Elegant Red
        : const Color(0xFF43A047); // Elegant Green

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
              color: Colors.black.withOpacity(0.1),
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
                        themeColor.withOpacity(0.15),
                        themeColor.withOpacity(0.05),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Category Icon Badge
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppThemeColors.of(context).cardBackground,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: themeColor.withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          item.category?.icon ?? '💰',
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Amount
                      Text(
                        '${isExpense ? '-' : '+'} ${AppHelperFunction.formatAmount(item.amount.toDouble(), '₫')}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: themeColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isExpense ? 'transaction.expenseType'.tr : 'transaction.incomeType'.tr,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: themeColor.withOpacity(0.7),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),

                // Details Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        icon: Icons.category_outlined,
                        label: 'transaction.categoryLabel'.tr,
                        value: item.category?.name ?? 'transaction.none'.tr,
                      ),
                      const Divider(height: 24),
                      _buildDetailRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'transaction.timeLabel'.tr,
                        value: item.transactionDate != null
                            ? AppHelperFunction.formatDateTime(
                                item.transactionDate!,
                              )
                            : 'transaction.none'.tr,
                      ),
                      const Divider(height: 24),
                      _buildDetailRow(
                        icon: Icons.notes_outlined,
                        label: 'transaction.note'.tr,
                        value: item.note != null && item.note!.isNotEmpty
                            ? item.note!
                            : 'transaction.noNote'.tr,
                        isMultiLine: true,
                      ),

                      // Picture Section
                      if (item.pictureUrl != null &&
                          item.pictureUrl!.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'transaction.evidencePhoto'.tr,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppThemeColors.of(context).textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 250),
                            child: item.pictureUrl!.startsWith('http')
                                ? Image.network(
                                    item.pictureUrl!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  )
                                : Image.file(
                                    File(item.pictureUrl!),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 32),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.edit_outlined,
                              label: 'Sửa',
                              onPressed: () async {
                                Get.back();
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TransactionForm(
                                      title: isExpense
                                          ? 'transaction.editExpense'.tr
                                          : 'transaction.editIncome'.tr,
                                      item: item,
                                      transactionType: isExpense
                                          ? 'expense'
                                          : 'income',
                                      showCategory: true,
                                    ),
                                  ),
                                );
                              },
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.delete_outline_rounded,
                              label: 'Xóa',
                              onPressed: () =>
                                  _handleDelete(context, transactionController),
                              color: const Color(0xFFE53935),
                              isOutlined: true,
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

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
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
            color: AppThemeColors.of(context).surfaceBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: AppColors.text3),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppThemeColors.of(context).textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppThemeColors.of(context).textPrimary,
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

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
    bool isOutlined = false,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20, color: isOutlined ? color : Colors.white),
      label: Text(
        label,
        style: TextStyle(
          color: isOutlined ? color : Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isOutlined ? AppThemeColors.of(context).cardBackground : color,
        foregroundColor: isOutlined ? color : Colors.white,
        elevation: isOutlined ? 0 : 4,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: isOutlined
              ? BorderSide(color: color, width: 1.5)
              : BorderSide.none,
        ),
        shadowColor: color.withOpacity(0.3),
      ),
    );
  }

  void _handleDelete(BuildContext context, TransactionController controller) {
    showDialog(
      context: context,
      builder: (context) => WarningDialog(
        message:
            'transaction.deleteConfirm'.tr,
        onCancel: () => Get.back(),
        onConfirm: () {
          Get.back();
          Get.back();
          controller.deleteTransaction(item.id!, userId);
          AppHelperFunction.showSuccessSnackBar('transaction.deleteSuccess'.tr);
        },
      ),
    );
  }
}
