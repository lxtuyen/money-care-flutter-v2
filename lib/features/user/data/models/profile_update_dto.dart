import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_update_dto.freezed.dart';
part 'profile_update_dto.g.dart';

@freezed
abstract class ProfileUpdateDto with _$ProfileUpdateDto {
  const factory ProfileUpdateDto({
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'monthlyIncome') int? monthlyIncome,
    @JsonKey(name: 'incomeDate') DateTime? incomeDate,
    @JsonKey(name: 'avatar') String? avatar,
  }) = _ProfileUpdateDto;

  factory ProfileUpdateDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileUpdateDtoFromJson(json);
}
