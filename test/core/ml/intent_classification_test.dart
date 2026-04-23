import 'package:flutter_test/flutter_test.dart';
import 'package:money_care/core/ml/intent_classifier.dart';

void main() {
  // Cần cái này để load các file từ assets trong môi trường test
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MobileBERT Intent Classification Tests', () {
    late IntentClassifier classifier;

    setUpAll(() async {
      classifier = IntentClassifier();
      // Chú ý: Trong môi trường test Flutter thuần túy (không device), 
      // tflite_flutter có thể cần binary library. Nếu chạy trên máy thật/emulator sẽ ổn định hơn.
    });

    test('Verify model initialization', () async {
      await classifier.initialize();
      expect(classifier.isInitialized, isTrue);
    });

    test('Classify: Add Expense', () async {
      final result = await classifier.classify('hôm nay tôi chi 100k cho ăn sáng');
      print('Test [Add Expense]: ${result.intent.value} (conf: ${result.confidence})');
      expect(result.intent, Intent.addExpense);
      expect(result.confidence, greaterThan(0.5));
    });

    test('Classify: Add Income', () async {
      final result = await classifier.classify('nhận lương 10 triệu hôm nay');
      print('Test [Add Income]: ${result.intent.value} (conf: ${result.confidence})');
      expect(result.intent, Intent.addIncome);
    });

    test('Classify: Get Expense (Query)', () async {
      final result = await classifier.classify('tháng này tôi đã tiêu hết bao nhiêu?');
      print('Test [Get Expense]: ${result.intent.value} (conf: ${result.confidence})');
      expect(result.intent, Intent.getExpense);
    });

    test('Classify: Add Category', () async {
      final result = await classifier.classify('thêm danh mục tiền nhà vào phần chi tiêu');
      print('Test [Add Category]: ${result.intent.value} (conf: ${result.confidence})');
      expect(result.intent, Intent.addCategory);
    });
  });
}
