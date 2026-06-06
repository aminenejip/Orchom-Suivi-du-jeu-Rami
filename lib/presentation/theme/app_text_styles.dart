import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Inter';

  static const TextStyle headlineLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 40 / 32,
    letterSpacing: -0.02,
  );

  static const TextStyle headlineLgMobile = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 36 / 28,
  );

  static const TextStyle headlineMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
  );

  static const TextStyle scoreDisplay = TextStyle(
    fontFamily: fontFamily,
    fontSize: 48,
    fontWeight: FontWeight.w800,
    height: 48 / 48,
    letterSpacing: -0.04,
  );

  static const TextStyle bodyLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 28 / 18,
  );

  static const TextStyle bodyMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );

  static const TextStyle labelMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    letterSpacing: 0.05,
  );

  static TextStyle headline(BuildContext context) =>
      Theme.of(context).textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.bold,
          );

  static TextStyle title(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
          );

  static TextStyle subtitle(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w500,
          );

  static TextStyle body(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge!;

  static TextStyle scoreNormalStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: AppColors.scoreNormal,
            fontWeight: FontWeight.bold,
          );

  static TextStyle scoreWarningStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: AppColors.scoreWarning,
            fontWeight: FontWeight.bold,
          );

  static TextStyle scoreDangerStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: AppColors.scoreDanger,
            fontWeight: FontWeight.bold,
          );
}
