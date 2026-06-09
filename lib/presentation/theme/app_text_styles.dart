import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static String get displayFont => GoogleFonts.playfairDisplay().fontFamily!;
  static String get bodyFont => GoogleFonts.dmSans().fontFamily!;

  static TextStyle get displayXL => GoogleFonts.playfairDisplay(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 48 / 40,
        letterSpacing: -0.03,
      );

  static TextStyle get displayLg => GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 40 / 32,
        letterSpacing: -0.02,
      );

  static TextStyle get displayMd => GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 36 / 28,
        letterSpacing: -0.01,
      );

  static TextStyle get displaySm => GoogleFonts.playfairDisplay(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
      );

  static TextStyle get headline => GoogleFonts.dmSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 32 / 24,
        letterSpacing: -0.01,
      );

  static TextStyle get subtitle => GoogleFonts.dmSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 28 / 18,
      );

  static TextStyle get body => GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
      );

  static TextStyle get bodySm => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
      );

  static TextStyle get label => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        letterSpacing: 0.03,
      );

  static TextStyle get labelSm => GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 16 / 12,
        letterSpacing: 0.05,
      );

  static TextStyle get scoreDisplay => GoogleFonts.dmSans(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        height: 48 / 48,
        letterSpacing: -0.04,
      );

  static TextStyle get scoreDisplaySm => GoogleFonts.dmSans(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        height: 36 / 32,
        letterSpacing: -0.03,
      );

  static TextStyle get button => GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 24 / 16,
        letterSpacing: 0.02,
      );

  static TextStyle heading(BuildContext context) =>
      Theme.of(context).textTheme.headlineMedium!.copyWith(
            fontFamily: displayFont,
            fontWeight: FontWeight.w700,
          );

  static TextStyle title(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
          );

  static TextStyle subtitleText(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w500,
          );

  static TextStyle bodyText(BuildContext context) =>
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

  static TextStyle scoreGoldStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: AppColors.scoreGold,
            fontWeight: FontWeight.bold,
          );
}
