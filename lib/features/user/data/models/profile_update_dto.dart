import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_update_dto.freezed.dart';
part 'profile_update_dto.g.dart';

@freezed
abstract class ProfileUpdateDto with _$ProfileUpdateDto {
  const factory ProfileUpdateDto({
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
  }) = _ProfileUpdateDto;

  factory ProfileUpdateDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileUpdateDtoFromJson(json);
}
