import 'package:get/get.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/saving_fund/data/datasources/saving_fund_remote_datasource.dart';
import 'package:money_care/features/saving_fund/data/repositories/saving_fund_repository_impl.dart';
import 'package:money_care/features/saving_fund/domain/usecases/usecases.dart';
import 'package:money_care/features/saving_fund/presentation/controllers/create_saving_fund_controller.dart';
import 'package:money_care/features/saving_fund/presentation/controllers/saving_fund_controller.dart';

class SavingFundBinding extends Bindings {
  final ApiClient apiClient;

  SavingFundBinding({required this.apiClient});

  @override
  void dependencies() {
    final remoteDatasource = SavingFundRemoteDatasourceImpl(api: apiClient);
    final repository = SavingFundRepositoryImpl(
      remoteDatasource: remoteDatasource,
    );

    Get.lazyPut(
      () => SavingFundController(
        getSavingFundsByUserUseCase: GetSavingFundsByUserUseCase(repository),
        getSavingFundUseCase: GetSavingFundUseCase(repository),
        updateSavingFundUseCase: UpdateSavingFundUseCase(repository),
        deleteSavingFundUseCase: DeleteSavingFundUseCase(repository),
        selectSavingFundUseCase: SelectSavingFundUseCase(repository),
        checkExpiredFundUseCase: CheckExpiredFundUseCase(repository),
        markAsNotifiedUseCase: MarkAsNotifiedUseCase(repository),
        extendFundUseCase: ExtendFundUseCase(repository),
        getFundReportUseCase: GetFundReportUseCase(repository),
      ),
      fenix: true,
    );

    Get.lazyPut(
      () => CreateSavingFundController(
        createSavingFundUseCase: CreateSavingFundUseCase(repository),
      ),
      fenix: true,
    );
  }
}
