import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:money_care/core/constants/sizes.dart';

class RoundedIcon extends StatelessWidget {
  const RoundedIcon({
    super.key,
    this.width,
    this.height,
    this.border,
    this.backgroundColor = Colors.white,
    this.fit = BoxFit.contain,
    this.padding,
    this.onPressed,
    this.borderRadius = AppSizes.md,
    this.icon,
    this.iconPath,
    required this.applyIconRadius,
    this.size,
    this.color,
  });

  final double? width, height, size;
  final IconData? icon;
  final String? iconPath;
  final bool applyIconRadius;
  final BoxBorder? border;
  final Color? backgroundColor;
  final Color? color;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: border,
          color: backgroundColor,
        ),
        child:
            iconPath != null
                ? SvgPicture.asset(
                  iconPath!,
                  width: width,
                  height: height,
                  color: color,
                )
                : Icon(icon, color: color, size: size),
      ),
    );
  }
}
