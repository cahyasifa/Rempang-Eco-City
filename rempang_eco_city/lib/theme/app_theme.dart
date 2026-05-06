import 'package:flutter/material.dart';

class AppColors {
  // ─── MITRA HILIR ──────────────────────────────────────────────
  static const Color bgPrimary      = Color(0xFFFAF9F9);
  static const Color bgSecondary    = Color(0xFFFFF7E8);
  static const Color blue           = Color(0xFF5AACDD);
  static const Color blueDark       = Color(0xFF3A8FBF);
  static const Color blueLight      = Color(0xFFD6EEFA);
  static const Color navBg          = Color(0xFFD6EEFA);
  static const Color statusWaiting  = Color(0xFFFFA500);
  static const Color statusProcess  = Color(0xFF5AACDD);
  static const Color statusDone     = Color(0xFF4CAF50);
  static const Color statusRejected = Color(0xFFE53935);
  static const Color iconGrey       = Color(0xFF888888);
  static const Color deleteRed      = Color(0xFFE53935);
  static const Color successGreen   = Color(0xFF4CAF50);

  // ─── PRODUSEN ─────────────────────────────────────────────────
  static const Color bgPage          = Color(0xFFFAFAFA);
  static const Color bgCard          = Color(0xFFFDFDFD);
  static const Color bgWhite         = Color(0xFFFFFFFF);
  static const Color white           = Color(0xFFFFFFFF);
  static const Color appBar          = Color(0xFFFDFDFD);
  static const Color appBarText      = Color(0xFF222222);
  static const Color primary         = Color(0xFF1D9E75);
  static const Color borderCard      = Color(0xFFE4E4E4);
  static const Color borderInput     = Color(0xFFC8C6C6);
  static const Color divider         = Color(0xFFE4E4E4);
  static const Color chipDefault     = Color(0xFFEDF2F8);
  static const Color chipDefaultText = Color(0xFF3A6FA8);
  static const Color chipActive      = Color(0xFF288AE7);
  static const Color chipActiveText  = Color(0xFFFFFFFF);
  static const Color badgeGreenBg    = Color(0xFFE1F5EE);
  static const Color badgeGreenText  = Color(0xFF0F6E56);
  static const Color badgeAmberBg    = Color(0xFFFAEEDA);
  static const Color badgeAmberText  = Color(0xFF854F0B);
  static const Color badgeRedBg      = Color(0xFFFCEBEB);
  static const Color badgeRedText    = Color(0xFFA32D2D);
  static const Color badgeBlueBg     = Color(0xFFE6F1FB);
  static const Color badgeBlueText   = Color(0xFF185FA5);
  static const Color textPrimary     = Color(0xFF222222);
  static const Color textSecondary   = Color(0xFF888888);
  static const Color textMuted       = Color(0xFF555555);
  static const Color textSuccess     = Color(0xFF0F6E56);
  static const Color textDanger      = Color(0xFFA32D2D);
  static const Color metricAccentBg     = Color(0xFFE1F5EE);
  static const Color metricAccentBorder = Color(0xFF9FE1CB);
  static const Color barGreen        = Color(0xFF1D9E75);
  static const Color barAmber        = Color(0xFFEF9F27);
  static const Color barRed          = Color(0xFFE24B4A);
  static const Color dotLokasi       = Color(0xFF288AE7);

  // ─── ADMIN ────────────────────────────────────────────────────
  static const Color adminBg             = Color(0xFFF4F6F8);
  static const Color adminSurface        = Color(0xFFFFFFFF);
  static const Color sidebarBg          = Color(0xFF0F3D25);
  static const Color sidebarActive      = Color(0xFF1D6A3E);
  static const Color sidebarText        = Color(0xFFB8D9C5);
  static const Color sidebarTextActive  = Color(0xFFFFFFFF);
  static const Color adminPrimary        = Color(0xFF1D6A3E);
  static const Color adminPrimaryLight   = Color(0xFF2E9E5B);
  static const Color adminPrimarySurface = Color(0xFFE8F5EE);
  static const Color adminSuccess        = Color(0xFF2E9E5B);
  static const Color adminSuccessSurface = Color(0xFFE8F5EE);
  static const Color adminWarning        = Color(0xFFF59E0B);
  static const Color adminWarningSurface = Color(0xFFFEF3C7);
  static const Color adminDanger         = Color(0xFFE53935);
  static const Color adminDangerSurface  = Color(0xFFFFEBEE);
  static const Color adminInfo           = Color(0xFF1976D2);
  static const Color adminInfoSurface    = Color(0xFFE3F2FD);
  static const Color adminBorder         = Color(0xFFE0E0E0);
  static const Color adminTextPrimary    = Color(0xFF1A1A1A);
  static const Color adminTextSecondary  = Color(0xFF6B7280);
  static const Color adminTextHint       = Color(0xFF9CA3AF);

  // ─── ALIAS ────────────────────────────────────────────────────
  static const Color primaryDark  = adminPrimary;
  static const Color primaryLight = adminPrimaryLight;
  static const Color background   = adminBg;
  static const Color textDark     = adminTextPrimary;
  static const Color textGrey     = adminTextSecondary;
  static const Color error        = adminDanger;
  static const Color warning      = adminWarning;
  static const Color success      = adminSuccess;
  static const Color info         = adminInfo;
  static const Color accent       = adminPrimaryLight;
  static const Color cardBg       = adminSurface;
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,

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

    cardTheme: CardThemeData(
      color: AppColors.bgCard,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}