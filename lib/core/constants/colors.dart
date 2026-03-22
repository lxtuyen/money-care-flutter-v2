import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // App Basic Colors
  static const Color primary = Color(0xFF42A6ED);
  static const Color secondaryOrange = Color(0xFFFF7D39);
  static const Color secondaryNavyBlue = Color(0xFF1379C1);

  static const Gradient linearGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF71C4FF), Color(0xFF0966A7)],
  );

  // Neutral Text Colors
  static const Color text1 = Color(0xFF0F1314); // Bastille - đậm nhất
  static const Color text2 = Color(0xFF232829); // Ship Gray
  static const Color text3 = Color(0xFF515353); // Mortar
  static const Color text4 = Color(0xFF7A7777); // Mountain Mist
  static const Color text5 = Color(0xFFB0B0B0); // Spun Pearl
  static const Color white = Colors.white;

  // Background Colors
  static const Color backgroundPrimary = Color(
    0xFFEEF1F5,
  ); // Flash White – nền chính
  static const Color backgroundSecondary = Color(
    0xFFFBFBFB,
  );

  //Button Colors
  static const Color buttonPrimary = Color(0xFF4b68ff);
  static const Color buttonSecondary = Color(0xFF6C867D);
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  //Border Colors
  static const Color borderPrimary = Color(0xFFBEC2C3);
  static const Color borderSecondary = Color(0xFFE1E5E9);

  // Error and Validation Colors
  static const Color error = Color(0xFFFF3E40);
  static const Color success = Color(0xFF52D113);
  static const Color warning = Color(0xFFFFAA00);
  static const Color info = Color(0xFF0D8BFF);
  static const Color disabled = Color(0xFFD5D5D6);
}
