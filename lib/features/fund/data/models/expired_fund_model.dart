import 'package:freezed_annotation/freezed_annotation.dart';

part 'expired_fund_model.freezed.dart';
part 'expired_fund_model.g.dart';

@freezed
abstract class ExpiredFundInfoModel with _$ExpiredFundInfoModel {
  const factory ExpiredFundInfoModel({
    required int id,
    required String name,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'completion_percentage') @Default(0) int completionPercentage,
    @JsonKey(name: 'total_spent') @Default(0) double totalSpent,
    @Default(0) double target,
    @Default(0) double balance,
  }) = _ExpiredFundInfoModel;

  factory ExpiredFundInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ExpiredFundInfoModelFromJson(json);
}

@freezed
abstract class ExpiredFundCheckModel with _$ExpiredFundCheckModel {
  const factory ExpiredFundCheckModel({
    @JsonKey(name: 'has_expired_fund') @Default(false) bool hasExpiredFund,
    @JsonKey(name: 'expired_fund') ExpiredFundInfoModel? expiredFund,
  }) = _ExpiredFundCheckModel;

  factory ExpiredFundCheckModel.fromJson(Map<String, dynamic> json) =>
      _$ExpiredFundCheckModelFromJson(json);
}
