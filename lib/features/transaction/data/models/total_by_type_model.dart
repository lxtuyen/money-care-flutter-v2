import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class TotalByTypeModel {
  final int income;
  final int expense;
  final int currentSaving;
  final int targetSaving;

  TotalByTypeModel({
    required this.income,
    required this.expense,
    required this.currentSaving,
    required this.targetSaving,
  });

  factory TotalByTypeModel.fromJson(Map<String, dynamic> json) {
    return TotalByTypeModel(
      income: (json['income_total'] ?? 0).toInt(),
      expense: (json['expense_total'] ?? 0).toInt(),
      currentSaving: (json['current_saving'] ?? 0).toInt(),
      targetSaving: (json['target_saving'] ?? 0).toInt(),
    );
  }

  TotalByTypeEntity toEntity() => TotalByTypeEntity(
        incomeTotal: income,
        expenseTotal: expense,
        currentSaving: currentSaving,
        targetSaving: targetSaving,
      );
}
