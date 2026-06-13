import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class CoupleSettlementMemberBalance {
  final int userId;
  final String userName;
  final double netAmount;

  CoupleSettlementMemberBalance({
    required this.userId,
    required this.userName,
    required this.netAmount,
  });

  factory CoupleSettlementMemberBalance.fromJson(Map<String, dynamic> json) {
    return CoupleSettlementMemberBalance(
      userId: json['userId'] ?? 0,
      userName: json['userName'] ?? '',
      netAmount: double.parse(json['netAmount']?.toString() ?? '0'),
    );
  }
}

class CoupleWhoOwesWhom {
  final int debtorId;
  final String debtorName;
  final int creditorId;
  final String creditorName;
  final double amount;

  CoupleWhoOwesWhom({
    required this.debtorId,
    required this.debtorName,
    required this.creditorId,
    required this.creditorName,
    required this.amount,
  });

  factory CoupleWhoOwesWhom.fromJson(Map<String, dynamic> json) {
    return CoupleWhoOwesWhom(
      debtorId: json['debtorId'] ?? 0,
      debtorName: json['debtorName'] ?? '',
      creditorId: json['creditorId'] ?? 0,
      creditorName: json['creditorName'] ?? '',
      amount: double.parse(json['amount']?.toString() ?? '0'),
    );
  }
}

class CoupleSettlementSummaryEntity {
  final List<CoupleSettlementMemberBalance> netBalance;
  final CoupleWhoOwesWhom? whoOwesWhom;
  final List<TransactionEntity> unsettledTransactions;

  CoupleSettlementSummaryEntity({
    required this.netBalance,
    this.whoOwesWhom,
    required this.unsettledTransactions,
  });

  factory CoupleSettlementSummaryEntity.fromJson(Map<String, dynamic> json) {
    final balanceList = (json['netBalance'] as List<dynamic>?)
            ?.map((x) => CoupleSettlementMemberBalance.fromJson(x))
            .toList() ??
        [];
    final whoOwes = json['whoOwesWhom'] != null
        ? CoupleWhoOwesWhom.fromJson(json['whoOwesWhom'])
        : null;
    final txList = (json['unsettledTransactions'] as List<dynamic>?)
            ?.map((x) => TransactionEntity.fromMap(Map<String, dynamic>.from(x)))
            .toList() ??
        [];

    return CoupleSettlementSummaryEntity(
      netBalance: balanceList,
      whoOwesWhom: whoOwes,
      unsettledTransactions: txList,
    );
  }
}
