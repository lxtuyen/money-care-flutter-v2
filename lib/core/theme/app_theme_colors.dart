import 'package:flutter/material.dart';

/// Semantic color tokens that adapt to light/dark theme.
/// Access via `AppThemeColors.of(context)`.
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color cardBackground;
  final Color surfaceBackground;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textMuted;
  final Color textHint;
  final Color borderPrimary;
  final Color borderSecondary;
  final Color iconBackground;
  final Color dialogBackground;

  const AppThemeColors({
    required this.cardBackground,
    required this.surfaceBackground,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textMuted,
    required this.textHint,
    required this.borderPrimary,
    required this.borderSecondary,
    required this.iconBackground,
    required this.dialogBackground,
  });

  static AppThemeColors of(BuildContext context) {
    return Theme.of(context).extension<AppThemeColors>()!;
  }

  static const light = AppThemeColors(
    cardBackground: Colors.white,
    surfaceBackground: Color(0xFFEEF1F5),
    textPrimary: Color(0xFF0F1314),
    textSecondary: Color(0xFF232829),
    textTertiary: Color(0xFF515353),
    textMuted: Color(0xFF7A7777),
    textHint: Color(0xFFB0B0B0),
    borderPrimary: Color(0xFFBEC2C3),
    borderSecondary: Color(0xFFE1E5E9),
    iconBackground: Color(0xFFF5FAFE),
    dialogBackground: Colors.white,
  );

  static const dark = AppThemeColors(
    cardBackground: Color(0xFF1E2630),
    surfaceBackground: Color(0xFF0F1418),
    textPrimary: Color(0xFFE8ECF0),
    textSecondary: Color(0xFFCDD3DA),
    textTertiary: Color(0xFFA0AAB4),
    textMuted: Color(0xFF7A8490),
    textHint: Color(0xFF556070),
    borderPrimary: Color(0xFF2C3640),
    borderSecondary: Color(0xFF232D38),
    iconBackground: Color(0xFF1A2430),
    dialogBackground: Color(0xFF1E2630),
  );

  @override
  AppThemeColors copyWith({
    Color? cardBackground,
    Color? surfaceBackground,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textMuted,
    Color? textHint,
    Color? borderPrimary,
    Color? borderSecondary,
    Color? iconBackground,
    Color? dialogBackground,
  }) {
    return AppThemeColors(
      cardBackground: cardBackground ?? this.cardBackground,
      surfaceBackground: surfaceBackground ?? this.surfaceBackground,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textMuted: textMuted ?? this.textMuted,
      textHint: textHint ?? this.textHint,
      borderPrimary: borderPrimary ?? this.borderPrimary,
      borderSecondary: borderSecondary ?? this.borderSecondary,
      iconBackground: iconBackground ?? this.iconBackground,
      dialogBackground: dialogBackground ?? this.dialogBackground,
    );
  }

  @override
  AppThemeColors lerp(
    covariant ThemeExtension<AppThemeColors>? other,
    double t,
  ) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors(
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      surfaceBackground: Color.lerp(
        surfaceBackground,
        other.surfaceBackground,
        t,
      )!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      borderPrimary: Color.lerp(borderPrimary, other.borderPrimary, t)!,
      borderSecondary: Color.lerp(borderSecondary, other.borderSecondary, t)!,
      iconBackground: Color.lerp(iconBackground, other.iconBackground, t)!,
      dialogBackground: Color.lerp(
        dialogBackground,
        other.dialogBackground,
        t,
      )!,
    );
  }
}
