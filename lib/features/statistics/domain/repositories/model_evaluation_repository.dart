import '../../data/models/model_evaluation_model.dart';

abstract class ModelEvaluationRepository {
  Future<ModelEvaluationSummaryModel> getEvaluationSummary();
  Future<ForecastingEvaluationModel> getForecastingEvaluation();
  Future<BudgetingEvaluationModel> getBudgetingEvaluation();
  Future<void> runManualEvaluation({String? modelType});
}
