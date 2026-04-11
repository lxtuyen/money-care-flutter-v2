import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/validators/validation.dart';

class PercentageInputField extends StatelessWidget {
  final int value;
  final Function(int) onChanged;

  const PercentageInputField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: TextFormField(
        key: ValueKey(value),
        initialValue: value.toString(),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          suffixText: '%',
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 6,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.primary),
          ),
        ),
        onChanged: (text) {
          final percentage = int.tryParse(text) ?? 0;
          if (percentage >= 0 && percentage <= 100) {
            onChanged(percentage);
          }
        },
        validator: AppValidator.validatePercentage,
      ),
    );
  }
}
