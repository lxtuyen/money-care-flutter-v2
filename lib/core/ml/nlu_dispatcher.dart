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

/// Routes NLU results to the appropriate NestJS API endpoint and returns
/// a human-readable response string for the chat UI.
class NluDispatcher {
  final ApiClient _api;
  final EmbeddingService _embeddingService = EmbeddingService();

  NluDispatcher({required ApiClient api}) : _api = api;

  /// Dispatches a [NluResult] for [userId] and optional [fundId].
  /// Returns a formatted response string to display in the chat.
  Future<String> dispatch(
    NluResult result,
    int userId, {
    int? fundId,
  }) async {
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
    if (categoryName != null) {
      final matchResult = await _matchCategory(categoryName, userId, type);
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
      print("🧪 [TEST MODE] Chặn lưu giao dịch: $categoryName - ${entities.amount}");
      
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
    if (entities.category != null) {
      final match = await _matchCategory(entities.category!, userId, type);
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

  // ────────────────────────────────────────────────────────────────────────────
  // GET CATEGORIES
  // ────────────────────────────────────────────────────────────────────────────

  Future<String> _getCategories({required int userId}) async {
    try {
      final res = await _api.get<List<CategoryModel>>(
        '${ApiRoutes.userCategories}/$userId',
        fromJsonT: (json) {
          final list = json as List<dynamic>;
          return list.map((e) => CategoryModel.fromJson(e)).toList();
        },
      );

      if (!res.success || res.data == null) {
        return ResponseBuilder.apiError(res.message);
      }

      return ResponseBuilder.categoryList(res.data!);
    } catch (e) {
      return ResponseBuilder.apiError(e.toString());
    }
  }

  // ────────────────────────────────────────────────────────────────────────────
  // CATEGORY FUZZY MATCHING
  // ────────────────────────────────────────────────────────────────────────────

  /// Fetches user categories and returns the best fuzzy match for [query].
  /// Returns null if no match found or API fails.
  Future<CategoryModel?> _matchCategory(
    String query,
    int userId,
    String type,
  ) async {
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

      // 1. Exact match (case-insensitive)
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
            .where((qt) => catTokens.any((ct) => ct.contains(qt) || qt.contains(ct)))
            .length;
        if (overlap > bestScore) {
          bestScore = overlap;
          best = cat;
        }
      }

      if (bestScore > 0) return best;

      // 4. Semantic match using EmbeddingService
      print('🧠 Semantic matching for: "$queryLower"...');
      if (!_embeddingService.isInitialized) {
        await _embeddingService.initialize();
      }

      final queryEmb = await _embeddingService.getEmbedding(queryLower);
      CategoryModel? bestSemantic;
      double bestSimilarity = -1.0;

      for (final cat in categories) {
        final catEmb = await _embeddingService.getEmbedding(cat.name.toLowerCase());
        final similarity = EmbeddingService.cosineSimilarity(queryEmb, catEmb);
        
        // Log chi tiết từng danh mục để bạn theo dõi
        print('   🔍 Thử với: "${cat.name}" -> Similarity: ${(similarity * 100).toStringAsFixed(1)}%');

        if (similarity > bestSimilarity) {
          bestSimilarity = similarity;
          bestSemantic = cat;
        }
      }

      // If semantic similarity is > 65%, consider it a match
      if (bestSemantic != null && bestSimilarity > 0.65) {
        print('   ✅ Chọn danh mục: "${bestSemantic.name}" (Độ tương đồng cao nhất: ${(bestSimilarity * 100).toStringAsFixed(1)}%)');
        return bestSemantic;
      }

      print('   ⚠️ Không tìm thấy danh mục nào đủ giống (Max: ${(bestSimilarity * 100).toStringAsFixed(1)}%)');
      return null;
    } catch (_) {
      return null;
    }
  }
}
