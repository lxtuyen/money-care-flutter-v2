import 'package:get/get.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/fund/data/datasources/fund_remote_datasource.dart';
import 'package:money_care/features/fund/data/repositories/fund_repository_impl.dart';
import 'package:money_care/features/fund/domain/usecases/usecases.dart';
import 'package:money_care/features/fund/presentation/controllers/create_fund_controller.dart';

class FundBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();
    final remoteDatasource = FundRemoteDatasourceImpl(api: apiClient);
    final repository = FundRepositoryImpl(
      remoteDatasource: remoteDatasource,
    );



    Get.lazyPut(
      () => CreateFundController(
        createFundUseCase: CreateFundUseCase(repository),
      ),
      fenix: true,
    );
  }
}
