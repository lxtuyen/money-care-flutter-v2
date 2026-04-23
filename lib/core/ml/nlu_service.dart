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
  bool get isConfident => confidence >= 0.80;

  /// True if this is a basic CRUD intent (not a complex analysis request).
  bool get isBasicCrud {
    return const {
      Intent.addExpense,
      Intent.addIncome,
      Intent.getExpense,
      Intent.getIncome,
      Intent.addCategory,
      Intent.getCategory,
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
    } catch (_) {
      intentResult = const IntentResult(
        intent: Intent.unknown,
        confidence: 0.0,
      );
    }

    final entities = EntityExtractor.extract(text);

    final result = NluResult(
      intent: intentResult.intent,
      confidence: intentResult.confidence,
      entities: entities,
    );

    // THÊM DÒNG NÀY ĐỂ KIỂM TRA
    print('-------------------------------------------');
    print('🤖 NLU Result for: "$text"');
    print('Detected Intent: ${result.intent.value}');
    print('Confidence: ${(result.confidence * 100).toStringAsFixed(1)}%');
    print('Confident enough? ${result.isConfident ? "✅ YES (Offline)" : "❌ NO (Fallback to Gemini)"}');
    print('-------------------------------------------');

    return result;
  }
}
