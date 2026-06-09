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
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightText,
      surfaceContainerLowest: AppColors.lightSurface,
      surfaceContainerLow: AppColors.lightSurfaceContainer,
      surfaceContainer: AppColors.lightSurfaceContainer,
      surfaceContainerHigh: AppColors.lightSurfaceHigh,
      surfaceContainerHighest: AppColors.lightSurfaceHigh,
      surfaceDim: AppColors.lightSurfaceContainer,
      surfaceBright: AppColors.lightSurface,
      inverseSurface: AppColors.darkBg,
      inversePrimary: AppColors.primaryDark,
      outline: AppColors.lightOutline,
      outlineVariant: AppColors.lightOutline.withValues(alpha: 0.5),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightBg,
      fontFamily: AppTextStyles.bodyFont,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionColor: AppColors.primary.withValues(alpha: 0.3),
        selectionHandleColor: AppColors.primary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightSurface.withValues(alpha: 0.8),
        foregroundColor: AppColors.lightText,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0.5,
        titleTextStyle: AppTextStyles.displaySm.copyWith(
          color: AppColors.lightText,
        ),
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 0,
        shadowColor: AppColors.cardShadow,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: BorderSide(
            color: AppColors.lightOutline.withValues(alpha: 0.3),
          ),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        clipBehavior: Clip.antiAlias,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          disabledBackgroundColor: AppColors.lightOutline.withValues(alpha: 0.5),
          disabledForegroundColor: AppColors.lightTextMuted,
          minimumSize: const Size(double.infinity, AppSpacing.touchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          textStyle: AppTextStyles.button,
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
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
          disabledForegroundColor: AppColors.lightTextMuted,
          minimumSize: const Size(double.infinity, AppSpacing.touchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurfaceContainer,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(
            color: AppColors.lightOutline.withValues(alpha: 0.4),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: AppColors.lightOutline.withValues(alpha: 0.2)),
        ),
        labelStyle: TextStyle(
          color: AppColors.lightTextMuted,
          fontFamily: AppTextStyles.bodyFont,
          fontSize: 14,
        ),
        floatingLabelStyle: TextStyle(
          color: AppColors.primary,
          fontFamily: AppTextStyles.bodyFont,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: TextStyle(
          color: AppColors.lightTextMuted.withValues(alpha: 0.6),
          fontFamily: AppTextStyles.bodyFont,
          fontSize: 16,
        ),
        errorStyle: TextStyle(
          color: AppColors.error,
          fontFamily: AppTextStyles.bodyFont,
          fontSize: 12,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.lightOutline.withValues(alpha: 0.3),
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightSurfaceContainer,
        labelStyle: AppTextStyles.bodySm.copyWith(
          color: AppColors.lightText,
        ),
        secondaryLabelStyle: AppTextStyles.bodySm.copyWith(
          color: AppColors.lightTextMuted,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        side: BorderSide(color: AppColors.lightOutline.withValues(alpha: 0.3)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        showCheckmark: false,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return AppColors.lightTextMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withValues(alpha: 0.3);
          }
          return AppColors.lightOutline.withValues(alpha: 0.5);
        }),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.primary.withValues(alpha: 0.2),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightSurface.withValues(alpha: 0.95),
        indicatorColor: AppColors.primary.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.labelSm.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            );
          }
          return AppTextStyles.labelSm.copyWith(color: AppColors.lightTextMuted);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(size: 24, color: AppColors.primary);
          }
          return IconThemeData(size: 24, color: AppColors.lightTextMuted);
        }),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXl),
          ),
        ),
        elevation: 0,
        modalElevation: 0,
        showDragHandle: false,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkBg,
        contentTextStyle: AppTextStyles.bodySm.copyWith(color: AppColors.darkText),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        elevation: 0,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayXL.copyWith(color: AppColors.lightText),
        displayMedium: AppTextStyles.displayLg.copyWith(color: AppColors.lightText),
        displaySmall: AppTextStyles.displayMd.copyWith(color: AppColors.lightText),
        headlineLarge: AppTextStyles.headline.copyWith(color: AppColors.lightText),
        headlineMedium: AppTextStyles.subtitle.copyWith(color: AppColors.lightText),
        headlineSmall: AppTextStyles.body.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.lightText,
        ),
        titleLarge: AppTextStyles.displaySm.copyWith(color: AppColors.lightText),
        titleMedium: AppTextStyles.subtitle.copyWith(color: AppColors.lightText),
        titleSmall: AppTextStyles.bodySm.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.lightTextMuted,
        ),
        bodyLarge: AppTextStyles.body.copyWith(color: AppColors.lightText),
        bodyMedium: AppTextStyles.body.copyWith(color: AppColors.lightTextMuted),
        bodySmall: AppTextStyles.bodySm.copyWith(color: AppColors.lightTextMuted),
        labelLarge: AppTextStyles.label.copyWith(color: AppColors.lightText),
        labelMedium: AppTextStyles.bodySm.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.lightTextMuted,
        ),
        labelSmall: AppTextStyles.labelSm.copyWith(color: AppColors.lightTextMuted),
      ),
    );
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme.dark(
      primary: AppColors.primaryDark,
      onPrimary: const Color(0xFF022C22),
      primaryContainer: AppColors.primaryContainerDark,
      onPrimaryContainer: AppColors.onPrimaryContainerDark,
      secondary: AppColors.secondaryDark,
      onSecondary: const Color(0xFF3B2F00),
      secondaryContainer: AppColors.secondaryContainerDark,
      onSecondaryContainer: AppColors.onSecondaryContainerDark,
      tertiary: AppColors.tertiary,
      onTertiary: const Color(0xFF5C2A00),
      tertiaryContainer: AppColors.tertiaryContainer,
      onTertiaryContainer: AppColors.onTertiaryContainer,
      error: AppColors.errorDark,
      onError: const Color(0xFF450A0A),
      errorContainer: AppColors.errorContainerDark,
      onErrorContainer: AppColors.onErrorContainerDark,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkText,
      surfaceContainerLowest: AppColors.darkBg,
      surfaceContainerLow: AppColors.darkSurface,
      surfaceContainer: AppColors.darkSurfaceElevated,
      surfaceContainerHigh: AppColors.darkSurfaceHigh,
      surfaceContainerHighest: AppColors.darkSurfaceHigh,
      surfaceDim: AppColors.darkBg,
      surfaceBright: AppColors.darkSurfaceHigh,
      inverseSurface: AppColors.lightSurface,
      inversePrimary: AppColors.primary,
      outline: AppColors.darkOutline,
      outlineVariant: AppColors.darkOutline.withValues(alpha: 0.5),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBg,
      fontFamily: AppTextStyles.bodyFont,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.primaryDark,
        selectionColor: AppColors.primaryDark.withValues(alpha: 0.3),
        selectionHandleColor: AppColors.primaryDark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurfaceElevated.withValues(alpha: 0.8),
        foregroundColor: AppColors.darkText,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0.5,
        titleTextStyle: AppTextStyles.displaySm.copyWith(
          color: AppColors.darkText,
        ),
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: BorderSide(
            color: AppColors.darkOutline.withValues(alpha: 0.3),
          ),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        clipBehavior: Clip.antiAlias,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: AppColors.onPrimary,
          disabledBackgroundColor: AppColors.darkOutline.withValues(alpha: 0.5),
          disabledForegroundColor: AppColors.darkTextMuted,
          minimumSize: const Size(double.infinity, AppSpacing.touchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          textStyle: AppTextStyles.button,
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size(double.infinity, AppSpacing.touchTarget),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          side: BorderSide(color: AppColors.primaryDark.withValues(alpha: 0.5)),
          disabledForegroundColor: AppColors.darkTextMuted,
          minimumSize: const Size(double.infinity, AppSpacing.touchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(
            color: AppColors.darkOutline.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(
            color: AppColors.primaryDark.withValues(alpha: 0.8),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.errorDark),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.errorDark, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(
            color: AppColors.darkOutline.withValues(alpha: 0.3),
          ),
        ),
        labelStyle: TextStyle(
          color: AppColors.darkTextMuted,
          fontFamily: AppTextStyles.bodyFont,
          fontSize: 14,
        ),
        floatingLabelStyle: TextStyle(
          color: AppColors.primaryDark,
          fontFamily: AppTextStyles.bodyFont,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: TextStyle(
          color: AppColors.darkTextMuted.withValues(alpha: 0.6),
          fontFamily: AppTextStyles.bodyFont,
          fontSize: 16,
        ),
        errorStyle: TextStyle(
          color: AppColors.errorDark,
          fontFamily: AppTextStyles.bodyFont,
          fontSize: 12,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.darkOutline.withValues(alpha: 0.4),
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurface,
        labelStyle: AppTextStyles.bodySm.copyWith(
          color: AppColors.darkText,
        ),
        secondaryLabelStyle: AppTextStyles.bodySm.copyWith(
          color: AppColors.darkTextMuted,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        side: BorderSide(color: AppColors.darkOutline.withValues(alpha: 0.4)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        showCheckmark: false,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primaryDark;
          return AppColors.darkTextMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryDark.withValues(alpha: 0.3);
          }
          return AppColors.darkOutline.withValues(alpha: 0.5);
        }),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primaryDark,
        linearTrackColor: AppColors.primaryDark.withValues(alpha: 0.2),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkSurfaceElevated.withValues(alpha: 0.95),
        indicatorColor: AppColors.primaryDark.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.labelSm.copyWith(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w700,
            );
          }
          return AppTextStyles.labelSm.copyWith(color: AppColors.darkTextMuted);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(size: 24, color: AppColors.primaryDark);
          }
          return IconThemeData(size: 24, color: AppColors.darkTextMuted);
        }),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.darkSurfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXl),
          ),
        ),
        elevation: 0,
        modalElevation: 0,
        showDragHandle: false,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkSurfaceHigh,
        contentTextStyle: AppTextStyles.bodySm.copyWith(color: AppColors.darkText),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkSurfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        elevation: 0,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayXL.copyWith(color: AppColors.darkText),
        displayMedium: AppTextStyles.displayLg.copyWith(color: AppColors.darkText),
        displaySmall: AppTextStyles.displayMd.copyWith(color: AppColors.darkText),
        headlineLarge: AppTextStyles.headline.copyWith(color: AppColors.darkText),
        headlineMedium: AppTextStyles.subtitle.copyWith(color: AppColors.darkText),
        headlineSmall: AppTextStyles.body.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
        ),
        titleLarge: AppTextStyles.displaySm.copyWith(color: AppColors.darkText),
        titleMedium: AppTextStyles.subtitle.copyWith(color: AppColors.darkText),
        titleSmall: AppTextStyles.bodySm.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.darkTextMuted,
        ),
        bodyLarge: AppTextStyles.body.copyWith(color: AppColors.darkText),
        bodyMedium: AppTextStyles.body.copyWith(color: AppColors.darkTextMuted),
        bodySmall: AppTextStyles.bodySm.copyWith(color: AppColors.darkTextMuted),
        labelLarge: AppTextStyles.label.copyWith(color: AppColors.darkText),
        labelMedium: AppTextStyles.bodySm.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.darkTextMuted,
        ),
        labelSmall: AppTextStyles.labelSm.copyWith(color: AppColors.darkTextMuted),
      ),
    );
  }
}
