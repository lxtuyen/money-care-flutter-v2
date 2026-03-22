import 'package:image_picker/image_picker.dart';
import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/scan_receipt/data/models/scan_receipt_model.dart';

abstract class ScanReceiptRemoteDatasource {
  Future<ScanReceiptModel> scanReceipt(XFile image);
}

class ScanReceiptRemoteDatasourceImpl implements ScanReceiptRemoteDatasource {
  final ApiClient api;

  ScanReceiptRemoteDatasourceImpl({required this.api});

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
