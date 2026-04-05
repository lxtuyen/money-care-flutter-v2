import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/errors/exceptions.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/finance_mode/data/models/finance_mode_model.dart';

abstract class FinanceModeRemoteDatasource {
  Future<FinanceModeModel> getFinanceMode(int userId);
  Future<FinanceModeModel> saveFinanceMode(FinanceModeModel model);
}

class FinanceModeRemoteDatasourceImpl implements FinanceModeRemoteDatasource {
  final ApiClient api;

  FinanceModeRemoteDatasourceImpl({required this.api});

  @override
  Future<FinanceModeModel> getFinanceMode(int userId) async {
    final res = await api.get<FinanceModeModel>(
      ApiRoutes.financeMode,
      fromJsonT: (json) =>
          FinanceModeModel.fromJson(json as Map<String, dynamic>),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty
            ? res.message
            : 'Không thể tải chế độ tài chính',
      );
    }
    return res.data!;
  }

  @override
  Future<FinanceModeModel> saveFinanceMode(FinanceModeModel model) async {
    final res = await api.put<FinanceModeModel>(
      ApiRoutes.financeMode,
      body: model.toUpdateDto(),
      fromJsonT: (json) =>
          FinanceModeModel.fromJson(json as Map<String, dynamic>),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty
            ? res.message
            : 'Không thể lưu chế độ tài chính',
      );
    }
    return res.data!;
  }
}
