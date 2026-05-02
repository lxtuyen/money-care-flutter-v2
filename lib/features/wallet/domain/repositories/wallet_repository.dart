import 'package:money_care/features/wallet/domain/entities/wallet_entity.dart';

abstract class WalletRepository {
  Future<List<WalletEntity>> findAll();
  Future<WalletEntity> findOne(int id);
  Future<WalletEntity> create(Map<String, dynamic> data);
  Future<WalletEntity> update(int id, Map<String, dynamic> data);
  Future<bool> delete(int id);
  Future<void> transfer(Map<String, dynamic> data);
  Future<double> getTotalAssets();
}
