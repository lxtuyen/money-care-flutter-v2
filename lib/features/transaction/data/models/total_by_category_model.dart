import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_care/core/utils/helper/num_parser.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

part 'total_by_category_model.freezed.dart';
part 'total_by_category_model.g.dart';

@freezed
abstract class TotalByCategoryEntityModel with _$TotalByCategoryEntityModel {
  const factory TotalByCategoryEntityModel({
    @JsonKey(name: 'category_id', fromJson: NumParser.parseIntNullable)
    int? categoryId,
    @Default('') String categoryName,
    @Default('') String categoryIcon,
    @JsonKey(fromJson: NumParser.parseDouble) @Default(0.0) double percentage,
    @JsonKey(fromJson: NumParser.parseDouble)
    @Default(0.0)
    double spendingPercentage,
    @JsonKey(fromJson: NumParser.parseDouble) @Default(0.0) double limit,
    @JsonKey(fromJson: NumParser.parseInt) @Default(0) int total,
    @Default(true) bool isEssential,
  }) = _TotalByCategoryEntityModel;

  const TotalByCategoryEntityModel._();

  factory TotalByCategoryEntityModel.fromJson(Map<String, dynamic> json) =>
      _$TotalByCategoryEntityModelFromJson(json);

  TotalByCategoryEntity toEntity() => TotalByCategoryEntity(
        categoryId: categoryId,
        categoryName: categoryName,
        total: total,
        categoryIcon: categoryIcon,
        percentage: percentage,
        spendingPercentage: spendingPercentage,
        limit: limit,
        isEssential: isEssential,
        color: null,
      );
}


