import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';

class EstimatedExpenseModel {
  final int id;
  final String? category;
  final int? categoryId;
  final String? subCategory;
  final int? subCategoryId;
  final double amount;
  final double monthlyLimit;
  final double? dailyLimit;
  final double spentThisMonth;
  final double todaySpent;
  final double monthlyProgress;
  final double dailyOverAmount;
  final String frequencyType;
  final int frequencyValue;

  const EstimatedExpenseModel({
    required this.id,
    this.category,
    this.categoryId,
    this.subCategory,
    this.subCategoryId,
    required this.amount,
    this.monthlyLimit = 0,
    this.dailyLimit,
    this.spentThisMonth = 0,
    this.todaySpent = 0,
    this.monthlyProgress = 0,
    this.dailyOverAmount = 0,
    required this.frequencyType,
    required this.frequencyValue,
  });

  factory EstimatedExpenseModel.fromJson(Map<String, dynamic> json) {
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
    return EstimatedExpenseModel(
      id: _asInt(json['id']),
      category: catName,
      categoryId: json['category'] is Map
          ? _asIntNullable(json['category']['id'])
          : _asIntNullable(json['categoryId']),
      subCategory: subCatName,
      subCategoryId: json['subCategory'] is Map
          ? _asIntNullable(json['subCategory']['id'])
          : _asIntNullable(json['subCategoryId']),
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'categoryId': categoryId,
      'subCategoryId': subCategoryId,
      'amount': amount,
      'monthlyLimit': monthlyLimit,
      'dailyLimit': dailyLimit,
      'frequencyType': frequencyType,
      'frequencyValue': frequencyValue,
    };
  }

  EstimatedExpenseEntity toEntity() {
    return EstimatedExpenseEntity(
      id: id,
      category: category,
      categoryId: categoryId,
      subCategory: subCategory,
      subCategoryId: subCategoryId,
      amount: amount,
      monthlyLimit: monthlyLimit,
      dailyLimit: dailyLimit,
      spentThisMonth: spentThisMonth,
      todaySpent: todaySpent,
      monthlyProgress: monthlyProgress,
      dailyOverAmount: dailyOverAmount,
      frequencyType: frequencyType,
      frequencyValue: frequencyValue,
    );
  }
}

class SpendingPlanModel {
  final int id;
  final double totalAmount;
  final double savingTargetAmount;
  final double estimatedExpenseTotal;
  final double availableSpendingAmount;
  final String status;
  final String riskLevel;
  final List<EstimatedExpenseModel> estimatedExpenses;

  const SpendingPlanModel({
    required this.id,
    required this.totalAmount,
    required this.savingTargetAmount,
    required this.estimatedExpenseTotal,
    required this.availableSpendingAmount,
    required this.status,
    required this.riskLevel,
    required this.estimatedExpenses,
  });

  factory SpendingPlanModel.fromJson(Map<String, dynamic> json) {
    final rawEstimatedExpenses =
        json['estimatedExpenses'] ?? json['fixedExpenses'];
    return SpendingPlanModel(
      id: _asInt(json['id']),
      totalAmount: _asDouble(json['totalAmount']),
      savingTargetAmount: _asDouble(json['savingTargetAmount']),
      estimatedExpenseTotal: _asDouble(
        json['estimatedExpenseTotal'] ?? json['fixedExpenseTotal'],
      ),
      availableSpendingAmount: _asDouble(json['availableSpendingAmount']),
      status: json['status']?.toString() ?? 'draft',
      riskLevel: json['riskLevel']?.toString() ?? 'warning',
      estimatedExpenses: rawEstimatedExpenses is List
          ? rawEstimatedExpenses
                .whereType<Map<String, dynamic>>()
                .map(EstimatedExpenseModel.fromJson)
                .toList()
          : const [],
    );
  }

  SpendingPlanEntity toEntity() {
    return SpendingPlanEntity(
      id: id,
      totalAmount: totalAmount,
      savingTargetAmount: savingTargetAmount,
      estimatedExpenseTotal: estimatedExpenseTotal,
      availableSpendingAmount: availableSpendingAmount,
      status: status,
      riskLevel: riskLevel,
      estimatedExpenses: estimatedExpenses
          .map((expense) => expense.toEntity())
          .toList(),
    );
  }
}

class CreateEstimatedExpenseRequest {
  final String? category;
  final int? categoryId;
  final int? subCategoryId;
  final double amount;
  final double? monthlyLimit;
  final double? dailyLimit;
  final String? frequencyType;
  final int? frequencyValue;

  const CreateEstimatedExpenseRequest({
    this.category,
    this.categoryId,
    this.subCategoryId,
    required this.amount,
    this.monthlyLimit,
    this.dailyLimit,
    this.frequencyType,
    this.frequencyValue,
  });

  Map<String, dynamic> toJson() {
    return {
      if (category != null) 'category': category,
      if (categoryId != null) 'categoryId': categoryId,
      if (subCategoryId != null) 'subCategoryId': subCategoryId,
      'amount': amount,
      if (monthlyLimit != null) 'monthlyLimit': monthlyLimit,
      'dailyLimit': dailyLimit,
      if (frequencyType != null) 'frequencyType': frequencyType,
      if (frequencyValue != null) 'frequencyValue': frequencyValue,
    };
  }
}

class CreateSpendingPlanRequest {
  final double totalAmount;
  final double savingTargetAmount;
  final List<CreateEstimatedExpenseRequest> estimatedExpenses;

  const CreateSpendingPlanRequest({
    required this.totalAmount,
    required this.savingTargetAmount,
    required this.estimatedExpenses,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalAmount': totalAmount,
      'savingTargetAmount': savingTargetAmount,
      'estimatedExpenses': estimatedExpenses
          .map((expense) => expense.toJson())
          .toList(),
    };
  }
}

class UpdateSpendingPlanRequest {
  final double? totalAmount;
  final double? savingTargetAmount;
  final List<CreateEstimatedExpenseRequest>? estimatedExpenses;

  const UpdateSpendingPlanRequest({
    this.totalAmount,
    this.savingTargetAmount,
    this.estimatedExpenses,
  });

  Map<String, dynamic> toJson() {
    return {
      if (totalAmount != null) 'totalAmount': totalAmount,
      if (savingTargetAmount != null) 'savingTargetAmount': savingTargetAmount,
      if (estimatedExpenses != null)
        'estimatedExpenses': estimatedExpenses!
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
  final double spentEstimatedAmount;
  final double remainingAmount;
  final int daysLeft;
  final double projectedEndBalance;
  final List<EstimatedExpenseModel> estimatedExpenses;

  const SpendingPlanStatsModel({
    required this.planId,
    required this.planName,
    required this.availableSpendingAmount,
    required this.spentFlexibleAmount,
    required this.spentEstimatedAmount,
    required this.remainingAmount,
    required this.daysLeft,
    required this.projectedEndBalance,
    required this.estimatedExpenses,
  });

  factory SpendingPlanStatsModel.fromJson(Map<String, dynamic> json) {
    final rawEstimatedExpenses =
        json['estimatedExpenses'] ?? json['fixedExpenses'];
    return SpendingPlanStatsModel(
      planId: _asInt(json['planId']),
      planName: json['planName']?.toString() ?? '',
      availableSpendingAmount: _asDouble(json['availableSpendingAmount']),
      spentFlexibleAmount: _asDouble(json['spentFlexibleAmount']),
      spentEstimatedAmount: _asDouble(
        json['spentEstimatedAmount'] ?? json['spentFixedAmount'],
      ),
      remainingAmount: _asDouble(json['remainingAmount']),
      daysLeft: _asInt(json['daysLeft']),
      projectedEndBalance: _asDouble(json['projectedEndBalance']),
      estimatedExpenses: rawEstimatedExpenses is List
          ? rawEstimatedExpenses
                .map((e) => Map<String, dynamic>.from(e as Map))
                .map(EstimatedExpenseModel.fromJson)
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
      spentEstimatedAmount: spentEstimatedAmount,
      remainingAmount: remainingAmount,
      daysLeft: daysLeft,
      projectedEndBalance: projectedEndBalance,
      estimatedExpenses: estimatedExpenses.map((e) => e.toEntity()).toList(),
    );
  }
}
