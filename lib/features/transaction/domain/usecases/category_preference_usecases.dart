import 'package:money_care/features/transaction/domain/repositories/category_preference_repository.dart';

class GetEssentialExpenseCategoryIdsUseCase {
  final CategoryPreferenceRepository repository;

  const GetEssentialExpenseCategoryIdsUseCase(this.repository);

  Future<Set<int>> call() {
    return repository.getEssentialExpenseCategoryIds();
  }
}

class SaveEssentialExpenseCategoryIdsUseCase {
  final CategoryPreferenceRepository repository;

  const SaveEssentialExpenseCategoryIdsUseCase(this.repository);

  Future<void> call(Set<int> categoryIds) {
    return repository.saveEssentialExpenseCategoryIds(categoryIds);
  }
}
