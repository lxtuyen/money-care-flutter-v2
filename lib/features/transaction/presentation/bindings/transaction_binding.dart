import 'package:get/get.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:money_care/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:money_care/features/transaction/domain/usecases/scan_receipt_usecases.dart';
import 'package:money_care/features/transaction/presentation/controllers/filter_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/scan_receipt_controller.dart';

import 'package:money_care/features/transaction/presentation/controllers/photo_transaction_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/transaction_form_controller.dart';

import 'package:money_care/core/services/ocr_service.dart';

class TransactionBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();
    final ocrService = OCRService();
    final remoteDatasource = TransactionRemoteDatasourceImpl(api: apiClient);
    final repository = TransactionRepositoryImpl(
      remoteDatasource: remoteDatasource,
      ocrService: ocrService,
    );

    Get.lazyPut(() => FilterController(), fenix: true);
    Get.lazyPut(() => TransactionFormController(), fenix: true);
    Get.lazyPut(
      () => PhotoTransactionController(
        scanReceiptUseCase: ScanReceiptUseCase(repository),
      ),
      fenix: true,
    );

    Get.lazyPut(
      () => ScanReceiptController(
        scanReceiptUseCase: ScanReceiptUseCase(repository),
      ),
      fenix: true,
    );
  }
}
