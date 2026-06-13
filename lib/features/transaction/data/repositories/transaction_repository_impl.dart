import 'package:money_care/features/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

import 'package:money_care/features/transaction/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDatasource remoteDatasource;

  TransactionRepositoryImpl({required this.remoteDatasource});

  @override
  Future<TransactionByTypeEntity> findAllByFilter(
    int userId,
    TransactionFilterDto dto, {
    int? coupleId,
  }) async {
    final model = await remoteDatasource.findAllByFilter(userId, dto, coupleId: coupleId);
    return model.toEntity();
  }

  @override
  Future<TotalByTypeEntity> getTotalByType(
    int userId,
    TransactionTotalsDto dto,
  ) async {
    final model = await remoteDatasource.getTotalByType(userId, dto);
    return model.toEntity();
  }

  @override
  Future<List<TotalByCategoryEntity>> getTotalByCate(
    int userId,
    TransactionTotalsDto dto,
  ) async {
    final models = await remoteDatasource.getTotalByCate(userId, dto);
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<TotalsByDateEntity> getTotalByDateEntity(
    int userId,
    TransactionTotalsDto dto,
  ) async {
    final model = await remoteDatasource.getTotalByDateEntity(userId, dto);
    return model.toEntity();
  }

  @override
  Future<TransactionEntity> createTransaction(
    TransactionCreateDto dto, {
    int? coupleId,
    int? payerId,
    String? splitMethod,
    List<Map<String, dynamic>>? splits,
  }) async {
    final model = await remoteDatasource.createTransaction(
      dto,
      coupleId: coupleId,
      payerId: payerId,
      splitMethod: splitMethod,
      splits: splits,
    );
    return model.toEntity();
  }

  @override
  Future<TransactionEntity> updateTransaction(
    TransactionCreateDto dto,
    int id, {
    int? coupleId,
    int? payerId,
    String? splitMethod,
    List<Map<String, dynamic>>? splits,
  }) async {
    final model = await remoteDatasource.updateTransaction(
      dto,
      id,
      coupleId: coupleId,
      payerId: payerId,
      splitMethod: splitMethod,
      splits: splits,
    );
    return model.toEntity();
  }

  @override
  Future<bool> deleteTransaction(int id) {
    return remoteDatasource.deleteTransaction(id);
  }

  @override
  Future<StatisticsSummaryEntity> getStatisticsSummary(int userId) async {
    final model = await remoteDatasource.getStatisticsSummary(userId);
    return model.toEntity();
  }

  @override
  Future<bool> exportReport(
    int userId,
    TransactionFilterDto dto,
    String format,
  ) {
    return remoteDatasource.exportReport(userId, dto, format);
  }
}
