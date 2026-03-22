import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/constants/image_string.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:money_care/features/onboarding/presentation/widgets/onboarding_template.dart';

class OnboardingExpenseManagementScreen extends StatelessWidget {
  const OnboardingExpenseManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingController controller = Get.find<OnboardingController>();

    return OnboardingTemplate(
      imagePath: AppImages.expenseManagement,
      title: AppTexts.onboardingExpenseTitle,
      highlightText: AppTexts.onboardingExpenseHighlight,
      description: AppTexts.onboardingExpenseDescription,
      indicatorIndex: 0,
      totalIndicators: 2,
      onNext: () => Get.toNamed(RoutePath.onboardingFinancialFreedom),
      onSkip: () {
        controller.completeOnboarding(nextRoute: RoutePath.loginOption);
      },
    );
  }
}
