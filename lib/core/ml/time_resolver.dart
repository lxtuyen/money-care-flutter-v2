/// Resolves Vietnamese relative time expressions into concrete [DateRange]s.
class TimeResolver {
  TimeResolver._();

  /// Resolves a raw time string from NLU into a [DateRange].
  /// Returns null if the expression is unrecognized.
  static DateRange? resolve(String raw) {
    final t = raw.toLowerCase().trim();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // ── Exact day references
    if (_match(t, ['hôm nay', 'ngày hôm nay', 'today'])) {
      return DateRange(start: today, end: _endOfDay(today));
    }
    if (_match(t, ['hôm qua', 'ngày hôm qua', 'yesterday'])) {
      final d = today.subtract(const Duration(days: 1));
      return DateRange(start: d, end: _endOfDay(d));
    }
    if (_match(t, ['ngày kia', 'hôm kia'])) {
      final d = today.subtract(const Duration(days: 2));
      return DateRange(start: d, end: _endOfDay(d));
    }
    if (_match(t, ['ngày mai', 'tomorrow'])) {
      final d = today.add(const Duration(days: 1));
      return DateRange(start: d, end: _endOfDay(d));
    }

    // ── Evening/morning (collapse to today)
    if (_match(t, ['tối qua', 'sáng nay', 'chiều nay', 'trưa nay', 'tối nay'])) {
      return DateRange(start: today, end: _endOfDay(today));
    }

    // ── Week references
    if (_match(t, ['tuần này', 'tuần hiện tại'])) {
      return _thisWeek(today);
    }
    if (_match(t, ['tuần trước', 'tuần vừa rồi', 'tuần qua'])) {
      return _lastWeek(today);
    }
    if (_match(t, ['cuối tuần', 'cuối tuần này'])) {
      return _thisWeekend(today);
    }

    // ── Month references
    if (_match(t, ['tháng này', 'tháng hiện tại'])) {
      return _thisMonth(today);
    }
    if (_match(t, ['tháng trước', 'tháng vừa rồi', 'tháng qua'])) {
      return _lastMonth(today);
    }
    if (_match(t, ['tháng sau'])) {
      return _nextMonth(today);
    }

    // ── "tháng X" (specific month of current year)
    final thangX = RegExp(r'tháng\s*(\d{1,2})(?:\s*(năm\s*\d{4}))?');
    final mThang = thangX.firstMatch(t);
    if (mThang != null) {
      final month = int.tryParse(mThang.group(1)!);
      if (month != null && month >= 1 && month <= 12) {
        final year = _parseYear(mThang.group(2)) ?? today.year;
        return _specificMonth(year, month);
      }
    }

    // ── Year references
    if (_match(t, ['năm nay', 'năm hiện tại'])) {
      return _thisYear(today);
    }
    if (_match(t, ['năm ngoái', 'năm trước', 'năm qua'])) {
      return _lastYear(today);
    }

    // ── "X ngày qua" / "X ngày gần đây"
    final nDays = RegExp(r'(\d+)\s*ngày\s*(?:qua|gần đây|trước)');
    final mDays = nDays.firstMatch(t);
    if (mDays != null) {
      final n = int.tryParse(mDays.group(1)!);
      if (n != null) {
        final start = today.subtract(Duration(days: n - 1));
        return DateRange(start: start, end: _endOfDay(today));
      }
    }

    // ── "X tháng qua" / "X tháng gần đây"
    final nMonths = RegExp(r'(\d+)\s*tháng\s*(?:qua|gần đây|trước)');
    final mMonths = nMonths.firstMatch(t);
    if (mMonths != null) {
      final n = int.tryParse(mMonths.group(1)!);
      if (n != null) {
        final start = DateTime(today.year, today.month - n + 1, 1);
        return DateRange(start: start, end: _endOfDay(today));
      }
    }

    // ── "quý X" (quarter)
    final quy = RegExp(r'quý\s*(\d)');
    final mQuy = quy.firstMatch(t);
    if (mQuy != null) {
      final q = int.tryParse(mQuy.group(1)!);
      if (q != null && q >= 1 && q <= 4) {
        return _quarter(today.year, q);
      }
    }

    return null;
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  static bool _match(String text, List<String> keywords) =>
      keywords.any((k) => text.contains(k));

  static DateTime _endOfDay(DateTime d) =>
      DateTime(d.year, d.month, d.day, 23, 59, 59);

  static DateRange _thisWeek(DateTime today) {
    // Week starts Monday
    final weekday = today.weekday; // 1=Mon … 7=Sun
    final start = today.subtract(Duration(days: weekday - 1));
    final end = _endOfDay(start.add(const Duration(days: 6)));
    return DateRange(start: start, end: end);
  }

  static DateRange _lastWeek(DateTime today) {
    final startThisWeek = _thisWeek(today).start;
    final start = startThisWeek.subtract(const Duration(days: 7));
    final end = _endOfDay(start.add(const Duration(days: 6)));
    return DateRange(start: start, end: end);
  }

  static DateRange _thisWeekend(DateTime today) {
    final weekday = today.weekday;
    final daysToSat = 6 - weekday; // Saturday = 6
    final sat = today.add(Duration(days: daysToSat));
    final sun = sat.add(const Duration(days: 1));
    return DateRange(start: sat, end: _endOfDay(sun));
  }

  static DateRange _thisMonth(DateTime today) {
    final start = DateTime(today.year, today.month, 1);
    final end = _endOfDay(DateTime(today.year, today.month + 1, 0));
    return DateRange(start: start, end: end);
  }

  static DateRange _lastMonth(DateTime today) {
    final start = DateTime(today.year, today.month - 1, 1);
    final end = _endOfDay(DateTime(today.year, today.month, 0));
    return DateRange(start: start, end: end);
  }

  static DateRange _nextMonth(DateTime today) {
    final start = DateTime(today.year, today.month + 1, 1);
    final end = _endOfDay(DateTime(today.year, today.month + 2, 0));
    return DateRange(start: start, end: end);
  }

  static DateRange _specificMonth(int year, int month) {
    final start = DateTime(year, month, 1);
    final end = _endOfDay(DateTime(year, month + 1, 0));
    return DateRange(start: start, end: end);
  }

  static DateRange _thisYear(DateTime today) {
    return DateRange(
      start: DateTime(today.year, 1, 1),
      end: _endOfDay(DateTime(today.year, 12, 31)),
    );
  }

  static DateRange _lastYear(DateTime today) {
    return DateRange(
      start: DateTime(today.year - 1, 1, 1),
      end: _endOfDay(DateTime(today.year - 1, 12, 31)),
    );
  }

  static DateRange _quarter(int year, int q) {
    final startMonth = (q - 1) * 3 + 1;
    final start = DateTime(year, startMonth, 1);
    final end = _endOfDay(DateTime(year, startMonth + 3, 0));
    return DateRange(start: start, end: end);
  }

  static int? _parseYear(String? s) {
    if (s == null) return null;
    return int.tryParse(s.replaceAll(RegExp(r'[^\d]'), ''));
  }
}

/// Represents a date range with inclusive start and end.
class DateRange {
  final DateTime start;
  final DateTime end;

  const DateRange({required this.start, required this.end});

  @override
  String toString() => 'DateRange($start → $end)';
}
