import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';

class OCRService {
  final TextRecognizer _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  Future<RecognizedText> processImage(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    return await _textRecognizer.processImage(inputImage);
  }

  Future<RecognizedText> processInputImage(InputImage inputImage) async {
    return await _textRecognizer.processImage(inputImage);
  }

  bool checkIfReceipt(RecognizedText recognizedText) {
    if (recognizedText.text.isEmpty) return false;

    final text = AppHelperFunction.normalizeVietnamese(recognizedText.text);
    final keywords = [
      'tong',
      'thanh toan',
      'hoa don',
      'total',
      'bill',
      'receipt',
      'vnd',
      'thanh tien',
      'can thanh toan',
    ];

    var count = 0;
    for (final keyword in keywords) {
      if (text.contains(keyword)) count++;
    }

    return count >= 2 || recognizedText.blocks.length > 5;
  }

  void dispose() {
    _textRecognizer.close();
  }
}
