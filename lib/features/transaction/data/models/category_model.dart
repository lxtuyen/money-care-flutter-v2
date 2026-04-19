import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_care/core/utils/helper/num_parser.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

class ColorConverter implements JsonConverter<Color?, dynamic> {
  const ColorConverter();

  @override
  Color? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is int) return Color(json);
    if (json is String) {
      final hexCode = json.replaceAll('#', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    }
    return null;
  }

  @override
  dynamic toJson(Color? color) => color?.value;
}

@freezed
abstract class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    @JsonKey(fromJson: NumParser.parseIntNullable) int? id,
    required String name,
    @JsonKey(fromJson: NumParser.parseInt) @Default(0) int percentage,
    @Default('') String icon,
    @ColorConverter() Color? color,
    @Default(true) bool isEssential,
    String? type,
  }) = _CategoryModel;

  const CategoryModel._();

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  CategoryEntity toEntity() => CategoryEntity(
        id: id,
        name: name,
        percentage: percentage,
        icon: icon,
        color: color,
        isEssential: isEssential,
        type: type,
      );
}


