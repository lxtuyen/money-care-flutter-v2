import 'package:money_care/features/saving_fund/data/models/models.dart';
import 'package:money_care/features/saving_fund/domain/entities/saving_fund_entity.dart';

abstract class SavingFundRepository {
  Future<SavingFundEntity> createSavingFund(SavingFundDto dto);
  Future<List<SavingFundEntity>> getSavingFundsByUser(int userId);
  Future<SavingFundEntity> getSavingFund(int id);
  Future<SavingFundEntity> updateSavingFund(SavingFundDto dto);
  Future<bool> deleteSavingFund(int id);
  Future<SavingFundEntity> selectSavingFund(int userId, int fundId);
}
