import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

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

    final text = recognizedText.text.toLowerCase();
    final keywords = [
      'tổng',
      'thanh toán',
      'hóa đơn',
      'total',
      'bill',
      'receipt',
      'vnd',
      'đ',
      'thành tiền',
    ];

    int count = 0;
    for (var kw in keywords) {
      if (text.contains(kw)) count++;
    }

    // Heuristic: If we see at least 2 keywords, it's likely a receipt
    // Or if there's a lot of text lines (more than 5)
    return count >= 2 || recognizedText.blocks.length > 5;
  }

  void dispose() {
    _textRecognizer.close();
  }
}
