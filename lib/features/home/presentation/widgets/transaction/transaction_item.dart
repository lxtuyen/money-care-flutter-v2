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
    // Safely try to find FinanceModeController — it may not be registered in all contexts.
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

    return GestureDetector(onTap: onTap, child: content);
  }

  Widget _buildContent({required bool isSavingMode}) {
    // Show "Có thể bỏ qua" label when SAVING mode is active and category is non-essential.
    // Requirement 5.7: highlight Non_Essential_Category transactions with "Có thể bỏ qua".
    final bool showSkippableLabel =
        isSavingMode && (item.category?.isEssential == false);

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
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
                      fontSize: AppSizes.fontSizeSm,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    item.category?.name ?? 'Không có danh mục',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.text4,
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
                if (isShowDate)
                  Text(
                    AppHelperFunction.formatDateTime(item.transactionDate!),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.text4,
                    ),
                  ),
                Text(
                  AppHelperFunction.formatAmount(
                    item.amount.toDouble(),
                    'VND',
                  ),
                  style: const TextStyle(
                    fontSize: AppSizes.fontSizeMd,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 8),

        if (isShowDivider)
          const Divider(
            color: AppColors.borderSecondary,
            height: AppSizes.dividerHeight,
          ),
      ],
    );
  }
}

/// Small badge label shown on non-essential transactions in SAVING mode.
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
