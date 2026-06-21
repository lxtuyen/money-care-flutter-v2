import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<TransactionByTypeEntity> findAllByFilter(
    int userId,
    TransactionFilterDto dto, {
    int? coupleId,
  });
  Future<TotalByTypeEntity> getTotalByType(
    int userId,
    TransactionTotalsDto dto,
  );
  Future<List<TotalByCategoryEntity>> getTotalByCate(
    int userId,
    TransactionTotalsDto dto,
  );
  Future<TotalsByDateEntity> getTotalByDateEntity(
    int userId,
    TransactionTotalsDto dto,
  );
  Future<TransactionEntity> createTransaction(
    TransactionCreateDto dto, {
    int? coupleId,
    int? payerId,
    String? splitMethod,
    List<Map<String, dynamic>>? splits,
  });
  Future<TransactionEntity> updateTransaction(
    TransactionCreateDto dto,
    int id, {
    int? coupleId,
    int? payerId,
    String? splitMethod,
    List<Map<String, dynamic>>? splits,
  });
  Future<bool> deleteTransaction(int id);
  Future<StatisticsSummaryEntity> getStatisticsSummary(int userId);
  Future<bool> exportReport(
    int userId,
    TransactionFilterDto dto,
    String format,
  );
  Future<DateTime?> getFirstTransactionDate(int userId);
}
