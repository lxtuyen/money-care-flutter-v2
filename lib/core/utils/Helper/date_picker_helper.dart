import 'package:flutter/material.dart';

Future<DateTime?> showStyledDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  DateTime? lastDate,
}) {
  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate ?? DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF1379C1),
            onPrimary: Colors.white,
            onSurface: Color(0xFF0F1314),
            surface: Colors.white,
            secondary: Color(0xFF42A6ED),
          ),
          datePickerTheme: DatePickerThemeData(
            backgroundColor: Colors.white,
            headerBackgroundColor: const Color(0xFF1379C1),
            headerForegroundColor: Colors.white,
            headerHeadlineStyle: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            headerHelpStyle: const TextStyle(
              fontSize: 13,
              color: Colors.white70,
            ),
            dayStyle: const TextStyle(fontSize: 13),
            todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const Color(0xFF1379C1);
              }
              return const Color(0xFFE3F2FD);
            }),
            todayForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.white;
              }
              return const Color(0xFF1379C1);
            }),
            dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const Color(0xFF1379C1);
              }
              return null;
            }),
            dayForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.white;
              }
              if (states.contains(WidgetState.disabled)) {
                return const Color(0xFFB0B0B0);
              }
              return const Color(0xFF0F1314);
            }),
            yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const Color(0xFF1379C1);
              }
              return null;
            }),
            yearForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.white;
              }
              return const Color(0xFF0F1314);
            }),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            shadowColor: Colors.black26,
            dividerColor: const Color(0xFFE1E5E9),
            cancelButtonStyle: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(const Color(0xFF7A7777)),
            ),
            confirmButtonStyle: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(const Color(0xFF1379C1)),
            ),
          ),
        ),
        child: child!,
      );
    },
  );
}
