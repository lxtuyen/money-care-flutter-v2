import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/statistics/data/models/analytics_model.dart';
import 'package:money_care/features/statistics/domain/repositories/analytics_repository.dart';

class GetFinancialAnalyticsUseCase {
  final AnalyticsRepository repository;

  const GetFinancialAnalyticsUseCase(this.repository);

  Future<Either<Failure, AnalyticsModel>> call() {
    return repository.getFinancialAnalytics();
  }
}
