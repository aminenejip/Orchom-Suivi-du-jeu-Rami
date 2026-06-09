import 'package:flutter/material.dart';
import '../theme/theme.dart';

class OrchomSectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const OrchomSectionTitle({
    required this.title,
    this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.displaySm.copyWith(
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: AppTextStyles.bodySm.copyWith(
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ],
    );
  }
}
