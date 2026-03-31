import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/errors/exceptions.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/saving_fund/data/models/models.dart';

abstract class SavingFundRemoteDatasource {
  Future<SavingFundModel> createSavingFund(SavingFundDto dto);
  Future<List<SavingFundModel>> getSavingFundsByUser(int userId);
  Future<SavingFundModel> getSavingFund(int id);
  Future<SavingFundModel> updateSavingFund(SavingFundDto dto);
  Future<bool> deleteSavingFund(int id);
  Future<SavingFundModel> selectSavingFund(int userId, int fundId);
}

class SavingFundRemoteDatasourceImpl implements SavingFundRemoteDatasource {
  final ApiClient api;

  SavingFundRemoteDatasourceImpl({required this.api});

  @override
  Future<SavingFundModel> createSavingFund(SavingFundDto dto) async {
    final res = await api.post<SavingFundModel>(
      ApiRoutes.savingFund,
      body: dto.toJsonCreate(),
      fromJsonT: (json) => SavingFundModel.fromMap(json),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'Không thể tạo quỹ tiết kiệm',
      );
    }
    return res.data!;
  }

  @override
  Future<List<SavingFundModel>> getSavingFundsByUser(int userId) async {
    final res = await api.get<List<SavingFundModel>>(
      '${ApiRoutes.getSavingFunds}/$userId',
      fromJsonT: (json) {
        final list = json as List;
        return list.map((e) => SavingFundModel.fromMap(e)).toList();
      },
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty
            ? res.message
            : 'Không thể tải danh sách quỹ tiết kiệm',
      );
    }
    return res.data!;
  }

  @override
  Future<SavingFundModel> getSavingFund(int id) async {
    final res = await api.get<SavingFundModel>(
      '${ApiRoutes.savingFund}/$id',
      fromJsonT: (json) => SavingFundModel.fromMap(json),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'Không thể tải quỹ tiết kiệm',
      );
    }
    return res.data!;
  }

  @override
  Future<SavingFundModel> updateSavingFund(SavingFundDto dto) async {
    final res = await api.patch<SavingFundModel>(
      '${ApiRoutes.savingFund}/${dto.id}',
      body: dto.toJsonUpdate(),
      fromJsonT: (json) => SavingFundModel.fromMap(json),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty
            ? res.message
            : 'Không thể cập nhật quỹ tiết kiệm',
      );
    }
    return res.data!;
  }

  @override
  Future<bool> deleteSavingFund(int id) async {
    final res = await api.delete<void>('${ApiRoutes.savingFund}/$id');
    if (!res.success) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'Không thể xóa quỹ tiết kiệm',
      );
    }
    return res.success;
  }

  @override
  Future<SavingFundModel> selectSavingFund(int userId, int fundId) async {
    final res = await api.patch<SavingFundModel>(
      '${ApiRoutes.selectSavingFund}/$fundId',
      body: {'userId': userId},
      fromJsonT: (json) => SavingFundModel.fromMap(json),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'Không thể chọn quỹ tiết kiệm',
      );
    }
    return res.data!;
  }
}
