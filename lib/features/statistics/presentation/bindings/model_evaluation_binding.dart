import 'package:get/get.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/statistics/data/repositories/model_evaluation_repository_impl.dart';
import 'package:money_care/features/statistics/domain/repositories/model_evaluation_repository.dart';
import 'package:money_care/features/statistics/domain/usecases/get_model_evaluation_usecase.dart';
import 'package:money_care/features/statistics/presentation/controllers/model_evaluation_controller.dart';

class ModelEvaluationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ModelEvaluationRepository>(
      () => ModelEvaluationRepositoryImpl(api: Get.find<ApiClient>()),
    );
    Get.lazyPut<GetModelEvaluationUseCase>(
      () => GetModelEvaluationUseCase(Get.find<ModelEvaluationRepository>()),
    );
    Get.lazyPut<ModelEvaluationController>(
      () => ModelEvaluationController(useCase: Get.find<GetModelEvaluationUseCase>()),
    );
  }
}
