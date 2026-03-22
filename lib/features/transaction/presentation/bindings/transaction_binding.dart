import 'package:get/get.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:money_care/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:money_care/features/transaction/domain/usecases/create_transaction_usecase.dart';
import 'package:money_care/features/transaction/domain/usecases/delete_transaction_usecase.dart';
import 'package:money_care/features/transaction/domain/usecases/filter_transactions_usecase.dart';
import 'package:money_care/features/transaction/domain/usecases/get_transaction_stats_usecase.dart';
import 'package:money_care/features/transaction/domain/usecases/update_transaction_usecase.dart';
import 'package:money_care/features/transaction/presentation/controllers/filter_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/transaction_controller.dart';

class TransactionBinding extends Bindings {
  final ApiClient apiClient;

  TransactionBinding({required this.apiClient});

  @override
  void dependencies() {
    final remoteDatasource = TransactionRemoteDatasourceImpl(api: apiClient);
    final repository = TransactionRepositoryImpl(remoteDatasource: remoteDatasource);

    Get.lazyPut(() => FilterController(), fenix: true);

    Get.lazyPut(
      () => TransactionController(
        filterTransactionsUseCase: FilterTransactionsUseCase(repository),
        getTotalByTypeUseCase: GetTotalByTypeUseCase(repository),
        getTotalByCateUseCase: GetTotalByCateUseCase(repository),
        getTotalByDateEntityUseCase: GetTotalByDateEntityUseCase(repository),
        createTransactionUseCase: CreateTransactionUseCase(repository),
        updateTransactionUseCase: UpdateTransactionUseCase(repository),
        deleteTransactionUseCase: DeleteTransactionUseCase(repository),
      ),
      fenix: true,
    );
  }
}
