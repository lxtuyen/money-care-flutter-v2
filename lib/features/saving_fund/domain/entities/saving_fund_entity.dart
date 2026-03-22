import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class SavingFundEntity {
  final int id;
  final String name;
  final bool? isSelected;
  final List<CategoryEntity> categories;

  const SavingFundEntity({
    required this.id,
    required this.name,
    this.isSelected,
    required this.categories,
  });
}
