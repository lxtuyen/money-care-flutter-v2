import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/student_profile/domain/entities/student_profile_entity.dart';

abstract class StudentProfileRepository {
  Future<Either<Failure, StudentProfileEntity>> getStudentProfile(int userId);
  Future<Either<Failure, StudentProfileEntity>> saveStudentProfile(
      StudentProfileEntity profile);
}
