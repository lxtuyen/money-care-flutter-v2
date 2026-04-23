import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

/// Intent labels — must match label_map.json from training
enum Intent {
  addCategory('add_category'),
  addExpense('add_expense'),
  addIncome('add_income'),
  getCategory('get_category'),
  getExpense('get_expense'),
  getIncome('get_income'),
  unknown('unknown');

  final String value;
  const Intent(this.value);

  static Intent fromString(String s) =>
      Intent.values.firstWhere((e) => e.value == s, orElse: () => Intent.unknown);
}

/// Result from intent classification.
class IntentResult {
  final Intent intent;
  final double confidence;

  const IntentResult({required this.intent, required this.confidence});

  bool get isConfident => confidence >= 0.80;

  @override
  String toString() =>
      'IntentResult(${intent.value}, conf=${confidence.toStringAsFixed(2)})';
}

/// On-device MobileBERT intent classifier using TFLite.
///
/// Load once, reuse across calls:
/// ```dart
/// final clf = IntentClassifier();
/// await clf.initialize();
/// final result = await clf.classify("hôm nay chi 50k ăn trưa");
/// ```
class IntentClassifier {
  static const _modelAsset = 'assets/ml/mobilebert_intent.tflite';
  static const _vocabAsset = 'assets/ml/vocab.txt';
  static const _labelAsset = 'assets/ml/label_map.json';
  static const _maxLength  = 64;
  static const _clsToken   = 101; // [CLS]
  static const _sepToken   = 102; // [SEP]
  static const _padToken   = 0;   // [PAD]
  static const _unkToken   = 100; // [UNK]

  Interpreter? _interpreter;
  final Map<String, int> _vocab = {};
  Map<int, String> _labelMap = {};
  bool _initialized = false;

  bool get isInitialized => _initialized;

  // ────────────────────────────────────────────────────────────────────────────
  // Initialization
  // ────────────────────────────────────────────────────────────────────────────

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Load TFLite model
      _interpreter = await Interpreter.fromAsset(_modelAsset);

      // Load vocab
      final vocabRaw = await rootBundle.loadString(_vocabAsset);
      final lines = vocabRaw.split('\n');
      for (int i = 0; i < lines.length; i++) {
        final tok = lines[i].trim();
        if (tok.isNotEmpty) _vocab[tok] = i;
      }

      // Load label map: {"0": "add_expense", ...}
      final labelRaw = await rootBundle.loadString(_labelAsset);
      final labelJson = Map<String, dynamic>.from(jsonDecode(labelRaw));
      _labelMap = {
        for (final e in labelJson.entries) int.parse(e.key): e.value as String
      };

      _initialized = true;
    } catch (e) {
      _initialized = false;
      rethrow;
    }
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _initialized = false;
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Inference
  // ────────────────────────────────────────────────────────────────────────────

  Future<IntentResult> classify(String text) async {
    if (!_initialized) await initialize();

    final tokens   = _tokenize(text.toLowerCase());
    final inputIds = _buildInputIds(tokens);
    final masks    = _buildMask(inputIds);
    final typeIds  = List<int>.filled(_maxLength, 0);

    // TFLite expects shape [1, maxLength] with int64 inputs
    final inputIdsTensor  = [inputIds];
    final masksTensor     = [masks];
    final typeIdsTensor   = [typeIds];

    final numLabels = _labelMap.length;

    // Use reshaped Float32List for output — avoids type mismatch with tflite_flutter
    final outputRaw = Float32List(numLabels);
    final outputTensor = [outputRaw];

    // runForMultipleInputs: output map key is 0-indexed output slot (not tensor index)
    _interpreter!.runForMultipleInputs(
      [inputIdsTensor, masksTensor, typeIdsTensor],
      {0: outputTensor},
    );

    final logits = outputRaw.map((v) => v.toDouble()).toList();
    final softmax = _softmax(logits);
    final maxIdx = softmax.indexOf(softmax.reduce(math.max));
    final confidence = softmax[maxIdx];

    final intentStr = _labelMap[maxIdx] ?? 'unknown';
    final intent = Intent.fromString(intentStr);

    return IntentResult(intent: intent, confidence: confidence);
  }

  // ────────────────────────────────────────────────────────────────────────────
  // WordPiece Tokenization (MobileBERT uncased — with Vietnamese normalization)
  // ────────────────────────────────────────────────────────────────────────────

  List<int> _tokenize(String text) {
    final tokens = <int>[];
    // Normalize: strip Vietnamese diacritics so tokens match MobileBERT ASCII vocab
    // text is already lowercased by the caller (classify)
    final normalized = _normalizeVietnamese(text);
    // Split by whitespace and punctuation
    final words = normalized.split(RegExp(r'[\s\p{P}]+', unicode: true));

    for (final word in words) {
      if (word.isEmpty) continue;
      final wordTokens = _wordPiece(word);
      tokens.addAll(wordTokens);
    }
    return tokens;
  }

  /// Strip Vietnamese diacritics so words map to MobileBERT's ASCII vocab.
  /// e.g. "hôm" → "hom", "trưa" → "trua", "tiêu" → "tieu"
  String _normalizeVietnamese(String text) {
    const Map<String, String> vietMap = {
      'à': 'a', 'á': 'a', 'ả': 'a', 'ã': 'a', 'ạ': 'a',
      'ă': 'a', 'ằ': 'a', 'ắ': 'a', 'ẳ': 'a', 'ẵ': 'a', 'ặ': 'a',
      'â': 'a', 'ầ': 'a', 'ấ': 'a', 'ẩ': 'a', 'ẫ': 'a', 'ậ': 'a',
      'è': 'e', 'é': 'e', 'ẻ': 'e', 'ẽ': 'e', 'ẹ': 'e',
      'ê': 'e', 'ề': 'e', 'ế': 'e', 'ể': 'e', 'ễ': 'e', 'ệ': 'e',
      'ì': 'i', 'í': 'i', 'ỉ': 'i', 'ĩ': 'i', 'ị': 'i',
      'ò': 'o', 'ó': 'o', 'ỏ': 'o', 'õ': 'o', 'ọ': 'o',
      'ô': 'o', 'ồ': 'o', 'ố': 'o', 'ổ': 'o', 'ỗ': 'o', 'ộ': 'o',
      'ơ': 'o', 'ờ': 'o', 'ớ': 'o', 'ở': 'o', 'ỡ': 'o', 'ợ': 'o',
      'ù': 'u', 'ú': 'u', 'ủ': 'u', 'ũ': 'u', 'ụ': 'u',
      'ư': 'u', 'ừ': 'u', 'ứ': 'u', 'ử': 'u', 'ữ': 'u', 'ự': 'u',
      'ỳ': 'y', 'ý': 'y', 'ỷ': 'y', 'ỹ': 'y', 'ỵ': 'y',
      'đ': 'd',
    };
    final buf = StringBuffer();
    // Use runes to iterate over Unicode code points correctly
    for (final rune in text.runes) {
      final ch = String.fromCharCode(rune);
      buf.write(vietMap[ch] ?? ch);
    }
    return buf.toString();
  }

  /// Simple WordPiece encoding. Falls back to [UNK] for unknown tokens.
  List<int> _wordPiece(String word) {
    // Try full word first
    if (_vocab.containsKey(word)) return [_vocab[word]!];

    // Try splitting into sub-words
    final subwords = <int>[];
    var start = 0;
    var isBad = false;

    while (start < word.length) {
      var end = word.length;
      int? curId;

      while (start < end) {
        var substr = word.substring(start, end);
        if (start > 0) substr = '##$substr';
        if (_vocab.containsKey(substr)) {
          curId = _vocab[substr];
          break;
        }
        end--;
      }

      if (curId == null) {
        isBad = true;
        break;
      }
      subwords.add(curId);
      start = end;
    }

    return isBad ? [_unkToken] : subwords;
  }

  List<int> _buildInputIds(List<int> tokens) {
    // [CLS] + tokens (truncated) + [SEP] + padding
    final maxTokens = _maxLength - 2;
    final truncated = tokens.length > maxTokens
        ? tokens.sublist(0, maxTokens)
        : tokens;

    final ids = <int>[_clsToken, ...truncated, _sepToken];
    while (ids.length < _maxLength) {
      ids.add(_padToken);
    }
    return ids;
  }

  List<int> _buildMask(List<int> ids) =>
      ids.map((id) => id != _padToken ? 1 : 0).toList();

  List<double> _softmax(List<double> logits) {
    final maxLogit = logits.reduce(math.max);
    final exps = logits.map((x) => math.exp(x - maxLogit)).toList();
    final sum = exps.reduce((a, b) => a + b);
    return exps.map((x) => x / sum).toList();
  }
}
