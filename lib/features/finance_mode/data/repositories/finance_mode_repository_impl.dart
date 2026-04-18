import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/exceptions.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/finance_mode/data/datasources/finance_mode_local_datasource.dart';
import 'package:money_care/features/finance_mode/data/datasources/finance_mode_remote_datasource.dart';
import 'package:money_care/features/finance_mode/data/models/finance_mode_model.dart';
import 'package:money_care/features/finance_mode/domain/entities/finance_mode_entity.dart';
import 'package:money_care/features/finance_mode/domain/repositories/finance_mode_repository.dart';

class FinanceModeRepositoryImpl implements FinanceModeRepository {
  final FinanceModeRemoteDatasource remoteDatasource;
  final FinanceModeLocalDatasource localDatasource;

  FinanceModeRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  /// Offline-first read: try remote first, fallback to local cache.
  @override
  Future<Either<Failure, FinanceModeEntity>> getFinanceMode(int userId) async {
    try {
      final model = await remoteDatasource.getFinanceMode(userId);
      await localDatasource.saveFinanceMode(model);
      return Right(model.toEntity());
    } on NetworkException catch (e) {
      final cached = await localDatasource.getFinanceMode(userId);
      if (cached != null) return Right(cached.toEntity());
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      final cached = await localDatasource.getFinanceMode(userId);
      if (cached != null) return Right(cached.toEntity());
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Offline-first write: save local first, queue pending sync, then sync to backend.
  /// If offline, the pending sync entry is kept for retry when connectivity is restored.
  @override
  Future<Either<Failure, FinanceModeEntity>> saveFinanceMode(
      FinanceModeEntity financeMode) async {
    final model = FinanceModeModel.fromEntity(financeMode);

    // Step 1: Save locally first (offline-first)
    await localDatasource.saveFinanceMode(model);

    // Step 2: Mark as pending sync in case network fails
    await localDatasource.savePendingSync(model);

    // Step 3: Attempt to sync with backend
    try {
      final synced = await remoteDatasource.saveFinanceMode(model);
      // Update local cache with server response
      await localDatasource.saveFinanceMode(synced);
      // Clear pending sync — successfully synced
      await localDatasource.clearPendingSync(financeMode.userId);
      return Right(synced.toEntity());
    } on NetworkException {
      // Offline — local save succeeded, pending sync queued for later retry
      return Right(model.toEntity());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Retry syncing any pending changes to the backend.
  /// Call this when ConnectivityService reports the connection is restored.
  Future<void> syncPending(int userId) async {
    final pending = await localDatasource.getPendingSync(userId);
    if (pending == null) return;

    try {
      final synced = await remoteDatasource.saveFinanceMode(pending);
      await localDatasource.saveFinanceMode(synced);
      await localDatasource.clearPendingSync(userId);
    } on NetworkException {
      // Still offline — keep pending entry for next retry
    } catch (_) {
      // Other errors — keep pending entry, will retry later
    }
  }
}


