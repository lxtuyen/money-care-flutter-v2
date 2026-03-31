import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class SavingFundEntity {
  final int id;
  final String name;
  final bool? isSelected;
  final List<CategoryEntity> categories;
  final double? budget;
  final double? target;
  final DateTime? start_date;
  final DateTime? end_date;

  const SavingFundEntity({
    required this.id,
    required this.name,
    this.isSelected,
    required this.categories,
    this.budget,
    this.target,
    this.start_date,
    this.end_date,
  });
}
