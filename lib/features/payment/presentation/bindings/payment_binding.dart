import 'package:get/get.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/payment/data/datasources/payment_remote_datasource.dart';
import 'package:money_care/features/payment/data/repositories/payment_repository_impl.dart';
import 'package:money_care/features/payment/domain/usecases/payment_usecases.dart';
import 'package:money_care/features/payment/presentation/controllers/payment_controller.dart';

class PaymentBinding extends Bindings {
  final ApiClient apiClient;

  PaymentBinding({required this.apiClient});

  @override
  void dependencies() {
    final remoteDatasource = PaymentRemoteDatasourceImpl(api: apiClient);
    final repository = PaymentRepositoryImpl(remoteDatasource: remoteDatasource);

    Get.lazyPut(
      () => PaymentController(
        confirmPaymentUseCase: ConfirmPaymentUseCase(repository),
        getMonthlyRevenueUseCase: GetMonthlyRevenueUseCase(repository),
      ),
      fenix: true,
    );
  }
}
