import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/features/transaction/presentation/controllers/recurring_transaction_controller.dart';
import 'package:money_care/features/transaction/data/models/recurring_transaction_model.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';

class RecurringTransactionScreen extends GetView<RecurringTransactionController> {
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
              if (controller.isLoading.value && controller.recurringTransactions.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.recurringTransactions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.autorenew, size: 64, color: AppColors.text3.withOpacity(0.5)),
                      const SizedBox(height: 16),
                      const Text(
                        'Chưa có giao dịch định kỳ nào',
                        style: TextStyle(color: AppColors.text3, fontSize: 16),
                      ),
                    ],
                  ),
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

  Widget _buildRecurringItem(BuildContext context, RecurringTransactionModel item) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'VND');
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: AppThemeColors.of(context).cardBackground,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: (item.type == 'income' ? Colors.green : Colors.red).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            item.type == 'income' ? Icons.add_circle_outline : Icons.remove_circle_outline,
            color: item.type == 'income' ? Colors.green : Colors.red,
          ),
        ),
        title: Text(
          item.note ?? 'Giao dịch định kỳ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_getFrequencyLabel(item.frequency)} • Từ ${dateFormat.format(item.startDate)}',
              style: const TextStyle(fontSize: 12),
            ),
            if (item.category != null)
              Text(
                item.category!.name,
                style: const TextStyle(fontSize: 12, color: AppColors.primary),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              currencyFormat.format(item.amount),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: item.type == 'income' ? Colors.green : Colors.red,
              ),
            ),
            IconButton(
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
              onPressed: () => _confirmDelete(context, item),
            ),
          ],
        ),
      ),
    );
  }

  String _getFrequencyLabel(String freq) {
    switch (freq) {
      case 'daily': return 'Hàng ngày';
      case 'weekly': return 'Hàng tuần';
      case 'monthly': return 'Hàng tháng';
      case 'yearly': return 'Hàng năm';
      default: return freq;
    }
  }

  void _confirmDelete(BuildContext context, RecurringTransactionModel item) {
    Get.dialog(
      AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa giao dịch định kỳ này?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Hủy')),
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
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    final rxType = 'expense'.obs;
    final rxFreq = 'monthly'.obs;
    final rxStartDate = DateTime.now().obs;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppThemeColors.of(context).cardBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Thêm giao dịch định kỳ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Số tiền',
                  prefixIcon: Icon(Icons.money),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Chi'),
                      value: 'expense',
                      groupValue: rxType.value,
                      onChanged: (v) => rxType.value = v!,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Thu'),
                      value: 'income',
                      groupValue: rxType.value,
                      onChanged: (v) => rxType.value = v!,
                    ),
                  ),
                ],
              )),
              const SizedBox(height: 16),
              Obx(() => DropdownButtonFormField<String>(
                initialValue: rxFreq.value,
                decoration: const InputDecoration(
                  labelText: 'Tần suất',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'daily', child: Text('Hàng ngày')),
                  DropdownMenuItem(value: 'weekly', child: Text('Hàng tuần')),
                  DropdownMenuItem(value: 'monthly', child: Text('Hàng tháng')),
                  DropdownMenuItem(value: 'yearly', child: Text('Hàng năm')),
                ],
                onChanged: (v) => rxFreq.value = v!,
              )),
              const SizedBox(height: 16),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú',
                  prefixIcon: Icon(Icons.note),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final userId = Get.find<AppController>().userId.value;
                    if (userId == null) return;
                    
                    final amount = double.tryParse(amountController.text) ?? 0;
                    if (amount <= 0) {
                      Get.snackbar('Lỗi', 'Số tiền phải lớn hơn 0');
                      return;
                    }

                    controller.createRecurringTransaction(
                      CreateRecurringTransactionDto(
                        amount: amount,
                        type: rxType.value,
                        frequency: rxFreq.value,
                        startDate: rxStartDate.value,
                        note: noteController.text,
                        userId: userId,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Lưu', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
