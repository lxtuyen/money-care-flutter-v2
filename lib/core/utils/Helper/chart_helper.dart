import 'package:intl/intl.dart';

class ChartHelper {
  double calculateInterval(double maxY) {
    if (maxY <= 0) return 1000;

    if (maxY <= 10000) return 2000;
    if (maxY <= 50000) return 10000;
    if (maxY <= 100000) return 20000;
    if (maxY <= 500000) return 100000;
    if (maxY <= 1000000) return 200000;

    return _roundToNiceNumber(maxY / 5);
  }

  String formatCurrencyShort(int value) {
    final absValue = value.abs();

    if (absValue >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)}B';
    }
    if (absValue >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (absValue >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }

    return NumberFormat('#,###', 'vi_VN').format(value);
  }

  double _roundToNiceNumber(double value) {
    final magnitude = _pow10(value);
    final normalized = value / magnitude;

    if (normalized <= 1) return 1 * magnitude;
    if (normalized <= 2) return 2 * magnitude;
    if (normalized <= 5) return 5 * magnitude;
    return 10 * magnitude;
  }

  double _pow10(double value) {
    if (value <= 0) return 1;
    final digits = value.toInt().toString().length - 1;
    return digits <= 0
        ? 1
        : List.filled(digits, 10).fold(1, (a, b) => a * b).toDouble();
  }
}

final chartHelper = ChartHelper();
