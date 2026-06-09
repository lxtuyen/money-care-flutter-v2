import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Widget? icon;
  final double? height;
  final double? width;
  final double? fontSize;
  final double? borderRadius;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? textColor;
  final BorderSide? side;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.height,
    this.width,
    this.fontSize,
    this.borderRadius,
    this.elevation,
    this.padding,
    this.backgroundColor,
    this.textColor,
    this.side,
  });

  @override
  Widget build(BuildContext context) {
    final canPress = isEnabled && !isLoading;
    final double buttonHeight = height ?? 56;
    final double btnBorderRadius = borderRadius ?? 12;
    final double btnElevation = elevation ?? (canPress ? 4 : 0);

    final Widget child = isLoading
        ? SizedBox(
            height: buttonHeight * 0.43,
            width: buttonHeight * 0.43,
            child: const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
        : Text(
            label,
            style: TextStyle(
              fontSize: fontSize ?? 18,
              fontWeight: FontWeight.bold,
              color: textColor ?? (canPress ? Colors.white : Colors.grey[600]),
            ),
          );

    final buttonStyle = ElevatedButton.styleFrom(
      minimumSize: width != null ? Size(width!, buttonHeight) : Size.fromHeight(buttonHeight),
      padding: padding,
      backgroundColor: backgroundColor ?? (canPress ? AppColors.primary : Colors.grey[400]),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(btnBorderRadius),
        side: side ?? BorderSide.none,
      ),
      elevation: btnElevation,
    );

    if (icon != null && !isLoading) {
      return ElevatedButton.icon(
        onPressed: canPress ? onPressed : null,
        style: buttonStyle,
        icon: icon!,
        label: child,
      );
    }

    return ElevatedButton(
      onPressed: canPress ? onPressed : null,
      style: buttonStyle,
      child: child,
    );
  }
}
