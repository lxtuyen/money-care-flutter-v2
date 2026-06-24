/// Model cho phân tích chi tiết chi tiêu theo từng danh mục.
class CategoryBreakdownModel {
  final int targetMonth;
  final int targetYear;
  final List<CategoryBreakdownItem> categories;

  const CategoryBreakdownModel({
    required this.targetMonth,
    required this.targetYear,
    required this.categories,
  });

  factory CategoryBreakdownModel.fromJson(Map<String, dynamic> json) {
    return CategoryBreakdownModel(
      targetMonth: _asInt(json['target_month']),
      targetYear: _asInt(json['target_year']),
      categories: _asList(json['categories'])
          .map((item) => CategoryBreakdownItem.fromJson(_asMap(item)))
          .toList(),
    );
  }

  String get periodLabel => 'Tháng $targetMonth/$targetYear';
}

class CategoryBreakdownItem {
  final String categoryName;
  final String? categoryIcon;
  final double total;
  final int count;
  final double prevMonthTotal;
  final double? changePct;
  final List<SubGroupItem> subGroups;

  const CategoryBreakdownItem({
    required this.categoryName,
    required this.categoryIcon,
    required this.total,
    required this.count,
    required this.prevMonthTotal,
    required this.changePct,
    required this.subGroups,
  });

  factory CategoryBreakdownItem.fromJson(Map<String, dynamic> json) {
    return CategoryBreakdownItem(
      categoryName: json['category_name']?.toString() ?? '',
      categoryIcon: json['category_icon']?.toString(),
      total: _asDouble(json['total']),
      count: _asInt(json['count']),
      prevMonthTotal: _asDouble(json['prev_month_total']),
      changePct: _asNullableDouble(json['change_pct']),
      subGroups: _asList(json['sub_groups'])
          .map((item) => SubGroupItem.fromJson(_asMap(item)))
          .toList(),
    );
  }

  bool get isIncreased => (changePct ?? 0) > 0;
  bool get isDecreased => (changePct ?? 0) < 0;
  bool get isNew => prevMonthTotal <= 0 && total > 0;
}

class SubGroupItem {
  final String groupName;
  final int count;
  final double total;
  final double avgPerTransaction;
  final int prevMonthCount;
  final double prevMonthTotal;
  final double? changePct;
  final List<SubGroupTransaction> transactions;

  const SubGroupItem({
    required this.groupName,
    required this.count,
    required this.total,
    required this.avgPerTransaction,
    required this.prevMonthCount,
    required this.prevMonthTotal,
    required this.changePct,
    required this.transactions,
  });

  factory SubGroupItem.fromJson(Map<String, dynamic> json) {
    return SubGroupItem(
      groupName: json['group_name']?.toString() ?? '',
      count: _asInt(json['count']),
      total: _asDouble(json['total']),
      avgPerTransaction: _asDouble(json['avg_per_transaction']),
      prevMonthCount: _asInt(json['prev_month_count']),
      prevMonthTotal: _asDouble(json['prev_month_total']),
      changePct: _asNullableDouble(json['change_pct']),
      transactions: _asList(json['transactions'])
          .map((item) => SubGroupTransaction.fromJson(_asMap(item)))
          .toList(),
    );
  }

  bool get isIncreased => (changePct ?? 0) > 0;
  bool get isDecreased => (changePct ?? 0) < 0;
}

class SubGroupTransaction {
  final String note;
  final double amount;
  final String date;

  const SubGroupTransaction({
    required this.note,
    required this.amount,
    required this.date,
  });

  factory SubGroupTransaction.fromJson(Map<String, dynamic> json) {
    return SubGroupTransaction(
      note: json['note']?.toString() ?? '',
      amount: _asDouble(json['amount']),
      date: json['date']?.toString() ?? '',
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}

List<dynamic> _asList(dynamic value) {
  if (value is List) return value;
  return const [];
}

double _asDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

double? _asNullableDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
