import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/errors/exceptions.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/student_profile/data/models/student_profile_model.dart';

abstract class StudentProfileRemoteDatasource {
  Future<StudentProfileModel> getStudentProfile(int userId);
  Future<StudentProfileModel> saveStudentProfile(StudentProfileModel model);
}

class StudentProfileRemoteDatasourceImpl
    implements StudentProfileRemoteDatasource {
  final ApiClient api;

  StudentProfileRemoteDatasourceImpl({required this.api});

  @override
  Future<StudentProfileModel> getStudentProfile(int userId) async {
    final res = await api.get<StudentProfileModel>(
      ApiRoutes.studentProfile,
      fromJsonT: (json) =>
          StudentProfileModel.fromJson(json as Map<String, dynamic>),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty
            ? res.message
            : 'Không thể tải hồ sơ sinh viên',
      );
    }
    return res.data!;
  }

  @override
  Future<StudentProfileModel> saveStudentProfile(
      StudentProfileModel model) async {
    final res = await api.put<StudentProfileModel>(
      ApiRoutes.studentProfile,
      body: model.toJson(),
      fromJsonT: (json) =>
          StudentProfileModel.fromJson(json as Map<String, dynamic>),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty
            ? res.message
            : 'Không thể lưu hồ sơ sinh viên',
      );
    }
    return res.data!;
  }
}
