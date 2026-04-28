import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:money_care/features/transaction/domain/repositories/transaction_repository.dart';

class ExportReportUseCase {
  final TransactionRepository repository;

  ExportReportUseCase(this.repository);

  Future<bool> call(int userId, TransactionFilterDto dto, String format) {
    return repository.exportReport(userId, dto, format);
  }
}
