import 'package:money_care/features/payment/data/models/payment_request_dto.dart';
import 'package:money_care/features/payment/domain/entities/monthly_revenue_entity.dart';

abstract class PaymentRepository {
  Future<bool> confirm(PaymentRequestDto dto);
  Future<List<MonthlyRevenueEntity>> getMonthlyRevenue();
}
