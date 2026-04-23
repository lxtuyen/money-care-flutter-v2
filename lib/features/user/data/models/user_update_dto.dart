import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_update_dto.freezed.dart';
part 'user_update_dto.g.dart';

@freezed
abstract class UserUpdateDto with _$UserUpdateDto {
  const factory UserUpdateDto({String? role, bool? isVip}) = _UserUpdateDto;

  factory UserUpdateDto.fromJson(Map<String, dynamic> json) =>
      _$UserUpdateDtoFromJson(json);
}
