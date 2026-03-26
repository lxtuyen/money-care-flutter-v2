import 'package:money_care/features/saving_fund/domain/entities/saving_fund_entity.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';

class SavingFundModel {
  final int id;
  final String name;
  bool? isSelected;
  final List<CategoryModel> categories;
  final double? amount;
  final DateTime? start_date;
  final DateTime? end_date;

  SavingFundModel({
    required this.id,
    required this.name,
    this.isSelected,
    required this.categories,
    this.amount,
    this.start_date,
    this.end_date,
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
      amount:
          json['amount'] != null ? double.tryParse(json['amount'].toString()) : null,
      start_date:
          json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      end_date: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'is_selected': isSelected,
      'categories': categories.map((e) => e.toJson()).toList(),
      'amount': amount,
      'start_date': start_date?.toIso8601String(),
      'end_date': end_date?.toIso8601String(),
    };
  }

  SavingFundEntity toEntity() => SavingFundEntity(
    id: id,
    name: name,
    isSelected: isSelected,
    categories: categories.map((e) => e.toEntity()).toList(),
    amount: amount,
    start_date: start_date,
    end_date: end_date,
  );
}
