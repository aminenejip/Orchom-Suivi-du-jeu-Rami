import 'package:flutter/material.dart';
import '../../application/game_controller.dart';
import '../../application/game_settings_controller.dart';
import '../../data/local/quick_button_audio_service.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';
import '../widgets/quick_score_button_widget.dart';
import '../widgets/round_history_card.dart';
import 'results_screen.dart';

class GameScreen extends StatefulWidget {
  final GameController controller;
  final GameSettingsController settingsController;
  final QuickButtonAudioService audioService;

  const GameScreen({
    required this.controller,
    required this.settingsController,
    required this.audioService,
    super.key,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final Map<String, TextEditingController> _scoreControllers = {};

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
    _initScoreControllers();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    for (final c in _scoreControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  void _initScoreControllers() {
    final session = widget.controller.currentSession;
    if (session == null) return;
    for (final player in session.players) {
      _scoreControllers.putIfAbsent(
        player.id,
        () => TextEditingController(),
      );
    }
  }

  Future<void> _validateRound() async {
    final session = widget.controller.currentSession;
    if (session == null) return;

    if (session.isFinished) {
      await _navigateToResults();
      return;
    }

    final scoresByPlayerId = <String, int>{};
    for (final player in session.players) {
      final text = _scoreControllers[player.id]?.text ?? '';
      final parsed = int.tryParse(text);
      if (parsed == null) {
        OrchomToast.show(
          context: context,
          message: 'Score invalide pour ${player.name}',
          type: ToastType.error,
        );
        return;
      }
      scoresByPlayerId[player.id] = parsed;
    }

    try {
      await widget.controller.addRound(scoresByPlayerId);
      if (!mounted) return;

      if (widget.controller.currentSession?.isFinished == true) {
        await _navigateToResults();
      } else {
        for (final c in _scoreControllers.values) {
          c.clear();
        }
      }
    } catch (e) {
      if (!mounted) return;
      OrchomToast.show(
        context: context,
        message: widget.controller.errorMessage ?? e.toString(),
        type: ToastType.error,
      );
    }
  }

  Future<void> _undoLastRound() async {
    try {
      await widget.controller.undoLastRound();
      if (!mounted) return;
      _initScoreControllers();
    } catch (e) {
      if (!mounted) return;
      OrchomToast.show(
        context: context,
        message: widget.controller.errorMessage ?? e.toString(),
        type: ToastType.error,
      );
    }
  }

  Future<void> _navigateToResults() async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultsScreen(
          controller: widget.controller,
          settingsController: widget.settingsController,
        ),
      ),
    );
  }

  void _setQuickScore(String playerId, int buttonValue, String soundId) {
    final currentText = _scoreControllers[playerId]?.text ?? '';
    final currentValue = int.tryParse(currentText) ?? 0;
    final newValue = currentValue + buttonValue;
    _scoreControllers[playerId]?.text = newValue.toString();
    widget.audioService.playBySoundId(soundId);
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.controller.currentSession;
    if (session == null) {
      return Scaffold(
        appBar: OrchomAppBar(title: 'Partie'),
        body: const OrchomEmptyState(
          icon: Icons.style_rounded,
          title: 'Aucune partie active',
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFinished = session.isFinished;
    final starter = widget.controller.getCurrentStarter();
    final ranking = widget.controller.getRanking();
    final quickButtons = session.config.quickScoreButtons;
    final reversedRounds = session.rounds.reversed.toList();
    final targetScore = session.config.targetScore;
    final roundLabel = isFinished
        ? 'Partie terminée'
        : 'Manche ${session.currentRound}';

    return Scaffold(
      appBar: OrchomAppBar(
        title: roundLabel,
        actions: [
          OrchomBadge(
            label: 'Cible: $targetScore',
            variant: BadgeVariant.gold,
          ),
          const SizedBox(width: AppSpacing.md),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStarterBanner(starter, isDark),
              const SizedBox(height: AppSpacing.md),
              _buildRankingSection(ranking, targetScore, isDark),
              const SizedBox(height: AppSpacing.lg),
              _buildScoreInputSection(session, quickButtons, isFinished, isDark),
              const SizedBox(height: AppSpacing.md),
              _buildActionButtons(isFinished, session, isDark),
              if (reversedRounds.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                _buildHistorySection(reversedRounds, session, isDark),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStarterBanner(dynamic starter, bool isDark) {
    return OrchomCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: (isDark ? AppColors.primaryDark : AppColors.primary)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.person_rounded,
              size: 18,
              color: isDark ? AppColors.primaryDark : AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Donneur: ${starter?.name ?? '-'}',
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankingSection(
      List<dynamic> ranking, int targetScore, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OrchomSectionTitle(title: 'Classement'),
        const SizedBox(height: AppSpacing.sm),
        ...ranking.asMap().entries.map((entry) {
          final index = entry.key;
          final p = entry.value;
          final isPlayerWinner = p.score >= targetScore;
          final scoreColor = isPlayerWinner
              ? AppColors.scoreDanger
              : p.score >= targetScore * 0.8
                  ? AppColors.scoreWarning
                  : null;

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: OrchomCard(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.sm,
              ),
              color: scoreColor?.withValues(alpha: 0.06),
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    child: Text(
                      '#${index + 1}',
                      style: AppTextStyles.label.copyWith(
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  OrchomAvatar(
                    initials: p.name.isNotEmpty ? p.name[0] : '?',
                    size: 36,
                    winner: isPlayerWinner,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      p.name,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isPlayerWinner)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Icon(
                        Icons.emoji_events_rounded,
                        size: 18,
                        color: AppColors.scoreGold,
                      ),
                    ),
                  Text(
                    '${p.score}',
                    style: AppTextStyles.scoreDisplaySm.copyWith(
                      fontSize: 28,
                      color: scoreColor ??
                          (isDark ? AppColors.primaryDark : AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildScoreInputSection(
      dynamic session, List<dynamic> quickButtons, bool isFinished, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OrchomSectionTitle(
          title: 'Saisie des scores',
          subtitle: isFinished ? 'Partie terminée' : 'Entre le score de chaque joueur',
        ),
        const SizedBox(height: AppSpacing.sm),
        ...session.players.map((player) {
          final ctrl = _scoreControllers[player.id] ?? TextEditingController();
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: OrchomCard(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      OrchomAvatar(
                        initials: player.name.isNotEmpty ? player.name[0] : '?',
                        size: 32,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          player.name,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: (isDark ? AppColors.primaryDark : AppColors.primary)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Score: ${player.score}',
                          style: AppTextStyles.label.copyWith(
                            fontSize: 13,
                            color: isDark ? AppColors.primaryDark : AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: TextField(
                          controller: ctrl,
                          keyboardType: TextInputType.number,
                          readOnly: isFinished,
                          style: AppTextStyles.scoreDisplaySm.copyWith(
                            fontSize: 24,
                            height: 28 / 24,
                          ),
                          decoration: InputDecoration(
                            hintText: '0',
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusSm,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      if (!isFinished)
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: quickButtons.map((btn) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: QuickScoreButtonWidget(
                                    button: btn,
                                    onPressed: () => _setQuickScore(
                                      player.id,
                                      btn.value,
                                      btn.soundId,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildActionButtons(bool isFinished, dynamic session, bool isDark) {
    return Column(
      children: [
        OrchomButton(
          label: isFinished ? 'Voir les résultats' : 'Valider la manche',
          icon: isFinished ? Icons.visibility_rounded : Icons.check_circle_rounded,
          onPressed: isFinished ? _navigateToResults : _validateRound,
          height: 56,
        ),
        if (!isFinished && session.rounds.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: OrchomButton(
              label: 'Annuler dernière manche',
              icon: Icons.undo_rounded,
              variant: ButtonVariant.outline,
              onPressed: _undoLastRound,
            ),
          ),
      ],
    );
  }

  Widget _buildHistorySection(
      List<dynamic> reversedRounds, dynamic session, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            OrchomSectionTitle(
              title: 'Historique',
              subtitle: '${session.rounds.length} manche(s)',
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: (isDark ? AppColors.primaryDark : AppColors.primary)
                    .withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.timeline_rounded,
                size: 18,
                color: isDark ? AppColors.primaryDark : AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ...reversedRounds.map(
          (round) => RoundHistoryCard(
            round: round,
            players: session.players,
          ),
        ),
      ],
    );
  }
}
