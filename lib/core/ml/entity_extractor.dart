import 'package:money_care/core/ml/amount_parser.dart';
import 'package:money_care/core/ml/time_resolver.dart';

/// Extracts structured entities (AMOUNT, CATEGORY, TIME) from Vietnamese text
/// using rule-based patterns — no ML required.
class EntityExtractor {
  EntityExtractor._();

  static EntityResult extract(String text) {
    // ── 1. Extract AMOUNT
    final rawAmount = AmountParser.findRaw(text);
    final amount    = rawAmount != null ? AmountParser.parse(rawAmount) : null;

    // ── 2. Extract TIME
    final rawTime = _findRawTime(text);
    final dateRange = rawTime != null ? TimeResolver.resolve(rawTime) : null;

    // ── 3. Extract CATEGORY
    // Remove amount and time tokens from text, what remains is candidate category
    var cleaned = text;
    if (rawAmount != null) {
      cleaned = cleaned.replaceFirst(rawAmount, '').trim();
    }
    if (rawTime != null) {
      cleaned = cleaned.replaceFirst(
        RegExp(RegExp.escape(rawTime), caseSensitive: false),
        '',
      ).trim();
    }
    final category = _extractCategory(cleaned);

    return EntityResult(
      amount: amount,
      rawAmount: rawAmount,
      category: category,
      dateRange: dateRange,
      rawTime: rawTime,
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  // TIME detection
  // ────────────────────────────────────────────────────────────────────────────

  static const _timeKeywords = [
    'hôm nay', 'ngày hôm nay',
    'hôm qua', 'ngày hôm qua',
    'ngày kia', 'hôm kia',
    'ngày mai',
    'tối qua', 'sáng nay', 'chiều nay', 'trưa nay', 'tối nay',
    'tuần này', 'tuần hiện tại',
    'tuần trước', 'tuần vừa rồi', 'tuần qua',
    'cuối tuần', 'cuối tuần này',
    'tháng này', 'tháng hiện tại',
    'tháng trước', 'tháng vừa rồi', 'tháng qua',
    'tháng sau',
    'năm nay', 'năm hiện tại',
    'năm ngoái', 'năm trước', 'năm qua',
  ];

  static String? _findRawTime(String text) {
    final lower = text.toLowerCase();

    // ── Check static keywords (longest first to avoid partial match)
    final sorted = List<String>.from(_timeKeywords)
      ..sort((a, b) => b.length.compareTo(a.length));
    for (final kw in sorted) {
      if (lower.contains(kw)) return kw;
    }

    // ── "tháng X" — e.g. "tháng 3", "tháng 12"
    final thangX = RegExp(r'tháng\s*\d{1,2}', caseSensitive: false);
    final mThang = thangX.firstMatch(lower);
    if (mThang != null) return mThang.group(0);

    // ── "X ngày qua|gần đây"
    final nDays = RegExp(r'\d+\s*ngày\s*(?:qua|gần đây|trước)', caseSensitive: false);
    final mDays = nDays.firstMatch(lower);
    if (mDays != null) return mDays.group(0);

    // ── "X tháng qua|gần đây"
    final nMonths = RegExp(r'\d+\s*tháng\s*(?:qua|gần đây|trước)', caseSensitive: false);
    final mMonths = nMonths.firstMatch(lower);
    if (mMonths != null) return mMonths.group(0);

    // ── "quý X"
    final quy = RegExp(r'quý\s*\d', caseSensitive: false);
    final mQuy = quy.firstMatch(lower);
    if (mQuy != null) return mQuy.group(0);

    return null;
  }

  // ────────────────────────────────────────────────────────────────────────────
  // CATEGORY extraction from cleaned text
  // ────────────────────────────────────────────────────────────────────────────

  static const _stopWords = {
    // Intent verbs & filler words
    'tôi', 'mình', 'hôm', 'đã', 'vừa', 'chi', 'tiêu', 'mất',
    'hết', 'thanh', 'toán', 'đốt', 'nhận', 'kiếm', 'được',
    'có', 'bán', 'trúng', 'thưởng', 'thêm', 'tạo', 'tổng', 'thu',
    'nhập', 'xem', 'xài', 'mua', 'đi', 'bao', 'nhiêu', 'là',
    'của', 'gần', 'hiện', 'tại', 'nay', 'qua', 'này', 'trước',
    'rồi', 'thế', 'nào', 'không', 'danh', 'mục', 'category', 'khoản',
    'phân', 'loại', 'ứng', 'dụng', 'đang', 'dùng',
    // Connectors
    'và', 'hoặc', 'hay', 'với', 'từ', 'trong', 'vào', 'lại', 'ra',
    'về', 'lên', 'xuống', 'cho', 'để', 'mà', 'nhưng', 'nếu',
  };

  static String? _extractCategory(String cleaned) {
    // Split into tokens, remove stop words and punctuation
    final tokens = cleaned
        .replaceAll(RegExp(r'[!?.,;:()[]{}"]+'), ' ')
        .split(RegExp(r'\s+'))
        .where((t) => t.length > 1 && !_stopWords.contains(t.toLowerCase()))
        .toList();

    if (tokens.isEmpty) return null;

    // Return joined meaningful tokens
    final result = tokens.join(' ').trim();
    return result.isEmpty ? null : _capitalize(result);
  }

  static String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}

/// Structured result from entity extraction.
class EntityResult {
  /// Parsed amount in VND (e.g. 50000.0)
  final double? amount;

  /// Raw amount string from original text (e.g. "50k")
  final String? rawAmount;

  /// Extracted category text (e.g. "Ăn trưa")
  final String? category;

  /// Resolved date range from time expression
  final DateRange? dateRange;

  /// Raw time string from original text (e.g. "hôm nay")
  final String? rawTime;

  const EntityResult({
    this.amount,
    this.rawAmount,
    this.category,
    this.dateRange,
    this.rawTime,
  });

  @override
  String toString() => 'EntityResult('
      'amount=$amount, '
      'category=$category, '
      'time=$rawTime'
      ')';
}
