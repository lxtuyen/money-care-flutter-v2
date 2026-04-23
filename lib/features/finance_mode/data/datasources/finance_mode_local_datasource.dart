import 'dart:convert';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/features/finance_mode/data/models/finance_mode_model.dart';

abstract class FinanceModeLocalDatasource {
  Future<FinanceModeModel?> getFinanceMode(int userId);
  Future<void> saveFinanceMode(FinanceModeModel model);
  Future<void> clearFinanceMode(int userId);

  /// Pending sync queue — stored when offline, cleared after successful sync.
  Future<void> savePendingSync(FinanceModeModel model);
  Future<FinanceModeModel?> getPendingSync(int userId);
  Future<void> clearPendingSync(int userId);
}

class FinanceModeLocalDatasourceImpl implements FinanceModeLocalDatasource {
  final LocalStorage storage;

  FinanceModeLocalDatasourceImpl({required this.storage});

  String _key(int userId) => 'finance_mode_$userId';
  String _pendingKey(int userId) => 'pending_sync_finance_mode_$userId';

  @override
  Future<FinanceModeModel?> getFinanceMode(int userId) async {
    final jsonString = storage.readString(_key(userId));
    if (jsonString == null) return null;
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return FinanceModeModel.fromJson(json);
  }

  @override
  Future<void> saveFinanceMode(FinanceModeModel model) async {
    final jsonString = jsonEncode(model.toJson());
    await storage.writeString(_key(model.userId), jsonString);
  }

  @override
  Future<void> clearFinanceMode(int userId) async {
    await storage.remove(_key(userId));
  }

  @override
  Future<void> savePendingSync(FinanceModeModel model) async {
    final jsonString = jsonEncode(model.toJson());
    await storage.writeString(_pendingKey(model.userId), jsonString);
  }

  @override
  Future<FinanceModeModel?> getPendingSync(int userId) async {
    final jsonString = storage.readString(_pendingKey(userId));
    if (jsonString == null) return null;
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return FinanceModeModel.fromJson(json);
  }

  @override
  Future<void> clearPendingSync(int userId) async {
    await storage.remove(_pendingKey(userId));
  }
}
