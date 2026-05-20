import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/presentation/widgets/transaction_form.dart';

class CreateTransactionScreen extends StatelessWidget {
  const CreateTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final String type = args?['type'] ?? 'expense';
    final TransactionEntity? item = args?['item'];

    return TransactionForm(
      title: item == null
          ? (type == 'expense' ? 'Thêm Tiền Chi' : 'Thêm Tiền Thu')
          : 'Chỉnh sửa giao dịch',
      transactionType: type,
      showCategory: true,
      item: item,
    );
  }
}
