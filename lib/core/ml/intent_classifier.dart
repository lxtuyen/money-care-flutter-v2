import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

/// Intent labels — must match label_map.json from training
enum Intent {
  addExpense('add_expense'),
  addIncome('add_income'),
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

  bool get isConfident => confidence >= 0.75;

  @override
  String toString() =>
      'IntentResult(${intent.value}, conf=${confidence.toStringAsFixed(2)})';
}

class IntentClassifier {
  static const _modelAsset = 'assets/ml/intent_model.tflite';
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

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      _interpreter = await Interpreter.fromAsset(_modelAsset);
      
      print('✅ Model Loaded: $_modelAsset');
      for (var i = 0; i < _interpreter!.getInputTensors().length; i++) {
        final t = _interpreter!.getInputTensor(i);
        print('   Input $i: ${t.name}, shape: ${t.shape}, type: ${t.type}');
      }
      for (var i = 0; i < _interpreter!.getOutputTensors().length; i++) {
        final t = _interpreter!.getOutputTensor(i);
        print('   Output $i: ${t.name}, shape: ${t.shape}, type: ${t.type}');
      }

      final vocabRaw = await rootBundle.loadString(_vocabAsset);
      final lines = vocabRaw.split('\n');
      for (int i = 0; i < lines.length; i++) {
        final tok = lines[i].trim();
        if (tok.isNotEmpty) _vocab[tok] = i;
      }

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

  Future<IntentResult> classify(String text) async {
    if (!_initialized) await initialize();

    final tokens   = _tokenize(text.toLowerCase());
    final inputIds = _buildInputIds(tokens);
    final masks    = _buildMask(inputIds);
    final typeIds  = List<int>.filled(_maxLength, 0);

    // Sử dụng Int32List và reshape để đảm bảo đúng định dạng [1, 64]
    final inputIdsTensor = Int32List.fromList(inputIds).reshape([1, _maxLength]);
    final masksTensor    = Int32List.fromList(masks).reshape([1, _maxLength]);
    final typeIdsTensor  = Int32List.fromList(typeIds).reshape([1, _maxLength]);

    final numLabels = _labelMap.length;
    // Khởi tạo output tensor với đúng shape [1, numLabels]
    final outputTensor = Float32List(numLabels).reshape([1, numLabels]);

    _interpreter!.runForMultipleInputs(
      [inputIdsTensor, masksTensor, typeIdsTensor],
      {0: outputTensor},
    );

    // Lấy dữ liệu từ mảng đã được reshape
    final List<double> logits = List<double>.from(outputTensor[0]);
    final softmax = _softmax(logits);
    final maxIdx = softmax.indexOf(softmax.reduce(math.max));
    final confidence = softmax[maxIdx];

    final intentStr = _labelMap[maxIdx] ?? 'unknown';
    final intent = Intent.fromString(intentStr);

    return IntentResult(intent: intent, confidence: confidence);
  }

  List<int> _tokenize(String text) {
    final tokens = <int>[];
    final words = text.split(RegExp(r'[\s\p{P}]+', unicode: true));

    for (final word in words) {
      if (word.isEmpty) continue;
      final wordTokens = _wordPiece(word);
      tokens.addAll(wordTokens);
    }
    return tokens;
  }

  List<int> _wordPiece(String word) {
    if (_vocab.containsKey(word)) return [_vocab[word]!];

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
