import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/errors/exceptions.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/spending_plan/data/models/spending_plan_model.dart';

abstract class SpendingPlanRemoteDatasource {
  Future<List<SpendingPlanModel>> getPlans();
  Future<SpendingPlanModel?> getActivePlan();
  Future<SpendingPlanModel> getPlan(int id);
  Future<SpendingPlanModel> createPlan(CreateSpendingPlanRequest request);
  Future<SpendingPlanModel> updatePlan(
    int id,
    UpdateSpendingPlanRequest request,
  );
  Future<void> deletePlan(int id);
  Future<SpendingPlanModel> activatePlan(int id);
  Future<SpendingPlanModel> archivePlan(int id);
  Future<SpendingPlanModel> clonePlan(int id, {int? month, int? year});
  Future<SpendingPlanModel> createFixedExpense(
    int planId,
    CreateFixedExpenseRequest request,
  );
  Future<SpendingPlanModel> updateFixedExpense(
    int planId,
    int expenseId,
    Map<String, dynamic> data,
  );
  Future<SpendingPlanModel> deleteFixedExpense(int planId, int expenseId);
  Future<SpendingPlanModel> markFixedExpensePaid(
    int planId,
    int expenseId,
    bool isPaid,
  );
}

class SpendingPlanRemoteDatasourceImpl implements SpendingPlanRemoteDatasource {
  final ApiClient api;

  SpendingPlanRemoteDatasourceImpl({required this.api});

  @override
  Future<List<SpendingPlanModel>> getPlans() async {
    final res = await api.get<List<SpendingPlanModel>>(
      ApiRoutes.spendingPlans,
      fromJsonT: (json) {
        final list = json as List;
        return list.map((item) => SpendingPlanModel.fromJson(item)).toList();
      },
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty
            ? res.message
            : 'Không thể tải danh sách kế hoạch chi tiêu',
      );
    }
    return res.data!;
  }

  @override
  Future<SpendingPlanModel?> getActivePlan() async {
    final res = await api.get<SpendingPlanModel?>(
      '${ApiRoutes.spendingPlans}/active',
      fromJsonT: (json) =>
          json == null ? null : SpendingPlanModel.fromJson(json),
    );
    if (!res.success) {
      throw ServerException(
        res.message.isNotEmpty
            ? res.message
            : 'Không thể tải kế hoạch đang áp dụng',
      );
    }
    return res.data;
  }

  @override
  Future<SpendingPlanModel> getPlan(int id) async {
    final res = await api.get<SpendingPlanModel>(
      '${ApiRoutes.spendingPlans}/$id',
      fromJsonT: (json) => SpendingPlanModel.fromJson(json),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'Không thể tải kế hoạch',
      );
    }
    return res.data!;
  }

  @override
  Future<SpendingPlanModel> createPlan(
    CreateSpendingPlanRequest request,
  ) async {
    final res = await api.post<SpendingPlanModel>(
      ApiRoutes.spendingPlans,
      body: request.toJson(),
      fromJsonT: (json) => SpendingPlanModel.fromJson(json),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'Không thể tạo kế hoạch',
      );
    }
    return res.data!;
  }

  @override
  Future<SpendingPlanModel> updatePlan(
    int id,
    UpdateSpendingPlanRequest request,
  ) async {
    final res = await api.patch<SpendingPlanModel>(
      '${ApiRoutes.spendingPlans}/$id',
      body: request.toJson(),
      fromJsonT: (json) => SpendingPlanModel.fromJson(json),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty
            ? res.message
            : 'KhÃ´ng thá»ƒ cáº­p nháº­t káº¿ hoáº¡ch',
      );
    }
    return res.data!;
  }

  @override
  Future<void> deletePlan(int id) async {
    final res = await api.delete<dynamic>('${ApiRoutes.spendingPlans}/$id');
    if (!res.success) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'KhÃ´ng thá»ƒ xÃ³a káº¿ hoáº¡ch',
      );
    }
  }

  @override
  Future<SpendingPlanModel> activatePlan(int id) async {
    final res = await api.patch<SpendingPlanModel>(
      '${ApiRoutes.spendingPlans}/$id/activate',
      fromJsonT: (json) => SpendingPlanModel.fromJson(json),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'Không thể áp dụng kế hoạch',
      );
    }
    return res.data!;
  }

  @override
  Future<SpendingPlanModel> archivePlan(int id) async {
    final res = await api.patch<SpendingPlanModel>(
      '${ApiRoutes.spendingPlans}/$id/archive',
      fromJsonT: (json) => SpendingPlanModel.fromJson(json),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'Không thể lưu trữ kế hoạch',
      );
    }
    return res.data!;
  }

  @override
  Future<SpendingPlanModel> clonePlan(int id, {int? month, int? year}) async {
    final body = <String, dynamic>{};
    if (month != null) body['month'] = month;
    if (year != null) body['year'] = year;

    final res = await api.post<SpendingPlanModel>(
      '${ApiRoutes.spendingPlans}/$id/clone',
      body: body,
      fromJsonT: (json) => SpendingPlanModel.fromJson(json),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'Không thể nhân bản kế hoạch',
      );
    }
    return res.data!;
  }

  @override
  Future<SpendingPlanModel> createFixedExpense(
    int planId,
    CreateFixedExpenseRequest request,
  ) async {
    final res = await api.post<SpendingPlanModel>(
      '${ApiRoutes.spendingPlans}/$planId/fixed-expenses',
      body: request.toJson(),
      fromJsonT: (json) => SpendingPlanModel.fromJson(json),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'Không thể thêm chi phí cố định',
      );
    }
    return res.data!;
  }

  @override
  Future<SpendingPlanModel> updateFixedExpense(
    int planId,
    int expenseId,
    Map<String, dynamic> data,
  ) async {
    final res = await api.patch<SpendingPlanModel>(
      '${ApiRoutes.spendingPlans}/$planId/fixed-expenses/$expenseId',
      body: data,
      fromJsonT: (json) => SpendingPlanModel.fromJson(json),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty
            ? res.message
            : 'Không thể cập nhật chi phí cố định',
      );
    }
    return res.data!;
  }

  @override
  Future<SpendingPlanModel> deleteFixedExpense(
    int planId,
    int expenseId,
  ) async {
    final res = await api.delete<SpendingPlanModel>(
      '${ApiRoutes.spendingPlans}/$planId/fixed-expenses/$expenseId',
      fromJsonT: (json) => SpendingPlanModel.fromJson(json),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'Không thể xóa chi phí cố định',
      );
    }
    return res.data!;
  }

  @override
  Future<SpendingPlanModel> markFixedExpensePaid(
    int planId,
    int expenseId,
    bool isPaid,
  ) async {
    final res = await api.patch<SpendingPlanModel>(
      '${ApiRoutes.spendingPlans}/$planId/fixed-expenses/$expenseId/pay',
      body: {'isPaid': isPaid},
      fromJsonT: (json) => SpendingPlanModel.fromJson(json),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'Không thể cập nhật trạng thái',
      );
    }
    return res.data!;
  }
}
