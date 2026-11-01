import 'package:flutter/material.dart';

/// Canonical Makambako Yetu palette.
///
/// Kept in one place so the home, explore, saved, profile, and discovery
/// surfaces stay visually identical.
abstract final class MakambakoColors {
  static const Color forest = Color(0xFF145C45);
  static const Color green = Color(0xFF237A59);
  static const Color page = Color(0xFFF5F7F2);
  static const Color ink = Color(0xFF1D2B25);
  static const Color muted = Color(0xFF758179);
}

/// Builds the app-wide Material 3 theme from the palette above.
ThemeData buildMakambakoTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: MakambakoColors.page,
    colorScheme: ColorScheme.fromSeed(
      seedColor: MakambakoColors.green,
      primary: MakambakoColors.forest,
      surface: Colors.white,
    ),
    fontFamily: 'Roboto',
  );
}
