import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

class OrchomAvatar extends StatelessWidget {
  final String initials;
  final Color? backgroundColor;
  final Color? textColor;
  final double size;
  final String? imagePath;
  final bool winner;

  const OrchomAvatar({
    super.key,
    required this.initials,
    this.backgroundColor,
    this.textColor,
    this.size = 48,
    this.imagePath,
    this.winner = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ??
            (winner
                ? const Color(0xFFD4A853)
                : (isDark
                    ? const Color(0xFF2D3561)
                    : const Color(0xFFD6D3D1))),
        borderRadius: BorderRadius.circular(size / 2),
        border: winner
            ? Border.all(
                color: const Color(0xFFD4A853).withValues(alpha: 0.6),
                width: 2,
              )
            : null,
        boxShadow: winner
            ? [
                BoxShadow(
                  color: const Color(0xFFD4A853).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          initials.length > 2 ? initials.substring(0, 2).toUpperCase() : initials.toUpperCase(),
          style: TextStyle(
            fontFamily: AppTextStyles.bodyFont,
            fontSize: size * 0.4,
            fontWeight: FontWeight.w700,
            color: textColor ??
                (winner
                    ? const Color(0xFF1C1917)
                    : (isDark
                        ? const Color(0xFFF1F0ED)
                        : const Color(0xFF1C1917))),
          ),
        ),
      ),
    );
  }
}
