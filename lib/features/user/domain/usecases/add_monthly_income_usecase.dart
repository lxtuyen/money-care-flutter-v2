import 'package:money_care/features/user/domain/entities/user_profile_entity.dart';
import 'package:money_care/features/user/domain/repositories/user_repository.dart';

class AddMonthlyIncomeUseCase {
  final UserRepository repository;
  AddMonthlyIncomeUseCase(this.repository);

  Future<UserProfileEntity> call(int monthlyIncome) {
    return repository.addMonthlyIncome(monthlyIncome);
  }
}