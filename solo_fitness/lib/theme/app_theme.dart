import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the fitness application.
/// Implements Cinematic Minimalism design with Controlled Neon Spectrum colors.
class AppTheme {
  AppTheme._();

  // Controlled Neon Spectrum Colors
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color secondaryPurple = Color(0xFF8B5CF6);
  static const Color accentGold = Color(0xFFEAB308);
  static const Color backgroundDeep = Color(0xFF0A0A0F);
  static const Color backgroundMid = Color(0xFF1A1F2E);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFEF4444);

  // Light theme colors (minimal usage for this dark-focused app)
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textLightPrimary = Color(0xFF0F172A);
  static const Color textLightSecondary = Color(0xFF64748B);

  // Neon glow variants for interactive elements
  static const Color primaryBlueGlow = Color(0x333B82F6);
  static const Color secondaryPurpleGlow = Color(0x338B5CF6);
  static const Color accentGoldGlow = Color(0x33EAB308);

  // Shadow colors with neon tints
  static const Color shadowBlue = Color(0x1A3B82F6);
  static const Color shadowPurple = Color(0x1A8B5CF6);
  static const Color shadowGold = Color(0x1AEAB308);

  /// Dark theme (primary theme for fitness app)
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryBlue,
      onPrimary: textPrimary,
      primaryContainer: primaryBlue.withValues(alpha: 0.2),
      onPrimaryContainer: textPrimary,
      secondary: secondaryPurple,
      onSecondary: textPrimary,
      secondaryContainer: secondaryPurple.withValues(alpha: 0.2),
      onSecondaryContainer: textPrimary,
      tertiary: accentGold,
      onTertiary: backgroundDeep,
      tertiaryContainer: accentGold.withValues(alpha: 0.2),
      onTertiaryContainer: textPrimary,
      error: errorRed,
      onError: textPrimary,
      surface: backgroundMid,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      outline: textSecondary.withValues(alpha: 0.2),
      outlineVariant: textSecondary.withValues(alpha: 0.1),
      shadow: shadowBlue,
      scrim: backgroundDeep.withValues(alpha: 0.8),
      inverseSurface: surfaceLight,
      onInverseSurface: textLightPrimary,
      inversePrimary: primaryBlue,
    ),
    scaffoldBackgroundColor: backgroundDeep,
    cardColor: backgroundMid,
    dividerColor: textSecondary.withValues(alpha: 0.2),

    // AppBar theme with cinematic styling
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundDeep,
      foregroundColor: textPrimary,
      elevation: 0,
      shadowColor: shadowBlue,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.orbitron(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.5,
      ),
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),
    ),

    // Card theme with subtle neon glow
    cardTheme: CardTheme(
      color: backgroundMid,
      elevation: 0,
      shadowColor: shadowBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: primaryBlue.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      margin: const EdgeInsets.all(8.0),
    ),

    // Bottom navigation with gaming aesthetic
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: backgroundMid,
      selectedItemColor: primaryBlue,
      unselectedItemColor: textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
    ),

    // Floating action button with neon accent
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryBlue,
      foregroundColor: textPrimary,
      elevation: 4,
      focusElevation: 6,
      hoverElevation: 6,
      highlightElevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),

    // Button themes with neon styling
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: textPrimary,
        backgroundColor: primaryBlue,
        disabledForegroundColor: textSecondary,
        disabledBackgroundColor: backgroundMid,
        elevation: 0,
        shadowColor: shadowBlue,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ).copyWith(
        overlayColor: WidgetStateProperty.all(primaryBlueGlow),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryBlue,
        disabledForegroundColor: textSecondary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: const BorderSide(color: primaryBlue, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ).copyWith(
        overlayColor: WidgetStateProperty.all(primaryBlueGlow),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryBlue,
        disabledForegroundColor: textSecondary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.25,
        ),
      ).copyWith(
        overlayColor: WidgetStateProperty.all(primaryBlueGlow),
      ),
    ),

    // Text theme with Orbitron and Inter fonts
    textTheme: _buildDarkTextTheme(),

    // Input decoration with neon focus states
    inputDecorationTheme: InputDecorationTheme(
      fillColor: backgroundMid,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: textSecondary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: textSecondary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(
          color: primaryBlue,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(
          color: errorRed,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(
          color: errorRed,
          width: 2,
        ),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textSecondary.withValues(alpha: 0.6),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      prefixIconColor: textSecondary,
      suffixIconColor: textSecondary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),

    // Switch theme with neon colors
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue;
        }
        return textSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue.withValues(alpha: 0.5);
        }
        return textSecondary.withValues(alpha: 0.3);
      }),
      overlayColor: WidgetStateProperty.all(primaryBlueGlow),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(textPrimary),
      overlayColor: WidgetStateProperty.all(primaryBlueGlow),
      side: BorderSide(color: textSecondary.withValues(alpha: 0.5), width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),

    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue;
        }
        return textSecondary;
      }),
      overlayColor: WidgetStateProperty.all(primaryBlueGlow),
    ),

    // Progress indicators with neon styling
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryBlue,
      linearTrackColor: backgroundMid,
      circularTrackColor: backgroundMid,
    ),

    sliderTheme: SliderThemeData(
      activeTrackColor: primaryBlue,
      thumbColor: primaryBlue,
      overlayColor: primaryBlueGlow,
      inactiveTrackColor: backgroundMid,
      valueIndicatorColor: primaryBlue,
      valueIndicatorTextStyle: GoogleFonts.jetBrainsMono(
        color: textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),

    // Tab bar theme for gaming aesthetic
    tabBarTheme: TabBarTheme(
      labelColor: primaryBlue,
      unselectedLabelColor: textSecondary,
      indicatorColor: primaryBlue,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      overlayColor: WidgetStateProperty.all(primaryBlueGlow),
    ),

    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: backgroundMid,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: primaryBlue.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: shadowBlue,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      textStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: backgroundMid,
      contentTextStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: primaryBlue,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: primaryBlue.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      elevation: 4,
    ),

    // Dialog theme with cinematic styling
    dialogTheme: DialogTheme(
      backgroundColor: backgroundMid,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shadowColor: shadowBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: primaryBlue.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      titleTextStyle: GoogleFonts.orbitron(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      contentTextStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
    ),
  );

  /// Light theme (secondary theme for accessibility)
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryBlue,
      onPrimary: textPrimary,
      primaryContainer: primaryBlue.withValues(alpha: 0.1),
      onPrimaryContainer: primaryBlue,
      secondary: secondaryPurple,
      onSecondary: textPrimary,
      secondaryContainer: secondaryPurple.withValues(alpha: 0.1),
      onSecondaryContainer: secondaryPurple,
      tertiary: accentGold,
      onTertiary: backgroundDeep,
      tertiaryContainer: accentGold.withValues(alpha: 0.1),
      onTertiaryContainer: accentGold,
      error: errorRed,
      onError: textPrimary,
      surface: surfaceLight,
      onSurface: textLightPrimary,
      onSurfaceVariant: textLightSecondary,
      outline: textLightSecondary.withValues(alpha: 0.3),
      outlineVariant: textLightSecondary.withValues(alpha: 0.2),
      shadow: Colors.black.withValues(alpha: 0.1),
      scrim: Colors.black.withValues(alpha: 0.5),
      inverseSurface: backgroundMid,
      onInverseSurface: textPrimary,
      inversePrimary: primaryBlue,
    ),
    scaffoldBackgroundColor: backgroundLight,
    cardColor: surfaceLight,
    dividerColor: textLightSecondary.withValues(alpha: 0.2),
    textTheme: _buildLightTextTheme(), dialogTheme: DialogThemeData(backgroundColor: surfaceLight),
    // Additional light theme configurations would follow the same pattern
    // but are abbreviated here since the app primarily uses dark theme
  );

  /// Build dark theme text styles with Orbitron and Inter fonts
  static TextTheme _buildDarkTextTheme() {
    return TextTheme(
      // Display styles with Orbitron for futuristic headers
      displayLarge: GoogleFonts.orbitron(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.orbitron(
        fontSize: 45,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.orbitron(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.22,
      ),

      // Headline styles with Orbitron for section headers
      headlineLarge: GoogleFonts.orbitron(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.orbitron(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.orbitron(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.33,
      ),

      // Title styles with Inter for UI elements
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.15,
        height: 1.50,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.1,
        height: 1.43,
      ),

      // Body styles with Inter for content
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0.5,
        height: 1.50,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        letterSpacing: 0.4,
        height: 1.33,
      ),

      // Label styles with Inter for UI labels
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }

  /// Build light theme text styles
  static TextTheme _buildLightTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.orbitron(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        color: textLightPrimary,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.orbitron(
        fontSize: 45,
        fontWeight: FontWeight.w600,
        color: textLightPrimary,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.orbitron(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: textLightPrimary,
        letterSpacing: 0,
        height: 1.22,
      ),
      headlineLarge: GoogleFonts.orbitron(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textLightPrimary,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.orbitron(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textLightPrimary,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.orbitron(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textLightPrimary,
        letterSpacing: 0,
        height: 1.33,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textLightPrimary,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textLightPrimary,
        letterSpacing: 0.15,
        height: 1.50,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textLightPrimary,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textLightPrimary,
        letterSpacing: 0.5,
        height: 1.50,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textLightPrimary,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textLightSecondary,
        letterSpacing: 0.4,
        height: 1.33,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textLightPrimary,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textLightSecondary,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: textLightSecondary,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }

  /// Data display text styles using JetBrains Mono
  static TextStyle dataDisplayLarge = GoogleFonts.jetBrainsMono(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    letterSpacing: 0,
  );

  static TextStyle dataDisplayMedium = GoogleFonts.jetBrainsMono(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    letterSpacing: 0,
  );

  static TextStyle dataDisplaySmall = GoogleFonts.jetBrainsMono(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    letterSpacing: 0,
  );

  static TextStyle timerDisplay = GoogleFonts.jetBrainsMono(
    fontSize: 48,
    fontWeight: FontWeight.w500,
    color: primaryBlue,
    letterSpacing: -1,
  );

  /// Caption styles for small UI elements
  static TextStyle captionPrimary = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    letterSpacing: 0.4,
  );

  static TextStyle captionSecondary = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w300,
    color: textSecondary.withValues(alpha: 0.7),
    letterSpacing: 0.5,
  );
}
