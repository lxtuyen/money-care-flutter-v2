import 'package:money_care/features/wallet/data/models/transfer_dto.dart';
import 'package:money_care/features/wallet/data/models/update_wallet_dto.dart';
import 'package:money_care/features/wallet/domain/entities/wallet_entity.dart';

abstract class WalletRepository {
  Future<List<WalletEntity>> findAll({int? coupleId});
  Future<WalletEntity> findOne(int id);
  Future<WalletEntity> create(Map<String, dynamic> data);
  Future<WalletEntity> update(int id, UpdateWalletDto dto);
  Future<bool> delete(int id);
  Future<void> transfer(TransferDto dto);
  Future<double> getTotalAssets();
}
