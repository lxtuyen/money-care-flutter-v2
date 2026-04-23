import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/features/transaction/domain/entities/scan_receipt_entity.dart';

class ReceiptParser {
  static ScanReceiptEntity parse(RecognizedText recognizedText) {
    String? merchantName;
    String? date;
    double totalAmount = 0;

    final List<({String text, double y})> linesWithPos = [];
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        linesWithPos.add((text: line.text, y: line.boundingBox.top.toDouble()));
      }
    }

    linesWithPos.sort((a, b) => a.y.compareTo(b.y));
    final List<String> rawLines = linesWithPos.map((e) => e.text).toList();

    final List<String> filteredLines = rawLines.where((line) {
      final l = line.toLowerCase();
      if (l.contains('đt:') ||
          l.contains('sđt:') ||
          l.contains('tel:') ||
          l.contains('phone:'))
        return false;
      if (l.contains('.jpg') || l.contains('.png') || l.contains('.jpeg'))
        return false;
      if (RegExp(r'\d{3,4}\.\d{3}\.\d{3}').hasMatch(line)) return false;
      if (l.length < 3) return false;
      return true;
    }).toList();

    if (filteredLines.isEmpty) {
      return ScanReceiptEntity(
        rawText: rawLines.join('\n'),
        totalAmount: 0,
        date: DateTime.now().toIso8601String(),
        merchantName: AppTexts.unknownMerchant,
        address: '',
        currency: 'VND',
        categoryKey: '',
        categoryName: '',
      );
    }

    final commonHeaders = [
      'hóa đơn',
      'phiếu',
      'tính tiền',
      'bán hàng',
      'thu ngân',
      'bàn:',
      'số:',
      'giờ:',
    ];
    merchantName = null;

    for (String line in filteredLines) {
      final l = line.toLowerCase();
      bool isHeader = commonHeaders.any((h) => l.contains(h));
      bool isNotMerchant =
          RegExp(r'^\d+$').hasMatch(l) ||
          RegExp(r'\d{1,2}/\d{1,2}').hasMatch(l) ||
          RegExp(r'^[:.-]+$').hasMatch(l);

      if (!isHeader && !isNotMerchant && line.trim().length > 4) {
        merchantName = line.trim();
        break;
      }
    }

    final dateRegex = RegExp(r'(\d{1,2})[/.-](\d{1,2})[/.-](\d{2,4})');
    for (String line in filteredLines) {
      final match = dateRegex.firstMatch(line);
      if (match != null) {
        date = _normalizeDate(match.group(0)!);
        break;
      }
    }

    totalAmount = _extractTotalAmount(filteredLines);

    return ScanReceiptEntity(
      rawText: rawLines.join('\n'),
      totalAmount: totalAmount.toInt(),
      date: date ?? DateTime.now().toIso8601String(),
      merchantName: merchantName ?? '',
      address: '',
      currency: 'VND',
      categoryKey: '',
      categoryName: '',
    );
  }

  static double _extractTotalAmount(List<String> lines) {
    final totalKeywords = [
      'tổng',
      'thanh toán',
      'tổng cộng',
      'total',
      'sum',
      'amount',
    ];

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].toLowerCase();

      for (var kw in totalKeywords) {
        if (line.contains(kw)) {
          final afterKeyword = line.substring(line.indexOf(kw) + kw.length);
          final numbersSameLine = _extractNumbers(afterKeyword);
          if (numbersSameLine.isNotEmpty) {
            return numbersSameLine.first;
          }

          final beforeKeyword = line.substring(0, line.indexOf(kw));
          final numbersBefore = _extractNumbers(beforeKeyword);
          if (numbersBefore.isNotEmpty) {
            return numbersBefore.last;
          }

          if (i + 1 < lines.length) {
            final nextLineNumbers = _extractNumbers(lines[i + 1]);
            if (nextLineNumbers.isNotEmpty) {
              return nextLineNumbers.first;
            }
          }
        }
      }
    }

    final allNumbers = lines.expand((l) => _extractNumbers(l)).toList();
    if (allNumbers.isNotEmpty) {
      allNumbers.sort((a, b) => b.compareTo(a));
      return allNumbers.firstWhere(
        (n) => n < 10000000,
        orElse: () => allNumbers.first,
      );
    }

    return 0;
  }

  static List<double> _extractNumbers(String text) {
    final List<double> results = [];
    final numberRegex = RegExp(r'\b\d{1,3}(?:[.,]\d{3})+\b|\b\d{4,}\b');
    final matches = numberRegex.allMatches(text);

    for (final match in matches) {
      String raw = match.group(0)!;

      String digitsOnly = raw.replaceAll(RegExp(r'\D'), '');
      if (digitsOnly.startsWith('0') || digitsOnly.length >= 9) {
        continue;
      }

      String processed = raw.replaceAll(RegExp(r'[.,]'), '');
      double? val = double.tryParse(processed);
      if (val != null) {
        results.add(val);
      }
    }

    return results;
  }

  static String _normalizeDate(String rawDate) {
    try {
      final parts = rawDate.split(RegExp(r'[/.-]'));
      if (parts.length == 3) {
        String d = parts[0].padLeft(2, '0');
        String m = parts[1].padLeft(2, '0');
        String y = parts[2];
        if (y.length == 2) y = "20$y";
        return "$y-$m-$d";
      }
    } catch (_) {}
    return rawDate;
  }
}
