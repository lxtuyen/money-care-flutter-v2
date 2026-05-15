class PlaceModel {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double? rating;
  final String? priceLevel;
  final List<String> types;
  final String? photoReference;
  final int? placeId;
  final double? distance;
  final String? reason;
  final String? ratingSource;
  final Map<String, dynamic>? priceEstimate;
  final String provider;
  final String? providerPlaceId;

  PlaceModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.rating,
    this.priceLevel,
    required this.types,
    this.photoReference,
    this.placeId,
    this.distance,
    this.reason,
    this.ratingSource,
    this.priceEstimate,
    this.provider = 'goong',
    this.providerPlaceId,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id'],
      placeId: json['placeId'],
      name: json['displayName']?['text'] ?? 'Unknown',
      address: json['formattedAddress'] ?? '',
      latitude: json['location']?['latitude'] ?? 0.0,
      longitude: json['location']?['longitude'] ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble(),
      priceLevel: json['priceLevel'],
      types: List<String>.from(json['types'] ?? []),
      distance: (json['distance'] as num?)?.toDouble(),
      reason: json['reason'],
      ratingSource: json['ratingSource'],
      priceEstimate: json['priceEstimate'] is Map<String, dynamic>
          ? json['priceEstimate'] as Map<String, dynamic>
          : null,
      photoReference: (json['photos'] != null && json['photos'].isNotEmpty)
          ? json['photos'][0]['name']
          : null,
      provider: json['provider'] ?? 'goong',
      providerPlaceId: json['providerPlaceId']?.toString(),
    );
  }

  factory PlaceModel.fromSearchJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: (json['placeId'] ?? json['providerPlaceId'] ?? json['name'])
          .toString(),
      placeId: json['placeId'],
      name: json['name'] ?? 'Unknown',
      address: json['address'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      types: List<String>.from(json['categories'] ?? []),
      distance: (json['distance'] as num?)?.toDouble(),
      provider: json['provider'] ?? 'goong',
      providerPlaceId: json['providerPlaceId']?.toString(),
    );
  }

  factory PlaceModel.manual({
    required String name,
    required String address,
    required double latitude,
    required double longitude,
  }) {
    return PlaceModel(
      id: 'manual:$latitude,$longitude',
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      types: const [],
      provider: 'manual',
    );
  }

  Map<String, dynamic> toCheckinPlacePayload() {
    return {
      if (placeId != null) 'id': placeId,
      'provider': provider,
      if (provider == 'goong') 'providerPlaceId': providerPlaceId ?? id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'categories': types,
    };
  }

  String get priceLevelString {
    switch (priceLevel) {
      case 'PRICE_LEVEL_FREE':
        return 'Miễn phí';
      case 'PRICE_LEVEL_INEXPENSIVE':
        return '₫';
      case 'PRICE_LEVEL_MODERATE':
        return '₫₫';
      case 'PRICE_LEVEL_EXPENSIVE':
        return '₫₫₫';
      case 'PRICE_LEVEL_VERY_EXPENSIVE':
        return '₫₫₫₫';
      default:
        return '';
    }
  }
}
