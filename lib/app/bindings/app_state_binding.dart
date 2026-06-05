import 'package:get/get.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:money_care/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:money_care/features/transaction/domain/usecases/usecases.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/features/statistics/data/datasources/goal_plan_insight_remote_datasource.dart';
import 'package:money_care/features/statistics/data/repositories/goal_plan_insight_repository_impl.dart';
import 'package:money_care/features/statistics/domain/usecases/get_goal_plan_insight_usecase.dart';
import 'package:money_care/features/statistics/data/repositories/analytics_repository_impl.dart';
import 'package:money_care/features/statistics/domain/usecases/get_financial_analytics_usecase.dart';
import 'package:money_care/features/ai_feedback/data/repositories/ai_feedback_repository_impl.dart';
import 'package:money_care/features/ai_feedback/domain/usecases/send_ai_feedback_usecase.dart';

class AppStateBinding extends Bindings {
  final ApiClient apiClient;

  AppStateBinding({required this.apiClient});

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
    final analyticsRepo = AnalyticsRepositoryImpl(api: apiClient);
    final aiFeedbackRepo = AiFeedbackRepositoryImpl(api: apiClient);

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
        getFinancialAnalyticsUseCase: GetFinancialAnalyticsUseCase(
          analyticsRepo,
        ),
        sendAiFeedbackUseCase: SendAiFeedbackUseCase(aiFeedbackRepo),
      ),
      permanent: true,
    );
  }
}
