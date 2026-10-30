import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class LoadingScreen extends StatelessWidget {
  final String? message;
  final bool showLogo;

  const LoadingScreen({
    super.key,
    this.message,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBg : AppColors.lightBg;
    final mutedColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final primaryColor = isDark ? AppColors.primaryDark : AppColors.primary;

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showLogo) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/images/orchom_logo.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
              SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  strokeCap: StrokeCap.round,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                message ?? 'Chargement…',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                  height: 22 / 15,
                  color: mutedColor,
                  fontFamily: 'serif',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
