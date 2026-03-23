import 'package:flutter/material.dart';
import 'package:money_care/core/utils/Helper/helper_functions.dart';
import 'package:money_care/features/saving_fund/domain/entities/entities.dart';
import 'package:money_care/features/saving_fund/presentation/widgets/category_wrap.dart';

class SavingFundItemCard extends StatelessWidget {
  final SavingFundEntity fund;
  final bool isSelected;
  final VoidCallback onTap;

  const SavingFundItemCard({
    super.key,
    required this.fund,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fund.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _InfoRow(
              label: 'Mục tiêu:',
              value:
                  fund.targetAmount != null
                      ? AppHelperFunction.formatAmount(
                        fund.targetAmount!,
                        'VND',
                      )
                      : 'Chưa xác định',
            ),
            _InfoRow(
              label: 'Bắt đầu:',
              value:
                  fund.startDate != null
                      ? AppHelperFunction.formatDayMonth(fund.startDate!)
                      : 'Chưa xác định',
            ),
            _InfoRow(
              label: 'Kết thúc:',
              value:
                  fund.endDate != null
                      ? AppHelperFunction.formatDayMonth(fund.endDate!)
                      : 'Chưa xác định',
            ),

            if (fund.categories.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 12),
              CategoryWrap(categories: fund.categories),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
