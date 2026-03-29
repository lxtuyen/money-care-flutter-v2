import 'package:flutter/material.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/saving_fund/domain/entities/entities.dart';
import 'package:money_care/features/saving_fund/presentation/widgets/category_wrap.dart';

class SavingFundItemCard extends StatelessWidget {
  final SavingFundEntity fund;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onUpdate;
  final VoidCallback? onDelete;

  const SavingFundItemCard({
    super.key,
    required this.fund,
    required this.isSelected,
    required this.onTap,
    this.onUpdate,
    this.onDelete,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    fund.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (onUpdate != null)
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                    onPressed: onUpdate,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                if (onUpdate != null && onDelete != null)
                  const SizedBox(width: 8),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                    onPressed: onDelete,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
              ],
            ),
            const SizedBox(height: 12),

            _InfoRow(
              label: 'Mục tiêu:',
              value:
                  fund.amount != null
                      ? AppHelperFunction.formatAmount(
                        fund.amount!,
                        'VND',
                      )
                      : 'Chưa xác định',
            ),
            _InfoRow(
              label: 'Bắt đầu:',
              value:
                  fund.start_date != null
                      ? AppHelperFunction.formatDayMonth(fund.start_date!)
                      : 'Chưa xác định',
            ),
            _InfoRow(
              label: 'Kết thúc:',
              value:
                  fund.end_date != null
                      ? AppHelperFunction.formatDayMonth(fund.end_date!)
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
