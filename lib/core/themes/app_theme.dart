import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary Colors (Dark theme inspired)
  static const Color primaryDark = Color(0xFF2A2D3A); // Deep navy background
  static const Color primaryLight = Color(0xFFF8F9FA); // Light background
  static const Color accentPink = Color(0xFFFF6B9D); // Pink accent (from image)
  static const Color accentYellow = Color(0xFFFFC107); // Yellow accent (from image)
  static const Color accentPurple = Color(0xFF8B5CF6); // Purple accent

  // Navigation Colors
  static const Color navBackground = Color(0xFFFFFFFF); // White nav background
  static const Color navInactive = Color(0xFF9CA3AF); // Gray inactive icons
  static const Color navActive = Color(0xFF1F2937); // Dark active icons
  static const Color centerFAB = Color(0xFFFF6B9D); // Pink center button

  // Status Colors
  static const Color statusSubmitted = Color(0xFF3B82F6); // Blue
  static const Color statusApproved = Color(0xFF10B981); // Green
  static const Color statusRejected = Color(0xFFEF4444); // Red
  static const Color statusPending = Color(0xFFF59E0B); // Amber

  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryLight,
      scaffoldBackgroundColor: primaryLight,
      colorScheme: const ColorScheme.light(
        primary: primaryLight,
        secondary: accentPink,
        surface: navBackground,
        onPrimary: navActive,
        onSecondary: Colors.white,
        onSurface: navActive,
      ),
      textTheme: _buildTextTheme(ThemeData.light().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryLight,
        foregroundColor: navActive,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentPink,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentPink,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: accentPink),
        ),
        labelStyle: TextStyle(color: Colors.grey[700]),
        prefixIconColor: Colors.grey[700],
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      chipTheme: ChipThemeData(
        selectedColor: accentPink,
        labelStyle: const TextStyle(color: Colors.white),
        backgroundColor: Colors.grey[200],
        checkmarkColor: Colors.white,
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryDark,
      scaffoldBackgroundColor: primaryDark,
      colorScheme: const ColorScheme.dark(
        primary: primaryDark,
        secondary: accentPink,
        surface: primaryDark,
        onPrimary: primaryLight,
        onSecondary: Colors.white,
        onSurface: navInactive,
      ),
      textTheme: _buildTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryDark,
        foregroundColor: primaryLight,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentPink,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentPink,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: accentPink),
        ),
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIconColor: Colors.white70,
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: primaryDark.withValues(alpha: 0.8),
      ),
      chipTheme: ChipThemeData(
        selectedColor: accentPink,
        labelStyle: const TextStyle(color: Colors.white),
        backgroundColor: Colors.white.withValues(alpha: 0.1),
        checkmarkColor: Colors.white,
      ),
    );
  }

  static TextTheme _buildTextTheme(TextTheme base) {
    return TextTheme(
      headlineLarge: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        color: base.displayLarge?.color, // Use base color for adaptability
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
        color: base.displayMedium?.color,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        color: base.bodyLarge?.color,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: base.bodyMedium?.color,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: base.labelLarge?.color,
      ),
    );
  }
}