import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/chatbot/presentation/controllers/chat_controller.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class TransactionSavedBubble extends StatelessWidget {
  final Map<String, dynamic> metadata;

  const TransactionSavedBubble({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    final transaction = TransactionEntity.fromMap(metadata);
    final isIncome = transaction.type == 'income';
    final needsClarification = metadata['needsClarification'] == true;
    final suggestions = (metadata['suggestedSubCategories'] as List? ?? [])
        .map((item) => item.toString())
        .where((item) => item.isNotEmpty)
        .toList();

    String formattedDate = AppHelperFunction.getFormattedDate(DateTime.now());
    if (transaction.transactionDate != null) {
      formattedDate = AppHelperFunction.getFormattedDate(
        transaction.transactionDate!,
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
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Get.find<ChatController>().onTransactionTap(metadata),
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isIncome
                        ? const Color(0xFFE8F5E9)
                        : const Color(0xFFFFEBEE),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        needsClarification
                            ? 'Cần xác nhận danh mục'
                            : isIncome
                            ? 'Đã ghi nhận thu nhập'
                            : 'Đã ghi nhận chi tiêu',
                        style: TextStyle(
                          color: isIncome
                              ? AppColors.income
                              : AppColors.expense,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          color:
                              (isIncome ? AppColors.income : AppColors.expense)
                                  .withValues(alpha: 0.6),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color:
                              (isIncome
                                      ? const Color(0xFF43A047)
                                      : const Color(0xFFE53935))
                                  .withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            transaction.category?.icon ?? '💰',
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transaction.category?.name ?? 'Chi tiêu',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            if (transaction.note?.isNotEmpty ?? false) ...[
                              const SizedBox(height: 3),
                              Text(
                                transaction.note!,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            if (transaction.walletName != null) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.account_balance_wallet_outlined,
                                    size: 14,
                                    color: Colors.blue.shade600,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    transaction.walletName!,
                                    style: TextStyle(
                                      color: Colors.blue.shade600,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      Text(
                        '${isIncome ? '+' : '-'} ${AppHelperFunction.formatAmount(transaction.amount.toDouble())}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: isIncome
                              ? AppColors.income
                              : AppColors.expense,
                        ),
                      ),
                    ],
                  ),
                ),
                if (needsClarification && suggestions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: suggestions.map((suggestion) {
                        return ActionChip(
                          label: Text(suggestion),
                          onPressed: () {
                            final controller = Get.find<ChatController>();
                            final userId =
                                controller.appController.userId.value;
                            if (userId == null) return;
                            controller.sendCustomMessage(
                              suggestion,
                              'Ghi giao dịch ${transaction.amount} ${transaction.category?.name ?? ''} $suggestion',
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
        ),
      ),
    );
  }
}
