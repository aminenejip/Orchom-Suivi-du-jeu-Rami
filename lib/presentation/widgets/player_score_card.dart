import 'package:flutter/material.dart';
import '../../domain/entities/player.dart' as domain;
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class PlayerScoreCard extends StatelessWidget {
  final domain.Player player;
  final bool isWinner;
  final bool isLoser;

  const PlayerScoreCard({
    required this.player,
    this.isWinner = false,
    this.isLoser = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = isWinner
        ? AppColors.primary
        : isLoser
            ? AppColors.error
            : null;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: accentColor?.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: accentColor != null
            ? Border.all(color: accentColor.withValues(alpha: 0.25))
            : Border.all(
                color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              player.name,
              style: AppTextStyles.bodyMd.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '${player.score}',
            style: AppTextStyles.scoreDisplay.copyWith(
              fontSize: 32,
              height: 32 / 32,
              color: accentColor ?? AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
