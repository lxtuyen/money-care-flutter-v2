import 'package:money_care/features/saving_fund/data/models/models.dart';
import 'package:money_care/features/saving_fund/domain/entities/saving_fund_entity.dart';
import 'package:money_care/features/saving_fund/domain/repositories/saving_fund_repository.dart';

class CreateSavingFundUseCase {
  final SavingFundRepository repository;
  CreateSavingFundUseCase(this.repository);

  Future<SavingFundEntity> call(SavingFundDto dto) {
    return repository.createSavingFund(dto);
  }
}

class GetSavingFundsByUserUseCase {
  final SavingFundRepository repository;
  GetSavingFundsByUserUseCase(this.repository);

  Future<List<SavingFundEntity>> call(int userId) {
    return repository.getSavingFundsByUser(userId);
  }
}

class GetSavingFundUseCase {
  final SavingFundRepository repository;
  GetSavingFundUseCase(this.repository);

  Future<SavingFundEntity> call(int id) {
    return repository.getSavingFund(id);
  }
}

class UpdateSavingFundUseCase {
  final SavingFundRepository repository;
  UpdateSavingFundUseCase(this.repository);

  Future<SavingFundEntity> call(SavingFundDto dto) {
    return repository.updateSavingFund(dto);
  }
}

class DeleteSavingFundUseCase {
  final SavingFundRepository repository;
  DeleteSavingFundUseCase(this.repository);

  Future<bool> call(int id) {
    return repository.deleteSavingFund(id);
  }
}

class SelectSavingFundUseCase {
  final SavingFundRepository repository;
  SelectSavingFundUseCase(this.repository);

  Future<SavingFundEntity> call(int userId, int fundId) {
    return repository.selectSavingFund(userId, fundId);
  }
}
