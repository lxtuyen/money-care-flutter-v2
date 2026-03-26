import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/image_string.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/core/presentation/widgets/button/primary_button.dart';

class OnboardingWelcomeScreen extends StatelessWidget {
  const OnboardingWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),

            Expanded(
              flex: 3,
              child: Image.asset(AppImages.welcome, fit: BoxFit.contain),
            ),

            const SizedBox(height: 32),
            Expanded(
              flex: 2,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 680),
                    child: Column(
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text1,
                            ),
                            children: [
                              TextSpan(text: AppTexts.welcomeTitle),
                              TextSpan(
                                text: AppTexts.welcomeTileHighlight,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Text(
                          AppTexts.welcomeDescription,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.text1,
                            height: 1.4,
                          ),
                        ),

                        const Spacer(),

                        SizedBox(
                          width: double.infinity,
                          child: PrimaryButton(
                            label: AppTexts.buttonText,
                            onPressed:
                                () =>
                                    Get.toNamed(RoutePath.onboardingSavingRule),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
