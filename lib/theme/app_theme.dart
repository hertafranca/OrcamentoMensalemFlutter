import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData dark() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.richGold,
      onPrimary: AppColors.imperialPurple,
      primaryContainer: AppColors.goldDark,
      onPrimaryContainer: AppColors.goldLight,
      secondary: AppColors.bottleGreen,
      onSecondary: AppColors.textPrimary,
      secondaryContainer: AppColors.bottleGreen,
      onSecondaryContainer: AppColors.textPrimary,
      error: AppColors.danger,
      onError: AppColors.imperialPurple,
      surface: AppColors.background,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      surfaceContainerLowest: AppColors.background,
      surfaceContainerLow: AppColors.surface,
      surfaceContainer: AppColors.surface,
      surfaceContainerHigh: AppColors.surfaceHigh,
      surfaceContainerHighest: AppColors.surfaceHigh,
      outline: AppColors.border,
      outlineVariant: AppColors.border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: _textTheme(),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.richGold,
        foregroundColor: AppColors.imperialPurple,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.surfaceHigh,
        contentTextStyle: const TextStyle(color: AppColors.textPrimary),
        actionTextColor: AppColors.richGold,
        closeIconColor: AppColors.textSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
      ),
    );
  }

  // Playfair Display para títulos e valores.
  // Inter para todo o resto.
  static TextTheme _textTheme() {
    final baseTextTheme = ThemeData(brightness: Brightness.dark).textTheme;

    final bodyTextTheme = GoogleFonts.interTextTheme(baseTextTheme);
    final titleTextTheme = GoogleFonts.playfairDisplayTextTheme(baseTextTheme);

    return bodyTextTheme
        .copyWith(
          displayLarge: titleTextTheme.displayLarge,
          displayMedium: titleTextTheme.displayMedium,
          displaySmall: titleTextTheme.displaySmall,
          headlineLarge: titleTextTheme.headlineLarge,
          headlineMedium: titleTextTheme.headlineMedium,
          headlineSmall: titleTextTheme.headlineSmall,
          titleLarge: titleTextTheme.titleLarge,
        )
        .apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        );
  }

  // Aparência padrão dos campos de texto do app.
  static InputDecoration input({
    required String label,
    String? hintText,
    String? prefixText,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      prefixText: prefixText,
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}
 