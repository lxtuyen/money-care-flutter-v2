import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/network/api_client.dart';

abstract class CategoryPreferenceRemoteDatasource {
  Future<Set<int>> getEssentialExpenseCategoryIds();

  Future<void> saveEssentialExpenseCategoryIds(Set<int> categoryIds);
}

class CategoryPreferenceRemoteDatasourceImpl
    implements CategoryPreferenceRemoteDatasource {
  final ApiClient api;

  const CategoryPreferenceRemoteDatasourceImpl({required this.api});

  @override
  Future<Set<int>> getEssentialExpenseCategoryIds() async {
    final res = await api.get<Set<int>>(
      '${ApiRoutes.categories}/me/essential-expenses',
      fromJsonT: _parseCategoryIds,
    );
    return res.unwrap();
  }

  @override
  Future<void> saveEssentialExpenseCategoryIds(Set<int> categoryIds) async {
    final res = await api.put<void>(
      '${ApiRoutes.categories}/me/essential-expenses',
      body: {'categoryIds': categoryIds.toList()},
    );
    res.unwrap();
  }

  Set<int> _parseCategoryIds(dynamic json) {
    final rawIds = json is Map<String, dynamic> ? json['categoryIds'] : null;
    if (rawIds is! List) return <int>{};
    return rawIds
        .map((item) => item is int ? item : int.tryParse(item.toString()))
        .whereType<int>()
        .toSet();
  }
}
