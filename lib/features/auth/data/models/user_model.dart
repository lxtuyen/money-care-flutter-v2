import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_care/features/auth/data/models/fund_model.dart';
import 'package:money_care/features/auth/data/models/user_profile_model.dart';
import 'package:money_care/features/auth/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    required String email,
    required String role,
    bool? isVip,
    String? accessToken,
    required UserProfileModel profile,
    FundModel? fund,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Custom factory to handle token from external source (like login response)
  factory UserModel.fromAuthJson(Map<String, dynamic> json, String? token) {
    final model = UserModel.fromJson(json);
    return model.copyWith(accessToken: token);
  }

  factory UserModel.fromJsonUpdate(Map<String, dynamic> json) =>
      UserModel.fromJson(json);

  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        role: role,
        isVip: isVip,
        accessToken: accessToken,
        profile: profile.toEntity(),
        fund: fund?.toEntity(),
      );
}
