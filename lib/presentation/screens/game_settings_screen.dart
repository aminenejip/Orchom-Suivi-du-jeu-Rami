import 'package:flutter/material.dart';
import '../../application/game_settings_controller.dart';
import '../../domain/enums/starter_mode.dart';

class GameSettingsScreen extends StatefulWidget {
  final GameSettingsController settingsController;

  const GameSettingsScreen({required this.settingsController, super.key});

  @override
  State<GameSettingsScreen> createState() => _GameSettingsScreenState();
}

class _GameSettingsScreenState extends State<GameSettingsScreen> {
  final _labelController = TextEditingController();
  final _valueController = TextEditingController(text: '0');
  late TextEditingController _ghaltaController;

  @override
  void initState() {
    super.initState();
    widget.settingsController.addListener(_onChanged);
    _ghaltaController = TextEditingController(
      text: widget.settingsController.settings.defaultGhaltaPenalty.toString(),
    );
  }

  @override
  void dispose() {
    widget.settingsController.removeListener(_onChanged);
    _labelController.dispose();
    _valueController.dispose();
    _ghaltaController.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (mounted) {
      setState(() {
        _ghaltaController.text = widget
            .settingsController.settings.defaultGhaltaPenalty
            .toString();
      });
    }
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

  Future<void> _saveGhaltaPenalty() async {
    final value = int.tryParse(_ghaltaController.text);
    if (value == null || value <= 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La pénalité doit être un nombre > 0')),
      );
      return;
    }
    try {
      await widget.settingsController.updateDefaultGhaltaPenalty(value);
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
        title: const Text('Réglage des parties'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Paramètres de partie',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _ghaltaController,
            decoration: const InputDecoration(
              labelText: 'Pénalité Ghalta par défaut',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveGhaltaPenalty,
              child: const Text('Sauvegarder la pénalité'),
            ),
          ),
          const SizedBox(height: 12),
          Text('Mode donneur par défaut'),
          const SizedBox(height: 8),
          DropdownButton<StarterMode>(
            value: settings.defaultStarterMode,
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
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 8),
          Text(
            'Boutons rapides de score',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (buttons.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text('Aucun bouton configuré'),
            ),
          ...buttons.map((button) {
            return Card(
              child: ListTile(
                title: Text(button.label),
                subtitle: Text(
                  'Valeur: ${button.value}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteButton(button.id),
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          TextFormField(
            controller: _labelController,
            decoration: const InputDecoration(
              labelText: 'Label du bouton',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _valueController,
            decoration: const InputDecoration(
              labelText: 'Valeur du bouton',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _addButton,
              child: const Text('Ajouter'),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _resetToDefaults,
              child: const Text('Réinitialiser par défaut'),
            ),
          ),
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
