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
        return const Color(0xFFB39DDB);
      case 'Custom2':
        return const Color(0xFFFFCC80);
      case 'Custom3':
        return const Color(0xFF80CBC4);
      default:
        return Colors.grey;
    }
  }

  static final List<String> _colorNames = [
    'Green',
    'Red',
    'Blue',
    'Pink',
    'Grey',
    'Purple',
    'Orange',
    'Brown',
    'Teal',
    'Indigo',
    'Cyan',
    'Lime',
    'Amber',
    'DeepOrange',
    'DeepPurple',
    'LightBlue',
    'LightGreen',
    'Yellow',
    'BlueGrey',
    'Black',
    'Custom1',
    'Custom2',
    'Custom3',
  ];

  static Color getRandomColor() {
    final random = Random();
    final colorName = _colorNames[random.nextInt(_colorNames.length)];
    return getColor(colorName)!;
  }

  static void showSnackBar(String message) {
    ScaffoldMessenger.of(
      Get.context!,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  static void showAlert(String title, String message) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text("OK")),
          ],
        );
      },
    );
  }

  static String truncateText(String text, int maxlength) {
    if (text.length <= maxlength) {
      return text;
    } else {
      return '${text.substring(0, maxlength)}...';
    }
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size screenSize() {
    return MediaQuery.of(Get.context!).size;
  }

  static double screenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  static double screenWith() {
    BuildContext? context = Get.context;
    if (context == null) {
      return 375.0;
    }
    return MediaQuery.of(context).size.width;
  }

  static String getFormattedDate(
    DateTime date, {
    String format = 'dd/MM/yyyy',
  }) {
    return DateFormat(format).format(date);
  }

  static  String formatDateTime(DateTime dateTime) {
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

  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }

  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    final wrappedList = <Widget>[];
    for (var i = 0; i < widgets.length; i += rowSize) {
      final rowChildren = widgets.sublist(
        i,
        i + rowSize > widgets.length ? widgets.length : i + rowSize,
      );
      wrappedList.add(Row(children: rowChildren));
    }
    return wrappedList;
  }

  static String formatAmount(double amount, String currency) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return '${formatter.format(amount)} $currency';
  }

  static int clampZero(int value) => value < 0 ? 0 : value;
}
