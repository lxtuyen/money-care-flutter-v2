import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/wallet/domain/entities/wallet_entity.dart';

abstract class WalletRemoteDatasource {
  Future<List<WalletEntity>> findAll();
  Future<WalletEntity> findOne(int id);
  Future<WalletEntity> create(Map<String, dynamic> data);
  Future<WalletEntity> update(int id, Map<String, dynamic> data);
  Future<bool> delete(int id);
  Future<void> transfer(Map<String, dynamic> data);
  Future<double> getTotalAssets();
}

class WalletRemoteDatasourceImpl implements WalletRemoteDatasource {
  final ApiClient api;

  WalletRemoteDatasourceImpl({required this.api});

  @override
  Future<List<WalletEntity>> findAll() async {
    final res = await api.get<List<WalletEntity>>(
      ApiRoutes.wallets,
      fromJsonT: (json) {
        final list = json as List<dynamic>;
        return list.map((e) => WalletEntity.fromJson(e)).toList();
      },
    );
    return res.unwrap();
  }

  @override
  Future<WalletEntity> findOne(int id) async {
    final res = await api.get<WalletEntity>(
      '${ApiRoutes.wallets}/$id',
      fromJsonT: (json) => WalletEntity.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<WalletEntity> create(Map<String, dynamic> data) async {
    final res = await api.post<WalletEntity>(
      ApiRoutes.wallets,
      body: data,
      fromJsonT: (json) => WalletEntity.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<WalletEntity> update(int id, Map<String, dynamic> data) async {
    final res = await api.patch<WalletEntity>(
      '${ApiRoutes.wallets}/$id',
      body: data,
      fromJsonT: (json) => WalletEntity.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<bool> delete(int id) async {
    final res = await api.delete<void>('${ApiRoutes.wallets}/$id');
    res.unwrap();
    return true;
  }

  @override
  Future<void> transfer(Map<String, dynamic> data) async {
    final res = await api.post<void>(
      '${ApiRoutes.wallets}/transfer',
      body: data,
    );
    res.unwrap();
  }

  @override
  Future<double> getTotalAssets() async {
    final res = await api.get<double>(
      ApiRoutes.totalAssets,
      fromJsonT: (json) => double.parse(json.toString()),
    );
    return res.unwrap();
  }
}
