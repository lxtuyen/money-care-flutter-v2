import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/errors/exceptions.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/fund/data/models/models.dart';

abstract class FundRemoteDatasource {
  Future<FundModel> createFund(FundDto dto);
  Future<List<FundModel>> getFundsByUser(int userId);
  Future<FundModel> getFund(int id);
  Future<FundModel> updateFund(FundDto dto);
  Future<bool> deleteFund(int id);
  Future<FundModel> selectFund(int userId, int fundId);
  Future<ExpiredFundCheckModel> checkExpiredFund(int userId);
  Future<bool> markAsNotified(int fundId);
  Future<FundModel> extendFund(int fundId, DateTime newEndDate, {DateTime? newStartDate});
  Future<FundReportModel> getFundReport(int fundId);
}

class FundRemoteDatasourceImpl implements FundRemoteDatasource {
  final ApiClient api;

  FundRemoteDatasourceImpl({required this.api});

  @override
  Future<FundModel> createFund(FundDto dto) async {
    final res = await api.post<FundModel>(
      ApiRoutes.fund,
      body: dto.toJsonCreate(),
      fromJsonT: (json) => FundModel.fromJson(json),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'Không thể tạo quỹ tiết kiệm',
      );
    }
    return res.data!;
  }

  @override
  Future<List<FundModel>> getFundsByUser(int userId) async {
    final res = await api.get<List<FundModel>>(
      '${ApiRoutes.getFunds}/$userId',
      fromJsonT: (json) {
        final list = json as List;
        return list.map((e) => FundModel.fromJson(e)).toList();
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
  Future<FundModel> getFund(int id) async {
    final res = await api.get<FundModel>(
      '${ApiRoutes.fund}/$id',
      fromJsonT: (json) => FundModel.fromJson(json),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'Không thể tải quỹ tiết kiệm',
      );
    }
    return res.data!;
  }

  @override
  Future<FundModel> updateFund(FundDto dto) async {
    final res = await api.patch<FundModel>(
      '${ApiRoutes.fund}/${dto.id}',
      body: dto.toJsonUpdate(),
      fromJsonT: (json) => FundModel.fromJson(json),
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
  Future<bool> deleteFund(int id) async {
    final res = await api.delete<void>('${ApiRoutes.fund}/$id');
    if (!res.success) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'Không thể xóa quỹ tiết kiệm',
      );
    }
    return res.success;
  }

  @override
  Future<FundModel> selectFund(int userId, int fundId) async {
    final res = await api.patch<FundModel>(
      '${ApiRoutes.selectFund}/$fundId',
      body: {'userId': userId},
      fromJsonT: (json) => FundModel.fromJson(json),
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
      fromJsonT: (json) => ExpiredFundCheckModel.fromJson(json),
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
      '${ApiRoutes.fund}/$fundId/mark-notified',
    );
    if (!res.success) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'Không thể cập nhật trạng thái',
      );
    }
    return true;
  }

  @override
  Future<FundModel> extendFund(
    int fundId,
    DateTime newEndDate, {
    DateTime? newStartDate,
  }) async {
    final body = <String, dynamic>{
      'new_end_date': newEndDate.toIso8601String(),
      if (newStartDate != null) 'new_start_date': newStartDate.toIso8601String(),
    };
    final res = await api.patch<FundModel>(
      '${ApiRoutes.fund}/$fundId/extend',
      body: body,
      fromJsonT: (json) => FundModel.fromJson(json),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'Không thể gia hạn quỹ',
      );
    }
    return res.data!;
  }

  @override
  Future<FundReportModel> getFundReport(int fundId) async {
    final res = await api.get<FundReportModel>(
      '${ApiRoutes.fund}/$fundId/report',
      fromJsonT: (json) => FundReportModel.fromJson(json),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'Không thể tải báo cáo',
      );
    }
    return res.data!;
  }
}
