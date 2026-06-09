import 'package:flutter/material.dart';
import '../../domain/entities/quick_score_button.dart';
import '../theme/theme.dart';

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
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        splashColor: fgColor.withValues(alpha: 0.1),
        highlightColor: fgColor.withValues(alpha: 0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(
              color: fgColor.withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                button.label,
                style: AppTextStyles.label.copyWith(
                  color: fgColor,
                  fontSize: 13,
                ),
              ),
              Text(
                button.value > 0 ? '+${button.value}' : '${button.value}',
                style: AppTextStyles.labelSm.copyWith(
                  color: fgColor.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
