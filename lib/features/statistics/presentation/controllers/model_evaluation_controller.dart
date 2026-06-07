import 'package:get/get.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/statistics/data/models/model_evaluation_model.dart';
import 'package:money_care/features/statistics/domain/usecases/get_model_evaluation_usecase.dart';

class ModelEvaluationController extends GetxController {
  final GetModelEvaluationUseCase useCase;

  ModelEvaluationController({required this.useCase});

  final Rxn<ModelEvaluationSummaryModel> summary =
      Rxn<ModelEvaluationSummaryModel>();
  final RxBool isLoading = true.obs;
  final RxBool isRunningEvaluation = false.obs;
  final RxBool isTrainingForecasting = false.obs;

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
      final result = await useCase.runManualEvaluation();
      if (result.evaluatedCount > 0) {
        AppHelperFunction.showSuccessSnackBar(
          'Đã đánh giá ${result.evaluatedCount} dự báo đến hạn',
        );
      } else {
        AppHelperFunction.showWarningSnackBar(
          'Chưa có dự báo nào đến hạn để đánh giá',
        );
      }
      await loadSummary();
    } catch (e) {
      AppHelperFunction.showErrorSnackBar('Không thể chạy đánh giá AI: $e');
    } finally {
      isRunningEvaluation.value = false;
    }
  }

  Future<void> trainForecastingModel() async {
    try {
      isTrainingForecasting.value = true;
      final result = await useCase.trainForecastingModel();

      if (result.artifactSaved) {
        AppHelperFunction.showSuccessSnackBar(
          'Đã train forecasting model và lưu artifact',
        );
      } else if (result.reason == 'insufficient_data') {
        AppHelperFunction.showWarningSnackBar(
          'Chưa đủ dữ liệu train: ${result.trainingRows}/${result.minimumRequiredTransactions ?? 50} giao dịch, ${result.historyDays}/${result.minimumRequiredDays ?? 30} ngày',
        );
      } else {
        AppHelperFunction.showWarningSnackBar(
          'Training kết thúc với trạng thái: ${result.status}',
        );
      }

      await loadSummary();
    } catch (e) {
      AppHelperFunction.showErrorSnackBar('Không thể train model: $e');
    } finally {
      isTrainingForecasting.value = false;
    }
  }
}
