import 'package:get/get.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/features/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:money_care/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:money_care/features/transaction/domain/usecases/usecases.dart';
import 'package:money_care/features/statistics/data/datasources/goal_plan_insight_remote_datasource.dart';
import 'package:money_care/features/statistics/data/repositories/goal_plan_insight_repository_impl.dart';
import 'package:money_care/features/statistics/domain/usecases/get_goal_plan_insight_usecase.dart';

class StatisticsBinding extends Bindings {
  final ApiClient apiClient;

  StatisticsBinding({required this.apiClient});

  @override
  void dependencies() {
    final remoteDatasource = TransactionRemoteDatasourceImpl(api: apiClient);
    final repository = TransactionRepositoryImpl(
      remoteDatasource: remoteDatasource,
    );
    final goalPlanInsightRemoteDs = GoalPlanInsightRemoteDatasourceImpl(
      api: apiClient,
    );
    final goalPlanInsightRepo = GoalPlanInsightRepositoryImpl(
      remoteDatasource: goalPlanInsightRemoteDs,
    );

    Get.lazyPut(
      () => StatisticsController(
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
      fenix: true,
    );
  }
}
