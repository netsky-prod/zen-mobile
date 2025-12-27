import 'package:flutter/material.dart';

class AppTheme {
  // Casa de Papel colors
  static const Color redPrimary = Color(0xFFB71C1C);
  static const Color redDark = Color(0xFF8B0000);
  static const Color bgDark = Color(0xFF1a1a1a);
  static const Color bgDarker = Color(0xFF0d0d0d);
  static const Color accentGold = Color(0xFFD4AF37);
  static const Color textLight = Color(0xFFF5F5DC);
  static const Color textMuted = Color(0xFFAAAAAA);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: redPrimary,
      scaffoldBackgroundColor: bgDark,
      fontFamily: 'SpecialElite',
      appBarTheme: const AppBarTheme(
        backgroundColor: bgDarker,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'BebasNeue',
          fontSize: 28,
          letterSpacing: 4,
          color: textLight,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: redPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: textMuted.withOpacity(0.6)),
      ),
      colorScheme: const ColorScheme.dark(
        primary: redPrimary,
        secondary: accentGold,
        surface: bgDark,
      ),
    );
  }
}

