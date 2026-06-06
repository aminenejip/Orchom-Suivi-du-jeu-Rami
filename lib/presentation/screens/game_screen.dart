import 'package:flutter/material.dart';
import '../../application/game_controller.dart';
import '../../application/game_settings_controller.dart';
import '../../data/local/quick_button_audio_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Score invalide pour ${player.name}')),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.controller.errorMessage ?? e.toString()),
        ),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.controller.errorMessage ?? e.toString()),
        ),
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
        appBar: AppBar(title: const Text('Partie')),
        body: const Center(child: Text('Aucune partie active')),
      );
    }

    final isFinished = session.isFinished;
    final starter = widget.controller.getCurrentStarter();
    final ranking = widget.controller.getRanking();
    final quickButtons = session.config.quickScoreButtons;
    final reversedRounds = session.rounds.reversed.toList();
    final targetScore = session.config.targetScore;

    return Scaffold(
      appBar: AppBar(
        title: Text('Manche ${session.currentRound}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person, size: 20, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Donneur: ${starter?.name ?? '-'}',
                    style: AppTextStyles.bodyMd.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      'Cible: $targetScore',
                      style: AppTextStyles.labelMd.copyWith(
                        fontSize: 12,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Classement',
              style: AppTextStyles.headlineMd.copyWith(
                fontSize: 20,
                height: 28 / 20,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...ranking.map((p) {
              final isPlayerWinner = p.score >= targetScore;
              final scoreColor = isPlayerWinner
                  ? AppColors.error
                  : p.score >= targetScore * 0.8
                      ? AppColors.secondary
                      : null;
              return Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: scoreColor?.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: scoreColor != null
                      ? Border.all(color: scoreColor.withValues(alpha: 0.25))
                      : Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .outlineVariant
                              .withValues(alpha: 0.3),
                        ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(p.name,
                          style: AppTextStyles.bodyMd),
                    ),
                    Text(
                      '${p.score}',
                      style: AppTextStyles.scoreDisplay.copyWith(
                        fontSize: 28,
                        height: 28 / 28,
                        color: scoreColor ?? AppColors.primary,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: AppSpacing.lg),
            ...session.players.map((player) {
              final ctrl = _scoreControllers[player.id] ??
                  TextEditingController();
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            player.name,
                            style: AppTextStyles.bodyMd.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          'Score: ${player.score}',
                          style: AppTextStyles.bodyMd.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                            decoration: const InputDecoration(
                              hintText: 'Score',
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
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
                                    padding:
                                        const EdgeInsets.only(right: 6),
                                    child: QuickScoreButtonWidget(
                                      button: btn,
                                      onPressed: () => _setQuickScore(
                                          player.id, btn.value, btn.soundId),
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
              );
            }),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: isFinished ? _navigateToResults : _validateRound,
                icon: Icon(isFinished ? Icons.visibility : Icons.check_circle),
                label: Text(
                    isFinished ? 'Voir les résultats' : 'Valider la manche'),
              ),
            ),
            if (!isFinished && session.rounds.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _undoLastRound,
                    icon: const Icon(Icons.undo, size: 18),
                    label: const Text('Annuler dernière manche'),
                  ),
                ),
              ),
            if (reversedRounds.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Historique des manches (${session.rounds.length})',
                style: AppTextStyles.headlineMd.copyWith(
                  fontSize: 20,
                  height: 28 / 20,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ...reversedRounds.map(
                  (round) => RoundHistoryCard(round: round, players: session.players)),
            ],
          ],
        ),
      ),
    );
  }
}
