import '../repositories/model_evaluation_repository.dart';
import '../../data/models/model_evaluation_model.dart';

class GetModelEvaluationUseCase {
  final ModelEvaluationRepository repository;

  const GetModelEvaluationUseCase(this.repository);

  Future<ModelEvaluationSummaryModel> execute() {
    return repository.getEvaluationSummary();
  }

  Future<ForecastingEvaluationModel> getForecastingDetail() {
    return repository.getForecastingEvaluation();
  }

  Future<BudgetingEvaluationModel> getBudgetingDetail() {
    return repository.getBudgetingEvaluation();
  }

  Future<ManualEvaluationResultModel> runManualEvaluation({String? modelType}) {
    return repository.runManualEvaluation(modelType: modelType);
  }

  Future<ForecastingTrainingResultModel> trainForecastingModel() {
    return repository.trainForecastingModel();
  }
}
