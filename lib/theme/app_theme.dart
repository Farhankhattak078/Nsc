import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary custom colors based on Blue/Indigo
  static const Color primaryColor = Color(0xFF4F46E5); // Indigo
  static const Color primaryGradientStart = Color(0xFF4338CA);
  static const Color primaryGradientEnd = Color(0xFF6366F1);
  
  static const Color scaffoldLight = Color(0xFFF9FAFB);
  static const Color scaffoldDark = Color(0xFF0F172A);

  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1E293B);

  static const Color textLight = Color(0xFF111827);
  static const Color textDark = Color(0xFFF9FAFB);

  static const double cardRadius = 16.0;

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldLight,
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldLight,
        elevation: 0,
        iconTheme: const IconThemeData(color: textLight),
        titleTextStyle: GoogleFonts.inter(
          color: textLight,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.05),
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: primaryGradientEnd,
        surface: cardLight,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldDark,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldDark,
        elevation: 0,
        iconTheme: const IconThemeData(color: textDark),
        titleTextStyle: GoogleFonts.inter(
          color: textDark,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.2),
      ),
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: primaryGradientEnd,
        surface: cardDark,
      ),
    );
  }
}
