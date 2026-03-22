import 'package:image_picker/image_picker.dart';
import 'package:money_care/features/scan_receipt/domain/entities/scan_receipt_entity.dart';
import 'package:money_care/features/scan_receipt/domain/repositories/scan_receipt_repository.dart';

class ScanReceiptUseCase {
  final ScanReceiptRepository repository;

  ScanReceiptUseCase(this.repository);

  Future<ScanReceiptEntity> call(XFile image) {
    return repository.scanReceipt(image);
  }
}
