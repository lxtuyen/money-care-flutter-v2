import 'package:money_care/features/payment/data/models/payment_request_dto.dart';
import 'package:money_care/features/payment/domain/entities/monthly_revenue_entity.dart';
import 'package:money_care/features/payment/domain/repositories/payment_repository.dart';

class ConfirmPaymentUseCase {
  final PaymentRepository repository;
  ConfirmPaymentUseCase(this.repository);

  Future<bool> call(PaymentRequestDto dto) {
    return repository.confirm(dto);
  }
}

class GetMonthlyRevenueUseCase {
  final PaymentRepository repository;
  GetMonthlyRevenueUseCase(this.repository);

  Future<List<MonthlyRevenueEntity>> call() {
    return repository.getMonthlyRevenue();
  }
}
