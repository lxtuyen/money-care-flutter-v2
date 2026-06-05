import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/statistics/data/models/model_evaluation_model.dart';
import 'package:money_care/features/statistics/domain/repositories/model_evaluation_repository.dart';

class ModelEvaluationRepositoryImpl implements ModelEvaluationRepository {
  final ApiClient api;

  const ModelEvaluationRepositoryImpl({required this.api});

  @override
  Future<ModelEvaluationSummaryModel> getEvaluationSummary() async {
    final res = await api.get<ModelEvaluationSummaryModel>(
      ApiRoutes.modelEvaluation,
      fromJsonT: (json) => ModelEvaluationSummaryModel.fromJson(json as Map<String, dynamic>),
    );
    return res.unwrap();
  }

  @override
  Future<ForecastingEvaluationModel> getForecastingEvaluation() async {
    final res = await api.get<ForecastingEvaluationModel>(
      ApiRoutes.modelEvaluationForecasting,
      fromJsonT: (json) => ForecastingEvaluationModel.fromJson(json as Map<String, dynamic>),
    );
    return res.unwrap();
  }

  @override
  Future<BudgetingEvaluationModel> getBudgetingEvaluation() async {
    final res = await api.get<BudgetingEvaluationModel>(
      ApiRoutes.modelEvaluationBudgeting,
      fromJsonT: (json) => BudgetingEvaluationModel.fromJson(json as Map<String, dynamic>),
    );
    return res.unwrap();
  }

  @override
  Future<void> runManualEvaluation({String? modelType}) async {
    await api.post<void>(
      ApiRoutes.modelEvaluationRun,
      body: {'modelType': ?modelType},
      fromJsonT: (_) {},
    );
  }
}
