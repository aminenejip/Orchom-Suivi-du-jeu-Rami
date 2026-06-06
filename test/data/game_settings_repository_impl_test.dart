import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:orchom/data/local/app_database.dart';
import 'package:orchom/data/repositories/game_settings_repository_impl.dart';
import 'package:orchom/domain/entities/game_settings.dart';
import 'package:orchom/domain/entities/quick_score_button.dart';
import 'package:orchom/domain/enums/starter_mode.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late AppDatabase appDatabase;
  late GameSettingsRepositoryImpl repository;

  setUp(() {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    appDatabase = AppDatabase(databaseName: 'test_settings_$timestamp.db');
    repository = GameSettingsRepositoryImpl(appDatabase);
  });

  tearDown(() async {
    await appDatabase.close();
  });

  group('GameSettingsRepository', () {
    test('getSettings returns default settings when nothing is saved', () async {
      final settings = await repository.getSettings();

      expect(settings.quickScoreButtons, hasLength(4));
      expect(settings.quickScoreButtons[0].label, '-10');
      expect(settings.defaultGhaltaPenalty, 50);
      expect(settings.defaultStarterMode, StarterMode.rotation);
    });

    test('saveSettings and getSettings roundtrip', () async {
      final custom = GameSettings(
        quickScoreButtons: [
          QuickScoreButton(id: 'qs_c1', label: 'Test', value: 99),
        ],
        defaultGhaltaPenalty: 200,
        defaultStarterMode: StarterMode.random,
      );

      await repository.saveSettings(custom);
      final restored = await repository.getSettings();

      expect(restored.quickScoreButtons, hasLength(1));
      expect(restored.quickScoreButtons[0].label, 'Test');
      expect(restored.quickScoreButtons[0].value, 99);
      expect(restored.defaultGhaltaPenalty, 200);
      expect(restored.defaultStarterMode, StarterMode.random);
    });

    test('resetSettings resets to defaults', () async {
      final custom = GameSettings(
        quickScoreButtons: [
          QuickScoreButton(id: 'qs_c1', label: 'Custom', value: 10),
        ],
        defaultGhaltaPenalty: 200,
        defaultStarterMode: StarterMode.random,
      );
      await repository.saveSettings(custom);

      await repository.resetSettings();
      final restored = await repository.getSettings();

      expect(restored.quickScoreButtons, hasLength(4));
      expect(restored.quickScoreButtons[0].label, '-10');
      expect(restored.defaultGhaltaPenalty, 50);
      expect(restored.defaultStarterMode, StarterMode.rotation);
    });
  });
}
