import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/icon_string.dart';
import 'package:money_care/core/constants/sizes.dart';

class TransactionEmptyState extends StatelessWidget {
  const TransactionEmptyState({
    super.key,
    this.message = 'Không có giao dịch nào gần đây.',
    this.action,
  });

  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(AppIcons.emptyFolder, width: 150, height: 150),
          const SizedBox(height: AppSizes.spaceBtwItems),
          Text(
            message,
            style: const TextStyle(fontSize: 16, color: AppColors.text5),
            textAlign: TextAlign.center,
          ),
          if (action != null) ...[
            const SizedBox(height: 8),
            action!,
          ],
        ],
      ),
    );
  }
}
