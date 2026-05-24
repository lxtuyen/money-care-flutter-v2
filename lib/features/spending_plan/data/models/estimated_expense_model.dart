import 'package:money_care/features/spending_plan/data/models/model_parse_utils.dart';
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
      id: asInt(json['id']),
      category: catName,
      categoryId: json['category'] is Map
          ? asIntNullable(json['category']['id'])
          : asIntNullable(json['categoryId']),
      subCategory: subCatName,
      subCategoryId: json['subCategory'] is Map
          ? asIntNullable(json['subCategory']['id'])
          : asIntNullable(json['subCategoryId']),
      amount: asDouble(json['amount']),
      monthlyLimit: asDouble(json['monthlyLimit']),
      dailyLimit: json['dailyLimit'] == null
          ? null
          : asDouble(json['dailyLimit']),
      spentThisMonth: asDouble(json['spentThisMonth']),
      todaySpent: asDouble(json['todaySpent']),
      monthlyProgress: asDouble(json['monthlyProgress']),
      dailyOverAmount: asDouble(json['dailyOverAmount']),
      frequencyType: json['frequencyType']?.toString() ?? 'once',
      frequencyValue: asInt(json['frequencyValue'] ?? 1),
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

  EstimatedExpenseModel copyWith({
    int? id,
    String? category,
    int? categoryId,
    String? subCategory,
    int? subCategoryId,
    double? amount,
    double? monthlyLimit,
    double? dailyLimit,
    double? spentThisMonth,
    double? todaySpent,
    double? monthlyProgress,
    double? dailyOverAmount,
    String? frequencyType,
    int? frequencyValue,
  }) {
    return EstimatedExpenseModel(
      id: id ?? this.id,
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      subCategory: subCategory ?? this.subCategory,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      amount: amount ?? this.amount,
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
      dailyLimit: dailyLimit ?? this.dailyLimit,
      spentThisMonth: spentThisMonth ?? this.spentThisMonth,
      todaySpent: todaySpent ?? this.todaySpent,
      monthlyProgress: monthlyProgress ?? this.monthlyProgress,
      dailyOverAmount: dailyOverAmount ?? this.dailyOverAmount,
      frequencyType: frequencyType ?? this.frequencyType,
      frequencyValue: frequencyValue ?? this.frequencyValue,
    );
  }

  double getMonthlyAmount({int? daysInMonth}) {
    final now = DateTime.now();
    final days = daysInMonth ?? DateTime(now.year, now.month + 1, 0).day;
    switch (frequencyType) {
      case 'daily':
        return amount * frequencyValue * days;
      case 'weekly':
        return amount * frequencyValue * (days / 7);
      case 'monthly':
      default:
        return amount * frequencyValue;
    }
  }
}


