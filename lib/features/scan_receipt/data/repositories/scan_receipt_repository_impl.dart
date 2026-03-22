import 'package:image_picker/image_picker.dart';
import 'package:money_care/features/scan_receipt/data/datasources/scan_receipt_remote_datasource.dart';
import 'package:money_care/features/scan_receipt/domain/entities/scan_receipt_entity.dart';
import 'package:money_care/features/scan_receipt/domain/repositories/scan_receipt_repository.dart';

class ScanReceiptRepositoryImpl implements ScanReceiptRepository {
  final ScanReceiptRemoteDatasource remoteDatasource;

  ScanReceiptRepositoryImpl({required this.remoteDatasource});

  @override
  Future<ScanReceiptEntity> scanReceipt(XFile image) async {
    final model = await remoteDatasource.scanReceipt(image);
    return model.toEntity();
  }
}
