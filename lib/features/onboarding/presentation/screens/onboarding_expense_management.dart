import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/image_string.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/features/onboarding/presentation/widgets/onboarding_template.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingExpenseManagementScreen extends StatelessWidget {
  const OnboardingExpenseManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingTemplate(
      imagePath: AppImages.expenseManagement,
      title: AppTexts.onboardingExpenseTitle,
      highlightText: AppTexts.onboardingExpenseHighlight,
      description: AppTexts.onboardingExpenseDescription,
      indicatorIndex: 0,
      totalIndicators: 2,
      onNext: () => Get.toNamed('/onboarding_financial_freedom'),
      onSkip: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('hasSeenOnboarding', true);
        Get.toNamed('/select_method_login');
      },
    );
  }
}
