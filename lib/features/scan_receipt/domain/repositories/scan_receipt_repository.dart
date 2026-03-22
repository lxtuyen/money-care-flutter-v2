import 'package:image_picker/image_picker.dart';
import 'package:money_care/features/scan_receipt/domain/entities/scan_receipt_entity.dart';

abstract class ScanReceiptRepository {
  Future<ScanReceiptEntity> scanReceipt(XFile image);
}
