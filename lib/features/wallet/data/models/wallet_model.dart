import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_care/core/utils/helper/num_parser.dart';
import 'package:money_care/features/wallet/domain/entities/wallet_entity.dart';
import 'package:money_care/features/saving_goal/data/models/saving_goal_model.dart';

part 'wallet_model.freezed.dart';
part 'wallet_model.g.dart';

@freezed
abstract class WalletModel with _$WalletModel {
  const factory WalletModel({
    @JsonKey(fromJson: NumParser.parseInt) required int id,
    required String name,
    @JsonKey(fromJson: NumParser.parseDouble) @Default(0) double balance,
    String? icon,
    String? color,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @Default('regular') String type,
    @Default([]) List<SavingGoalModel> savingGoals,
  }) = _WalletModel;

  const WalletModel._();

  factory WalletModel.fromJson(Map<String, dynamic> json) =>
      _$WalletModelFromJson(json);

  WalletEntity toEntity() {
    return WalletEntity(
      id: id,
      name: name,
      balance: balance,
      icon: icon,
      color: color,
      isActive: isActive,
      type: type,
      savingGoals: savingGoals.map((e) => e.toEntity()).toList(),
    );
  }
}
