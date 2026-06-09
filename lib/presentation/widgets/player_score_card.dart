import 'package:flutter/material.dart';
import '../../domain/entities/player.dart' as domain;
import '../theme/theme.dart';
import 'orchom_avatar.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isWinner
        ? AppColors.scoreGold
        : isLoser
            ? AppColors.scoreDanger
            : null;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: accentColor?.withValues(alpha: 0.08) ??
            (isDark ? AppColors.darkCard : AppColors.lightCard),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: accentColor != null
              ? accentColor.withValues(alpha: 0.3)
              : (isDark
                  ? AppColors.darkOutline.withValues(alpha: 0.3)
                  : AppColors.lightOutline.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        children: [
          OrchomAvatar(
            initials: player.name.isNotEmpty
                ? player.name[0]
                : '?',
            size: 40,
            winner: isWinner,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isWinner)
                  Row(
                    children: [
                      Icon(Icons.emoji_events_rounded, size: 14, color: AppColors.scoreGold),
                      const SizedBox(width: 4),
                      Text(
                        'Gagnant',
                        style: AppTextStyles.labelSm.copyWith(
                          color: AppColors.scoreGold,
                        ),
                      ),
                    ],
                  ),
                if (isLoser)
                  Row(
                    children: [
                      Icon(Icons.arrow_downward_rounded, size: 14, color: AppColors.scoreDanger),
                      const SizedBox(width: 4),
                      Text(
                        'Perdant',
                        style: AppTextStyles.labelSm.copyWith(
                          color: AppColors.scoreDanger,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Text(
            '${player.score}',
            style: AppTextStyles.scoreDisplaySm.copyWith(
              fontSize: 28,
              color: accentColor ??
                  (isDark ? AppColors.primaryDark : AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
