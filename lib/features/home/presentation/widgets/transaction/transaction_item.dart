import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/sizes.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    super.key,
    required this.item,
    required this.onTap,
    this.isShowDate = true,
    this.isShowDivider = true,
    this.color,
    this.title,
    this.subtitle,
    this.detail,
    this.trailingSubtitle,
    this.trailingAction,
    this.trailingInlineAction,
    this.showAmountSign = true,
  });

  final TransactionEntity item;
  final bool isShowDate;
  final bool isShowDivider;
  final VoidCallback onTap;
  final Color? color;
  final String? title;
  final String? subtitle;
  final Widget? detail;
  final String? trailingSubtitle;
  final Widget? trailingAction;
  final Widget? trailingInlineAction;
  final bool showAmountSign;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final bool isIncome = item.type == 'income' || item.type == 'thu';
    final Color typeColor =
        color ?? (isIncome ? AppColors.income : AppColors.expense);

    final double amountValue = (item.amount).toDouble();
    final String amountText =
        '${showAmountSign ? (isIncome ? '+' : '-') : ''} ${AppHelperFunction.formatAmount(amountValue, currency: '')} ₫';

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
                  color: typeColor.withValues(alpha: 0.1),
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
                      title ?? item.note ?? '',
                      style: TextStyle(
                        fontSize: AppSizes.fontSizeSm + 1,
                        fontWeight: FontWeight.w600,
                        color: AppThemeColors.of(context).textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle ?? item.category?.name ?? 'Không có danh mục',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppThemeColors.of(context).textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (detail != null) ...[const SizedBox(height: 4), detail!],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        amountText,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: typeColor,
                        ),
                      ),
                      if (trailingInlineAction != null) ...[
                        const SizedBox(width: 8),
                        trailingInlineAction!,
                      ],
                    ],
                  ),
                  if (trailingSubtitle != null)
                    Text(
                      trailingSubtitle!,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppThemeColors.of(context).textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (isShowDate && item.transactionDate != null)
                    Text(
                      AppHelperFunction.getFormattedDate(item.transactionDate!),
                      style: TextStyle(
                        fontSize: 11,
                        color: AppThemeColors.of(context).textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (trailingAction != null) ...[
                    const SizedBox(height: 6),
                    trailingAction!,
                  ],
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
