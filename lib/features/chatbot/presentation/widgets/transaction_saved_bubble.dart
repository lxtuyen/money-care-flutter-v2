import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/chatbot/presentation/controllers/chat_controller.dart';
import 'package:money_care/features/chatbot/domain/entities/entities.dart';
import 'package:money_care/features/transaction/presentation/widgets/transaction_detail.dart';
import 'package:money_care/features/chatbot/presentation/widgets/chat_transaction_row.dart';

class TransactionSavedBubble extends StatelessWidget {
  final Map<String, dynamic> metadata;

  const TransactionSavedBubble({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    final model = ChatTransactionSavedEntity.fromMap(metadata);

    if (model.isDeleted) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Text(
            'Giao dịch này đã bị xóa.',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    String formattedDate = AppHelperFunction.getFormattedDate(DateTime.now());
    if (model.transaction.transactionDate != null) {
      formattedDate = AppHelperFunction.getFormattedDate(
        model.transaction.transactionDate!,
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: model.isIncome
                    ? AppColors.income.withValues(alpha: 0.08)
                    : AppColors.expense.withValues(alpha: 0.08),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    model.needsClarification
                        ? 'Cần xác nhận danh mục'
                        : model.isIncome
                            ? 'Đã ghi nhận thu nhập'
                            : 'Đã ghi nhận chi tiêu',
                    style: TextStyle(
                      color: model.isIncome ? AppColors.income : AppColors.expense,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      color: (model.isIncome ? AppColors.income : AppColors.expense)
                          .withValues(alpha: 0.6),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            ChatTransactionRow(
              transaction: model.transaction,
              isIncome: model.isIncome,
              showWalletName: true,
              iconSize: 24,
              iconContainerSize: 52,
              fontSize: 15,
              padding: const EdgeInsets.all(16),
              onTap: () {
                if (model.transaction.id != null) {
                  final chatController = Get.find<ChatController>();
                  final userId = chatController.appController.userId.value ?? 0;
                  TransactionDetail.show(
                    context,
                    item: model.transaction,
                    userId: userId,
                    isExpense: !model.isIncome,
                  );
                }
              },
            ),
            if (model.needsClarification && model.suggestions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: model.suggestions.map((suggestion) {
                    return ActionChip(
                      label: Text(suggestion),
                      onPressed: () {
                        final chatController = Get.find<ChatController>();
                        final userId = chatController.appController.userId.value;
                        if (userId == null) return;
                        chatController.sendCustomMessage(
                          suggestion,
                          'Ghi giao dịch ${model.transaction.amount} ${model.transaction.category?.name ?? ''} $suggestion',
                          userId,
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
