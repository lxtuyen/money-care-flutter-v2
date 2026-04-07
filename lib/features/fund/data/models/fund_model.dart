import 'package:money_care/features/fund/domain/entities/fund_entity.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';

class FundModel {
  final int id;
  final String name;
  final String? type;
  bool? isSelected;
  final List<CategoryModel> categories;

  // SPENDING
  final double? balance;
  final double? monthlyLimit;
  final double spentCurrentMonth;
  final bool notified70;
  final bool notified90;

  // SAVING GOAL
  final double? target;
  final double savedAmount;
  final bool isCompleted;
  final String? templateKey;

  // Common
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;

  FundModel({
    required this.id,
    required this.name,
    this.type,
    this.isSelected,
    required this.categories,
    this.balance,
    this.monthlyLimit,
    this.spentCurrentMonth = 0,
    this.notified70 = false,
    this.notified90 = false,
    this.target,
    this.savedAmount = 0,
    this.isCompleted = false,
    this.templateKey,
    this.startDate,
    this.endDate,
    this.status,
  });

  factory FundModel.fromMap(Map<String, dynamic> json) {
    double? parseNum(dynamic v) =>
        v != null ? double.tryParse(v.toString()) : null;

    return FundModel(
      id: json['id'],
      name: json['name'],
      type: json['type'] as String?,
      isSelected: json['is_selected'] as bool?,
      categories: json['categories'] != null
          ? List<CategoryModel>.from(
              (json['categories'] as List).map((x) => CategoryModel.fromJson(x)),
            )
          : [],
      balance: parseNum(json['balance']),
      monthlyLimit: parseNum(json['monthly_limit']),
      spentCurrentMonth: parseNum(json['spent_current_month']) ?? 0,
      notified70: json['notified_70'] as bool? ?? false,
      notified90: json['notified_90'] as bool? ?? false,
      target: parseNum(json['target']),
      savedAmount: parseNum(json['saved_amount']) ?? 0,
      isCompleted: json['is_completed'] as bool? ?? false,
      templateKey: json['template_key'] as String?,
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'].toString())
          : null,
      endDate: json['end_date'] != null
          ? DateTime.tryParse(json['end_date'].toString())
          : null,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'is_selected': isSelected,
      'categories': categories.map((e) => e.toJson()).toList(),
      'balance': balance,
      'monthly_limit': monthlyLimit,
      'spent_current_month': spentCurrentMonth,
      'notified_70': notified70,
      'notified_90': notified90,
      'target': target,
      'saved_amount': savedAmount,
      'is_completed': isCompleted,
      'template_key': templateKey,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'status': status,
    };
  }

  FundEntity toEntity() {
    FundType ft = FundType.spending;
    if (type == 'SAVING_GOAL') ft = FundType.savingGoal;

    return FundEntity(
      id: id,
      name: name,
      type: ft,
      isSelected: isSelected,
      categories: categories.map((e) => e.toEntity()).toList(),
      balance: balance,
      monthlyLimit: monthlyLimit,
      spentCurrentMonth: spentCurrentMonth,
      notified70: notified70,
      notified90: notified90,
      target: target,
      savedAmount: savedAmount,
      isCompleted: isCompleted,
      templateKey: templateKey,
      startDate: startDate,
      endDate: endDate,
      status: status,
    );
  }
}
