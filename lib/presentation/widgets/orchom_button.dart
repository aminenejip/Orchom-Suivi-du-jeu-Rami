import 'package:flutter/material.dart';
import '../theme/app_animations.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

enum ButtonVariant { primary, secondary, outline, ghost, danger, glass }

class OrchomButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final ButtonVariant variant;
  final bool fullWidth;
  final bool loading;
  final bool disabled;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final EdgeInsets? padding;

  const OrchomButton({
    super.key,
    required this.label,
    this.icon,
    this.variant = ButtonVariant.primary,
    this.fullWidth = true,
    this.loading = false,
    this.disabled = false,
    this.onPressed,
    this.width,
    this.height,
    this.padding,
  });

  @override
  State<OrchomButton> createState() => _OrchomButtonState();
}

class _OrchomButtonState extends State<OrchomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isActive = !widget.disabled && !widget.loading;

    Color bgColor;
    Color fgColor;
    Color? borderColor;
    List<BoxShadow>? shadows;

    switch (widget.variant) {
      case ButtonVariant.primary:
        bgColor = isDark ? AppColors.primaryDark : AppColors.primary;
        fgColor = AppColors.onPrimary;
        borderColor = null;
        shadows = isDark ? AppShadows.buttonDark : AppShadows.buttonLight;
      case ButtonVariant.secondary:
        bgColor = isDark
            ? AppColors.secondaryContainerDark
            : AppColors.secondaryContainer;
        fgColor = isDark
            ? AppColors.onSecondaryContainerDark
            : AppColors.onSecondaryContainer;
        borderColor = null;
      case ButtonVariant.outline:
        bgColor = Colors.transparent;
        fgColor = isDark ? AppColors.primaryDark : AppColors.primary;
        borderColor = isDark
            ? AppColors.primaryDark.withValues(alpha: 0.5)
            : AppColors.primary.withValues(alpha: 0.5);
      case ButtonVariant.ghost:
        bgColor = Colors.transparent;
        fgColor = isDark ? AppColors.darkText : AppColors.lightText;
        borderColor = null;
      case ButtonVariant.danger:
        bgColor = isDark ? AppColors.errorContainerDark : AppColors.errorContainer;
        fgColor = isDark ? AppColors.onErrorContainerDark : AppColors.onErrorContainer;
        borderColor = null;
      case ButtonVariant.glass:
        bgColor = isDark ? AppColors.glassDark : AppColors.glassWhite;
        fgColor = isDark ? AppColors.darkText : AppColors.lightText;
        borderColor = isDark ? AppColors.glassStrokeDark : AppColors.glassStroke;
        shadows = isDark ? AppShadows.glassDark : AppShadows.glassLight;
    }

    if (widget.disabled) {
      bgColor = bgColor.withValues(alpha: 0.4);
      fgColor = fgColor.withValues(alpha: 0.4);
    }

    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) => Transform.scale(
        scale: _scale.value,
        child: child,
      ),
      child: GestureDetector(
        onTapDown: isActive
            ? (_) {
                _controller.forward();
              }
            : null,
        onTapUp: isActive
            ? (_) {
                _controller.reverse();
                widget.onPressed?.call();
              }
            : null,
        onTapCancel: isActive
            ? () {
                _controller.reverse();
              }
            : null,
        child: Container(
          width: widget.fullWidth ? double.infinity : widget.width,
          height: widget.height ?? AppSpacing.touchTarget,
          padding: widget.padding ??
              const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: borderColor != null
                ? Border.all(color: borderColor)
                : null,
            boxShadow: shadows,
          ),
          child: Center(
            child: widget.loading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: fgColor,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, size: 20, color: fgColor),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      Flexible(
                        child: Text(
                          widget.label,
                          style: AppTextStyles.button.copyWith(color: fgColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
