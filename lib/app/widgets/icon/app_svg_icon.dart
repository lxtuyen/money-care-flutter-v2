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

    if (iconName != null && _isEmoji(iconName!)) {
      return SizedBox(
        width: iconWidth,
        height: iconHeight,
        child: Center(
          child: Text(
            iconName!,
            style: TextStyle(
              fontSize: (size ?? width ?? 20) * 0.9,
              fontFamily: 'Apple Color Emoji',
            ),
          ),
        ),
      );
    }

    final resolvedPath =
        assetPath ??
        (iconName != null ? AppAssets.iconSvgPath(iconName!) : null);

    if (resolvedPath == null) return const SizedBox.shrink();

    return SvgPicture.asset(
      resolvedPath,
      width: iconWidth,
      height: iconHeight,
      color: color,
      fit: fit,
    );
  }

  bool _isEmoji(String text) {
    if (text.isEmpty) return false;

    if (text.contains('.') || text.contains('/')) return false;

    for (var rune in text.runes) {
      if (rune > 128) return true;
    }

    final alphanumeric = RegExp(r'^[a-zA-Z0-9_\-]+$');
    if (alphanumeric.hasMatch(text)) return false;

    return true;
  }
}
