import 'package:get/get.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/spending_insights/data/datasources/spending_insights_remote_datasource.dart';
import 'package:money_care/features/spending_insights/data/repositories/spending_insights_repository_impl.dart';
import 'package:money_care/features/spending_insights/presentation/controllers/recurring_controller.dart';

class SpendingInsightsBinding extends Bindings {
  @override
  void dependencies() {
    final api = Get.find<ApiClient>();

    final datasource = SpendingInsightsRemoteDataSourceImpl(api: api);
    final repository = SpendingInsightsRepositoryImpl(
      remoteDataSource: datasource,
    );

    Get.lazyPut(() => RecurringController(repository: repository));
  }
}
