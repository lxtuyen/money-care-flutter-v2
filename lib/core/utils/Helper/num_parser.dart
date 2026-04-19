class NumParser {
  static double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      final cleaned = value.replaceAll(RegExp(r'[^0-9.]'), '');
      return double.tryParse(cleaned) ?? 0.0;
    }
    return 0.0;
  }

  static double? parseDoubleNullable(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) {
      final cleaned = value.replaceAll(RegExp(r'[^0-9.]'), '');
      return double.tryParse(cleaned);
    }
    return null;
  }

  static int parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    if (value is String) {
      final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
      return int.tryParse(cleaned) ?? 0;
    }
    return 0;
  }

  static int? parseIntNullable(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    if (value is String) {
      final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
      return int.tryParse(cleaned);
    }
    return null;
  }
}


