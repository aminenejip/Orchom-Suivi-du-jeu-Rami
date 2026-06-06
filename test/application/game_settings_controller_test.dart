import 'package:flutter_test/flutter_test.dart';
import 'package:orchom/application/game_settings_controller.dart';
import 'package:orchom/data/local/app_database.dart';
import 'package:orchom/data/repositories/game_settings_repository_impl.dart';
import 'package:orchom/domain/enums/app_theme_mode.dart';
import 'package:orchom/domain/enums/starter_mode.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late AppDatabase appDatabase;
  late GameSettingsController controller;

  setUp(() {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    appDatabase = AppDatabase(databaseName: 'test_contr_$timestamp.db');
    final repository = GameSettingsRepositoryImpl(appDatabase);
    controller = GameSettingsController(repository: repository);
  });

  tearDown(() async {
    await appDatabase.close();
  });

  group('GameSettingsController', () {
    test('loadSettings returns defaults initially', () async {
      await controller.loadSettings();

      expect(controller.settings.quickScoreButtons, hasLength(4));
      expect(controller.settings.defaultGhaltaPenalty, 50);
      expect(controller.settings.defaultStarterMode, StarterMode.rotation);
      expect(controller.settings.appThemeMode, AppThemeMode.dark);
      expect(controller.errorMessage, isNull);
    });

    test('addQuickScoreButton adds a button and preserves other settings', () async {
      await controller.loadSettings();
      final initialCount = controller.settings.quickScoreButtons.length;

      await controller.addQuickScoreButton('Custom', 99);

      expect(controller.settings.quickScoreButtons, hasLength(initialCount + 1));
      expect(
        controller.settings.quickScoreButtons.last.label,
        'Custom',
      );
      expect(controller.settings.defaultGhaltaPenalty, 50);
    });

    test('addQuickScoreButton refuses empty label', () async {
      await controller.loadSettings();

      expect(
        () => controller.addQuickScoreButton('  ', 10),
        throwsArgumentError,
      );
      expect(controller.errorMessage, isNotNull);
    });

    test('addQuickScoreButton refuses duplicate label', () async {
      await controller.loadSettings();

      await controller.addQuickScoreButton('Custom', 10);

      expect(
        () => controller.addQuickScoreButton('Custom', 20),
        throwsArgumentError,
      );
      expect(controller.errorMessage, isNotNull);
    });

    test('deleteQuickScoreButton removes a button', () async {
      await controller.loadSettings();
      await controller.addQuickScoreButton('MyButton', 5);
      final addedId = controller.settings.quickScoreButtons.last.id;

      await controller.deleteQuickScoreButton(addedId);

      expect(
        controller.settings.quickScoreButtons.any((b) => b.id == addedId),
        isFalse,
      );
    });

    test('resetSettings resets to defaults', () async {
      await controller.loadSettings();
      await controller.addQuickScoreButton('Extra', 1);

      await controller.resetSettings();

      expect(controller.settings.quickScoreButtons, hasLength(4));
      expect(controller.settings.quickScoreButtons[0].label, '-10');
      expect(controller.settings.defaultGhaltaPenalty, 50);
      expect(controller.settings.defaultStarterMode, StarterMode.rotation);
      expect(controller.settings.appThemeMode, AppThemeMode.dark);
    });

    test('updateDefaultStarterMode updates the starter mode', () async {
      await controller.loadSettings();

      await controller.updateDefaultStarterMode(StarterMode.random);

      expect(controller.settings.defaultStarterMode, StarterMode.random);
    });

    test('updateAppThemeMode updates to light', () async {
      await controller.loadSettings();

      await controller.updateAppThemeMode(AppThemeMode.light);

      expect(controller.settings.appThemeMode, AppThemeMode.light);
    });

    test('updateAppThemeMode updates to system', () async {
      await controller.loadSettings();

      await controller.updateAppThemeMode(AppThemeMode.system);

      expect(controller.settings.appThemeMode, AppThemeMode.system);
    });

    test('updateAppThemeMode preserves other settings', () async {
      await controller.loadSettings();
      await controller.addQuickScoreButton('Extra', 5);
      final buttonCount = controller.settings.quickScoreButtons.length;

      await controller.updateAppThemeMode(AppThemeMode.light);

      expect(controller.settings.quickScoreButtons, hasLength(buttonCount));
      expect(controller.settings.defaultGhaltaPenalty, 50);
      expect(controller.settings.defaultStarterMode, StarterMode.rotation);
    });

    test('updateAppThemeMode saves automatically', () async {
      await controller.loadSettings();
      await controller.updateAppThemeMode(AppThemeMode.light);

      await controller.loadSettings();

      expect(controller.settings.appThemeMode, AppThemeMode.light);
    });

    test('updateQuickButtonSound modifies the sound of a button', () async {
      await controller.loadSettings();
      final button = controller.settings.quickScoreButtons.first;

      await controller.updateQuickButtonSound(
        buttonId: button.id,
        soundId: 'sound_01',
      );

      final updated = controller.settings.quickScoreButtons
          .firstWhere((b) => b.id == button.id);
      expect(updated.soundId, 'sound_01');
    });

    test('updateQuickButtonSound saves automatically', () async {
      await controller.loadSettings();
      final button = controller.settings.quickScoreButtons.first;

      await controller.updateQuickButtonSound(
        buttonId: button.id,
        soundId: 'sound_02',
      );

      await controller.loadSettings();

      final updated = controller.settings.quickScoreButtons
          .firstWhere((b) => b.id == button.id);
      expect(updated.soundId, 'sound_02');
    });

    test('updateQuickButtonSound refuses unknown buttonId', () async {
      await controller.loadSettings();

      expect(
        () => controller.updateQuickButtonSound(
          buttonId: 'nonexistent',
          soundId: 'sound_01',
        ),
        throwsArgumentError,
      );
      expect(controller.errorMessage, contains('introuvable'));
    });

    test('updateQuickButtonSound refuses invalid soundId', () async {
      await controller.loadSettings();
      final button = controller.settings.quickScoreButtons.first;

      expect(
        () => controller.updateQuickButtonSound(
          buttonId: button.id,
          soundId: 'invalid_sound',
        ),
        throwsArgumentError,
      );
      expect(controller.errorMessage, contains('invalide'));
    });
  });
}
