import '../repositories/personalization_repository.dart';
import '../../data/models/personal_finance_profile_model.dart';

class GetPersonalFinanceProfileUseCase {
  final PersonalizationRepository repository;

  const GetPersonalFinanceProfileUseCase(this.repository);

  Future<PersonalFinanceProfileModel> execute() {
    return repository.getProfile();
  }

  Future<PersonalFinanceProfileModel> rebuild() {
    return repository.rebuildProfile();
  }

  Future<void> retrainModel() {
    return repository.retrainForecastingModel();
  }
}
