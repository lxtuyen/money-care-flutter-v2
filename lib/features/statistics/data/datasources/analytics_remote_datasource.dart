import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/features/statistics/data/models/analytics_model.dart';

abstract class AnalyticsRemoteDataSource {
  Future<AnalyticsModel> getFinancialAnalytics({
    int? targetMonth,
    int? targetYear,
  });
}

class AnalyticsRemoteDataSourceImpl implements AnalyticsRemoteDataSource {
  final ApiClient api;

  AnalyticsRemoteDataSourceImpl({required this.api});

  @override
  Future<AnalyticsModel> getFinancialAnalytics({
    int? targetMonth,
    int? targetYear,
  }) async {
    final res = await api.get<AnalyticsModel>(
      ApiRoutes.financialAnalytics,
      queryParameters: {'targetMonth': targetMonth, 'targetYear': targetYear},
      fromJsonT: (json) =>
          AnalyticsModel.fromJson(json as Map<String, dynamic>),
    );
    return res.unwrap();
  }
}
