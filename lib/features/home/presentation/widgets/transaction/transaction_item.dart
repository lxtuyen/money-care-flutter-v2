import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/sizes.dart';
import 'package:money_care/core/utils/Helper/helper_functions.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    super.key,
    required this.item,
    required this.onTap,
    this.isShowDate = true,
    this.isShowDivider = true, this.color,
  });

  final TransactionEntity item;
  final bool isShowDate;
  final bool isShowDivider;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
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
                      item.category?.name ?? 'KhÃ´ng cÃ³ danh má»¥c',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.text4,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (isShowDate)
                    Text(
                      AppHelperFunction.formatDateTime(item.transactionDate!),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.text4,
                      ),
                    ),
                  Text(
                    AppHelperFunction.formatAmount(item.amount.toDouble(), 'VND'),
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
      ),
    );
  }
}