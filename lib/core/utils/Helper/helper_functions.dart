import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppHelperFunction {
  static Color? getColor(String value) {
    switch (value) {
      case 'Green':
        return Colors.green;
      case 'Red':
        return Colors.red;
      case 'Blue':
        return Colors.blue;
      case 'Pink':
        return Colors.pink;
      case 'Grey':
        return Colors.grey;
      case 'Purple':
        return Colors.purple;
      case 'Orange':
        return Colors.orange;
      case 'Brown':
        return Colors.brown;
      case 'Teal':
        return Colors.teal;
      case 'Indigo':
        return Colors.indigo;
      case 'Cyan':
        return Colors.cyan;
      case 'Lime':
        return Colors.lime;
      case 'Amber':
        return Colors.amber;
      case 'DeepOrange':
        return Colors.deepOrange;
      case 'DeepPurple':
        return Colors.deepPurple;
      case 'LightBlue':
        return Colors.lightBlue;
      case 'LightGreen':
        return Colors.lightGreen;
      case 'Yellow':
        return Colors.yellow;
      case 'BlueGrey':
        return Colors.blueGrey;
      case 'Black':
        return Colors.black;
      case 'Custom1':
        return const Color(0xFF6D5BD0);
      case 'Custom2':
        return const Color(0xFFC96B2C);
      case 'Custom3':
        return const Color(0xFF2E8B7F);
      default:
        return Colors.grey;
    }
  }

  static final List<String> _colorNames = [
    'Green',
    'Red',
    'Blue',
    'Grey',
    'Purple',
    'Brown',
    'Teal',
    'Indigo',
    'DeepOrange',
    'DeepPurple',
    'BlueGrey',
    'Black',
    'Custom1',
    'Custom2',
    'Custom3',
  ];

  static final List<Color> _chartColors = [
    const Color(0xFF2D9CDB),
    const Color(0xFF27AE60),
    const Color(0xFFF2994A),
    const Color(0xFFEB5757),
    const Color(0xFF9B51E0),
    const Color(0xFF2DCEB3),
    const Color(0xFF3D5AFE),
    const Color(0xFF8D6E63),
    const Color(0xFF00897B),
    const Color(0xFF5C6BC0),
  ];

  static Color getRandomColor() {
    final random = Random();
    final colorName = _colorNames[random.nextInt(_colorNames.length)];
    return getColor(colorName)!;
  }

  static Color getChartColorByIndex(int index) {
    if (_chartColors.isEmpty) {
      return AppHelperFunction.getRandomColor();
    }
    return _chartColors[index % _chartColors.length];
  }

  static void showSnackBar(String message) {
    final context = Get.context;
    if (context == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static String getFormattedDate(
    DateTime date, {
    String format = 'dd/MM/yyyy',
  }) {
    return DateFormat(format).format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inDays == 0) {
      return 'Hôm nay';
    } else if (diff.inDays == 1) {
      return 'Hôm qua';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }

  static String formatDayMonth(DateTime date) {
    return DateFormat('dd/MM').format(date);
  }

  static String formatAmount(double amount, String currency) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return '${formatter.format(amount)} $currency';
  }

  static int clampZero(int value) => value < 0 ? 0 : value;
}
