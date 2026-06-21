import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/transaction/data/models/statistics_summary_model.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';

abstract class TransactionRemoteDatasource {
  Future<TransactionByTypeModel> findAllByFilter(
    int userId,
    TransactionFilterDto dto, {
    int? coupleId,
  });
  Future<TotalByTypeModel> getTotalByType(int userId, TransactionTotalsDto dto);
  Future<List<TotalByCategoryEntityModel>> getTotalByCate(
    int userId,
    TransactionTotalsDto dto,
  );
  Future<TotalsByDateEntityModel> getTotalByDateEntity(
    int userId,
    TransactionTotalsDto dto,
  );
  Future<TransactionModel> createTransaction(
    TransactionCreateDto dto, {
    int? coupleId,
    int? payerId,
    String? splitMethod,
    List<Map<String, dynamic>>? splits,
  });
  Future<TransactionModel> updateTransaction(
    TransactionCreateDto dto,
    int id, {
    int? coupleId,
    int? payerId,
    String? splitMethod,
    List<Map<String, dynamic>>? splits,
  });
  Future<bool> deleteTransaction(int id);
  Future<StatisticsSummaryModel> getStatisticsSummary(int userId);
  Future<bool> exportReport(
    int userId,
    TransactionFilterDto dto,
    String format,
  );
  Future<DateTime?> getFirstTransactionDate(int userId);
}

class TransactionRemoteDatasourceImpl implements TransactionRemoteDatasource {
  final ApiClient api;

  TransactionRemoteDatasourceImpl({required this.api});

  String _userPath(int userId) => '${ApiRoutes.transaction}/$userId';

  @override
  Future<TransactionByTypeModel> findAllByFilter(
    int userId,
    TransactionFilterDto dto, {
    int? coupleId,
  }) async {
    final params = Map<String, dynamic>.from(dto.toQueryParams());
    if (coupleId != null) {
      params['coupleId'] = coupleId;
    }
    final res = await api.get<TransactionByTypeModel>(
      '${_userPath(userId)}/filter',
      queryParameters: params,
      fromJsonT: (json) => TransactionByTypeModel.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<TotalByTypeModel> getTotalByType(
    int userId,
    TransactionTotalsDto dto,
  ) async {
    final res = await api.get<TotalByTypeModel>(
      '${_userPath(userId)}/total-by-type',
      queryParameters: dto.toJson(),
      fromJsonT: (json) => TotalByTypeModel.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<List<TotalByCategoryEntityModel>> getTotalByCate(
    int userId,
    TransactionTotalsDto dto,
  ) async {
    final res = await api.get<List<TotalByCategoryEntityModel>>(
      '${_userPath(userId)}/total-by-category',
      queryParameters: dto.toJson(),
      fromJsonT: (json) {
        final list = json as List<dynamic>;
        return list.map((e) => TotalByCategoryEntityModel.fromJson(e)).toList();
      },
    );
    return res.unwrap();
  }

  @override
  Future<TotalsByDateEntityModel> getTotalByDateEntity(
    int userId,
    TransactionTotalsDto dto,
  ) async {
    final res = await api.get<TotalsByDateEntityModel>(
      '${_userPath(userId)}/total-by-day',
      queryParameters: dto.toJson(),
      fromJsonT: (json) => TotalsByDateEntityModel.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<TransactionModel> createTransaction(
    TransactionCreateDto dto, {
    int? coupleId,
    int? payerId,
    String? splitMethod,
    List<Map<String, dynamic>>? splits,
  }) async {
    final body = Map<String, dynamic>.from(dto.toJson());
    if (coupleId != null) {
      body['coupleId'] = coupleId;
    }
    if (payerId != null) {
      body['payerId'] = payerId;
    }
    if (splitMethod != null) {
      body['splitMethod'] = splitMethod;
    }
    if (splits != null) {
      body['splits'] = splits;
    }
    final res = await api.post<TransactionModel>(
      ApiRoutes.transaction,
      body: body,
      fromJsonT: (json) => TransactionModel.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<TransactionModel> updateTransaction(
    TransactionCreateDto dto,
    int id, {
    int? coupleId,
    int? payerId,
    String? splitMethod,
    List<Map<String, dynamic>>? splits,
  }) async {
    final body = Map<String, dynamic>.from(dto.toJson());
    if (coupleId != null) {
      body['coupleId'] = coupleId;
    }
    if (payerId != null) {
      body['payerId'] = payerId;
    }
    if (splitMethod != null) {
      body['splitMethod'] = splitMethod;
    }
    if (splits != null) {
      body['splits'] = splits;
    }
    final res = await api.put<TransactionModel>(
      '${ApiRoutes.transaction}/$id',
      body: body,
      fromJsonT: (json) => TransactionModel.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<bool> deleteTransaction(int id) async {
    final res = await api.delete<void>('${ApiRoutes.transaction}/$id');
    return res.success;
  }

  @override
  Future<StatisticsSummaryModel> getStatisticsSummary(int userId) async {
    final res = await api.get<StatisticsSummaryModel>(
      '${_userPath(userId)}/statistics-summary',
      fromJsonT: (json) => StatisticsSummaryModel.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<bool> exportReport(
    int userId,
    TransactionFilterDto dto,
    String format,
  ) async {
    final res = await api.post<void>(
      '${_userPath(userId)}/export',
      queryParameters: {'format': format},
      body: dto.toJson(),
    );
    if (!res.success) {
      throw Exception(
        res.message.isNotEmpty ? res.message : 'Không thể xuất báo cáo',
      );
    }
    return true;
  }

  @override
  Future<DateTime?> getFirstTransactionDate(int userId) async {
    final res = await api.get<Map<String, dynamic>>(
      '${_userPath(userId)}/first-transaction-date',
      fromJsonT: (json) => json as Map<String, dynamic>,
    );
    final data = res.unwrap();
    final dateStr = data['firstTransactionDate'] as String?;
    if (dateStr == null) return null;
    return DateTime.tryParse(dateStr);
  }
}
