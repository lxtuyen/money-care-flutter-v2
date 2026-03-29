import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';

class TransactionTypeSummaryToggle extends StatelessWidget {
  final String selected;
  final Function(String) onSelected;
  final int spendText;
  final int incomeText;

  const TransactionTypeSummaryToggle({
    super.key,
    required this.selected,
    required this.onSelected,
    this.spendText = 0,
    this.incomeText = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            _buildSelectCard(
              label: 'Chi tiêu',
              value: AppHelperFunction.formatAmount(
                spendText.toDouble(),
                'VND',
              ),
              isActive: selected == 'chi',
              onTap: () => onSelected('chi'),
            ),
            const SizedBox(width: 12),
            _buildSelectCard(
              label: 'Thu nhập',
              value: AppHelperFunction.formatAmount(
                incomeText.toDouble(),
                'VND',
              ),
              isActive: selected == 'thu',
              onTap: () => onSelected('thu'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectCard({
    required String label,
    required String value,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 92,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color:
                isActive
                    ? Colors.white.withOpacity(0.24)
                    : Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isActive
                      ? Colors.white.withOpacity(0.34)
                      : Colors.white.withOpacity(0.18),
            ),
            boxShadow:
                isActive
                    ? [
                      BoxShadow(
                        color: AppColors.secondaryNavyBlue.withOpacity(0.14),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ]
                    : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.84),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
