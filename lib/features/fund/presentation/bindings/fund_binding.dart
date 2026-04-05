import 'package:get/get.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/fund/data/datasources/fund_remote_datasource.dart';
import 'package:money_care/features/fund/data/repositories/fund_repository_impl.dart';
import 'package:money_care/features/fund/domain/usecases/usecases.dart';
import 'package:money_care/features/fund/presentation/controllers/create_fund_controller.dart';
import 'package:money_care/features/fund/presentation/controllers/fund_controller.dart';

class FundBinding extends Bindings {
  final ApiClient apiClient;

  FundBinding({required this.apiClient});

  @override
  void dependencies() {
    final remoteDatasource = FundRemoteDatasourceImpl(api: apiClient);
    final repository = FundRepositoryImpl(
      remoteDatasource: remoteDatasource,
    );

    Get.lazyPut(
      () => FundController(
        getFundsByUserUseCase: GetFundsByUserUseCase(repository),
        getFundUseCase: GetFundUseCase(repository),
        updateFundUseCase: UpdateFundUseCase(repository),
        deleteFundUseCase: DeleteFundUseCase(repository),
        selectFundUseCase: SelectFundUseCase(repository),
        checkExpiredFundUseCase: CheckExpiredFundUseCase(repository),
        markAsNotifiedUseCase: MarkAsNotifiedUseCase(repository),
        extendFundUseCase: ExtendFundUseCase(repository),
        getFundReportUseCase: GetFundReportUseCase(repository),
      ),
      fenix: true,
    );

    Get.lazyPut(
      () => CreateFundController(
        createFundUseCase: CreateFundUseCase(repository),
      ),
      fenix: true,
    );
  }
}
