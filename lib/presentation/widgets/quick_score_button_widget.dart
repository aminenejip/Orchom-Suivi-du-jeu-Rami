import 'package:flutter/material.dart';
import '../../domain/entities/quick_score_button.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class QuickScoreButtonWidget extends StatelessWidget {
  final QuickScoreButton button;
  final VoidCallback onPressed;

  const QuickScoreButtonWidget({
    required this.button,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = button.value >= 0;
    final bgColor = isPositive
        ? AppColors.primary.withValues(alpha: 0.1)
        : AppColors.error.withValues(alpha: 0.1);
    final fgColor = isPositive ? AppColors.primary : AppColors.error;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            button.label,
            style: AppTextStyles.labelMd.copyWith(
              color: fgColor,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
