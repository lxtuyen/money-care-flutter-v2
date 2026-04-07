import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_care/features/transaction/domain/entities/category_entity.dart';

part 'fund_dto.freezed.dart';

@freezed
class FundDto with _$FundDto {
  const factory FundDto({
    String? name,
    String? type,
    List<CategoryEntity>? categories,
    int? id,
    double? balance,
    double? target,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
  }) = _FundDto;

  const FundDto._();

  Map<String, dynamic> toJsonCreate() {
    return {
      'name': name,
      'type': type,
      'categories': categories
          ?.map(
            (e) => <String, dynamic>{
              'name': e.name,
              'percentage': e.percentage,
              'icon': e.icon,
            },
          )
          .toList(),
      'userId': id,
      'balance': balance,
      'target': target,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
    };
  }

  Map<String, dynamic> toJsonUpdate() {
    return {
      'name': name,
      'type': type,
      'categories': categories
          ?.map(
            (e) => <String, dynamic>{
              'id': e.id,
              'name': e.name,
              'percentage': e.percentage,
              'icon': e.icon,
            },
          )
          .toList(),
      'balance': balance,
      'target': target,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
    };
  }
}
