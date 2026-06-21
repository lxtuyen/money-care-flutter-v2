import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/payment/domain/entities/subscription_entity.dart';
import 'package:money_care/features/payment/domain/entities/payment_entity.dart';

abstract class PaymentRepository {
  Future<Either<Failure, String>> subscribe();
  Future<Either<Failure, SubscriptionEntity>> activateTrial();
  Future<Either<Failure, SubscriptionEntity>> getSubscriptionStatus();
  Future<Either<Failure, List<PaymentEntity>>> getPaymentHistory();
  Future<Either<Failure, bool>> verifyPayment(int orderCode);
}
