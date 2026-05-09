import 'dart:convert';
import 'dart:math';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/transaction/domain/entities/scan_receipt_entity.dart';

class ReceiptOcrLine {
  final String text;
  final double x;
  final double y;
  final double width;
  final double height;

  const ReceiptOcrLine({
    required this.text,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    'x': x,
    'y': y,
    'w': width,
    'h': height,
  };
}

class ReceiptParseResult {
  final ScanReceiptEntity entity;
  final double confidence;
  final List<ReceiptOcrLine> lines;
  final List<String> warnings;

  const ReceiptParseResult({
    required this.entity,
    required this.confidence,
    required this.lines,
    required this.warnings,
  });

  bool get shouldUseAiRefinement =>
      confidence < 0.78 ||
      entity.totalAmount <= 0 ||
      entity.merchantName.isEmpty;

  Map<String, String> toAiFields() => {
    'ocrText': entity.rawText,
    'ocrLines': jsonEncode(lines.map((line) => line.toJson()).toList()),
    'ruleCandidate': jsonEncode({
      'merchantName': entity.merchantName,
      'transactionDate': entity.date,
      'totalAmount': entity.totalAmount,
      'currency': entity.currency,
      'confidence': confidence,
      'warnings': warnings,
    }),
  };
}

class ReceiptParser {
  static ReceiptParseResult parse(RecognizedText recognizedText) {
    return parseLines(extractLines(recognizedText));
  }

  static List<ReceiptOcrLine> extractLines(RecognizedText recognizedText) {
    final lines = <ReceiptOcrLine>[];
    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        final box = line.boundingBox;
        lines.add(
          ReceiptOcrLine(
            text: line.text.trim(),
            x: box.left.toDouble(),
            y: box.top.toDouble(),
            width: box.width.toDouble(),
            height: box.height.toDouble(),
          ),
        );
      }
    }

    lines.sort((a, b) {
      final yCompare = a.y.compareTo(b.y);
      return yCompare != 0 ? yCompare : a.x.compareTo(b.x);
    });
    return lines.where((line) => line.text.isNotEmpty).toList();
  }

  static ReceiptParseResult parseLines(List<ReceiptOcrLine> lines) {
    final rawLines = lines.map((line) => line.text).toList();
    final filteredLines = rawLines.where(_isUsefulReceiptLine).toList();
    final warnings = <String>[];

    if (filteredLines.isEmpty) {
      warnings.add('No useful OCR lines found.');
      return _buildResult(
        rawText: rawLines.join('\n'),
        merchantName: AppTexts.unknownMerchant,
        date: DateTime.now().toIso8601String(),
        totalAmount: 0,
        confidence: 0,
        lines: lines,
        warnings: warnings,
      );
    }

    final merchantName = _extractMerchantName(filteredLines);
    final parsedDate = _extractDate(filteredLines);
    final totalCandidate = _extractTotalAmount(filteredLines);

    if (merchantName == null) warnings.add('Merchant name is uncertain.');
    if (parsedDate == null) warnings.add('Transaction date is missing.');
    if (totalCandidate.amount <= 0) warnings.add('Total amount is missing.');
    if (!totalCandidate.fromKeyword && totalCandidate.amount > 0) {
      warnings.add('Total amount inferred from the largest plausible value.');
    }

    final confidence = _calculateConfidence(
      merchantName: merchantName,
      date: parsedDate,
      totalCandidate: totalCandidate,
      lineCount: filteredLines.length,
    );

    return _buildResult(
      rawText: rawLines.join('\n'),
      merchantName: merchantName ?? '',
      date: parsedDate ?? DateTime.now().toIso8601String(),
      totalAmount: totalCandidate.amount,
      confidence: confidence,
      lines: lines,
      warnings: warnings,
    );
  }

  static ScanReceiptEntity mergeWithAiResult(
    ReceiptParseResult localResult,
    ScanReceiptEntity aiResult,
  ) {
    final local = localResult.entity;
    return ScanReceiptEntity(
      rawText: aiResult.rawText.isNotEmpty ? aiResult.rawText : local.rawText,
      merchantName: aiResult.merchantName.isNotEmpty
          ? aiResult.merchantName
          : local.merchantName,
      address: aiResult.address.isNotEmpty ? aiResult.address : local.address,
      date: _validDate(aiResult.date) ? aiResult.date : local.date,
      totalAmount: aiResult.totalAmount > 0
          ? aiResult.totalAmount
          : local.totalAmount,
      currency: aiResult.currency.isNotEmpty
          ? aiResult.currency
          : local.currency,
      categoryKey: aiResult.categoryKey.isNotEmpty
          ? aiResult.categoryKey
          : local.categoryKey,
      categoryName: aiResult.categoryName.isNotEmpty
          ? aiResult.categoryName
          : local.categoryName,
      imagePath: aiResult.imagePath ?? local.imagePath,
    );
  }

  static ReceiptParseResult _buildResult({
    required String rawText,
    required String merchantName,
    required String date,
    required int totalAmount,
    required double confidence,
    required List<ReceiptOcrLine> lines,
    required List<String> warnings,
  }) {
    return ReceiptParseResult(
      entity: ScanReceiptEntity(
        rawText: rawText,
        totalAmount: totalAmount,
        date: date,
        merchantName: merchantName,
        address: '',
        currency: 'VND',
        categoryKey: '',
        categoryName: '',
      ),
      confidence: confidence,
      lines: lines,
      warnings: warnings,
    );
  }

  static bool _isUsefulReceiptLine(String line) {
    final normalized = AppHelperFunction.normalizeVietnamese(line);
    if (normalized.length < 3) return false;
    if (normalized.contains('.jpg') ||
        normalized.contains('.png') ||
        normalized.contains('.jpeg')) {
      return false;
    }
    if (normalized.contains('tel:') ||
        normalized.contains('phone:') ||
        normalized.contains('dt:') ||
        normalized.contains('sdt:')) {
      return false;
    }
    if (RegExp(r'\d{3,4}[ .-]\d{3}[ .-]\d{3}').hasMatch(normalized)) {
      return false;
    }
    return true;
  }

  static String? _extractMerchantName(List<String> lines) {
    const ignoredHeaders = [
      'hoa don',
      'phieu',
      'tinh tien',
      'ban hang',
      'thu ngan',
      'ban:',
      'so:',
      'gio:',
      'ngay:',
      'receipt',
      'invoice',
      'bill',
    ];

    for (final line in lines.take(min(lines.length, 8))) {
      final normalized = AppHelperFunction.normalizeVietnamese(line);
      final isHeader = ignoredHeaders.any(
        (keyword) => normalized.contains(keyword),
      );
      final mostlyNumber = RegExp(r'^[\d\s:./,-]+$').hasMatch(normalized);
      final hasMoney = _extractMoneyValues(line).isNotEmpty;

      if (!isHeader && !mostlyNumber && !hasMoney && line.trim().length > 4) {
        return line.trim();
      }
    }
    return null;
  }

  static String? _extractDate(List<String> lines) {
    final dateRegex = RegExp(r'(\d{1,2})[/.-](\d{1,2})[/.-](\d{2,4})');
    for (final line in lines) {
      final match = dateRegex.firstMatch(line);
      if (match == null) continue;

      final normalized = _normalizeDate(match.group(0)!);
      if (_validDate(normalized)) return normalized;
    }
    return null;
  }

  static _TotalCandidate _extractTotalAmount(List<String> lines) {
    const highPriorityKeywords = [
      'can thanh toan',
      'khach phai tra',
      'thanh toan',
      'tong cong',
      'tong tien',
      'grand total',
      'total',
      'amount due',
    ];
    const lowPriorityKeywords = ['tong', 'amount', 'sum'];
    const negativeKeywords = ['tra lai', 'tien thua', 'change', 'discount'];

    _TotalCandidate best = const _TotalCandidate(amount: 0, score: 0);

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final normalized = AppHelperFunction.normalizeVietnamese(line);
      if (negativeKeywords.any((keyword) => normalized.contains(keyword))) {
        continue;
      }

      final keywordScore =
          highPriorityKeywords.any((keyword) => normalized.contains(keyword))
          ? 80
          : lowPriorityKeywords.any((keyword) => normalized.contains(keyword))
          ? 45
          : 0;

      if (keywordScore == 0) continue;

      final sameLineValues = _extractMoneyValues(line);
      final nextLineValues = i + 1 < lines.length
          ? _extractMoneyValues(lines[i + 1])
          : <int>[];

      for (final amount in [...sameLineValues, ...nextLineValues]) {
        final bottomBias = (i / max(lines.length, 1) * 20).round();
        final candidate = _TotalCandidate(
          amount: amount,
          score: keywordScore + bottomBias,
          fromKeyword: true,
        );
        if (candidate.score > best.score) best = candidate;
      }
    }

    if (best.amount > 0) return best;

    final allValues = lines.expand(_extractMoneyValues).toList();
    if (allValues.isEmpty) return best;

    allValues.sort((a, b) => b.compareTo(a));
    final plausible = allValues.firstWhere(
      (value) => value < 10000000,
      orElse: () => allValues.first,
    );
    return _TotalCandidate(amount: plausible, score: 35);
  }

  static List<int> _extractMoneyValues(String text) {
    final values = <int>[];
    final normalizedDigits = text
        .replaceAll('O', '0')
        .replaceAll('o', '0')
        .replaceAll('I', '1')
        .replaceAll('l', '1');
    final moneyRegex = RegExp(r'\b\d{1,3}(?:[.,\s]\d{3})+\b|\b\d{4,}\b');

    for (final match in moneyRegex.allMatches(normalizedDigits)) {
      final raw = match.group(0)!;
      final digitsOnly = raw.replaceAll(RegExp(r'\D'), '');
      if (digitsOnly.length < 4 || digitsOnly.length >= 9) continue;
      if (digitsOnly.startsWith('0')) continue;

      final value = int.tryParse(digitsOnly);
      if (value != null && value > 0) values.add(value);
    }
    return values;
  }

  static double _calculateConfidence({
    required String? merchantName,
    required String? date,
    required _TotalCandidate totalCandidate,
    required int lineCount,
  }) {
    var score = 0.0;
    if (merchantName != null && merchantName.isNotEmpty) score += 0.2;
    if (date != null && date.isNotEmpty) score += 0.2;
    if (totalCandidate.amount > 0) {
      score += totalCandidate.fromKeyword ? 0.45 : 0.25;
    }
    if (lineCount >= 5) score += 0.1;
    if (totalCandidate.amount > 0 && totalCandidate.amount < 10000000) {
      score += 0.05;
    }
    return score.clamp(0.0, 1.0).toDouble();
  }

  static String _normalizeDate(String rawDate) {
    try {
      final parts = rawDate.split(RegExp(r'[/.-]'));
      if (parts.length == 3) {
        final day = parts[0].padLeft(2, '0');
        final month = parts[1].padLeft(2, '0');
        var year = parts[2];
        if (year.length == 2) year = '20$year';
        return '$year-$month-$day';
      }
    } catch (_) {}
    return rawDate;
  }

  static bool _validDate(String value) {
    final date = DateTime.tryParse(value);
    if (date == null) return false;
    final now = DateTime.now();
    return date.year >= 2000 && date.isBefore(now.add(const Duration(days: 2)));
  }
}

class _TotalCandidate {
  final int amount;
  final int score;
  final bool fromKeyword;

  const _TotalCandidate({
    required this.amount,
    required this.score,
    this.fromKeyword = false,
  });
}
