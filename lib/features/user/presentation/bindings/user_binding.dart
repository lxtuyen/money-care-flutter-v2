import 'package:get/get.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/user/data/datasources/user_remote_datasource.dart';
import 'package:money_care/features/user/data/repositories/user_repository_impl.dart';
import 'package:money_care/features/user/domain/usecases/user_usecase.dart';


class UserBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();
    final remoteDatasource = UserRemoteDatasourceImpl(api: apiClient);
    final repository = UserRepositoryImpl(remoteDatasource: remoteDatasource);


  }
}
