import 'package:money_care/features/saving_fund/domain/entities/saving_fund_entity.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';

class SavingFundModel {
  final int id;
  final String name;
  bool? isSelected;
  final List<CategoryModel> categories;
  final double? targetAmount;
  final DateTime? startDate;
  final DateTime? endDate;

  SavingFundModel({
    required this.id,
    required this.name,
    this.isSelected,
    required this.categories,
    this.targetAmount,
    this.startDate,
    this.endDate,
  });

  factory SavingFundModel.fromMap(Map<String, dynamic> json) {
    return SavingFundModel(
      id: json['id'],
      name: json['name'],
      isSelected: json['is_selected'],
      categories:
          json['categories'] != null
              ? List<CategoryModel>.from(
                json['categories'].map((x) => CategoryModel.fromJson(x)),
              )
              : [],
      targetAmount:
          json['targetAmount']?.toDouble(),
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'is_selected': isSelected,
      'categories': categories.map((e) => e.toJson()).toList(),
      'targetAmount': targetAmount,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  SavingFundEntity toEntity() => SavingFundEntity(
    id: id,
    name: name,
    isSelected: isSelected,
    categories: categories.map((e) => e.toEntity()).toList(),
    targetAmount: targetAmount,
    startDate: startDate,
    endDate: endDate,
  );
}
