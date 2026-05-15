import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/sizes.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';
import 'package:money_care/features/home/presentation/widgets/transaction/transaction_item.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';

class TransactionSection extends StatefulWidget {
  const TransactionSection({
    super.key,
    required this.incomeTransactions,
    required this.expenseTransactions,
  });

  final List<TransactionEntity> incomeTransactions;
  final List<TransactionEntity> expenseTransactions;

  @override
  State<TransactionSection> createState() => _TransactionSectionState();
}

class _TransactionSectionState extends State<TransactionSection> {
  bool isExpense = true;

  @override
  Widget build(BuildContext context) {
    final currentList = isExpense
        ? widget.expenseTransactions
        : widget.incomeTransactions;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.spaceBtwItems),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppThemeColors.of(context).surfaceBackground,
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
            ),
            child: Row(
              children: [
                _buildTab('statistics.expense'.tr, isExpense, 'expense'),
                _buildTab('statistics.income'.tr, !isExpense, 'income'),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.defaultSpace),
          if (currentList.isEmpty)
            AppEmptyState(message: 'transaction.noRecent'.tr)
          else
            ...currentList
                .take(5)
                .toList()
                .asMap()
                .entries
                .map(
                  (entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TransactionItem(
                      item: entry.value,
                      onTap: () {},
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Expanded _buildTab(String label, bool isActive, String type) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isExpense = (type == 'expense')),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isActive
                  ? Colors.white
                  : AppThemeColors.of(context).textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
