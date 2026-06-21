import 'package:get/get.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/payment/data/datasources/payment_remote_datasource.dart';
import 'package:money_care/features/payment/data/repositories/payment_repository_impl.dart';
import 'package:money_care/features/payment/presentation/controllers/payment_controller.dart';

class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    final api = Get.find<ApiClient>();

    Get.lazyPut<PaymentRemoteDatasource>(
      () => PaymentRemoteDatasourceImpl(api: api),
    );

    Get.lazyPut<PaymentController>(
      () => PaymentController(
        repository: PaymentRepositoryImpl(
          datasource: Get.find<PaymentRemoteDatasource>(),
        ),
      ),
    );
  }
}
