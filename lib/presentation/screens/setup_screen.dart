import 'package:flutter/material.dart';
import '../../application/game_controller.dart';
import '../../application/game_settings_controller.dart';
import '../../data/local/quick_button_audio_service.dart';
import '../../domain/entities/game_config.dart';
import '../../domain/entities/game_session.dart';
import '../../domain/entities/player.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';
import 'game_screen.dart';

class SetupScreen extends StatefulWidget {
  final GameController controller;
  final GameSettingsController settingsController;
  final QuickButtonAudioService audioService;

  const SetupScreen({
    required this.controller,
    required this.settingsController,
    required this.audioService,
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

  void _onPlayerCountChanged(int value) {
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
      players.add(Player(id: 'player_${i}_$id', name: name));
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
            audioService: widget.audioService,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      OrchomToast.show(
        context: context,
        message: widget.controller.errorMessage ?? e.toString(),
        type: ToastType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: OrchomAppBar(title: 'Nouvelle partie'),
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrchomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OrchomSectionTitle(
                        title: 'Nombre de joueurs',
                        subtitle: 'Choisis entre 2 ou 4 joueurs',
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SegmentedButton<int>(
                        segments: const [
                          ButtonSegment(
                            value: 2,
                            label: Text('2 Joueurs'),
                            icon: Icon(Icons.people_rounded),
                          ),
                          ButtonSegment(
                            value: 4,
                            label: Text('4 Joueurs'),
                            icon: Icon(Icons.groups_rounded),
                          ),
                        ],
                        selected: {_playerCount},
                        onSelectionChanged: (value) =>
                            _onPlayerCountChanged(value.first),
                        style: SegmentedButton.styleFrom(
                          selectedBackgroundColor: isDark
                              ? AppColors.primaryDark.withValues(alpha: 0.2)
                              : AppColors.primary.withValues(alpha: 0.15),
                          selectedForegroundColor: isDark
                              ? AppColors.primaryDark
                              : AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                OrchomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OrchomSectionTitle(
                        title: 'Noms des joueurs',
                        subtitle: 'Donne un nom à chaque participant',
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ...List.generate(_playerCount, (i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: OrchomTextField(
                            controller: _nameControllers[i],
                            label: 'Joueur ${i + 1}',
                            hint: 'Entrer le nom du joueur ${i + 1}',
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            prefixIcon: Icon(
                              Icons.person_rounded,
                              size: 20,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
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
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                OrchomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OrchomSectionTitle(
                        title: 'Score cible',
                        subtitle: 'Le score à atteindre pour gagner',
                      ),
                      const SizedBox(height: AppSpacing.md),
                      OrchomTextField(
                        controller: _targetScoreController,
                        label: 'Score cible',
                        hint: 'Entre 1 et 10000',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        prefixIcon: Icon(
                          Icons.flag_rounded,
                          size: 20,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                        validator: (value) {
                          final n = int.tryParse(value ?? '');
                          if (n == null || n < 1 || n > 10000) {
                            return 'Entre 1 et 10000';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),
                OrchomButton(
                  label: 'Lancer la partie',
                  icon: Icons.play_arrow_rounded,
                  onPressed: _startGame,
                  height: 56,
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
