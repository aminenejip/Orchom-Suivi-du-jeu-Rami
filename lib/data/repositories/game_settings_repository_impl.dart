import 'dart:convert';
import 'package:sqflite/sqflite.dart' show ConflictAlgorithm;
import '../../domain/entities/game_settings.dart';
import '../../domain/repositories/game_settings_repository.dart';
import '../local/app_database.dart';

class GameSettingsRepositoryImpl implements GameSettingsRepository {
  final AppDatabase _appDatabase;

  GameSettingsRepositoryImpl(this._appDatabase);

  @override
  Future<GameSettings> getSettings() async {
    final db = await _appDatabase.database;
    final rows = await db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: ['game_settings'],
    );
    if (rows.isEmpty) return GameSettings.defaultSettings();
    final json = jsonDecode(rows.first['value_json'] as String)
        as Map<String, dynamic>;
    return GameSettings.fromJson(json);
  }

  @override
  Future<void> saveSettings(GameSettings settings) async {
    final db = await _appDatabase.database;
    await db.insert(
      'app_settings',
      {
        'key': 'game_settings',
        'value_json': jsonEncode(settings.toJson()),
        'updated_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> resetSettings() async {
    await saveSettings(GameSettings.defaultSettings());
  }
}
