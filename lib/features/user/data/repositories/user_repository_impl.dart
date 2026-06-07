import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/exceptions.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/user/data/datasources/user_remote_datasource.dart';
import 'package:money_care/features/user/data/models/profile_update_dto.dart';
import 'package:money_care/features/user/domain/entities/user_profile_entity.dart';
import 'package:money_care/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource remoteDatasource;

  UserRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, UserProfileEntity>> updateMyProfile(ProfileUpdateDto dto) async {
    try {
      final model = await remoteDatasource.updateMyProfile(dto);
      return Right(model.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
