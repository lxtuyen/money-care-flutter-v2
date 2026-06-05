import 'package:money_care/features/statistics/data/models/analytics_model.dart';

abstract class AnalyticsRepository {
  Future<AnalyticsModel> getFinancialAnalytics();
}
