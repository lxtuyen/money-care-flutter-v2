import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum AppSnackBarType { success, error, warning, info }

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

  static void showSnackBar(
    String message, {
    AppSnackBarType? type,
    String? title,
    Duration? duration,
  }) {
    final context = Get.overlayContext ?? Get.context;
    if (context == null) return;

    final resolvedType = type ?? _inferSnackBarType(message);
    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: duration ?? _defaultDurationFor(resolvedType),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          content: _SnackBarContent(
            title: title ?? _defaultTitleFor(resolvedType),
            message: message,
            type: resolvedType,
          ),
        ),
      );
  }

  static void showSuccessSnackBar(
    String message, {
    String? title,
    Duration? duration,
  }) {
    showSnackBar(
      message,
      type: AppSnackBarType.success,
      title: title,
      duration: duration,
    );
  }

  static void showErrorSnackBar(
    String message, {
    String? title,
    Duration? duration,
  }) {
    showSnackBar(
      message,
      type: AppSnackBarType.error,
      title: title,
      duration: duration,
    );
  }

  static void showWarningSnackBar(
    String message, {
    String? title,
    Duration? duration,
  }) {
    showSnackBar(
      message,
      type: AppSnackBarType.warning,
      title: title,
      duration: duration,
    );
  }

  static AppSnackBarType _inferSnackBarType(String message) {
    final normalized = message.toLowerCase();

    const successKeywords = [
      'thành công',
      'thanh cong',
      'success',
      'đã lưu',
      'da luu',
      'đã cập nhật',
      'da cap nhat',
      'đã tạo',
      'da tao',
      'đã xóa',
      'da xoa',
    ];

    const errorKeywords = [
      'lỗi',
      'loi',
      'error',
      'thất bại',
      'that bai',
      'không thể',
      'khong the',
      'vui lòng',
      'vui long',
      'phải',
      'phai',
    ];

    if (successKeywords.any(normalized.contains)) {
      return AppSnackBarType.success;
    }

    if (errorKeywords.any(normalized.contains)) {
      return AppSnackBarType.error;
    }

    return AppSnackBarType.info;
  }

  static Duration _defaultDurationFor(AppSnackBarType type) {
    switch (type) {
      case AppSnackBarType.error:
        return const Duration(seconds: 4);
      case AppSnackBarType.warning:
        return const Duration(seconds: 3);
      case AppSnackBarType.success:
      case AppSnackBarType.info:
        return const Duration(seconds: 3);
    }
  }

  static String _defaultTitleFor(AppSnackBarType type) {
    switch (type) {
      case AppSnackBarType.success:
        return 'Thành công';
      case AppSnackBarType.error:
        return 'Có lỗi xảy ra';
      case AppSnackBarType.warning:
        return 'Lưu ý';
      case AppSnackBarType.info:
        return 'Thông báo';
    }
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

  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Chào buổi sáng ☀️';
    } else if (hour < 18) {
      return 'Chào buổi chiều 🌤️';
    } else {
      return 'Chào buổi tối 🌙';
    }
  }

  static String formatCurrency(String value) {
    if (value.isEmpty) return '';
    final formatter = NumberFormat('#,###', 'vi_VN');
    try {
      return formatter.format(int.parse(value));
    } catch (_) {
      return value;
    }
  }

  static String unformatCurrency(String value) {
    if (value.isEmpty) return '';
    return value.replaceAll(RegExp(r'[^0-9]'), '').trim();
  }
}

class _SnackBarContent extends StatelessWidget {
  final String title;
  final String message;
  final AppSnackBarType type;

  const _SnackBarContent({
    required this.title,
    required this.message,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = _SnackBarScheme.from(type);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.background, scheme.backgroundAccent],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.border),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: scheme.iconBackground,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(scheme.icon, color: scheme.foreground, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: scheme.foreground,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    message,
                    style: TextStyle(
                      color: scheme.foreground.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SnackBarScheme {
  final Color background;
  final Color backgroundAccent;
  final Color border;
  final Color iconBackground;
  final Color foreground;
  final Color shadow;
  final IconData icon;

  const _SnackBarScheme({
    required this.background,
    required this.backgroundAccent,
    required this.border,
    required this.iconBackground,
    required this.foreground,
    required this.shadow,
    required this.icon,
  });

  factory _SnackBarScheme.from(AppSnackBarType type) {
    switch (type) {
      case AppSnackBarType.success:
        return _SnackBarScheme(
          background: const Color(0xFFECFDF5),
          backgroundAccent: const Color(0xFFD1FAE5),
          border: const Color(0xFF10B981).withValues(alpha: 0.35),
          iconBackground: const Color(0xFFD1FAE5),
          foreground: const Color(0xFF064E3B),
          shadow: const Color(0xFF10B981).withValues(alpha: 0.15),
          icon: Icons.check_rounded,
        );
      case AppSnackBarType.error:
        return _SnackBarScheme(
          background: const Color(0xFFFFF1F2),
          backgroundAccent: const Color(0xFFFFE4E6),
          border: const Color(0xFFF43F5E).withValues(alpha: 0.30),
          iconBackground: const Color(0xFFFFE4E6),
          foreground: const Color(0xFF881337),
          shadow: const Color(0xFFF43F5E).withValues(alpha: 0.13),
          icon: Icons.close_rounded,
        );
      case AppSnackBarType.warning:
        return _SnackBarScheme(
          background: const Color(0xFFFFFBEB),
          backgroundAccent: const Color(0xFFFEF3C7),
          border: const Color(0xFFF59E0B).withValues(alpha: 0.35),
          iconBackground: const Color(0xFFFEF3C7),
          foreground: const Color(0xFF78350F),
          shadow: const Color(0xFFF59E0B).withValues(alpha: 0.15),
          icon: Icons.priority_high_rounded,
        );
      case AppSnackBarType.info:
        return _SnackBarScheme(
          background: const Color(0xFFEFF6FF),
          backgroundAccent: const Color(0xFFDBEAFE),
          border: const Color(0xFF3B82F6).withValues(alpha: 0.30),
          iconBackground: const Color(0xFFDBEAFE),
          foreground: const Color(0xFF1E3A8A),
          shadow: const Color(0xFF3B82F6).withValues(alpha: 0.13),
          icon: Icons.info_outline_rounded,
        );
    }
  }
}
