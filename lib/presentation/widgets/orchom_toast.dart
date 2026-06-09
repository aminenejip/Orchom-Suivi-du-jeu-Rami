import 'package:flutter/material.dart';

enum ToastType { success, error, warning, info }

class OrchomToast {
  static void show({
    required BuildContext context,
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bgColor;
    Color iconColor;
    Color borderColor;
    IconData icon;

    switch (type) {
      case ToastType.success:
        bgColor = isDark
            ? const Color(0xFF064E3B)
            : const Color(0xFFD1FAE5);
        iconColor = isDark
            ? const Color(0xFF6EE7B7)
            : const Color(0xFF065F46);
        borderColor = isDark
            ? const Color(0xFF065F46)
            : const Color(0xFFA7F3D0);
        icon = Icons.check_circle_rounded;
      case ToastType.error:
        bgColor = isDark
            ? const Color(0xFF7F1D1D)
            : const Color(0xFFFEE2E2);
        iconColor = isDark
            ? const Color(0xFFFCA5A5)
            : const Color(0xFF991B1B);
        borderColor = isDark
            ? const Color(0xFF991B1B)
            : const Color(0xFFFECACA);
        icon = Icons.error_rounded;
      case ToastType.warning:
        bgColor = isDark
            ? const Color(0xFF78350F)
            : const Color(0xFFFEF3C7);
        iconColor = isDark
            ? const Color(0xFFFDE68A)
            : const Color(0xFF92400E);
        borderColor = isDark
            ? const Color(0xFF92400E)
            : const Color(0xFFFDE68A);
        icon = Icons.warning_amber_rounded;
      case ToastType.info:
        bgColor = isDark
            ? const Color(0xFF1A2235)
            : const Color(0xFFEFF6FF);
        iconColor = isDark
            ? const Color(0xFF93C5FD)
            : const Color(0xFF1D4ED8);
        borderColor = isDark
            ? const Color(0xFF2D3561)
            : const Color(0xFFBFDBFE);
        icon = Icons.info_rounded;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFFF1F0ED)
                      : const Color(0xFF1C1917),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor, width: 0.5),
        ),
        duration: duration,
        elevation: 4,
      ),
    );
  }
}
