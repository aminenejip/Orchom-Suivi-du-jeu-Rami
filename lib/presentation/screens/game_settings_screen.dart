import 'package:flutter/material.dart';
import '../../application/game_settings_controller.dart';
import '../../data/local/quick_button_audio_service.dart';
import '../../domain/entities/quick_button_sound_option.dart';
import '../../domain/enums/app_theme_mode.dart';
import '../../domain/enums/starter_mode.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';

class GameSettingsScreen extends StatefulWidget {
  final GameSettingsController settingsController;
  final QuickButtonAudioService audioService;

  const GameSettingsScreen({
    required this.settingsController,
    required this.audioService,
    super.key,
  });

  @override
  State<GameSettingsScreen> createState() => _GameSettingsScreenState();
}

class _GameSettingsScreenState extends State<GameSettingsScreen> {
  final _labelController = TextEditingController();
  final _valueController = TextEditingController(text: '0');

  @override
  void initState() {
    super.initState();
    widget.settingsController.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.settingsController.removeListener(_onChanged);
    _labelController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _addButton() async {
    final label = _labelController.text.trim();
    final value = int.tryParse(_valueController.text) ?? 0;

    try {
      await widget.settingsController.addQuickScoreButton(label, value);
      if (!mounted) return;
      _labelController.clear();
      _valueController.text = '0';
      OrchomToast.show(
        context: context,
        message: 'Bouton ajouté',
        type: ToastType.success,
      );
    } catch (e) {
      if (!mounted) return;
      OrchomToast.show(
        context: context,
        message: widget.settingsController.errorMessage ?? 'Erreur',
        type: ToastType.error,
      );
    }
  }

  Future<void> _deleteButton(String id) async {
    final confirm = await OrchomDialog.confirm(
      context: context,
      title: 'Supprimer',
      message: 'Supprimer ce bouton rapide ?',
      isDestructive: true,
    );
    if (confirm != true) return;

    try {
      await widget.settingsController.deleteQuickScoreButton(id);
      if (!mounted) return;
      OrchomToast.show(
        context: context,
        message: 'Bouton supprimé',
        type: ToastType.success,
      );
    } catch (e) {
      if (!mounted) return;
      OrchomToast.show(
        context: context,
        message: widget.settingsController.errorMessage ?? 'Erreur',
        type: ToastType.error,
      );
    }
  }

  Future<void> _resetToDefaults() async {
    final confirm = await OrchomDialog.confirm(
      context: context,
      title: 'Réinitialiser',
      message: 'Tous les réglages reviendront à leurs valeurs par défaut.',
      confirmLabel: 'Réinitialiser',
      isDestructive: true,
    );
    if (confirm != true) return;

    try {
      await widget.settingsController.resetSettings();
      if (!mounted) return;
      OrchomToast.show(
        context: context,
        message: 'Réglages réinitialisés',
        type: ToastType.success,
      );
    } catch (e) {
      if (!mounted) return;
      OrchomToast.show(
        context: context,
        message: widget.settingsController.errorMessage ?? 'Erreur',
        type: ToastType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = widget.settingsController.settings;
    final buttons = settings.quickScoreButtons;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: OrchomAppBar(title: 'Réglages'),
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
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            _buildSection('Apparence', 'Personnalise l\'apparence de l\'application'),
            const SizedBox(height: AppSpacing.md),
            _ThemeModeSelector(
              value: settings.appThemeMode,
              onChanged: (mode) {
                widget.settingsController.updateAppThemeMode(mode);
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            Divider(
              color: isDark ? AppColors.darkOutline.withValues(alpha: 0.5) : AppColors.lightOutline,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildSection('Partie', 'Configuration par défaut des parties'),
            const SizedBox(height: AppSpacing.md),
            OrchomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: (isDark ? AppColors.primaryDark : AppColors.primary)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.swap_horiz_rounded,
                          size: 18,
                          color: isDark ? AppColors.primaryDark : AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Mode donneur par défaut',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<StarterMode>(
                    initialValue: settings.defaultStarterMode,
                    items: StarterMode.values.map((mode) {
                      return DropdownMenuItem(
                        value: mode,
                        child: Text(_starterModeLabel(mode)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        widget.settingsController.updateDefaultStarterMode(value);
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Divider(
              color: isDark ? AppColors.darkOutline.withValues(alpha: 0.5) : AppColors.lightOutline,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildSection('Boutons rapides', 'Personnalise les boutons de score rapide'),
            const SizedBox(height: AppSpacing.md),
            if (buttons.isEmpty)
              OrchomEmptyState(
                icon: Icons.speed_rounded,
                title: 'Aucun bouton configuré',
                subtitle: 'Ajoutez vos boutons de score rapide',
              ),
            ...buttons.map((button) {
              return OrchomCard(
                margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                button.label,
                                style: AppTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Valeur: ${button.value}',
                                style: AppTextStyles.bodySm.copyWith(
                                  color: isDark
                                      ? AppColors.darkTextMuted
                                      : AppColors.lightTextMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete_rounded,
                            color: AppColors.scoreDanger,
                          ),
                          onPressed: () => _deleteButton(button.id),
                          splashRadius: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: button.soundId,
                            items:
                                QuickButtonSoundOption.availableSounds.map((s) {
                              return DropdownMenuItem(
                                value: s.id,
                                child: Text(s.label),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                widget.settingsController.updateQuickButtonSound(
                                  buttonId: button.id,
                                  soundId: value,
                                );
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Son',
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
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
                        IconButton(
                          icon: Icon(
                            Icons.play_circle_outline_rounded,
                            color: isDark
                                ? AppColors.primaryDark
                                : AppColors.primary,
                          ),
                          tooltip: 'Écouter',
                          onPressed: () async {
                            if (button.soundId == 'none') {
                              OrchomToast.show(
                                context: context,
                                message: 'Aucun son sélectionné',
                                type: ToastType.warning,
                              );
                            } else {
                              await widget.audioService
                                  .previewSound(button.soundId);
                            }
                          },
                          splashRadius: 18,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: AppSpacing.lg),
            Divider(
              color: isDark ? AppColors.darkOutline.withValues(alpha: 0.5) : AppColors.lightOutline,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildSection('Ajouter un bouton', 'Crée un bouton de score rapide'),
            const SizedBox(height: AppSpacing.md),
            OrchomCard(
              child: Column(
                children: [
                  OrchomTextField(
                    controller: _labelController,
                    label: 'Label du bouton',
                    hint: 'Ex: Kmalt',
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  OrchomTextField(
                    controller: _valueController,
                    label: 'Valeur du bouton',
                    hint: 'Ex: -10 ou 50',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  OrchomButton(
                    label: 'Ajouter le bouton',
                    icon: Icons.add_rounded,
                    onPressed: _addButton,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            OrchomButton(
              label: 'Réinitialiser les réglages',
              icon: Icons.restart_alt_rounded,
              variant: ButtonVariant.outline,
              onPressed: _resetToDefaults,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.displaySm.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: AppTextStyles.bodySm.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  String _starterModeLabel(StarterMode mode) {
    switch (mode) {
      case StarterMode.rotation:
        return 'Rotation';
      case StarterMode.random:
        return 'Aléatoire';
      case StarterMode.manual:
        return 'Manuel';
    }
  }
}

class _ThemeModeSelector extends StatelessWidget {
  final AppThemeMode value;
  final ValueChanged<AppThemeMode> onChanged;

  const _ThemeModeSelector({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.primaryDark : AppColors.primary;

    return OrchomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ThemeOption(
            icon: Icons.light_mode_rounded,
            title: 'Clair',
            subtitle: 'Thème clair',
            selected: value == AppThemeMode.light,
            primaryColor: primaryColor,
            onTap: () => onChanged(AppThemeMode.light),
          ),
          Divider(
            height: 1,
            indent: 56,
            color: isDark ? AppColors.darkOutline.withValues(alpha: 0.3) : AppColors.lightOutline.withValues(alpha: 0.3),
          ),
          _ThemeOption(
            icon: Icons.dark_mode_rounded,
            title: 'Sombre',
            subtitle: 'Thème sombre',
            selected: value == AppThemeMode.dark,
            primaryColor: primaryColor,
            onTap: () => onChanged(AppThemeMode.dark),
          ),
          Divider(
            height: 1,
            indent: 56,
            color: isDark ? AppColors.darkOutline.withValues(alpha: 0.3) : AppColors.lightOutline.withValues(alpha: 0.3),
          ),
          _ThemeOption(
            icon: Icons.settings_brightness_rounded,
            title: 'Système',
            subtitle: 'Suivre le système',
            selected: value == AppThemeMode.system,
            primaryColor: primaryColor,
            onTap: () => onChanged(AppThemeMode.system),
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final Color primaryColor;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: selected ? primaryColor.withValues(alpha: 0.1) : Colors.transparent,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd - 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd - 4),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: selected
                      ? primaryColor.withValues(alpha: 0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: selected ? primaryColor : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                        color: selected
                            ? primaryColor
                            : (isDark ? AppColors.darkText : AppColors.lightText),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySm.copyWith(
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: primaryColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
