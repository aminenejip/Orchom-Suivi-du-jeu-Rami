import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

enum BadgeVariant { primary, success, warning, danger, neutral, gold }

class OrchomBadge extends StatelessWidget {
  final String label;
  final BadgeVariant variant;
  final double fontSize;
  final EdgeInsetsGeometry? padding;
  final IconData? icon;

  const OrchomBadge({
    super.key,
    required this.label,
    this.variant = BadgeVariant.neutral,
    this.fontSize = 12,
    this.padding,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bgColor;
    Color textColor;

    switch (variant) {
      case BadgeVariant.primary:
        bgColor = isDark
            ? const Color(0xFF064E3B)
            : const Color(0xFFD1FAE5);
        textColor = isDark
            ? const Color(0xFFD1FAE5)
            : const Color(0xFF022C22);
      case BadgeVariant.success:
        bgColor = isDark
            ? const Color(0xFF064E3B)
            : const Color(0xFFD1FAE5);
        textColor = isDark
            ? const Color(0xFF6EE7B7)
            : const Color(0xFF065F46);
      case BadgeVariant.warning:
        bgColor = isDark
            ? const Color(0xFF78350F)
            : const Color(0xFFFEF3C7);
        textColor = isDark
            ? const Color(0xFFFDE68A)
            : const Color(0xFF92400E);
      case BadgeVariant.danger:
        bgColor = isDark
            ? const Color(0xFF7F1D1D)
            : const Color(0xFFFEE2E2);
        textColor = isDark
            ? const Color(0xFFFCA5A5)
            : const Color(0xFF991B1B);
      case BadgeVariant.neutral:
        bgColor = isDark
            ? const Color(0xFF2D3561)
            : const Color(0xFFF5F0EB);
        textColor = isDark
            ? const Color(0xFF8B8FA3)
            : const Color(0xFF78716C);
      case BadgeVariant.gold:
        bgColor = const Color(0xFFD4A853).withValues(alpha: 0.2);
        textColor = const Color(0xFFD4A853);
    }

    return Container(
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xxs,
          ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: fontSize + 2, color: textColor),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppTextStyles.bodyFont,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                    height: 1.2,
                  ),
                ),
              ],
            )
          : Text(
              label,
              style: TextStyle(
                fontFamily: AppTextStyles.bodyFont,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: textColor,
                height: 1.2,
              ),
            ),
    );
  }
}
