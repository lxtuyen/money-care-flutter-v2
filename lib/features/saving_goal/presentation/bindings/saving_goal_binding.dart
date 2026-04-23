import 'package:get/get.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/saving_goal/data/datasources/saving_goal_remote_datasource.dart';
import 'package:money_care/features/saving_goal/data/repositories/saving_goal_repository_impl.dart';
import 'package:money_care/features/saving_goal/domain/usecases/usecases.dart';
import 'package:money_care/features/saving_goal/presentation/controllers/create_saving_goal_controller.dart';

class SavingGoalBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();
    final remoteDatasource = SavingGoalRemoteDatasourceImpl(api: apiClient);
    final repository = SavingGoalRepositoryImpl(
      remoteDatasource: remoteDatasource,
    );

    Get.lazyPut<CreateSavingGoalUseCase>(
      () => CreateSavingGoalUseCase(repository),
    );
    Get.lazyPut<UpdateSavingGoalUseCase>(
      () => UpdateSavingGoalUseCase(repository),
    );

    Get.lazyPut<CreateSavingGoalController>(
      () => CreateSavingGoalController(),
      fenix: true,
    );
  }
}
