import 'package:money_care/features/recommendation/data/models/place_model.dart';

class PlaceCheckinModel {
  final int id;
  final int? transactionId;
  final int amount;
  final int rating;
  final bool wantToReturn;
  final String? note;
  final List<String> tags;
  final DateTime? visitedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final PlaceModel place;

  const PlaceCheckinModel({
    required this.id,
    required this.transactionId,
    required this.amount,
    required this.rating,
    required this.wantToReturn,
    required this.note,
    required this.tags,
    required this.visitedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.place,
  });

  factory PlaceCheckinModel.fromJson(Map<String, dynamic> json) {
    return PlaceCheckinModel(
      id: (json['id'] as num).toInt(),
      transactionId: (json['transactionId'] as num?)?.toInt(),
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toInt() ?? 5,
      wantToReturn: json['wantToReturn'] == true,
      note: json['note']?.toString(),
      tags: List<String>.from(json['tags'] ?? []),
      visitedAt: json['visitedAt'] == null
          ? null
          : DateTime.tryParse(json['visitedAt'].toString()),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.tryParse(json['createdAt'].toString()),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.tryParse(json['updatedAt'].toString()),
      place: PlaceModel.fromSearchJson(
        Map<String, dynamic>.from(json['place'] as Map),
      ),
    );
  }
}
