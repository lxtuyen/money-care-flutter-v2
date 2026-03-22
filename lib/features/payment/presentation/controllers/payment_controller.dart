import 'package:get/get.dart';
import 'package:money_care/features/payment/data/models/payment_request_dto.dart';
import 'package:money_care/features/payment/domain/entities/monthly_revenue_entity.dart';
import 'package:money_care/features/payment/domain/usecases/payment_usecases.dart';

class PaymentController extends GetxController {
  final ConfirmPaymentUseCase confirmPaymentUseCase;
  final GetMonthlyRevenueUseCase getMonthlyRevenueUseCase;

  PaymentController({
    required this.confirmPaymentUseCase,
    required this.getMonthlyRevenueUseCase,
  });

  var isLoading = false.obs;
  var payment = false.obs;
  RxList<MonthlyRevenueEntity> monthlyRevenue = <MonthlyRevenueEntity>[].obs;

  Future<bool> confirm(PaymentRequestDto dto) async {
    try {
      isLoading.value = true;
      final isSuccess = await confirmPaymentUseCase(dto);
      payment.value = isSuccess;
      return isSuccess;
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<MonthlyRevenueEntity>> getMonthlyRevenue() async {
    try {
      isLoading.value = true;
      final data = await getMonthlyRevenueUseCase();
      monthlyRevenue.value = data;
      return data;
    } finally {
      isLoading.value = false;
    }
  }
}
