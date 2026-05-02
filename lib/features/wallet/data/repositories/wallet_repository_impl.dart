import 'package:money_care/features/wallet/data/datasources/wallet_remote_datasource.dart';
import 'package:money_care/features/wallet/domain/entities/wallet_entity.dart';
import 'package:money_care/features/wallet/domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDatasource remoteDatasource;

  WalletRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<WalletEntity>> findAll() {
    return remoteDatasource.findAll();
  }

  @override
  Future<WalletEntity> findOne(int id) {
    return remoteDatasource.findOne(id);
  }

  @override
  Future<WalletEntity> create(Map<String, dynamic> data) {
    return remoteDatasource.create(data);
  }

  @override
  Future<WalletEntity> update(int id, Map<String, dynamic> data) {
    return remoteDatasource.update(id, data);
  }

  @override
  Future<bool> delete(int id) {
    return remoteDatasource.delete(id);
  }

  @override
  Future<void> transfer(Map<String, dynamic> data) {
    return remoteDatasource.transfer(data);
  }

  @override
  Future<double> getTotalAssets() {
    return remoteDatasource.getTotalAssets();
  }
}
