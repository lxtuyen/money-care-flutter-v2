import 'dart:math' as math;

class Unit {
  final int value;
  final String symbol;

  Unit(this.value, this.symbol);
}

class chartHelper {
static String formatCurrencyShort(int value) {
  if (value < 1000) return value.toString();

  final units = [
    Unit(1000000, 'M'),
    Unit(1000, 'K'),
  ];

  for (var unit in units) {
    if (value >= unit.value) {
      double val = value / unit.value;

      return val == val.roundToDouble()
          ? '${val.toInt()}${unit.symbol}'
          : '${val.toStringAsFixed(1)}${unit.symbol}';
    }
  }

  return value.toString();
}

  static double calculateInterval(double maxValue) {
  if (maxValue <= 0) return 1;

  const targetDivisions = 5;
  final rawInterval = maxValue / targetDivisions;

  final magnitude = math.pow(10, (math.log(rawInterval) / math.ln10).floor());
  final normalized = rawInterval / magnitude;

  double niceNormalized;
  if (normalized >= 5) {
    niceNormalized = 5;
  } else if (normalized >= 2) {
    niceNormalized = 2;
  } else {
    niceNormalized = 1;
  }

  final interval = niceNormalized * magnitude;
  return interval;
}
}