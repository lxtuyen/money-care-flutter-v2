import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_care/core/utils/helper/num_parser.dart';
import 'package:money_care/features/transaction/data/models/category_model.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

part 'transaction_response_model.freezed.dart';
part 'transaction_response_model.g.dart';

Object? _readPictureUrl(Map json, String key) {
  return json['pictureURL'] ?? json['pictuteURL'];
}

@freezed
abstract class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    @JsonKey(fromJson: NumParser.parseIntNullable) int? id,
    @JsonKey(fromJson: NumParser.parseInt) @Default(0) int amount,
    @Default('') String type,
    @JsonKey(readValue: _readPictureUrl, name: 'picture_url') String? pictureUrl,
    @JsonKey(name: 'transaction_date') DateTime? transactionDate,
    String? note,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    CategoryModel? category,
  }) = _TransactionModel;

  const TransactionModel._();

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  TransactionEntity toEntity() => TransactionEntity(
        id: id,
        amount: amount,
        type: type,
        pictureUrl: pictureUrl,
        transactionDate: transactionDate,
        note: note,
        createdAt: createdAt,
        updatedAt: updatedAt,
        category: category?.toEntity(),
      );
}
