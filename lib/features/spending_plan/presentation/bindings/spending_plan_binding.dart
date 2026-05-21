import 'package:get/get.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/spending_plan/data/datasources/spending_plan_remote_datasource.dart';
import 'package:money_care/features/spending_plan/data/repositories/spending_plan_repository_impl.dart';
import 'package:money_care/features/spending_plan/domain/usecases/usecases.dart';
import 'package:money_care/features/spending_plan/presentation/controllers/spending_plan_controller.dart';

class SpendingPlanBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();

    if (!Get.isRegistered<SpendingPlanRemoteDatasource>()) {
      Get.lazyPut<SpendingPlanRemoteDatasource>(
        () => SpendingPlanRemoteDatasourceImpl(api: apiClient),
        fenix: true,
      );
    }

    final repository = SpendingPlanRepositoryImpl(
      remoteDatasource: Get.find<SpendingPlanRemoteDatasource>(),
    );

    if (!Get.isRegistered<GetSpendingPlansUseCase>()) {
      Get.lazyPut<GetSpendingPlansUseCase>(
        () => GetSpendingPlansUseCase(repository),
        fenix: true,
      );
    }
    if (!Get.isRegistered<GetActiveSpendingPlanUseCase>()) {
      Get.lazyPut<GetActiveSpendingPlanUseCase>(
        () => GetActiveSpendingPlanUseCase(repository),
        fenix: true,
      );
    }
    if (!Get.isRegistered<GetSpendingPlanUseCase>()) {
      Get.lazyPut<GetSpendingPlanUseCase>(
        () => GetSpendingPlanUseCase(repository),
        fenix: true,
      );
    }
    if (!Get.isRegistered<CreateSpendingPlanUseCase>()) {
      Get.lazyPut<CreateSpendingPlanUseCase>(
        () => CreateSpendingPlanUseCase(repository),
        fenix: true,
      );
    }
    if (!Get.isRegistered<UpdateSpendingPlanUseCase>()) {
      Get.lazyPut<UpdateSpendingPlanUseCase>(
        () => UpdateSpendingPlanUseCase(repository),
        fenix: true,
      );
    }
    if (!Get.isRegistered<DeleteSpendingPlanUseCase>()) {
      Get.lazyPut<DeleteSpendingPlanUseCase>(
        () => DeleteSpendingPlanUseCase(repository),
        fenix: true,
      );
    }
    if (!Get.isRegistered<ActivateSpendingPlanUseCase>()) {
      Get.lazyPut<ActivateSpendingPlanUseCase>(
        () => ActivateSpendingPlanUseCase(repository),
        fenix: true,
      );
    }
    if (!Get.isRegistered<ArchiveSpendingPlanUseCase>()) {
      Get.lazyPut<ArchiveSpendingPlanUseCase>(
        () => ArchiveSpendingPlanUseCase(repository),
        fenix: true,
      );
    }
    if (!Get.isRegistered<PauseSpendingPlanUseCase>()) {
      Get.lazyPut<PauseSpendingPlanUseCase>(
        () => PauseSpendingPlanUseCase(repository),
        fenix: true,
      );
    }

    if (!Get.isRegistered<GetActiveSpendingPlanStatisticsUseCase>()) {
      Get.lazyPut<GetActiveSpendingPlanStatisticsUseCase>(
        () => GetActiveSpendingPlanStatisticsUseCase(repository),
        fenix: true,
      );
    }

    if (!Get.isRegistered<SpendingPlanController>()) {
      Get.lazyPut<SpendingPlanController>(
        () => SpendingPlanController(
          getSpendingPlansUseCase: Get.find<GetSpendingPlansUseCase>(),
          getActiveSpendingPlanUseCase:
              Get.find<GetActiveSpendingPlanUseCase>(),
          getSpendingPlanUseCase: Get.find<GetSpendingPlanUseCase>(),
          createSpendingPlanUseCase: Get.find<CreateSpendingPlanUseCase>(),
          updateSpendingPlanUseCase: Get.find<UpdateSpendingPlanUseCase>(),
          deleteSpendingPlanUseCase: Get.find<DeleteSpendingPlanUseCase>(),
          activateSpendingPlanUseCase: Get.find<ActivateSpendingPlanUseCase>(),
          pauseSpendingPlanUseCase: Get.find<PauseSpendingPlanUseCase>(),
          archiveSpendingPlanUseCase: Get.find<ArchiveSpendingPlanUseCase>(),
          getActiveSpendingPlanStatisticsUseCase:
              Get.find<GetActiveSpendingPlanStatisticsUseCase>(),
        ),
        fenix: true,
      );
    }
  }
}
