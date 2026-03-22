import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/payment/data/models/monthly_revenue_model.dart';
import 'package:money_care/features/payment/data/models/payment_request_dto.dart';


abstract class PaymentRemoteDatasource {
  Future<bool> confirm(PaymentRequestDto dto);
  Future<List<MonthlyRevenueModel>> getMonthlyRevenue();
}

class PaymentRemoteDatasourceImpl implements PaymentRemoteDatasource {
  final ApiClient api;

  PaymentRemoteDatasourceImpl({required this.api});

  @override
  Future<bool> confirm(PaymentRequestDto dto) async {
    final res = await api.post<bool>(
      ApiRoutes.paymentconfirm,
      body: dto.toJson(),
    );
    if (!res.success) throw Exception(res.message);
    return res.success;
  }

  @override
  Future<List<MonthlyRevenueModel>> getMonthlyRevenue() async {
    final res = await api.get<List<MonthlyRevenueModel>>(
      ApiRoutes.getMonthlyRevenue,
      fromJsonT: (json) {
        final list = json as List;
        return list.map((e) => MonthlyRevenueModel.fromJson(e)).toList();
      },
    );
    if (!res.success || res.data == null) throw Exception(res.message);
    return res.data!;
  }
}
