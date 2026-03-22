import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_care/features/transaction/domain/entities/scan_receipt_entity.dart';
import 'package:money_care/features/transaction/domain/usecases/scan_receipt_usecases.dart';

class ScanReceiptController extends GetxController {
  final ScanReceiptUseCase scanReceiptUseCase;

  ScanReceiptController({required this.scanReceiptUseCase});

  final isScanning = false.obs;
  final errorMessage = ''.obs;

  final scanResult = Rxn<ScanReceiptEntity>();

  final ImagePicker picker = ImagePicker();

  Future<ScanReceiptEntity?> scan(ImageSource source) async {
    if (isScanning.value) return null;

    isScanning.value = true;
    errorMessage.value = '';

    try {
      final image = await picker.pickImage(source: source, imageQuality: 80);
      if (image == null) return null;

      final res = await scanReceiptUseCase(image);
      scanResult.value = res;
      return res;
    } catch (e) {
      errorMessage.value = e.toString();
      scanResult.value = null;
      return null;
    } finally {
      isScanning.value = false;
    }
  }
}
