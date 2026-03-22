import 'package:money_care/features/transaction/data/models/transaction_model.dart';

class SavingFundDto {
  final String? name;
  final List<CategoryModel>? categories;
  final int? id;

  SavingFundDto({this.name, this.categories, this.id});

  Map<String, dynamic> toJsonCreate() {
    return {
      'name': name,
      'categories': categories?.map((e) => e.toJson()).toList(),
      'userId': id,
    };
  }

  Map<String, dynamic> toJsonUpdate() {
    return {
      'name': name,
      'categories': categories?.map((e) => e.toJson()).toList(),
    };
  }
}
