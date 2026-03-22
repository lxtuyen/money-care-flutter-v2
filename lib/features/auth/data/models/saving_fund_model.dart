import 'package:money_care/features/auth/domain/entities/saving_fund_entity.dart';

class SavingFundModel {
  final int id;
  final String name;
  bool? isSelected;

  SavingFundModel({
    required this.id,
    required this.name,
    this.isSelected,
  });

  factory SavingFundModel.fromMap(Map<String, dynamic> json) {
    return SavingFundModel(
      id: json['id'],
      name: json['name'],
      isSelected: json['is_selected'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'is_selected': isSelected,
    };
  }

  SavingFundEntity toEntity() => SavingFundEntity(
    id: id,
    name: name,
    isSelected: isSelected,
  );
}
