import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/sizes.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/finance_mode/domain/entities/finance_mode_entity.dart';
import 'package:money_care/features/finance_mode/presentation/controllers/finance_mode_controller.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    super.key,
    required this.item,
    required this.onTap,
    this.isShowDate = true,
    this.isShowDivider = true,
    this.color,
  });

  final TransactionEntity item;
  final bool isShowDate;
  final bool isShowDivider;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final FinanceModeController? financeModeController =
        Get.isRegistered<FinanceModeController>()
            ? Get.find<FinanceModeController>()
            : null;

    Widget content = _buildContent(isSavingMode: false);

    if (financeModeController != null) {
      content = Obx(() {
        final isSaving =
            financeModeController.currentMode.value == FinanceMode.saving;
        return _buildContent(isSavingMode: isSaving);
      });
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: content,
    );
  }

  Widget _buildContent({required bool isSavingMode}) {
    final bool isIncome = item.type == 'income';
    final Color typeColor = isIncome ? AppColors.success : AppColors.error;
    final bool showSkippableLabel =
        isSavingMode && (item.category?.isEssential == false);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(
                  item.category?.icon ?? '💰',
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              const SizedBox(width: AppSizes.spaceBtwItems),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.note ?? "",
                      style: const TextStyle(
                        fontSize: AppSizes.fontSizeSm + 1,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.category?.name ?? 'Không có danh mục',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.text4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (showSkippableLabel) ...[
                      const SizedBox(height: 4),
                      _SkippableLabel(),
                    ],
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isIncome ? '+' : '-'} ${AppHelperFunction.formatAmount(
                      item.amount.toDouble(),
                      '',
                    )} ₫',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: typeColor,
                    ),
                  ),
                  if (isShowDate && item.transactionDate != null)
                    Text(
                      AppHelperFunction.formatDateTime(item.transactionDate!),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.text5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        if (isShowDivider)
          const Divider(
            color: AppColors.borderSecondary,
            height: AppSizes.dividerHeight,
            indent: 56,
          ),
      ],
    );
  }
}

class _SkippableLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.warning, width: 0.8),
      ),
      child: const Text(
        'Có thể bỏ qua',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.warning,
        ),
      ),
    );
  }
}
