import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';

class OnboardingTemplate extends StatelessWidget {
  final String imagePath;
  final String title;
  final String highlightText;
  final String description;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final int indicatorIndex;
  final int totalIndicators;

  const OnboardingTemplate({
    super.key,
    required this.imagePath,
    required this.title,
    required this.highlightText,
    required this.description,
    required this.onNext,
    required this.onSkip,
    this.indicatorIndex = 0,
    this.totalIndicators = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: onSkip,
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: AppColors.text1, fontSize: 16),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Center(
                child: Image.asset(
                  imagePath,
                  height: 220,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 40),

              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text1,
                  ),
                  children: [
                    TextSpan(text: '$title '),
                    TextSpan(
                      text: highlightText,
                      style: const TextStyle(color: AppColors.primary),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.text1,
                  height: 1.4,
                ),
              ),

              const Spacer(),

              Row(
                children: List.generate(totalIndicators, (index) {
                  final isActive = index == indicatorIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(right: 6),
                    width: isActive ? 25 : 10,
                    height: 5,
                    decoration: BoxDecoration(
                      color:
                          isActive ? AppColors.primary : AppColors.text1,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: onNext,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.linearGradient
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
