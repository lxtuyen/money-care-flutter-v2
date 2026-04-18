import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/errors/exceptions.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/gamification/data/models/gamification_model.dart';

abstract class GamificationRemoteDatasource {
  Future<GamificationModel> getGamification(int userId);

  Future<GamificationModel> recordDay(int userId, DateTime date);
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
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty
            ? res.message
            : 'Không thể tải dữ liệu gamification',
      );
    }
    return res.data!;
  }

  @override
  Future<GamificationModel> recordDay(int userId, DateTime date) async {
    final dateOnly = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    
    final res = await api.post<GamificationModel>(
      '${ApiRoutes.gamification}/record-day',
      body: {
        'date': dateOnly,
      },
      fromJsonT: (json) =>
          GamificationModel.fromJson(json as Map<String, dynamic>),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty
            ? res.message
            : 'Không thể ghi nhận giao dịch ngày',
      );
    }
    return res.data!;
  }
}


