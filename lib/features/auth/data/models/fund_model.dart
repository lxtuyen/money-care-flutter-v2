import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_care/features/fund/domain/entities/fund_entity.dart';
import 'package:money_care/features/transaction/data/models/category_model.dart';

part 'fund_model.freezed.dart';
part 'fund_model.g.dart';

@freezed
abstract class FundModel with _$FundModel {
  const factory FundModel({
    required int id,
    required String name,
    @JsonKey(name: 'is_selected') bool? isSelected,
    @Default([]) List<CategoryModel> categories,
  }) = _FundModel;

  const FundModel._();

  factory FundModel.fromJson(Map<String, dynamic> json) =>
      _$FundModelFromJson(json);

  FundEntity toEntity() => FundEntity(
        id: id,
        name: name,
        isSelected: isSelected,
        categories: categories.map((e) => e.toEntity()).toList(),
      );
}
