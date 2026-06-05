import '../../data/models/personal_finance_profile_model.dart';

abstract class PersonalizationRepository {
  Future<PersonalFinanceProfileModel> getProfile();
  Future<PersonalFinanceProfileModel> rebuildProfile();
}
