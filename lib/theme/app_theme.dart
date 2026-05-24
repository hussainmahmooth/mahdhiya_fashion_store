import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF000666);
  static const Color onPrimary = Colors.white;
  static const Color secondary = Color(0xFF0C6780);
  static const Color onSecondary = Colors.white;
  static const Color background = Color(0xFFFBF9F8);
  static const Color onBackground = Color(0xFF1B1C1C);
  static const Color surface = Color(0xFFFBF9F8);
  static const Color onSurface = Color(0xFF1B1C1C);
  static const Color surfaceVariant = Color(0xFFE4E2E1);
  static const Color outline = Color(0xFF767683);
  static const Color onSurfaceVariant = Color(0xFF454652);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onSecondary,
        surface: surface,
        onSurface: onSurface,
        background: background,
        onBackground: onBackground,
        surfaceVariant: surfaceVariant,
        outline: outline,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.notoSerif(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.02,
          color: onBackground,
        ),
        displayMedium: GoogleFonts.notoSerif(
          fontSize: 36,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.01,
          color: onBackground,
        ),
        headlineLarge: GoogleFonts.notoSerif(
          fontSize: 30,
          fontWeight: FontWeight.w600,
          color: onBackground,
        ),
        headlineMedium: GoogleFonts.notoSerif(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: onBackground,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: onBackground,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: onBackground,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: onSurfaceVariant,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.05,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
      scaffoldBackgroundColor: background,
    );
  }
}

extension AppThemeStyles on TextTheme {
  TextStyle get fontDisplayLg => GoogleFonts.notoSerif(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.02,
      );
  TextStyle get fontDisplayMd => GoogleFonts.notoSerif(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.01,
      );
  TextStyle get fontHeadlineLg => GoogleFonts.notoSerif(
        fontSize: 30,
        fontWeight: FontWeight.w600,
      );
  TextStyle get fontHeadlineMd => GoogleFonts.notoSerif(
        fontSize: 24,
        fontWeight: FontWeight.w500,
      );
  TextStyle get fontBodyLg => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.normal,
      );
  TextStyle get fontBodyMd => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      );
  TextStyle get fontBodySm => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );
  TextStyle get fontLabelLg => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.05,
      );
  TextStyle get fontLabelMd => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      );
  TextStyle get fontLabelSm => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
      );
}
