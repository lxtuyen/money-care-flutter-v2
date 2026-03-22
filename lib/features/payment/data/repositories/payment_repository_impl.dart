import 'package:money_care/features/payment/data/datasources/payment_remote_datasource.dart';
import 'package:money_care/features/payment/data/models/payment_request_dto.dart';
import 'package:money_care/features/payment/domain/entities/monthly_revenue_entity.dart';
import 'package:money_care/features/payment/domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDatasource remoteDatasource;

  PaymentRepositoryImpl({required this.remoteDatasource});

  @override
  Future<bool> confirm(PaymentRequestDto dto) {
    return remoteDatasource.confirm(dto);
  }

  @override
  Future<List<MonthlyRevenueEntity>> getMonthlyRevenue() async {
    final models = await remoteDatasource.getMonthlyRevenue();
    return models.map((e) => e.toEntity()).toList();
  }
}
