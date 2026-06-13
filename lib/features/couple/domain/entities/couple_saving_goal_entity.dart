class CoupleSavingGoalContribution {
  final int id;
  final double amount;
  final int userId;
  final String fullName;
  final DateTime createdAt;

  CoupleSavingGoalContribution({
    required this.id,
    required this.amount,
    required this.userId,
    required this.fullName,
    required this.createdAt,
  });

  factory CoupleSavingGoalContribution.fromJson(Map<String, dynamic> json) {
    return CoupleSavingGoalContribution(
      id: json['id'] ?? 0,
      amount: double.parse(json['amount']?.toString() ?? '0'),
      userId: json['userId'] ?? 0,
      fullName: json['fullName'] ?? 'Thành viên',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}

class CoupleSavingGoalMemberProgress {
  final int userId;
  final String fullName;
  final double amount;

  CoupleSavingGoalMemberProgress({
    required this.userId,
    required this.fullName,
    required this.amount,
  });

  factory CoupleSavingGoalMemberProgress.fromJson(Map<String, dynamic> json) {
    return CoupleSavingGoalMemberProgress(
      userId: json['userId'] ?? 0,
      fullName: json['fullName'] ?? '',
      amount: double.parse(json['amount']?.toString() ?? '0'),
    );
  }
}

class CoupleSavingGoalEntity {
  final int id;
  final int coupleId;
  final String name;
  final double target;
  final double savedAmount;
  final DateTime? endDate;
  final String status;
  final List<CoupleSavingGoalMemberProgress> memberContributions;
  final List<CoupleSavingGoalContribution> contributions;

  CoupleSavingGoalEntity({
    required this.id,
    required this.coupleId,
    required this.name,
    required this.target,
    required this.savedAmount,
    this.endDate,
    required this.status,
    required this.memberContributions,
    required this.contributions,
  });

  factory CoupleSavingGoalEntity.fromJson(Map<String, dynamic> json) {
    final memberContribs =
        (json['memberContributions'] as List<dynamic>?)
            ?.map((x) => CoupleSavingGoalMemberProgress.fromJson(x))
            .toList() ??
        [];
    final contribList =
        (json['contributions'] as List<dynamic>?)
            ?.map((x) => CoupleSavingGoalContribution.fromJson(x))
            .toList() ??
        [];

    return CoupleSavingGoalEntity(
      id: json['id'] ?? 0,
      coupleId: json['coupleId'] ?? 0,
      name: json['name'] ?? '',
      target: double.parse(json['target']?.toString() ?? '0'),
      savedAmount: double.parse(json['saved_amount']?.toString() ?? '0'),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : null,
      status: json['status'] ?? 'active',
      memberContributions: memberContribs,
      contributions: contribList,
    );
  }
}
