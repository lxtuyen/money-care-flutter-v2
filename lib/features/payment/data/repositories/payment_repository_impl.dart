import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/exceptions.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/payment/data/datasources/payment_remote_datasource.dart';
import 'package:money_care/features/payment/domain/entities/subscription_entity.dart';
import 'package:money_care/features/payment/domain/entities/payment_entity.dart';
import 'package:money_care/features/payment/domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDatasource datasource;

  PaymentRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, String>> subscribe() async {
    try {
      final checkoutUrl = await datasource.subscribe();
      return Right(checkoutUrl);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SubscriptionEntity>> activateTrial() async {
    try {
      final result = await datasource.activateTrial();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SubscriptionEntity>> getSubscriptionStatus() async {
    try {
      final status = await datasource.getSubscriptionStatus();
      return Right(status);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PaymentEntity>>> getPaymentHistory() async {
    try {
      final history = await datasource.getPaymentHistory();
      return Right(history);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyPayment(int orderCode) async {
    try {
      final verified = await datasource.verifyPayment(orderCode);
      return Right(verified);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
