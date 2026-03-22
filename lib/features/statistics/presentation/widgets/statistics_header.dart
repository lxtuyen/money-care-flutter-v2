import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/Helper/helper_functions.dart';

class StatisticsHeader extends StatelessWidget {
  final String selected;
  final Function(String) onSelected;
  final String title;
  final int spendText;
  final int incomeText;

  const StatisticsHeader({
    super.key,
    required this.selected,
    required this.onSelected,
    this.title = "Thống kê",
    this.spendText = 0,
    this.incomeText = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: kIsWeb ? AppColors.text2 : Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Row(
                children: [
                  _buildSelectCard(
                    label: "Tiền chi",
                    value: AppHelperFunction.formatAmount(
                      spendText.toDouble(),
                      'VND',
                    ),
                    isActive: selected == 'chi',
                    onTap: () => onSelected('chi'),
                  ),
                  const SizedBox(width: 12),
                  _buildSelectCard(
                    label: "Tiền thu",
                    value: AppHelperFunction.formatAmount(
                      incomeText.toDouble(),
                      'VND',
                    ),
                    isActive: selected == 'thu',
                    onTap: () => onSelected('thu'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectCard({
    required String label,
    required String value,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final bool isWeb = kIsWeb;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isWeb ? Colors.white : const Color(0xFF1976D2),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color:
                  isWeb
                      ? (isActive
                          ? const Color(0xFF1976D2)
                          : Colors.grey.shade300)
                      : (isActive
                          ? Colors.grey.shade300
                          : const Color(0xFF1976D2)),
              width: 2,
            ),
            boxShadow:
                isWeb
                    ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                    : null,
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  color:
                      isWeb
                          ? const Color(0xFF1976D2)
                          : Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  color: isWeb ? const Color(0xFF1976D2) : Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
