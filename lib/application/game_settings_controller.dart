import 'package:flutter/foundation.dart';
import '../domain/entities/game_settings.dart';
import '../domain/entities/quick_button_sound_option.dart';
import '../domain/entities/quick_score_button.dart';
import '../domain/enums/app_theme_mode.dart';
import '../domain/enums/starter_mode.dart';
import '../domain/repositories/game_settings_repository.dart';

class GameSettingsController extends ChangeNotifier {
  final GameSettingsRepository repository;

  GameSettings _settings = GameSettings.defaultSettings();
  bool _isLoading = false;
  String? _errorMessage;

  GameSettingsController({required this.repository});

  GameSettings get settings => _settings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> loadSettings() async {
    _setLoading(true);
    try {
      _settings = await repository.getSettings();
      _setError(null);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> saveSettings(GameSettings settings) async {
    _setLoading(true);
    try {
      _settings = settings;
      await repository.saveSettings(settings);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resetSettings() async {
    _setLoading(true);
    try {
      _settings = GameSettings.defaultSettings();
      await repository.saveSettings(_settings);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addQuickScoreButton(String label, int value) async {
    if (label.trim().isEmpty) {
      final error = 'Le label ne peut pas être vide';
      _setError(error);
      throw ArgumentError(error);
    }
    final normalized = label.trim().toLowerCase();
    if (_settings.quickScoreButtons
        .any((b) => b.label.trim().toLowerCase() == normalized)) {
      final error = 'Un bouton avec le label "$label" existe déjà';
      _setError(error);
      throw ArgumentError(error);
    }

    final id = 'qs_${DateTime.now().millisecondsSinceEpoch}';
    final button = QuickScoreButton(
      id: id,
      label: label.trim(),
      value: value,
    );

    final updated = GameSettings(
      quickScoreButtons: [..._settings.quickScoreButtons, button],
      defaultGhaltaPenalty: _settings.defaultGhaltaPenalty,
      defaultStarterMode: _settings.defaultStarterMode,
      appThemeMode: _settings.appThemeMode,
    );
    await saveSettings(updated);
  }

  Future<void> updateQuickScoreButton(QuickScoreButton button) async {
    final updated = GameSettings(
      quickScoreButtons: _settings.quickScoreButtons.map((b) {
        return b.id == button.id ? button : b;
      }).toList(),
      defaultGhaltaPenalty: _settings.defaultGhaltaPenalty,
      defaultStarterMode: _settings.defaultStarterMode,
      appThemeMode: _settings.appThemeMode,
    );
    await saveSettings(updated);
  }

  Future<void> updateQuickButtonSound({
    required String buttonId,
    required String soundId,
  }) async {
    final sound = QuickButtonSoundOption.findById(soundId);
    if (sound == null) {
      final error = 'Son "$soundId" invalide';
      _setError(error);
      throw ArgumentError(error);
    }

    final index = _settings.quickScoreButtons.indexWhere((b) => b.id == buttonId);
    if (index == -1) {
      final error = 'Bouton "$buttonId" introuvable';
      _setError(error);
      throw ArgumentError(error);
    }

    final updatedButtons = _settings.quickScoreButtons.map((b) {
      return b.id == buttonId ? b.copyWith(soundId: soundId) : b;
    }).toList();

    final updated = GameSettings(
      quickScoreButtons: updatedButtons,
      defaultGhaltaPenalty: _settings.defaultGhaltaPenalty,
      defaultStarterMode: _settings.defaultStarterMode,
      appThemeMode: _settings.appThemeMode,
    );
    await saveSettings(updated);
  }

  Future<void> deleteQuickScoreButton(String id) async {
    final updated = GameSettings(
      quickScoreButtons: _settings.quickScoreButtons
          .where((b) => b.id != id)
          .toList(),
      defaultGhaltaPenalty: _settings.defaultGhaltaPenalty,
      defaultStarterMode: _settings.defaultStarterMode,
      appThemeMode: _settings.appThemeMode,
    );
    await saveSettings(updated);
  }

  Future<void> updateDefaultStarterMode(StarterMode mode) async {
    final updated = GameSettings(
      quickScoreButtons: _settings.quickScoreButtons,
      defaultGhaltaPenalty: _settings.defaultGhaltaPenalty,
      defaultStarterMode: mode,
      appThemeMode: _settings.appThemeMode,
    );
    await saveSettings(updated);
  }

  Future<void> updateAppThemeMode(AppThemeMode mode) async {
    final updated = GameSettings(
      quickScoreButtons: _settings.quickScoreButtons,
      defaultGhaltaPenalty: _settings.defaultGhaltaPenalty,
      defaultStarterMode: _settings.defaultStarterMode,
      appThemeMode: mode,
    );
    await saveSettings(updated);
  }
}
