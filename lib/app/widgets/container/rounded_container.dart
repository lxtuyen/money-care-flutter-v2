import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/sizes.dart';

class RoundedContainer extends StatelessWidget {
  const RoundedContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.radius = AppSizes.cardRadiusLg,
    this.showBorder = false,
    this.backgroundColor,
    this.borderColor,
    this.padding,
    this.margin,
  });

  final Widget? child;
  final double? width;
  final double? height;
  final double radius;
  final bool showBorder;
  final Color? backgroundColor;
  final Color? borderColor;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            (Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF1E2630)
                : Colors.white),
        borderRadius: BorderRadius.circular(radius),
        border: showBorder
            ? Border.all(color: borderColor ?? AppColors.borderPrimary)
            : null,
      ),
      child: child,
    );
  }
}
