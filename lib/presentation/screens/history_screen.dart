import 'dart:io';
import 'package:flutter/material.dart';
import '../../application/game_controller.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';
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
    final confirm = await OrchomDialog.confirm(
      context: context,
      title: 'Supprimer',
      message: 'Supprimer cette partie de l\'historique ?',
      confirmLabel: 'Supprimer',
      isDestructive: true,
    );
    if (confirm != true) return;

    try {
      await widget.controller.deleteHistoryGame(id);
      if (!mounted) return;
      OrchomToast.show(
        context: context,
        message: 'Partie supprimée',
        type: ToastType.success,
      );
    } catch (e) {
      if (!mounted) return;
      OrchomToast.show(
        context: context,
        message: widget.controller.errorMessage ?? 'Erreur',
        type: ToastType.error,
      );
    }
  }

  Future<void> _clearHistory() async {
    final confirm = await OrchomDialog.confirm(
      context: context,
      title: 'Vider l\'historique',
      message: 'Toutes les parties seront supprimées définitivement.',
      confirmLabel: 'Tout supprimer',
      isDestructive: true,
    );
    if (confirm != true) return;

    try {
      await widget.controller.clearHistory();
      if (!mounted) return;
      OrchomToast.show(
        context: context,
        message: 'Historique vidé',
        type: ToastType.success,
      );
    } catch (e) {
      if (!mounted) return;
      OrchomToast.show(
        context: context,
        message: widget.controller.errorMessage ?? 'Erreur',
        type: ToastType.error,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final history = widget.controller.history;
    final isLoading = widget.controller.isLoading;

    return Scaffold(
      appBar: OrchomAppBar(
        title: 'Historique',
        actions: [
          if (history.isNotEmpty)
            IconButton(
              onPressed: _clearHistory,
              icon: const Icon(Icons.delete_sweep_rounded),
              tooltip: 'Vider l\'historique',
              splashRadius: 22,
              style: IconButton.styleFrom(
                backgroundColor: isDark ? AppColors.glassDark : AppColors.glassWhite,
              ),
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppColors.darkBg, AppColors.darkSurface]
                : [AppColors.lightBg, AppColors.lightSurfaceContainer],
          ),
        ),
        child: isLoading
            ? ListView.builder(
                itemCount: 3,
                itemBuilder: (_, _) => const OrchomSkeletonCard(),
              )
            : history.isEmpty
                ? OrchomEmptyState(
                    icon: Icons.history_rounded,
                    title: 'Aucune partie terminée',
                    subtitle:
                        'Terminez une partie pour la voir apparaître ici',
                  )
                : ListView.builder(
                    itemCount: history.length,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final game = history[index];
                      final winner = widget.controller.engine.getWinner(game);
                      final loser = widget.controller.engine.getLoser(game);

                      return OrchomCard(
                        margin: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.xs,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                OrchomBadge(
                                  label:
                                      '${game.createdAt.day}/${game.createdAt.month}/${game.createdAt.year}',
                                  variant: BadgeVariant.primary,
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete_rounded,
                                    size: 20,
                                    color: isDark
                                        ? AppColors.darkTextMuted
                                        : AppColors.lightTextMuted,
                                  ),
                                  onPressed: () => _deleteGame(game.id),
                                  splashRadius: 18,
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Row(
                              children: [
                                Icon(
                                  Icons.people_rounded,
                                  size: 16,
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${game.players.length} joueurs',
                                  style: AppTextStyles.bodySm.copyWith(
                                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Icon(
                                  Icons.flag_rounded,
                                  size: 16,
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Cible: ${game.config.targetScore}',
                                  style: AppTextStyles.bodySm.copyWith(
                                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              game.players
                                  .map((p) => '${p.name}: ${p.score}')
                                  .join(' | '),
                              style: AppTextStyles.bodySm.copyWith(
                                color: isDark ? AppColors.darkText : AppColors.lightText,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            if (winner != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: AppColors.scoreGold.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Icon(Icons.emoji_events_rounded,
                                          size: 14, color: AppColors.scoreGold),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Gagnant: ${winner.name}',
                                      style: AppTextStyles.bodySm.copyWith(
                                        color: AppColors.scoreGold,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (loser != null)
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: AppColors.scoreDanger.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Icon(Icons.arrow_downward_rounded,
                                        size: 14, color: AppColors.scoreDanger),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Perdant: ${loser.name}',
                                    style: AppTextStyles.bodySm.copyWith(
                                      color: AppColors.scoreDanger,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            if (game.finalComment != null &&
                                game.finalComment!.trim().isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.sm),
                              Divider(
                                height: 1,
                                color: isDark ? AppColors.darkOutline : AppColors.lightOutline,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.format_quote_rounded,
                                    size: 16,
                                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      game.finalComment!,
                                      style: AppTextStyles.bodySm.copyWith(
                                        fontStyle: FontStyle.italic,
                                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (game.photoPaths.isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.sm),
                              SizedBox(
                                height: 80,
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
                                        borderRadius: BorderRadius.circular(
                                            AppSpacing.radiusMd),
                                        child: Image.file(
                                          File(path),
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, _, _) =>
                                              Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              color: isDark
                                                  ? AppColors.darkSurfaceHigh
                                                  : AppColors.lightSurfaceHigh,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppSpacing.radiusMd),
                                            ),
                                            child: Icon(
                                              Icons.broken_image_rounded,
                                              color: isDark
                                                  ? AppColors.darkTextMuted
                                                  : AppColors.lightTextMuted,
                                            ),
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
                      );
                    },
                  ),
      ),
    );
  }
}
