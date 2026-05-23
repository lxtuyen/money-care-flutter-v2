import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';

class TransactionTypeToggle extends StatelessWidget {
  final String selected;
  final Function(String) onSelected;
  final int spendText;
  final int incomeText;
  final bool showAmount;
  final IconData? spendIcon;
  final IconData? incomeIcon;
  final String spendLabel;
  final String incomeLabel;
  final String spendValue;
  final String incomeValue;

  const TransactionTypeToggle({
    super.key,
    required this.selected,
    required this.onSelected,
    this.spendText = 0,
    this.incomeText = 0,
    this.showAmount = true,
    this.spendIcon,
    this.incomeIcon,
    this.spendLabel = 'Chi tiêu',
    this.incomeLabel = 'Thu nhập',
    this.spendValue = 'chi',
    this.incomeValue = 'thu',
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
              label: spendLabel,
              value: showAmount
                  ? AppHelperFunction.formatAmount(
                      spendText.toDouble(),
                      currency: 'VND',
                    )
                  : '',
              icon: spendIcon,
              isActive: selected == spendValue,
              onTap: () => onSelected(spendValue),
            ),
            const SizedBox(width: 12),
            _buildSelectCard(
              label: incomeLabel,
              value: showAmount
                  ? AppHelperFunction.formatAmount(
                      incomeText.toDouble(),
                      currency: 'VND',
                    )
                  : '',
              icon: incomeIcon,
              isActive: selected == incomeValue,
              onTap: () => onSelected(incomeValue),
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
    IconData? icon,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: showAmount ? 92 : 70,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white.withValues(alpha: 0.24)
                : Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive
                  ? Colors.white.withValues(alpha: 0.4)
                  : Colors.white.withValues(alpha: 0.15),
              width: 1.5,
            ),
            boxShadow: isActive && showAmount
                ? [
                    BoxShadow(
                      color: AppColors.secondaryNavyBlue.withValues(
                        alpha: 0.14,
                      ),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: showAmount
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.84),
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
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        color: isActive ? Colors.white : Colors.white70,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      label,
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.white70,
                        fontSize: 15,
                        fontWeight:
                            isActive ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
