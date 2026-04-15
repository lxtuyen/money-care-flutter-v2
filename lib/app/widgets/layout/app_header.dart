import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final double height;
  final bool showBackButton;
  final VoidCallback? onBackTap;
  final Widget? child;
  final Color? backgroundColor;
  final List<Widget>? actions;

  const AppHeader({
    super.key,
    required this.title,
    this.height = 195,
    this.showBackButton = false,
    this.onBackTap,
    this.child,
    this.backgroundColor,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final hasCustomBackground = backgroundColor != null;
    final iconAndTextColor =
        hasCustomBackground ? _foregroundColorFor(backgroundColor!) : Colors.white;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: hasCustomBackground ? backgroundColor : null,
        gradient: hasCustomBackground
            ? null
            : const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF79CBFF),
                AppColors.primary,
                AppColors.secondaryNavyBlue,
              ],
              stops: [0.0, 0.52, 1.0],
            ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.18),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        child: Stack(
          children: [
            if (!hasCustomBackground) ...[
              Positioned(
                top: -42,
                right: -28,
                child: Container(
                  width: 132,
                  height: 132,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                left: -36,
                bottom: -54,
                child: Container(
                  width: 144,
                  height: 144,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Row(
                      children: [
                        if (showBackButton)
                          GestureDetector(
                            onTap: onBackTap ?? () => Navigator.of(context).pop(),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(
                                  hasCustomBackground ? 0.12 : 0.16,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.14),
                                ),
                              ),
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                color: iconAndTextColor,
                                size: 18,
                              ),
                            ),
                          )
                        else
                          const SizedBox(width: 36),
                        Expanded(
                          child: Center(
                            child: Text(
                              title,
                              style: TextStyle(
                                color: iconAndTextColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),
                        if (actions != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: actions!,
                          )
                        else
                          const SizedBox(width: 36),
                      ],
                    ),
                  ),
                  if (child != null) Expanded(child: child!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _foregroundColorFor(Color color) {
    return ThemeData.estimateBrightnessForColor(color) == Brightness.dark
        ? Colors.white
        : AppColors.text1;
  }
}
