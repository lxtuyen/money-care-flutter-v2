import 'package:image_picker/image_picker.dart';
import 'package:money_care/features/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:money_care/features/transaction/domain/entities/scan_receipt_entity.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

import 'package:money_care/features/transaction/domain/repositories/transaction_repository.dart';

import 'package:money_care/core/services/ocr_service.dart';
import 'package:money_care/features/transaction/data/utils/receipt_parser.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDatasource remoteDatasource;
  final OCRService ocrService;

  TransactionRepositoryImpl({
    required this.remoteDatasource,
    required this.ocrService,
  });

  @override
  Future<TransactionByTypeEntity> findAllByFilter(
    int userId,
    TransactionFilterDto dto,
  ) async {
    final model = await remoteDatasource.findAllByFilter(userId, dto);
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
  Future<TransactionEntity> createTransaction(TransactionCreateDto dto) async {
    final model = await remoteDatasource.createTransaction(dto);
    return model.toEntity();
  }

  @override
  Future<TransactionEntity> updateTransaction(
    TransactionCreateDto dto,
    int id,
  ) async {
    final model = await remoteDatasource.updateTransaction(dto, id);
    return model.toEntity();
  }

  @override
  Future<bool> deleteTransaction(int id) {
    return remoteDatasource.deleteTransaction(id);
  }

  @override
  Future<ScanReceiptEntity> scanReceipt(XFile image) async {
    ReceiptParseResult? localResult;

    try {
      final recognizedText = await ocrService.processImage(image.path);
      localResult = ReceiptParser.parse(recognizedText);

      if (!localResult.shouldUseAiRefinement) {
        return localResult.entity;
      }
    } catch (e) {
      localResult = null;
    }

    try {
      final model = await remoteDatasource.scanReceipt(
        image,
        localResult: localResult,
      );
      final aiResult = model.toEntity();
      if (localResult == null) return aiResult;
      return ReceiptParser.mergeWithAiResult(localResult, aiResult);
    } catch (e) {
      if (localResult != null) return localResult.entity;
      throw Exception('Receipt scan failed: $e');
    }
  }

  @override
  Future<StatisticsSummaryEntity> getStatisticsSummary(
    int userId,
    TransactionTotalsDto dto,
  ) async {
    final model = await remoteDatasource.getStatisticsSummary(userId, dto);
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
