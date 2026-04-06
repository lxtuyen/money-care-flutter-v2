import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/controllers/app_controller.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/features/onboarding/onboarding_data.dart';
import 'package:money_care/features/transaction/domain/entities/category_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';

class OnboardingCategorySelectController extends GetxController {
  final RxList<SuggestedCategory> expenseCategories =
      List.from(suggestedExpenseCategories).obs;
  final RxList<SuggestedCategory> incomeCategories =
      List.from(suggestedIncomeCategories).obs;

  final RxSet<String> selectedExpenseNames = <String>{}.obs;
  final RxSet<String> selectedIncomeNames = <String>{}.obs;

  int get selectedExpenseCount => selectedExpenseNames.length;
  int get selectedIncomeCount => selectedIncomeNames.length;
  bool get isValid => selectedExpenseCount >= 3 && selectedIncomeCount >= 1;

  void toggleCategory(String name, bool isExpense) {
    final set = isExpense ? selectedExpenseNames : selectedIncomeNames;
    if (set.contains(name)) {
      set.remove(name);
    } else {
      set.add(name);
    }
  }

  void addCustomCategory(String name, String emoji, String type) {
    final newCat = SuggestedCategory(name, emoji, type == 'expense');
    if (type == 'expense') {
      expenseCategories.add(newCat);
      selectedExpenseNames.add(name);
    } else {
      incomeCategories.add(newCat);
      selectedIncomeNames.add(name);
    }
  }

  void onContinue() {
    if (!isValid) return;

    final userCategoryController = Get.find<UserCategoryController>();

    final selected = [
      ...expenseCategories
          .where((c) => selectedExpenseNames.contains(c.name))
          .map((c) => CategoryEntity(
              name: c.name,
              icon: c.emoji,
              percentage: 0,
              type: 'expense',
              isEssential: c.isEssential)),
      ...incomeCategories
          .where((c) => selectedIncomeNames.contains(c.name))
          .map((c) => CategoryEntity(
              name: c.name,
              icon: c.emoji,
              percentage: 0,
              type: 'income',
              isEssential: c.isEssential)),
    ];

    const uncategorizedName = 'Chưa phân loại';
    if (!selected.any((c) => c.name == uncategorizedName)) {
      selected.add(const CategoryEntity(
        name: uncategorizedName,
        icon: '❓',
        percentage: 0,
        type: 'others',
        isEssential: true,
      ));
    }

    userCategoryController.saveCategories(selected);

    // Đánh dấu onboarding đã hoàn thành cho user này
    final appController = Get.find<AppController>();
    final userId = appController.userId.value;
    if (userId != null) {
      LocalStorage().setOnboardingDone(userId);
    }

    Get.offAllNamed(RoutePath.main);
  }

  void onSkip() {
    // Bỏ qua onboarding - cũng đánh dấu là đã xem để không hiện lại
    final appController = Get.find<AppController>();
    final userId = appController.userId.value;
    if (userId != null) {
      LocalStorage().setOnboardingDone(userId);
    }
    Get.offAllNamed(RoutePath.main);
  }
}
