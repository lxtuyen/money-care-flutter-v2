import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF42A6ED);
  static const Color secondaryOrange = Color(0xFFFF7D39);
  static const Color secondaryNavyBlue = Color(0xFF1379C1);

  static const Gradient linearGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF71C4FF), Color(0xFF0966A7)],
  );

  static const Color text1 = Color(0xFF0F1314);
  static const Color text2 = Color(0xFF232829);
  static const Color text3 = Color(0xFF515353);
  static const Color text4 = Color(0xFF7A7777);
  static const Color text5 = Color(0xFFB0B0B0);
  static const Color white = Colors.white;

  static const Color backgroundPrimary = Color(
    0xFFEEF1F5,
  );
  static const Color backgroundSecondary = Color(
    0xFFFBFBFB,
  );

  static const Color buttonPrimary = Color(0xFF4b68ff);
  static const Color buttonSecondary = Color(0xFF6C867D);
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  static const Color borderPrimary = Color(0xFFBEC2C3);
  static const Color borderSecondary = Color(0xFFE1E5E9);

  static const Color error = Color(0xFFFF3E40);
  static const Color success = Color(0xFF52D113);
  static const Color warning = Color(0xFFFFAA00);
  static const Color info = Color(0xFF0D8BFF);
  static const Color disabled = Color(0xFFD5D5D6);
}
