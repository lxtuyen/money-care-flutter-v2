import 'package:money_care/features/transaction/data/models/transaction_model.dart';

class RecurringTransactionModel {
  final int id;
  final double amount;
  final String type;
  final String frequency;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? lastExecutedDate;
  final bool isActive;
  final String? note;
  final CategoryModel? category;

  RecurringTransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.frequency,
    required this.startDate,
    this.endDate,
    this.lastExecutedDate,
    required this.isActive,
    this.note,
    this.category,
  });

  factory RecurringTransactionModel.fromJson(Map<String, dynamic> json) {
    return RecurringTransactionModel(
      id: json['id'],
      amount: double.parse(json['amount'].toString()),
      type: json['type'],
      frequency: json['frequency'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      lastExecutedDate: json['lastExecutedDate'] != null
          ? DateTime.parse(json['lastExecutedDate'])
          : null,
      isActive: json['isActive'] ?? true,
      note: json['note'],
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'frequency': frequency,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'lastExecutedDate': lastExecutedDate?.toIso8601String(),
      'isActive': isActive,
      'note': note,
      'category': category?.toJson(),
    };
  }
}

class CreateRecurringTransactionDto {
  final double amount;
  final String type;
  final String frequency;
  final DateTime startDate;
  final DateTime? endDate;
  final String? note;
  final int userId;
  final int? categoryId;

  CreateRecurringTransactionDto({
    required this.amount,
    required this.type,
    required this.frequency,
    required this.startDate,
    this.endDate,
    this.note,
    required this.userId,
    this.categoryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'type': type,
      'frequency': frequency,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'note': note,
      'userId': userId,
      'categoryId': categoryId,
    };
  }
}
