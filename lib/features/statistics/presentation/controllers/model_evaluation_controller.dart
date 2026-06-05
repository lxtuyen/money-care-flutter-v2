import 'package:get/get.dart';
import 'package:money_care/features/statistics/data/models/model_evaluation_model.dart';
import 'package:money_care/features/statistics/domain/usecases/get_model_evaluation_usecase.dart';

class ModelEvaluationController extends GetxController {
  final GetModelEvaluationUseCase useCase;

  ModelEvaluationController({required this.useCase});

  final Rxn<ModelEvaluationSummaryModel> summary = Rxn<ModelEvaluationSummaryModel>();
  final RxBool isLoading = true.obs;
  final RxBool isRunningEvaluation = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSummary();
  }

  Future<void> loadSummary() async {
    try {
      isLoading.value = true;
      final data = await useCase.execute();
      summary.value = data;
    } catch (e) {
      summary.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> runManualEvaluation() async {
    try {
      isRunningEvaluation.value = true;
      await useCase.runManualEvaluation();
      await loadSummary();
    } catch (e) {
      // Silently handle
    } finally {
      isRunningEvaluation.value = false;
    }
  }
}
