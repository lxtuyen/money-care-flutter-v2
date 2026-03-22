import 'package:money_care/features/saving_fund/domain/entities/saving_fund_entity.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';

class SavingFundModel {
  final int id;
  final String name;
  bool? isSelected;
  final List<CategoryModel> categories;

  SavingFundModel({
    required this.id,
    required this.name,
    this.isSelected,
    required this.categories,
  });

  factory SavingFundModel.fromMap(Map<String, dynamic> json) {
    return SavingFundModel(
      id: json['id'],
      name: json['name'],
      isSelected: json['is_selected'],
      categories: json['categories'] != null
          ? List<CategoryModel>.from(
              json['categories'].map((x) => CategoryModel.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'is_selected': isSelected,
      'categories': categories.map((e) => e.toJson()).toList(),
    };
  }

  SavingFundEntity toEntity() => SavingFundEntity(
    id: id,
    name: name,
    isSelected: isSelected,
    categories: categories.map((e) => e.toEntity()).toList(),
  );
}
