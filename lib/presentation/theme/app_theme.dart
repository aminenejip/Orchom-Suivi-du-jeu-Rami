import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.onTertiary,
      tertiaryContainer: AppColors.tertiaryContainer,
      onTertiaryContainer: AppColors.onTertiaryContainer,
      error: AppColors.error,
      onError: AppColors.onError,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.onErrorContainer,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      surfaceContainerLowest: AppColors.surfaceContainerLowest,
      surfaceContainerLow: AppColors.surfaceContainerLow,
      surfaceContainer: AppColors.surfaceContainer,
      surfaceContainerHigh: AppColors.surfaceContainerHigh,
      surfaceContainerHighest: AppColors.surfaceContainerHighest,
      surfaceDim: AppColors.surfaceDim,
      surfaceBright: AppColors.surfaceBright,
      inverseSurface: AppColors.inverseSurface,
      inversePrimary: AppColors.inversePrimary,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppTextStyles.fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 1,
        titleTextStyle: AppTextStyles.headlineMd.copyWith(
          color: AppColors.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerLowest,
        elevation: 0,
        shadowColor: AppColors.cardShadowColor.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size(double.infinity, AppSpacing.touchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.bodyMd.copyWith(
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size(double.infinity, AppSpacing.touchTarget),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.bodyMd.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          minimumSize: const Size(double.infinity, AppSpacing.touchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.bodyMd.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.outline.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 14,
        ),
        labelStyle: TextStyle(color: AppColors.neutral),
        floatingLabelStyle: TextStyle(color: AppColors.primary),
        hintStyle: TextStyle(color: AppColors.neutral.withValues(alpha: 0.6)),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.outline.withValues(alpha: 0.2),
        thickness: 1,
        space: 1,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: AppColors.primary,
          selectedForegroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.neutral;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withValues(alpha: 0.3);
          }
          return AppColors.neutral.withValues(alpha: 0.2);
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.secondary,
        labelStyle: const TextStyle(color: AppColors.onSecondary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9999),
        ),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.headlineLg,
        displayMedium: AppTextStyles.headlineMd,
        displaySmall: AppTextStyles.scoreDisplay,
        headlineLarge: AppTextStyles.headlineLg,
        headlineMedium: AppTextStyles.headlineLgMobile,
        headlineSmall: AppTextStyles.headlineMd,
        titleLarge: AppTextStyles.headlineMd.copyWith(color: AppColors.onSurface),
        titleMedium: AppTextStyles.bodyMd.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        titleSmall: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.neutral,
        ),
        bodyLarge: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurface),
        bodyMedium: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
        bodySmall: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 14,
          color: AppColors.neutral,
        ),
        labelLarge: AppTextStyles.labelMd.copyWith(color: AppColors.onSurface),
        labelMedium: AppTextStyles.labelMd.copyWith(color: AppColors.neutral),
        labelSmall: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.neutral,
        ),
      ),
    );
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme.dark(
      primary: AppColors.inversePrimary,
      onPrimary: const Color(0xFF690005),
      primaryContainer: AppColors.primary,
      onPrimaryContainer: AppColors.primaryContainer,
      secondary: const Color(0xFFFFB77D),
      onSecondary: const Color(0xFF4A2E00),
      secondaryContainer: AppColors.secondary,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      tertiary: const Color(0xFFBEC6E0),
      onTertiary: const Color(0xFF262D42),
      tertiaryContainer: const Color(0xFF3F465C),
      onTertiaryContainer: AppColors.tertiaryContainer,
      error: const Color(0xFFFFB4AB),
      onError: const Color(0xFF690005),
      errorContainer: AppColors.error,
      onErrorContainer: AppColors.onErrorContainer,
      surface: const Color(0xFF0D1B2A),
      onSurface: const Color(0xFFEAF1FF),
      surfaceContainerLowest: const Color(0xFF081526),
      surfaceContainerLow: const Color(0xFF152234),
      surfaceContainer: const Color(0xFF1B2838),
      surfaceContainerHigh: const Color(0xFF243447),
      surfaceContainerHighest: const Color(0xFF2D3E52),
      surfaceDim: const Color(0xFF0D1B2A),
      surfaceBright: const Color(0xFF334155),
      inverseSurface: const Color(0xFFEAF1FF),
      inversePrimary: AppColors.primary,
      outline: const Color(0xFFA08C89),
      outlineVariant: const Color(0xFF5B403D),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF0D1B2A),
      fontFamily: AppTextStyles.fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1B2838),
        foregroundColor: const Color(0xFFEAF1FF),
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 1,
        titleTextStyle: AppTextStyles.headlineMd.copyWith(
          color: const Color(0xFFEAF1FF),
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1B2838),
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(double.infinity, AppSpacing.touchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.bodyMd.copyWith(
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(double.infinity, AppSpacing.touchTarget),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.bodyMd.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary),
          minimumSize: const Size(double.infinity, AppSpacing.touchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.bodyMd.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF152234),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: const Color(0xFFA08C89).withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFFFB4AB)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFFFB4AB), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 14,
        ),
        labelStyle: const TextStyle(color: Color(0xFFA08C89)),
        floatingLabelStyle: TextStyle(color: colorScheme.primary),
        hintStyle: TextStyle(color: const Color(0xFFA08C89).withValues(alpha: 0.6)),
      ),
      dividerTheme: DividerThemeData(
        color: const Color(0xFFEAF1FF).withValues(alpha: 0.12),
        thickness: 1,
        space: 1,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: colorScheme.primary,
          selectedForegroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return const Color(0xFFA08C89);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary.withValues(alpha: 0.3);
          }
          return const Color(0xFFA08C89).withValues(alpha: 0.2);
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.secondary,
        labelStyle: const TextStyle(color: AppColors.onSecondary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9999),
        ),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.headlineLg.copyWith(color: const Color(0xFFEAF1FF)),
        displayMedium: AppTextStyles.headlineMd.copyWith(color: const Color(0xFFEAF1FF)),
        displaySmall: AppTextStyles.scoreDisplay.copyWith(color: const Color(0xFFEAF1FF)),
        headlineLarge: AppTextStyles.headlineLg.copyWith(color: const Color(0xFFEAF1FF)),
        headlineMedium: AppTextStyles.headlineLgMobile.copyWith(color: const Color(0xFFEAF1FF)),
        headlineSmall: AppTextStyles.headlineMd.copyWith(color: const Color(0xFFEAF1FF)),
        titleLarge: AppTextStyles.headlineMd.copyWith(color: const Color(0xFFEAF1FF)),
        titleMedium: AppTextStyles.bodyMd.copyWith(
          fontWeight: FontWeight.w600,
          color: const Color(0xFFEAF1FF),
        ),
        titleSmall: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: const Color(0xFFA08C89),
        ),
        bodyLarge: AppTextStyles.bodyMd.copyWith(color: const Color(0xFFEAF1FF)),
        bodyMedium: AppTextStyles.bodyMd.copyWith(color: const Color(0xFFB0B0B0)),
        bodySmall: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 14,
          color: const Color(0xFFA08C89),
        ),
        labelLarge: AppTextStyles.labelMd.copyWith(color: const Color(0xFFEAF1FF)),
        labelMedium: AppTextStyles.labelMd.copyWith(color: const Color(0xFFB0B0B0)),
        labelSmall: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: const Color(0xFFA08C89),
        ),
      ),
    );
  }
}
