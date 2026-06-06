import 'dart:io';
import 'package:flutter/material.dart';
import '../../application/game_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'photo_preview_screen.dart';

class HistoryScreen extends StatefulWidget {
  final GameController controller;

  const HistoryScreen({required this.controller, super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
    widget.controller.loadHistory();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _deleteGame(String id) async {
    try {
      await widget.controller.deleteHistoryGame(id);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.controller.errorMessage ?? e.toString()),
        ),
      );
    }
  }

  Future<void> _clearHistory() async {
    try {
      await widget.controller.clearHistory();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.controller.errorMessage ?? e.toString()),
        ),
      );
    }
  }

  void _openPhoto(String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PhotoPreviewScreen(imagePath: imagePath),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
        actions: [
          if (widget.controller.history.isNotEmpty)
            IconButton(
              onPressed: _clearHistory,
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Vider historique',
            ),
        ],
      ),
      body: widget.controller.history.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.2),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Aucune partie terminée',
                    style: AppTextStyles.bodyMd.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: widget.controller.history.length,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              itemBuilder: (context, index) {
                final game = widget.controller.history[index];
                final winner = widget.controller.engine.getWinner(game);
                final loser = widget.controller.engine.getLoser(game);
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cardShadowColor.withValues(alpha: 0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              child: Text(
                                '${game.createdAt.day}/${game.createdAt.month}/${game.createdAt.year}',
                                style: AppTextStyles.labelMd.copyWith(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 20),
                              onPressed: () => _deleteGame(game.id),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          '${game.players.length} joueurs - Cible: ${game.config.targetScore}',
                          style: AppTextStyles.bodyMd.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          game.players
                              .map((p) => '${p.name}: ${p.score}')
                              .join(' | '),
                          style: AppTextStyles.bodyMd.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        if (winner != null)
                          Row(
                            children: [
                              Icon(Icons.emoji_events,
                                  size: 16, color: AppColors.secondary),
                              const SizedBox(width: 4),
                              Text(
                                'Gagnant: ${winner.name}',
                                style: AppTextStyles.bodyMd.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        if (loser != null)
                          Row(
                            children: [
                              const Icon(Icons.arrow_downward,
                                  size: 16, color: AppColors.error),
                              const SizedBox(width: 4),
                              Text(
                                'Perdant: ${loser.name}',
                                style: AppTextStyles.bodyMd.copyWith(
                                  color: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        if (game.finalComment != null &&
                            game.finalComment!.trim().isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.sm),
                          const Divider(height: 1),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Commentaire:',
                            style: AppTextStyles.labelMd.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            game.finalComment!,
                            style: AppTextStyles.bodyMd,
                          ),
                        ],
                        if (game.photoPaths.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.sm),
                          const Divider(height: 1),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Photos:',
                            style: AppTextStyles.labelMd.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          SizedBox(
                            height: 88,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: game.photoPaths.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(width: AppSpacing.sm),
                              itemBuilder: (context, i) {
                                final path = game.photoPaths[i];
                                return GestureDetector(
                                  onTap: () => _openPhoto(path),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      File(path),
                                      width: 88,
                                      height: 88,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) =>
                                          Container(
                                        width: 88,
                                        height: 88,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surfaceContainerHighest,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(Icons.broken_image),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
