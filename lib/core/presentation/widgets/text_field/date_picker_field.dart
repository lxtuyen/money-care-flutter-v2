import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DatePickerField extends StatelessWidget {
  final Rxn<DateTime> selectedDate;
  final String label;
  final String placeholder;
  final VoidCallback onTap;

  const DatePickerField({
    super.key,
    required this.selectedDate,
    required this.label,
    required this.placeholder,
    required this.onTap,
  });

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final dateDisplay =
          selectedDate.value != null
              ? '$label: ${_formatDate(selectedDate.value!)}'
              : placeholder;
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.date_range),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  dateDisplay,
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        selectedDate.value != null
                            ? Colors.black
                            : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
