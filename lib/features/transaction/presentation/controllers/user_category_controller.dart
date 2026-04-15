import 'package:get/get.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/transaction/domain/entities/category_entity.dart';

/// Quản lý danh mục của user độc lập với quỹ tiết kiệm.
class UserCategoryController extends GetxController {
  final ApiClient apiClient;
  final AppController appController;

  UserCategoryController({
    required this.apiClient,
    required this.appController,
  });

  RxList<CategoryEntity> categories = <CategoryEntity>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final initialUserId = appController.userId.value;
    if (initialUserId != null && categories.isEmpty) {
      loadCategories(initialUserId);
    }

    ever(appController.userId, (id) {
      if (id != null) {
        loadCategories(id);
      } else {
        categories.clear();
      }
    });
  }

  Future<void> loadCategories(int userId) async {
    if (userId <= 0) return;
    isLoading.value = true;
    try {
      final res = await apiClient.get<List<dynamic>>(
        '${ApiRoutes.userCategories}/$userId',
        fromJsonT: (json) => json as List<dynamic>,
      );
      
      if (res.success && res.data != null) {
        final List<CategoryEntity> loaded = [];
        for (var e in res.data!) {
          try {
            if (e is Map<String, dynamic>) {
              loaded.add(_fromJson(e));
            } else {
              print('UserCategoryController: Skipping non-map item: $e');
            }
          } catch (err) {
            print('UserCategoryController: Error parsing category item: $err. Data: $e');
          }
        }
        categories.assignAll(loaded);
      } else if (!res.success) {
      }
    } catch (e, stack) {
      print('UserCategoryController: Catch error loading categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> saveCategories(List<CategoryEntity> cats) async {
    final userId = appController.userId.value;
    if (userId == null) {
      return false;
    }

    isLoading.value = true;
    try {
      final body = cats.map(_toJson).toList();
      final res = await apiClient.post<List<dynamic>>(
        '${ApiRoutes.userCategories}/$userId',
        bodyList: body,
        fromJsonT: (json) => json as List<dynamic>,
      );
      if (res.success && res.data != null) {
        final List<CategoryEntity> saved = [];
        for (var e in res.data!) {
          try {
            saved.add(_fromJson(e as Map<String, dynamic>));
          } catch (err) {
            print('UserCategoryController: Error parsing saved category: $err');
          }
        }
        categories.assignAll(saved);
        _refreshStatistics(userId);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addCategory(String name, String icon, String type, bool isEssential) async {
    final userId = appController.userId.value;
    if (userId == null) return false;

    isLoading.value = true;
    try {
      final body = {
        'name': name,
        'icon': icon,
        'type': type,
        'isEssential': isEssential,
      };
      
      final res = await apiClient.post<List<dynamic>>(
        '${ApiRoutes.userCategories}/$userId/single',
        body: body,
        fromJsonT: (json) => json as List<dynamic>,
      );
      
      if (res.success) {
        await loadCategories(userId);
        _refreshStatistics(userId);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateCategory(int id, String name, String icon, String? type, bool isEssential) async {
    final userId = appController.userId.value;
    if (userId == null) return false;

    isLoading.value = true;
    try {
      final body = {
        'name': name,
        'icon': icon,
        'type': type,
        'isEssential': isEssential,
      };
      
      final res = await apiClient.patch<Map<String, dynamic>>(
        '${ApiRoutes.categories}/$id',
        body: body,
        fromJsonT: (json) => json as Map<String, dynamic>,
      );
      
      if (res.success) {
        await loadCategories(userId);
        _refreshStatistics(userId);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteCategory(int id) async {
    final userId = appController.userId.value;
    if (userId == null) return false;

    isLoading.value = true;
    try {
      final res = await apiClient.delete<Map<String, dynamic>>(
        '${ApiRoutes.categories}/$id',
        fromJsonT: (json) => json as Map<String, dynamic>,
      );
      
      if (res.success) {
        await loadCategories(userId);
        _refreshStatistics(userId);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void _refreshStatistics(int userId) {
    if (Get.isRegistered<StatisticsController>()) {
      Get.find<StatisticsController>().refreshStatisticsData(userId);
    }
  }

  bool get hasCategories => categories.isNotEmpty;

  Map<String, dynamic> _toJson(CategoryEntity c) => {
        'name': c.name,
        'icon': c.icon,
        'percentage': c.percentage,
        'isEssential': c.isEssential,
        if (c.type != null) 'type': c.type,
      };

  CategoryEntity _fromJson(Map<String, dynamic> m) => CategoryEntity(
        id: m['id'] as int?,
        name: m['name'] as String,
        percentage: (m['percentage'] as num?)?.toInt() ?? 0,
        icon: m['icon'] as String? ?? 'search',
        isEssential: m['isEssential'] as bool? ?? true,
        type: m['type'] as String?,
      );
}
