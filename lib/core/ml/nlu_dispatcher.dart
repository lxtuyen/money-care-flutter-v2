import 'package:intl/intl.dart';
import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/ml/entity_extractor.dart';
import 'package:money_care/core/ml/intent_classifier.dart';
import 'package:money_care/core/ml/nlu_service.dart';
import 'package:money_care/core/ml/embedding_service.dart';
import 'package:money_care/core/ml/response_builder.dart';
import 'package:money_care/core/ml/time_resolver.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/transaction/data/models/category_model.dart';
import 'package:money_care/features/transaction/data/models/transaction_create_dto.dart';
import 'package:money_care/features/transaction/data/models/transaction_response_model.dart';
import 'package:money_care/features/transaction/data/models/transaction_by_type_model.dart';

class NluDispatcher {
  final ApiClient _api;
  final EmbeddingService _embeddingService = EmbeddingService();

  /// Alias map: keyword có trong rawCategory → tên danh mục tương ứng.
  /// Giúp nhận dạng nhanh các cụm từ phổ biến mà không cần chạy embedding.
  static const _categoryAliases = <String, List<String>>{
    'hóa đơn': [
      'tiền điện',
      'tiền nước',
      'tiền mạng',
      'tiền internet',
      'tiền wifi',
      'tiền ga',
      'tiền nhà',
      'tiền thuê',
      'điện nước',
      'nước sinh hoạt',
      'điện sinh hoạt',
      'nộp tiền điện',
      'nộp tiền nước',
      'nộp điện',
      'nộp nước',
      'đóng tiền điện',
      'đóng tiền nước',
      'đóng điện',
      'đóng nước',
      'trả tiền điện',
      'trả tiền nước',
      'trả điện',
      'trả nước',
      'trả mạng',
      'cước điện thoại',
      'cước di động',
      'phí dịch vụ',
    ],
    'ăn uống': [
      'cà phê',
      'trà sữa',
      'bánh mì',
      'cơm',
      'ăn sáng',
      'ăn trưa',
      'ăn tối',
      'ăn vặt',
      'nhậu',
      'bia',
      'nước uống',
      'bún',
      'phở',
    ],
    'di chuyển': [
      'xăng',
      'đổ xăng',
      'grab',
      'xe ôm',
      'taxi',
      'gửi xe',
      'đỗ xe',
      'vé xe',
      'vé tàu',
      'vé máy bay',
    ],
    'sức khỏe': [
      'thuốc',
      'khám bệnh',
      'bệnh viện',
      'bác sĩ',
      'phí khám',
      'y tế',
      'bảo hiểm y tế',
    ],
    'mua sắm': [
      'quần áo',
      'giày dép',
      'nón',
      'mỹ phẩm',
      'shopping',
      'đồ dùng',
      'phụ kiện',
    ],
    'giáo dục': [
      'học phí',
      'sách vở',
      'khóa học',
      'học thêm',
      'gia sư',
      'tiền học',
    ],
  };

  NluDispatcher({required ApiClient api}) : _api = api;

  Future<String> dispatch(NluResult result, int userId, {int? fundId}) async {
    final entities = result.entities;

    switch (result.intent) {
      case Intent.addExpense:
        return _addTransaction(
          entities: entities,
          userId: userId,
          fundId: fundId,
          type: 'expense',
        );

      case Intent.addIncome:
        return _addTransaction(
          entities: entities,
          userId: userId,
          fundId: fundId,
          type: 'income',
        );

      case Intent.getExpense:
        return _getTransactions(
          entities: entities,
          userId: userId,
          fundId: fundId,
          type: 'expense',
        );

      case Intent.getIncome:
        return _getTransactions(
          entities: entities,
          userId: userId,
          fundId: fundId,
          type: 'income',
        );

      case Intent.unknown:
        return ResponseBuilder.fallback();
    }
  }

  // ────────────────────────────────────────────────────────────────────────────
  // ADD TRANSACTION (expense / income)
  // ────────────────────────────────────────────────────────────────────────────

  Future<String> _addTransaction({
    required EntityResult entities,
    required int userId,
    required String type, // 'EXPENSE' | 'INCOME'
    int? fundId,
  }) async {
    // Validate amount
    if (entities.amount == null || entities.amount! <= 0) {
      return ResponseBuilder.missingAmount(type);
    }

    // Resolve categoryId — fuzzy match against user's categories
    int? categoryId;
    String? categoryName = entities.category;
    if (categoryName != null || entities.rawCategory != null) {
      final matchResult = await _matchCategory(
        categoryName ?? '',
        userId,
        type,
        rawCategory: entities.rawCategory,
      );
      categoryId = matchResult?.id;
      if (matchResult != null) categoryName = matchResult.name;
    }

    // Resolve date
    final txDate = entities.dateRange?.start ?? DateTime.now();

    final dto = TransactionCreateDto(
      amount: entities.amount!.toInt(),
      type: type,
      note: entities.category,
      transactionDate: txDate,
      categoryId: categoryId,
      userId: userId,
    );

    try {
      // Tạm thời chặn gửi lên Backend để test Offline
      print(
        "🧪 [TEST MODE] Chặn lưu giao dịch: $categoryName - ${entities.amount}",
      );

      /*
      final res = await _api.post<TransactionModel>(
        ApiRoutes.transaction,
        body: dto.toJson(), 
        fromJsonT: (json) => TransactionModel.fromJson(json),
      );

      if (!res.success || res.data == null) {
        return ResponseBuilder.apiError(res.message);
      }
      */

      return ResponseBuilder.transactionSaved(
        amount: entities.amount!,
        type: type,
        categoryName: categoryName,
        date: txDate,
        rawTime: entities.rawTime,
      );
    } catch (e) {
      return ResponseBuilder.apiError(e.toString());
    }
  }

  // ────────────────────────────────────────────────────────────────────────────
  // GET TRANSACTIONS (expense / income listing)
  // ────────────────────────────────────────────────────────────────────────────

  Future<String> _getTransactions({
    required EntityResult entities,
    required int userId,
    required String type, // 'EXPENSE' | 'INCOME'
    int? fundId,
  }) async {
    // Default to this month if no time specified
    final dateRange = entities.dateRange ?? TimeResolver.resolve('tháng này')!;
    final fmt = DateFormat('yyyy-MM-dd');

    // Resolve categoryId if present
    int? categoryId;
    if (entities.category != null || entities.rawCategory != null) {
      final match = await _matchCategory(
        entities.category ?? '',
        userId,
        type,
        rawCategory: entities.rawCategory,
      );
      categoryId = match?.id;
    }

    final queryParams = <String, dynamic>{
      'start_date': fmt.format(dateRange.start),
      'end_date': fmt.format(dateRange.end),
      'categoryId': categoryId,
      'fundId': fundId,
    };

    try {
      final res = await _api.get<TransactionByTypeModel>(
        '${ApiRoutes.getTransactionsFilter}/$userId',
        queryParameters: queryParams,
        fromJsonT: (json) => TransactionByTypeModel.fromJson(json),
      );

      if (!res.success || res.data == null) {
        return ResponseBuilder.apiError(res.message);
      }

      final data = res.data!;
      // TransactionByTypeModel uses .income and .expense (no 's')
      final txModels = type == 'expense' ? data.expense : data.income;
      final transactions = txModels.map((m) => m.toEntity()).toList();

      return ResponseBuilder.transactionList(
        transactions: transactions,
        type: type,
        dateRange: dateRange,
        rawTime: entities.rawTime,
        categoryFilter: entities.category,
      );
    } catch (e) {
      return ResponseBuilder.apiError(e.toString());
    }
  }

  // ────────────────────────────────────────────────────────────────────────────
  // ADD CATEGORY
  // ────────────────────────────────────────────────────────────────────────────

  Future<String> _addCategory({
    required EntityResult entities,
    required int userId,
  }) async {
    if (entities.category == null || entities.category!.isEmpty) {
      return '❓ Bạn muốn thêm danh mục gì? Vui lòng cho tôi biết tên danh mục.';
    }

    final body = {
      'name': entities.category!,
      'userId': userId,
      'icon': '📁',
      'isEssential': false,
    };

    try {
      final res = await _api.post<CategoryModel>(
        ApiRoutes.categories,
        body: body,
        fromJsonT: (json) => CategoryModel.fromJson(json),
      );

      if (!res.success || res.data == null) {
        return ResponseBuilder.apiError(res.message);
      }

      return ResponseBuilder.categoryCreated(res.data!.name);
    } catch (e) {
      return ResponseBuilder.apiError(e.toString());
    }
  }

  // ──────────�  /// Fetches user categories and returns the best fuzzy match for [query].
  /// Uses [rawCategory] (pre-stop-word text) for richer semantic matching.
  /// Returns null if no match found or API fails.
  Future<CategoryModel?> _matchCategory(
    String query,
    int userId,
    String type, {
    String? rawCategory,
  }) async {
    try {
      final res = await _api.get<List<CategoryModel>>(
        '${ApiRoutes.userCategories}/$userId',
        fromJsonT: (json) {
          final list = json as List<dynamic>;
          return list.map((e) => CategoryModel.fromJson(e)).toList();
        },
      );

      if (!res.success || res.data == null) return null;

      final categories = res.data!;
      final queryLower = query.toLowerCase();

      // 0. Alias match — check rawCategory against known aliases
      if (rawCategory != null && rawCategory.isNotEmpty) {
        final rawLower = rawCategory.toLowerCase();
        final normalizedRaw = _normalizeText(rawLower);
        for (final entry in _categoryAliases.entries) {
          final aliasTarget = entry.key; // e.g. "hóa đơn"
          final normalizedAliasTarget = _normalizeText(aliasTarget);
          final keywords = entry.value; // e.g. ["tiền điện", ...]
          for (final kw in keywords) {
            final normalizedKeyword = _normalizeText(kw);
            if (normalizedRaw.contains(normalizedKeyword)) {
              // Tìm danh mục user có tên match aliasTarget
              final match = categories.where((c) {
                final normalizedName = _normalizeText(c.name);
                return normalizedName == normalizedAliasTarget ||
                    normalizedName.contains(normalizedAliasTarget) ||
                    normalizedAliasTarget.contains(normalizedName);
              }).toList();

              if (match.isNotEmpty) {
                print(
                  '🎯 [Alias Match] "$rawLower" → keyword "$kw" → danh mục "${match.first.name}"',
                );
                return match.first;
              }

              // Fallback: nếu aliasTarget không khớp chính xác, chọn danh mục có chứa ít nhất một token của aliasTarget
              final fallback = categories.where((c) {
                final normalizedName = _normalizeText(c.name);
                return normalizedAliasTarget
                    .split(' ')
                    .where((token) => token.isNotEmpty)
                    .any((token) => normalizedName.contains(token));
              }).toList();
              if (fallback.isNotEmpty) {
                print(
                  '🎯 [Alias Fallback] "$rawLower" → keyword "$kw" → danh mục "${fallback.first.name}"',
                );
                return fallback.first;
              }
            }
          }
        }
        print('🔍 [Alias] Không tìm thấy alias cho: "$rawLower"');
      }

      // 1. Exact match (case-insensitive)
      if (queryLower.isNotEmpty) {
        final exact = categories.where(
          (c) => c.name.toLowerCase() == queryLower,
        );
        if (exact.isNotEmpty) return exact.first;

        // 2. Contains match
        final contains = categories.where(
          (c) =>
              c.name.toLowerCase().contains(queryLower) ||
              queryLower.contains(c.name.toLowerCase()),
        );
        if (contains.isNotEmpty) return contains.first;

        // 3. Token overlap — split both into words, count overlap
        final queryTokens = queryLower.split(RegExp(r'\s+'));
        CategoryModel? best;
        int bestScore = 0;

        for (final cat in categories) {
          final catTokens = cat.name.toLowerCase().split(RegExp(r'\s+'));
          final overlap = queryTokens
              .where(
                (qt) =>
                    catTokens.any((ct) => ct.contains(qt) || qt.contains(ct)),
              )
              .length;
          if (overlap > bestScore) {
            bestScore = overlap;
            best = cat;
          }
        }

        if (bestScore > 0) return best;
      }

      // 4. Semantic match using EmbeddingService
      // Sử dụng rawCategory (cụm từ đầy đủ ngữ nghĩa) thay vì category (đã loại stop words)
      final semanticQuery = rawCategory ?? queryLower;
      if (semanticQuery.isEmpty) return null;

      print('🧠 Semantic matching for: "$semanticQuery"...');
      if (!_embeddingService.isInitialized) {
        await _embeddingService.initialize();
      }

      final queryEmb = await _embeddingService.getEmbedding(semanticQuery);
      CategoryModel? bestSemantic;
      double bestSimilarity = -1.0;

      for (final cat in categories) {
        final catEmb = await _embeddingService.getEmbedding(
          cat.name.toLowerCase(),
        );
        final similarity = EmbeddingService.cosineSimilarity(queryEmb, catEmb);

        // Log chi tiết từng danh mục để bạn theo dõi
        print(
          '   🔍 Thử với: "${cat.name}" -> Similarity: ${(similarity * 100).toStringAsFixed(1)}%',
        );

        if (similarity > bestSimilarity) {
          bestSimilarity = similarity;
          bestSemantic = cat;
        }
      }

      // If semantic similarity is > 65%, consider it a match
      if (bestSemantic != null && bestSimilarity > 0.65) {
        print(
          '   ✅ Chọn danh mục: "${bestSemantic.name}" (Độ tương đồng cao nhất: ${(bestSimilarity * 100).toStringAsFixed(1)}%)',
        );
        return bestSemantic;
      }

      print(
        '   ⚠️ Không tìm thấy danh mục nào đủ giống (Max: ${(bestSimilarity * 100).toStringAsFixed(1)}%)',
      );
      return null;
    } catch (_) {
      return null;
    }
  }

  String _normalizeText(String input) {
    final lower = input.toLowerCase().trim();
    const replacements = {
      'à': 'a',
      'á': 'a',
      'ả': 'a',
      'ã': 'a',
      'ạ': 'a',
      'ă': 'a',
      'ằ': 'a',
      'ắ': 'a',
      'ẳ': 'a',
      'ẵ': 'a',
      'ặ': 'a',
      'â': 'a',
      'ầ': 'a',
      'ấ': 'a',
      'ẩ': 'a',
      'ẫ': 'a',
      'ậ': 'a',
      'è': 'e',
      'é': 'e',
      'ẻ': 'e',
      'ẽ': 'e',
      'ẹ': 'e',
      'ê': 'e',
      'ề': 'e',
      'ế': 'e',
      'ể': 'e',
      'ễ': 'e',
      'ệ': 'e',
      'ì': 'i',
      'í': 'i',
      'ỉ': 'i',
      'ĩ': 'i',
      'ị': 'i',
      'ò': 'o',
      'ó': 'o',
      'ỏ': 'o',
      'õ': 'o',
      'ọ': 'o',
      'ô': 'o',
      'ồ': 'o',
      'ố': 'o',
      'ổ': 'o',
      'ỗ': 'o',
      'ộ': 'o',
      'ơ': 'o',
      'ờ': 'o',
      'ớ': 'o',
      'ở': 'o',
      'ỡ': 'o',
      'ợ': 'o',
      'ù': 'u',
      'ú': 'u',
      'ủ': 'u',
      'ũ': 'u',
      'ụ': 'u',
      'ư': 'u',
      'ừ': 'u',
      'ứ': 'u',
      'ử': 'u',
      'ữ': 'u',
      'ự': 'u',
      'ỳ': 'y',
      'ý': 'y',
      'ỷ': 'y',
      'ỹ': 'y',
      'ỵ': 'y',
      'đ': 'd',
    };

    final buffer = StringBuffer();
    for (final rune in lower.runes) {
      final char = String.fromCharCode(rune);
      buffer.write(replacements[char] ?? char);
    }

    return buffer
        .toString()
        .replaceAll(RegExp(r'[^a-z0-9\s]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
