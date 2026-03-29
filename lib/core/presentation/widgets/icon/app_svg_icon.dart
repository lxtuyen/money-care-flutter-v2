import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:money_care/core/constants/app_assets.dart';

class AppSvgIcon extends StatelessWidget {
  const AppSvgIcon({
    super.key,
    this.assetPath,
    this.iconName,
    this.size,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
  }) : assert(
         assetPath != null || iconName != null,
         'Provide either assetPath or iconName.',
       );

  final String? assetPath;
  final String? iconName;
  final double? size;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final iconWidth = width ?? size;
    final iconHeight = height ?? size;
    final resolvedPath = assetPath ?? AppAssets.iconSvgPath(iconName!);

    return SvgPicture.asset(
      resolvedPath,
      width: iconWidth,
      height: iconHeight,
      color: color,
      fit: fit,
    );
  }
}
