import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';

class FixedExpenseModel {
  final int id;
  final String name;
  final String? category;
  final double amount;
  final String frequencyType;
  final int frequencyValue;
  final int? dueDay;
  final String? note;
  final bool isPaid;
  final bool isReminderEnabled;
  final int? linkedTransactionId;

  const FixedExpenseModel({
    required this.id,
    required this.name,
    this.category,
    required this.amount,
    required this.frequencyType,
    required this.frequencyValue,
    this.dueDay,
    this.note,
    required this.isPaid,
    required this.isReminderEnabled,
    this.linkedTransactionId,
  });

  factory FixedExpenseModel.fromJson(Map<String, dynamic> json) {
    String? catName;
    if (json['category'] != null) {
      if (json['category'] is Map) {
        catName = json['category']['name']?.toString();
      } else {
        catName = json['category']?.toString();
      }
    }
    return FixedExpenseModel(
      id: _asInt(json['id']),
      name: json['name']?.toString() ?? '',
      category: catName,
      amount: _asDouble(json['amount']),
      frequencyType: json['frequencyType']?.toString() ?? 'once',
      frequencyValue: _asInt(json['frequencyValue'] ?? 1),
      dueDay: json['dueDay'] == null ? null : _asInt(json['dueDay']),
      note: json['note']?.toString(),
      isPaid: json['isPaid'] == true,
      isReminderEnabled: json['isReminderEnabled'] == true,
      linkedTransactionId: json['linkedTransactionId'] == null
          ? null
          : _asInt(json['linkedTransactionId']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'amount': amount,
      'frequencyType': frequencyType,
      'frequencyValue': frequencyValue,
      'dueDay': dueDay,
      'note': note,
      'isPaid': isPaid,
      'isReminderEnabled': isReminderEnabled,
      'linkedTransactionId': linkedTransactionId,
    };
  }

  FixedExpenseEntity toEntity() {
    return FixedExpenseEntity(
      id: id,
      name: name,
      category: category,
      amount: amount,
      frequencyType: frequencyType,
      frequencyValue: frequencyValue,
      dueDay: dueDay,
      note: note,
      isPaid: isPaid,
      isReminderEnabled: isReminderEnabled,
      linkedTransactionId: linkedTransactionId,
    );
  }
}

class SpendingPlanModel {
  final int id;
  final int month;
  final int year;
  final double totalAmount;
  final double savingTargetAmount;
  final double fixedExpenseTotal;
  final double availableSpendingAmount;
  final String status;
  final String riskLevel;
  final List<FixedExpenseModel> fixedExpenses;

  const SpendingPlanModel({
    required this.id,
    required this.month,
    required this.year,
    required this.totalAmount,
    required this.savingTargetAmount,
    required this.fixedExpenseTotal,
    required this.availableSpendingAmount,
    required this.status,
    required this.riskLevel,
    required this.fixedExpenses,
  });

  factory SpendingPlanModel.fromJson(Map<String, dynamic> json) {
    final rawFixedExpenses = json['fixedExpenses'];
    return SpendingPlanModel(
      id: _asInt(json['id']),
      month: _asInt(json['month']),
      year: _asInt(json['year']),
      totalAmount: _asDouble(json['totalAmount']),
      savingTargetAmount: _asDouble(json['savingTargetAmount']),
      fixedExpenseTotal: _asDouble(json['fixedExpenseTotal']),
      availableSpendingAmount: _asDouble(json['availableSpendingAmount']),
      status: json['status']?.toString() ?? 'draft',
      riskLevel: json['riskLevel']?.toString() ?? 'warning',
      fixedExpenses: rawFixedExpenses is List
          ? rawFixedExpenses
                .whereType<Map<String, dynamic>>()
                .map(FixedExpenseModel.fromJson)
                .toList()
          : const [],
    );
  }

  SpendingPlanEntity toEntity() {
    return SpendingPlanEntity(
      id: id,
      month: month,
      year: year,
      totalAmount: totalAmount,
      savingTargetAmount: savingTargetAmount,
      fixedExpenseTotal: fixedExpenseTotal,
      availableSpendingAmount: availableSpendingAmount,
      status: status,
      riskLevel: riskLevel,
      fixedExpenses: fixedExpenses
          .map((expense) => expense.toEntity())
          .toList(),
    );
  }
}

class CreateFixedExpenseRequest {
  final String? name;
  final String? category;
  final double amount;
  final String? frequencyType;
  final int? frequencyValue;
  final int? dueDay;
  final String? note;
  final bool? isReminderEnabled;

  const CreateFixedExpenseRequest({
    this.name,
    this.category,
    required this.amount,
    this.frequencyType,
    this.frequencyValue,
    this.dueDay,
    this.note,
    this.isReminderEnabled,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      'amount': amount,
      if (frequencyType != null) 'frequencyType': frequencyType,
      if (frequencyValue != null) 'frequencyValue': frequencyValue,
      'dueDay': dueDay,
      'note': note,
      if (isReminderEnabled != null) 'isReminderEnabled': isReminderEnabled,
    };
  }
}

class CreateSpendingPlanRequest {
  final double totalAmount;
  final double savingTargetAmount;
  final List<CreateFixedExpenseRequest> fixedExpenses;

  const CreateSpendingPlanRequest({
    required this.totalAmount,
    required this.savingTargetAmount,
    required this.fixedExpenses,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalAmount': totalAmount,
      'savingTargetAmount': savingTargetAmount,
      'fixedExpenses': fixedExpenses
          .map((expense) => expense.toJson())
          .toList(),
    };
  }
}

class UpdateSpendingPlanRequest {
  final int? month;
  final int? year;
  final double? totalAmount;
  final double? savingTargetAmount;
  final List<CreateFixedExpenseRequest>? fixedExpenses;

  const UpdateSpendingPlanRequest({
    this.month,
    this.year,
    this.totalAmount,
    this.savingTargetAmount,
    this.fixedExpenses,
  });

  Map<String, dynamic> toJson() {
    return {
      if (month != null) 'month': month,
      if (year != null) 'year': year,
      if (totalAmount != null) 'totalAmount': totalAmount,
      if (savingTargetAmount != null) 'savingTargetAmount': savingTargetAmount,
      if (fixedExpenses != null)
        'fixedExpenses': fixedExpenses!
            .map((expense) => expense.toJson())
            .toList(),
    };
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _asDouble(dynamic value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}
