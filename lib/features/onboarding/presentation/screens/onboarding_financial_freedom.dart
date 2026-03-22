import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/constants/image_string.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:money_care/features/onboarding/presentation/widgets/onboarding_template.dart';

class OnboardingFinancialFreedomScreen extends StatelessWidget {
  const OnboardingFinancialFreedomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingController controller = Get.find<OnboardingController>();

    return OnboardingTemplate(
      imagePath: AppImages.financialFreedom,
      title: AppTexts.onboardingFinancialTitle,
      highlightText: AppTexts.onboardingFinancialHighlight,
      description: AppTexts.onboardingFinancialDescription,
      indicatorIndex: 1,
      totalIndicators: 2,
      onSkip: () {
        controller.completeOnboarding(nextRoute: RoutePath.loginOption);
      },
      onNext: () {
        controller.completeOnboarding(nextRoute: RoutePath.loginOption);
      },
    );
  }
}
