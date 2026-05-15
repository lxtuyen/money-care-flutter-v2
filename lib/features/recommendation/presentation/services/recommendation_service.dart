import 'package:geolocator/geolocator.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/recommendation/data/models/place_model.dart';
import 'package:get/get.dart';

class RecommendationService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<List<PlaceModel>> getNearbyRecommendations({
    int? categoryId,
    double radius = 1000,
    String? maxPrice,
    int? budgetMax,
    List<String>? keywords,
  }) async {
    try {
      // 1. Check and request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return [];
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return [];
      }

      // 2. Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 3. Call backend API
      final response = await _apiClient.post('/recommendations/nearby', body: {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'categoryId': categoryId,
        'radius': radius,
        'maxPrice': maxPrice,
        'budgetMax': budgetMax,
        'keywords': keywords,
      });

      if (response.success && response.data != null) {
        final List<dynamic> data = response.data;
        return data.map((json) => PlaceModel.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error getting recommendations: $e');
      return [];
    }
  }
}
