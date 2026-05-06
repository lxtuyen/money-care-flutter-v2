import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/home/presentation/widgets/transaction/transaction_item.dart';
import 'package:money_care/features/transaction/data/models/recurring_transaction_model.dart';
import 'package:money_care/features/transaction/domain/entities/category_entity.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/recurring_transaction_controller.dart';
import 'package:money_care/features/transaction/presentation/widgets/transaction_form.dart';
import 'package:money_care/features/transaction/presentation/screens/create_transaction_screen.dart';
import 'package:money_care/features/transaction/presentation/bindings/transaction_binding.dart';

class RecurringTransactionScreen
    extends GetView<RecurringTransactionController> {
  const RecurringTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          AppHeader(
            title: 'Giao dịch định kỳ',
            showBackButton: true,
            height: 120,
            actions: [
              IconButton(
                onPressed: () => _showAddRecurringDialog(context),
                icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              ),
            ],
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.recurringTransactions.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.recurringTransactions.isEmpty) {
                return const AppEmptyState(
                  message: 'Chưa có giao dịch định kỳ nào',
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.recurringTransactions.length,
                itemBuilder: (context, index) {
                  final item = controller.recurringTransactions[index];
                  return _buildRecurringItem(context, item);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRecurringItem(
    BuildContext context,
    RecurringTransactionModel item,
  ) {
    final formattedDate = AppHelperFunction.getFormattedDate(item.startDate);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: AppThemeColors.of(context).cardBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: TransactionItem(
          item: _toTransactionEntity(item),
          onTap: () {},
          isShowDate: false,
          isShowDivider: true,
          title: item.note ?? 'Giao dịch định kỳ',
          subtitle: item.category?.name ?? 'Không có danh mục',
          detail: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _getFrequencyLabel(item.frequency),
                style: const TextStyle(fontSize: 12, color: AppColors.primary),
              ),
              Text(
                'Từ $formattedDate',
                style: const TextStyle(fontSize: 12, color: AppColors.primary),
              ),
            ],
          ),
          trailingInlineAction: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _confirmDelete(context, item),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.delete_outline, size: 20, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  TransactionEntity _toTransactionEntity(RecurringTransactionModel item) {
    return TransactionEntity(
      id: item.id,
      amount: item.amount.round(),
      type: item.type,
      note: item.note,
      transactionDate: item.startDate,
      category: item.category == null
          ? null
          : CategoryEntity(
              id: item.category!.id,
              name: item.category!.name,
              icon: item.category!.icon,
              color: item.category!.color,
              isEssential: item.category!.isEssential,
              type: item.category!.type,
            ),
    );
  }

  String _getFrequencyLabel(String freq) {
    switch (freq) {
      case 'daily':
        return 'Hàng ngày';
      case 'weekly':
        return 'Hàng tuần';
      case 'monthly':
        return 'Hàng tháng';
      case 'yearly':
        return 'Hàng năm';
      default:
        return freq;
    }
  }

  void _confirmDelete(BuildContext context, RecurringTransactionModel item) {
    Get.dialog(
      AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text(
          'Bạn có chắc chắn muốn xóa giao dịch định kỳ này?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteRecurringTransaction(item.id);
              Get.back();
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddRecurringDialog(BuildContext context) {
    Get.to(
      () => CreateTransactionScreen(),
      arguments: {
        'type': 'expense',
        'isRecurring': true,
        'onRecurringSubmit': (dto) {
          controller.createRecurringTransaction(dto);
        },
      },
      binding: TransactionBinding(),
    );
  }
}
