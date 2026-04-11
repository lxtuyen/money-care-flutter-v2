import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/sizes.dart';

class CircularIcon extends StatelessWidget {
  const CircularIcon({
    super.key,
    this.height,
    this.width,
    this.size = AppSizes.lg,
    this.onTap,
    this.icon,
    this.iconPath,
    this.backgroundColor,
    this.color,
  });

  final double? height, width, size;
  final VoidCallback? onTap;
  final IconData? icon;
  final String? iconPath;
  final Color? backgroundColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: backgroundColor != null
              ? backgroundColor!
              : AppColors.white.withOpacity(0.9),
        ),
        child: iconPath != null
                ? SvgPicture.asset(
                    iconPath!,
                    width: width,
                    height: height,
                    color: color,
                  )
                : Icon(
                    icon,
                    color: color,
                    size: size,
                  )),
    );
  }
}
