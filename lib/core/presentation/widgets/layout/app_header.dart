import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final double height;
  final bool showBackButton;
  final VoidCallback? onBackTap;
  final Widget? child;
  final Color? backgroundColor;

  const AppHeader({
    super.key,
    required this.title,
    this.height = 195,
    this.showBackButton = false,
    this.onBackTap,
    this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isWeb = kIsWeb;
    final Color actualBackgroundColor = backgroundColor ?? (isWeb ? Colors.white : AppColors.primary);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: actualBackgroundColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  if (showBackButton)
                    GestureDetector(
                      onTap: onBackTap ?? () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: isWeb ? AppColors.text2 : Colors.white,
                        size: 22,
                      ),
                    )
                  else
                    const SizedBox(width: 22),
                  Expanded(
                    child: Center(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: isWeb ? AppColors.text1 : Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            if (child != null) Expanded(child: child!),
          ],
        ),
      ),
    );
  }
}
