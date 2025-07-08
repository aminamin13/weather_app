import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors
  static const Color _lightPrimaryColor = Color(0xFF6366F1); // Indigo
  static const Color _lightSecondaryColor = Color(0xFF8B5CF6); // Purple
  static const Color _lightAccentColor = Color(0xFF06B6D4); // Cyan
  static const Color _lightBackgroundColor = Color(0xFFF8FAFC); // Light gray
  static const Color _lightSurfaceColor = Colors.white;
  static const Color _lightTextPrimary = Color(0xFF1E293B);
  static const Color _lightTextSecondary = Color(0xFF64748B);
  static const Color _lightErrorColor = Color(0xFFEF4444);

  // Dark Theme Colors
  static const Color _darkPrimaryColor = Color(0xFF818CF8); // Lighter indigo for dark mode
  static const Color _darkSecondaryColor = Color(0xFFA78BFA); // Lighter purple for dark mode
  static const Color _darkAccentColor = Color(0xFF22D3EE); // Lighter cyan for dark mode
  static const Color _darkBackgroundColor = Color(0xFF0F172A); // Dark slate
  static const Color _darkSurfaceColor = Color(0xFF1E293B); // Dark surface
  static const Color _darkTextPrimary = Color(0xFFF1F5F9);
  static const Color _darkTextSecondary = Color(0xFF94A3B8);
  static const Color _darkErrorColor = Color(0xFFF87171);

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: _lightPrimaryColor,
        secondary: _lightSecondaryColor,
        tertiary: _lightAccentColor,
        surface: _lightSurfaceColor,
        surfaceContainer: Color(0xFFF1F5F9),
        surfaceContainerHighest: Color(0xFFE2E8F0),
        background: _lightBackgroundColor,
        error: _lightErrorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onTertiary: Colors.white,
        onSurface: _lightTextPrimary,
        onSurfaceVariant: _lightTextSecondary,
        onBackground: _lightTextPrimary,
        onError: Colors.white,
        outline: Color(0xFFCBD5E1),
        outlineVariant: Color(0xFFE2E8F0),
      ),

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightSurfaceColor,
        foregroundColor: _lightTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: _lightPrimaryColor,
        titleTextStyle: TextStyle(
          color: _lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: _lightSurfaceColor,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightPrimaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: _lightPrimaryColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _lightPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _lightPrimaryColor,
          side: const BorderSide(color: _lightPrimaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightSurfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _lightPrimaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: _lightTextPrimary, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: _lightTextPrimary, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: _lightTextPrimary, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: _lightTextPrimary, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(color: _lightTextPrimary, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: _lightTextPrimary, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: _lightTextPrimary, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: _lightTextPrimary, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: _lightTextPrimary, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: _lightTextPrimary),
        bodyMedium: TextStyle(color: _lightTextPrimary),
        bodySmall: TextStyle(color: _lightTextSecondary),
        labelLarge: TextStyle(color: _lightTextPrimary, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(color: _lightTextSecondary),
        labelSmall: TextStyle(color: _lightTextSecondary),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: _lightTextSecondary,
        size: 24,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE2E8F0),
        thickness: 1,
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: _darkPrimaryColor,
        secondary: _darkSecondaryColor,
        tertiary: _darkAccentColor,
        surface: _darkSurfaceColor,
        surfaceContainer: Color(0xFF334155),
        surfaceContainerHighest: Color(0xFF475569),
        background: _darkBackgroundColor,
        error: _darkErrorColor,
        onPrimary: Color(0xFF1E293B),
        onSecondary: Color(0xFF1E293B),
        onTertiary: Color(0xFF1E293B),
        onSurface: _darkTextPrimary,
        onSurfaceVariant: _darkTextSecondary,
        onBackground: _darkTextPrimary,
        onError: Color(0xFF1E293B),
        outline: Color(0xFF475569),
        outlineVariant: Color(0xFF334155),
      ),

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkSurfaceColor,
        foregroundColor: _darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: _darkPrimaryColor,
        titleTextStyle: TextStyle(
          color: _darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: _darkSurfaceColor,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkPrimaryColor,
          foregroundColor: const Color(0xFF1E293B),
          elevation: 3,
          shadowColor: _darkPrimaryColor.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _darkPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _darkPrimaryColor,
          side: const BorderSide(color: _darkPrimaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF334155),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF475569)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF475569)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _darkPrimaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: _darkTextPrimary, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: _darkTextPrimary, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: _darkTextPrimary, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: _darkTextPrimary, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(color: _darkTextPrimary, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: _darkTextPrimary, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: _darkTextPrimary, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: _darkTextPrimary, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: _darkTextPrimary, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: _darkTextPrimary),
        bodyMedium: TextStyle(color: _darkTextPrimary),
        bodySmall: TextStyle(color: _darkTextSecondary),
        labelLarge: TextStyle(color: _darkTextPrimary, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(color: _darkTextSecondary),
        labelSmall: TextStyle(color: _darkTextSecondary),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: _darkTextSecondary,
        size: 24,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: Color(0xFF475569),
        thickness: 1,
      ),
    );
  }

  // Custom Gradients
  static LinearGradient get lightPrimaryGradient => const LinearGradient(
    colors: [_lightPrimaryColor, _lightSecondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get darkPrimaryGradient => const LinearGradient(
    colors: [_darkPrimaryColor, _darkSecondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get lightCardGradient => LinearGradient(
    colors: [_lightSurfaceColor, _lightSurfaceColor.withOpacity(0.8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get darkCardGradient => LinearGradient(
    colors: [_darkSurfaceColor, _darkSurfaceColor.withOpacity(0.8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// Extension to easily access gradients from context
extension ThemeGradients on ThemeData {
  LinearGradient get primaryGradient => brightness == Brightness.light 
      ? AppTheme.lightPrimaryGradient 
      : AppTheme.darkPrimaryGradient;
      
  LinearGradient get cardGradient => brightness == Brightness.light 
      ? AppTheme.lightCardGradient 
      : AppTheme.darkCardGradient;
}