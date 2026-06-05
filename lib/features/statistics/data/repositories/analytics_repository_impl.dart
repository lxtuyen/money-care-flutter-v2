import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/statistics/data/models/analytics_model.dart';
import 'package:money_care/features/statistics/domain/repositories/analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final ApiClient api;

  const AnalyticsRepositoryImpl({required this.api});

  @override
  Future<AnalyticsModel> getFinancialAnalytics() async {
    final res = await api.get<AnalyticsModel>(
      ApiRoutes.financialAnalytics,
      fromJsonT: (json) => AnalyticsModel.fromJson(json as Map<String, dynamic>),
    );
    return res.unwrap();
  }
}
