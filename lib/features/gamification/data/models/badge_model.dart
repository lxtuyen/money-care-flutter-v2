import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_care/features/gamification/domain/entities/gamification_entity.dart';

part 'badge_model.freezed.dart';
part 'badge_model.g.dart';

@freezed
class BadgeModel with _$BadgeModel {
  const factory BadgeModel({
    required String key,
    required String name,
    required DateTime awardedAt,
  }) = _BadgeModel;

  const BadgeModel._();

  factory BadgeModel.fromJson(Map<String, dynamic> json) =>
      _$BadgeModelFromJson(json);

  factory BadgeModel.fromEntity(BadgeEntity entity) {
    return BadgeModel(
      key: entity.key,
      name: entity.name,
      awardedAt: entity.awardedAt,
    );
  }

  BadgeEntity toEntity() => BadgeEntity(
        key: key,
        name: name,
        awardedAt: awardedAt,
      );
}
