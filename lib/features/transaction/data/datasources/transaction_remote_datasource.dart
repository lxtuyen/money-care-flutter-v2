import 'package:image_picker/image_picker.dart';
import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/transaction/data/models/scan_receipt_model.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';

abstract class TransactionRemoteDatasource {
  Future<TransactionByTypeModel> findAllByFilter(
      int userId, TransactionFilterDto dto);
  Future<TotalByTypeModel> getTotalByType(
      int userId, TransactionTotalsDto dto);
  Future<List<TotalByCategoryEntityModel>> getTotalByCate(
      int userId, TransactionTotalsDto dto);
  Future<TotalsByDateEntityModel> getTotalByDateEntity(
      int userId, TransactionTotalsDto dto);
  Future<TransactionModel> createTransaction(TransactionCreateDto dto);
  Future<TransactionModel> updateTransaction(
      TransactionCreateDto dto, int id);
  Future<bool> deleteTransaction(int id);
  Future<ScanReceiptModel> scanReceipt(XFile image);
}

class TransactionRemoteDatasourceImpl implements TransactionRemoteDatasource {
  final ApiClient api;

  TransactionRemoteDatasourceImpl({required this.api});

  @override
  Future<TransactionByTypeModel> findAllByFilter(
      int userId, TransactionFilterDto dto) async {
    final res = await api.get<TransactionByTypeModel>(
      '${ApiRoutes.getTransactionsFilter}/$userId',
      queryParameters: dto.toQueryParams(),
      fromJsonT: (json) => TransactionByTypeModel.fromJson(json),
    );
    if (!res.success || res.data == null) throw Exception(res.message);
    return res.data!;
  }

  @override
  Future<TotalByTypeModel> getTotalByType(
      int userId, TransactionTotalsDto dto) async {
    final res = await api.get<TotalByTypeModel>(
      '${ApiRoutes.transaction}/$userId/total-by-type',
      queryParameters: dto.toJson(),
      fromJsonT: (json) => TotalByTypeModel.fromJson(json),
    );
    if (!res.success || res.data == null) throw Exception(res.message);
    return res.data!;
  }

  @override
  Future<List<TotalByCategoryEntityModel>> getTotalByCate(
      int userId, TransactionTotalsDto dto) async {
    final res = await api.get<List<TotalByCategoryEntityModel>>(
      '${ApiRoutes.transaction}/$userId/total-by-category',
      queryParameters: dto.toJson(),
      fromJsonT: (json) {
        final list = json as List<dynamic>;
        return list.map((e) => TotalByCategoryEntityModel.fromJson(e)).toList();
      },
    );
    if (!res.success || res.data == null) throw Exception(res.message);
    return res.data ?? [];
  }

  @override
  Future<TotalsByDateEntityModel> getTotalByDateEntity(
      int userId, TransactionTotalsDto dto) async {
    final res = await api.get<TotalsByDateEntityModel>(
      '${ApiRoutes.transaction}/$userId/total-by-day',
      queryParameters: dto.toJson(),
      fromJsonT: (json) => TotalsByDateEntityModel.fromJson(json),
    );
    if (!res.success || res.data == null) throw Exception(res.message);
    return res.data!;
  }

  @override
  Future<TransactionModel> createTransaction(TransactionCreateDto dto) async {
    final res = await api.post<TransactionModel>(
      ApiRoutes.transaction,
      body: dto.toJson(),
      fromJsonT: (json) => TransactionModel.fromJson(json),
    );
    if (!res.success || res.data == null) throw Exception(res.message);
    return res.data!;
  }

  @override
  Future<TransactionModel> updateTransaction(
      TransactionCreateDto dto, int id) async {
    final res = await api.put<TransactionModel>(
      '${ApiRoutes.transaction}/$id',
      body: dto.toJson(),
      fromJsonT: (json) => TransactionModel.fromJson(json),
    );
    if (!res.success || res.data == null) throw Exception(res.message);
    return res.data!;
  }

  @override
  Future<bool> deleteTransaction(int id) async {
    final res =
        await api.delete<void>('${ApiRoutes.transaction}/$id');
    return res.success;
  }

  @override
  Future<ScanReceiptModel> scanReceipt(XFile image) async {
    try {
      final res = await api.postMultipart<ScanReceiptModel>(
        ApiRoutes.scanReceipt,
        file: image,
        fromJsonT: (json) => ScanReceiptModel.fromJson(json),
      );

      if (!res.success || res.data == null) {
        throw Exception(res.message);
      }
      return res.data!;
    } catch (e) {
      throw Exception('Quét hoá đơn thất bại: $e');
    }
  }
}
