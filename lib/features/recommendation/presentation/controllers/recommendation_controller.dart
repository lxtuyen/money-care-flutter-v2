import 'package:get/get.dart';
import 'package:money_care/features/recommendation/data/models/place_model.dart';
import 'package:money_care/features/recommendation/presentation/services/recommendation_service.dart';

class RecommendationController extends GetxController {
  final RecommendationService _service = Get.find<RecommendationService>();

  final RxList<PlaceModel> recommendations = <PlaceModel>[].obs;
  final RxBool isLoading = false.obs;
  DateTime? _lastFetch;
  int? _lastCategoryId;

  @override
  void onInit() {
    super.onInit();
    // Initially fetch some general recommendations or wait for specific trigger
  }

  Future<void> fetchNearby({int? categoryId, String? maxPrice, bool force = false}) async {
    if (!force && 
        recommendations.isNotEmpty && 
        _lastCategoryId == categoryId &&
        _lastFetch != null && 
        DateTime.now().difference(_lastFetch!).inMinutes < 10) {
      return;
    }

    isLoading.value = true;
    try {
      final result = await _service.getNearbyRecommendations(
        categoryId: categoryId,
        maxPrice: maxPrice,
      );
      recommendations.assignAll(result);
      _lastFetch = DateTime.now();
      _lastCategoryId = categoryId;
    } finally {
      isLoading.value = false;
    }
  }
}
