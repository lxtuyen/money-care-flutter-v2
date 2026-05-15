import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/recommendation/data/models/place_checkin_model.dart';
import 'package:money_care/features/recommendation/data/models/place_model.dart';

class ResolvedLocation {
  const ResolvedLocation({
    required this.label,
    required this.latitude,
    required this.longitude,
  });

  final String label;
  final double latitude;
  final double longitude;

  factory ResolvedLocation.fromJson(Map<String, dynamic> json) {
    return ResolvedLocation(
      label: json['label']?.toString() ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}

class PlaceCheckinService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<List<PlaceModel>> searchPlaces({
    required String query,
    double? latitude,
    double? longitude,
    double radius = 3000,
  }) async {
    final position = latitude == null || longitude == null
        ? await currentPosition()
        : null;
    final searchLatitude = latitude ?? position?.latitude;
    final searchLongitude = longitude ?? position?.longitude;
    if (searchLatitude == null || searchLongitude == null) return [];

    final response = await _apiClient.post<List<dynamic>>(
      '/places/search',
      body: {
        'query': query,
        'latitude': searchLatitude,
        'longitude': searchLongitude,
        'radius': radius,
      },
      fromJsonT: (json) => json as List<dynamic>,
    );

    if (!response.success) {
      throw Exception(
        response.message.isNotEmpty
            ? response.message
            : 'Khong the tim dia diem',
      );
    }
    if (response.data == null) return [];
    final data = response.data as List<dynamic>;
    return data
        .map((json) => PlaceModel.fromSearchJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<ResolvedLocation?> resolveLocation(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return null;

    final response = await _apiClient.post<ResolvedLocation?>(
      '/places/resolve-location',
      body: {'query': trimmed},
      fromJsonT: (json) => json == null
          ? null
          : ResolvedLocation.fromJson(json as Map<String, dynamic>),
    );

    return response.success ? response.data : null;
  }

  Future<bool> createCheckin({
    required int transactionId,
    required PlaceModel place,
    required int rating,
    required bool wantToReturn,
    String? note,
    List<String>? tags,
  }) async {
    final response = await _apiClient.post(
      '/place-checkins',
      body: {
        'transactionId': transactionId,
        if (place.placeId != null) 'placeId': place.placeId,
        'place': place.toCheckinPlacePayload(),
        'rating': rating,
        'wantToReturn': wantToReturn,
        'note': note,
        'tags': tags,
      },
    );
    return response.success;
  }

  Future<List<PlaceCheckinModel>> getMyCheckins() async {
    final response = await _apiClient.get<List<dynamic>>(
      '/place-checkins',
      fromJsonT: (json) => json as List<dynamic>,
    );

    if (!response.success) {
      throw Exception(
        response.message.isNotEmpty
            ? response.message
            : 'Khong the tai danh sach check-in',
      );
    }

    return (response.data ?? [])
        .map((json) => PlaceCheckinModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<PlaceCheckinModel> updateCheckin({
    required int id,
    required int rating,
    required bool wantToReturn,
    String? note,
  }) async {
    final response = await _apiClient.patch<PlaceCheckinModel>(
      '/place-checkins/$id',
      body: {'rating': rating, 'wantToReturn': wantToReturn, 'note': note},
      fromJsonT: (json) =>
          PlaceCheckinModel.fromJson(json as Map<String, dynamic>),
    );

    if (!response.success || response.data == null) {
      throw Exception(
        response.message.isNotEmpty
            ? response.message
            : 'Khong the cap nhat check-in',
      );
    }
    return response.data!;
  }

  Future<void> deleteCheckin(int id) async {
    final response = await _apiClient.delete<void>('/place-checkins/$id');
    if (!response.success) {
      throw Exception(
        response.message.isNotEmpty
            ? response.message
            : 'Khong the xoa check-in',
      );
    }
  }

  Future<Position?> currentPosition() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      ),
    );
  }
}
