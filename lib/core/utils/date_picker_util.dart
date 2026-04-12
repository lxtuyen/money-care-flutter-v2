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

Future<int?> pickDayOfMonth(BuildContext context, {int? initialDay}) async {
  return await showModalBottomSheet<int>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        height: 450,
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Chọn ngày nhận tiền',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.text1,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: 31,
                itemBuilder: (context, index) {
                  final day = index + 1;
                  final isSelected = day == initialDay;
                  return InkWell(
                    onTap: () => Navigator.pop(context, day),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.backgroundSecondary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.borderSecondary,
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$day',
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.text1,
                          fontSize: 15,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
