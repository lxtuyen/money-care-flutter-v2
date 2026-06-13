import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/app/widgets/dialog/app_confirm_dialog.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/features/transaction/presentation/widgets/transaction_form.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/app/widgets/button/app_action_button.dart';

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
    final Color themeColor = isExpense ? AppColors.expense : AppColors.income;

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
                          item.category?.icon ?? '',
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${isExpense ? '-' : '+'} ${AppHelperFunction.formatAmount(item.amount.toDouble())}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: themeColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isExpense
                            ? 'transaction.expenseType'.tr
                            : 'transaction.incomeType'.tr,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: themeColor.withValues(alpha: 0.7),
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
                        label: 'transaction.categoryLabel'.tr,
                        value: item.category?.name ?? 'transaction.none'.tr,
                      ),
                      const Divider(height: 24),
                      _buildDetailRow(
                        context,
                        icon: Icons.account_balance_wallet_outlined,
                        label: 'transaction.walletLabel'.tr,
                        value: item.walletName ?? 'Chưa xác định',
                      ),
                      if (item.coupleId != null && item.payerName != null) ...[
                        const Divider(height: 24),
                        _buildDetailRow(
                          context,
                          icon: Icons.person_outline,
                          label: 'transaction.payerLabel'.tr,
                          value: item.payerId == userId ? 'Bạn' : item.payerName!,
                        ),
                      ],
                      const Divider(height: 24),
                      _buildDetailRow(
                        context,
                        icon: Icons.calendar_today_outlined,
                        label: 'transaction.timeLabel'.tr,
                        value: item.transactionDate != null
                            ? AppHelperFunction.getFormattedDate(
                                item.transactionDate!,
                              )
                            : 'transaction.none'.tr,
                      ),
                      const Divider(height: 24),
                      _buildDetailRow(
                        context,
                        icon: Icons.notes_outlined,
                        label: 'transaction.note'.tr,
                        value: item.note != null && item.note!.isNotEmpty
                            ? item.note!
                            : 'transaction.noNote'.tr,
                        isMultiLine: true,
                      ),

                      if (item.pictureUrl != null &&
                          item.pictureUrl!.isNotEmpty) ...[
                        SizedBox(height: 24),
                        Align(
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
                        SizedBox(height: 12),
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

                      Row(
                        children: [
                          Expanded(
                            child: AppActionButton(
                              icon: Icons.edit_outlined,
                              label: 'common.edit'.tr,
                              onTap: () async {
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
                                    ),
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
                              label: 'common.delete'.tr,
                              onTap: () =>
                                  _handleDelete(context, transactionController),
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

  void _handleDelete(BuildContext context, TransactionController controller) {
    AppConfirmDialog.show(
      message: 'transaction.deleteConfirm'.tr,
      confirmText: 'common.delete'.tr,
      cancelText: 'common.back'.tr,
      onConfirm: () {
        Get.back();
        controller.deleteTransaction(item.id!, userId);
        AppHelperFunction.showSuccessSnackBar('transaction.deleteSuccess'.tr);
      },
    );
  }
}
