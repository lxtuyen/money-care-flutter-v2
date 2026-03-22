import 'package:money_care/features/transaction/domain/entities/total_by_date_entity.dart';

class TotalsByDateEntity {
  final List<TotalByDateEntity> income;
  final List<TotalByDateEntity> expense;

  const TotalsByDateEntity({required this.income, required this.expense});
}
