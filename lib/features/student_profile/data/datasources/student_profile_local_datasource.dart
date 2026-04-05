import 'dart:convert';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/features/student_profile/data/models/student_profile_model.dart';

abstract class StudentProfileLocalDatasource {
  Future<StudentProfileModel?> getStudentProfile(int userId);
  Future<void> saveStudentProfile(StudentProfileModel model);
  Future<void> clearStudentProfile(int userId);
}

class StudentProfileLocalDatasourceImpl
    implements StudentProfileLocalDatasource {
  final LocalStorage storage;

  StudentProfileLocalDatasourceImpl({required this.storage});

  String _key(int userId) => 'student_profile_$userId';

  @override
  Future<StudentProfileModel?> getStudentProfile(int userId) async {
    final jsonString = storage.readString(_key(userId));
    if (jsonString == null) return null;
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return StudentProfileModel.fromJson(json);
  }

  @override
  Future<void> saveStudentProfile(StudentProfileModel model) async {
    final jsonString = jsonEncode(model.toJson());
    await storage.writeString(_key(model.userId), jsonString);
  }

  @override
  Future<void> clearStudentProfile(int userId) async {
    await storage.remove(_key(userId));
  }
}
