import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/image_string.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingSavingRuleScreen extends StatelessWidget {
  const OnboardingSavingRuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  child: ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('hasSeenOnboarding', true);
                      Get.toNamed('/select_saving_fund');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: AppColors.primary,
                    ),
                    child: Text(
                      AppTexts.continueButton,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
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
