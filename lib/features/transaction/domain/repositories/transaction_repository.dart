import 'package:image_picker/image_picker.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/domain/entities/scan_receipt_entity.dart';

abstract class TransactionRepository {
  Future<TransactionByTypeEntity> findAllByFilter(
      int userId, TransactionFilterDto dto);
  Future<TotalByTypeEntity> getTotalByType(
      int userId, TransactionTotalsDto dto);
  Future<List<TotalByCategoryEntity>> getTotalByCate(
      int userId, TransactionTotalsDto dto);
  Future<TotalsByDateEntity> getTotalByDateEntity(
      int userId, TransactionTotalsDto dto);
  Future<TransactionEntity> createTransaction(TransactionCreateDto dto);
  Future<TransactionEntity> updateTransaction(
      TransactionCreateDto dto, int id);
  Future<bool> deleteTransaction(int id);
  Future<ScanReceiptEntity> scanReceipt(XFile image);
  Future<StatisticsSummaryEntity> getStatisticsSummary(
      int userId, TransactionTotalsDto dto);
}
