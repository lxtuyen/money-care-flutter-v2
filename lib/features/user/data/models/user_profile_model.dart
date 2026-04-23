import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_care/features/user/domain/entities/user_profile_entity.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
abstract class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    int? id,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'monthly_income') int? monthlyIncome,
    @JsonKey(name: 'income_date') DateTime? incomeDate,
  }) = _UserProfileModel;

  const UserProfileModel._();

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
