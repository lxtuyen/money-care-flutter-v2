import 'package:get/get.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:money_care/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:money_care/features/transaction/domain/usecases/usecases.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/core/services/ocr_service.dart';

class AppStateBinding extends Bindings {
  final ApiClient apiClient;

  AppStateBinding({required this.apiClient});

  @override
  void dependencies() {
    final remoteDatasource = TransactionRemoteDatasourceImpl(api: apiClient);
    final ocrService = OCRService();
    final repository = TransactionRepositoryImpl(
      remoteDatasource: remoteDatasource,
      ocrService: ocrService,
    );

    Get.put<StatisticsController>(
      StatisticsController(
        getTotalByTypeUseCase: GetTotalByTypeUseCase(repository),
        getTotalByCateUseCase: GetTotalByCateUseCase(repository),
        getTotalByDateEntityUseCase: GetTotalByDateEntityUseCase(repository),
        getStatisticsSummaryUseCase: GetStatisticsSummaryUseCase(
          repository: repository,
        ),
      ),
      permanent: true,
    );
  }
}
