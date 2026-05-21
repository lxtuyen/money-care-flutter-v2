import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';

class FixedExpenseModel {
  final int id;
  final String name;
  final String? category;
  final int? categoryId;
  final String? subCategory;
  final int? subCategoryId;
  final String trackingType;
  final double amount;
  final double monthlyLimit;
  final double? dailyLimit;
  final double spentThisMonth;
  final double todaySpent;
  final double monthlyProgress;
  final double dailyOverAmount;
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
    this.categoryId,
    this.subCategory,
    this.subCategoryId,
    this.trackingType = 'fixed_bill',
    required this.amount,
    this.monthlyLimit = 0,
    this.dailyLimit,
    this.spentThisMonth = 0,
    this.todaySpent = 0,
    this.monthlyProgress = 0,
    this.dailyOverAmount = 0,
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
    String? subCatName;
    if (json['subCategory'] != null) {
      if (json['subCategory'] is Map) {
        subCatName = json['subCategory']['name']?.toString();
      } else {
        subCatName = json['subCategory']?.toString();
      }
    }
    return FixedExpenseModel(
      id: _asInt(json['id']),
      name: json['name']?.toString() ?? '',
      category: catName,
      categoryId: json['category'] is Map
          ? _asIntNullable(json['category']['id'])
          : _asIntNullable(json['categoryId']),
      subCategory: subCatName,
      subCategoryId: json['subCategory'] is Map
          ? _asIntNullable(json['subCategory']['id'])
          : _asIntNullable(json['subCategoryId']),
      trackingType: json['trackingType']?.toString() ?? 'fixed_bill',
      amount: _asDouble(json['amount']),
      monthlyLimit: _asDouble(json['monthlyLimit']),
      dailyLimit: json['dailyLimit'] == null
          ? null
          : _asDouble(json['dailyLimit']),
      spentThisMonth: _asDouble(json['spentThisMonth']),
      todaySpent: _asDouble(json['todaySpent']),
      monthlyProgress: _asDouble(json['monthlyProgress']),
      dailyOverAmount: _asDouble(json['dailyOverAmount']),
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
      'categoryId': categoryId,
      'subCategoryId': subCategoryId,
      'trackingType': trackingType,
      'amount': amount,
      'monthlyLimit': monthlyLimit,
      'dailyLimit': dailyLimit,
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
      categoryId: categoryId,
      subCategory: subCategory,
      subCategoryId: subCategoryId,
      trackingType: trackingType,
      amount: amount,
      monthlyLimit: monthlyLimit,
      dailyLimit: dailyLimit,
      spentThisMonth: spentThisMonth,
      todaySpent: todaySpent,
      monthlyProgress: monthlyProgress,
      dailyOverAmount: dailyOverAmount,
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
  final double totalAmount;
  final double savingTargetAmount;
  final double fixedExpenseTotal;
  final double availableSpendingAmount;
  final String status;
  final String riskLevel;
  final List<FixedExpenseModel> fixedExpenses;

  const SpendingPlanModel({
    required this.id,
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
  final int? categoryId;
  final int? subCategoryId;
  final String? trackingType;
  final double amount;
  final double? monthlyLimit;
  final double? dailyLimit;
  final String? frequencyType;
  final int? frequencyValue;
  final int? dueDay;
  final bool? isReminderEnabled;

  const CreateFixedExpenseRequest({
    this.name,
    this.category,
    this.categoryId,
    this.subCategoryId,
    this.trackingType,
    required this.amount,
    this.monthlyLimit,
    this.dailyLimit,
    this.frequencyType,
    this.frequencyValue,
    this.dueDay,
    this.isReminderEnabled,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (categoryId != null) 'categoryId': categoryId,
      if (subCategoryId != null) 'subCategoryId': subCategoryId,
      if (trackingType != null) 'trackingType': trackingType,
      'amount': amount,
      if (monthlyLimit != null) 'monthlyLimit': monthlyLimit,
      'dailyLimit': dailyLimit,
      if (frequencyType != null) 'frequencyType': frequencyType,
      if (frequencyValue != null) 'frequencyValue': frequencyValue,
      'dueDay': dueDay,
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
  final double? totalAmount;
  final double? savingTargetAmount;
  final List<CreateFixedExpenseRequest>? fixedExpenses;

  const UpdateSpendingPlanRequest({
    this.totalAmount,
    this.savingTargetAmount,
    this.fixedExpenses,
  });

  Map<String, dynamic> toJson() {
    return {
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

int? _asIntNullable(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

double _asDouble(dynamic value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

class SpendingPlanStatsModel {
  final int planId;
  final String planName;
  final double availableSpendingAmount;
  final double spentFlexibleAmount;
  final double spentFixedAmount;
  final double remainingAmount;
  final int daysLeft;
  final double projectedEndBalance;
  final List<FixedExpenseModel> fixedExpenses;

  const SpendingPlanStatsModel({
    required this.planId,
    required this.planName,
    required this.availableSpendingAmount,
    required this.spentFlexibleAmount,
    required this.spentFixedAmount,
    required this.remainingAmount,
    required this.daysLeft,
    required this.projectedEndBalance,
    required this.fixedExpenses,
  });

  factory SpendingPlanStatsModel.fromJson(Map<String, dynamic> json) {
    final rawFixedExpenses = json['fixedExpenses'];
    return SpendingPlanStatsModel(
      planId: _asInt(json['planId']),
      planName: json['planName']?.toString() ?? '',
      availableSpendingAmount: _asDouble(json['availableSpendingAmount']),
      spentFlexibleAmount: _asDouble(json['spentFlexibleAmount']),
      spentFixedAmount: _asDouble(json['spentFixedAmount']),
      remainingAmount: _asDouble(json['remainingAmount']),
      daysLeft: _asInt(json['daysLeft']),
      projectedEndBalance: _asDouble(json['projectedEndBalance']),
      fixedExpenses: rawFixedExpenses is List
          ? rawFixedExpenses
                .map((e) => Map<String, dynamic>.from(e as Map))
                .map(FixedExpenseModel.fromJson)
                .toList()
          : const [],
    );
  }

  SpendingPlanStatsEntity toEntity() {
    return SpendingPlanStatsEntity(
      planId: planId,
      planName: planName,
      availableSpendingAmount: availableSpendingAmount,
      spentFlexibleAmount: spentFlexibleAmount,
      spentFixedAmount: spentFixedAmount,
      remainingAmount: remainingAmount,
      daysLeft: daysLeft,
      projectedEndBalance: projectedEndBalance,
      fixedExpenses: fixedExpenses.map((e) => e.toEntity()).toList(),
    );
  }
}
