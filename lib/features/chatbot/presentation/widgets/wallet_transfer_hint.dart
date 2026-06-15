import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/saving_goal/data/models/goal_achievement_prediction_model.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';

class WalletTransferHint extends StatelessWidget {
  final GoalRecommendedActionModel action;
  final int? goalWalletId;
  final AppThemeColors colors;

  const WalletTransferHint({
    super.key,
    required this.action,
    required this.goalWalletId,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final amount = action.amount ?? 0;
    final fromWalletId = action.walletId;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_rounded,
                color: AppColors.primary,
                size: 16,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Ví có thể bù vào',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            action.message,
            style: TextStyle(
              fontSize: 12.5,
              height: 1.4,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          PrimaryButton(
            label: 'Chuyển ${AppHelperFunction.formatAmount(amount)} vào ví tiết kiệm',
            onPressed: () => _openTransfer(
              fromWalletId: fromWalletId,
              toWalletId: goalWalletId,
              amount: amount,
            ),
            icon: const Icon(Icons.swap_horiz_rounded, size: 16),
            height: 40,
            fontSize: 12.5,
            borderRadius: 10,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
        ],
      ),
    );
  }

  void _openTransfer({
    required int? fromWalletId,
    required int? toWalletId,
    required double amount,
  }) {
    Get.toNamed(
      RoutePath.walletTransfer,
      arguments: {
        'fromWalletId': fromWalletId,
        'toWalletId': toWalletId,
        if (amount > 0) 'amount': amount,
      },
    );
  }
}
