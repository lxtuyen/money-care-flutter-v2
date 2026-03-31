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
  Future<ExpiredFundCheckModel> checkExpiredFund(int userId);
  Future<bool> markAsNotified(int fundId);
  Future<SavingFundModel> extendFund(int fundId, DateTime newEndDate, {DateTime? newStartDate});
  Future<SavingFundReportModel> getFundReport(int fundId);
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

  @override
  Future<ExpiredFundCheckModel> checkExpiredFund(int userId) async {
    final res = await api.get<ExpiredFundCheckModel>(
      '${ApiRoutes.checkExpiredFund}/$userId',
      fromJsonT: (json) => ExpiredFundCheckModel.fromMap(json),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'Không thể kiểm tra quỹ hết hạn',
      );
    }
    return res.data!;
  }

  @override
  Future<bool> markAsNotified(int fundId) async {
    final res = await api.patch<void>(
      '${ApiRoutes.savingFund}/$fundId/mark-notified',
    );
    if (!res.success) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'Không thể cập nhật trạng thái',
      );
    }
    return true;
  }

  @override
  Future<SavingFundModel> extendFund(
    int fundId,
    DateTime newEndDate, {
    DateTime? newStartDate,
  }) async {
    final body = <String, dynamic>{
      'new_end_date': newEndDate.toIso8601String(),
      if (newStartDate != null) 'new_start_date': newStartDate.toIso8601String(),
    };
    final res = await api.patch<SavingFundModel>(
      '${ApiRoutes.savingFund}/$fundId/extend',
      body: body,
      fromJsonT: (json) => SavingFundModel.fromMap(json),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'Không thể gia hạn quỹ',
      );
    }
    return res.data!;
  }

  @override
  Future<SavingFundReportModel> getFundReport(int fundId) async {
    final res = await api.get<SavingFundReportModel>(
      '${ApiRoutes.savingFund}/$fundId/report',
      fromJsonT: (json) => SavingFundReportModel.fromMap(json),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'Không thể tải báo cáo',
      );
    }
    return res.data!;
  }
}
