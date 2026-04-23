import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/errors/exceptions.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/saving_goal/data/models/models.dart';

abstract class SavingGoalRemoteDatasource {
  Future<SavingGoalModel> createSavingGoal(SavingGoalDto dto);
  Future<List<SavingGoalModel>> getSavingGoalsByUser(int userId);
  Future<SavingGoalModel> getSavingGoal(int id);
  Future<SavingGoalModel> updateSavingGoal(SavingGoalDto dto);
  Future<bool> deleteSavingGoal(int id);
  Future<SavingGoalModel?> selectSavingGoal(int userId, int id);
  Future<ExpiredGoalCheckModel> checkExpiredSavingGoal(int userId);
  Future<bool> markAsNotified(int id);
  Future<SavingGoalModel> extendSavingGoal(
    int id,
    DateTime newEndDate, {
    DateTime? newStartDate,
  });
  Future<SavingGoalReportModel> getSavingGoalReport(int id);
}

class SavingGoalRemoteDatasourceImpl implements SavingGoalRemoteDatasource {
  final ApiClient api;

  SavingGoalRemoteDatasourceImpl({required this.api});

  @override
  Future<SavingGoalModel> createSavingGoal(SavingGoalDto dto) async {
    final res = await api.post<SavingGoalModel>(
      ApiRoutes.savingGoal,
      body: dto.toJsonCreate(),
      fromJsonT: (json) => SavingGoalModel.fromJson(json),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty
            ? res.message
            : 'Không thể tạo mục tiêu tiết kiệm',
      );
    }
    return res.data!;
  }

  @override
  Future<List<SavingGoalModel>> getSavingGoalsByUser(int userId) async {
    final res = await api.get<List<SavingGoalModel>>(
      '${ApiRoutes.getSavingGoals}/$userId',
      fromJsonT: (json) {
        final list = json as List;
        return list.map((e) => SavingGoalModel.fromJson(e)).toList();
      },
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty
            ? res.message
            : 'Không thể tải danh sách mục tiêu tiết kiệm',
      );
    }
    return res.data!;
  }

  @override
  Future<SavingGoalModel> getSavingGoal(int id) async {
    final res = await api.get<SavingGoalModel>(
      '${ApiRoutes.savingGoal}/$id',
      fromJsonT: (json) => SavingGoalModel.fromJson(json),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty
            ? res.message
            : 'Không thể tải mục tiêu tiết kiệm',
      );
    }
    return res.data!;
  }

  @override
  Future<SavingGoalModel> updateSavingGoal(SavingGoalDto dto) async {
    final res = await api.patch<SavingGoalModel>(
      '${ApiRoutes.savingGoal}/${dto.id}',
      body: dto.toJsonUpdate(),
      fromJsonT: (json) => SavingGoalModel.fromJson(json),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty
            ? res.message
            : 'Không thể cập nhật mục tiêu tiết kiệm',
      );
    }
    return res.data!;
  }

  @override
  Future<bool> deleteSavingGoal(int id) async {
    final res = await api.delete<void>('${ApiRoutes.savingGoal}/$id');
    if (!res.success) {
      throw ServerException(
        res.message.isNotEmpty
            ? res.message
            : 'Không thể xóa mục tiêu tiết kiệm',
      );
    }
    return res.success;
  }

  @override
  Future<SavingGoalModel?> selectSavingGoal(int userId, int id) async {
    final res = await api.patch<SavingGoalModel?>(
      '${ApiRoutes.selectSavingGoal}/$id',
      body: {'userId': userId},
      fromJsonT: (json) => json == null ? null : SavingGoalModel.fromJson(json),
    );
    if (!res.success) {
      throw ServerException(
        res.message.isNotEmpty
            ? res.message
            : 'Không thể chọn mục tiêu tiết kiệm',
      );
    }
    return res.data;
  }

  @override
  Future<ExpiredGoalCheckModel> checkExpiredSavingGoal(int userId) async {
    final res = await api.get<ExpiredGoalCheckModel>(
      '${ApiRoutes.checkExpiredSavingGoal}/$userId',
      fromJsonT: (json) => ExpiredGoalCheckModel.fromJson(json),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty
            ? res.message
            : 'Không thể kiểm tra mục tiêu hết hạn',
      );
    }
    return res.data!;
  }

  @override
  Future<bool> markAsNotified(int id) async {
    final res = await api.patch<void>(
      '${ApiRoutes.savingGoal}/$id/mark-notified',
    );
    if (!res.success) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'Không thể cập nhật trạng thái',
      );
    }
    return true;
  }

  @override
  Future<SavingGoalModel> extendSavingGoal(
    int id,
    DateTime newEndDate, {
    DateTime? newStartDate,
  }) async {
    final body = <String, dynamic>{
      'new_end_date': newEndDate.toIso8601String(),
      if (newStartDate != null)
        'new_start_date': newStartDate.toIso8601String(),
    };
    final res = await api.patch<SavingGoalModel>(
      '${ApiRoutes.savingGoal}/$id/extend',
      body: body,
      fromJsonT: (json) => SavingGoalModel.fromJson(json),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'Không thể gia hạn mục tiêu',
      );
    }
    return res.data!;
  }

  @override
  Future<SavingGoalReportModel> getSavingGoalReport(int id) async {
    final res = await api.get<SavingGoalReportModel>(
      '${ApiRoutes.savingGoal}/$id/report',
      fromJsonT: (json) => SavingGoalReportModel.fromJson(json),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'Không thể tải báo cáo',
      );
    }
    return res.data!;
  }
}
