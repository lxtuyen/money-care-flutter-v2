import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_care/core/utils/helper/num_parser.dart';

part 'expired_goal_model.freezed.dart';
part 'expired_goal_model.g.dart';

@freezed
abstract class ExpiredGoalInfoModel with _$ExpiredGoalInfoModel {
  const factory ExpiredGoalInfoModel({
    @JsonKey(fromJson: NumParser.parseInt) required int id,
    required String name,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'completion_percentage', fromJson: NumParser.parseInt)
    @Default(0)
    int completionPercentage,
    @JsonKey(name: 'total_spent', fromJson: NumParser.parseDouble)
    @Default(0)
    double totalSpent,
    @JsonKey(fromJson: NumParser.parseDouble) @Default(0) double target,
    @JsonKey(fromJson: NumParser.parseDouble) @Default(0) double balance,
  }) = _ExpiredGoalInfoModel;

  factory ExpiredGoalInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ExpiredGoalInfoModelFromJson(json);
}

@freezed
abstract class ExpiredGoalCheckModel with _$ExpiredGoalCheckModel {
  const factory ExpiredGoalCheckModel({
    @JsonKey(name: 'has_expired_fund') @Default(false) bool hasExpiredGoal,
    @JsonKey(name: 'expired_fund') ExpiredGoalInfoModel? expiredGoal,
  }) = _ExpiredGoalCheckModel;

  factory ExpiredGoalCheckModel.fromJson(Map<String, dynamic> json) =>
      _$ExpiredGoalCheckModelFromJson(json);
}
