import 'package:flutter/material.dart';
import '../../application/game_controller.dart';
import '../../application/game_settings_controller.dart';
import '../../domain/entities/game_config.dart';
import '../../domain/entities/game_session.dart';
import '../../domain/entities/player.dart';
import 'game_screen.dart';

class SetupScreen extends StatefulWidget {
  final GameController controller;
  final GameSettingsController settingsController;

  const SetupScreen({
    required this.controller,
    required this.settingsController,
    super.key,
  });

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _formKey = GlobalKey<FormState>();
  int _playerCount = 2;
  final _nameControllers = <TextEditingController>[];
  final _targetScoreController = TextEditingController(text: '100');

  @override
  void initState() {
    super.initState();
    _initNameControllers();
  }

  @override
  void dispose() {
    for (final c in _nameControllers) {
      c.dispose();
    }
    _targetScoreController.dispose();
    super.dispose();
  }

  void _initNameControllers() {
    _nameControllers.clear();
    for (int i = 0; i < _playerCount; i++) {
      _nameControllers.add(TextEditingController());
    }
  }

  void _onPlayerCountChanged(int? value) {
    if (value == null) return;
    setState(() {
      _playerCount = value;
      _initNameControllers();
    });
  }

  Future<void> _startGame() async {
    if (!_formKey.currentState!.validate()) return;

    final targetScore = int.tryParse(_targetScoreController.text) ?? 100;
    final settings = widget.settingsController.settings;

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final config = GameConfig(
      targetScore: targetScore,
      ghaltaPenalty: settings.defaultGhaltaPenalty,
      playerCount: _playerCount,
      starterMode: settings.defaultStarterMode,
      quickScoreButtons: settings.quickScoreButtons,
    );

    final players = <Player>[];
    for (int i = 0; i < _playerCount; i++) {
      final name = _nameControllers[i].text.trim();
      players.add(Player(
        id: 'player_${i}_$id',
        name: name,
      ));
    }

    final session = GameSession(
      id: id,
      config: config,
      players: players,
      currentRound: 1,
      starterIndex: 0,
      isFinished: false,
      createdAt: DateTime.now(),
    );

    try {
      await widget.controller.startNewGame(session);
      if (!mounted) return;
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => GameScreen(
            controller: widget.controller,
            settingsController: widget.settingsController,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.controller.errorMessage ?? e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle partie'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nombre de joueurs'),
              const SizedBox(height: 8),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 2, label: Text('2')),
                  ButtonSegment(value: 4, label: Text('4')),
                ],
                selected: {_playerCount},
                onSelectionChanged: (value) => _onPlayerCountChanged(value.first),
              ),
              const SizedBox(height: 16),
              ...List.generate(_playerCount, (i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    controller: _nameControllers[i],
                    decoration: InputDecoration(
                      labelText: 'Joueur ${i + 1}',
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nom requis';
                      }
                      return null;
                    },
                  ),
                );
              }),
              const SizedBox(height: 16),
              TextFormField(
                controller: _targetScoreController,
                decoration: const InputDecoration(
                  labelText: 'Score cible',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final n = int.tryParse(value ?? '');
                  if (n == null || n < 1 || n > 10000) {
                    return 'Entre 1 et 10000';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _startGame,
                  child: const Text('Lancer la partie'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
