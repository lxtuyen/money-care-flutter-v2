import 'package:money_care/features/payment/domain/entities/monthly_revenue_entity.dart';

class MonthlyRevenueModel {
  final int month;
  final double total;

  MonthlyRevenueModel({
    required this.month,
    required this.total,
  });

  factory MonthlyRevenueModel.fromJson(Map<String, dynamic> json) {
    return MonthlyRevenueModel(
      month: json['month'],
      total: (json['total'] as num).toDouble(),
    );
  }

  MonthlyRevenueEntity toEntity() => MonthlyRevenueEntity(
    month: month,
    total: total,
  );
}
