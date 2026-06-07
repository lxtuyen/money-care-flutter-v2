import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/exceptions.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/statistics/data/datasources/analytics_remote_datasource.dart';
import 'package:money_care/features/statistics/data/models/analytics_model.dart';
import 'package:money_care/features/statistics/domain/repositories/analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDataSource remoteDataSource;

  const AnalyticsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AnalyticsModel>> getFinancialAnalytics() async {
    try {
      final model = await remoteDataSource.getFinancialAnalytics();
      return Right(model);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
