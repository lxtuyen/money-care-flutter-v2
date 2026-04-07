import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_care/features/finance_mode/domain/entities/finance_mode_entity.dart';

part 'finance_mode_model.freezed.dart';
part 'finance_mode_model.g.dart';

String _modeToJson(String mode) => mode.toUpperCase();

@freezed
class FinanceModeModel with _$FinanceModeModel {
  const factory FinanceModeModel({
    required int userId,
    @JsonKey(toJson: _modeToJson) required String mode,
    required DateTime updatedAt,
    DateTime? suggestionCooldownUntil,
  }) = _FinanceModeModel;

  const FinanceModeModel._();

  factory FinanceModeModel.fromJson(Map<String, dynamic> json) =>
      _$FinanceModeModelFromJson(json);

  Map<String, dynamic> toUpdateDto() => {
        'mode': mode.toUpperCase(),
        'suggestionCooldownUntil': suggestionCooldownUntil?.toIso8601String(),
      };

  factory FinanceModeModel.fromEntity(FinanceModeEntity entity) {
    return FinanceModeModel(
      userId: entity.userId,
      mode: entity.mode.name,
      updatedAt: entity.updatedAt,
      suggestionCooldownUntil: entity.suggestionCooldownUntil,
    );
  }

  FinanceModeEntity toEntity() => FinanceModeEntity(
        userId: userId,
        mode: FinanceMode.values.firstWhere(
          (e) => e.name.toUpperCase() == mode.toUpperCase(),
          orElse: () => FinanceMode.normal,
        ),
        updatedAt: updatedAt,
        suggestionCooldownUntil: suggestionCooldownUntil,
      );
}
