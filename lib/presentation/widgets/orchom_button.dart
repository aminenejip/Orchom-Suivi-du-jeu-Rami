import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';

class OrchomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isOutlined;
  final bool isDanger;
  final bool isFullWidth;

  const OrchomButton({
    required this.label,
    this.onPressed,
    this.icon,
    this.isOutlined = false,
    this.isDanger = false,
    this.isFullWidth = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final style = isOutlined
        ? OutlinedButton.styleFrom(
            foregroundColor: isDanger
                ? Theme.of(context).colorScheme.error
                : null,
            side: isDanger
                ? BorderSide(color: Theme.of(context).colorScheme.error)
                : null,
            minimumSize: Size(
              isFullWidth ? double.infinity : 0,
              AppSpacing.touchTarget,
            ),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: isDanger
                ? Theme.of(context).colorScheme.error
                : null,
            minimumSize: Size(
              isFullWidth ? double.infinity : 0,
              AppSpacing.touchTarget,
            ),
          );

    final button = isOutlined
        ? OutlinedButton.icon(
            onPressed: onPressed,
            icon: icon != null ? Icon(icon, size: 20) : const SizedBox.shrink(),
            label: Text(label),
            style: style,
          )
        : ElevatedButton.icon(
            onPressed: onPressed,
            icon: icon != null ? Icon(icon, size: 20) : const SizedBox.shrink(),
            label: Text(label),
            style: style,
          );

    return SizedBox(width: isFullWidth ? double.infinity : null, child: button);
  }
}
