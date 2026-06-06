import 'package:flutter/material.dart';
import '../../application/game_controller.dart';
import '../../application/game_settings_controller.dart';
import '../../application/theme_controller.dart';
import '../../data/local/quick_button_audio_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/orchom_button.dart';
import 'setup_screen.dart';
import 'game_screen.dart';
import 'history_screen.dart';
import 'game_settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final GameController controller;
  final GameSettingsController settingsController;
  final ThemeController themeController;
  final QuickButtonAudioService audioService;

  const HomeScreen({
    required this.controller,
    required this.settingsController,
    required this.themeController,
    required this.audioService,
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasActiveSession = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
    _load();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) {
      setState(() {
        _hasActiveSession = widget.controller.currentSession != null;
      });
    }
  }

  Future<void> _load() async {
    await widget.controller.loadActiveSession();
    if (mounted) {
      setState(() {
        _hasActiveSession = widget.controller.currentSession != null;
      });
    }
  }

  Future<void> _navigateToSetup() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SetupScreen(
          controller: widget.controller,
          settingsController: widget.settingsController,
          audioService: widget.audioService,
        ),
      ),
    );
    await _load();
  }

  Future<void> _navigateToGame() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          controller: widget.controller,
          settingsController: widget.settingsController,
          audioService: widget.audioService,
        ),
      ),
    );
    await _load();
  }

  Future<void> _navigateToHistory() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HistoryScreen(controller: widget.controller),
      ),
    );
    await _load();
  }

  Future<void> _navigateToSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameSettingsScreen(
          settingsController: widget.settingsController,
          audioService: widget.audioService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xl * 2),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.lg),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.lg),
                  child: Image.asset(
                    'assets/images/orchom_logo.png',
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Icon(
                      Icons.style,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Orchom',
                style: AppTextStyles.scoreDisplay.copyWith(
                  fontSize: 40,
                  height: 40 / 40,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Carnet de score Rami Tunisien',
                style: AppTextStyles.bodyMd.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(flex: 2),
              OrchomButton(
                label: 'Nouvelle partie',
                icon: Icons.add_circle_outline,
                onPressed: _navigateToSetup,
              ),
              const SizedBox(height: AppSpacing.sm),
              if (_hasActiveSession)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: OrchomButton(
                    label: 'Reprendre partie',
                    icon: Icons.play_circle_outline,
                    onPressed: _navigateToGame,
                  ),
                ),
              OrchomButton(
                label: 'Historique',
                icon: Icons.history,
                onPressed: _navigateToHistory,
              ),
              const SizedBox(height: AppSpacing.sm),
              OrchomButton(
                label: 'Réglage',
                icon: Icons.tune,
                onPressed: _navigateToSettings,
              ),
           
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
