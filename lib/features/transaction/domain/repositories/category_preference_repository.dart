abstract class CategoryPreferenceRepository {
  Future<Set<int>> getEssentialExpenseCategoryIds();

  Future<void> saveEssentialExpenseCategoryIds(Set<int> categoryIds);
}
