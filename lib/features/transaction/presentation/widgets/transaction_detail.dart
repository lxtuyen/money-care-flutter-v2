import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/app/widgets/dialog/warning_dialog.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/home/presentation/widgets/transaction/transaction_item.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/features/transaction/presentation/widgets/transaction_form.dart';

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

  @override
  Widget build(BuildContext context) {
    final TransactionController transactionController =
        Get.find<TransactionController>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isExpense ? 'Chi tiết tiền chi' : 'Chi tiết tiền thu',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (item.pictureUrl != null && item.pictureUrl!.isNotEmpty) ...[
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child:
                        item.pictureUrl!.startsWith('http')
                            ? Image.network(item.pictureUrl!, fit: BoxFit.cover)
                            : Image.file(
                              File(item.pictureUrl!),
                              fit: BoxFit.cover,
                            ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              TransactionItem(
                color: AppHelperFunction.getRandomColor(),
                item: item,
                isShowDate: true,
                isShowDivider: false,
                onTap: () {},
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      Get.back();

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => TransactionForm(
                                title:
                                    isExpense
                                        ? 'Chỉnh sửa chi'
                                        : 'Chỉnh sửa thu',
                                item: item,
                                transactionType: isExpense ? 'expense' : 'income',
                                showCategory: true,
                              ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: AppColors.text3,
                      size: 22,
                    ),
                    label: const Text(
                      'Chỉnh sửa',
                      style: TextStyle(
                        color: AppColors.text3,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(
                          color: AppColors.secondaryNavyBlue,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => WarningDialog(
                              message:
                                  'Bạn có chắc chắn muốn xóa giao dịch này?',
                              onCancel: () => Get.back(),
                              onConfirm: () {
                                Get.back();
                                Get.back();
                                transactionController.deleteTransaction(
                                  item.id!,
                                  userId,
                                );
                                AppHelperFunction.showSuccessSnackBar(
                                  'Xóa giao dịch thành công',
                                );
                              },
                            ),
                      );
                    },
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.text3,
                      size: 22,
                    ),
                    label: const Text(
                      'Xóa',
                      style: TextStyle(
                        color: AppColors.text3,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(
                          color: AppColors.secondaryNavyBlue,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
