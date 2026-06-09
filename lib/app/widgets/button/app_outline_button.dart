import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';

class AppOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isSelected;
  final Widget? child;
  final IconData? icon;
  final double? iconSize;
  final double? iconSpacing;
  final double? height;
  final Size? minimumSize;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? selectedColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final double borderWidth;
  final MaterialTapTargetSize? tapTargetSize;
  final TextOverflow? overflow;
  final int? maxLines;
  final ButtonStyle? style;

  const AppOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isSelected = false,
    this.child,
    this.icon,
    this.iconSize,
    this.iconSpacing,
    this.height,
    this.minimumSize,
    this.padding,
    this.borderRadius,
    this.fontSize,
    this.fontWeight,
    this.selectedColor,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.borderWidth = 1.2,
    this.tapTargetSize,
    this.overflow,
    this.maxLines,
    this.style,
  }) : assert(label != '' || child != null);

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final activeColor = selectedColor ?? AppColors.primary;
    final effectiveTextColor =
        textColor ?? (isSelected ? Colors.white : colors.textSecondary);
    final button = OutlinedButton(
      onPressed: onPressed,
      style:
          style ??
          OutlinedButton.styleFrom(
            padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
            backgroundColor: isSelected
                ? activeColor
                : (backgroundColor ?? colors.cardBackground),
            foregroundColor: effectiveTextColor,
            side: BorderSide(
              color: isSelected
                  ? activeColor
                  : (borderColor ?? colors.borderSecondary),
              width: borderWidth,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
            ),
            minimumSize: minimumSize,
            tapTargetSize: tapTargetSize,
          ),
      child: child ?? _buildContent(effectiveTextColor),
    );

    if (height == null) return button;

    return SizedBox(height: height, child: button);
  }

  Widget _buildContent(Color effectiveTextColor) {
    final text = Text(
      label,
      style: TextStyle(
        fontSize: fontSize ?? 11,
        fontWeight: fontWeight ?? FontWeight.w700,
        color: effectiveTextColor,
      ),
      overflow: overflow,
      maxLines: maxLines,
    );

    if (icon == null) return text;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: iconSize ?? 16, color: effectiveTextColor),
        SizedBox(width: iconSpacing ?? 6),
        Flexible(child: text),
      ],
    );
  }
}
