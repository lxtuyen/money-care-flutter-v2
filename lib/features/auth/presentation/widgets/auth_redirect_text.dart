import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';

class AuthRedirectText extends StatelessWidget {
  final String leadingText;
  final String actionText;
  final VoidCallback onTap;
  final double fontSize;
  final Color leadingColor;
  final Color actionColor;

  const AuthRedirectText({
    super.key,
    required this.leadingText,
    required this.actionText,
    required this.onTap,
    this.fontSize = 14,
    this.leadingColor = AppColors.text3,
    this.actionColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: leadingText,
          style: TextStyle(color: leadingColor, fontSize: fontSize),
          children: [
            TextSpan(
              text: actionText,
              style: TextStyle(
                color: actionColor,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
              recognizer: TapGestureRecognizer()..onTap = onTap,
            ),
          ],
        ),
      ),
    );
  }
}
