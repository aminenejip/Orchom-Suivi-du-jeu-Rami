import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../application/game_controller.dart';
import '../../application/game_settings_controller.dart';
import '../../application/theme_controller.dart';
import '../../data/local/quick_button_audio_service.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';
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

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _hasActiveSession = false;
  late AnimationController _entranceController;
  late List<Animation<double>> _staggeredAnimations;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _staggeredAnimations = List.generate(6, (i) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _entranceController,
          curve: Interval(
            0.1 + i * 0.1,
            0.5 + i * 0.1,
            curve: Curves.easeOutCubic,
          ),
        ),
      );
    });
    _load();
    _entranceController.forward();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    _entranceController.dispose();
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppColors.gradientStartDark, AppColors.gradientEndDark]
                : [AppColors.gradientStartLight, AppColors.gradientEndLight],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: -size.width * 0.35,
                right: -size.width * 0.2,
                child: Transform.rotate(
                  angle: -math.pi / 6,
                  child: Container(
                    width: size.width * 0.65,
                    height: size.width * 0.65,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.04),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -size.width * 0.2,
                left: -size.width * 0.15,
                child: Container(
                  width: size.width * 0.55,
                  height: size.width * 0.55,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.gold.withValues(alpha: 0.04),
                  ),
                ),
              ),
              Positioned(
                top: size.height * 0.4,
                right: -size.width * 0.15,
                child: Container(
                  width: size.width * 0.4,
                  height: size.width * 0.4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.tertiary.withValues(alpha: 0.03),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.xxxl + 8),
                    _buildLogo(isDark),
                    const SizedBox(height: AppSpacing.xs),
                    _buildSubtitle(),
                    const Spacer(flex: 2),
                    ..._buildMenuButtons(),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(bool isDark) {
    return AnimatedBuilder(
      animation: _staggeredAnimations[0],
      builder: (context, _) => Opacity(
        opacity: _staggeredAnimations[0].value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - _staggeredAnimations[0].value)),
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.2),
                  AppColors.gold.withValues(alpha: 0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.25),
              ),
              boxShadow: isDark ? AppShadows.glassDark : AppShadows.glassLight,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl - 1),
              child: Image.asset(
                'assets/images/orchom_logo.png',
                width: 88,
                height: 88,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Icon(
                  Icons.style_rounded,
                  size: 44,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _staggeredAnimations[1],
          builder: (context, _) => Opacity(
            opacity: _staggeredAnimations[1].value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - _staggeredAnimations[1].value)),
              child: Text(
                'Orchom',
                style: AppTextStyles.displayXL.copyWith(
                  color: AppColors.primary,
                  fontFamily: AppTextStyles.displayFont,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        AnimatedBuilder(
          animation: _staggeredAnimations[2],
          builder: (context, _) => Opacity(
            opacity: _staggeredAnimations[2].value,
            child: Text(
              'Carnet de score Rami Tunisien',
              style: AppTextStyles.body.copyWith(
                color: AppColors.darkTextMuted,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildMenuButtons() {
    final buttons = <Widget>[
      _buildMenuItem(
        index: 2,
        label: 'Nouvelle partie',
        icon: Icons.add_circle_rounded,
        color: AppColors.primary,
        onPressed: _navigateToSetup,
        variant: ButtonVariant.primary,
      ),
    ];

    if (_hasActiveSession) {
      buttons.add(
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: _buildMenuItem(
            index: 3,
            label: 'Reprendre la partie',
            icon: Icons.play_circle_rounded,
            color: AppColors.gold,
            onPressed: _navigateToGame,
            variant: ButtonVariant.secondary,
          ),
        ),
      );
    }

    buttons.addAll([
      _buildMenuItem(
        index: 4,
        label: 'Historique',
        icon: Icons.history_rounded,
        color: AppColors.primary,
        onPressed: _navigateToHistory,
        variant: ButtonVariant.glass,
      ),
      _buildMenuItem(
        index: 5,
        label: 'Réglages',
        icon: Icons.tune_rounded,
        color: AppColors.tertiary,
        onPressed: _navigateToSettings,
        variant: ButtonVariant.glass,
      ),
    ]);

    return buttons;
  }

  Widget _buildMenuItem({
    required int index,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required ButtonVariant variant,
  }) {
    return AnimatedBuilder(
      animation: _staggeredAnimations[index],
      builder: (context, _) => Opacity(
        opacity: _staggeredAnimations[index].value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - _staggeredAnimations[index].value)),
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: variant == ButtonVariant.glass
                ? _buildGlassMenuItem(label, icon, color, onPressed)
                : OrchomButton(
                    label: label,
                    icon: icon,
                    onPressed: onPressed,
                    height: 56,
                    variant: variant,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassMenuItem(
      String label, IconData icon, Color accent, VoidCallback onPressed) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: isDark ? AppColors.glassDark : AppColors.glassWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: isDark ? AppColors.glassStrokeDark : AppColors.glassStroke,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          splashColor: accent.withValues(alpha: 0.1),
          highlightColor: accent.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 20, color: accent),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.button.copyWith(
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
