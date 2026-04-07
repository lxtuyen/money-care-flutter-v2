import 'package:money_care/features/gamification/domain/entities/gamification_entity.dart';

class BadgeModel {
  final String key;
  final String name;
  final DateTime awardedAt;

  const BadgeModel({
    required this.key,
    required this.name,
    required this.awardedAt,
  });

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      key: json['key'] as String,
      name: json['name'] as String,
      awardedAt: DateTime.parse(json['awardedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'key': key,
        'name': name,
        'awardedAt': awardedAt.toIso8601String(),
      };

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
