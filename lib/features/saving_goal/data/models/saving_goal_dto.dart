import 'package:freezed_annotation/freezed_annotation.dart';

part 'saving_goal_dto.freezed.dart';

@freezed
abstract class SavingGoalDto with _$SavingGoalDto {
  const factory SavingGoalDto({
    String? name,
    int? id,
    int? userId,
    double? target,
    @JsonKey(name: 'saved_amount') double? savedAmount,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,

    @JsonKey(name: 'is_completed') bool? isCompleted,
    int? walletId,
    @JsonKey(name: 'create_new_wallet') bool? createNewWallet,
    @JsonKey(name: 'is_budget_enabled') bool? isBudgetEnabled,
  }) = _SavingGoalDto;

  const SavingGoalDto._();

  Map<String, dynamic> toJsonCreate() {
    final map = {
      'name': name,
      'userId': userId,
      'target': target,
      'saved_amount': savedAmount,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),

      'walletId': walletId,
      'create_new_wallet': createNewWallet,
      'is_budget_enabled': isBudgetEnabled,
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }

  Map<String, dynamic> toJsonUpdate() {
    final map = {
      'name': name,
      'target': target,
      'saved_amount': savedAmount,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),

      'is_completed': isCompleted,
      'walletId': walletId,
      'is_budget_enabled': isBudgetEnabled,
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }
}
