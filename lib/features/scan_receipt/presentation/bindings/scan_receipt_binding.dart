import 'package:get/get.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/scan_receipt/data/datasources/scan_receipt_remote_datasource.dart';
import 'package:money_care/features/scan_receipt/data/repositories/scan_receipt_repository_impl.dart';
import 'package:money_care/features/scan_receipt/domain/usecases/scan_receipt_usecases.dart';
import 'package:money_care/features/scan_receipt/presentation/controllers/scan_receipt_controller.dart';

class ScanReceiptBinding extends Bindings {
  final ApiClient apiClient;

  ScanReceiptBinding({required this.apiClient});

  @override
  void dependencies() {
    final remoteDatasource =
        ScanReceiptRemoteDatasourceImpl(api: apiClient);
    final repository =
        ScanReceiptRepositoryImpl(remoteDatasource: remoteDatasource);

    Get.lazyPut(
      () => ScanReceiptController(
        scanReceiptUseCase: ScanReceiptUseCase(repository),
      ),
      fenix: true,
    );
  }
}
