class ChatWalletEntity {
  final int id;
  final String name;
  final double balance;
  final String type;

  const ChatWalletEntity({
    required this.id,
    required this.name,
    required this.balance,
    required this.type,
  });

  factory ChatWalletEntity.fromMap(Map<String, dynamic> map) {
    return ChatWalletEntity(
      id: (map['id'] as num?)?.toInt() ?? 0,
      name: map['name']?.toString() ?? '',
      balance: (map['balance'] as num?)?.toDouble() ?? 0,
      type: map['type']?.toString() ?? 'general',
    );
  }
}
