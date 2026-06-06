import '../entities/game_settings.dart';

abstract class GameSettingsRepository {
  Future<GameSettings> getSettings();
  Future<void> saveSettings(GameSettings settings);
  Future<void> resetSettings();
}
