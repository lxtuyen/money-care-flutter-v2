import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_wallet_dto.freezed.dart';

@freezed
abstract class UpdateWalletDto with _$UpdateWalletDto {
  const factory UpdateWalletDto({
    String? name,
    @JsonKey(name: 'is_active') bool? isActive,
  }) = _UpdateWalletDto;

  const UpdateWalletDto._();

  Map<String, dynamic> toJson() {
    final map = {'name': name, 'is_active': isActive};
    map.removeWhere((key, value) => value == null);
    return map;
  }
}
