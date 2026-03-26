import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/image_string.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/core/presentation/widgets/button/primary_button.dart';
import 'package:money_care/features/onboarding/presentation/controllers/onboarding_controller.dart';

class OnboardingSavingRuleScreen extends StatelessWidget {
  const OnboardingSavingRuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingController controller = Get.find<OnboardingController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                Expanded(
                  flex: 6,
                  child: Image.asset(AppImages.savingRule, fit: BoxFit.contain),
                ),

                const SizedBox(height: 32),

                Text(
                  AppTexts.savingRuleDescription1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.text1,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  AppTexts.savingRuleDescription2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.text1,
                    height: 1.4,
                  ),
                ),
                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    label: AppTexts.continueButton,
                    onPressed:
                        () => controller.completeOnboarding(
                          nextRoute: RoutePath.selectSavingFund,
                        ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
