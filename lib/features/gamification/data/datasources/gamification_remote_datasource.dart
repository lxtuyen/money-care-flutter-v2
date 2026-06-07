import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/gamification/data/models/gamification_model.dart';
import 'package:money_care/features/gamification/domain/entities/gamification_entity.dart';

abstract class GamificationRemoteDatasource {
  Future<GamificationModel> getGamification(int userId);

  Future<GamificationModel> recordDay(int userId, DateTime date, {BadgeEntity? badge});
}

class GamificationRemoteDatasourceImpl implements GamificationRemoteDatasource {
  final ApiClient api;

  GamificationRemoteDatasourceImpl({required this.api});

  @override
  Future<GamificationModel> getGamification(int userId) async {
    final res = await api.get<GamificationModel>(
      ApiRoutes.gamification,
      queryParameters: {'userId': userId},
      fromJsonT: (json) =>
          GamificationModel.fromJson(json as Map<String, dynamic>),
    );
    return res.unwrap();
  }

  @override
  Future<GamificationModel> recordDay(int userId, DateTime date, {BadgeEntity? badge}) async {
    final dateOnly =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    final body = <String, dynamic>{
      'date': dateOnly,
    };
    if (badge != null) {
      body['badge'] = {
        'key': badge.key,
        'name': badge.name,
        'awardedAt': badge.awardedAt.toIso8601String(),
      };
    }

    final res = await api.post<GamificationModel>(
      '${ApiRoutes.gamification}/record-day',
      body: body,
      fromJsonT: (json) =>
          GamificationModel.fromJson(json as Map<String, dynamic>),
    );
    return res.unwrap();
  }
}
