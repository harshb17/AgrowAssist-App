import 'package:flutter/material.dart';

class AppColors {
  // New color palette from https://coolors.co/palette/d8f3dc-b7e4c7-95d5b2-74c69d-52b788-40916c-2d6a4f-1b4332-081c15
  static const Color lightestGreen = Color(0xFFD8F3DC);
  static const Color lighterGreen = Color(0xFFB7E4C7);
  static const Color lightGreen = Color(0xFF95D5B2);
  static const Color mediumLightGreen = Color(0xFF74C69D);
  static const Color mediumGreen = Color(0xFF52B788);
  static const Color mediumDarkGreen = Color(0xFF40916C);
  static const Color darkGreen = Color(0xFF2D6A4F);
  static const Color darkerGreen = Color(0xFF1B4332);
  static const Color darkestGreen = Color(0xFF081C15);

  // Light theme colors
  static const Color primaryLight = mediumGreen;
  static const Color primaryVariantLight = mediumDarkGreen;
  static const Color secondaryLight = lightGreen;
  static const Color backgroundLight = Color(0xFFF3FAF5);
  static const Color surfaceLight = Colors.white;
  static const Color errorLight = Colors.red;
  static const Color onPrimaryLight = Colors.white;
  static const Color onSecondaryLight = darkGreen;
  static const Color onBackgroundLight = darkestGreen;
  static const Color onSurfaceLight = darkestGreen;
  static const Color onErrorLight = Colors.white;

  // Dark theme colors
  static const Color primaryDark = darkGreen;
  static const Color primaryVariantDark = darkerGreen;
  static const Color secondaryDark = mediumDarkGreen;
  static const Color backgroundDark = darkestGreen;
  static const Color surfaceDark = darkerGreen;
  static const Color errorDark = Colors.redAccent;
  static const Color onPrimaryDark = Colors.white;
  static const Color onSecondaryDark = Colors.white;
  static const Color onBackgroundDark = lightestGreen;
  static const Color onSurfaceDark = lightestGreen;
  static const Color onErrorDark = Colors.white;
}
