import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/user/data/models/user_profile_model.dart';

abstract class UserRemoteDatasource {
  Future<UserProfileModel> updateMyProfile(ProfileUpdateDto dto);
  Future<UserProfileModel> addMonthlyIncome(int monthlyIncome);
}

class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  final ApiClient api;

  UserRemoteDatasourceImpl({required this.api});

  @override
  Future<UserProfileModel> updateMyProfile(ProfileUpdateDto dto) async {
    final res = await api.patch<UserProfileModel>(
      ApiRoutes.userProfile,
      body: dto.toJson(),
      fromJsonT: (json) => UserProfileModel.fromJson(json),
    );
    if (!res.success || res.data == null) throw Exception(res.message);
    return res.data!;
  }

  @override
  Future<UserProfileModel> addMonthlyIncome(int monthlyIncome) async {
    final res = await api.patch<UserProfileModel>(
      ApiRoutes.monthlyIncome,
      body: {'monthly_income': monthlyIncome},
      fromJsonT: (json) => UserProfileModel.fromJson(json),
    );
    if (!res.success || res.data == null) throw Exception(res.message);
    return res.data!;
  }
}
