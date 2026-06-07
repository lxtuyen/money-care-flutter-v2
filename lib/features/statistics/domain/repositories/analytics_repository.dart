import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/statistics/data/models/analytics_model.dart';

abstract class AnalyticsRepository {
  Future<Either<Failure, AnalyticsModel>> getFinancialAnalytics({
    int? targetMonth,
    int? targetYear,
  });
}
