import 'package:image_picker/image_picker.dart';
import 'package:money_care/features/transaction/domain/entities/scan_receipt_entity.dart';
import 'package:money_care/features/transaction/domain/repositories/transaction_repository.dart';

class ScanReceiptUseCase {
  final TransactionRepository repository;

  ScanReceiptUseCase(this.repository);

  Future<ScanReceiptEntity> call(XFile image) {
    return repository.scanReceipt(image);
  }
}
