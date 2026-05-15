import 'package:flutter/material.dart';
import 'package:money_care/features/recommendation/data/models/place_model.dart';
import 'package:money_care/features/recommendation/presentation/widgets/recommendation_card.dart';

class RecommendationListBubble extends StatelessWidget {
  final Map<String, dynamic> metadata;

  const RecommendationListBubble({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    final List placeMaps = metadata['places'] as List? ?? [];
    final places = placeMaps
        .map((m) => PlaceModel.fromJson(m as Map<String, dynamic>))
        .toList();

    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 12, bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.blue),
                SizedBox(width: 4),
                Text(
                  'Gợi ý địa điểm gần bạn',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
              itemCount: places.length,
              itemBuilder: (context, index) {
                return RecommendationCard(place: places[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
