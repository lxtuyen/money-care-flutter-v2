import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_care/core/utils/helper/num_parser.dart';
import 'package:money_care/features/saving_goal/domain/entities/saving_goal_entity.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';

part 'saving_goal_model.freezed.dart';
part 'saving_goal_model.g.dart';

@freezed
abstract class SavingGoalModel with _$SavingGoalModel {
  const factory SavingGoalModel({
    @JsonKey(fromJson: NumParser.parseInt) required int id,
    required String name,
    @JsonKey(name: 'is_selected') bool? isSelected,
    List<CategoryModel>? categories,

    @JsonKey(fromJson: NumParser.parseDoubleNullable) double? target,
    @JsonKey(name: 'saved_amount', fromJson: NumParser.parseDouble)
    @Default(0)
    double savedAmount,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
    @JsonKey(name: 'template_key') String? templateKey,

    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    String? status,
  }) = _SavingGoalModel;

  const SavingGoalModel._();

  factory SavingGoalModel.fromJson(Map<String, dynamic> json) =>
      _$SavingGoalModelFromJson(json);

  SavingGoalEntity toEntity() {
    return SavingGoalEntity(
      id: id,
      name: name,
      isSelected: isSelected,
      categories: categories?.map((e) => e.toEntity()).toList() ?? [],
      target: target,
      savedAmount: savedAmount,
      isCompleted: isCompleted,
      templateKey: templateKey,
      startDate: startDate,
      endDate: endDate,
      status: status,
    );
  }
}
