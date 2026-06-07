import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/features/statistics/data/models/analytics_model.dart';

abstract class AnalyticsRemoteDataSource {
  Future<AnalyticsModel> getFinancialAnalytics();
}

class AnalyticsRemoteDataSourceImpl implements AnalyticsRemoteDataSource {
  final ApiClient api;

  AnalyticsRemoteDataSourceImpl({required this.api});

  @override
  Future<AnalyticsModel> getFinancialAnalytics() async {
    final res = await api.get<AnalyticsModel>(
      ApiRoutes.financialAnalytics,
      fromJsonT: (json) => AnalyticsModel.fromJson(json as Map<String, dynamic>),
    );
    return res.unwrap();
  }
}
