import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';

class OrchomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final Color? color;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool elevated;
  final bool glass;

  const OrchomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.color,
    this.onTap,
    this.onLongPress,
    this.elevated = false,
    this.glass = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    final radius = borderRadius ?? AppSpacing.radiusLg;
    final effectiveColor = color ?? (glass
        ? (isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurface)
        : theme.cardTheme.color);
    final effectiveShadows = glass
        ? (isDark ? AppShadows.glassDark : AppShadows.glassLight)
        : elevated
            ? (isDark ? AppShadows.cardElevatedDark : AppShadows.cardElevatedLight)
            : (isDark ? AppShadows.cardDark : AppShadows.cardLight);

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        color: effectiveColor,
        borderRadius: BorderRadius.circular(radius),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(radius),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              border: glass
                  ? Border.all(
                      color: isDark ? AppColors.glassStrokeDark : AppColors.glassStroke,
                    )
                  : null,
              boxShadow: effectiveShadows,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Padding(
                padding: padding ?? const EdgeInsets.all(AppSpacing.md),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
