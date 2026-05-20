import 'package:get/get.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:money_care/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:money_care/features/transaction/domain/usecases/usecases.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/core/services/ocr_service.dart';
import 'package:money_care/features/statistics/data/datasources/goal_plan_insight_remote_datasource.dart';
import 'package:money_care/features/statistics/data/repositories/goal_plan_insight_repository_impl.dart';
import 'package:money_care/features/statistics/domain/usecases/get_goal_plan_insight_usecase.dart';

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
    final goalPlanInsightRemoteDs = GoalPlanInsightRemoteDatasourceImpl(
      api: apiClient,
    );
    final goalPlanInsightRepo = GoalPlanInsightRepositoryImpl(
      remoteDatasource: goalPlanInsightRemoteDs,
    );

    Get.put<StatisticsController>(
      StatisticsController(
        getTotalByTypeUseCase: GetTotalByTypeUseCase(repository),
        getTotalByCateUseCase: GetTotalByCateUseCase(repository),
        getTotalByDateEntityUseCase: GetTotalByDateEntityUseCase(repository),
        getStatisticsSummaryUseCase: GetStatisticsSummaryUseCase(
          repository: repository,
        ),
        getGoalPlanInsightUseCase: GetGoalPlanInsightUseCase(
          goalPlanInsightRepo,
        ),
      ),
      permanent: true,
    );
  }
}
