class SubscriptionEntity {
  final bool isPremium;
  final bool isGracePeriod;
  final bool isTrial;
  final bool hasUsedTrial;
  final String? plan;
  final DateTime? expiresAt;
  final DateTime? graceExpiresAt;
  final int daysRemaining;

  const SubscriptionEntity({
    required this.isPremium,
    required this.isGracePeriod,
    required this.isTrial,
    required this.hasUsedTrial,
    this.plan,
    this.expiresAt,
    this.graceExpiresAt,
    required this.daysRemaining,
  });

  bool get isActive => isPremium && !isGracePeriod;
  bool get needsRenewal => isGracePeriod || !isPremium;
  bool get canStartTrial => !hasUsedTrial && !isPremium;
}
