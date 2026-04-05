import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/student_profile/domain/entities/student_profile_entity.dart';
import 'package:money_care/features/student_profile/domain/repositories/student_profile_repository.dart';

class SaveStudentProfileUseCase {
  final StudentProfileRepository repository;

  SaveStudentProfileUseCase(this.repository);

  Future<Either<Failure, StudentProfileEntity>> call(
      StudentProfileEntity profile) {
    return repository.saveStudentProfile(profile);
  }
}
