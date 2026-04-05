import 'package:money_care/features/finance_mode/domain/entities/finance_mode_entity.dart';

class FinanceModeModel {
  final int userId;
  final String mode;
  final DateTime updatedAt;
  final DateTime? suggestionCooldownUntil;

  const FinanceModeModel({
    required this.userId,
    required this.mode,
    required this.updatedAt,
    this.suggestionCooldownUntil,
  });

  factory FinanceModeModel.fromJson(Map<String, dynamic> json) {
    return FinanceModeModel(
      userId: json['userId'] as int,
      mode: json['mode'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      suggestionCooldownUntil: json['suggestionCooldownUntil'] != null
          ? DateTime.parse(json['suggestionCooldownUntil'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'mode': mode.toUpperCase(),
        'updatedAt': updatedAt.toIso8601String(),
        'suggestionCooldownUntil': suggestionCooldownUntil?.toIso8601String(),
      };

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
