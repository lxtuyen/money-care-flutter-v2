import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/exceptions.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/student_profile/data/datasources/student_profile_local_datasource.dart';
import 'package:money_care/features/student_profile/data/datasources/student_profile_remote_datasource.dart';
import 'package:money_care/features/student_profile/data/models/student_profile_model.dart';
import 'package:money_care/features/student_profile/domain/entities/student_profile_entity.dart';
import 'package:money_care/features/student_profile/domain/repositories/student_profile_repository.dart';

class StudentProfileRepositoryImpl implements StudentProfileRepository {
  final StudentProfileRemoteDatasource remoteDatasource;
  final StudentProfileLocalDatasource localDatasource;

  StudentProfileRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  /// Offline-first read: try remote first, fallback to local cache.
  @override
  Future<Either<Failure, StudentProfileEntity>> getStudentProfile(
      int userId) async {
    try {
      final model = await remoteDatasource.getStudentProfile(userId);
      // Cache the latest remote data locally
      await localDatasource.saveStudentProfile(model);
      return Right(model.toEntity());
    } on NetworkException catch (e) {
      // Offline — try local cache
      final cached = await localDatasource.getStudentProfile(userId);
      if (cached != null) {
        return Right(cached.toEntity());
      }
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      // Server error — try local cache as fallback
      final cached = await localDatasource.getStudentProfile(userId);
      if (cached != null) {
        return Right(cached.toEntity());
      }
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Offline-first write: save local first, then sync to backend.
  @override
  Future<Either<Failure, StudentProfileEntity>> saveStudentProfile(
      StudentProfileEntity profile) async {
    final model = StudentProfileModel.fromEntity(profile);

    // Step 1: Save locally first (offline-first)
    await localDatasource.saveStudentProfile(model);

    // Step 2: Attempt to sync with backend
    try {
      final synced = await remoteDatasource.saveStudentProfile(model);
      // Update local cache with server response (may include server-side fields)
      await localDatasource.saveStudentProfile(synced);
      return Right(synced.toEntity());
    } on NetworkException {
      // Offline — local save succeeded, return local data
      return Right(model.toEntity());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
