import 'package:money_care/core/ml/intent_classifier.dart';
import 'package:money_care/core/ml/entity_extractor.dart';

/// Combined NLU result: intent + confidence + extracted entities.
class NluResult {
  final Intent intent;
  final double confidence;
  final EntityResult entities;

  const NluResult({
    required this.intent,
    required this.confidence,
    required this.entities,
  });

  /// True if the model is confident enough to act without Gemini fallback.
  bool get isConfident => confidence >= 0.30; // Hạ xuống 0.30 để ưu tiên xử lý Offline hơn

  /// True if this is a basic CRUD intent (not a complex analysis request).
  bool get isBasicCrud {
    return const {
      Intent.addExpense,
      Intent.addIncome,
      Intent.getExpense,
      Intent.getIncome,
    }.contains(intent);
  }

  @override
  String toString() =>
      'NluResult(intent=${intent.value}, conf=${confidence.toStringAsFixed(2)}, entities=$entities)';
}

/// Orchestrates [IntentClassifier] and [EntityExtractor] into a single call.
///
/// This service is meant to be a singleton — initialize once at app start.
class NluService {
  final IntentClassifier _classifier;

  NluService({IntentClassifier? classifier})
      : _classifier = classifier ?? IntentClassifier();

  bool get isReady => _classifier.isInitialized;

  /// Initialize TFLite model. Call once before first [process] call.
  Future<void> initialize() => _classifier.initialize();

  void dispose() => _classifier.dispose();

  /// Runs intent classification + entity extraction on [text].
  ///
  /// Safe to call even if initialization failed — returns [Intent.unknown]
  /// with confidence 0.0 so the caller can fallback to Gemini.
  Future<NluResult> process(String text) async {
    IntentResult intentResult;

    try {
      intentResult = await _classifier.classify(text);
    } catch (e) {
      print('❌ NLU Error: $e');
      intentResult = const IntentResult(
        intent: Intent.unknown,
        confidence: 0.0,
      );
    }

    final entities = EntityExtractor.extract(text);

    var finalIntent = intentResult.intent;
    
    // 💡 Correction Logic: Cưỡng ép Intent nếu model phân loại sai hoặc không chắc chắn
    final textLower = text.toLowerCase();
    
    // 1. Kiểm tra xem có phải là câu hỏi/truy vấn không (getExpense/getIncome)
    if (textLower.contains('bao nhiêu') || 
        textLower.contains('xem') || 
        textLower.contains('liệt kê') || 
        textLower.contains('thống kê') ||
        textLower.contains('báo cáo') ||
        textLower.contains('mấy')) {
      
      // Nếu có từ khóa thu nhập trong câu hỏi -> getIncome
      if (textLower.contains('lương') || textLower.contains('thu nhập') || textLower.contains('nhận')) {
        finalIntent = Intent.getIncome;
      } else {
        finalIntent = Intent.getExpense;
      }
      print("💡 [Correction] Detected query intent (getExpense/getIncome)");
    } 
    // 2. Nếu không phải câu hỏi, kiểm tra xem có từ khóa THU NHẬP không (Ưu tiên cao)
    else if (textLower.contains('lương') || 
             textLower.contains('thưởng') || 
             textLower.contains('thu nhập') ||
             textLower.contains('nhận') ||
             textLower.contains('lời') ||
             textLower.contains('lãi') ||
             textLower.contains('lì xì') ||
             textLower.contains('quà') ||
             textLower.contains('biếu') ||
             textLower.contains('tặng') ||
             textLower.contains('tạm ứng')) {
      finalIntent = Intent.addIncome;
      print("💡 [Correction] Forced to addIncome based on keywords");
    }
    // 3. Nếu không phải thu nhập, kiểm tra từ khóa CHI TIÊU
    else if (finalIntent == Intent.unknown || intentResult.confidence < 0.25) {
      if (textLower.contains('chi') || 
          textLower.contains('tiêu') || 
          textLower.contains('nộp') || 
          textLower.contains('đóng') || 
          textLower.contains('trả') ||
          textLower.contains('mất') ||
          textLower.contains('hết') ||
          textLower.contains('mua') ||
          textLower.contains('tiền') || // Thêm "tiền" (ví dụ: tiền điện, tiền nhà)
          textLower.contains('phí')) {
        finalIntent = Intent.addExpense;
        print("💡 [Correction] Forced to addExpense based on keywords");
      }
    }

    final result = NluResult(
      intent: finalIntent,
      confidence: intentResult.confidence,
      entities: entities,
    );

    // THÊM DÒNG NÀY ĐỂ KIỂM TRA
    print('-------------------------------------------');
    print('🤖 NLU Result for: "$text"');
    print('Detected Intent: ${result.intent.value}');
    print('Confidence: ${(result.confidence * 100).toStringAsFixed(1)}%');
    print('Entities: ${result.entities}');
    print('Confident enough? ${result.isConfident ? "✅ YES (Offline)" : "❌ NO (Fallback to Gemini)"}');
    print('-------------------------------------------');

    return result;
  }
}
