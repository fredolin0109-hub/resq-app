import 'package:flutter/material.dart';

/// Central theme configuration for the ResQLink application.
class AppTheme {
  static ThemeData get darkTheme {
    const primary = Color(0xFFEF4444); // Rescue Red
    const secondary = Color(0xFF3B82F6); // Tactical Blue
    const surface = Color(0xFF0F172A); // Deep Navy Slate
    const background = Color(0xFF090D16);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
      primary: primary,
      secondary: secondary,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF1E293B)),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    const primary = Color(0xFFDC2626);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        primary: primary,
      ),
    );
  }
}
