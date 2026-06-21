import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/payment/domain/entities/subscription_entity.dart';
import 'package:money_care/features/payment/domain/entities/payment_entity.dart';

abstract class PaymentRemoteDatasource {
  Future<String> subscribe();
  Future<SubscriptionEntity> activateTrial();
  Future<SubscriptionEntity> getSubscriptionStatus();
  Future<List<PaymentEntity>> getPaymentHistory();
  Future<bool> verifyPayment(int orderCode);
}

class PaymentRemoteDatasourceImpl implements PaymentRemoteDatasource {
  final ApiClient api;

  PaymentRemoteDatasourceImpl({required this.api});

  @override
  Future<String> subscribe() async {
    final res = await api.post<Map<String, dynamic>>(
      ApiRoutes.paymentsSubscribe,
      fromJsonT: (json) => json as Map<String, dynamic>,
    );
    final data = res.unwrap();
    return data['checkoutUrl'] as String;
  }

  @override
  Future<SubscriptionEntity> activateTrial() async {
    final res = await api.post<SubscriptionEntity>(
      ApiRoutes.paymentsActivateTrial,
      fromJsonT: (json) => _parseSubscriptionStatus({
        'isPremium': true,
        'isGracePeriod': false,
        'isTrial': true,
        'hasUsedTrial': true,
        'plan': 'premium_monthly',
        'expiresAt': json['expiresAt'],
        'graceExpiresAt': null,
        'daysRemaining': 7,
      }),
    );
    return res.unwrap();
  }

  @override
  Future<SubscriptionEntity> getSubscriptionStatus() async {
    final res = await api.get<SubscriptionEntity>(
      ApiRoutes.subscriptionStatus,
      fromJsonT: (json) => _parseSubscriptionStatus(json),
    );
    return res.unwrap();
  }

  @override
  Future<List<PaymentEntity>> getPaymentHistory() async {
    final res = await api.get<List<PaymentEntity>>(
      ApiRoutes.paymentHistory,
      fromJsonT: (json) {
        final list = json as List<dynamic>;
        return list.map((e) => _parsePayment(e)).toList();
      },
    );
    return res.unwrap();
  }

  SubscriptionEntity _parseSubscriptionStatus(dynamic json) {
    final map = json as Map<String, dynamic>;
    return SubscriptionEntity(
      isPremium: map['isPremium'] as bool? ?? false,
      isGracePeriod: map['isGracePeriod'] as bool? ?? false,
      isTrial: map['isTrial'] as bool? ?? false,
      hasUsedTrial: map['hasUsedTrial'] as bool? ?? false,
      plan: map['plan'] as String?,
      expiresAt: map['expiresAt'] != null
          ? DateTime.parse(map['expiresAt'] as String)
          : null,
      graceExpiresAt: map['graceExpiresAt'] != null
          ? DateTime.parse(map['graceExpiresAt'] as String)
          : null,
      daysRemaining: map['daysRemaining'] as int? ?? 0,
    );
  }

  PaymentEntity _parsePayment(dynamic json) {
    final map = json as Map<String, dynamic>;
    return PaymentEntity(
      id: map['id'] as int,
      orderCode: int.parse(map['orderCode'].toString()),
      amount: map['amount'] as int,
      status: map['status'] as String,
      provider: map['provider'] as String? ?? 'payos',
      providerTransactionId: map['providerTransactionId'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      paidAt: map['paidAt'] != null
          ? DateTime.parse(map['paidAt'] as String)
          : null,
    );
  }

  @override
  Future<bool> verifyPayment(int orderCode) async {
    final res = await api.get<Map<String, dynamic>>(
      ApiRoutes.paymentVerify(orderCode),
      fromJsonT: (json) => json as Map<String, dynamic>,
    );
    final data = res.unwrap();
    return data['verified'] as bool? ?? false;
  }
}
