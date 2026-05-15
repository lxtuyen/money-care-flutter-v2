import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/chatbot/presentation/controllers/chat_controller.dart';
import 'package:money_care/features/recommendation/presentation/services/checkin_prompt_service.dart';
import 'package:money_care/features/recommendation/presentation/utils/place_query_utils.dart';
import 'package:money_care/features/recommendation/presentation/widgets/place_checkin_sheet.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class TransactionSavedBubble extends StatelessWidget {
  final Map<String, dynamic> metadata;
  static final Set<int> _promptedTransactionIds = <int>{};

  const TransactionSavedBubble({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    final transaction = TransactionEntity.fromMap(metadata);
    final isIncome = transaction.type == 'income';
    if (!isIncome &&
        transaction.id != null &&
        _promptedTransactionIds.add(transaction.id!)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!Get.isRegistered<CheckinPromptService>()) return;
        Get.find<CheckinPromptService>().promptForExpense(transaction);
      });
    }

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
                        isIncome
                            ? 'Da ghi nhan thu nhap'
                            : 'Da ghi nhan chi tieu',
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                                transaction.category?.icon ?? r'$',
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
                                  transaction.category?.name ?? 'Chi tieu',
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
                      if (!isIncome && transaction.id != null) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => PlaceCheckinSheet.show(
                              transactionId: transaction.id!,
                              initialQuery: queryFromCategory(
                                transaction.category?.name,
                              ),
                            ),
                            icon: const Icon(Icons.place_outlined, size: 18),
                            label: const Text('Check-in dia diem'),
                          ),
                        ),
                      ],
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
}
