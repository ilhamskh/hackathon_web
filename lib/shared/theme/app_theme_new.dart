import 'package:flutter/material.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_typography.dart';
import '../../core/design/app_spacing.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: false,
      fontFamily: AppTypography.fontFamily,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryLight,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.secondaryLight,
        surface: AppColors.white,
        background: AppColors.gray50,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.gray900,
        onBackground: AppColors.gray900,
        onError: AppColors.white,
        outline: AppColors.gray300,
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.gray900,
        titleTextStyle: AppTypography.h5,
        toolbarHeight: 72,
        centerTitle: false,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: AppElevation.sm,
        color: AppColors.white,
        shadowColor: AppColors.shadowLight,
        shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.radiusLG),
        margin: AppSpacing.marginMD,
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: AppElevation.sm,
          shadowColor: AppColors.shadowMedium,
          shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.radiusLG),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          textStyle: AppTypography.buttonMedium,
          minimumSize: const Size(120, 48),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.radiusLG),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          textStyle: AppTypography.buttonMedium,
          minimumSize: const Size(120, 48),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.radiusLG),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          textStyle: AppTypography.buttonMedium,
          minimumSize: const Size(120, 48),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: AppBorderRadius.radiusLG,
          borderSide: const BorderSide(color: AppColors.gray300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.radiusLG,
          borderSide: const BorderSide(color: AppColors.gray300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.radiusLG,
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.radiusLG,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.radiusLG,
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: AppSpacing.paddingMD,
        labelStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.gray600,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.gray400),
        errorStyle: AppTypography.labelSmall.copyWith(color: AppColors.error),
      ),

      // Scaffold Theme
      scaffoldBackgroundColor: AppColors.gray50,

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: AppTypography.h1,
        displayMedium: AppTypography.h2,
        displaySmall: AppTypography.h3,
        headlineLarge: AppTypography.h4,
        headlineMedium: AppTypography.h5,
        headlineSmall: AppTypography.h6,
        titleLarge: AppTypography.h5,
        titleMedium: AppTypography.h6,
        titleSmall: AppTypography.labelLarge,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.labelLarge,
        labelMedium: AppTypography.labelMedium,
        labelSmall: AppTypography.labelSmall,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: AppColors.gray600, size: 24),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.gray200,
        thickness: 1,
        space: 1,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.gray100,
        selectedColor: AppColors.primary,
        deleteIconColor: AppColors.gray500,
        labelStyle: AppTypography.labelSmall,
        padding: AppSpacing.paddingSM,
        shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.radiusFull),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: false,
      fontFamily: AppTypography.fontFamily,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryLight,
        primaryContainer: AppColors.primary,
        secondary: AppColors.secondaryLight,
        secondaryContainer: AppColors.secondary,
        surface: AppColors.darkSurface,
        background: AppColors.darkBackground,
        error: AppColors.error,
        onPrimary: AppColors.darkBackground,
        onSecondary: AppColors.darkBackground,
        onSurface: AppColors.white,
        onBackground: AppColors.white,
        onError: AppColors.white,
        outline: AppColors.darkBorder,
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.white,
        titleTextStyle: AppTypography.h5,
        toolbarHeight: 72,
        centerTitle: false,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: AppElevation.sm,
        color: AppColors.darkCard,
        shadowColor: AppColors.shadowHeavy,
        shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.radiusLG),
        margin: AppSpacing.marginMD,
      ),

      // Scaffold Theme
      scaffoldBackgroundColor: AppColors.darkBackground,

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkCard,
        border: OutlineInputBorder(
          borderRadius: AppBorderRadius.radiusLG,
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.radiusLG,
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.radiusLG,
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
        ),
        contentPadding: AppSpacing.paddingMD,
        labelStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.gray400,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.gray500),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: AppColors.gray300, size: 24),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
