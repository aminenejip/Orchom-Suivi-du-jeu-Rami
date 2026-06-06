import 'package:flutter/material.dart';
import '../../application/game_controller.dart';
import '../../application/game_settings_controller.dart';
import '../../domain/entities/player.dart';
import '../../domain/entities/round_score.dart';
import '../../domain/entities/quick_score_button.dart';
import 'results_screen.dart';

class GameScreen extends StatefulWidget {
  final GameController controller;
  final GameSettingsController settingsController;

  const GameScreen({
    required this.controller,
    required this.settingsController,
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

  void _setQuickScore(String playerId, int buttonValue) {
    final currentText = _scoreControllers[playerId]?.text ?? '';
    final currentValue = int.tryParse(currentText) ?? 0;
    final newValue = currentValue + buttonValue;
    _scoreControllers[playerId]?.text = newValue.toString();
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Manche ${session.currentRound}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Donneur: ${starter?.name ?? '-'}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Classement:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            ...ranking.map((p) => Text('${p.name}: ${p.score}')),
            const SizedBox(height: 16),
            ...session.players.map((player) {
              final ctrl = _scoreControllers[player.id] ?? TextEditingController();
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${player.name} (${player.score})',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: TextField(
                            controller: ctrl,
                            keyboardType: TextInputType.number,
                            readOnly: isFinished,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                        if (!isFinished) ...[
                          const SizedBox(width: 4),
                          ...quickButtons.map((btn) => _quickButton(player.id, btn)),
                        ],
                      ],
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isFinished ? _navigateToResults : _validateRound,
                child: Text(isFinished ? 'Voir les résultats' : 'Valider la manche'),
              ),
            ),
            const SizedBox(height: 8),
            if (!isFinished && session.rounds.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _undoLastRound,
                  child: const Text('Annuler dernière manche'),
                ),
              ),
            if (reversedRounds.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                'Historique des manches (${session.rounds.length}):',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ...reversedRounds.map((round) => _buildRoundHistory(round, session.players)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _quickButton(String playerId, QuickScoreButton button) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: TextButton(
        onPressed: () => _setQuickScore(playerId, button.value),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(button.label),
      ),
    );
  }

  Widget _buildRoundHistory(RoundScore round, List<Player> players) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text('Manche ${round.roundNumber}: '),
          ...round.scoresByPlayerId.entries.map((entry) {
            final player = players.firstWhere(
              (p) => p.id == entry.key,
              orElse: () => Player(id: entry.key, name: '?'),
            );
            return Text('${player.name}=${entry.value}  ');
          }),
        ],
      ),
    );
  }
}
