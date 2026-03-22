import 'package:money_care/features/transaction/data/models/total_by_date_model.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class TotalsByDateEntityModel {
  final List<TotalByDateEntityModel> income;
  final List<TotalByDateEntityModel> expense;

  TotalsByDateEntityModel({required this.income, required this.expense});

  factory TotalsByDateEntityModel.fromJson(Map<String, dynamic> json) {
    return TotalsByDateEntityModel(
      income: (json['income'] as List<dynamic>? ?? [])
          .map((e) => TotalByDateEntityModel.fromJson(e))
          .toList(),
      expense: (json['expense'] as List<dynamic>? ?? [])
          .map((e) => TotalByDateEntityModel.fromJson(e))
          .toList(),
    );
  }

  TotalsByDateEntity toEntity() => TotalsByDateEntity(
    income: income.map((e) => e.toEntity()).toList(),
    expense: expense.map((e) => e.toEntity()).toList(),
  );
}
