import 'package:money_care/features/admin/domain/entities/entities.dart';

class AdminUserStatsModel {
  final int totalUsers;
  final int newUsersThisMonth;
  final double freePercent;
  final double vipPercent;
  final double monthlyRevenue;

  AdminUserStatsModel({
    required this.totalUsers,
    required this.newUsersThisMonth,
    required this.freePercent,
    required this.vipPercent,
    required this.monthlyRevenue,
  });

  factory AdminUserStatsModel.fromJson(Map<String, dynamic> json) {
    return AdminUserStatsModel(
      totalUsers: json['totalUsers'] as int,
      newUsersThisMonth: json['newUsersThisMonth'] as int,
      freePercent: (json['freePercent'] as num).toDouble(),
      vipPercent: (json['vipPercent'] as num).toDouble(),
      monthlyRevenue: (json['monthlyRevenue'] as num).toDouble(),
    );
  }

  AdminUserStatsEntity toEntity() => AdminUserStatsEntity(
    totalUsers: totalUsers,
    newUsersThisMonth: newUsersThisMonth,
    freePercent: freePercent,
    vipPercent: vipPercent,
    monthlyRevenue: monthlyRevenue,
  );
}
