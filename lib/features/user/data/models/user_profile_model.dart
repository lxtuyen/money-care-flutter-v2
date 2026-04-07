import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_care/features/user/domain/entities/user_profile_entity.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
class ProfileUpdateDto with _$ProfileUpdateDto {
  @JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
  const factory ProfileUpdateDto({
    String? firstName,
    String? lastName,
    int? monthlyIncome,
    DateTime? incomeDate,
  }) = _ProfileUpdateDto;

  factory ProfileUpdateDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileUpdateDtoFromJson(json);
}

@freezed
class UserUpdateDto with _$UserUpdateDto {
  const factory UserUpdateDto({
    String? role,
    bool? isVip,
  }) = _UserUpdateDto;

  factory UserUpdateDto.fromJson(Map<String, dynamic> json) =>
      _$UserUpdateDtoFromJson(json);
}

@freezed
class UserProfileModel with _$UserProfileModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UserProfileModel({
    int? id,
    required String firstName,
    required String lastName,
    int? monthlyIncome,
    DateTime? incomeDate,
  }) = _UserProfileModel;

  const UserProfileModel._();

  String get fullName => '$firstName $lastName';

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  UserProfileEntity toEntity() => UserProfileEntity(
        id: id,
        firstName: firstName,
        lastName: lastName,
        monthlyIncome: monthlyIncome,
        incomeDate: incomeDate,
      );
}
