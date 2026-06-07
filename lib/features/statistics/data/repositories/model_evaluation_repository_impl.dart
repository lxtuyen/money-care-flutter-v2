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
      fromJsonT: (json) =>
          ModelEvaluationSummaryModel.fromJson(json as Map<String, dynamic>),
    );
    return res.unwrap();
  }

  @override
  Future<ForecastingEvaluationModel> getForecastingEvaluation() async {
    final res = await api.get<ForecastingEvaluationModel>(
      ApiRoutes.modelEvaluationForecasting,
      fromJsonT: (json) =>
          ForecastingEvaluationModel.fromJson(json as Map<String, dynamic>),
    );
    return res.unwrap();
  }

  @override
  Future<BudgetingEvaluationModel> getBudgetingEvaluation() async {
    final res = await api.get<BudgetingEvaluationModel>(
      ApiRoutes.modelEvaluationBudgeting,
      fromJsonT: (json) =>
          BudgetingEvaluationModel.fromJson(json as Map<String, dynamic>),
    );
    return res.unwrap();
  }

  @override
  Future<ManualEvaluationResultModel> runManualEvaluation({
    String? modelType,
  }) async {
    final res = await api.post<ManualEvaluationResultModel>(
      ApiRoutes.modelEvaluationRun,
      // ignore: use_null_aware_elements
      body: {if (modelType != null) 'modelType': modelType},
      fromJsonT: (json) =>
          ManualEvaluationResultModel.fromJson(json as Map<String, dynamic>),
    );
    return res.unwrap();
  }

  @override
  Future<ForecastingTrainingResultModel> trainForecastingModel() async {
    final res = await api.post<ForecastingTrainingResultModel>(
      ApiRoutes.modelTrainingForecasting,
      fromJsonT: (json) =>
          ForecastingTrainingResultModel.fromJson(json as Map<String, dynamic>),
    );
    return res.unwrap();
  }
}
