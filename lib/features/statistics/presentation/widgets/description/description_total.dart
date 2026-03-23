import 'package:flutter/material.dart';
import 'package:money_care/core/utils/Helper/helper_functions.dart';
import 'package:money_care/features/statistics/presentation/widgets/description/description_item.dart';

class DescriptionTotal extends StatelessWidget {
  const DescriptionTotal({
    super.key,
    required this.dailyAverage,
    required this.dailyAverageChange,
    required this.monthlyBalance,
    required this.monthlyBalanceChange,
  });
  final double dailyAverage;
  final String dailyAverageChange;
  final double monthlyBalance;
  final String monthlyBalanceChange;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DescriptionItem(
            title: 'Trung bình chi theo ngày',
            value: AppHelperFunction.formatAmount(dailyAverage, 'VND'),
            percent: dailyAverageChange,
          ),
          const SizedBox(height: 8),

          DescriptionItem(
            title: 'Số dư tháng này',
            value: AppHelperFunction.formatAmount(monthlyBalance, 'VND'),
            percent: monthlyBalanceChange,
          ),
        ],
      ),
    );
  }
}
