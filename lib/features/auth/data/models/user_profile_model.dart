import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_care/features/user/domain/entities/user_profile_entity.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
abstract class UserProfileModel with _$UserProfileModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UserProfileModel({
    int? id,
    required String firstName,
    required String lastName,
    String? avatar,
  }) = _UserProfileModel;

  const UserProfileModel._();

  String get fullName => '$firstName $lastName';

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  UserProfileEntity toEntity() => UserProfileEntity(
    id: id ?? 0,
    firstName: firstName,
    lastName: lastName,
    avatar: avatar,
  );
}
