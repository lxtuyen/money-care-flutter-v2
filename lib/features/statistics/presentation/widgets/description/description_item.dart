import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';

class DescriptionItem extends StatelessWidget {
  const DescriptionItem({
    super.key,
    required this.title,
    required this.value,
    required this.percent,
  });

  final String title;
  final String value;
  final String percent;

  Color get _percentColor {
    if (percent.startsWith('-')) return Colors.red;
    return Colors.green;
  }

  IconData get _percentIcon {
    if (percent.startsWith('-')) return Icons.arrow_drop_down;
    return Icons.arrow_drop_up;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.text1,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 4),
            Icon(_percentIcon, color: _percentColor, size: 20),
            Text(
              '$percent %',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _percentColor,
              ),
            ),
          ],
        ),

        const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Divider(height: 16, thickness: 1, color: Color(0xFFE0E0E0)),
        ),
      ],
    );
  }
}
