import 'package:money_care/features/saving_fund/data/datasources/saving_fund_remote_datasource.dart';
import 'package:money_care/features/saving_fund/data/models/models.dart';
import 'package:money_care/features/saving_fund/domain/entities/saving_fund_entity.dart';
import 'package:money_care/features/saving_fund/domain/repositories/saving_fund_repository.dart';

class SavingFundRepositoryImpl implements SavingFundRepository {
  final SavingFundRemoteDatasource remoteDatasource;

  SavingFundRepositoryImpl({required this.remoteDatasource});

  @override
  Future<SavingFundEntity> createSavingFund(SavingFundDto dto) async {
    final model = await remoteDatasource.createSavingFund(dto);
    return model.toEntity();
  }

  @override
  Future<List<SavingFundEntity>> getSavingFundsByUser(int userId) async {
    final models = await remoteDatasource.getSavingFundsByUser(userId);
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<SavingFundEntity> getSavingFund(int id) async {
    final model = await remoteDatasource.getSavingFund(id);
    return model.toEntity();
  }

  @override
  Future<SavingFundEntity> updateSavingFund(SavingFundDto dto) async {
    final model = await remoteDatasource.updateSavingFund(dto);
    return model.toEntity();
  }

  @override
  Future<bool> deleteSavingFund(int id) {
    return remoteDatasource.deleteSavingFund(id);
  }

  @override
  Future<SavingFundEntity> selectSavingFund(int userId, int fundId) async {
    final model = await remoteDatasource.selectSavingFund(userId, fundId);
    return model.toEntity();
  }
}
