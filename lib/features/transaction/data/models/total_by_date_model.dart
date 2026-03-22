import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class TotalByDateEntityModel {
  final DateTime date;
  final int total;

  TotalByDateEntityModel({required this.date, required this.total});

  factory TotalByDateEntityModel.fromJson(Map<String, dynamic> json) {
    return TotalByDateEntityModel(
      date: DateTime.parse(json['date']),
      total: (json['total'] ?? 0).toInt(),
    );
  }

  TotalByDateEntity toEntity() => TotalByDateEntity(date: date, total: total);
}
