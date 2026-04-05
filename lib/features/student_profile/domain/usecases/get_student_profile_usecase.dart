import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/student_profile/domain/entities/student_profile_entity.dart';
import 'package:money_care/features/student_profile/domain/repositories/student_profile_repository.dart';

class GetStudentProfileUseCase {
  final StudentProfileRepository repository;

  GetStudentProfileUseCase(this.repository);

  Future<Either<Failure, StudentProfileEntity>> call(int userId) {
    return repository.getStudentProfile(userId);
  }
}
