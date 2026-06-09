import 'package:flutter/material.dart';
import '../../domain/entities/player.dart' as domain;
import '../../domain/entities/round_score.dart';
import '../theme/theme.dart';

class RoundHistoryCard extends StatelessWidget {
  final RoundScore round;
  final List<domain.Player> players;

  const RoundHistoryCard({
    required this.round,
    required this.players,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface.withValues(alpha: 0.5)
            : AppColors.lightSurfaceContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: isDark
              ? AppColors.darkOutline.withValues(alpha: 0.2)
              : AppColors.lightOutline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              'Manche ${round.roundNumber}',
              style: AppTextStyles.label.copyWith(
                fontSize: 13,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
          ),
          Container(
            width: 1,
            height: 24,
            color: isDark
                ? AppColors.darkOutline.withValues(alpha: 0.3)
                : AppColors.lightOutline.withValues(alpha: 0.3),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Wrap(
              spacing: 12,
              runSpacing: 4,
              children: round.scoresByPlayerId.entries.map((entry) {
                final player = players.firstWhere(
                  (p) => p.id == entry.key,
                  orElse: () => domain.Player(id: entry.key, name: '?'),
                );
                final score = entry.value;
                final scoreColor = score < 0
                    ? AppColors.scoreDanger
                    : score > 0
                        ? AppColors.scoreNormal
                        : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted);
                return Text(
                  '${player.name}: ${score > 0 ? '+' : ''}$score',
                  style: AppTextStyles.bodySm.copyWith(
                    color: scoreColor,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
