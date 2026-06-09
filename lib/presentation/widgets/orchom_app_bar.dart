import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class OrchomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;
  final Widget? leading;
  final VoidCallback? onBack;
  final Color? backgroundColor;
  final double elevation;
  final Widget? titleWidget;

  const OrchomAppBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.actions,
    this.leading,
    this.onBack,
    this.backgroundColor,
    this.elevation = 0,
    this.titleWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      backgroundColor: backgroundColor ??
          (isDark
              ? AppColors.darkSurfaceElevated.withValues(alpha: 0.75)
              : AppColors.lightSurface.withValues(alpha: 0.75)),
      foregroundColor: theme.appBarTheme.foregroundColor,
      elevation: elevation,
      centerTitle: true,
      scrolledUnderElevation: 0.5,
      surfaceTintColor: Colors.transparent,
      leading: showBack
          ? leading ??
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: onBack ?? () => Navigator.pop(context),
                splashRadius: AppSpacing.touchTargetSm / 2,
                style: IconButton.styleFrom(
                  backgroundColor: isDark
                      ? AppColors.glassDark
                      : AppColors.glassWhite,
                ),
              )
          : leading,
      title: titleWidget ??
          Text(
            title,
            style: AppTextStyles.displaySm.copyWith(
              color: theme.appBarTheme.foregroundColor,
            ),
          ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
