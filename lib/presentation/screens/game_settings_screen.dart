import 'package:flutter/material.dart';
import '../../application/game_settings_controller.dart';
import '../../data/local/quick_button_audio_service.dart';
import '../../domain/entities/quick_button_sound_option.dart';
import '../../domain/enums/app_theme_mode.dart';
import '../../domain/enums/starter_mode.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/orchom_section_title.dart';

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
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.settingsController.errorMessage ?? e.toString(),
          ),
        ),
      );
    }
  }

  Future<void> _deleteButton(String id) async {
    try {
      await widget.settingsController.deleteQuickScoreButton(id);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.settingsController.errorMessage ?? e.toString(),
          ),
        ),
      );
    }
  }

  Future<void> _resetToDefaults() async {
    try {
      await widget.settingsController.resetSettings();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.settingsController.errorMessage ?? e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = widget.settingsController.settings;
    final buttons = settings.quickScoreButtons;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Réglage'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          OrchomSectionTitle(title: 'Apparence'),
          const SizedBox(height: AppSpacing.sm),
          _ThemeModeSelector(
            value: settings.appThemeMode,
            onChanged: (mode) {
              widget.settingsController.updateAppThemeMode(mode);
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(),
          const SizedBox(height: AppSpacing.md),
          OrchomSectionTitle(title: 'Partie'),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Mode donneur par défaut',
            style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: AppSpacing.sm),
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
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(),
          const SizedBox(height: AppSpacing.md),
          OrchomSectionTitle(title: 'Boutons rapides'),
          const SizedBox(height: AppSpacing.sm),
          if (buttons.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text('Aucun bouton configuré'),
            ),
          ...buttons.map((button) {
            return Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.xs),
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cardShadowColor.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
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
                              style: AppTextStyles.bodyMd.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Valeur: ${button.value}',
                              style: AppTextStyles.bodyMd.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteButton(button.id),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
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
                              widget.settingsController
                                  .updateQuickButtonSound(
                                buttonId: button.id,
                                soundId: value,
                              );
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'Son',
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      IconButton(
                        icon: const Icon(Icons.play_circle_outline),
                        tooltip: 'Écouter',
                        onPressed: () async {
                          if (button.soundId == 'none') {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Aucun son sélectionné'),
                              ),
                            );
                          } else {
                            await widget.audioService
                                .previewSound(button.soundId);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: AppSpacing.md),
          const Divider(),
          const SizedBox(height: AppSpacing.md),
          OrchomSectionTitle(title: 'Ajouter un bouton'),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _labelController,
            decoration: const InputDecoration(
              labelText: 'Label du bouton',
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _valueController,
            decoration: const InputDecoration(
              labelText: 'Valeur du bouton',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _addButton,
              child: const Text('Ajouter'),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _resetToDefaults,
              child: const Text('Réinitialiser par défaut'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ThemeOption(
          icon: Icons.light_mode,
          title: 'Clair',
          selected: value == AppThemeMode.light,
          onTap: () => onChanged(AppThemeMode.light),
        ),
        const SizedBox(height: AppSpacing.xs),
        _ThemeOption(
          icon: Icons.dark_mode,
          title: 'Sombre',
          selected: value == AppThemeMode.dark,
          onTap: () => onChanged(AppThemeMode.dark),
        ),
        const SizedBox(height: AppSpacing.xs),
        _ThemeOption(
          icon: Icons.settings_brightness,
          title: 'Système',
          selected: value == AppThemeMode.system,
          onTap: () => onChanged(AppThemeMode.system),
        ),
      ],
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: AppTextStyles.bodyMd.copyWith(
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
              ),
              const Spacer(),
              if (selected)
                Icon(
                  Icons.check_circle,
                  size: 22,
                  color: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
