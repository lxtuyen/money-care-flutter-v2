import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final double titleFontSize;
  final double subtitleFontSize;
  final Color titleColor;
  final Color subtitleColor;
  final double topSpacing;
  final double spacing;
  final double subtitleHeight;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.titleFontSize = 30,
    this.subtitleFontSize = 15,
    this.titleColor = AppColors.text1,
    this.subtitleColor = AppColors.text3,
    this.topSpacing = 80,
    this.spacing = 10,
    this.subtitleHeight = 1.4,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: topSpacing),
        Text(
          title,
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),
        SizedBox(height: spacing),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: subtitleFontSize,
            color: subtitleColor,
            height: subtitleHeight,
          ),
        ),
      ],
    );
  }
}
