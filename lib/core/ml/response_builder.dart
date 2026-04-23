import 'package:intl/intl.dart';
import 'package:money_care/core/ml/time_resolver.dart';
import 'package:money_care/features/transaction/data/models/category_model.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

/// Builds formatted Vietnamese response strings for the chat UI.
class ResponseBuilder {
  ResponseBuilder._();

  static final _moneyFmt = NumberFormat('#,###', 'vi_VN');
  static final _dateFmt  = DateFormat('dd/MM/yyyy', 'vi_VN');

  // ────────────────────────────────────────────────────────────────────────────
  // Transaction responses
  // ────────────────────────────────────────────────────────────────────────────

  /// Confirms a successfully saved transaction.
  static String transactionSaved({
    required double amount,
    required String type,
    String? categoryName,
    required DateTime date,
    String? rawTime,
  }) {
    final isExpense = type == 'EXPENSE';
    final emoji = isExpense ? '💸' : '💰';
    final verb  = isExpense ? 'Chi' : 'Thu';
    final timeLabel = rawTime != null ? ' ($rawTime)' : '';
    final catLabel = categoryName != null ? ' - $categoryName' : '';

    return '$emoji Đã ghi nhận: $verb ${_moneyFmt.format(amount)}đ'
        '$catLabel'
        '\n📅 Ngày: ${_dateFmt.format(date)}$timeLabel';
  }

  /// Returns a summary of transactions matching the filter.
  static String transactionList({
    required List<TransactionEntity> transactions,
    required String type,
    required DateRange dateRange,
    String? rawTime,
    String? categoryFilter,
  }) {
    final isExpense = type == 'EXPENSE';
    final emoji = isExpense ? '💸' : '💰';
    final noun  = isExpense ? 'chi tiêu' : 'thu nhập';

    final timeLabel = rawTime ?? '${_dateFmt.format(dateRange.start)} - ${_dateFmt.format(dateRange.end)}';
    final catLabel  = categoryFilter != null ? ' (Danh mục: $categoryFilter)' : '';

    if (transactions.isEmpty) {
      return '$emoji Không tìm thấy khoản $noun nào trong $timeLabel$catLabel.';
    }

    final total = transactions.fold<int>(0, (sum, t) => sum + t.amount);
    final buf = StringBuffer();
    buf.writeln('$emoji **Tổng $noun $timeLabel$catLabel:**');
    buf.writeln('💵 Tổng: ${_moneyFmt.format(total)}đ (${transactions.length} giao dịch)');
    buf.writeln();

    // Show last 5 transactions
    final shown = transactions.length > 5
        ? transactions.sublist(transactions.length - 5)
        : transactions;

    buf.writeln('📋 Gần đây nhất:');
    for (final t in shown.reversed) {
      final dateStr = t.transactionDate != null
          ? _dateFmt.format(t.transactionDate!)
          : '';
      final catStr = t.category?.name ?? '';
      buf.writeln('  • ${_moneyFmt.format(t.amount)}đ  $catStr  $dateStr');
    }

    if (transactions.length > 5) {
      buf.writeln('  ...và ${transactions.length - 5} giao dịch khác');
    }

    return buf.toString().trim();
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Category responses
  // ────────────────────────────────────────────────────────────────────────────

  static String categoryCreated(String name) =>
      '✅ Đã tạo danh mục **$name** thành công!';

  static String categoryList(List<CategoryModel> categories) {
    if (categories.isEmpty) {
      return '📂 Bạn chưa có danh mục nào. Hãy tạo danh mục đầu tiên!';
    }

    final expenses = categories.where((c) => c.type?.toUpperCase() == 'EXPENSE').toList();
    final incomes  = categories.where((c) => c.type?.toUpperCase() == 'INCOME').toList();
    final others   = categories.where((c) => c.type == null).toList();

    final buf = StringBuffer();
    buf.writeln('📂 **Danh sách danh mục (${categories.length} danh mục):**');

    if (expenses.isNotEmpty) {
      buf.writeln('\n💸 **Chi tiêu:**');
      for (final c in expenses) {
        buf.writeln('  • ${c.icon.isNotEmpty ? c.icon : "📁"} ${c.name}');
      }
    }
    if (incomes.isNotEmpty) {
      buf.writeln('\n💰 **Thu nhập:**');
      for (final c in incomes) {
        buf.writeln('  • ${c.icon.isNotEmpty ? c.icon : "📁"} ${c.name}');
      }
    }
    if (others.isNotEmpty) {
      buf.writeln('\n📋 **Khác:**');
      for (final c in others) {
        buf.writeln('  • ${c.icon.isNotEmpty ? c.icon : "📁"} ${c.name}');
      }
    }

    return buf.toString().trim();
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Error & fallback responses
  // ────────────────────────────────────────────────────────────────────────────

  static String missingAmount(String type) {
    final isExpense = type == 'EXPENSE';
    final noun = isExpense ? 'chi' : 'thu nhập';
    return '❓ Bạn muốn ghi $noun bao nhiêu tiền? '
        'Ví dụ: "chi 50k ăn trưa hôm nay"';
  }

  static String apiError(String message) {
    // Sanitize error message for user display
    final clean = message
        .replaceAll('Exception: ', '')
        .replaceAll('Error: ', '');
    return '❌ Có lỗi xảy ra: $clean\nVui lòng thử lại hoặc kiểm tra kết nối.';
  }

  static String fallback() =>
      '🤖 Tôi không chắc bạn muốn làm gì. Hãy thử:\n'
      '  • "chi 50k ăn trưa hôm nay"\n'
      '  • "tháng này tôi tiêu bao nhiêu?"\n'
      '  • "nhận lương 10 triệu"\n'
      '  • "thêm danh mục xăng xe"';
}
