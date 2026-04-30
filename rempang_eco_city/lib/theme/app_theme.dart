import 'package:flutter/material.dart';

class AppColors {
  static const Color bgPrimary   = Color(0xFFFAF9F9);
  static const Color bgSecondary = Color(0xFFFFF7E8);
  static const Color bgCard      = Color(0xFFFFF7E8);
  static const Color blue        = Color(0xFF5AACDD);
  static const Color blueDark    = Color(0xFF3A8FBF);
  static const Color blueLight   = Color(0xFFD6EEFA);
  static const Color navBg       = Color(0xFFD6EEFA);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color statusWaiting  = Color(0xFFFFA500);
  static const Color statusProcess  = Color(0xFF5AACDD);
  static const Color statusDone     = Color(0xFF4CAF50);
  static const Color statusRejected = Color(0xFFE53935);
  static const Color white    = Color(0xFFFFFFFF);
  static const Color divider  = Color(0xFFE0E0E0);
  static const Color iconGrey = Color(0xFF888888);
  static const Color deleteRed   = Color(0xFFE53935);
  static const Color successGreen = Color(0xFF4CAF50);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true, // 🔥 penting biar sesuai Flutter terbaru

    scaffoldBackgroundColor: AppColors.bgPrimary,

    colorScheme: const ColorScheme.light(
      primary: AppColors.blue,
      secondary: AppColors.bgSecondary,
      surface: Color.from(alpha: 1, red: 0.98, green: 0.976, blue: 0.976),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.blue,
      foregroundColor: AppColors.white,
      elevation: 0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.blue),
      ),
    ),

    // ✅ FIX DI SINI
    cardTheme: CardThemeData(
      color: AppColors.bgCard,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}