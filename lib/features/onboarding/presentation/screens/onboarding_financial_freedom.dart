import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/image_string.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/features/onboarding/presentation/widgets/onboarding_template.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingFinancialFreedomScreen extends StatelessWidget {
  const OnboardingFinancialFreedomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingTemplate(
      imagePath: AppImages.financialFreedom,
      title: AppTexts.onboardingFinancialTitle,
      highlightText: AppTexts.onboardingFinancialHighlight,
      description: AppTexts.onboardingFinancialDescription,
      indicatorIndex: 1,
      totalIndicators: 2,
      onSkip: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('hasSeenOnboarding', true);
        Get.toNamed('/select_method_login');
      },
      onNext: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('hasSeenOnboarding', true);
        Get.toNamed('/select_method_login');
      },
    );
  }
}
