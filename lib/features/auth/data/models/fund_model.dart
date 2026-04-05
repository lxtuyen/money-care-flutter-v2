import 'package:money_care/features/fund/domain/entities/fund_entity.dart';
import 'package:money_care/features/transaction/data/models/category_model.dart';

class FundModel {
  final int id;
  final String name;
  bool? isSelected;
  final List<CategoryModel> categories;

  FundModel({
    required this.id,
    required this.name,
    this.isSelected,
    this.categories = const [],
  });

  factory FundModel.fromMap(Map<String, dynamic> json) {
    return FundModel(
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

  FundEntity toEntity() => FundEntity(
    id: id,
    name: name,
    isSelected: isSelected,
    categories: categories.map((e) => e.toEntity()).toList(),
  );
}
