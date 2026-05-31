import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class ChatTransactionRow extends StatelessWidget {
  final TransactionEntity transaction;
  final bool isIncome;
  final bool showWalletName;
  final bool showDate;
  final String? formattedDate;
  final double iconSize;
  final double iconContainerSize;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const ChatTransactionRow({
    super.key,
    required this.transaction,
    required this.isIncome,
    this.showWalletName = false,
    this.showDate = false,
    this.formattedDate,
    this.iconSize = 18,
    this.iconContainerSize = 40,
    this.fontSize = 13,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: Row(
            children: [
              // Icon Container
              Container(
                width: iconContainerSize,
                height: iconContainerSize,
                decoration: BoxDecoration(
                  color: (isIncome ? AppColors.income : AppColors.expense)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    transaction.category?.icon ?? '💰',
                    style: TextStyle(fontSize: iconSize),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Info Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.category?.name ?? 'Chưa phân loại',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: fontSize,
                      ),
                    ),
                    if (transaction.note?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 3),
                      Text(
                        transaction.note!,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: fontSize - 1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (showWalletName && transaction.walletName != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            size: fontSize + 1,
                            color: Colors.blue.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            transaction.walletName!,
                            style: TextStyle(
                              color: Colors.blue.shade600,
                              fontSize: fontSize - 1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Amount + Optional Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${isIncome ? '+' : '-'}${AppHelperFunction.formatAmount(transaction.amount.toDouble())}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                      color: isIncome ? AppColors.income : AppColors.expense,
                    ),
                  ),
                  if (showDate && formattedDate != null && formattedDate!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      formattedDate!,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: fontSize - 2,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
