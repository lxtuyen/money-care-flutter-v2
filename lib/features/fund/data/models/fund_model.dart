import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_care/features/fund/domain/entities/fund_entity.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';

part 'fund_model.freezed.dart';
part 'fund_model.g.dart';

@freezed
class FundModel with _$FundModel {
  const factory FundModel({
    required int id,
    required String name,
    String? type,
    @JsonKey(name: 'is_selected') bool? isSelected,
    required List<CategoryModel> categories,

    // SPENDING
    double? balance,
    @JsonKey(name: 'monthly_limit') double? monthlyLimit,
    @JsonKey(name: 'spent_current_month') @Default(0) double spentCurrentMonth,
    @JsonKey(name: 'notified_70') @Default(false) bool notified70,
    @JsonKey(name: 'notified_90') @Default(false) bool notified90,

    // SAVING GOAL
    double? target,
    @JsonKey(name: 'saved_amount') @Default(0) double savedAmount,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
    @JsonKey(name: 'template_key') String? templateKey,

    // Common
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    String? status,
  }) = _FundModel;

  const FundModel._();

  factory FundModel.fromJson(Map<String, dynamic> json) =>
      _$FundModelFromJson(json);

  FundEntity toEntity() {
    FundType ft = FundType.spending;
    if (type == 'SAVING_GOAL') ft = FundType.savingGoal;

    return FundEntity(
      id: id,
      name: name,
      type: ft,
      isSelected: isSelected,
      categories: categories.map((e) => e.toEntity()).toList(),
      balance: balance,
      monthlyLimit: monthlyLimit,
      spentCurrentMonth: spentCurrentMonth,
      notified70: notified70,
      notified90: notified90,
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
