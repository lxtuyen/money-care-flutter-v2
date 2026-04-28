import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class EmbeddingService {
  static const _modelAsset = 'assets/ml/embedding_model.tflite';
  static const _vocabAsset = 'assets/ml/embedding_vocab.txt';
  static const _maxLength  = 64;
  
  // vi-electra-small tokens
  static const _padToken   = 0;
  static const _unkToken   = 1;
  static const _clsToken   = 2;
  static const _sepToken   = 3;

  Interpreter? _interpreter;
  final Map<String, int> _vocab = {};
  bool _initialized = false;

  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      _interpreter = await Interpreter.fromAsset(_modelAsset);

      final vocabRaw = await rootBundle.loadString(_vocabAsset);
      final lines = vocabRaw.split('\n');
      for (int i = 0; i < lines.length; i++) {
        final tok = lines[i].trim();
        if (tok.isNotEmpty) _vocab[tok] = i;
      }

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

  Future<List<double>> getEmbedding(String text) async {
    if (!_initialized) await initialize();

    final tokens   = _tokenize(text.toLowerCase());
    final inputIds = _buildInputIds(tokens);
    final masks    = _buildMask(inputIds);
    final typeIds  = List<int>.filled(_maxLength, 0);

    // Dims matching onnx dynamic batch size
    final inputIdsTensor  = [inputIds];
    final masksTensor     = [masks];
    final typeIdsTensor   = [typeIds];

    // Output dimension is 256 for vi-electra-small
    final outputRaw = Float32List(256);
    final outputTensor = [outputRaw];

    _interpreter!.runForMultipleInputs(
      [inputIdsTensor, masksTensor, typeIdsTensor],
      {0: outputTensor},
    );

    return outputRaw.map((v) => v.toDouble()).toList();
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

  /// Utility function to calculate cosine similarity between two embeddings
  static double cosineSimilarity(List<double> a, List<double> b) {
    if (a.length != b.length) return 0.0;
    double dotProduct = 0.0;
    double normA = 0.0;
    double normB = 0.0;
    for (int i = 0; i < a.length; i++) {
      dotProduct += a[i] * b[i];
      normA += math.pow(a[i], 2);
      normB += math.pow(b[i], 2);
    }
    if (normA == 0.0 || normB == 0.0) return 0.0;
    return dotProduct / (math.sqrt(normA) * math.sqrt(normB));
  }
}
