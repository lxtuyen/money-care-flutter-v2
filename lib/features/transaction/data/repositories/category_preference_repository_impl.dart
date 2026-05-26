import 'package:money_care/features/transaction/data/datasources/category_preference_remote_datasource.dart';
import 'package:money_care/features/transaction/domain/repositories/category_preference_repository.dart';

class CategoryPreferenceRepositoryImpl implements CategoryPreferenceRepository {
  final CategoryPreferenceRemoteDatasource remoteDatasource;

  const CategoryPreferenceRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Set<int>> getEssentialExpenseCategoryIds() {
    return remoteDatasource.getEssentialExpenseCategoryIds();
  }

  @override
  Future<void> saveEssentialExpenseCategoryIds(Set<int> categoryIds) {
    return remoteDatasource.saveEssentialExpenseCategoryIds(categoryIds);
  }
}
