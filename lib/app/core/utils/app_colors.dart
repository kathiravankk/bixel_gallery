import 'package:flutter/material.dart';

class AppColors {
  // Brand & Primary
  static const Color primaryColor = Color(0xFF01CDCD);
  static const Color primaryDark = Color(0xFF009E9E);
  static const Color primaryLight = Color(0xFF5FF5F5);

  // Backgrounds & Surfaces (Dark Mode)
  static const Color darkScaffold = Color(0xFF0F1416);
  static const Color darkCard = Color(0xFF182023);
  static const Color darkSurface = Color(0xFF1E282C);
  static const Color darkField = Color(0xFF232E33);

  // Backgrounds & Surfaces (Light Mode)
  static const Color lightScaffold = Color(0xFFF8FAFC);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF1F5F9);
  static const Color lightField = Color(0xFFE2E8F0);

  // Borders & Dividers
  static const Color darkBorder = Color.fromRGBO(255, 255, 255, 0.08);
  static const Color lightBorder = Color.fromRGBO(0, 0, 0, 0.08);
  static const Color dividerColor = Color.fromRGBO(255, 255, 255, 0.12);

  // Toast & Status Colors (Matching Internsharks)
  static const Color sucBgColor = Color.fromRGBO(220, 252, 231, 1);
  static const Color sucTextColor = Color.fromRGBO(22, 163, 74, 1);
  static const Color failBgColor = Color.fromRGBO(254, 226, 226, 1);
  static const Color failTextColor = Color.fromRGBO(220, 38, 38, 1);

  // Accent & Functional Colors
  static const Color favoriteRed = Color(0xFFFF4757);
  static const Color starYellow = Color(0xFFFFB800);
  static const Color infoBlue = Color(0xFF3B82F6);

  // Neutrals
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;
  static const Color transparentColor = Colors.transparent;
  static const Color greyColor = Color(0xFF94A3B8);
  static const Color greyLight = Color(0xFFCBD5E1);
  static const Color greyDark = Color(0xFF64748B);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF01CDCD), Color(0xFF009E9E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardOverlayGradient = LinearGradient(
    colors: [Colors.transparent, Color.fromRGBO(0, 0, 0, 0.85)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
