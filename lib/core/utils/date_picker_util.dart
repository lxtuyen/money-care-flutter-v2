import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:money_care/core/constants/colors.dart';

Future<List<DateTime?>> pickDateRange(BuildContext context) async {
  final values = await showCalendarDatePicker2Dialog(
    context: context,
    config: CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.range,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      selectedDayHighlightColor: Colors.blueAccent,
      okButton: const Text('Chọn'),
      cancelButton: const Text('Hủy'),
    ),
    dialogSize: const Size(325, 400),
    borderRadius: BorderRadius.circular(16),
  );

  return values ?? [];
}

Future<DateTime?> pickSingleDate(BuildContext context) async {
  final values = await showCalendarDatePicker2Dialog(
    context: context,
    config: CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.range,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      selectedDayHighlightColor: AppColors.primary,
      okButton: const Text('Chọn'),
      cancelButton: const Text('Hủy'),
    ),
    dialogSize: const Size(325, 400),
    borderRadius: BorderRadius.circular(16),
  );

  return values != null && values.isNotEmpty ? values.first : null;
}
