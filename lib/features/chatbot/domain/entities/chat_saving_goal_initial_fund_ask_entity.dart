import 'package:money_care/features/chatbot/domain/entities/chat_wallet_entity.dart';

class ChatSavingGoalInitialFundAskEntity {
  final String name;
  final double target;
  final double totalBalance;
  final int requestedMonths;
  final List<ChatWalletEntity> wallets;
  final int suggestedWalletId;
  final bool isFinalized;

  const ChatSavingGoalInitialFundAskEntity({
    required this.name,
    required this.target,
    required this.totalBalance,
    required this.requestedMonths,
    required this.wallets,
    required this.suggestedWalletId,
    required this.isFinalized,
  });

  factory ChatSavingGoalInitialFundAskEntity.fromMap(Map<String, dynamic> map) {
    final rawWallets = map['wallets'] as List? ?? [];
    final wallets = rawWallets
        .map((w) => ChatWalletEntity.fromMap(Map<String, dynamic>.from(w)))
        .toList();

    return ChatSavingGoalInitialFundAskEntity(
      name: map['name']?.toString() ?? 'Mục tiêu tiết kiệm',
      target: (map['target'] as num?)?.toDouble() ?? 0,
      totalBalance: (map['totalBalance'] as num?)?.toDouble() ?? 0,
      requestedMonths: (map['requestedMonths'] as num?)?.toInt() ?? 0,
      wallets: wallets,
      suggestedWalletId: (map['suggestedWalletId'] as num?)?.toInt() ?? 0,
      isFinalized: map['isFinalized'] == true,
    );
  }
}
