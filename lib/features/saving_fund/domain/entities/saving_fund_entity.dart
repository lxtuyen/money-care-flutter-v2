import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class SavingFundEntity {
  final int id;
  final String name;
  final bool? isSelected;
  final List<CategoryEntity> categories;
  final double? targetAmount;
  final DateTime? startDate;
  final DateTime? endDate;

  const SavingFundEntity({
    required this.id,
    required this.name,
    this.isSelected,
    required this.categories,
    this.targetAmount,
    this.startDate,
    this.endDate,
  });
}
