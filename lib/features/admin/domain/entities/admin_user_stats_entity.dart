class AdminUserStatsEntity {
  final int totalUsers;
  final int newUsersThisMonth;
  final double freePercent;
  final double vipPercent;
  final double monthlyRevenue;

  const AdminUserStatsEntity({
    required this.totalUsers,
    required this.newUsersThisMonth,
    required this.freePercent,
    required this.vipPercent,
    required this.monthlyRevenue,
  });
}
