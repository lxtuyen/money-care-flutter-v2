/// Parses Vietnamese currency amount strings to double values.
///
/// Supported formats:
///   "50k"          → 50,000
///   "1 triệu"      → 1,000,000
///   "1 triệu 2"    → 1,200,000
///   "2tr5"         → 2,500,000
///   "300.000 VND"  → 300,000
///   "300.000đ"     → 300,000
///   "150 nghìn"    → 150,000
///   "1,5 triệu"    → 1,500,000
class AmountParser {
  AmountParser._();

  /// Returns the parsed amount in VND, or null if no amount found.
  static double? parse(String text) {
    final normalized = text.toLowerCase().trim();

    // ── "Xtr Y" format: 2tr5, 1tr2
    final trShort = RegExp(r'(\d+(?:[.,]\d+)?)tr(\d*)');
    final mTrShort = trShort.firstMatch(normalized);
    if (mTrShort != null) {
      final main = _parseNum(mTrShort.group(1)!);
      final frac = mTrShort.group(2);
      if (frac != null && frac.isNotEmpty) {
        return (main + int.parse(frac) / 10) * 1_000_000;
      }
      return main * 1_000_000;
    }

    // ── "X triệu Y" or "X triệu"
    final trieu = RegExp(r'(\d+(?:[.,]\d+)?)\s*tri[eệ]u(?:\s+(\d+))?');
    final mTrieu = trieu.firstMatch(normalized);
    if (mTrieu != null) {
      final main = _parseNum(mTrieu.group(1)!);
      final frac = mTrieu.group(2);
      if (frac != null) {
        return (main + int.parse(frac) / 10) * 1_000_000;
      }
      return main * 1_000_000;
    }

    // ── "X nghìn" / "X ngàn"
    final nghin = RegExp(r'(\d+(?:[.,]\d+)?)\s*(?:ngh[iì]n|ng[aà]n)');
    final mNghin = nghin.firstMatch(normalized);
    if (mNghin != null) {
      return _parseNum(mNghin.group(1)!) * 1_000;
    }

    // ── "Xk" / "X K"
    final k = RegExp(r'(\d+(?:[.,]\d+)?)\s*k\b');
    final mK = k.firstMatch(normalized);
    if (mK != null) {
      return _parseNum(mK.group(1)!) * 1_000;
    }

    // ── "X.000" or "X.000.000" (dot as thousands separator)
    final dotSep = RegExp(r'(\d{1,3}(?:\.\d{3})+)(?:\s*(?:vnd|đ|dong|đồng))?');
    final mDot = dotSep.firstMatch(normalized);
    if (mDot != null) {
      final clean = mDot.group(1)!.replaceAll('.', '');
      return double.tryParse(clean);
    }

    // ── Plain number with optional currency suffix
    final plain = RegExp(r'(\d+(?:[.,]\d+)?)\s*(?:vnd|đ|dong|đồng)?');
    final mPlain = plain.firstMatch(normalized);
    if (mPlain != null) {
      return _parseNum(mPlain.group(1)!);
    }

    return null;
  }

  /// Finds and returns the raw amount substring, or null.
  static String? findRaw(String text) {
    final patterns = [
      RegExp(r'\d+(?:[.,]\d+)?tr\d*', caseSensitive: false),
      RegExp(r'\d+(?:[.,]\d+)?\s*tri[eệ]u(?:\s+\d+)?', caseSensitive: false),
      RegExp(r'\d+(?:[.,]\d+)?\s*(?:nghìn|ngàn|ngh[iì]n)', caseSensitive: false),
      RegExp(r'\d+(?:[.,]\d+)?\s*k\b', caseSensitive: false),
      RegExp(r'\d{1,3}(?:\.\d{3})+(?:\s*(?:vnd|đ|dong|đồng))?', caseSensitive: false),
      RegExp(r'\d+(?:[.,]\d+)?\s*(?:vnd|đ|dong|đồng)', caseSensitive: false),
    ];

    for (final p in patterns) {
      final m = p.firstMatch(text);
      if (m != null) return m.group(0);
    }
    return null;
  }

  static double _parseNum(String s) {
    // Replace comma decimal separator: "1,5" → "1.5"
    return double.tryParse(s.replaceAll(',', '.')) ?? 0;
  }
}
