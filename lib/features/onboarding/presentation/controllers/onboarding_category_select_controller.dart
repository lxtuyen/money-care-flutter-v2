import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/features/onboarding/onboarding_data.dart';
import 'package:money_care/features/transaction/domain/entities/category_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';

class OnboardingCategorySelectController extends GetxController {
  final RxList<SuggestedCategory> expenseCategories =
      List<SuggestedCategory>.from(suggestedExpenseCategories).obs;
  final RxList<SuggestedCategory> incomeCategories =
      List<SuggestedCategory>.from(suggestedIncomeCategories).obs;

  final RxList<String> selectedExpenseNames = <String>[].obs;
  final RxList<String> selectedIncomeNames = <String>[].obs;

  int get selectedExpenseCount => selectedExpenseNames.length;
  int get selectedIncomeCount => selectedIncomeNames.length;
  bool get isValid => selectedExpenseCount >= 3 && selectedIncomeCount >= 1;

  void toggleCategory(String name, bool isExpense) {
    final list = isExpense ? selectedExpenseNames : selectedIncomeNames;
    if (list.contains(name)) {
      list.remove(name);
    } else {
      list.add(name);
    }
  }

  void addCustomCategory(String name, String emoji, String type) {
    final newCat = SuggestedCategory(name, emoji, type == 'expense');
    if (type == 'expense') {
      expenseCategories.add(newCat);
      if (!selectedExpenseNames.contains(name)) selectedExpenseNames.add(name);
    } else {
      incomeCategories.add(newCat);
      if (!selectedIncomeNames.contains(name)) selectedIncomeNames.add(name);
    }
  }

  void onContinue() {
    if (!isValid) return;

    final userCategoryController = Get.find<UserCategoryController>();

    final selected = [
      ...expenseCategories
          .where((c) => selectedExpenseNames.contains(c.name))
          .map(
            (c) => CategoryEntity(
              name: c.name,
              icon: c.emoji,
              percentage: 0,
              type: 'expense',
              isEssential: c.isEssential,
            ),
          ),
      ...incomeCategories
          .where((c) => selectedIncomeNames.contains(c.name))
          .map(
            (c) => CategoryEntity(
              name: c.name,
              icon: c.emoji,
              percentage: 0,
              type: 'income',
              isEssential: c.isEssential,
            ),
          ),
    ];

    const uncategorizedName = 'Chưa phân loại';
    if (!selected.any((c) => c.name == uncategorizedName)) {
      selected.add(
        const CategoryEntity(
          name: uncategorizedName,
          icon: '❓',
          percentage: 0,
          type: 'others',
          isEssential: true,
        ),
      );
    }

    // Chờ quá trình lưu danh mục hoàn tất thành công
    userCategoryController.saveCategories(selected).then((success) {
      if (!success) {
        AppHelperFunction.showErrorSnackBar(
          'Lưu danh mục thất bại. Vui lòng thử lại.',
        );
        return;
      }

      // Đánh dấu onboarding đã hoàn thành cho user này sau khi đã lưu xong
      final appController = Get.find<AppController>();
      int? userId = appController.userId.value;

      // Fallback nếu appController chưa kịp sync
      if (userId == null) {
        try {
          final authController = Get.find<AuthController>();
          userId = authController.user.value?.id;
          if (userId != null) {
            appController.setUserId(userId);
            print(
              'OnboardingController: Sync userId to AppController: $userId',
            );
          }
        } catch (_) {}
      }

      print('OnboardingController: Finishing onboarding for userId: $userId');
      if (userId != null) {
        LocalStorage().setOnboardingDone(userId).then((_) {
          Get.offAllNamed(RoutePath.main);
        });
      } else {
        print(
          'OnboardingController Error: userId is still null, cannot save onboarding status!',
        );
        Get.offAllNamed(RoutePath.main);
      }
    });
  }

  void onSkip() {
    final appController = Get.find<AppController>();
    int? userId = appController.userId.value;

    if (userId == null) {
      try {
        final authController = Get.find<AuthController>();
        userId = authController.user.value?.id;
      } catch (_) {}
    }

    if (userId != null) {
      LocalStorage().setOnboardingDone(userId);
    }
    Get.offAllNamed(RoutePath.main);
  }
}
