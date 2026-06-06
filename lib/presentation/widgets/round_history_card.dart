import 'package:flutter/material.dart';
import '../../domain/entities/player.dart' as domain;
import '../../domain/entities/round_score.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

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
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            child: Text(
              'Manche ${round.roundNumber}',
              style: AppTextStyles.labelMd.copyWith(
                fontSize: 13,
              ),
            ),
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
                final scoreColor = score < 0 ? AppColors.error : AppColors.primary;
                return Text(
                  '${player.name}: $score',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: scoreColor,
                    fontWeight: FontWeight.w500,
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
