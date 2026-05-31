import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/chatbot/domain/entities/entities.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';
import 'package:money_care/features/chatbot/presentation/controllers/chat_controller.dart';
import 'package:money_care/features/transaction/presentation/widgets/transaction_detail.dart';
import 'package:money_care/features/chatbot/presentation/widgets/chat_transaction_row.dart';

class TransactionListBubble extends StatelessWidget {
  final Map<String, dynamic> metadata;

  const TransactionListBubble({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    final model = ChatTransactionListEntity.fromMap(metadata);

    String periodLabel = _buildPeriodLabel(model.startDate, model.endDate);
    String typeLabel = _buildTypeLabel(model.type);

    final bool isIncomeList = model.type == 'income';
    final bool isExpenseList = model.type == 'expense';

    final Color headerBgColor;
    final Color headerTextColor;
    if (isIncomeList) {
      headerBgColor = AppColors.income.withValues(alpha: 0.08);
      headerTextColor = AppColors.income;
    } else if (isExpenseList) {
      headerBgColor = AppColors.expense.withValues(alpha: 0.08);
      headerTextColor = AppColors.expense;
    } else {
      headerBgColor = AppColors.primary.withValues(alpha: 0.08);
      headerTextColor = AppColors.primary;
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.88,
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
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: headerBgColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.receipt_long_rounded,
                    color: headerTextColor,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$typeLabel${periodLabel.isNotEmpty ? ' · $periodLabel' : ''}',
                      style: TextStyle(
                        color: headerTextColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: headerTextColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${model.total} giao dịch',
                      style: TextStyle(
                        color: headerTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (model.transactions.isEmpty)
              AppEmptyState(
                message: 'Không có giao dịch nào trong khoảng thời gian này.',
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: model.transactions.length,
                separatorBuilder: (_, _) => Divider(
                  height: 1,
                  color: Colors.grey.shade100,
                  indent: 16,
                  endIndent: 16,
                ),
                itemBuilder: (context, index) {
                  final transaction = model.transactions[index];
                  final bool isIncome = transaction.type == 'income';

                  String formattedDate = '';
                  if (transaction.transactionDate != null) {
                    formattedDate = AppHelperFunction.formatDayMonth(
                      transaction.transactionDate!.toLocal(),
                    );
                  }

                  return ChatTransactionRow(
                    transaction: transaction,
                    isIncome: isIncome,
                    showDate: true,
                    formattedDate: formattedDate,
                    onTap: () {
                      if (transaction.id != null) {
                        final chatController = Get.find<ChatController>();
                        final userId = chatController.appController.userId.value ?? 0;
                        TransactionDetail.show(
                          context,
                          item: transaction,
                          userId: userId,
                          isExpense: !isIncome,
                        );
                      }
                    },
                  );
                },
              ),

            if (model.transactions.isNotEmpty) _buildSummaryFooter(model.transactions),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryFooter(List<TransactionEntity> transactions) {
    double totalIncome = 0;
    double totalExpense = 0;
    for (final t in transactions) {
      final amount = t.amount.toDouble();
      if (t.type == 'income') {
        totalIncome += amount;
      } else {
        totalExpense += amount;
      }
    }

    final hasIncome = totalIncome > 0;
    final hasExpense = totalExpense > 0;
    if (!hasIncome && !hasExpense) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (hasIncome)
            Flexible(
              child: _SummaryChip(
                label: 'Thu',
                amount: AppHelperFunction.formatAmount(totalIncome),
                color: AppColors.income,
                icon: Icons.arrow_downward_rounded,
              ),
            ),
          if (hasIncome && hasExpense)
            Container(
              width: 1,
              height: 24,
              color: Colors.grey.shade200,
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
          if (hasExpense)
            Flexible(
              child: _SummaryChip(
                label: 'Chi',
                amount: AppHelperFunction.formatAmount(totalExpense),
                color: AppColors.expense,
                icon: Icons.arrow_upward_rounded,
              ),
            ),
        ],
      ),
    );
  }

  String _buildPeriodLabel(String? startDate, String? endDate) {
    if (startDate == null && endDate == null) return '';
    try {
      final start = startDate != null ? DateTime.parse(startDate) : null;
      final end = endDate != null ? DateTime.parse(endDate) : null;
      if (start != null && end != null) {
        final startStr = AppHelperFunction.formatDayMonth(start.toLocal());
        final endStr = AppHelperFunction.formatDayMonth(end.toLocal());
        if (startStr == endStr) return startStr;
        return '$startStr - $endStr';
      }
      if (start != null) {
        return 'từ ${AppHelperFunction.formatDayMonth(start.toLocal())}';
      }
      if (end != null) {
        return 'đến ${AppHelperFunction.formatDayMonth(end.toLocal())}';
      }
    } catch (_) {}
    return '';
  }

  String _buildTypeLabel(String type) {
    switch (type) {
      case 'income':
        return 'Lịch sử thu nhập';
      case 'expense':
        return 'Lịch sử chi tiêu';
      default:
        return 'Lịch sử giao dịch';
    }
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;
  final IconData icon;

  const _SummaryChip({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            '$label: $amount',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
